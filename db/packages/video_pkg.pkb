create or replace package body video_pkg as

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
  ) return blob is
  
    l_blob blob;
    l_query_params multimedia_pkg.query_param_tt;
    
  begin
  
    if p_duration is not null then
      l_query_params(l_query_params.count + 1) := 'duration=' || p_duration;
    end if;
  
    if p_volume is not null then
      l_query_params(l_query_params.count + 1) := 'volume=' || p_volume;
    end if;
  
    if p_size is not null then
      l_query_params(l_query_params.count + 1) := 'size=' || p_size.width || ',' || p_size.height;
    end if;
  
    if p_framerate is not null then
      l_query_params(l_query_params.count + 1) := 'framerate=' || p_framerate;
    end if;
  
    if p_bitrate is not null then
      l_query_params(l_query_params.count + 1) := 'bitrate=' || p_bitrate;
    end if;
  
    if p_gray = 'Y' then
      l_query_params(l_query_params.count + 1) := 'gray';
    end if;
  
    if p_thumbnail is not null then
      l_query_params(l_query_params.count + 1) := 'thumbnail=' || p_thumbnail.width || ',' || p_thumbnail.height;
    end if;
  
    if p_ext is not null then
      l_query_params(l_query_params.count + 1) := 'ext=' || p_ext;
    end if;
  
    l_blob := multimedia_pkg.convert_media(
      p_blob => p_blob
    , p_file_name => p_file_name
    , p_mime_type => p_mime_type
    , p_type => multimedia_pkg.gc_media_type_video
    , p_query_params => multimedia_pkg.get_query_string(l_query_params)
    );
        
    return l_blob;
    
  end convert_video;

end video_pkg;