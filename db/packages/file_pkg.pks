create or replace package file_pkg as 

  ------------------------------------------------------------------------------
  -- procedure blob_to_file
  ------------------------------------------------------------------------------
  procedure blob_to_file(
    p_blob in out nocopy blob
  , p_file_name in varchar2
  , p_dir_name in varchar2
  );
  
  ------------------------------------------------------------------------------
  -- function bfile_to_blob
  ------------------------------------------------------------------------------
  function bfile_to_blob (
    p_bfile in bfile
  ) return blob;

  ------------------------------------------------------------------------------
  -- procedure get_file_info
  ------------------------------------------------------------------------------
  function get_file_info (
    p_bfile in bfile
  ) return file_into_t;

end file_pkg;