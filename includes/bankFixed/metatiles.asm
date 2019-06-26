; 16x16 metatiles
; $00-open,$01-wood solid,$02-wood walk,$03-wood high ceiling,$04-web left home,$05-crate,$06-barrel,$07-ladder
; $08-bed left,$09-bed right,$0a-chair,$0b-table,$0c-torch left,$0d-torch right,$0e-cave_walk,$0f-cave_solid
; $10-cave_ceiling,$11-cave walk ceiling,$12-pedastal,$13-column,$14-web right,$15-grass,$16-dirt
; $17-tree base,$18-tree bark,$19-branch left short,$1a-branch left long ON tree,$1b-left root,$1c-right root
; $1d-left branch long,$1e-branch right short,$1f-right branch long,$20-small tree bottom branch $21-small tree top branch
; $22-bush,$23-brick,$24-branch thick,$25-branch thick taper left,$26-branch thick taper right,$27-canopy solid
; $28-canopy empty bottom,$29-CV block,$2a-water top,$2b-water bottom,$2c-concrete top ($16-dirt is filler)
; $2d-column,$2e-pillar top,$2f-pillar bottom,$30-headstone,$31-gargoyle,$32-perch,$33-shaved bark bottom
; $34-shaved bark top,$35-flame,$36-water top on bottom,$37-vine

; original canopy $9c,$9d,$9d,$9c
tile16_a:
	.byte $00,$c0,$c4,$c0,$b8,$b0,$b4,$2e,$ca,$cc,$ce,$be,$6f,$00,$d0,$d2
	.byte $d4,$d0,$a0,$a2,$ae,$9a,$aa,$90,$90,$81,$83,$00,$00,$83,$87,$85
	.byte $85,$85,$96,$5f,$8b,$8b,$8b,$60,$64,$a4,$9e,$9f,$a8,$a2,$a0,$00
	.byte $70,$74,$78,$90,$7e,$d8,$00,$89
tile16_b:                                
	.byte $00,$c1,$c4,$c1,$b9,$b1,$b5,$2f,$cb,$cd,$00,$bf,$00,$6f,$d1,$d3
	.byte $d5,$d1,$a1,$a3,$af,$9b,$ab,$91,$91,$82,$85,$00,$00,$85,$88,$86
	.byte $86,$86,$97,$5f,$8b,$8b,$8b,$63,$65,$a5,$9e,$9f,$a9,$a3,$a1,$00
	.byte $71,$75,$79,$91,$7f,$d9,$00,$00
tile16_c:                                
	.byte $00,$c2,$c2,$c5,$ba,$b2,$b6,$2e,$c7,$c8,$cf,$c7,$bb,$00,$d2,$d4
	.byte $d6,$d6,$a2,$a2,$00,$aa,$ac,$93,$91,$89,$93,$00,$95,$00,$84,$00
	.byte $00,$00,$98,$5f,$8c,$8c,$8e,$64,$00,$a6,$9f,$9f,$aa,$a2,$a2,$a0
	.byte $72,$76,$7a,$7c,$91,$da,$9e,$00
tile16_d:                                
	.byte $00,$c3,$c3,$c6,$00,$b3,$b7,$2f,$c8,$c9,$00,$c9,$00,$bd,$d3,$d5
	.byte $d7,$d7,$a3,$a3,$ad,$ab,$aa,$94,$90,$00,$91,$92,$00,$8a,$8a,$00
	.byte $00,$00,$99,$5f,$8c,$8d,$8d,$65,$00,$a7,$9f,$9f,$ab,$a3,$a3,$a1
	.byte $73,$77,$7b,$7d,$90,$db,$9e,$00

