model tiny
codeseg
startupcode

        mov     dl, 00h
        mov     dh, 00h
        mov     ch, 00h
        mov     cl, 01h
        mov     al, 01h
        mov     ah, 02h
        lea     bx, _buffer
        int     13h

        mov     ah, 40h
        mov     cx, 512
        mov     bx, 0001h
        lea     dx, _buffer
        int     21h

        mov     ax, 4c00h
        int     21h
        

        _buffer        db      512 dup (0)


        end        
