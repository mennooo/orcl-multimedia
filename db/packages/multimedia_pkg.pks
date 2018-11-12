create or replace package multimedia_pkg as 

  subtype media_dir_t is varchar2(30);
  
  gc_media_type_image multimedia.media_type%type := 'IMAGE';
  gc_media_type_audio multimedia.media_type%type := 'AUDIO';
  gc_media_type_video multimedia.media_type%type := 'VIDEO';
  
  gc_convert_base_url varchar2(50) := 'http://localhost:3000/';
  
  type query_param_tt is table of varchar2(4000) index by pls_integer;
  
  type media_size_t is record (
    width number
  , height number
  );

  ------------------------------------------------------------------------------
  -- procedure ins
  ------------------------------------------------------------------------------
  procedure ins (
    p_type multimedia.media_type%type
  , p_temp_file_name apex_application_temp_files.name%type
  );
  
  ------------------------------------------------------------------------------
  -- procedure ins_collection
  ------------------------------------------------------------------------------
  procedure ins_collection (
    p_type multimedia.media_type%type
  , p_collection_name varchar2
  );
  
  ------------------------------------------------------------------------------
  -- procedure ins_ajax_base64
  ------------------------------------------------------------------------------
  procedure ins_ajax_base64 (
    p_type multimedia.media_type%type
  );

  ------------------------------------------------------------------------------
  -- function convert_media
  ------------------------------------------------------------------------------
  function convert_media (
    p_blob blob
  , p_type multimedia.media_type%type
  , p_query_params varchar2
  ) return blob;

  ------------------------------------------------------------------------------
  -- function get_query_string
  ------------------------------------------------------------------------------
  function get_query_string (
    p_params query_param_tt
  ) return varchar2;

end multimedia_pkg;