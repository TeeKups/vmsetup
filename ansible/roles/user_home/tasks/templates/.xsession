picom &
dwmblocks &
setxkbmap fi

[ -f $HOME/.config/wallpaper.* ] && feh --no-fehbg --bg-scale $HOME/.config/wallpaper.*

exec dwm