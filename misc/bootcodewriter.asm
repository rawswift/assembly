model tiny
codeseg
startupcode

; write bootstrap program

        lea     dx, _file_name
        mov     ah, 3dh
        mov     al, 00h
        int     21h

        xchg    ax, bx
        push    bx

        mov     ah, 3fh
        mov     cx, 512
        lea     dx, _buffer
        int     21h

        mov     ah, 3eh
        pop     bx
        int     21h

        mov     dl, 00h
        mov     dh, 00h
        mov     ch, 00h
        mov     cl, 01h
        mov     al, 01h
        mov     ah, 03h
        lea     bx, _buffer
        int     13h

        mov     ah, 09h
        lea     dx, _msg
        int     21h

        mov     ax, 4c00h
        int     21h

        _buffer         db      512 dup(0)
        _file_name      db      'boot.bin',00h
        _msg            db      'Bootstrap program has been written succesfully',0dh,0ah,'$'

        end
                        
