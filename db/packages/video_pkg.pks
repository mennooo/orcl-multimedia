create or replace package video_pkg as 

  gc_video_dir constant multimedia_pkg.media_dir_t := 'VIDEO_DIR';
  
  /*
      duration [[hh:]mm:]ss[.xxx]
    - starttime [[hh:]mm:]ss[.xxx]
    - volume [0..1]
    - size [width, height]
    - framerate [number] frames per second
    - bitrate [kbit/s]
    - gray
    - ext [extension]
    - thumbnail


     
    select video_pkg.convert_video(
              p_blob => file_pkg.bfile_to_blob(file_locator)
            , p_thumbnail => media_size_t(500, 300)
            , p_ext => 'jpg'
            )
      from multimedia
     where id = 11;
     
    select video_pkg.convert_video(
              p_blob => file_pkg.bfile_to_blob(file_locator)
            , p_file_name => file_name
            , p_mime_type => mime_type
            , p_duration => '00:00:10'
            )
      from multimedia
     where id = 38;
  */

  ------------------------------------------------------------------------------
  -- function convert_video
  ------------------------------------------------------------------------------
  function convert_video (
    p_blob blob
  , p_file_name varchar2
  , p_mime_type varchar2
  , p_duration varchar2 default null
  , p_volume number default null
  , p_size media_size_t default null
  , p_framerate number default null
  , p_bitrate number default null
  , p_gray varchar2 default null
  , p_thumbnail media_size_t default null
  , p_ext varchar2 default null
  ) return blob;

end video_pkg;