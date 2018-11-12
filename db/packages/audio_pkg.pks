create or replace package audio_pkg as 

  gc_audio_dir constant multimedia_pkg.media_dir_t := 'AUDIO_DIR';
  
  /*
    - tempo [number] less then 1 is slower, more than 1 is faster
    - bitrate [kbit/s]
    - duration [[hh:]mm:]ss[.xxx]
    - starttime [[hh:]mm:]ss[.xxx]
    - volume [0..1]
    - ext [extension]
  */

--  ------------------------------------------------------------------------------
--  -- function convert_video
--  ------------------------------------------------------------------------------
--  function convert_video (
--    p_bfile bfile
--  , p_duration varchar2 default null
--  , p_volume number default null
--  , p_size multimedia_pkg.media_size_t default null
--  , p_framerate number default null
--  , p_bitrate number default null
--  , p_gray boolean default null
--  , p_thumbnail boolean default null
--  , p_ext varchar2 default null
--  ) return blob;

end audio_pkg;