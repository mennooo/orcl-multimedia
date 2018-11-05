## Video
Based on ffmeg.
Supports most formats

- duration [[hh:]mm:]ss[.xxx]
- starttime [[hh:]mm:]ss[.xxx]
- volume [0..1]
- size [width, height]
- framerate [number] frames per second
- bitrate [kbit/s]
- gray
- ext [extension]
- thumbnail [width, height]

localhost:3000/video?conversion=gray&duration=1min&ext=mp4

## Audio
Based on ffmeg.
Supports most formats

- tempo [number] less then 1 is slower, more than 1 is faster
- bitrate [kbit/s]
- duration [[hh:]mm:]ss[.xxx]
- starttime [[hh:]mm:]ss[.xxx]
- volume [0..1]
- ext [extension]

## Image
Based on imagemagick
Supports most formats

https://www.imagemagick.org/script/formats.php


- ext [extension]
- size [width, height]
- quality [0..100] percentage
- crop [width, height, offsetLeft, offsetTop]
- flip
- flop
- rotate [deg]
- contrast [number]
- type [string]
    - Bilevel
    - Grayscale
    - Palette
    - PaletteMatte
    - TrueColor
    - TrueColorMatte
    - ColorSeparation
    - ColorSeparationMatte
    - Optimize
- sepia
- negative
- blur [number] pixels

localhost:3000/image?size=20,20&ext=jpg&flip