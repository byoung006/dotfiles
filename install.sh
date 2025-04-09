#! /bin/env bash
echo 'Starting Automated Setup'
echo 'Installing dependencies...'
sudo apt update 
echo 'Installing environment dependencies...'
if [ ! -f "packages.conf" ]; then
	echo "Error: packages.conf file not found!"
	exit 1
fi
source packages.conf
source utils.sh


echo "Installing System Utils..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing Dev Utils..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing FZF"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf/
./install.sh
echo "Installing additional dependencies..."

echo "Installing lazygit:"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

echo "Installing lazydocker:"
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash


	