; 32x32 metatiles - four bytes=16x16 metatiles, one byte=attribute table, one byte=collision
;  collision: 0=open, 1=ladder, 2=hurt, 3=solid
tile32_a:	; topleft 16x16 metatile
	.byte $00,$00,$01,$03,$01,$01,$00,$00,$00,$05,$00,$01,$03,$00,$00,$0d
	.byte $07,$01,$02,$02,$02,$00,$00,$0a,$00,$0f,$0f,$11,$00,$0e,$07,$00
	.byte $10,$0f,$00,$10,$00,$0e,$00,$00,$00,$05,$11,$00,$04,$0f,$0f,$00
	.byte $15,$00,$18,$19,$18,$00,$00,$19,$00,$00,$1e,$00,$00,$1f,$00,$00
	.byte $21,$00,$16,$00,$23,$23,$23,$23,$00,$00,$06,$00,$07,$1f,$00,$00
	.byte $03,$00,$00,$00,$01,$27,$27,$27,$27,$00,$00,$1f,$00,$00,$00,$23
	.byte $23,$23,$00,$23,$00,$24,$24,$16,$00,$16,$00,$07,$00,$2a,$00,$00
	.byte $00,$00,$2c,$2e,$2d,$29,$07,$2c,$00,$00,$00,$18,$18,$18,$00,$27
	.byte $29,$00,$00,$00,$16,$00,$29,$00,$2c,$2d,$2d,$00,$0e,$0f,$0f,$00
	.byte $00,$0e,$00,$07,$2e,$00,$27,$1b,$33,$00,$34,$00,$00,$00,$35,$01
	.byte $01,$31,$00,$00,$00,$00,$23,$00,$00,$23,$00,$29,$00,$07,$18
tile32_b:	; topright 16x16 metatile
	.byte $00,$01,$00,$03,$00,$00,$00,$06,$05,$00,$01,$00,$00,$00,$00,$03
	.byte $01,$07,$02,$02,$01,$07,$00,$0b,$00,$0f,$0f,$11,$00,$0e,$00,$07
	.byte $10,$00,$0f,$00,$10,$0e,$00,$00,$00,$00,$00,$14,$00,$0f,$0f,$00
	.byte $15,$18,$18,$1a,$18,$00,$00,$1d,$00,$19,$00,$00,$00,$1e,$00,$18
	.byte $18,$00,$16,$18,$07,$00,$23,$23,$00,$00,$06,$00,$18,$1e,$00,$00
	.byte $07,$00,$00,$01,$00,$27,$27,$27,$27,$00,$00,$1f,$00,$00,$18,$23
	.byte $23,$00,$23,$00,$00,$24,$18,$00,$16,$16,$00,$16,$00,$2a,$00,$2d
	.byte $2e,$00,$2c,$00,$00,$29,$16,$00,$00,$00,$00,$18,$18,$18,$27,$00
	.byte $00,$00,$31,$00,$15,$00,$00,$29,$2c,$07,$00,$00,$0f,$00,$00,$10
	.byte $00,$00,$11,$0f,$00,$23,$00,$18,$33,$33,$34,$34,$00,$00,$35,$01
	.byte $00,$31,$00,$00,$27,$07,$23,$00,$00,$07,$00,$29,$29,$18,$18
tile32_c:	; bottomleft 16x16 metatile
	.byte $00,$01,$04,$00,$03,$01,$02,$02,$02,$02,$07,$01,$00,$05,$08,$00
	.byte $07,$03,$03,$00,$00,$02,$02,$02,$00,$10,$0f,$00,$11,$10,$07,$00
	.byte $00,$0f,$00,$00,$00,$0f,$00,$0c,$05,$05,$00,$00,$00,$0f,$10,$15
	.byte $16,$1b,$18,$00,$17,$00,$1c,$37,$1f,$00,$00,$19,$00,$00,$1e,$20
	.byte $00,$22,$16,$00,$23,$23,$23,$00,$00,$06,$06,$06,$07,$00,$1f,$19
	.byte $00,$24,$26,$1f,$19,$27,$00,$27,$28,$27,$27,$00,$1f,$24,$24,$23
	.byte $00,$23,$00,$23,$23,$00,$00,$16,$00,$00,$16,$07,$16,$2b,$00,$00
	.byte $00,$2c,$00,$2d,$2d,$00,$07,$16,$02,$02,$00,$17,$18,$00,$00,$00
	.byte $29,$00,$00,$00,$16,$15,$29,$00,$16,$2d,$2d,$00,$0f,$0f,$10,$0e
	.byte $0e,$0f,$00,$07,$2d,$00,$27,$15,$02,$02,$18,$00,$35,$35,$11,$01
	.byte $03,$32,$00,$00,$27,$36,$36,$23,$36,$23,$16,$00,$00,$07,$00
