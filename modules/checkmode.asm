model tiny
dataseg
 right db 'Check Mode written by Ryan Yonzon'
       db ' 1997-1998',0dh,0ah,0ah
 gui db 'G.U.I. - '
 no_gui db 'none',0dh,0ah
 gui_found db 'detected',0dh,0ah
 ver db 'Version - '
 win_ver db '??.??'
 ver_in_win db ' / Windows',0dh,0ah
 ver_in_dos db ' / Dos',0dh,0ah
 mode db 'Mode - '
 standard db 'standard / real',0dh,0ah
 enhanced db 'enhanced / protected',0dh,0ah

codeseg
startupcode

 mov cx,65
 lea dx,right
 call disp_em

 mov cx,9
 lea dx,gui
 call disp_em

 sub si,si

 mov ax,160ah
 int 2fh

 or ax,ax

 jnz no_gui_found

 call convert_ver

 mov cx,10
 lea dx,gui_found
 call disp_em

 mov cx,15
 lea dx,ver
 call disp_em

 mov cx,12
 lea dx,ver_in_win
 call disp_em

 mov cx,7
 lea dx,mode
 call disp_em

 mov cx,22
 lea dx,enhanced

 call disp_em

 mov al,01h

 jmp da_end

no_gui_found:

 mov cx,6
 lea dx,no_gui
 call disp_em

 sub si,si

 mov ah,30h
 int 21h

 lea di,win_ver
 mov si,ax
 push ax
 call text_em

 inc di
 pop ax
 mov al,ah
 call text_em

 mov cx,15
 lea dx,ver
 call disp_em

 mov cx,8
 lea dx,ver_in_dos
 call disp_em

 mov cx,7
 lea dx,mode
 call disp_em

 mov cx,17
 lea dx,standard
 call disp_em

 mov al,00h

da_end:

 mov ah,4ch
 int 21h

disp_em proc near

  mov ah,40h
  mov bx,0001h
  int 21h
  ret

disp_em endp

text_em proc near

 aam
 or ax,3030h
 xchg ah,al
 stosw
 ret

text_em endp

convert_ver proc near

 lea di,win_ver

 mov al,bh
 mov si,ax
 call text_em

 inc di
 mov al,bl
 call text_em
 ret

convert_ver endp

   end
