# ENVIRONEMENT

deps on : https://github.com/HyDE-Project/HyDE

### INSTALLATION

```
pacman -S --needed git base-devel
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE/Scripts
./install.sh
reboot
```

> [!UPDATE]
>
> ```
> cd ~/HyDE/Scripts
> git pull origin master
> ./install.sh -r
> ```

### ZSH INSTALL

#### Install oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Install dependance
```
sudo pacman -Syu fzf
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/custom/pure"
curl -o ~/.zshrc https://raw.githubusercontent.com/Denos-soneD/zshrc/main/zshrc && source ~/.zshrc
```

### BLACK ARCH AND YAY INSTALL
```
curl -O https://blackarch.org/strap.sh
sudo chmod +x strap.sh
sudo ./ strap.sh
sudo pacman -Syyu --noconfirm
sudo pacman -S yay --noconfirm
```