*-------------------------------------------------------------------------
*
*       Setup the port registers to read joysticks.
*
*-------------------------------------------------------------------------

port_setup:
                moveq       #$40,d0
                move.b      d0,$a10009
                move.b      d0,$a1000b
                move.b      d0,$a1000d
                rts

*-------------------------------------------------------------------------
*
*       Check for input from Joypad 1.
*
*       Input:
*               None
*       Output:
*               Status of Joypad 1
*       Registers used:
*               d0, d1
*
*-------------------------------------------------------------------------

porta:
                moveq       #0,d0
                move.b      #$40,$a10003
                nop
                nop
                move.b      $a10003,d1
                andi.b      #$3f,d1
                move.b      #0,$a10003
                nop
                nop
                move.b      $a10003,d0
                andi.b      #$30,d0
                lsl.b       #2,d0
                or.b        d1,d0
                not.b       d0
                rts
