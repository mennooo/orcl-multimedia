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
  */

  ------------------------------------------------------------------------------
  -- function convert_video
  ------------------------------------------------------------------------------
  function convert_video (
    p_bfile bfile
  , p_duration varchar2 default null
  , p_volume number default null
  , p_size multimedia_pkg.media_size_t default null
  , p_framerate number default null
  , p_bitrate number default null
  , p_gray boolean default null
  , p_thumbnail boolean default null
  , p_ext varchar2 default null
  ) return blob;

end video_pkg;