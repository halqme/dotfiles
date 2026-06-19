{...}: let
  onePasswordAgentSocket = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [
      "~/.orbstack/ssh/config"
    ];

    settings."*" = {
      Compression = false;
      ForwardAgent = false;
      HashKnownHosts = true;
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
      IdentityAgent = onePasswordAgentSocket;
    };
  };

  home.file.".ssh/config".force = true;
}
