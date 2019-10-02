# Bash the wall

A small bash script to set your wallpaper from the command line. Simply run `./wall.sh` followed by any categories you would like!
Or, if you are feelin fancy, run it with no arguments for a random background. Crazy stuff I know...

This uses the unsplash API to source the images.

## Requirements/Dependencies
You will need [feh](https://github.com/derf/feh) installed for this to work.

## Example

```sh
./wall.sh nature bird
# This will grab a picture from unsplash that matches the query 'nature bird'
```

## Notes

As feh only sets the wallpaper for the current session, you can either add `~/.fehbg &` to your startup file (usually `~/.xinitrc, ~/.config/openbox/autostart` etc) to run the last feh command on startup.

Alternatively add `./wall.sh` with your arguments to your startup file to generate a new wallpaper on startup.

---

Any issues either open an issue on github, or give me a shout over on twitter [@crumb1e_](https://www.twitter.com/crumb1e_)