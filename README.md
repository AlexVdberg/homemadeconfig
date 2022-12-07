# Setup
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


```
# This isn't necessesary with the Moonlander keyboard
ln -s ~/.config/homemadeconfig/.Xmodmap .Xmodmap
```

