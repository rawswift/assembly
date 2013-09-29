model tiny
dataseg

  _no_mouse     db 'Mouse Driver Is Not Detected',0dh,0ah,'$'
  _mouse_found  db 'Mouse Driver Detected',0dh,0ah,'$'

codeseg
startupcode

        mov     ax, 00h
        int     33h

        cmp     ax, 00h
        je      mouse_not_found

        cmp     ax, -01h
        je      mouse_found

mouse_not_found:

        mov     ah, 09h
        lea     dx, _no_mouse
        int     21h

        mov     al, 01h

        jmp     done

mouse_found:
   
        mov     ah, 09h
        lea     dx, _mouse_found
        int     21h

        mov     al, 00h

done:

        mov     ah, 4ch
        int     21h

                end
