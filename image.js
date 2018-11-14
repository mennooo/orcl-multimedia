const gm = require('gm')
const mime = require('mime-types')

// All supported gm modifications
const gcConversions = {
  ext: (img, settings) => {
    console.log('setting format', ...settings)
    return img.setFormat(...settings)
  },
  size: (img, settings) => {
    console.log('resizing', ...settings)
    return img.resize(...settings)
  },
  quality: (img, settings) => {
    console.log('quality', ...settings)
    return img.quality(...settings)
  },
  crop: (img, settings) => {
    console.log('cropping', ...settings)
    return img.crop(...settings)
  },
  flip: (img, settings) => {
    console.log('flipping', ...settings)
    return img.flip(...settings)
  },
  flop: (img, settings) => {
    console.log('flopping', ...settings)
    return img.flop(...settings)
  },
  rotate: (img, settings) => {
    console.log('rotating', ...settings)
    settings.unshift('white')
    return img.rotate(...settings)
  },
  contrast: (img, settings) => {
    console.log('contrast', ...settings)
    return img.contrast(...settings)
  },
  sepia: (img, settings) => {
    console.log('sepia')
    return img.sepia()
  },
  type: (img, settings) => {
    console.log('type', ...settings)
    return img.type(...settings)
  },
  negative: (img, settings) => {
    console.log('negative')
    return img.negative()
  },
  blur: (img, settings) => {
    console.log('blur', ...settings)
    return img.blur(...settings)
  }
}

async function convert (req, res) {
  // Read the upload as streamed gm object
  const img = gm(req.file.buffer)

  // Do all conversions for the image
  for (let conversion in req.query) {
    try {
      await gcConversions[conversion](img, req.query[conversion].split(','))
    } catch (err) {
      console.log(err)
      throw new Error(`failed to ${conversion}`)
    }
  }
  // Get the image format to set the response content type
  img.format((err, format) => {
    if (err) {
      throw new Error(err.message)
    }
    res.type(mime.lookup(format))
    // Return the stream as response
    img.stream(function (err, stdout, stderr) {
      if (err) {
        throw new Error(err.message)
      }
      stdout.pipe(res)
    })
  })
}

module.exports = {
  convert: convert
}
