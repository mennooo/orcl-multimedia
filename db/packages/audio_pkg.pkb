create or replace package body audio_pkg as

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
  ) return blob is
    l_blob blob;
  begin
  
    l_blob := apex_web_service.make_rest_request_b(
      p_url => 'http://us.music.yahooapis.com/ video/v1/list/published/popular'
    , p_http_method => 'POST'
    , p_parm_name => apex_util.string_to_table('appid:format')
    , p_parm_value => apex_util.string_to_table('xyz:xml')
    );
        
    return l_blob;
    
  end convert_video;

end audio_pkg;