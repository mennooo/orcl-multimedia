create or replace package body audio_pkg as

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
  ) return blob is
  
    l_blob blob;
    l_query_params multimedia_pkg.query_param_tt;
    
  begin
  
    if p_tempo is not null then
      l_query_params(l_query_params.count + 1) := 'tempo=' || p_tempo;
    end if;
  
    if p_starttime is not null then
      l_query_params(l_query_params.count + 1) := 'starttime=' || p_starttime;
    end if;
  
    if p_duration is not null then
      l_query_params(l_query_params.count + 1) := 'duration=' || p_duration;
    end if;
  
    if p_volume is not null then
      l_query_params(l_query_params.count + 1) := 'volume=' || p_volume;
    end if;
  
    if p_bitrate is not null then
      l_query_params(l_query_params.count + 1) := 'bitrate=' || p_bitrate;
    end if;
  
    if p_samplerate is not null then
      l_query_params(l_query_params.count + 1) := 'samplerate=' || p_samplerate;
    end if;
  
    if p_ext is not null then
      l_query_params(l_query_params.count + 1) := 'ext=' || p_ext;
    end if;
  
    l_blob := multimedia_pkg.convert_media(
      p_blob => p_blob
    , p_file_name => p_file_name
    , p_mime_type => p_mime_type
    , p_type => multimedia_pkg.gc_media_type_audio
    , p_query_params => multimedia_pkg.get_query_string(l_query_params)
    );
        
    return l_blob;
    
  end convert_audio;

end audio_pkg;