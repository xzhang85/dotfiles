#!/bin/bash

echo "=== Install necessary packages ==="
sudo -E apt-get update
sudo -E apt-get install -y aptitude openssh-server git tmux vim vim-nox zsh htop curl rsync clang-format universal-ctags cloc cscope tree build-essential autoconf gdb cmake cmake-curses-gui pkg-config wget trash-cli python3-dev

echo "=== Setup GDB ==="
wget https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit -O ~/.gdbinit
mkdir ~/.gdbinit.d
cat<<EOF > ~/.gdbinit.d/dashboard
dashboard -style prompt_not_running '\[\e[1;31m\]>>>\[\e[0m\]'
dashboard -style style_low '1;31'
dashboard -style syntax_highlighting 'vim'
dashboard -layout source stack threads memory history expressions !assembly !registers
dashboard source -style context 15
dashboard stack -style compact True
dashboard stack -style limit 5
EOF

echo "=== Setup oh-my-zsh ==="
sh -c "RUNZSH=no $(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "=== Download config files ==="
git clone https://github.com/zhang-xin/dotfiles.git
cp dotfiles/vimrc ~/.vimrc
cp dotfiles/zshrc ~/.zshrc
cp dotfiles/p10k.zsh ~/.p10k.zsh
cp dotfiles/tmux.conf ~/.tmux.conf
cp dotfiles/gitconfig ~/.gitconfig
cp dotfiles/dir_colors ~/.dir_colors
mkdir ~/bin
mkdir ~/.vim
cp dotfiles/dgdb ~/bin
rm -rf dotfiles

echo "=== Setup vim-plug and vim plugins ==="
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
sed -i 's/colorscheme ron/colorscheme solarized/' ~/.vimrc

echo "remember to relogin."
echo "Bye Bye."
