#!/bin/bash

# MacOS tarzı kısayolları Ubuntu'da etkinleştirmek için script
# Bu script, GNOME masaüstü ortamındaki kısayolları günceller

# Sol ve Sağ Command (Super) tuşlarını Control ile değiştir
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_lwin_lctl', 'ctrl:swap_rwin_rctl']"

# Özel kısayolları tanımlamak için dizin
keybindings_dir="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

# Mevcut özel kısayol yollarını al
existing_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

# Özel kısayol yollarını tutacak bir dizi oluştur
custom_bindings=()

# Eğer mevcut özel kısayollar varsa, onları diziye ekle
if [ "$existing_bindings" != "@as []" ]; then
    IFS=', ' read -r -a custom_bindings <<< "${existing_bindings//[\[\]\' ]/}"
fi

# Özel kısayolları tanımla
declare -A shortcuts
shortcuts=(
    # Genel Kısayollar
    ["copy"]="<Super>c"
    ["paste"]="<Super>v"
    ["cut"]="<Super>x"
    ["undo"]="<Super>z"
    ["redo"]="<Super>Shift>z"
    ["select_all"]="<Super>a"
    ["find"]="<Super>f"
    ["new_window"]="<Super>n"
    ["quit"]="<Super>q"
    ["close_window"]="<Super>w"
    ["hide_application"]="<Super>h"
    ["minimize_window"]="<Super>m"
    ["switch_apps"]="<Super>Tab"
    ["screenshot"]="<Super>Shift>3"
    ["screenshot_select"]="<Super>Shift>4"
    ["screen_record"]="<Super>Shift>5"
    ["touch_bar_screenshot"]="<Super>Shift>6"

    # Finder ve Dosya Yönetimi Kısayolları
    ["new_finder_window"]="<Super>n"
    ["new_folder"]="<Super>Shift>n"
    ["move_to_trash"]="<Super>Delete"
    ["empty_trash"]="<Super>Shift>Delete"
    ["show_info"]="<Super>i"
    ["spotlight_search"]="<Super>Space"
    ["duplicate_item"]="<Super>d"
    ["open_network"]="<Super>k"

    # Sistem ve Uygulama Kısayolları
    ["lock_screen"]="<Ctrl><Super>l"
    ["force_quit"]="<Super>Shift>Esc"
    ["fast_logout"]="<Super>Shift>q"
    ["go_home"]="<Super>h"
    ["refresh"]="<Super>r"
    ["open_applications_folder"]="<Super>Shift>a"
    ["open_utilities"]="<Super>Shift>u"
    ["go_to_home_directory"]="<Super>Shift>h"
    ["restart_mac"]="<Ctrl><Super>power"
    ["shutdown_mac"]="<Ctrl><Option><Super>power"
    ["sleep_mac"]="<Ctrl><Shift>power"
    ["close_active_window"]="<Super>f4"
    ["toggle_dock"]="<Super>d"

    # Safari ve İnternet Kısayolları
    ["restore_tab"]="<Super>Shift>t"
    ["view_history"]="<Super>y"
    ["switch_tab"]="<Super>1"
    ["search_in_safari"]="<Super>f"
    ["focus_search_in_safari"]="<Super>Shift>f"
    ["open_settings"]="<Super>,"

    # Terminal Kısayolları
    ["cancel_command"]="<Ctrl>c"
    ["close_terminal"]="<Ctrl>d"
    ["clear_screen"]="<Ctrl>l"
    ["clear_terminal"]="<Super>k"
    ["previous_command"]="<Up>"
    ["next_command"]="<Down>"
    ["paste_in_terminal"]="<Super>Shift>v"

    # Ekran Görüntüsü Kısayolları
    ["screenshot_full"]="<Super>Shift>3"
    ["screenshot_select_area"]="<Super>Shift>4"
    ["screenshot_with_recording"]="<Super>Shift>5"
    ["touch_bar_screenshot"]="<Super>Shift>6"

    # Erişilebilirlik Kısayolları
    ["accessibility_menu"]="<Option><Super>f5"
    ["invert_screen"]="<Option><Super>8"
    ["zoom_in"]="<Option><Super>+"
    ["zoom_out"]="<Option><Super>-"

    # Magic Keyboard Özellikleri
    ["f1_f2_brightness"]="<F1>"
    ["f3_mission_control"]="<F3>"
    ["f4_launchpad"]="<F4>"
    ["f7_f8_f9_volume"]="<F7>"
    ["f10_f11_f12_volume_control"]="<F10>"
    ["fn_up_down_page"]="<Fn><Up>"
    ["fn_down_page"]="<Fn><Down>"

    # Ekran Kilitleme ve Uygulama Kısayolları
    ["lock_screen_ctrl_super_q"]="<Ctrl><Super>q"  # Ekranı kilitle
)

# Kısayol indexini başlat
index=${#custom_bindings[@]}

for name in "${!shortcuts[@]}"; do
    binding="${shortcuts[$name]}"

    # Uygulanacak komutlar
    case $name in
        "copy"|"paste"|"cut"|"undo"|"redo"|"select_all"|"find"|"save")
            command="xdotool key ${binding}"  # Kısayol tuşlarına basmayı simüle et
            ;;
        "new_window")
            command="xdg-open ~"  # Yeni bir pencere açmak
            ;;
        "quit")
            command="gnome-session-quit --logout --no-prompt"  # Çıkış yap
            ;;
        "lock_screen")
            command="gnome-screensaver-command --lock"  # Ekranı kilitle
            ;;
        "lock_screen_ctrl_super_q")
            command="gnome-screensaver-command --lock"  # Command + Control + Q ekran kilitleme
            ;;
        "screenshot")
            command="gnome-screenshot --file ~/Pictures/screenshot.png"  # Ekran görüntüsü al
            ;;
        "shutdown")
            command="systemctl poweroff"  # Sistem kapalı
            ;;
        "logout")
            command="gnome-session-quit --logout --no-prompt"  # Oturumu kapat
            ;;
        "open_terminal")
            command="gnome-terminal"  # Terminal aç
            ;;
        "open_files")
            command="nautilus"  # Dosya yöneticisini aç
            ;;
        "show_desktop")
            command="xdotool key Super+d"  # Masaüstünü göster
            ;;
        "show_notifications")
            command="gnome-shell --replace &"  # Bildirimleri göster
            ;;
        "toggle_apps")
            command="gnome-shell-extension-prefs"  # Uygulama menüsünü aç
            ;;
        *)
            continue
            ;;
    esac

    keybinding_path="$keybindings_dir/custom$index/"
    custom_bindings+=("$keybinding_path")

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$keybinding_path" name "$name"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$keybinding_path" command "$command"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$keybinding_path" binding "$binding"

    ((index++))
done

# Özel kısayolları etkinleştir
bindings_str="['$(printf "%s," "${custom_bindings[@]}" | sed 's/,$//')]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$bindings_str" > /dev/null 2>&1

colors=(
    "38;5;129"  
    "38;5;13"   
    "38;5;5"    
    "38;5;81"   
)

# Mesajı yazdıran fonksiyon
print_message() {
    message="Magic Keyboard Shortcut created by Y K Y"
    for i in {0..5}; do
        
        color=${colors[$((i % ${#colors[@]}))]}
        echo -e "\033[48;5;16m\033[${color}m$message\033[0m"
        sleep 0.3  
        clear       
    done
}
print_message
