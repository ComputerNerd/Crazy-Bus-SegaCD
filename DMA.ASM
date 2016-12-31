DoDMAtoCRAM:            ; Does DMA to CRAM
 MOVE.L #CPORT, A1
 MOVE.L A0, D1          ; D0 = WORDs to transfer
 LSR.L  #1, D1          ; A0 = source address
 MOVE.L D1, A0
 MOVE.W D0, D1          
 AND.W  #$00FF, D1      
 OR.W   #$9300, D1
 MOVE.W D1, (A1)
 LSR.W  #8, D0
 OR.W   #$9400, D0
 MOVE.W D0, (A1)
 MOVE.L A0, D0
 MOVE.W #$9500, D1
 OR.B   D0, D1
 MOVE.W D1, (A1)
 LSR.L  #8, D0
 MOVE.W #$9600, D1
 OR.B   D0, D1
 MOVE.W D1, (A1)
 LSR.L  #8, D0
 AND.B  #$7F, D0
 MOVE.W #$9700, D1
 OR.B   D0, D1
 MOVE.W D1, (A1)
 MOVE.L #$C0000080, (A1)
 RTS

DoDMAtoVRAM:            ; Does DMA to VRAM
 MOVE.L #CPORT, A1      ; D0 = WORDs to transfer                        
 MOVE.L #$94009300, D1  ; D2 = VRAM address
 OR.B   D0, D1          ; A0 = source address
 LSR.W  #8, D0
 SWAP   D0
 CLR.W  D0
 OR.L   D0, D1
 MOVE.L D1, (A1)
 MOVE.L A0, D0          
 LSR.L  #1, D0          
 MOVE.L #$97009500, D1
 OR.B   D0, D1
 LSR.W  #8, D0
 OR.W   #$9600, D0
 MOVE.W D0, (A1)        ; MID
 SWAP   D0
 SWAP   D1
 AND.B  #$3F, D0
 OR.B   D0, D1
 MOVE.L D1, (A1)        ; LOW, HIGH
 OR.B   #$80, D2
 MOVE.L D2, (A1)
 RTS

