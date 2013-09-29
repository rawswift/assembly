model tiny
dataseg

        _no_win        db      'Windows is not detected',0dh,0ah,'$'
        _window        db      'Windows '
        _win_ver       db      '??.??'
                       db      ' is detected and running in $'
        _standard      db      'standard mode',0dh,0ah,'$'
        _enhanced      db      'enhanced mode',0dh,0ah,'$'

codeseg
startupcode

        sub     si, si

        mov     ax, 160ah
        int     2fh

        lea     dx, _no_win
        or      ax, ax

        jnz     the_end

        lea     di, _win_ver
        mov     al, bh
        mov     si, ax

        call    chk_em

        inc     di
        mov     al, bl
        call    chk_em

        mov     ah, 09h
        lea     dx, _window
        int     21h

        lea     dx, _standard
        cmp     cl, 02h

        jz      the_end

        lea     dx, _enhanced

the_end:

        mov     ah, 09h
        int     21h

        mov     ax, si

        mov     ax, 4c00h
        int     21h

        chk_em  proc    near

                aam
                or      ax, 3030h
                xchg    ah, al
                stosw

                ret

        chk_em  endp

                end
