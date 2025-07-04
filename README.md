# Setup
Don't make the symlinks manually. Instead it woud be better to use something
like `stow` to build the symlinks for you and then easily be able to reverse it
later.


Sym-link configuration files

```
ln -s ~/.config/homemadeconfig/.alacritty.yml ~/.alacritty.yml
ln -s ~/.config/homemadeconfig/.bashrc ~/.bashrc
ln -s ~/.config/homemadeconfig/.tmux.conf ~/.tmux.conf
ln -s ~/.config/homemadeconfig/.vimrc ~/.vimrc
ln -s ~/.config/homemadeconfig/config ~/.config/i3/config
ln -s ~/.config/homemadeconfig/.i3status.conf ~/.i3status.conf

cp ~/.config/homemadeconfig/10-monitor.conf /etc/X11/xorg.conf.d/
cp ~/.config/homemadeconfig/.Xresources ~/
```

Install programs on ubuntu
```
sudo apt install gnome-screenshot ddcutil

# Install policykit for password prompts
sudo apt install policykit-desktop-privileges
sudo apt install policykit-1-gnome
# Add exec to config
#$exec /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Copy window layout
sudo cp ~/.config/homeadeconfig/20-monitor.conf /usr/share/X11/xorg.conf.d/20-monitor.conf

# Vim
sudo apt install vim

# Emacs
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs28
mkdir -p ~/org-roam

## Install node and npm and nvm
# https://nodejs.org/en/download/package-manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install 20
sudo npm install -g @mermaid-js/mermaid-cli
```


Install programs on manjaro/arch
```
sudo pacman -Syu gnome-screenshot ddcutil
```

Xp Pen Artist Pro 16

I mostly followed the guide by [David
Revoy][https://www.davidrevoy.com/article1004/xppen-artist-pro-16-gen-2-review-on-gnulinux]
for this. One thing to note is that the `xinput_calibrator` only works with 1
monitor. To work around this, disable all other monitors to get your values for
minx, miny, maxx, maxy and use those values.
```
# disable all other screens in display manager
xinput_calibrator
# set stylus area with the numbers you get to test it out
xsetwacom set "UGTABLET Artist Pro 16 (Gen2) stylus" Area -100 0 32639 32761
# Re-enable all displays
# Manually map the stylus to the display
xsetwacom set "UGTABLET Artist Pro 16 (Gen2) stylus" MapToOutput HDMI-A-0
# get the device id of the tablet
xinput list
# get the Calibration Transition Matrix that the maptoputput will populate
xinput list-props <device id>
# add the calibration information to 99-calibaration.conf
# make sure there are no "," in the string field
# Install xorg conf for xppen pro 16 (gen2)
# log in and out to apply
sudo cp 99-calibration.conf /etc/X11/xorg.conf.d/99-calibration.conf
```

Other setup things
```
# Git config editor to vim
git config --global core.editor "vim"

# Install playerctl for audio pause/play
sudo pacman -Syu playerctl
```

```
# This isn't necessesary with the Moonlander keyboard
# Swap capslock and ctrl
ln -s ~/.config/homemadeconfig/.Xmodmap .Xmodmap
```
