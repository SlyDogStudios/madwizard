loop_finito:
	jsr flicker_em
	jmp end_loop

nmi_won1:
	lda ppu_addy+1
	sta $2006
	lda ppu_addy+0
	sta $2006
	lda #$00
	sta $2007
	inc ppu_addy+0
	bne :++
		inc ppu_addy+1
		lda ppu_addy+1
		cmp #$24
		bne :++
			lda #<nmi_won2
			sta nmi_pointer+0
			lda #>nmi_won2
			sta nmi_pointer+1
			ldx #$00
			stx temp_8bit_1
			lda #$ff
:			sta p_top_left, x
			inx
			cpx #$10
			bne :-
:
	jmp end_nmi

nmi_won2:
	ldx temp_8bit_1
	lda line_lo, x
	sta temp_16bit_1+0
	lda line_hi, x
	sta temp_16bit_1+1
	lda line_addy_lo, x
	sta ppu_addy+0
	lda line_addy_hi, x
	sta ppu_addy+1
	lda line_stop, x
	sta temp_8bit_2

	ldy #$00
	lda ppu_addy+1
	sta $2006
	lda ppu_addy+0
	sta $2006
:	lda (temp_16bit_1), y
	sta $2007
	iny
	cpy temp_8bit_2
	bne :-
	inc temp_8bit_1
	lda temp_8bit_1
	cmp #$06
	bne :+
			lda #<nmi_done
			sta nmi_pointer+0
			lda #>nmi_done
			sta nmi_pointer+1
:
	jmp end_nmi
nmi_done:
	jmp end_nmi
line_lo:
	.byte <line1,<line2,<line3,<line4,<line5,<line6
line_hi:
	.byte >line1,>line2,>line3,>line4,>line5,>line6
line_addy_lo:
	.byte $03,$43,$83,$c3,$03,$93
line_addy_hi:
	.byte $21,$21,$21,$21,$22,$22

line_stop:
	.byte 22,25,26,23,13,7
line1:
	.byte "HAVING RID THE LAND OF"
line2:
	.byte "AMONDUS, HEKL WAS A HERO!"
line3:
	.byte "THE KING BECKONED HIM, AND"
line4:
	.byte "THUS BEGINS HIS ROLE IN"
line5:
	.byte $5b,"CANDELABRA",$5b,"."
line6:
	.byte "THE END"

;HEKL DEFEATS THE EVIL SUMMONER AMONDUS. THE PRIMWOODS ARE SAVED.
;HE RECEIVES A HERO'S INVITE TO THE KING'S COURT TO SERVE ON A NOBLE QUEST.
;SO BEGINS HIS ROLE IN THE SAGA OF "CANDELABRA".
;THE END

;AFTER DESTROYING THE EVIL SUMMONER AMONDUS, HEKL REGAINED CONTROL OF THE PRIMWOODS
;HAILED AS A HERO, HE WAS INVITED TO THE KING'S COURT TO SERVE ON A MOST NOBLE QUEST
;SO BEGINS HIS ROLE IN THE SAGA OF "CANDELABRA"

;THE END
