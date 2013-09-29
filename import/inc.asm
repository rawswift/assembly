.model tpascal
.code

public echo
public echo_2
public echo_pas
public echo_dot
public echo_terminated
public echo_done
public echo_password
public echo_confirm
public echo_six_char
public echo_not_equal
public echo_writing
public echo_invalid;
public echo_option;
public echo_not_found;
public echo_already;
public echo_not_enc;
public oncur
public nocur
public da_name
public help_em
public end_em;

setup proc

  mov ax,@code
  mov ds,ax
  ret

setup endp
echo proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,2
  lea dx,cr_lf
  int 21h
  pop ds
  ret

echo endp

echo_2 proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,4
  lea dx,cr_lf_2
  int 21h
  pop ds
  ret

echo_2 endp

echo_pas proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,1
  lea dx,pas
  int 21h
  pop ds
  ret

echo_pas endp

echo_dot proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,1
  lea dx,dot
  int 21h
  pop ds
  ret

echo_dot endp

echo_terminated proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,15
  lea dx,terminated
  int 21h
  pop ds
  ret

echo_terminated endp

echo_done proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,7
  lea dx,done
  int 21h
  pop ds
  ret

echo_done endp

echo_password proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,11
  lea dx,password
  int 21h
  pop ds
  ret

echo_password endp

echo_confirm proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,11
  lea dx,confirm
  int 21h
  pop ds
  ret

echo_confirm endp

echo_six_char proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,32
  lea dx,six_char
  int 21h
  pop ds
  ret

echo_six_char endp

echo_not_equal proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,23
  lea dx,not_equal
  int 21h
  pop ds
  ret

echo_not_equal endp

echo_writing proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,8
  lea dx,writing
  int 21h
  pop ds
  ret

echo_writing endp

echo_invalid proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,18
  lea dx,invalid
  int 21h
  pop ds
  ret

echo_invalid endp

echo_option proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,25
  lea dx,option
  int 21h
  pop ds
  ret

echo_option endp

echo_not_found proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,17
  lea dx,not_found
  int 21h
  pop ds
  ret

echo_not_found endp

echo_already proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,23
  lea dx,already
  int 21h
  pop ds
  ret

echo_already endp

echo_not_enc proc far

  push ds
  call setup
  mov ah,40h
  mov bx,0001h
  mov cx,19
  lea dx,not_enc
  int 21h
  pop ds
  ret

echo_not_enc endp

oncur proc far

  sub ax,ax
  mov ah,01h
  mov ch,06h
  mov cl,07h
  int 10h
  ret

oncur endp

nocur proc far

  sub ax,ax
  mov ah,01h
  mov ch,20h
  mov cl,20h
  int 10h
  ret

nocur endp

da_name proc far

 push ds
 call setup
 mov ah,40h
 mov bx,0001h
 mov cx,54
 lea dx,msg01
 int 21h
 pop ds
 ret

da_name endp

help_em proc far

 push ds
 call setup
 mov ah,40h
 mov bx,0001h
 mov cx,34
 lea dx,msg02
 int 21h
 pop ds
 ret

help_em endp

end_em proc far

 mov ah,4ch
 mov al,01h
 int 21h
 ret

end_em endp

  cr_lf db 0dh,0ah
  cr_lf_2 db 0dh,0ah,0dh,0ah
  pas db '*'
  dot db '.'
  done db ' done',0dh,0ah
  terminated db '...terminated',0dh,0ah
  password db 'password : '
  confirm db 'confirm  : '
  six_char db 'password requires 6 characters',0dh,0ah
  not_equal db 'password do not match',0dh,0ah
  writing db 'writing '
  invalid db 'invalid password',0dh,0ah
  option db 'Required option missing',0dh,0ah
  not_found db 'File not found - '
  already db '...already encrypted - '
  not_enc db '...not encrypted - '
  msg01 db 'Written by Ryan Yonzon, 1997',0dh,0ah
  msg02 db '    rage < file name > -[e] -[d]',0dh,0ah

    end
