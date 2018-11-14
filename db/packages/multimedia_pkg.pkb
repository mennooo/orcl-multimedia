create or replace package body multimedia_pkg as

  ------------------------------------------------------------------------------
  -- function get_media_dir
  ------------------------------------------------------------------------------
  function get_media_dir (
    p_type multimedia.media_type%type
  ) return media_dir_t
  is
  begin
  
    return case p_type
      when gc_media_type_image then image_pkg.gc_image_dir
      when gc_media_type_audio then audio_pkg.gc_audio_dir
      when gc_media_type_video then video_pkg.gc_video_dir
    end;
  
  end get_media_dir;

  ------------------------------------------------------------------------------
  -- procedure ins
  ------------------------------------------------------------------------------
  procedure ins (
    p_type multimedia.media_type%type
  , p_temp_file_name apex_application_temp_files.name%type
  ) as
    l_blob blob;
    l_file_name apex_application_temp_files.filename%type;
    l_file_name_unique apex_application_temp_files.filename%type;
    l_mime_type apex_application_temp_files.mime_type%type;
    l_media_dir media_dir_t;
    l_id multimedia.id%type;
  begin
  
    select blob_content
         , filename
         , mime_type
      into l_blob
         , l_file_name
         , l_mime_type
      from apex_application_temp_files
     where name = p_temp_file_name;
     
    l_media_dir := get_media_dir(p_type);
    
    l_id := mtmd_id_seq.nextval();
    
    -- make name unique
    l_file_name_unique := substr(l_id || '_' || l_file_name, 1, 255);
     
    file_pkg.blob_to_file(
      p_blob => l_blob
    , p_file_name => l_file_name_unique
    , p_dir_name => l_media_dir
    );
    
    insert into multimedia (id, media_type, file_name, mime_type, file_locator)
    values (l_id, p_type, l_file_name, l_mime_type, bfilename(l_media_dir, l_file_name_unique));
    
  end ins;

  ------------------------------------------------------------------------------
  -- procedure ins_collection
  ------------------------------------------------------------------------------
  procedure ins_collection (
    p_type multimedia.media_type%type
  , p_collection_name varchar2
  ) as
    l_blob blob;
    l_file_name apex_application_temp_files.filename%type;
    l_file_name_unique apex_application_temp_files.filename%type;
    l_mime_type apex_application_temp_files.mime_type%type;
    l_media_dir media_dir_t;
    l_id multimedia.id%type;
    
    cursor c_files (
      b_collection_name varchar2
    ) is
      select c001 filename
           , c002 mime_type
           , blob001 blob_content
        from apex_collections
       where collection_name = p_collection_name;
    
  begin
  
    for rec in c_files(p_collection_name) loop
     
      l_media_dir := get_media_dir(p_type);
      
      l_id := mtmd_id_seq.nextval();
      
      -- make name unique
      l_file_name_unique := substr(l_id || '_' || rec.filename, 1, 255);
       
      file_pkg.blob_to_file(
        p_blob => rec.blob_content
      , p_file_name => l_file_name_unique
      , p_dir_name => l_media_dir
      );
      
      insert into multimedia (id, media_type, file_name, mime_type, file_locator)
      values (l_id, p_type, rec.filename, rec.mime_type, bfilename(l_media_dir, l_file_name_unique));
    
    end loop;
    
  end ins_collection;

  ------------------------------------------------------------------------------
  -- procedure ins
  ------------------------------------------------------------------------------
  procedure ins_ajax_base64 (
    p_type multimedia.media_type%type
  ) as
    l_blob blob;
    l_file_name apex_application_temp_files.filename%type;
    l_file_name_unique apex_application_temp_files.filename%type;
    l_mime_type apex_application_temp_files.mime_type%type;
    l_media_dir media_dir_t;
    l_id multimedia.id%type;
  begin
  
    l_blob := apex_web_service.clobbase642blob(apex_application.g_clob_01);
    l_file_name := apex_application.g_x01;
    l_mime_type := apex_application.g_x02;
     
    l_media_dir := get_media_dir(p_type);
    
    l_id := mtmd_id_seq.nextval();
    
    -- make name unique
    l_file_name_unique := substr(l_id || '_' || l_file_name, 1, 255);
     
    file_pkg.blob_to_file(
      p_blob => l_blob
    , p_file_name => l_file_name_unique
    , p_dir_name => l_media_dir
    );
    
    insert into multimedia (id, media_type, file_name, mime_type, file_locator)
    values (l_id, p_type, l_file_name, l_mime_type, bfilename(l_media_dir, l_file_name_unique));
    
  end ins_ajax_base64;

  ------------------------------------------------------------------------------
  -- procedure ins_blob
  ------------------------------------------------------------------------------
  procedure ins_blob (
    p_blob in out nocopy blob
  , p_file_name varchar2
  , p_mime_type varchar2
  , p_type multimedia.media_type%type
  ) is
    l_file_name_unique apex_application_temp_files.filename%type;
    l_media_dir media_dir_t;
    l_id multimedia.id%type;
  begin
     
    l_media_dir := get_media_dir(p_type);
    
    l_id := mtmd_id_seq.nextval();
    
    -- make name unique
    l_file_name_unique := substr(l_id || '_' || p_file_name, 1, 255);
     
    file_pkg.blob_to_file(
      p_blob => p_blob
    , p_file_name => l_file_name_unique
    , p_dir_name => l_media_dir
    );
    
    insert into multimedia (id, media_type, file_name, mime_type, file_locator)
    values (l_id, p_type, p_file_name, p_mime_type, bfilename(l_media_dir, l_file_name_unique));
  
  end ins_blob;

  ------------------------------------------------------------------------------
  -- function convert_media
  ------------------------------------------------------------------------------
  function convert_media (
    p_blob blob
  , p_file_name varchar2
  , p_mime_type varchar2
  , p_type multimedia.media_type%type
  , p_query_params varchar2
  ) return blob
  is
    l_blob blob;
    l_length number;
  
    l_parts utl_http_multipart.parts := utl_http_multipart.parts();
    l_http_request utl_http.req;
  
    l_http_response utl_http.resp;
  
    l_offset number := 1;
    l_amount number := 2000;
    l_buffer raw(2000);
    
    l_raw            RAW(32767);
  begin
  
    utl_http_multipart.add_file(l_parts, lower(p_type), p_file_name, p_mime_type, p_blob);
    
    utl_http.set_transfer_timeout(300); --seconds
  
    l_http_request := utl_http.begin_request(
      url => gc_convert_base_url || lower(p_type) || p_query_params
    , method => 'POST'
    , http_version => 'HTTP/1.1'
    );
    
    utl_http_multipart.send(l_http_request, l_parts);
  
    l_http_response := utl_http.get_response(l_http_request);
    DBMS_LOB.createtemporary(l_blob, FALSE);
    BEGIN
      LOOP
        UTL_HTTP.read_raw(l_http_response, l_raw, 32767);
        DBMS_LOB.writeappend (l_blob, UTL_RAW.length(l_raw), l_raw);
      END LOOP;
    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        UTL_HTTP.end_response(l_http_response);
    END;
  
--    utl_http.read_text(l_http_response, l_response_body, 32767);
    return l_blob;
    
  end convert_media;

  ------------------------------------------------------------------------------
  -- function get_query_string
  ------------------------------------------------------------------------------
  function get_query_string (
    p_params query_param_tt
  ) return varchar2
  is
    l_idx pls_integer;
    l_query_string varchar2(4000);
  begin
  
    if p_params.count = 0 then
      return null;
    end if;
  
    l_idx := p_params.first();
    
    l_query_string := '?' || p_params(l_idx);
    
    l_idx := p_params.next(l_idx);
    
    while l_idx is not null loop
    
      l_query_string := l_query_string || '&' || p_params(l_idx);
    
      l_idx := p_params.next(l_idx);
    
    end loop;
  
    return l_query_string;
    
  end get_query_string;

end multimedia_pkg;