model tiny
dataseg

        _bios_date      db      'Basic Input / Output System release date is $'
        _cr_lf          db      0dh,0ah,'$'

codeseg
startupcode


        mov     ah, 09h
        lea     dx, _bios_date
        int     21h

        push    ds

        mov     ah, 240
        mov     al, 0
        mov     ds, ax

        mov     ah, 255
        mov     al, 245

        mov     dx, ax
        mov     cx, 8
        mov     bx, 0001h
        mov     ah, 40h
        int     21h

        pop     ds

        mov     ah, 09h
        lea     dx, _cr_lf
        int     21h

        mov     ax, 4c00h
        int     21h

                end
