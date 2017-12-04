setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle,grp_led:scroll" &

xsetroot -cursor_name left_ptr &

feh --bg-scale /home/petertr/Pictures/wallpapers/firewatch_green.jpg &
# _volume_pipe=/tmp/.volume-pipe &
# [ -e $_volume_pipe ] && rm $_volume_pipe &
# [[ -S $_volume_pipe ]] || mkfifo $_volume_pipe &
# echo `~/.xmonad/getvolume.sh` > /tmp/.volume-pipe & # moved to xmonad.hs

urxvt &
thunar --daemon &
yandex-disk start &
xmonad
