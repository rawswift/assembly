model tiny
dataseg

        _sys_boot_msg   db      'System Booted in Drive $'
        _cr_lf          db      0dh,0ah,'$'

codeseg
startupcode

        mov     ah, 09h
        lea     dx, _sys_boot_msg
        int     21h

        mov     ah, 33h
        mov     al, 05h
        int     21h

        add     dl, 40h
        mov     ah, 02h
        int     21h

        mov     ah, 09h
        lea     dx, _cr_lf
        int     21h

        mov     ax, 4c00h
        int     21h

                end
