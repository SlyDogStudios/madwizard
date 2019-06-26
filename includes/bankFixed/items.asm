loop_item1:
	lda #$ff
	sta item1
	jsr flicker_em
	dec temp_8bit_1
	bne :+
		lda item_type
		jsr item_selection
		jsr get_player_stats_bytes
		lda #$ff
		sta item_pos
		lda #$00
		sta item_type
		sta p_state
		sta p_anim_state
		sta move_counter
		lda #<loop_item2
		sta loop_pointer+0
		lda #>loop_item2
		sta loop_pointer+1
		lda #<nmi_item2
		sta nmi_pointer+0
		lda #>nmi_item2
		sta nmi_pointer+1
:	jmp end_loop


item_have_room:
	.byte 54,100,84,105,127,66,107,33,15,101,79,26,46,83,20,81,38
;  0 - health - hekl's home
;  1 - cube - well
;  2 - Y+1 - cave
;  3 - X+1 - cave
;  4 - Y+1 - river
;  5 - speed - ruins
;  6 - tricaster - fire cave
;  7 - health - final caste
;  8 - teleporter - big tree
;  9 - missile+1 - river/cave
; 10 - thunder - dig dug
; 11 - bridge - treehouse
; 12 - missile+1 - outside big tree
; 13 - health - well
; 14 - x+1 - tree before final castle
; 15 - x+1 - ruins
; 16 - missile+1 - trees

loop_item2:
	ldy #$00
:	lda item_have_room, y
	cmp map_pos
	beq :+
		iny
		cpy #17
		bne :-
			jmp @finished
:	lda #$01
	sta item_collection, y
@finished:

	lda nmi_pointer+0
	cmp #<nmi_gameplay
	bne :+
		lda nmi_pointer+1
		cmp #>nmi_gameplay
		bne :+
			lda #<loop_gameplay
			sta loop_pointer+0
			lda #>loop_gameplay
			sta loop_pointer+1
:	jmp end_loop
nmi_item1:
	ldx #$00
	lda #$23
	sta $2006
	lda #$2e
	sta $2006
:	lda item_words, x
	sta $2007
	inx
	cpx #$10
	bne :-
	jmp end_nmi
nmi_item2:
	ldx #$00
	lda #$23
	sta $2006
	lda #$4b
	sta $2006
:	lda light_tile1, x
	sta $2007
	inx
	cpx #11
	bne :-
	lda #$23
	sta $2006
	lda #$88
	sta $2006
	lda mm_tile1
	sta $2007
	lda mm_tile2
	sta $2007
		lda #<nmi_item3
		sta nmi_pointer+0
		lda #>nmi_item3
		sta nmi_pointer+1
	jmp end_nmi
nmi_item3:
	ldx #$00
	lda #$23
	sta $2006
	lda #$6b
	sta $2006
:	lda light_tile3, x
	sta $2007
	inx
	cpx #11
	bne :-
		lda #<nmi_item4
		sta nmi_pointer+0
		lda #>nmi_item4
		sta nmi_pointer+1
	jmp end_nmi
nmi_item4:
	ldx #$00
	lda #$23
	sta $2006
	lda #$8f
	sta $2006
:	lda join_tile1, x
	sta $2007
	inx
	cpx #16
	bne :-
		lda #<nmi_item5
		sta nmi_pointer+0
		lda #>nmi_item5
		sta nmi_pointer+1
	jmp end_nmi
nmi_item5:
	ldx #$00
	lda #$23
	sta $2006
	lda #$2e
	sta $2006
	lda #$00
:	sta $2007
	inx
	cpx #$10
	bne :-
		lda #<nmi_gameplay
		sta nmi_pointer+0
		lda #>nmi_gameplay
		sta nmi_pointer+1
	jmp end_nmi


join_1:
	.byte $01,$28
join_2:
	.byte $01,$27
join_3:
	.byte $01,$27
join_4:
	.byte $01,$28
join_5:
	.byte $01,$27
join_6:
	.byte $01,$26

lightning_tl:
	.byte $00,$08
lightning_tr:
	.byte $00,$09
lightning_bl:
	.byte $00,$0a
lightning_br:
	.byte $00,$0b

cloud_tl:
	.byte $00,$0c
cloud_tr:
	.byte $00,$0d
cloud_bl:
	.byte $00,$0e
cloud_br:
	.byte $00,$0f

tele_tl:
	.byte $00,$13
tele_tr:
	.byte $00,$14
tele_bl:
	.byte $00,$15
tele_br:
	.byte $00,$16

bridge_tl:
	.byte $00,$17
bridge_tr:
	.byte $00,$17
bridge_bl:
	.byte $00,$18
bridge_br:
	.byte $00,$18

