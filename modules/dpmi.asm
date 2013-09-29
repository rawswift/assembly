model tiny
dataseg

        _no_dpmi        db      'No DOS Protected-Mode Interface detected.',0dh,0ah,'$'
        _no_32          db      '32-bit programs are NOT supported.',0dh,0ah,'$'
        _32             db      '32-bit programs ARE supported.',0dh,0ah,'$'
        _p286           db      'Processer is an 80286.',0dh,0ah,'$'
        _p386           db      'Processer is an 80386.',0dh,0ah,'$'
        _p486           db      'Processer is an 80486 or Pentium.',0dh,0ah,'$'
        _punknown       db      'Unidentified Processer.',0dh,0ah,'$'

codeseg
startupcode

        mov     ax, 1687h
        int     2fh

        or      ax, ax
        jz      show_b

        lea     dx, _no_dpmi
        mov     ah, 09h
        int     21h

        jmp     done

show_b:

        or      bx, bx
        jnz     supported_32

        lea     dx, _no_32
        mov     ah, 09h
        int     21h

        jmp     show_p

supported_32:

        lea     dx, _32
        mov     ah, 09h
        int     21h

show_p:

        cmp     cl, 2
        jnz     cpu286

        lea     dx, _p286
        jmp     cpu_type

cpu286:

        cmp     cl, 3
        jnz     cpu386

        lea     dx, _p386
        jmp     cpu_type

cpu386:

        cmp     cl, 4
        jnz     cpu486

        lea     dx, _p486
        jmp     cpu_type

cpu486:

        lea     dx, _punknown

cpu_type:

        mov     ah, 09h
        int     21h

done:

        mov     ax, 4c00h
        int     21h

                end
