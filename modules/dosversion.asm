model tiny
dataseg

        _the_version    db      'MS-Dos version - $'
        _dos_ver        db      '??.??',0dh,0ah,'$'

codeseg
startupcode

        mov     ax, 3000h
        int     21h

        sub     si, si
        lea     di, _dos_ver
        mov     si, ax
        push    ax
        call    hex_to_dec

        inc     di
        pop     ax
        mov     al, ah
        call    hex_to_dec
        sub     ax, ax

        mov     ah, 09h
        lea     dx, _the_version
        int     21h

        mov     ah, 09h        
        lea     dx, _dos_ver
        int     21h

        mov     ax,4c00h
        int     21h

        hex_to_dec      proc    near

                        aam
                        or      ax, 3030h
                        xchg    ah, al
                        stosw
                        ret

        hex_to_dec      endp

                        end
