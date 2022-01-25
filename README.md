# Setup
Sym-link configuration files

```
ln -s ~/.config/homemadeconfig/.alacritty.yml .alacritty.yml
ln -s ~/.config/homemadeconfig/.bashrc .bashrc
ln -s ~/.config/homemadeconfig/.tmux.conf .tmux.conf

```

# Replace caps-lock with ctrl
This isn't necessesary with the Moonlander keyboard

## Arch

```
ln -s ~/.config/homemadeconfig/.Xmodmap .Xmodmap
```

copy .Xmodmap to `~/`

## Ubuntu
execute:

```
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']
```

# Truecolor support
To test if truecolor is working run the following

``` bash
curl -s https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh >24-bit-color.sh
bash 24-bit-color.sh
```

Information on the proper settings can be found in [alacritty-tmux-vim_truecolor.md](https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6)