tile32_d:	; bottomright 16x16 metatile
	.byte $00,$03,$00,$00,$01,$02,$00,$02,$02,$02,$01,$00,$00,$00,$09,$00
	.byte $01,$07,$0c,$00,$03,$02,$02,$02,$02,$10,$0f,$00,$11,$10,$00,$07
	.byte $00,$00,$0f,$00,$00,$0f,$0d,$00,$05,$05,$00,$00,$00,$10,$0f,$15
	.byte $16,$17,$18,$18,$17,$1b,$00,$00,$1e,$37,$00,$1d,$19,$37,$00,$18
	.byte $18,$00,$16,$18,$07,$15,$23,$00,$23,$06,$06,$00,$18,$00,$1e,$1d
	.byte $00,$25,$24,$1e,$1d,$27,$00,$28,$27,$27,$00,$00,$1f,$24,$18,$00
	.byte $23,$00,$23,$23,$00,$00,$18,$00,$16,$00,$16,$16,$00,$2b,$00,$2d
	.byte $2d,$2c,$00,$00,$00,$00,$16,$2c,$00,$02,$02,$17,$18,$00,$27,$00
	.byte $29,$29,$32,$30,$16,$00,$00,$29,$16,$07,$00,$0e,$0f,$0e,$00,$00
	.byte $00,$0e,$00,$0f,$00,$00,$00,$15,$02,$02,$18,$18,$00,$35,$11,$01
	.byte $07,$32,$00,$27,$27,$36,$36,$23,$36,$07,$00,$16,$00,$18,$18

tile32_e:	; attribute byte
	.byte $55,$55,$65,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$a5,$57
	.byte $55,$55,$d5,$55,$55,$55,$55,$5a,$55,$55,$55,$55,$55,$55,$55,$55
	.byte $55,$55,$55,$55,$55,$55,$d5,$75,$a5,$a6,$55,$55,$55,$55,$55,$55
	.byte $55,$66,$66,$9a,$aa,$95,$65,$9a,$a5,$59,$56,$a5,$95,$5a,$65,$a9
	.byte $9a,$55,$55,$99,$55,$77,$55,$55,$55,$a5,$aa,$65,$aa,$55,$55,$55
	.byte $55,$55,$55,$55,$55,$ff,$5f,$ff,$ff,$ff,$ff,$5a,$a5,$aa,$aa,$55
	.byte $55,$55,$55,$55,$55,$5a,$5a,$55,$55,$55,$55,$66,$55,$ff,$55,$55
	.byte $55,$55,$55,$55,$55,$55,$55,$55,$aa,$aa,$aa,$aa,$aa,$aa,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$55,$55,$ff,$ff,$ff,$ff,$ff,$55,$55,$55,$55,$55
	.byte $55,$55,$55,$55,$ff,$55,$ff,$5a,$aa,$aa,$aa,$aa,$ff,$ff,$5f,$55
	.byte $55,$55,$55,$ff,$ff,$f5,$f5,$55,$ff,$ff,$55,$55,$55,$66,$66
tile32_f:	; collision
	.byte $00,$3f,$c0,$f0,$cf,$cf,$0c,$3f,$3f,$cf,$37,$cc,$c0,$0c,$00,$b0
	.byte $77,$dd,$fe,$f0,$f3,$1f,$0f,$0f,$03,$ff,$ff,$f0,$0f,$ff,$44,$11
	.byte $f0,$cc,$33,$c0,$30,$ff,$02,$08,$0f,$cf,$c0,$00,$00,$ff,$ff,$0f
	.byte $ff,$00,$00,$f0,$00,$00,$00,$f0,$0f,$30,$c0,$0f,$03,$f0,$0c,$0c
	.byte $c0,$0c,$ff,$00,$dd,$cf,$ff,$f0,$03,$0f,$ff,$0c,$44,$f0,$0f,$0f
	.byte $d0,$0f,$0f,$3f,$cf,$ff,$f0,$ff,$ff,$0f,$0c,$f0,$0f,$0f,$0c,$fc
	.byte $f3,$cc,$33,$cf,$0c,$f0,$c0,$cc,$33,$f0,$0f,$77,$0c,$00,$0f,$33
	.byte $33,$0f,$f0,$cc,$cc,$f0,$77,$cf,$0c,$0f,$03,$ff,$ff,$f0,$33,$c0
	.byte $cf,$03,$33,$03,$ff,$0c,$cc,$33,$ff,$dd,$cc,$03,$ff,$cf,$cc,$3c
	.byte $0c,$cf,$30,$77,$cc,$30,$cc,$0f,$0f,$0f,$00,$00,$08,$0a,$af,$ff
	.byte $cd,$ff,$f0,$03,$3f,$10,$f0,$0f,$00,$dd,$0c,$f3,$30,$77,$f3

