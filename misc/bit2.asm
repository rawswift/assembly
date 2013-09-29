model tiny
dataseg

        buffer db ?

codeseg
startupcode

        jmp     loaded_

                right   db      'System Utility (v3.1) written by Ryan Yonzon '
                        db      '1998',0dh,0ah,0ah

                current_drive db ?
                    
loaded_:            
                    
        mov     cx, 69
        lea     dx, right
        call    disp_em

        mov     ah, 19h
        int     21h

        mov     current_drive, al

        lea     si, vol_label_msg
        add     si, 22
        add     al, 65
        mov     [si], al

        call    get_ver

        cmp     al, 07h
        jne     hell_yeah_2

        cmp     ah, 0ah
        jne     hell_yeah_2

        mov     al, current_drive
        cmp     al, 2
        jl      diskette_drive

        mov     ah, 33h
        mov     al, 05h
        int     21h

        cmp     dl, 3
        jl      hell_yeah_2 

        mov     dl, current_drive
        add     dl, 7eh
        mov     dh, 01h

        call    read_disk

        jmp     hell_yeah

diskette_drive:

        mov     ah, 33h
        mov     al, 05h
        int     21h

        cmp     dl, 2
        jg      hell_yeah_2

        mov     al, current_drive
        inc     al
        cmp     dl, al
        jne     hell_yeah_2

        mov     dl, current_drive
        mov     dh, 00h
        call    read_disk

hell_yeah:

        call    disk_info
        jmp     hell_yeah_3

hell_yeah_2:

        call    get_volume_label

hell_yeah_3:

        sub     si, si

        mov     ax, 160ah
        int     2fh

        or      ax, ax

        jnz     no_gui_detected

        call    convert_version_to_text

        call    squ

        mov     cx, 33
        lea     dx, gui_msg
        call    disp_em

        mov     cx, 5
        lea     dx, _version
        call    disp_em

        call    detected_msg

        call    squ

        mov     cx, 26
        lea     dx, running_under_msg
        call    d_o_s

        call    cr_lf_

        call    display_system_info
      
        mov     al, 00h

        jmp     done_exit

                incorrect_os_version_msg db 'Incorrect DOS version',0dh,0ah

no_gui_detected:

        call    squ

        mov     cx, 30
        lea     dx, dos_msg
        call    d_o_s

        call    cr_lf_

        call    display_system_info

        mov     al, 00h

