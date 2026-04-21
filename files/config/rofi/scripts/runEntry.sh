#!/usr/bin/env bash

# Audio Variables
## PipeWire
_pipewire_volume=$(wpctl get-volume @DEFAULT_SINK@ | awk '{printf "%d\n", $2 * 100}')
_pipewire_max_volume="100"
_pipewire_goal_volume="50"
_pipewire_volume_difference=$((_pipewire_goal_volume - _pipewire_volume))
_pipewire_absolute_volume_difference=${_pipewire_volume_difference#-}
## PulseAudio
_pulseaudio_volume=$(printf '%s\n' "$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $3}' | tr -d '\n')")
_pulseaudio_max_volume="65540"
_pulseaudio_goal_volume="32770"
_pulseaudio_volume_difference=$((_pulseaudio_goal_volume - _pulseaudio_volume))
_pulseaudio_absolute_volume_difference=${_pulseaudio_volume_difference#-}
## ALSA
_alsa_volume=$(printf '%s\n' "$(amixer sget Master | grep "%" | sed 's/^[^\[]*.//g' | sed 's|%.*||g' | awk 'NR==1')")
_alsa_goal_volume="50"
_alsa_max_volume="100"
_alsa_volume_difference=$((_alsa_volume - _alsa_goal_volume))
_alsa_absolute_volume_difference=${_alsa_volume_difference#-}

if command -v wpctl >/dev/null 2>&1; then
    _audio_backend="pipewire"
elif command -v pactl >/dev/null 2>&1; then
    _audio_backend="pulseaudio"
elif command -v amixer >/dev/null 2>&1; then
    _audio_backend="alsa"
else
    _audio_backend="none"
fi

case "$_audio_backend" in
    pipewire)
        if [[ $_pipewire_absolute_volume_difference -le 25 ]]; then
            pw-play "$HOME/.config/rofi/sounds/click.ogg"
        else
            wpctl set-volume @DEFAULT_SINK@ 50%
            pw-play "$HOME/.config/rofi/sounds/click.ogg"
            wpctl set-volume @DEFAULT_SINK@ ${_pipewire_volume}%
        fi
        ;;
    pulseaudio)
        if [[ $_pulseaudio_absolute_volume_difference -le 32770 ]]; then
            pactl set-sink-volume @DEFAULT_SINK@ 50%
            paplay $HOME/.config/rofi/sounds/click.ogg
            pactl set-sink-volume @DEFAULT_SINK@ $_pulseaudio_volume
        else
            paplay $HOME/.config/rofi/sounds/click.ogg
        fi
        ;;
    alsa)
        if [[ $_alsa_absolute_volume_difference -le 25 ]]; then
            aplay $HOME/.config/rofi/sounds/click.wav --file-type wav
        else
            amixer sset Master 50%
            aplay $HOME/.config/rofi/sounds/click.wav --file-type wav
            amixer sset Master ${_alsa_volume}%
        fi
        ;;
    *)
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Error" "No Audio Backend Detected."
        else
            echo "Error" "No Audio Backend Detected."
        fi
        ;;
esac

unset _pipewire_volume _pipewire_max_volume _pipewire_goal_volume _pipewire_volume_difference _pipewire_absolute_volume_difference _pulseaudio_volume _pulseaudio_max_volume _pulseaudio_goal_volume _pulseaudio_volume_difference _pulseaudio_absolute_volume_difference _alsa_volume _alsa_goal_volume _alsa_max_volume _alsa_volume_difference _alsa_absolute_volume_difference _audio_backend
