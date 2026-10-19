{
  pkgs,
  repoRoot,
  homeConfigurations,
  home-manager,
  nix-index-database,
  nixpkgs,
}: let
  inherit (pkgs) lib;
  system = pkgs.stdenv.hostPlatform.system;
  mac = homeConfigurations."hal@MacBook-Pro.local".config;
  linux = homeConfigurations."ci@actions".config;
  native =
    if pkgs.stdenv.hostPlatform.isDarwin
    then mac
    else linux;

  mkHomes = homeDefinitions:
    import ../lib/mk-home-configurations.nix {
      inherit repoRoot homeDefinitions home-manager nix-index-database nixpkgs;
    };

  fixture = {
    inherit system;
    homeDirectory = "/home/alice";
    modules = [
      ../modules/common/base.nix
      ({
        hostname,
        repoRoot,
        ...
      }: {
        home.sessionVariables = {
          TEST_HOSTNAME = hostname;
          TEST_REPO_ROOT = toString repoRoot;
        };
      })
    ];
  };

  homes = mkHomes {
    "alice@workstation.example" = fixture;
    "bob@builder" =
      fixture
      // {
        homeDirectory = "/srv/bob";
        stateVersion = "25.11";
      };
  };

  identity = home: {
    inherit (home.config.home) username homeDirectory stateVersion;
    system = home.pkgs.stdenv.hostPlatform.system;
  };

  failures = lib.runTests {
    testNamesDefaultsAndOverrides = {
      expr = lib.mapAttrs (_: home:
        identity home
        // {
          hostname = home.config.home.sessionVariables.TEST_HOSTNAME;
          repoRoot = home.config.home.sessionVariables.TEST_REPO_ROOT;
        })
      homes;
      expected = {
        "alice@workstation.example" = {
          username = "alice";
          hostname = "workstation.example";
          homeDirectory = "/home/alice";
          stateVersion = "26.05";
          repoRoot = toString repoRoot;
          inherit system;
        };
        "bob@builder" = {
          username = "bob";
          hostname = "builder";
          homeDirectory = "/srv/bob";
          stateVersion = "25.11";
          repoRoot = toString repoRoot;
          inherit system;
        };
      };
    };

    testInvalidNamesAreRejected = {
      expr = map (name: let
        invalidHomes = mkHomes {${name} = fixture;};
      in
        (builtins.tryEval invalidHomes.${name}.config.home.username).success)
      ["" "alice" "@host" "alice@"];
      expected = [false false false false];
    };

    testExportedHostIdentities = {
      expr = lib.mapAttrs (_: identity) homeConfigurations;
      expected = {
        "hal@MacBook-Pro.local" = {
          username = "hal";
          homeDirectory = "/Users/hal";
          stateVersion = "26.05";
          system = "aarch64-darwin";
        };
        "ci@actions" = {
          username = "ci";
          homeDirectory = "/home/hal";
          stateVersion = "26.05";
          system = "x86_64-linux";
        };
      };
    };

    testHomeManagerAssertions = {
      expr = lib.mapAttrs (_: home:
        map (item: item.message)
        (builtins.filter (item: !item.assertion) home.config.assertions))
      homeConfigurations;
      expected = {
        "hal@MacBook-Pro.local" = [];
        "ci@actions" = [];
      };
    };

    testSharedProfile = {
      expr = map (config: {
        xdg = config.xdg.enable;
        homeManager = config.programs.home-manager.enable;
        git = config.programs.git.enable;
        requireGitIdentity = config.programs.git.settings.user.useConfigOnly;
        defaultBranch = config.programs.git.settings.init.defaultBranch;
        direnv = config.programs.direnv.enable;
        nixDirenv = config.programs.direnv.nix-direnv.enable;
        nixIndex = config.programs.nix-index.enable;
        direnvZshIntegration = config.programs.direnv.enableZshIntegration;
        nixIndexZshIntegration = config.programs.nix-index.enableZshIntegration;
      }) [mac linux];
      expected = lib.replicate 2 {
        xdg = true;
        homeManager = true;
        git = true;
        requireGitIdentity = true;
        defaultBranch = "main";
        direnv = true;
        nixDirenv = true;
        nixIndex = true;
        direnvZshIntegration = false;
        nixIndexZshIntegration = false;
      };
    };

    testMacSigningAndSsh = {
      expr = {
        signCommits = mac.programs.git.settings.commit.gpgsign;
        signingFormat = mac.programs.git.settings.gpg.format;
        signingKeyInHome =
          lib.hasPrefix
          "${mac.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/"
          mac.programs.git.settings.user.signingkey;
        allowedSigners = mac.programs.git.settings."gpg \"ssh\"".allowedSignersFile;
        ssh = mac.programs.ssh.enable;
        includes = mac.programs.ssh.includes;
        inherit (mac.programs.ssh.settings."*".data) ForwardAgent HashKnownHosts IdentityAgent;
      };
      expected = {
        signCommits = true;
        signingFormat = "ssh";
        signingKeyInHome = true;
        allowedSigners = "~/.ssh/allowed_signers";
        ssh = true;
        includes = ["~/.orbstack/ssh/config" "~/.ssh/local_config"];
        ForwardAgent = false;
        HashKnownHosts = true;
        IdentityAgent = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      };
    };

    testLinuxDoesNotRequireMacCredentials = {
      expr = {
        ssh = linux.programs.ssh.enable;
        signCommits = linux.programs.git.settings.commit.gpgsign or false;
        signingKey = linux.programs.git.settings.user.signingkey or null;
        identityAgent = linux.programs.ssh.settings."*".data.IdentityAgent or null;
      };
      expected = {
        ssh = false;
        signCommits = false;
        signingKey = null;
        identityAgent = null;
      };
    };
  };
in {
  configuration =
    builtins.seq (lib.debug.throwTestFailures {inherit failures;})
    (pkgs.runCommand "home-manager-configuration-tests" {} ''
      touch "$out"
    '');

  use-age = import ./use-age.nix {
    inherit pkgs;
    direnvrc = native.xdg.configFile."direnv/direnvrc".source;
  };
}
