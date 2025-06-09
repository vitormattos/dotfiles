#!/bin/bash

DEFAULT_SINK=$(pactl get-default-sink | awk '{print $1}' | head -n1)

POWER_PATH="/sys/class/power_supply/AC/online"
if [ ! -f "$POWER_PATH" ]; then
    echo 'Carregador não encontrado'
    exit 1
fi

while true; do
    if [[ $(cat "$POWER_PATH") -eq 0 ]]; then
        pactl set-sink-volume "$DEFAULT_SINK" 100%
        pactl set-sink-mute "$DEFAULT_SINK" 0
        # espeak-ng -v pt-br -s 140 -p 50 "$1" --stdout | paplay
        echo "$1" | ~/projects/piper/piper/build/piper --model ~/Downloads/pt_BR-edresson-low.onnx --output-raw |   aplay -r 18000 -f S16_LE -t raw -
    fi
    sleep 1
done
