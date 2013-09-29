model tiny
dataseg

                _msg    db      'Today is $'
                _sun    db      'Sunday',0dh,0ah,'$'
                _mon    db      'Monday',0dh,0ah,'$'
                _tue    db      'Tuesday',0dh,0ah,'$'
                _wed    db      'Wednesday',0dh,0ah,'$'
                _thu    db      'Thursday',0dh,0ah,'$'
                _fri    db      'Friday',0dh,0ah,'$'
                _sat    db      'Saturday',0dh,0ah,'$'
                _daytab dw      _sun, _mon, _tue, _wed, _thu, _fri, _sat
        
codeseg
startupcode

        lea     dx, _msg
        mov     ah, 09h
        int     21h

        mov     ah, 2ah
        int     21h

        add     al, al
        cbw

        mov     si, ax
        lea     bx, _daytab

        mov     dx, [bx + si]

        mov     ah, 09h
        int     21h

        mov     ax, 4c00h
        int     21h

                end
