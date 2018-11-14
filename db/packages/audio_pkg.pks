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

  ------------------------------------------------------------------------------
  -- function convert_audio
  ------------------------------------------------------------------------------
  function convert_audio (
    p_blob blob
  , p_file_name varchar2
  , p_mime_type varchar2
  , p_tempo number default null
  , p_starttime varchar2 default null
  , p_duration varchar2 default null
  , p_volume number default null
  , p_bitrate number default null
  , p_samplerate number default null
  , p_ext varchar2 default null
  ) return blob;

end audio_pkg;