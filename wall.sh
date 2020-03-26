#!/bin/bash

category=$1
categories=$@
url="https://source.unsplash.com/6000x4000/?"

# don't output a comma before the first argument. There is probably a better way to do this.
comma=""
for i in ${categories}; do
    url="${url}${comma}$i"
    comma=","
done

if [ ! -d "~/.wallpaper" ]
then
    mkdir ~/.wallpaper
fi

# functions
command_exists () {
    type "$1" &> /dev/null ;
}

mac_wallpaper () {
    sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '~/.wallpaper/image.jpeg'";
    killall Dock;
}
# end functinos

image_url="${url}"

wget ${image_url} -O ~/.wallpaper/temp_image.jpeg &&

mv ~/.wallpaper/temp_image.jpeg ~/.wallpaper/image.jpeg &&
rm -rf ~/.wallpaper/temp_image.jpeg

if [[ "$OSTYPE" == "darwin"* ]]; then
    mac_wallpaper ~/.wallpaper/image.jpeg
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    if command_exists feh ; then
        feh --bg-scale ~/.wallpaper/image.jpeg
    fi
fi
