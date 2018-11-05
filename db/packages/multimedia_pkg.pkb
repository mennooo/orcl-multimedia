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
      when gc_media_type_image then null
      when gc_media_type_audio then null
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
    l_media_dir media_dir_t;
    l_id multimedia.id%type;
  begin
  
    select blob_content
         , filename
      into l_blob
         , l_file_name
      from apex_application_temp_files
     where name = p_temp_file_name;
     
    l_media_dir := get_media_dir(p_type);
    
    l_id := mtmd_id_seq.nextval();
     
    file_pkg.blob_to_file(
      p_blob => l_blob
    , p_file_name => substr(l_id || '_' || l_file_name, 1, 255) -- make name unique
    , p_dir_name => l_media_dir
    );
    
    insert into multimedia (id, media_type, file_name, file_locator)
    values (l_id, p_type, l_file_name, bfilename(l_media_dir, l_file_name));
    
  end ins;

  ------------------------------------------------------------------------------
  -- function convert_media
  ------------------------------------------------------------------------------
  function convert_media (
    p_bfile bfile
  , p_query_params varchar2
  ) return blob
  is
    l_blob blob;
    l_length number;
  
    l_http_request utl_http.req;
  
    l_http_response utl_http.resp;
  
    l_offset number := 1;
    l_amount number := 2000;
    l_buffer raw(2000);
  begin
  
    l_http_request := utl_http.begin_request(
      url => 'localhost:3000/video?size=200,200&ext=mp4'
    , method => 'POST'
    , http_version => 'HTTP/1.1'
    );
  
--    apex_web_service.blob2clobbase64(l_attachment) 
  
    utl_http.set_header(l_http_request, 'Content-Type', 'multipart/form-data; boundary="X-ORACLE-BOUNDARY"');
    utl_http.set_header(l_http_request, 'Content-Length', l_length);
    utl_http.set_header(l_http_request, 'Transfer-Encoding', 'Chunked');
  
    while l_offset < l_length loop
      dbms_lob.read(p_bfile, l_amount, l_offset, l_buffer);
      utl_http.write_raw(l_http_request, l_buffer);
      l_offset := l_offset + l_amount;
    end loop;
  
    l_http_response := utl_http.get_response(l_http_request);
  
--    utl_http.read_text(l_http_response, l_response_body, 32767);
    return l_blob;
    
  end convert_media;

end multimedia_pkg;