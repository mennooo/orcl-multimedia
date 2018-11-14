create or replace package image_pkg as 

  gc_image_dir constant multimedia_pkg.media_dir_t := 'IMAGE_DIR';
  
  /*
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
    
    
    select image_pkg.convert_image(
              p_blob => file_pkg.bfile_to_blob(file_locator)
            , p_sepia => 'Y'
            , p_size => media_size_t(500, 300)
            , p_rotate => 45
            , p_type => 'grayscale'
            , p_flip => 'Y'
            , p_negative => 'Y'
            )
      from multimedia
     where id = 27;
  */

  ------------------------------------------------------------------------------
  -- function convert_image
  ------------------------------------------------------------------------------
  function convert_image (
    p_blob blob
  , p_file_name varchar2
  , p_mime_type varchar2
  , p_size media_size_t default null
  , p_flip varchar default null
  , p_flop varchar default null
  , p_rotate number default null
  , p_contrast number default null
  , p_type varchar2 default null
  , p_sepia varchar2 default null
  , p_negative varchar2 default null
  , p_ext varchar2 default null
  ) return blob;

end image_pkg;