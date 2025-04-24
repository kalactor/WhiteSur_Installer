#!/bin/bash

set -e 

pm=$1
os=$2

export PATH="$HOME/.local/bin:$PATH"

extensions=(
	"user-theme@gnome-shell-extensions.gcampax.github.com"
	"blur-my-shell@aunetx"
	"dash-to-dock@micxgx.gmail.com"
	"logomenu@aryan_k"
	"Hide_Activities@shay.shayel.org"
	"just-perfection-desktop@just-perfection"
	"compiz-alike-magic-lamp-effect@hermes83.github.com"
	"moveclock@kuvaus.org"
)

ubuntu_extensions=(
	"user-theme@gnome-shell-extensions.gcampax.github.com"
	"blur-my-shell@aunetx"
	"logomenu@aryan_k"
	"Hide_Activities@shay.shayel.org"
	"just-perfection-desktop@just-perfection"
	"compiz-alike-magic-lamp-effect@hermes83.github.com"
	"moveclock@kuvaus.org"
)

pop_extensions=(
	"user-theme@gnome-shell-extensions.gcampax.github.com"
	"blur-my-shell@aunetx"
	"logomenu@aryan_k"
	"just-perfection-desktop@just-perfection"
	"compiz-alike-magic-lamp-effect@hermes83.github.com"
)

if [[ $pm == "pacman" ]]; then
	sudo $pm -Syu &> /dev/null
	sudo $pm -S --noconfirm python-pipx &> /dev/null
else
	sudo $pm update
	sudo $pm install pipx -y &> /dev/null
fi

pipx ensurepath
source ~/.bashrc
pipx install gnome-extensions-cli --system-site-packages

if [[ $os == "pop" ]]; then
	for extension in "${pop_extensions[@]}"; do
		if gnome-extensions list | grep -q "$extension"; then
			echo "Extension $extension is already installed. Skipping..."
		else
			echo "Installing and enabling extension: $extension"
			gnome-extensions-cli install $extension
		fi
	done
else
	for extension in "${pop_extensions[@]}"; do
		if gnome-extensions list | grep -q "$extension"; then
			echo "Extension $extension is already installed. Skipping..."
		else
			echo "Installing and enabling extension: $extension"
			gnome-extensions-cli install $extension
		fi
	done
fi





# extensions=(

# 	6949
# 	3193
# 	744
# 	3740
# 	19
# 	4451
# )

# #shell_version=$(gnome-shell --version | awk '{print $3}' | sed 's/\..*//')

# wget -O gnome-shell-extension-installer https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer
# chmod +x gnome-shell-extension-installer
# mv gnome-shell-extension-installer /usr/bin/

# shell_version=$(gnome-shell --version | awk '{print $3}' | cut -d. -f1)

# for extension in "${extensions[@]}"; do
# 	echo "[$extension] Installing..."
# 	gnome-shell-extension-installer $extension --yes
# done



#00000000000000000000000000000000
#
#declare -A os_extensions
#os_extensions["ubuntu"]="user-theme@gnome-shell-extensions.gcampax.github.com blur-my-shell@aunetx logomenu@aryan_k Hide_Activities@shay.shayel.org just-perfection-desktop@just-perfection compiz-alike-magic-lamp-effect@hermes83.github.com moveclock@kuvaus.org"
#os_extensions["pop"]="user-theme@gnome-shell-extensions.gcampax.github.com blur-my-shell@aunetx logomenu@aryan_k Hide_Activities@shay.shayel.org just-perfection-desktop@just-perfection compiz-alike-magic-lamp-effect@hermes83.github.com moveclock@kuvaus.org"
#os_extensions["default"]="user-theme@gnome-shell-extensions.gcampax.github.com blur-my-shell@aunetx dash-to-dock@micxgx.gmail.com logomenu@aryan_k Hide_Activities@shay.shayel.org just-perfection-desktop@just-perfection compiz-alike-magic-lamp-effect@hermes83.github.com moveclock@kuvaus.org"
#
#
#
## Detect OS
#os_id=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
#
## Fallback to default if not matched
#extensions="${os_extensions[$os_id]:-${os_extensions["default"]}}"
#
## Loop through and do something with each
#for ext in $extensions; do
#    echo "Enabling extension: $ext"
    # gnome-extensions enable "$ext" # example
#done
