#!/bin/bash

# MacOS tarzı kısayolları Ubuntu'da etkinleştirmek için script
# Bu script, GNOME masaüstü ortamındaki kısayolları günceller

# Sol Command ve Sol Control tuşlarını değiştir
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_lwin_lctl']"

# Sağ Command ve Sağ Control tuşlarını değiştir
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_rwin_rctl']"

# Fonksiyon tuşlarını medya tuşları olarak kullan
gsettings set org.gnome.settings-daemon.plugins.media-keys media-keys "['XF86AudioLowerVolume', 'XF86AudioRaiseVolume', 'XF86AudioMute', 'XF86AudioPlay', 'XF86AudioNext', 'XF86AudioPrev']"

# Özel kısayollar listesi
custom_keybindings=("copy" "paste" "cut" "undo" "redo" "select_all" "find" "new_window" "save" "quit")

# Özel kısayolları tanımla
for i in "${!custom_keybindings[@]}"; do
  name=${custom_keybindings[$i]}
  case $name in
    "copy")
      command='xdotool key --clearmodifiers ctrl+c'
      binding='<Super>c'
      ;;
    "paste")
      command='xdotool key --clearmodifiers ctrl+v'
      binding='<Super>v'
      ;;
    "cut")
      command='xdotool key --clearmodifiers ctrl+x'
      binding='<Super>x'
      ;;
    "undo")
      command='xdotool key --clearmodifiers ctrl+z'
      binding='<Super>z'
      ;;
    "redo")
      command='xdotool key --clearmodifiers ctrl+Shift+z'
      binding='<Super>Shift+z'
      ;;
    "select_all")
      command='xdotool key --clearmodifiers ctrl+a'
      binding='<Super>a'
      ;;
    "find")
      command='xdotool key --clearmodifiers ctrl+f'
      binding='<Super>f'
      ;;
    "new_window")
      command='xdotool key --clearmodifiers ctrl+n'
      binding='<Super>n'
      ;;
    "save")
      command='xdotool key --clearmodifiers ctrl+s'
      binding='<Super>s'
      ;;
    "quit")
      command='xdotool key --clearmodifiers ctrl+q'
      binding='<Super>q'
      ;;
  esac

  key="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i/"

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key name "$name"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key command "$command"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key binding "$binding"
done

# Özel kısayolları etkinleştir
paths=""
for i in "${!custom_keybindings[@]}"; do
  paths+="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i/', "
done
paths="[${paths::-2}]"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$paths"
