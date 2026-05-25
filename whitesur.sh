#!/bin/bash

set -e

scrDir="$(dirname "$(realpath "$0")")"

clone_and_run() {
	local repo_url="$1"
	local repo_name="$2"
	shift 2
	local run_args=("$@")

	if [[ -d "$repo_name" ]]; then
		echo "Removing existing $repo_name directory..."
		rm -rf "$repo_name"
	fi

	git clone --depth 1 "$repo_url" "$repo_name"

	(
		cd "$repo_name"
		if [[ ${#run_args[@]} -gt 0 ]]; then
			"${run_args[@]}"
		fi
	)

	rm -rf "$repo_name"
}

# Setting Cursor -----------------------------------------
clone_and_run \
	"https://github.com/vinceliuice/WhiteSur-cursors.git" \
	"WhiteSur-cursors" \
	"./install.sh"

# Setting Icon -------------------------------------------
clone_and_run \
	"https://github.com/vinceliuice/WhiteSur-icon-theme.git" \
	"WhiteSur-icon-theme" \
	"./install.sh"

# Setting Theme ------------------------------------------
(
	repo="WhiteSur-gtk-theme"
	if [[ -d "$repo" ]]; then
		rm -rf "$repo"
	fi
	git clone --depth 1 "https://github.com/vinceliuice/WhiteSur-gtk-theme.git" "$repo"
	cd "$repo"
	./install.sh -l -c light -m -HD --round -N stable
	sudo ./tweaks.sh -g -p 60
	
	# Apply Monterey Firefox tweak with error handling for uninitialized Firefox
	if command -v firefox &> /dev/null; then
		echo "Firefox detected, attempting to initialize for Monterey theme..."
		# Run Firefox briefly in background to initialize profile, then close it
		timeout 10 firefox &> /dev/null &
		firefox_pid=$!
		sleep 3
		if kill -0 $firefox_pid 2>/dev/null; then
			kill $firefox_pid 2>/dev/null || true
			wait $firefox_pid 2>/dev/null || true
		fi
	fi
	
	# Apply Monterey tweak, continue even if it fails due to Firefox issues
	sudo ./tweaks.sh -f monterey || echo "Warning: Monterey Firefox tweak failed (Firefox may need manual initialization)"
	
	cd ..
	rm -rf "$repo"
)

# Extract prebuilt themes --------------------------------
mkdir -p ~/.themes

for theme_archive in "$scrDir"/theme/*.tar.xz; do
	if [[ -f "$theme_archive" ]]; then
		tar -xf "$theme_archive" -C ~/.themes
	fi
done

# Setting wallpapers -------------------------------------
screen_resolution=$("$scrDir/screen-res.sh")
echo "Your Screen Resolution is $screen_resolution"

(
	repo="WhiteSur-wallpapers"
	if [[ -d "$repo" ]]; then
		rm -rf "$repo"
	fi
	git clone --depth 1 "https://github.com/vinceliuice/WhiteSur-wallpapers.git" "$repo"
	cd "$repo"
	mkdir -p "$HOME/.local/share/gnome-background-properties"
	./install-gnome-backgrounds.sh -t whitesur -s "$screen_resolution"
	cd ..
	rm -rf "$repo"
)

