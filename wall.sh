#!/bin/bash

usage() {
    cat <<EOF
Usage:
    Set wallpaper: wall *prompts* (e.g wall tokyo night)
    Save current wallpaper: wall -s *name* (saves to .wallpaper/saved/*name*.jpeg)
EOF
}

# by default, lets get 4k images.
resolution="3840x2160"

while getopts "hs:r:" opt; do
    case $opt in
        s) cp ~/.wallpaper/image.jpeg ~/.wallpaper/saved/$OPTARG.jpeg
        exit 1 ;;
        r)  resolution=$OPTARG
            # we've got the resolution, now lets get rid of the opt
            shift $(( OPTIND - 1 )) ;;
        h) usage
        exit 1 ;;
    esac
done

category=$1
categories=$@
url="https://source.unsplash.com/$resolution/?"

# don't output a comma before the first argument. There is probably a better way to do this.
comma=""
for i in ${categories}; do
    url="${url}${comma}$i"
    comma=","
done

# functions
command_exists () {
    type "$1" &> /dev/null ;
}

mac_check_dir () {
    if [ ! -d "/Users/$(whoami)/.wallpaper" ]; then
        echo "No wallpaper directory found, creating one now!"
        mkdir ~/.wallpaper
        mkdir ~/.wallpaper/saved
    fi
}

mac_wallpaper () {
    osascript -e 'tell application "System Events" to tell every desktop to set picture to "~/.wallpaper/image.jpeg"'
    killall Dock
}

get_wallpaper () {
    image_url="${url}"

    wget ${image_url} -O ~/.wallpaper/temp_image.jpeg &&

    mv ~/.wallpaper/temp_image.jpeg ~/.wallpaper/image.jpeg &&
    rm -rf ~/.wallpaper/temp_image.jpeg
}
# end functinos



if [[ "$OSTYPE" == "darwin"* ]]; then
    mac_check_dir
    get_wallpaper
    mac_wallpaper ~/.wallpaper/image.jpeg
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    get_wallpaper
    if command_exists feh ; then
        feh --bg-scale ~/.wallpaper/image.jpeg
    fi
fi
