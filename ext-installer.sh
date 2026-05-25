#!/bin/bash

set -e

# Color variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color / Reset

pm="$1"
os="$2"

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

if [[ "$pm" == "pacman" ]]; then
  echo -e "${YELLOW}Updating package database...${NC}"
  if sudo "$pm" -Syu; then
    echo -e "${GREEN}Package database updated successfully.${NC}"
  else
    echo -e "${RED}Failed to update package database. Exiting...${NC}"
    exit 1
  fi
  
  echo -e "${YELLOW}Installing python-pipx...${NC}"
  if sudo "$pm" -S --noconfirm --needed python-pipx; then
    echo -e "${GREEN}python-pipx installed successfully.${NC}"
  else
    echo -e "${RED}Failed to install python-pipx. Exiting...${NC}"
    exit 1
  fi
else
  echo -e "${YELLOW}Updating package database...${NC}"
  if sudo "$pm" update; then
    echo -e "${GREEN}Package database updated successfully.${NC}"
  else
    echo -e "${RED}Failed to update package database. Exiting...${NC}"
    exit 1
  fi
  
  echo -e "${YELLOW}Installing pipx...${NC}"
  if sudo "$pm" install -y pipx; then
    echo -e "${GREEN}pipx installed successfully.${NC}"
  else
    echo -e "${RED}Failed to install pipx. Exiting...${NC}"
    exit 1
  fi
fi

pipx ensurepath > /dev/null 2>&1 || true

if ! command -v gnome-extensions-cli &> /dev/null; then
  echo -e "${YELLOW}Installing gnome-extensions-cli...${NC}"
  if pipx install gnome-extensions-cli --system-site-packages; then
    echo -e "${GREEN}gnome-extensions-cli installed successfully.${NC}"
  else
    echo -e "${RED}Failed to install gnome-extensions-cli. Exiting...${NC}"
    exit 1
  fi
fi

case "$os" in
	pop)
		target_extensions=("${pop_extensions[@]}")
		;;
	ubuntu|linuxmint|zorin)
		target_extensions=("${ubuntu_extensions[@]}")
		;;
	*)
		target_extensions=("${extensions[@]}")
		;;
esac

for extension in "${target_extensions[@]}"; do
  if gnome-extensions list 2>/dev/null | grep -q "$extension"; then
    echo -e "${GREEN}Extension $extension is already installed. Skipping...${NC}"
  else
    echo -e "${YELLOW}Installing and enabling extension: $extension${NC}"
    if gnome-extensions-cli install "$extension"; then
      echo -e "${GREEN}Successfully installed $extension${NC}"
      if gnome-extensions-cli enable "$extension"; then
        echo -e "${GREEN}Successfully enabled $extension${NC}"
      else
        echo -e "${RED}Failed to enable $extension. Continuing...${NC}"
      fi
    else
      echo -e "${RED}Failed to install $extension. Continuing...${NC}"
    fi
  fi
done
