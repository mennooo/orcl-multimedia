create or replace package body file_pkg as

  ------------------------------------------------------------------------------
  -- procedure blob_to_file
  ------------------------------------------------------------------------------
  procedure blob_to_file (
    p_blob in out nocopy blob
  , p_file_name in varchar2
  , p_dir_name in varchar2
  ) as
      l_file      utl_file.file_type;
      l_buffer    raw(32767);
      l_amount    binary_integer := 32767;
      l_pos       integer := 1;
      l_blob_len  integer;
  begin
  
    l_blob_len := dbms_lob.getlength(p_blob);
    
    -- open the destination file.
    l_file := utl_file.fopen(p_dir_name,p_file_name,'wb', 32767);
  
    -- read chunks of the blob and write them to the file
    -- until complete.
    while l_pos <= l_blob_len loop
      dbms_lob.read(p_blob, l_amount, l_pos, l_buffer);
      utl_file.put_raw(l_file, l_buffer, true);
      l_pos := l_pos + l_amount;
    end loop;
    
    -- close the file.
    utl_file.fclose(l_file);
    
  exception
    when others then
      -- close the file if something goes wrong.
      if utl_file.is_open(l_file) then
        utl_file.fclose(l_file);
      end if;
      raise;
  end blob_to_file;

  ------------------------------------------------------------------------------
  -- procedure blob_to_file
  ------------------------------------------------------------------------------
  function get_file_info (
    p_bfile in bfile
  ) return file_into_t
  is
    l_file_name varchar2(255);
    l_file_dir varchar2(255);
    l_file_length number;
    l_file_exists number;
  begin
  
    dbms_lob.filegetname(p_bfile,l_file_dir,l_file_name);
    l_file_length := dbms_lob.getlength(p_bfile);
    l_file_exists := dbms_lob.fileexists(p_bfile);
  
    return file_into_t(
      file_name => l_file_name
    , file_length => l_file_length
    , file_exists => l_file_exists
    , file_dir => l_file_dir
    );
  
  end get_file_info;

end file_pkg;