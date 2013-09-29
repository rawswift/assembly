model tiny
dataseg

        _no_display_msg  db      'No Display',0dh,0ah,'$'
        _mono_msg        db      'Mono with monochrome monitor',0dh,0ah,'$'
        _cga_color_msg   db      'CGA with color monitor',0dh,0ah,'$'
        _reserved_msg    db      'Reserved',0dh,0ah,'$'
        _ega_color_msg   db      'EGA with color monitor',0dh,0ah,'$'
        _ega_mono_msg    db      'EGA with monochrome monitor',0dh,0ah,'$'
        _pro_gra_msg     db      'Professional Graphics System with color monitor',0dh,0ah,'$'
        _vga_mono_msg    db      'VGA with analog monochrome monitor',0dh,0ah,'$'
        _vga_color_msg   db      'VGA with analog color monitor',0dh,0ah,'$'
        _mcga_mono_msg   db      'MCGA with analog monochrome monitor',0dh,0ah,'$'
        _mcga_color_msg  db      'MCGA with analog color monitor',0dh,0ah,'$'
        _reserved_exp_msg db     'Reserved for expansion',0dh,0ah,'$'
        _unknown_msg     db     'Unknown type of monitor',0dh,0ah,'$'

codeseg
startupcode

        mov     ah, 1ah
        mov     al, 00h
        int     10h

        cmp     bl, 00
        je      no_display

        cmp     bl, 01h
        je      mono

        cmp     bl, 02h
        je      cga

        cmp     bl, 03h
        je      reserved

        cmp     bl, 04h
        je      ega_color

        cmp     bl, 05h
        je      ega_mono

        cmp     bl, 06h
        je      pro_gra

        cmp     bl, 07h
        je      vga_mono

        cmp     bl, 08h
        je      vga_color

        cmp     bl, 09h
        je      reserved

        cmp     bl, 0ah
        je      reserved

        cmp     bl,0bh
        je      mcga_mono

        cmp     bl, 0ch
        je      mcga_color

        cmp     bl, 0dh
        je      reserved_exp

        cmp     bl, 255
        je      unknown_monitor

no_display:

        mov     ah, 09h
        lea     dx, _no_display_msg
        int     21h
        jmp     done

mono:

        mov     ah, 09h
        lea     dx, _mono_msg
        int     21h
        jmp     done

cga:

        mov     ah, 09h
        lea     dx, _cga_color_msg
        int     21h
        jmp     done

reserved:

        mov     ah, 09h
        lea     dx, _reserved_msg
        int     21h
        jmp     done

ega_color:

        mov     ah, 09h
        lea     dx, _ega_color_msg
        int     21h
        jmp     done

ega_mono:

        mov     ah, 09h
        lea     dx, _ega_mono_msg
        int     21h
        jmp     done

pro_gra:

        mov     ah, 09h
        lea     dx, _pro_gra_msg
        int     21h
        jmp     done

vga_mono:

        mov    ah, 09h
        lea     dx, _vga_mono_msg
        int     21h
        jmp      done

vga_color:

        mov     ah, 09h
        lea     dx, _vga_color_msg
        int     21h
        jmp     done

mcga_mono:

        mov     ah, 09h
        lea     dx, _mcga_mono_msg
        int     21h
        jmp     done

mcga_color:

        mov     ah, 09h
        lea     dx, _mcga_color_msg
        int     21h
        jmp     done

reserved_exp:

        mov     ah, 09h
        lea     dx, _reserved_exp_msg        
        int     21h
        jmp     done

unknown_monitor:

        mov     ah, 09h
        lea     dx, _unknown_msg
        int     21h

done:

        mov     ax, 4c00h
        int     21h

                end
