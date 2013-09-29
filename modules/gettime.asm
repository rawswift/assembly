model tiny
dataseg

        _msg    db      'The time is $'
        _cr_lf  db      0dh,0ah,'$'

codeseg
startupcode

        lea     dx, _msg
        mov     ah, 09h
        int     21h

        mov     ah, 2ch
        int     21h

        mov     al, ch
        call    digits

        mov     dl, ':'
        mov     ah, 02h
        int     21h

        mov     al, cl
        call    digits

        mov     dl, ':'
        mov     ah, 02h
        int     21h

        mov     al, dh
        call    digits

        mov     ah, 09h
        lea     dx, _cr_lf
        int     21h

        mov     ax, 4c00h
        int     21h

                digits  proc    near

                        sub     ah, ah
                        mov     bl, 10
                        div     bl
                        add     al, 30h
                        mov     dl, al
                        push    ax

                        mov     ah, 02h
                        int     21h

                        pop     ax
                        add     ah, 30h

                        mov     dl, ah
                        mov     ah, 02h
                        int     21h

                        ret

                digits  endp

                        end
