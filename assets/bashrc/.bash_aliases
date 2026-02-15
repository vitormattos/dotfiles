alias kderestart='killall plasmashell && kstart5 plasmashell'
alias occ='docker compose exec -u www-data nextcloud ./occ'
alias php='docker compose exec $(docker compose ps --services | grep -E "php|nextcloud" | head -n 1) php'
alias composer='docker compose exec php composer'
alias adb=~/.nexustools/adb
alias fastboot=~/.nexustools/fastboot
alias webcam="scrcpy --video-source=camera --camera-size=1920x1080 --camera-facing=front --v4l2-sink=/dev/video5 --video-codec=h265  --no-audio"
