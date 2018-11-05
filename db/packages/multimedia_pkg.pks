create or replace package multimedia_pkg as 

  subtype media_dir_t is varchar2(30);
  
  gc_media_type_image multimedia.media_type%type := 'IMAGE';
  gc_media_type_audio multimedia.media_type%type := 'AUDIO';
  gc_media_type_video multimedia.media_type%type := 'VIDEO';
  
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
  -- function convert_media
  ------------------------------------------------------------------------------
  function convert_media (
    p_bfile bfile
  , p_query_params varchar2
  ) return blob;

end multimedia_pkg;