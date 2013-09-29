model tiny
codeseg
startupcode

        mov     bx, -1
        mov     es, bx

        mov     bx, 3
        mov     dx, word ptr es:[bx]

        mov     bx, 1
        mov     ax, word ptr es:[bx]

        mov     word ptr _restart + 2, dx
        mov     word ptr _restart, ax

        call    dword ptr _restart

                _restart        label   dword

                end
