#!/bin/bash

declare -A osInfo
osInfo[/etc/debian_version]="apt-get"
osInfo[/etc/alpine-release]="apk"
osInfo[/etc/centos-release]="yum"
osInfo[/etc/fedora-release]="dnf"

for f in "${!osInfo[@]}"; do
    if [[ -f $f ]]; then
        package_manager="${osInfo[$f]}"
        break
    fi
done

if [[ -z "$package_manager" ]]; then
    echo "Can't determine package manager :("
    exit 1
else
    echo "Detected package manager: $package_manager"
fi

