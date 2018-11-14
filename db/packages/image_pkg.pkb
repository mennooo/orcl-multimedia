create or replace package body image_pkg as

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
  ) return blob is
  
    l_blob blob;
    l_query_params multimedia_pkg.query_param_tt;
    
  begin
  
    if p_size is not null then
      l_query_params(l_query_params.count + 1) := 'size=' || p_size.width || ',' || p_size.height;
    end if;
  
    if p_flip = 'Y' then
      l_query_params(l_query_params.count + 1) := 'flip';
    end if;
  
    if p_flop = 'Y' then
      l_query_params(l_query_params.count + 1) := 'flop';
    end if;
  
    if p_rotate is not null then
      l_query_params(l_query_params.count + 1) := 'rotate=' || p_rotate;
    end if;
  
    if p_contrast is not null then
      l_query_params(l_query_params.count + 1) := 'contrast=' || p_contrast;
    end if;
  
    if p_type is not null then
      l_query_params(l_query_params.count + 1) := 'type=' || p_type;
    end if;
  
    if p_sepia = 'Y' then
      l_query_params(l_query_params.count + 1) := 'sepia';
    end if;
  
    if p_negative = 'Y'  then
      l_query_params(l_query_params.count + 1) := 'negative';
    end if;
  
    if p_ext is not null then
      l_query_params(l_query_params.count + 1) := 'ext=' || p_ext;
    end if;
  
    l_blob := multimedia_pkg.convert_media(
      p_blob => p_blob
    , p_file_name => p_file_name
    , p_mime_type => p_mime_type
    , p_type => multimedia_pkg.gc_media_type_image
    , p_query_params => multimedia_pkg.get_query_string(l_query_params)
    );
        
    return l_blob;
    
  end convert_image;

end image_pkg;