loop_nada:
	jmp end_loop
nmi_nada:
	jmp end_nmi


loop_loadmap:
	jsr clear_enemies
	jsr all_other_sprites_offscreen
	jsr move_back_routine
	jsr p_hitboxes
	jsr flicker_em

	ldy #1
	jsr bankswitch
	lda #<nmi_loadmap
	sta nmi_pointer+0
	lda #>nmi_loadmap
	sta nmi_pointer+1

	ldy temp_8bit_1
	cpy #48
	bne :+
		lda #$23
		sta ppu_addy+1
		lda #$c0
		sta ppu_addy
		lda #$00
		sta temp_8bit_2
		lda #<loop_all_else
		sta loop_pointer+0
		lda #>loop_all_else
		sta loop_pointer+1
		lda #<nmi_attribs
		sta nmi_pointer+0
		lda #>nmi_attribs
		sta nmi_pointer+1
		jmp end_loop
:	lda (room_pointer), y
	tay
	lda tile32_a, y
	tax
		lda tile16_a, x
		sta store_meta_16
		lda tile16_b, x
		sta store_meta_16+1
		lda tile16_c, x
		sta store_meta_16+4
		lda tile16_d, x
		sta store_meta_16+5
	lda tile32_b, y
	tax
		lda tile16_a, x
		sta store_meta_16+2
		lda tile16_b, x
		sta store_meta_16+3
		lda tile16_c, x
		sta store_meta_16+6
		lda tile16_d, x
		sta store_meta_16+7
	lda tile32_c, y
	tax
		lda tile16_a, x
		sta store_meta_16+8
		lda tile16_b, x
		sta store_meta_16+9
		lda tile16_c, x
		sta store_meta_16+12
		lda tile16_d, x
		sta store_meta_16+13
	lda tile32_d, y
	tax
		lda tile16_a, x
		sta store_meta_16+10
		lda tile16_b, x
		sta store_meta_16+11
		lda tile16_c, x
		sta store_meta_16+14
		lda tile16_d, x
		sta store_meta_16+15
	lda tile32_f, y
		sta bg_collision_byte
	lda tile32_e, y
		ldy temp_8bit_1
		sta bg_attribs_ram, y
	ldx temp_8bit_2
	lda bg_collision_byte
	and #%11000000
	ror
	ror
	ror
	ror
	ror
	ror
	sta bg_ram, x
	inx
	lda bg_collision_byte
	and #%00110000
	ror
	ror
	ror
	ror
	sta bg_ram, x
	lda temp_8bit_2
	clc
	adc #16
	tax
	lda bg_collision_byte
	and #%00001100
	ror
	ror
	sta bg_ram, x
	inx
	lda bg_collision_byte
	and #%00000011
	sta bg_ram, x

	ldx #$00
:	lda bg_shift, x
	cmp temp_8bit_2
	beq :+
		inx
		cpx #$06
		bne :-
		jmp :++
:	lda temp_8bit_2
	clc
	adc #18
	sta temp_8bit_2
	jmp end_loop
:	inc temp_8bit_2
	inc temp_8bit_2
	jmp end_loop

bg_shift:
	.byte $0e,$2e,$4e,$6e,$8e,$ae
shift_table:
	.byte 7,15,23,31,39,47,55,63

