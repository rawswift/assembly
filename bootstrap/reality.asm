model tiny
codeseg
startupcode

reality:

      jmp    begin      ; EB 2A 90 as per normal

      db     'REALITY '
      dw     512        ; sector size in bytes
      db     1          ; sectors per cluster
      dw     1          ; reserved clusters
      db     2          ; number of fats
      dw     224        ; root directory entries
      dw     2880       ; total sectors
      db     0F0h       ; format id
      dw     9          ; sectors per fat
      dw     18         ; sectors per track
      dw     2          ; sides
      dw     0          ; special hidden sectors
      db     0          ; physical drive
      db     0          ; reserved
      db     29h        ; signature byte
      db     0          ; volume serial number
      db     'REALITY    '
      db     'FAT12   '

begin:

        mov     ax, 07C0h   ; boot record location

        push    ax
        pop     ds

        mov     bx, message_offset  ; put offset to message into si
        mov     cx, message_length  ; message length from cx

continue:

        mov     ah, 14      ; write teletype
        mov     al, [bx]

        push    ds
        push    cx
        push    bx

        int     10h

        pop     bx
        pop     cx
        pop     ds

        inc     bx

        loop    continue

        mov     ah, 0       ; read next keyboard character
        int     16h

        mov     ah, 15      ; get video mode
        int     10h

        mov     ah, 0       ; set video mode (clears screen)
        int     10h

        int     19h        ; re-boot

message_start:

        db      0dh,0ah,'Bootstrap code written by Ryan Yonzon, 1997.',0dh,0ah
        db      'Insert MS-DOS bootable diskette & press any key to continue...',0dh,0ah

message_end:

tail:

        message_offset  equ     message_start - reality
        message_length  equ     message_end - message_start

        filler_amount   equ     512 - (tail - reality) - 2

        db      filler_amount   dup(0)      ; filler

        db      055h, 0AAh                  ; boot id

                end
