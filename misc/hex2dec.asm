.model small
.code

  org 100h

da_start:

  jmp convert_em

   ascii db 7 dup('$')

convert_em proc near
  
  mov ax,0012h    ; give a value for convertion

  lea si,ascii
  cmp ax,0
  jge positive
  neg ax
  mov byte ptr [si],'-'
  inc si

positive:

  mov bx,10
  mov cx,0

da_loop:

  mov dx,0
  div bx
  push dx
  inc cx
  cmp ax,0
  jne da_loop

pop_loop:

  pop ax
  add al,'0'
  mov [si],al
  inc si
  loop pop_loop

  mov ah,09h
  lea dx,ascii
  int 21h

  mov ax,4c00h
  int 21h

convert_em endp

   end da_start
