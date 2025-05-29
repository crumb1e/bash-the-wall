#!/bin/bash
source api_keys.env

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
oldurl="https://source.unsplash.com/$resolution/?"
url="https://api.unsplash.com/photos/random/?client_id=$UNSPLASH_CLIENT_ID&orientation=landscape&query="

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
        mkdir ~/.wallpaper/history
    fi
}


mac_wallpaper () {
    timestamp=$(date +%s)
    cp ~/.wallpaper/image.jpeg ~/.wallpaper/history/image_${timestamp}.jpeg
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"${HOME}/.wallpaper/history/image_${timestamp}.jpeg\""
    # Optionally, clean up old images if needed
    # Keep only the 5 most recent images, delete older ones
    ls -1t ~/.wallpaper/history/image_*.jpeg | tail -n +6 | xargs -I {} rm -- {}
}

get_wallpaper () {
    wget ${url} -O ~/.wallpaper/unsplash_response.json &&

    raw_image=`jq -r '.urls.raw' ~/.wallpaper/unsplash_response.json` &&

    wget ${raw_image} -O ~/.wallpaper/temp_image.jpeg &&

    mv ~/.wallpaper/temp_image.jpeg ~/.wallpaper/image.jpeg
}
# end functinos



if [[ "$OSTYPE" == "darwin"* ]]; then
    mac_check_dir
    get_wallpaper
    mac_wallpaper
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    get_wallpaper
    if command_exists feh ; then
        feh --bg-scale ~/.wallpaper/image.jpeg
    fi
fi