done_exit:

        mov     ah, 4ch
        int     21h

                gui_msg db 'Graphical User Interface version '
                _version db 'fu.ck'
                dos_msg db 'Disk Operating System version '
                running_under_msg db 'Running under DOS version '

        read_disk       proc    near

                lea     bx, buffer

                mov     ch, 00h
                mov     cl, 01h
                mov     al, 01h
                mov     ah, 02h
                int     13h

                ret

        read_disk       endp

                asterix db '?:\*.*',00h
                no_volume_msg db 'Current drive is '

        get_volume_label        proc    near

                mov     ah, 19h
                int     21h
                mov     current_drive, al

                lea     si, asterix
                add     al, 65
                mov     [si], al

                mov     ah, 4eh
                mov     cx, 08h
                lea     dx, asterix
                int     21h

                call    squ

                jc      no_volume

                mov     cx, 27
                lea     dx, vol_label_msg
                call    disp_em

                lea     dx, ds:9eh
                mov     cx, 8
                call    disp_em

                add     dx, 9
                mov     cx, 3
                call    disp_em

                call    cr_lf_

                jmp     return_from_proc_

        no_volume:

                mov     cx, 17
                lea     dx, no_volume_msg
                call    disp_em

                mov     dl, current_drive
                add     dl, 65
                mov     ah, 02h
                int     21h

                call cr_lf_

        return_from_proc_:

                ret

        get_volume_label        endp

        d_o_s   proc    near

                call    disp_em

                sub     si, si

                call    get_ver

                lea     di, _version
                mov     si, ax
                push    ax
                call    hex_to_ascii

                inc     di
                pop     ax
                mov     al, ah
                call    hex_to_ascii

                mov     cx, 5
                lea     dx, _version
                call    disp_em

                ret

        d_o_s   endp

                oem_msg         db      'Original Equipment Manufacturer identification is '
                oem_format      db      'Yonzon  '
                vol_label_msg   db      'Volume Label in Drive ? is '
                da_label        db      'reality bit'
                sys_fat_msg     db      'File System identification is '
                fat_type        db      'Ryan '

        disk_info       proc    near

                lea     si, buffer

                cmp     current_drive, 2
                jl      not_hard_disk

                lea     di, oem_format
                mov     cx, 8
                add     si, 03h
                cld
           repz movsb

                add     si, 3ch

                jmp     hard_disk_

        not_hard_disk:

                add     si, 43

        hard_disk_:

                lea     di, da_label

                sub     cx, cx
                mov     cx, 11
           repz movsb

                lea     di, fat_type
                mov     cx, 5
           repz movsb

                call    squ

                mov     cx, 27
                lea     dx, vol_label_msg
                call    disp_em

                mov     cx, 11
                lea     dx, da_label
                call    disp_em

                call    cr_lf_

                call    squ

                mov     cx, 30
                lea     dx, sys_fat_msg
                call    disp_em

                mov     cx, 5
                lea     dx, fat_type
                call    disp_em

                cmp     current_drive, 2
                jl      do_not_display_oem

                call    cr_lf_
        
                call    squ

                mov     cx, 50
                lea     dx, oem_msg
                call    disp_em

                mov     cx, 8
                lea     dx, oem_format
                call    disp_em

        do_not_display_oem:

                call    cr_lf_

                ret

        disk_info       endp


        display_system_info     proc    near

                call    count_the_number_of_drive_s

                call    bios_date

                call    cr_lf_

                call    boot_system

                mov     ah, 00h
                mov     al, 00h
                int     33h

                cmp     ax, -01h
                jne     no_mouse_driver

                call    squ

                mov     cx, 12
                lea     dx, mouse_detected_msg
                call    disp_em

                call    detected_msg

        no_mouse_driver:

                mov     ah, 43h
                mov     al, 00h
                int     2fh

                cmp     al, 80h
                jne     _return

                call    squ

                mov     cx, 10
                lea     dx, xms_detected_msg
                call    disp_em

                call    detected_msg

        _return:

                 call   get_ems

                 call   number_of_port_s

                 call   cr_lf_

                 call   game_port
 
                 call   squ

                 call   printer

                 call   cr_lf_

                 call   get_video

                 ret

        display_system_info     endp

                mouse_detected_msg      db      'Mouse driver'
                xms_detected_msg        db      'XMS driver'

        disp_em         proc    near

                mov     ah, 40h
                mov     bx, 0001h
                int     21h
                ret

        disp_em         endp

        cr_lf_          proc    near

                mov     ah, 40h
                mov     bx, 0001h
                mov     cx, 2
                lea     dx, cr_lf
                int     21h

                ret

                        cr_lf   db      0dh,0ah

        cr_lf_          endp

        hex_to_ascii    proc    near

                aam
                or ax,3030h
                xchg ah,al
                stosw
                ret

        hex_to_ascii    endp

        convert_version_to_text         proc    near

                lea     di, _version

                mov     al, bh
                mov     si, ax
                call    hex_to_ascii

                inc     di
                mov     al, bl
                call    hex_to_ascii
                ret

        convert_version_to_text         endp

        bios_date       proc    near

                call    squ

                mov     cx, 34
                lea     dx, bios
                call    disp_em

                push    ds

                mov     ah, 240
                mov     al, 0
                mov     ds, ax
        
                mov     ah, 255
                mov     al, 245
                mov     dx, ax
                mov     cx, 8
                call    disp_em

                pop ds
        
                ret

        bios_date       endp

                bios    db      'Basic Input/Output System Date is '

        get_ver         proc    near

                mov     ah, 30h
                mov     al, 00h
                int     21h
                ret

        get_ver         endp

        boot_system     proc    near

                call    squ
                            
                mov     cx, 23
                lea     dx, boot_msg
                call    disp_em

                mov     ah, 33h
                mov     al, 05h
                int     21h

                mov     ah, 02h
                add     dl, 40h
                int     21h

                call    cr_lf_

                ret

                        boot_msg        db      'System Booted in Drive '

        boot_system     endp

        squ     proc    near

                mov     ah, 02h
                mov     dl, ' '
                int     21h

                mov     ah, 02h
                mov     dl, ' '
                int     21h

                mov     ah, 02h
                mov     dl, ' '
                int     21h

                mov ah,02h
                mov dl,'þ'
                int 21h

                mov ah,02h
                mov dl,' '
                int 21h
                ret

        squ     endp
            
        get_ems         proc    near

                mov     ah, 35h
                mov     al, 67h
                int     21h

                sub     ax, ax
                mov     ax, es

                cmp     ax, 0000h
                je      no_ems

                call    squ

                lea     dx, ems_detected_msg
                mov     cx, 10
                call    disp_em

                call    detected_msg

        no_ems:

                ret

        get_ems         endp

                ems_detected_msg        db      'EMS driver'

        number_of_port_s        proc    near

                int     11h

                mov     bx, ax

                and     ax, 0e00h
                mov     serial, ax

                and     bx, 0c000h
                mov     parallel, bx

                push    ax
                call    squ
                pop     ax

                mov     cl, 9
                shr     ax, cl
                call    convert_to_text

                mov     cx, 21
                lea     dx, serial_msg
                call    disp_em

                call    cr_lf_

                call    squ

                mov     ax, parallel
                mov     cl, 14
                shr      ax,cl
                call     convert_to_text

                mov     cx, 23
                lea     dx, parallel_msg
                call    disp_em

                ret

        number_of_port_s        endp

                serial          dw      ?
                parallel        dw      ?
                serial_msg      db      ' serial port(s) found'
                parallel_msg    db      ' parallel port(s) found'
                _ascii          db      7 dup('$')

        convert_to_text         proc    near
  
                lea     si, _ascii
        
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
                mov     [si], al
                inc     si
                loop    pop_loop

                mov     ah, 09h
                lea     dx, _ascii
                int     21h

                ret

        convert_to_text         endp

        game_port       proc    near

                mov     dx, 201h
                mov     al, 1
                out     dx, al
                jmp     short $+2
                in      al, dx
                and     al, 0fh
                cmp     al, 0fh
                jne     no_game_port

                call    squ

                mov     cx, 21
                lea     dx, game_port_installed_msg
                call    disp_em

        no_game_port:

                ret

                game_port_installed_msg db 'Game port installed',0dh,0ah

        game_port       endp

                number_of_diskette      db ?
                number_of_hard_disk     db ?
                drive_number            db ?

        count_the_number_of_drive_s proc near

                mov     number_of_diskette, 0
                mov     number_of_hard_disk, 0 
                mov     drive_number, 3

                int     11h

                test    ax, 1

                jz      no_diskette

                push    ax
                call    squ
                pop     ax

                and     ax, 000c0h
                mov     cl, 6
                shr     ax, cl
                inc     ax
                call    convert_to_text

                mov     cx, 18
                lea     dx, diskette_drive_msg
                call    disp_em

                call    detected_msg

        no_diskette:

                mov     ah, 1ch
                mov     dl, drive_number
                push    ds
                int     21h
                mov     al, ds:[bx]
                pop     ds

                mov     bx, 0
                cmp     al, 0f8h

                jne      all_done_exit

                inc     number_of_hard_disk
                inc     drive_number

                jmp     no_diskette

        all_done_exit:

                call    squ

                sub     ax, ax
                mov     al, number_of_hard_disk
                call    convert_to_text

                mov     cx, 19
                lea     dx, hard_disk_msg
                call    disp_em

                call    detected_msg

                ret

        count_the_number_of_drive_s endp

                diskette_drive_msg      db ' diskette(s) drive'
                hard_disk_msg           db ' hard disk(s) drive'

        detected_msg    proc    near

                mov ah,40h
                mov bx,0001h
                mov cx,11
                lea dx,detected
                int 21h

                ret

                detected        db      ' detected',0dh,0ah

        detected_msg    endp

        printer         proc    near

                sub     ax, ax
                int     11h

                test    ah, 11000000b
                jnz     printer_detected

                jmp     printer_return

        printer_detected:

                mov     cx, 19
                lea     dx, printer_detected_msg
                call    disp_em

        printer_return:

                ret

        printer         endp

                printer_detected_msg db 'Printer(s) detected'

        get_video       proc    near

                mov     ah, 1ah
                mov     al, 00h
                int     10h

                call    squ

                cmp     bl, 00h
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

                cmp     bl, 0bh
                je      mcga_mono

                cmp     bl, 0ch
                je      mcga_color

                cmp     bl, 0dh
                je      reserved_exp

                cmp     bl, 255
                je      unknown_monitor

        no_display:

                mov     ah, 09h
                lea     dx, no_display_msg
                int     21h
                jmp     return_video

        mono:

                lea     dx, mono_msg
                call    display_video_msg

                jmp     return_video

        cga:

                lea     dx, cga_color_msg
                call    display_video_msg
                jmp     return_video

        reserved:

                lea     dx, reserved_msg
                call    display_video_msg
                jmp     return_video

        ega_color:

                lea     dx, ega_color_msg
                call    display_video_msg
                jmp     return_video

        ega_mono:

                lea     dx, ega_mono_msg
                call    display_video_msg
                jmp     return_video

        pro_gra:

                lea     dx, pro_gra_msg
                call    display_video_msg
                jmp     return_video

        vga_mono:

                lea     dx, vga_mono_msg
                call    display_video_msg
                jmp     return_video

        vga_color:

                lea     dx, vga_color_msg
                call    display_video_msg
                jmp     return_video

        mcga_mono:
                        
                lea     dx, mcga_mono_msg
                call    display_video_msg
                jmp     return_video

        mcga_color:

                lea     dx, mcga_color_msg
                call    display_video_msg
                jmp     return_video

        reserved_exp:

                lea     dx, reserved_exp_msg
                call    display_video_msg
                jmp     return_video

        unknown_monitor:

                lea     dx, unknown_msg
                call    display_video_msg

        return_video:

                call    cr_lf_

                ret

        get_video       endp

        display_video_msg        proc   near

                mov     ah, 09h
                int     21h

                mov     ah, 09h
                lea     dx, _creditz_msg
                int     21h

                ret

        display_video_msg       endp

        no_display_msg db 'No Display$'
        mono_msg db 'Mono with monochrome monitor$'
        cga_color_msg db 'CGA with color monitor$'
        reserved_msg db 'Reserved$'
        ega_color_msg db 'EGA with color monitor$'
        ega_mono_msg db 'EGA with monochrome monitor$'
        pro_gra_msg db 'Professional Graphics System with color monitor$'
        vga_mono_msg db 'VGA with analog monochrome monitor$'
        vga_color_msg db 'VGA with analog color monitor$'
        mcga_mono_msg db 'MCGA with analog monochrome monitor$'
        mcga_color_msg db 'MCGA with analog color monitor$'
        reserved_exp_msg db 'Reserved for expansion$'
        unknown_msg db 'Unknown type of monitor$'

       _creditz_msg db 0dh,0ah,0dh,0ah,'DISCLAIMER: The author does not take any responsability for any',0dh,0ah
                    db 'damage, either direct or implied, caused by the usage of this program',0dh,0ah
                    db 'No warrant is made about the product functionability or quality.$'

      end
