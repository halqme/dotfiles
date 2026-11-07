# SSH鍵とGit署名

GitHubへのSSH認証とGit署名にはSecretiveを使用する。

```text
Secretive
  -> GitHub SSH Authentication
  -> Git Signing
```

macOSの署名設定は `config/git/darwin.gitconfig`、SSH設定は `config/ssh/config` で管理し、mise bootstrap がリンクする。

## 初回セットアップ

1. Secretiveを開き、GitHub用の鍵を作成する。
2. 同じ公開鍵をGitHubへAuthentication keyとSigning keyとして登録する。
3. Secretiveの公開鍵パスを `config/git/darwin.gitconfig` の `user.signingkey` に設定する。
4. mise bootstrap を適用する。
5. 公開鍵から `~/.ssh/allowed_signers` を作成する。

```bash
cd ~/.dotfiles
mise bootstrap --yes

key="$(git config --global --includes --get user.signingkey)"
key="${key/#\~/$HOME}"
printf '%s %s\n' "$(git config --global --includes --get user.email)" "$(cat "$key")" > ~/.ssh/allowed_signers
```

`config/git/darwin.gitconfig` は次の Git 設定を与える。

```ini
[user]
    signingkey = ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/<key>.pub
[commit]
    gpgsign = true
[gpg]
    format = ssh
[gpg "ssh"]
    allowedSignersFile = ~/.ssh/allowed_signers
```

SSH認証を確認する。

```bash
ssh -T git@github.com
```

Git署名を確認する。

```bash
git commit --allow-empty -m 'test signing'
git log --show-signature -1
```

## 新しいMacへの移行

1. mise をインストールする。
2. dotfilesをHTTPSでcloneする。
3. Secretiveで新しいGitHub用の鍵を作成する。
4. 同じ公開鍵をGitHubへAuthentication keyとSigning keyとして登録する。
5. `config/git/darwin.gitconfig` の `user.signingkey` を更新する。
6. mise bootstrap を適用し、`~/.ssh/allowed_signers` を作成する。
7. SSH認証とGit署名を確認する。

```text
mise をインストール
  -> dotfilesをHTTPSでclone
  -> Secretiveで鍵を生成
  -> GitHubへAuthentication keyとSigning keyとして登録
  -> config/git/darwin.gitconfig を更新
  -> mise bootstrap --yes
  -> ~/.ssh/allowed_signers を作成
  -> SSH認証とGit署名を確認
```

## 注意事項
Secretiveを使用している場合、コミットを行うアプリ（ターミナルエミュレータ、エディタ）にはフルディスクアクセスが必要になります
