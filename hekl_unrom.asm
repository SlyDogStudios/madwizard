.include "includes\constants.asm"
.include "includes\music_declarations.asm"

.segment "ZEROPAGE"
.include "includes\zp.asm"

.include "includes\bank00\bank00.asm"		; enemies
.include "includes\bank01\bank01.asm"		; backgrounds
.include "includes\bank02\bank02.asm"		; graphics
.include "includes\bank03\bank03.asm"		; manual pages 1
.include "includes\bank04\bank04.asm"		; manual graphics 1
.include "includes\bank05\bank05.asm"		; manual pages 2, flappy bird bonus
.include "includes\bank06\bank06.asm"		; manual graphics 2
.include "includes\bankFixed\bankFixed.asm"	; main code (bankswitching, vectors)
