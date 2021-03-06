const { spawnSync } = require('child_process')
const fs = require('fs')
const mime = require('mime-types')
const path = require('path')

const gcConversions = {
  duration: (settings) => {
    return ['-t', ...settings]
  },
  starttime: (settings) => {
    return ['-ss', ...settings]
  },
  volume: (settings) => {
    return ['-filter:a', `volume=${settings}`]
  },
  size: (settings) => {
    return ['-s', `${settings[0]}x${settings[1]}`]
  },
  framerate: (settings) => {
    return ['-r', ...settings]
  },
  bitrate: (settings) => {
    return ['-ab', ...settings]
  },
  gray: () => {
    return ['-vf', 'format=gray']
  },
  thumbnail: (settings) => {
    return ['-vf', `thumbnail,scale=${settings[0]}:${settings[1]}`]
  }
}

function getConversionParameters (config) {
  const input = ['-i', config.inputFilename, '-v', '0']
  const output = [config.outputFilename]
  console.log(
    'Executing',
    'ffmpeg',
    ...input,
    ...config.conversions,
    ...output
  )
  return [
    ...input,
    ...config.conversions,
    ...output
  ]
}

async function convert (req, res) {
  const outputFilename = `${req.file.path}.${req.query.ext || path.extname(req.file.originalname)}`

  let conversions = []

  // Get all conversions for the video
  for (let conversion in req.query) {
    if (conversion !== 'ext') {
      try {
        conversions.push(...gcConversions[conversion](req.query[conversion].split(',')))
      } catch (err) {
        throw new Error(`failed to ${conversion}`)
      }
    }
  }

  // Start ffmpeg to do conversion
  spawnSync(
    'ffmpeg',
    getConversionParameters({
      conversions: conversions,
      inputFilename: req.file.path,
      outputFilename: outputFilename
    })
  )

  // Read converted output file
  const outputFile = fs.createReadStream(outputFilename)

  // Get new content type
  const contentType = mime.contentType(path.extname(outputFilename))

  res.type(contentType)

  // Send converted media back
  await outputFile.pipe(res)

  // Remove temp files
  fs.unlinkSync(req.file.path)
  fs.unlinkSync(outputFilename)
}

module.exports = {
  convert: convert
}