mm_left:
hor_left:
	.byte $2a,$2c,$2c,$2c
mm_right:
hor_right:
	.byte $2d,$2d,$29,$2c

ver_left:
	.byte $2b,$2c,$2c
ver_right:
	.byte $2d,$29,$2c

spd_left:
	.byte $2c,$2c
spd_right:
	.byte $2d,$2c

get_player_stats_bytes:
	lda player_stats0
	and #$01
	sta lev_spd_offset
	beq :+
		lda #$80
		sta levitate_speed
		lda #$20
		sta levitate_counter
		jmp @done_spd
:	lda #$40
	sta levitate_speed
	sta levitate_counter
@done_spd:
	lda player_stats0
	ror
	and #$03
	sta lev_ver_offset
	bne :+
		lda #$01
		sta levitate_up_amount
		jmp @done_ver
:	cmp #$01
	bne :+
		lda #$02
		sta levitate_up_amount
		jmp @done_ver
:	lda #$03
	sta levitate_up_amount
@done_ver:
	lda player_stats0
	ror
	ror
	ror
	and #$03
	sta lev_hor_offset
	bne :+
		lda #$01
		sta levitate_side_amount
		jmp @done_hor
:	cmp #$01
	bne :+
		lda #$02
		sta levitate_side_amount
		jmp @done_hor
:	cmp #$02
	bne :+
		lda #$03
		sta levitate_side_amount
		jmp @done_hor
:	lda #$04
	sta levitate_side_amount
@done_hor:
	lda player_stats0
	rol
	rol
	rol
	rol
	and #$01
	sta bridge_write_offset
	lda player_stats0
	rol
	rol
	rol
	and #$01
	sta tele_write_offset
	lda player_stats0
	rol
	rol
	and #$01
	sta cloud_write_offset

	lda player_stats1
	and #$01
	sta light_write_offset
	lda player_stats1
	ror
	and #$03
	sta mm_write_offset
	bne :+
		lda #$01
		sta p_shot_damage
		lda #$26
		sta p_shot_sprite
		sta p_shot1+1
		lda #$60
		sta shot_max
		jmp @done_mm
:	cmp #$01
	bne :+
		lda #$01
		sta p_shot_damage
		lda #$26
		sta p_shot_sprite
		sta p_shot1+1
		lda #$90
		sta shot_max
		jmp @done_mm
:	cmp #$02
	bne :+
		lda #$02
		sta p_shot_damage
		lda #$21
		sta p_shot_sprite
		sta p_shot1+1
		lda #$c0
		sta shot_max
		jmp @done_mm
:	lda #$02
	sta p_shot_damage
	lda #$21
	sta p_shot_sprite
	sta p_shot1+1
	lda #$e0
	sta shot_max
@done_mm:
	lda player_stats1
	ror
	ror
	ror
	and #$03
	sta life_meter_offset
	lda player_stats1
	rol
	rol
	rol
	rol
	and #$01
	sta magic_join_offset

	ldx mm_write_offset
	lda mm_left, x
	sta mm_tile1
	lda mm_right, x
	sta mm_tile2
	ldx magic_join_offset
	lda join_1, x
	sta join_tile1
	lda join_2, x
	sta join_tile2
	lda join_3, x
	sta join_tile3
	lda join_4, x
	sta join_tile4
	lda join_5, x
	sta join_tile5
	lda join_6, x
	sta join_tile6
	ldx lev_hor_offset
	lda hor_left, x
	sta hor_tile1
	lda hor_right, x
	sta hor_tile2
	ldx lev_ver_offset
	lda ver_left, x
	sta ver_tile1
	lda ver_right, x
	sta ver_tile2
	ldx lev_spd_offset
	lda spd_left, x
	sta spd_tile1
	lda spd_right, x
	sta spd_tile2

	ldx light_write_offset
	lda lightning_tl, x
	sta light_tile1
	lda lightning_tr, x
	sta light_tile2
	lda lightning_bl, x
	sta light_tile3
	lda lightning_br, x
	sta light_tile4
	ldx cloud_write_offset
	lda cloud_tl, x
	sta cloud_tile1
	lda cloud_tr, x
	sta cloud_tile2
	lda cloud_bl, x
	sta cloud_tile3
	lda cloud_br, x
	sta cloud_tile4
	ldx tele_write_offset
	lda tele_tl, x
	sta tele_tile1
	lda tele_tr, x
	sta tele_tile2
	lda tele_bl, x
	sta tele_tile3
	lda tele_br, x
	sta tele_tile4
	ldx bridge_write_offset
	lda bridge_tl, x
	sta bridge_tile1
	lda bridge_tr, x
	sta bridge_tile2
	lda bridge_bl, x
	sta bridge_tile3
	lda bridge_br, x
	sta bridge_tile4
	rts

