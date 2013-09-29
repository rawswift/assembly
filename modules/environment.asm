model tiny
codeseg
startupcode

        mov     ax, cs:[002ch]
        mov     ds, ax

        mov     cx, word ptr cs:[0003h]
        mov     dx, 0000h
        mov     bx, 0001h
        mov     ah, 40h
        int     21h

        mov     ax, 4c00h
        int     21h

                end
