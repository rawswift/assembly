model tiny
dataseg

   _serial_msg  db ' Serial and $'
   _parallel_msg db ' Parallel Port(s) found in the System',0dh,0ah,'$'

   _serial      dw      ?
   _parallel    dw      ?

   _ascii       db      7 dup('$')

codeseg
startupcode

        int     11h

        mov     bx, ax

        and     ax, 0e00h
        mov     _serial, ax

        and     bx, 0c000h
        mov     _parallel, bx

        mov     cl, 9
        shr     ax, cl
        call    hex_to_dec

        push    ax

        mov     ah, 09h
        lea     dx, _serial_msg
        int     21h

        pop     ax

        mov     ax, _parallel
        mov     cl, 14
        shr     ax, cl
        call    hex_to_dec

        mov     ah, 09h
        lea     dx, _parallel_msg
        int     21h

        mov     ax,4c00h
        int     21h

        hex_to_dec       proc    near
  
                lea     si, _ascii

                cmp     ax, 0
                jge     positive
                neg     ax
                mov     byte ptr [si], '-'
                inc     si

        positive:

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

        hex_to_dec      endp

                end