;LIFE SPHERE
;MAGIC MISSILE +1
;LEVITATION X +1
;LEVITATION Y +1
;LEVITATION SPEED
;SPECTRAL BRIDGE
;PRISM CUBE
;TELEPORTATION
;XECROM'S THUNDER
;TRI-CASTER
item_words_lo:
	.byte $00
	.byte <health_words,<mm_words,<thunder_words,<cloud_words,<bridge_words
	.byte <lev_up_words,<lev_side_words,<tri_words,<speed_words,<tele_words
item_words_hi:
	.byte $00
	.byte >health_words,>mm_words,>thunder_words,>cloud_words,>bridge_words
	.byte >lev_up_words,>lev_side_words,>tri_words,>speed_words,>tele_words
item_list:
	.addr none_up-1
	.addr health_up-1, mm_up-1, thunder_up-1, cloud_up-1, bridge_up-1
	.addr lev_up_up-1, lev_side_up-1, tri_up-1, speed_up-1, tele_up-1
item_selection:
	asl a
	tay
	lda item_list+1,y
	pha
	lda item_list,y
	pha
	rts
none_up:
	rts
health_words:
	.byte $27,$00,"LIFE SPHERE     "
health_up:
	lda life_meter_offset
	cmp #$03
	beq @done
		lda player_stats1
		and #%00011000
		ror
		ror
		ror
		clc
		adc #$01
		sta hekl_life_meter
		rol
		rol
		rol
		sta temp_8bit_2
		lda player_stats1
		and #%11100111
		clc
		adc temp_8bit_2
		sta player_stats1
		lda hekl_life_meter
		cmp #$01
		bne :++
			ldx #$00
:			lda life_table_3, x
			sta lifey_1, x
			inx
			cpx #$05
			bne :-
				jmp @finish
:		cmp #$02
		bne :++
			ldx #$00
:			lda life_table_4, x
			sta lifey_1, x
			inx
			cpx #$05
			bne :-
				jmp @finish
:		ldx #$00
:		lda life_table_5, x
		sta lifey_1, x
		inx
		cpx #$05
		bne :-
@finish:
	lda hekl_life_meter
	clc
	adc #$02
	sta hekl_life_meter
@done:
	rts
mm_words:
	.byte $2e,$01,"MAGIC MISSILE +1"
mm_up:
	lda player_stats1
	and #%00000110
	cmp #$06
	beq :+
		ror
		clc
		adc #$01
		rol
		sta temp_8bit_2
		lda player_stats1
		and #%11111001
		clc
		adc temp_8bit_2
		sta player_stats1
:	rts
thunder_words:
	.byte $2f,$01,"XECROM'S THUNDER"
thunder_up:
	lda light_write_offset
	bne :+
		lda player_stats1
		eor #%00000001
		sta player_stats1
:	rts
cloud_words:
	.byte $30,$01,"PRISM CUBE      "
cloud_up:
	lda cloud_write_offset
	bne :+
		lda player_stats0
		eor #%10000000
		sta player_stats0
:	rts
bridge_words:
	.byte $31,$01,"SPECTRAL BRIDGE "
bridge_up:
	lda bridge_write_offset
	bne :+
		lda player_stats0
		eor #%00100000
		sta player_stats0
:	rts
lev_up_words:
	.byte $32,$00,"LEVITATION Y +1 "
lev_up_up:
	lda player_stats0
	and #%00000110
	cmp #$04
	beq :+
		ror
		clc
		adc #$01
		rol
		sta temp_8bit_2
		lda player_stats0
		and #%11111001
		clc
		adc temp_8bit_2
		sta player_stats0
:	rts
lev_side_words:
	.byte $32,$00,"LEVITATION X +1 "
lev_side_up:
	lda player_stats0
	and #%00011000
	cmp #$18
	beq :+
		ror
		ror
		ror
		clc
		adc #$01
		rol
		rol
		rol
		sta temp_8bit_2
		lda player_stats0
		and #%11100111
		clc
		adc temp_8bit_2
		sta player_stats0
:	rts
tri_words:
	.byte $33,$01,"TRI-CASTER      "
tri_up:
	lda magic_join_offset
	bne :+
		lda player_stats1
		eor #%00100000
		sta player_stats1
:	rts
speed_words:
	.byte $34,$01,"LEVITATION SPEED"
speed_up:
	lda lev_spd_offset
	bne :+
		lda player_stats0
		eor #%00000001
		sta player_stats0
:	rts
tele_words:
	.byte $35,$01,"TELEPORTATION   "
tele_up:
	lda tele_write_offset
	bne :+
		lda player_stats0
		eor #%01000000
		sta player_stats0
:	rts
