model tiny
dataseg

        _msg            db      'The date is $'
        _da_date        db      '??-??-????',0dh,0ah,'$'

codeseg
startupcode

        mov     ah, 09h
        lea     dx, _msg
        int     21h

        sub     ax, ax

        mov     ah, 2ah
        int     21h

        lea     di, _da_date

        mov     al, dh
        call    hex_to_dec

        inc     di

        mov     al, dl
        call    hex_to_dec

        inc     di

        mov     ax, cx
        call    convert_em

        sub     ax, ax

        mov     ah, 09h
        lea     dx, _da_date
        int     21h

        mov     ax, 4c00h
        int     21h


        hex_to_dec      proc    near

                        aam
                        or      ax, 3030h
                        xchg    ah, al
                        stosw
                        ret

        hex_to_dec      endp

        convert_em      proc    near
  
                        mov     bx, 10
                        mov     cx, 0

        da_loop:

                        mov     dx, 0
                        div     bx
                        push    dx
                        inc     cx
                        cmp     ax, 0
                        jne     da_loop

        pop_loop:

                        pop     ax
                        add     al, '0'
                        mov     [di], al
                        inc     di
                        loop    pop_loop

                        ret

        convert_em      endp

                        end
