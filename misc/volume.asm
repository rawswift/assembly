model tiny
codeseg
startupcode

 mov cx,61
 lea dx,_dry_run_str
 call onscreen

 call cr_lf

 xor cx,cx

 mov si,80h
 mov cl,[si]
 mov _com_line_param_len,cl
 cmp cl,00h
 je no_command_line_parameter

 cmp cl,01h
 je one_byte_intercepted

 dec cx
 mov si,82h
 lea di,_new_volume_label_name
repnz movsb

 call check_if_vol_label_exist
 push ax
 cmp ax,9090h
 je create_new_volume_label

 call two_five_four

 mov cx,20
 lea dx,_deleted_str
 call onscreen

 mov cx,11
 lea dx,cs:9eh
 call onscreen

 call delete_the_current_vol_label

 call cr_lf

create_new_volume_label:

 mov ah,65h
 mov al,21h
 mov cx,11
 lea dx,_new_volume_label_name
 int 21h

 call update_the_volume_label

 call two_five_four

 pop ax
 cmp ax,9090h
 jne volume_label_change

 mov cx,20
 lea dx,_created_str
 call onscreen
 jmp go_go_go

volume_label_change:

 mov cx,26
 lea dx,_updated_str
 call onscreen

go_go_go:

 mov cx,11
 lea dx,_new_volume_label_name
 call onscreen

 call cr_lf

 mov al,00h
 jmp all_done

no_command_line_parameter:

 call two_five_four

 mov cx,96
 lea dx,_usage_str
 call onscreen

 call cr_lf

 mov al,01h
 jmp all_done

one_byte_intercepted:

 sub ax,ax
 mov si,81h
 mov al,[si]
 cmp al,3bh
 jne no_command_line_parameter

 call check_if_vol_label_exist
 cmp ax,9090h
 je all_done

 call delete_the_current_vol_label

 call two_five_four

 mov cx,34
 lea dx,_vol_deleted_str
 call onscreen

 call cr_lf

 mov al,00h

all_done:

 mov ah,4ch
 int 21h

        _dry_run_str db 'Disk Volume Label changer, written by Ryan Yonzon.',0dh,0ah
        _com_line_param_len db ?
        _new_volume_label_name db 11 dup(20h)
        _asterix db '?:\*.*',00h
        _hell_yeah db '...hell yeah'
        _created_str db 'New volume label is '    ; 20
        _required_parameter_missing_str db 'Error : required parameter missing' ; 34
        _deleted_str db 'Old volume label is '  ; 19
        _no_vol_label_str db 'Drive ? has no volume label'
        _fcb db 43 dup(20h)
        _wild_card db 11 dup('?')
        _updated_str db 'Volume label is change to '    ; 26
        _vol_deleted_str db 'Volume label in Drive ? is deleted'
        _usage_str db 'volume [label]       create or change volume label',0dh,0ah
                db ' þ volume;              delete current volume label'
        _write_this_str db ' þ '

onscreen proc near

 mov ah,40h
 mov bx,0001h
 int 21h
 ret

onscreen endp

cr_lf proc near

 mov cx,2
 lea dx,_cr_lf
 call onscreen
 ret
        _cr_lf db 0dh,0ah
        
cr_lf endp

check_if_vol_label_exist proc near

 xor ax,ax
 mov ah,19h
 int 21h

 lea si,_asterix
 add al,65
 mov [si],al

 lea si,_no_vol_label_str
 add si,6
 mov [si],al

 lea si,_vol_deleted_str
 add si,22
 mov [si],al

 mov ah,4eh
 mov cx,08h
 lea dx,_asterix
 int 21h

 jc no_volume_label_were_found

 mov ax,0000h
 jmp return

no_volume_label_were_found:

 call two_five_four

 mov cx,27
 lea dx,_no_vol_label_str
 call onscreen

 call cr_lf

 mov ax,9090h

return:

 ret

check_if_vol_label_exist endp

delete_the_current_vol_label proc near

 lea di,_fcb

 mov al,0ffh
 mov [di],al

 add di,6
 mov al,08h
 mov [di],al

 add di,1
 mov al,00h
 mov [di],al

 add di,1
 lea si,_wild_card
 mov cx,11
repnz movsb

 xor ax,ax
 mov ah,13h
 lea dx,_fcb
 int 21h

 ret

delete_the_current_vol_label endp

update_the_volume_label proc near

 lea di,_fcb

 mov al,0ffh
 mov [di],al

 add di,6
 mov al,08h
 mov [di],al

 add di,1
 mov al,00h
 mov [di],al

 add di,1
 lea si,_new_volume_label_name
 mov cx,11
repnz movsb

 xor ax,ax
 mov ah,16h
 lea dx,_fcb
 int 21h

 ret

update_the_volume_label endp

two_five_four proc near

 mov cx,3
 lea dx,_write_this_str
 call onscreen

 ret

two_five_four endp
            
 mov cx,8
 lea dx,cs:9eh
 call onscreen

 mov cx,3
 lea dx,cs:9eh
 add dx,9
 call onscreen

        end
