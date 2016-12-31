*//////////////////////////////////////////////////////////////////////////////
* Genitile demo 1
*
* www.pascalorama.com
*//////////////////////////////////////////////////////////////////////////////        
*// Includes
*//////////////////////////////////////////////////////////////////////////////       
	include sega.asm
	include genesis.inc				
*//////////////////////////////////////////////////////////////////////////////        				
*// Variables defining

vtimer  equ	$ff0000     ;long
frame	equ	vtimer+4	; frame idx
x	equ	frame+4
y	equ	x+4
blit	equ	y+2
dir	equ	blit+2
vx	equ	dir+2

*//////////////////////////////////////////////////////////////////////////////        				
*// Main
*//////////////////////////////////////////////////////////////////////////////
				
_main:                
	move.w	#1,frame
	move	#88,x
	move	#328,y
	move.w	#0,blit
	move.w	#0,dir
	move.w	#1,vx
	
	move.w      sr,-(sp)            ; disable interrupt
        or.w        #$700,sr

* Init VDP

        lea         GFXCTRL,a0          ; GFX Control
        move        #$8016,(a0)         ; reg. 80, Enable Hor. Sync
        move        #$8174,(a0)         ; reg. 81, Enable Ver. Sync + Fast transfer
        move        #$8238,(a0)         ; reg. 82, A plane left half location = $E000
        move        #$8338,(a0)         ; reg. 83, A plane right half location = $E000
        move        #$8407,(a0)         ; reg. 84, B plane location = $E000
        move        #$8560,(a0)         ; reg. 85, Sprite data table $C000
        move        #$8600,(a0)         ; reg. 86, ?
        move        #$8710,(a0)         ; reg. 87, Background color #16
        move        #$8801,(a0)         ; reg. 88, ?
        move        #$8901,(a0)         ; reg. 89, ?
        move        #$8a01,(a0)         ; reg. 8a, 
        move        #$8b00,(a0)         ; reg. 8b, enabled interrupt 2
        move        #$8c00,(a0)         ; reg. 8c, 40 cells mode 
        move        #$8d2e,(a0)         ; reg. 8d,
        move        #$8f02,(a0)         ; reg. 8f, 
        move        #$9000,(a0)         ; reg. 90,
        move        #$9100,(a0)         ; reg. 91,
        move        #$92ff,(a0)         ; reg. 92,

        move.w      (sp)+,sr 

* Fill the palette

        move.l	   #$c0000000,GFXCTRL  
        move.w     #31,d0
        lea        rick_pal,a0
loopp:  move.w     (a0)+,GFXDATA
        dbf        d0,loopp

* Load the tiles

        move.l     #$40000000,GFXCTRL
        move.w     #$d58,d0               ; (spoutnick:11936 bytes+rick:1728 bytes)/4
        lea        rick_tiles,a0
loopt:  move.l     (a0)+,GFXDATA
        dbf        d0,loopt       

* Fill the tile map

        move.l      #$60000003,GFXCTRL
        move.w      #$448,d0                ;counter : 32*28=896 tiles
        lea        spk_map,a0
loopm:
        move.l  (a0)+,GFXDATA                                    
        dbf	d0,loopm  	       

* main loop
loop: 
	
* display the sprite	

	move.l     #$40000003,GFXCTRL     ; Write to $C000 Sprite list    
	
	move	frame,d1
	mulu	#9,d1

	move	dir,d2
	tst	d2
	beq	noflip
	or.w	#$0800,d1
noflip

        move.w      y,GFXDATA	; Y
        move.w      #$a00,GFXDATA	; sprite size
        move.w      d1,GFXDATA		; tile number
        move.w      x,GFXDATA	; x

	move	vx,d3
	add	d3,x

	addq	#1,blit
	andi	#3,blit
	bne	fps

	cmp	#400,x
	ble	dirswitch1
	eori	#1,dir
	neg	vx
dirswitch1
	cmp	#88,x
	bge	dirswitch2
	eori	#1,dir
	neg	vx
dirswitch2
	
	cmp	#5,frame
	bge	reninit
	addq	#1,frame
	bra	fps
reninit	
	move	#1,frame
fps
 
* vsync
        clr.l       d0
        move.l      vtimer,d0
vloop   cmp.l       vtimer,d0
        beq         vloop
	
        bra loop

*//////////////////////////////////////////////////////////////////////////////
* Data includes
*//////////////////////////////////////////////////////////////////////////////

* map
        include data/spkm.asm
* pals  
	include data/rickp.asm      
        include data/spkp.asm				
* tiles  
	include data/rickt.asm
        include data/spkt.asm

        org $20000             
