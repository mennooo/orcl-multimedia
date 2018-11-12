create or replace package body image_pkg as

  ------------------------------------------------------------------------------
  -- function convert_image
  ------------------------------------------------------------------------------
  function convert_image (
    p_blob blob
  , p_size multimedia_pkg.media_size_t default null
  , p_rotate number default null
  , p_contrast number default null
  , p_sepia boolean default null
  , p_negative boolean default null
  , p_ext varchar2 default null
  ) return blob is
  
    l_blob blob;
    l_query_params multimedia_pkg.query_param_tt;
    
  begin
  
    if p_size.width is not null then
      l_query_params(l_query_params.count + 1) := 'size=' || p_size.width || ',' || p_size.height;
    end if;
  
    if p_rotate is not null then
      l_query_params(l_query_params.count + 1) := 'rotate=' || p_rotate;
    end if;
  
    l_blob := multimedia_pkg.convert_media(
      p_blob => p_blob
    , p_type => multimedia_pkg.gc_media_type_image
    , p_query_params => multimedia_pkg.get_query_string(l_query_params)
    );
        
    return l_blob;
    
  end convert_image;

end image_pkg;