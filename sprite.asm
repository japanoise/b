;;; Draws a very adorable 8*8 Kona on the screen
	org 256
	use16

	;; Go into VGA mode 13h
	mov ah,0
	mov al,13h 		; AH=0 (Change video mode), AL=13h (Mode)
	int 10h			; Video BIOS interrupt

	;; Setup ES; else the pixel code will fuck up
	mov ax, 0A000h 		; The offset to video memory
	mov es, ax 		; We load it to ES through AX, because immediate operation is not allowed on ES

	;; Draw the sprite
	mov si,sprite		; sprite
	mov ax,10 		; ycoord
	mov bx,100		; xcoord
	call drawsprite

	call waitkey

	;; Go back to mode 3 (the default)
	mov ax,3
	int 10h

	;; Quit
	mov ah,4Ch
	int 21h

;;; Functions begin here
waitkey:
	mov ah,0
	int 16h
	ret

putpixel:			; ax - ycoord, bx - xcoord, stack - color
	mov cx,320
	mul cx
	add ax,bx
	mov di,ax

	pop cx
	pop dx
	push cx
	mov [es:di],dl
	ret

drawsprite:			; ax - ycoord, bx - xcoord, si - sprite
	mov dx,0		; loop
spriteloop:
	;; Don't draw if the color is 0
	cmp word [si],0
	je transp

	;; Calculate the offsets
	push dx
	push ax
	push bx
	mov ax,dx
	mov dx,0
	mov cx,8
	div cx
	mov bx,dx

	;; Now ax and bx are y and x offsets; we need to add the original values
	pop cx 			; orig bx
	pop dx			; orig ax
	push dx
	push cx
	add ax,dx
	add bx,cx
	push word [si]
	call putpixel
	pop bx
	pop ax
	pop dx
transp:
	;; Loop round again
	add dx,1
	add si,2
	cmp dx,40h
	jne spriteloop
	ret

;;; Data begins here
	blue = 0x2020
	tran = 0x0000
	lblu = 0x3535
	whit = 0x0F0F
	skin = 0x5959
	gren = 0x0303
	pink = 0x3F3F

sprite: 			; Simple 8*8 sprite
	dw lblu,lblu,lblu,tran,tran,tran,tran,tran
	dw tran,tran,lblu,lblu,lblu,blue,tran,tran
	dw tran,lblu,blue,lblu,blue,lblu,blue,tran
	dw lblu,blue,skin,lblu,skin,lblu,blue,tran
	dw tran,blue,gren,skin,gren,lblu,blue,skin
	dw tran,lblu,skin,skin,skin,lblu,skin,skin
	dw lblu,blue,pink,pink,lblu,skin,skin,tran
	dw lblu,blue,whit,whit,lblu,whit,blue,tran
