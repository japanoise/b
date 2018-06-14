; Compile as e.g. fasm hello.asm hello.com
; Directive for .COM files; starts at byte 257, because first 256 bytes are segment
org 256

; Use 16bit
use16

; ah=9 - print string addressed by dx
mov ah,9
mov dx,msg

; execute based on ah
int 21h

; Quit
mov ah,4Ch
int 21h

msg:
db 'Hello World!',0Dh,0Ah,24h
