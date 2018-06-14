;;; ms-dos COM file - to assemble, do e.g. fasm hellopixels.asm hellopixels.com
;;; Have tried it on dosbox but not on native hardware - this is an exercise for the reader ;)

; Directive for .COM files; offset labels, because the first 256 bytes are used
; for the PSP
org 256

; Use 16bit
use16

;;; FIRST DEMO - HELLO WORLD
; ah=9 - print string addressed by dx
mov ah,9
mov dx,msg
; execute based on ah
int 21h

; Wait for a key
call waitkey

;;; SECOND DEMO - PIXELS
; Go into CGA mode 13h
mov ah,0
mov al,13h ; AH=0 (Change video mode), AL=13h (Mode)
int 10h ; Video BIOS interrupt

; Draw some pixels
mov ax, 0A000h ; The offset to video memory
mov es, ax ; We load it to ES through AX, becouse immediate operation is not allowed on ES

;; Method one; direct to di
mov ax, 0 ; 0 will put it in top left corner. To put it in top right corner load with 320, in the middle of the screen 32010.
mov di, ax ; load Destination Index register with ax value (the coords to put the pixel)
mov dl, 7 ; Grey color.
mov [es:di], dl ; And we put the pixel

;; Method two; calculate a di value and use that
mov ax,67 ; Y coord
mov bx,112 ; X coord
mov cx,320
mul cx; multiply AX by 320 (cx value)
add ax,bx ; and add X
mov di,ax
mov dl,7 ; grey again
mov [es:di],dl

;; Method three; same as two but as a subroutine
mov ax,10
mov bx,10
push 7
call putpixel

call waitkey

; Go back to mode 3 (the default)
mov ax,3
int 10h

; Quit
mov ah,4Ch
int 21h

waitkey:
mov ah,0
int 16h
ret

; ax - ycoord, bx - xcoord, stack - color
putpixel:
mov cx,320
mul cx
add ax,bx
mov di,ax

pop cx
pop dx
push cx
mov [es:di],dl
ret

msg:
db 'Hello World! Press any key...',0Dh,0Ah,24h