nmi_loadmap:
	lda ppu_addy+1
	sta $2006
	lda ppu_addy
	sta $2006
	lda store_meta_16
	sta $2007
	lda store_meta_16+1
	sta $2007
	lda store_meta_16+2
	sta $2007
	lda store_meta_16+3
	sta $2007
	lda ppu_addy
	clc
	adc #32
	sta ppu_addy
	lda ppu_addy+1
	sta $2006
	lda ppu_addy
	sta $2006
	lda store_meta_16+4
	sta $2007
	lda store_meta_16+5
	sta $2007
	lda store_meta_16+6
	sta $2007
	lda store_meta_16+7
	sta $2007
	lda ppu_addy
	clc
	adc #32
	sta ppu_addy
	lda ppu_addy+1
	sta $2006
	lda ppu_addy
	sta $2006
	lda store_meta_16+8
	sta $2007
	lda store_meta_16+9
	sta $2007
	lda store_meta_16+10
	sta $2007
	lda store_meta_16+11
	sta $2007
	lda ppu_addy
	clc
	adc #32
	sta ppu_addy
	lda ppu_addy+1
	sta $2006
	lda ppu_addy
	sta $2006
	lda store_meta_16+12
	sta $2007
	lda store_meta_16+13
	sta $2007
	lda store_meta_16+14
	sta $2007
	lda store_meta_16+15
	sta $2007

	ldx #$00
:	lda shift_table,x
	cmp temp_8bit_1
	beq :+
		inx
		cpx #$07
		bne :-
		jmp :++
:	lda ppu_addy
	clc
	adc #$04
	sta ppu_addy
	cmp #$00
	bne :++
		lda ppu_addy+1
		clc
		adc #$01
		sta ppu_addy+1
		jmp :++
:
	lda ppu_addy
	sec
	sbc #92
	sta ppu_addy
:
	inc temp_8bit_1
	jmp end_nmi

nmi_attribs:
	ldy temp_8bit_2
	cpy #24
	bcs :++
		lda ppu_addy+1
		sta $2006
		lda ppu_addy
		sta $2006
:		lda bg_attribs_ram, y
		sta $2007
		iny
		cpy #24
		bne :-
			sty temp_8bit_2
			lda #$d8
			sta ppu_addy
			jmp end_nmi
:	lda ppu_addy+1
	sta $2006
	lda ppu_addy
	sta $2006
:	lda bg_attribs_ram, y
	sta $2007
	iny
	cpy #48
	bne :-
		sty temp_8bit_2
	jmp end_nmi

loop_all_else:
	lda temp_8bit_2
	cmp #48
	beq :+
		jmp @done_loop
:		ldy temp_8bit_1
		ldx #$00
:		lda (room_pointer), y
;		sta enemy_list, x
		sta item_type, x
		iny
		sty temp_8bit_1
		inx
		cpx #$02
		bne :-
		
			lda item_type
			beq @done_item
				cmp #$0b
				beq @done_item
				tax
				ldy #$00
:				lda item_have_room, y
				cmp map_pos
				beq :+
					iny
					cpy #17
					bne :-
					jmp @still_do
:				lda item_collection, y
				beq @still_do
					lda #$ff
					sta item_pos
					sta item1
					sta item1+3
					jmp @done_item
@still_do:	
				lda item_words_lo, x
				sta addy+0
				lda item_words_hi, x
				sta addy+1
				ldy #$00
:				lda (addy), y
				sta item_tile, y
				iny
				cpy #18
				bne :-
				lda item_tile
				sta item1+1
				lda item_attrib
				sta item1+2
				lda item_pos
				and #$f0
				clc
				adc #$06
				sta item1
				lda item_pos
				and #$0f
				rol
				rol
				rol
				rol
				clc
				adc #$04
				sta item1+3
@done_item:
		ldy temp_8bit_1
		ldx #$00
:		lda (room_pointer), y
		sta room_words, x
		iny
		sty temp_8bit_1
		inx
		cpx #$1a
		bne :-
			ldx #$00
			stx temp_8bit_2
:			ldx temp_8bit_2
			lda e_types, x
;			beq @done_enemies
				tax
				lda enemy_data_lo, x
				sta addy+0
				lda enemy_data_hi, x
				sta addy+1
				jsr data_load
				jsr e_sprite_load
				ldx temp_8bit_2
				inx
				stx temp_8bit_2
				cpx #$04
				bne :-

