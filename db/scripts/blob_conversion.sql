with function load_blob_from_file(filename varchar2, directoryname varchar2)
    return blob
  is
    filecontent blob := null;
    src_file bfile := bfilename(directoryname,filename);
    offset number := 1;
  begin
    dbms_lob.createtemporary(filecontent,true,dbms_lob.session);
    dbms_lob.fileopen(src_file,dbms_lob.file_readonly);
    dbms_lob.loadblobfromfile (filecontent, src_file, dbms_lob.getlength(src_file), offset, offset);
    dbms_lob.fileclose(src_file);
    return filecontent;
  end;
select mtmd.id
     , 'VIDEO' media_type
     , mtmd.video.getSourceName() file_name
     , load_blob_from_file(mtmd.video.getSourceName(), 'VIDEO_DIR') file_content
  from multimedia_old mtmd;