{$F+}
{$L inc.obj}

program Encrypt_Decrypt;

uses crt, dos;
type
 rec = record
   element : char;
   file_pos : integer;
  end;

var

 thefile : text;
 open_the_file : file of char;
 data : rec;
 file_of_rec : file of rec;
 last_file : text;
 count : integer;
 param01, param02 : string;
 bufferx : string[7];
 thechar : char;
 stop : boolean;
 esc : boolean;
 the_same : boolean;
 pass : string;
 confirm : string;
 size : longint;

procedure echo;external;
procedure echo_2;external;
procedure echo_pas;external;
procedure echo_dot;external;
procedure echo_password;external;
procedure echo_invalid;external;
procedure echo_writing;external;
procedure echo_six_char;external;
procedure echo_confirm;external;
procedure echo_terminated;external;
procedure echo_not_equal;external;
procedure echo_done;external;
procedure echo_option;external;
procedure echo_not_found;external;
procedure echo_already;external;
procedure echo_not_enc;external;
procedure da_name;external;
procedure help_em;external;
procedure end_em;external;
procedure oncur;external;
procedure nocur;external;

procedure help;
 begin
  da_name;
  echo;
  help_em;
 end;

procedure fx(str : string);
 begin
  echo_2;
  write('...',str,'  - ');
   nocur;
  for count := 1 to 100 do
   begin
    delay(35);
     gotoxy(19, wherey);write(count,'%');
   end;
 end;


procedure get_pass;
 var
  six : boolean;
 begin

  the_same := false;

while not the_same do
 begin

  six := false;

 while not six do
  begin
  echo;
  echo_password;
  stop := false;
  esc := false;
  pass := '';
  count := 0;

   while (not stop) and (not esc) do
    begin
     thechar := readkey;
       if thechar = #13 then
        begin
         stop := true;
        end else if thechar = #27 then
         begin
          esc := true;
         end else
          begin
           inc(thechar, 11);
           pass := pass + thechar;
            echo_pas;
             inc(count, 1);
          end;
    end;

   if esc then
    begin
     echo_2;
     echo_terminated;
      end_em;
    end;

     if count = 6 then
      begin
       six := true;
      end else
       begin
        echo_2;
         echo_six_char;
       end;

  end;

  echo;
   echo_confirm;
  stop := false;
  esc := false;
  confirm := '';
   while (not stop) and (not esc) do
    begin
     thechar := readkey;
       if thechar = #13 then
        begin
         stop := true;
        end else if thechar = #27 then
         begin
          esc := true;
         end else
          begin
           inc(thechar, 11);
           confirm := confirm + thechar;
            echo_pas;
          end;
    end;

   if esc then
    begin
     echo_2;
     echo_terminated;
      end_em;
    end;

    if pass = confirm then
      begin
       the_same := true;
      end else
       begin
        echo_2;
         echo_not_equal;
       end;

 end;

 end;

procedure test_pass;
 begin

  echo_password;
   while (not stop) and (not esc) do
    begin
     thechar := readkey;
      if thechar = #13 then
       begin
        stop := true;
       end else if thechar = #27 then
        begin
         esc := true;
        end else
         begin
           inc(thechar, 11);
          pass := pass + thechar;
          echo_pas;
         end;
    end;

      if esc then
       begin
        echo_2;
        echo_terminated;
         end_em;
       end;

 end;

function upper(str : string) : string;
  var
    thechar : char;
    thestr : string;
    thelength : integer;
   begin
     thelength := length(str);
      thestr := '';
     repeat
       move(str[1], thechar, 1);
        thestr := thestr + upcase(thechar);
        delete(str, 1, 1);
       thelength := thelength - 1;
     until thelength = 0;
    upper := thestr;
   end;