@done_enemies:

	ldy #0
	jsr bankswitch
				lda e_types+0
				sta e1_anim_state
				lda e_types+1
				sta e2_anim_state
				lda e_types+2
				sta e3_anim_state
				lda e_types+3
				sta e4_anim_state
				lda #$78
				sta e1_catchall
				sta e2_catchall
				sta e3_catchall
				sta e4_catchall
				lda e1_hit_points
				sta e1_hp
				lda e2_hit_points
				sta e2_hp
				lda e3_hit_points
				sta e3_hp
				lda e4_hit_points
				sta e4_hp
				lda map_pos
				cmp #126
				bne :+
					lda #$3a
					sta e1_hp
					lda #$18
					sta e2_hp
					lda #$f0
					sta e2_catchall
:
					lda bg_pal_lo
					sta addy+0
					lda bg_pal_hi
					sta addy+1
					ldy #$00
:					lda (addy), y
					sta pal_address+5, y
					iny
					cpy #$0b
					bne :-
					ldy #$00
						;lda #$00
						;sta pal_address+5
						;lda #$10
						;sta pal_address+6
						;lda #$30
						;sta pal_address+7
		lda item_type+0
		cmp #$0b
		beq :+
			jmp @no_boss
:
			lda map_pos
			cmp #104
			beq :+
				cmp #93
				bne :++
:				lda #$16
				sta pal_address+29
				lda #$27
				sta pal_address+30
				lda #$1c
				sta pal_address+31
				jmp :++++
:			cmp #108
			beq :+
				cmp #$01
				bne :++
:
				lda #$2a
				sta pal_address+29
				lda #$28
				sta pal_address+30
				lda #$38
				sta pal_address+31
				jmp :++
:			cmp #$7e
			bne :+
				lda #$27
				sta pal_address+22	; beancy
				lda #$17
				sta pal_address+23	; beancy
				lda #$16
				sta pal_address+25
				lda #$10
				sta pal_address+26
				lda #$30
				sta pal_address+27
			ldy #$00
:			lda boss_dead_room, y
			cmp map_pos
			beq :+
				iny
				cpy #6
				bne :-
					jmp @do_boss
:			lda boss_dead, y
			beq @do_boss
				jsr clear_enemies
				lda #$ff
				sta item_pos
				sta item1
				sta item1+3
;				lda #$00
;				sta no_control
				jmp @no_boss
@do_boss:
			lda #<loop_boss_start
			sta loop_pointer+0
			lda #>loop_boss_start
			sta loop_pointer+1
			lda #$00
			jsr music_loadsong
			lda #$78
			sta boss_wait
			jmp @nmi_doer
@no_boss:
		ldy p_pos
		lda bg_ram, y
		cmp #$01
		bne @other_check
			lda p_pos
			clc
			adc #$10
			tay
			lda bg_ram, y
			cmp #$03
			beq :+
				lda #$00
				sta p_state
				lda #$0a
				sta p_anim_state
				jmp @looper_yup
:			lda #$00
			sta p_anim_state
			sta p_state
			jmp @looper_yup
@other_check:
			lda p_pos
			clc
			adc #$10
			tay
			lda bg_ram, y
			beq @looper_yup
				lda #$00
				sta p_state
				sta p_anim_state
@looper_yup:
		lda #<loop_gameplay
		sta loop_pointer+0
		lda #>loop_gameplay
		sta loop_pointer+1
@nmi_doer:
		lda #<nmi_gameplay
		sta nmi_pointer+0
		lda #>nmi_gameplay
		sta nmi_pointer+1

@done_loop:

	jmp end_loop

move_back_table:
	.byte $01,$02,$03,$04
x_or_y_table_lo:
	.byte <p_top_left_x,<p_top_left_x,<p_top_left,<p_top_left
x_or_y_table_hi:
	.byte >p_top_left_x,>p_top_left_x,>p_top_left,>p_top_left
compare_table:
	.byte $10,$e0,$9f,$0f
add_it_table:
	.byte $f8,$08,$04,$fc
move_back_routine:
	ldx #$00
	ldy #$00
@the_start:
	lda move_back_byte
	cmp move_back_table, x
	bne @inc_it
		lda x_or_y_table_lo, x
		sta addy+0
		lda x_or_y_table_hi, x
		sta addy+1
		lda (addy), y
		cmp compare_table, x
		bne :+
			lda #$00
			sta move_back_byte
			rts
:		clc
		adc add_it_table, x
		sta (addy), y
		rts
@inc_it:
	inx
	cpx #$04
	bne @the_start


