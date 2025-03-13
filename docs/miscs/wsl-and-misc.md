```shell
# Import or initialize secrets:
#   SSH private keys, GPG secret keys, AWSCLI API keys, Terraform API keys,
#   Docker tokens, Cargo tokens, Bundle tokens, NPM tokens, PIP tokens, ...
# (Linux) keychain
sudo apt install keychain
ln -sf ~/.dotfiles/.ssh/add_keys.sh ~/.ssh/add_keys.sh

# copilot
`(eval):1: bad pattern: ^[7^[[?25l^[8^[[0G^[[2K` 臾몄젣媛 諛쒖깮??寃쎌슦 ?꾨옒 李멸퀬.
https://github.com/github/gh-copilot/issues/40

@masewo

I "fixed" it by accepting data collection manually. Do you know how I can revert this?

$ gh copilot config

? What would you like to configure?
> Optional Usage Analytics


? Allow GitHub to collect optional usage data to help us improve? This data does not include your queries.
> No


# alacritty
mkdir -p ~/.config/alacritty
ln -s ~/.dotfiles/alacritty.toml ~/.config/alacritty/.
ln -s ~/.dotfiles/dracula.yml ~/.config/alacritty/.

# Change default shell to zsh
chsh -s /bin/zsh

# Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
nvim
```

Or via [snap](https://snapcraft.io/install/nvim/debian) and symlink via `sudo ln -s =/usr/bin/snap

/usr/bin/nvim`

[nvm](https://github.com/nvm-sh/nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Locales

sudo dpkg-reconfigure locales -> en_US.UTF-8, ja_JP.UTF-8, ko_KR.UTF-8

# (WSL) Make share directory btwn WSL instances
mkdir /mnt/wsl/share


# (WSL) Give docker access to user
sudo usermod -aG docker $USER


# (yarn install)
sudo apt remove cmdtest

sudo apt remove yarn
 
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
yarn install

# CLI Browser
sudo apt install links

# Online judge system
https://velog.io/@selemium/series/Online-Judge-System

# (Open port of WSL; Reference:
[here](https://github.com/Alex-D/dotfiles#wsl-bridge))

# WSL LTS kernel that makes docker desktop work

Use [here](https://github.com/Nevuly/WSL2-Linux-Kernel-Rolling-LTS);
[This comment](https://github.com/microsoft/WSL/issues/11771#issuecomment-2444995937) suggested to do that.

## On WSL
#!/bin/zsh
windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
# Get the hacky network bridge script
cp ~/dev/dotfiles/wsl2-bridge.ps1 ${windowsUserProfile}/wsl2-bridge.ps1

## On PowerShell(Administrator)

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
PowerShell -File $env:USERPROFILE\\wsl2-bridge.ps1

### configure wslconfig and /etc/wsl.conf
ln -sf ~/.dotfiles/wslconfigs/.wslconfig /mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')/.wslconfig
sudo cp ~/.dotfiles/wslconfigs/wsl.conf /etc/wsl.conf

### Alternative (if Alex-D's one doesn't work)

- `PowerShell) Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All` (skip if already enabled)

- `PowerShell) New-VMSwitch -Name "WSL" -NetAdapterName "<Your Network Adapter Name>"

    -AllowManagementOS $true`
  - `Get-NetAdapter` to get `<Your Network Adapter Name>`
- Add below to .wslconfig

    [wsl2]
    networkingMode = bridged
    vmSwitch = WSL


- `wsl --shutdown` and restart WSL


```
#### Attach nvim setting to vscode[WSL]
Install vscode-neovim in vscode; check useWSL option; assign neovim executable
path and init.vim file.

<br>
