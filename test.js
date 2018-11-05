const fs = require('fs');
const prism = require('prism-media');

console.log(typeof prism.FFmpeg)

const input = fs.createReadStream('./menno.jpg');
const output = fs.createWriteStream('./menno.png');
const transcoder = prism.FFmpeg({
  args: [
    '-analyzeduration', '0',
    '-loglevel', '0',
    '-f', 's16le',
    '-ar', '48000',
    '-ac', '2',
  ],
});

input.pipe(transcoder).pipe(output);