all_other_sprites_offscreen:
	ldx #$2c
	lda #$ff
:	sta p_top_left, x
	inx
	inx
	inx
	inx
	bne :-
	rts









loop_boss_start:
	lda boss_wait
	beq :+
		dec boss_wait
		jmp end_loop
:	lda #$01
	sta boss_wait
	lda #<loop_gameplay
	sta loop_pointer+0
	lda #>loop_gameplay
	sta loop_pointer+1
	lda #$8f
	sta blocker1+1
	sta blocker2+1
	lda #$01
	sta blocker1+2
	sta blocker2+2
	lda item_type+1
	and #$f0
	sta left_blocker_save
	tay
	clc
	adc #$03
	sta blocker1+0
	lda #$08
	sta blocker1+3
	lda #$03
	sta bg_ram, y
	lda item_type+1
	and #$0f
	rol
	rol
	rol
	rol
	tay
	clc
	adc #$03
	sta blocker2+0
	lda #$f0
	sta blocker2+3
	lda #$03
	tya
	clc
	adc #$0f
	sta right_blocker_save
	tay
	lda #$03
	sta bg_ram, y
	lda #$ff
	sta item_pos
	jmp end_loop

loop_boss_start2:
	lda boss_wait
	beq :++
		cmp #$32
		bne :+
			lda #$03
			jsr music_loadsong
:		dec boss_wait
		jmp end_loop
:	lda #$00
	sta p_state
	sta p_anim_state
	lda #<loop_gameplay
	sta loop_pointer+0
	lda #>loop_gameplay
	sta loop_pointer+1
	jmp end_loop


loop_boss_done:
	ldy #$00
:	lda boss_dead_room, y
	cmp map_pos
	beq :+
		iny
		cpy #6
		bne :-
:	lda #$01
	sta boss_dead, y
	lda #$ff
	sta e1_shot1
	sta e2_shot1
	sta e3_shot1
	sta e4_shot1
	lda boss_wait
	bne @shake_em
		lda #<loop_boss_done2
		sta loop_pointer+0
		lda #>loop_boss_done2
		sta loop_pointer+1
		lda #$02
		jsr music_loadsong
		jsr music_stopsfx
		lda #$78
		sta boss_wait
		jmp end_loop
@shake_em:
	ldy shake_offset
	cpy #$08
	bne :+
		lda #$00
		sta shake_offset
		dec boss_wait
		jmp end_loop
:	lda scroll_x
	clc
	adc shake_screen_table, y
	sta scroll_x
	iny
	sty shake_offset
	jmp end_loop

loop_boss_done2:
	lda boss_wait
	beq :+
		jmp @boss_gone
:		lda map_pos
		bne @item_do
			lda #$04
			jsr music_loadsong
			lda #$00
			sta hekl_hurt
			tax
			jsr palette_animation_routine
			jsr clear_enemies
			jsr all_other_sprites_offscreen
			lda #$ff
:			sta lives_icon, x
			inx
			cpx #28
			bne :-
			lda #<loop_finito
			sta loop_pointer+0
			lda #>loop_finito
			sta loop_pointer+1
			lda #$20
			sta ppu_addy+1
			ldy #$00
			sty ppu_addy+0
			lda #<nmi_won1
			sta nmi_pointer+0
			lda #>nmi_won1
			sta nmi_pointer+1
			jmp end_loop
@item_do:
		lda #$00
		sta item_type
		ldy left_blocker_save
		lda #$00
		sta bg_ram, y
		ldy right_blocker_save
		lda #$00
		sta bg_ram, y
		lda #$ff
		sta blocker1
		sta blocker2
		lda #<loop_gameplay
		sta loop_pointer+0
		lda #>loop_gameplay
		sta loop_pointer+1

	ldx #$00
:	lda map_pos
	cmp boss_music_return_room, x
	bne :+
		lda boss_music_return, x
		jsr music_loadsong
		jmp @done_tunes
:	inx
	cpx #$05
	bne :--
@done_tunes:
		jmp end_loop
@boss_gone:
	dec boss_wait
	jmp end_loop

boss_music_return:
	.byte $07,$07,$08,$09,$06
boss_music_return_room:
	.byte $6c,$5d,$7e,$01,$68