procedure encrypt_file;
 begin

  da_name;

    get_pass;

      close(open_the_file);

         fx('encrypting');

     echo_2;
      echo_writing;

       assign(thefile, param01);
        reset(thefile);
             echo_dot;
          assign(file_of_rec, '$$$$$$$$.$$$');
            rewrite(file_of_rec);
             echo_dot;
              count := 0;

            while not eof(thefile) do
             begin
              read(thefile, thechar);
              inc(thechar, 26);
               data.element := thechar;
                inc(count, 1);
                 data.file_pos := count;
                  write(file_of_rec, data);
             end;

             echo_dot;
               close(thefile);
                erase(thefile);
             echo_dot;
               close(file_of_rec);
                rename(file_of_rec, param01);

             echo_dot;
                  assign(open_the_file, param01);
                   reset(open_the_file);
             echo_dot;
                    assign(thefile, '$$$$$$$$.$$$');
                     rewrite(thefile);
                      write(thefile, 'RAGE(r)');
             echo_dot;
                       seek(open_the_file, 0);

                    while not eof(open_the_file) do
                      begin
                        read(open_the_file, thechar);
                        write(thefile, thechar);
                      end;
             echo_dot;
                        write(thefile, confirm);
                         close(open_the_file);
                          erase(open_the_file);
             echo_dot;
                         close(thefile);
                          rename(thefile, param01);
             echo_dot;
                          echo_done;
                           echo;
                            writeln(param01,' is encrypted');
                             oncur;

 end;

procedure decrypt_file;
 begin

  da_name;
   echo;
     test_pass;

      seek(open_the_file, filesize(open_the_file) - 6);
        while not eof(open_the_file) do
          begin
           read(open_the_file, thechar);
             confirm := confirm + thechar;
          end;

            if pass <> confirm then
             begin
              echo_2;
               echo_invalid;
               end_em;
             end;


           fx('decrypting');

            echo_2;
             echo_writing;

             echo_dot;

         size := filesize(open_the_file) - 6;
          seek(open_the_file, 7);
           assign(thefile, '$$$$$$$$.$$$');
            rewrite(thefile);
             echo_dot;
              stop := false;
            while not eof(open_the_file) and not stop do
             begin
              read(open_the_file, thechar);
              write(thefile, thechar);
               if filepos(open_the_file) = size then
                 begin
                  stop := true;
                 end;
             end;

             echo_dot;
               close(open_the_file);
                erase(open_the_file);
             echo_dot;
               close(thefile);
                rename(thefile, param01);

             echo_dot;
                 assign(file_of_rec, param01);
                  reset(file_of_rec);
             echo_dot;
                 assign(thefile, '$$$$$$$$.$$$');
                  rewrite(thefile);

             echo_dot;
                   while not eof(file_of_rec) do
                     begin
                       read(file_of_rec, data);
                        thechar := data.element;
                         dec(thechar, 26);
                       write(thefile, thechar);
                     end;

             echo_dot;
                       close(file_of_rec);
                        erase(file_of_rec);
             echo_dot;
                       close(thefile);
                        rename(thefile, param01);
             echo_dot;
                          echo_done;
                           echo;
                          writeln(param01,' is decrypted');
                             oncur;

 end;

begin                          { MAIN }

 param01 := paramstr(1);
  if param01 = '' then
   begin
    help;
     end_em;
   end;

          assign(open_the_file, param01);
            {$I-}
              reset(open_the_file);
               if ioresult <> 0 then
                begin
                 echo_not_found;
                  writeln(param01);
                  end_em;
                end;
             {$I+}

   param02 := paramstr(2);
     if param02 = '' then
      begin
        echo_option;
        end_em;
      end;

   if upper(param02) = '-E' then
    begin
      seek(open_the_file, 0);
       bufferx := '';
        for count := 1 to 7 do
         begin
          read(open_the_file, thechar);
           bufferx := bufferx + thechar;
         end;
          if bufferx = 'RAGE(r)' then
           begin
            echo_already;
             writeln(param01);
             end_em;
           end else
            begin

              encrypt_file;

            end;

    end else if upper(param02) = '-D' then
     begin
      seek(open_the_file, 0);
       bufferx := '';
        for count := 1 to 7 do
         begin
          read(open_the_file, thechar);
           bufferx := bufferx + thechar;
         end;
          if bufferx <> 'RAGE(r)' then
           begin
            echo_not_enc;
             writeln(param01);
             end_em;
           end else
            begin

              decrypt_file;

            end;

     end else
      begin
       writeln('Invalid parameter ',param02);
      end;

end.                           { MAIN }
