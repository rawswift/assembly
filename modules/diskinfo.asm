model tiny
dataseg

        _drv_num         db      ?
        _error_msg       db      'Error in Accessing Drive',0dh,0ah,'$'
        _cr_lf           db      0dh,0ah,'$'
        _buffer          db      60 dup(?)
        _format          db      8 dup(0)
        _da_label        db      11 dup(0)
        _fat_type        db      5 dup(0)

codeseg
startupcode

        mov     ah, 19h
        int     21h

        mov     _drv_num, al

        cmp     al, 2
        je      info_c

        cmp     al, 0
        je      info_a

        mov     ah, 09h
        lea     dx, _error_msg
        int     21h

        mov     al, 01h

        jmp     done

info_c:

        mov     dl, 80h
        mov     dh, 01h

        call    read_disk

        mov     al, 00h     

        jmp     done

info_a:

        mov     dl, 00h
        mov     dh, 00h

        call    read_disk

        mov     al, 00h

done:

        mov     ah,4ch
        int     21h

        read_disk       proc    near

                lea     bx, _buffer
                mov     ch, 00h
                mov     cl, 01h
                mov     al, 01h
                mov     ah, 02h
                int     13h

                lea     di, _format
                lea     si, _buffer
                mov     cx, 8
                inc     si
                inc     si
                inc     si
                cld
          repz movsb

                lea     di, _da_label

                cmp     _drv_num, 2
                je      hard_disk

                mov     cx, 32
                jmp     da_loop

        hard_disk:

                mov     cx, 60

        da_loop:

                inc     si
                loop    da_loop

                sub     cx, cx
                mov     cx, 11
           repz movsb

                lea     di, _fat_type
                mov     cx, 5
           repz movsb

                call    cr_lf_

                mov     cx, 8
                lea     dx, _format
                call    disp_em

                call    cr_lf_

                mov     cx, 11
                lea     dx, _da_label
                call    disp_em

                call    cr_lf_

                mov     cx, 5
                lea     dx, _fat_type
                call    disp_em

                call    cr_lf_

                ret

        read_disk       endp

        disp_em         proc    near

                mov     ah, 40h
                mov     bx, 0001h
                int     21h
                ret

        disp_em         endp

        cr_lf_  proc    near

                mov     ah, 09h
                lea     dx, _cr_lf
                int     21h
                ret

        cr_lf_  endp

   end
