#!/bin/bash

while getopts ":s:" opt; do
    case $opt in
        s) cp ~/.wallpaper/image.jpeg ~/.wallpaper/saved/$OPTARG.jpeg 
        exit 1
    esac
done

category=$1
categories=$@
url="https://source.unsplash.com/6000x4000/?"

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
