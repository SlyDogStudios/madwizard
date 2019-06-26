;WHITE PALETTE
;Ghost 		X
;Golem		X
;Bones		X
;Gargoyle	X

;GREEN PALETTE
;Trent		X
;Lizard
;Goblin		X

;OTHER PALETTE
;Bat X		X
;Bat Y		X
;Raven		X
;Snake      X

enemy_data_lo:
	.byte <no_data
	.byte <ghost_data,<trent_data,<hbat_data,<vbat_data,<bones_data
	.byte <spider_data,<no_data,<gargoyle_data,<golem_data,<raven_data
	.byte <goblin_data,<lizard_data,<bird_data,<gargboss_data,<lastboss_data
enemy_data_hi:
	.byte >no_data
	.byte >ghost_data,>trent_data,>hbat_data,>vbat_data,>bones_data
	.byte >spider_data,>no_data,>gargoyle_data,>golem_data,>raven_data
	.byte >goblin_data,>lizard_data,>bird_data,>gargboss_data,>lastboss_data

no_data:
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
	.byte $00
ghost_data:
	.byte $48,$49,$4a,$4b	; sprite tiles
	.byte $01,$01,$01,$01	; sprite attributes
	.byte $04				; hp
trent_data:
	.byte $40,$41,$42,$43
	.byte $03,$03,$03,$03
	.byte $06
hbat_data:
	.byte $44,$45,$46,$47
	.byte $02,$02,$02,$02
	.byte $03
vbat_data:
	.byte $44,$45,$46,$47
	.byte $02,$02,$02,$02
	.byte $03
bones_data:
	.byte $4c,$4d,$4e,$4f
	.byte $01,$01,$01,$01
	.byte $08
spider_data:
	.byte $58,$59,$5a,$5b
	.byte $03,$03,$03,$03
	.byte $05
gargoyle_data:
	.byte $64,$65,$66,$67
	.byte $01,$01,$01,$01
	.byte $06
golem_data:
	.byte $70,$71,$72,$73
	.byte $01,$01,$01,$01
	.byte $06
raven_data:
	.byte $7c,$7d,$7e,$7f
	.byte $01,$01,$01,$01
	.byte $05
goblin_data:
	.byte $58,$59,$5a,$5b
	.byte $01,$01,$01,$01
	.byte $05
lizard_data:
	.byte $58,$59,$5a,$5b
	.byte $01,$01,$01,$01
	.byte $08
bird_data:
	.byte $58,$59,$5a,$5b
	.byte $01,$01,$01,$01
	.byte $20
gargboss_data:
	.byte $58,$59,$5a,$5b
	.byte $03,$03,$03,$03
	.byte $40
lastboss_data:
	.byte $90,$91,$92,$93
	.byte $03,$03,$03,$03
	.byte $20
data_load:
	lda temp_8bit_2
	asl a
	tay
	lda data_place_choice+1, y
	pha
	lda data_place_choice, y
	pha
	rts
data_place_choice:
	.addr slot1-1,slot2-1,slot3-1,slot4-1
slot1:
	ldy #$00
:	lda (addy), y
	sta e1_sprite_tiles, y
	iny
	cpy #$09
	bne :-
	rts
slot2:
	ldy #$00
:	lda (addy), y
	sta e2_sprite_tiles, y
	iny
	cpy #$09
	bne :-
	rts
slot3:
	ldy #$00
:	lda (addy), y
	sta e3_sprite_tiles, y
	iny
	cpy #$09
	bne :-
	rts
slot4:
	ldy #$00
:	lda (addy), y
	sta e4_sprite_tiles, y
	iny
	cpy #$09
	bne :-
	rts


top_left_lo:
	.byte <e1_top_left,<e2_top_left,<e3_top_left,<e4_top_left
top_left_hi:
	.byte >e1_top_left,>e2_top_left,>e3_top_left,>e4_top_left
top_right_lo:
	.byte <e1_top_right,<e2_top_right,<e3_top_right,<e4_top_right
top_right_hi:
	.byte >e1_top_right,>e2_top_right,>e3_top_right,>e4_top_right
bot_left_lo:
	.byte <e1_bot_left,<e2_bot_left,<e3_bot_left,<e4_bot_left
bot_left_hi:
	.byte >e1_bot_left,>e2_bot_left,>e3_bot_left,>e4_bot_left
bot_right_lo:
	.byte <e1_bot_right,<e2_bot_right,<e3_bot_right,<e4_bot_right
bot_right_hi:
	.byte >e1_bot_right,>e2_bot_right,>e3_bot_right,>e4_bot_right


e_sprite_load:
	ldx temp_8bit_2
	
	lda top_left_lo, x
	sta temp_16bit_1+0
	lda top_left_hi, x
	sta temp_16bit_1+1
	
	lda top_right_lo, x
	sta temp_16bit_2+0
	lda top_right_hi, x
	sta temp_16bit_2+1
	
	lda bot_left_lo, x
	sta temp_16bit_3+0
	lda bot_left_hi, x
	sta temp_16bit_3+1
	
	lda bot_right_lo, x
	sta temp_16bit_4+0
	lda bot_right_hi, x
	sta temp_16bit_4+1
	
;	txa
	ldy #$00
	lda e_pos, x
	and #$f0
	sec
	sbc #$01
	sta (temp_16bit_1), y	; e1_top_left
	sta (temp_16bit_2), y	; e1_top_right
	clc
	adc #$08
	sta (temp_16bit_3), y	; e1_bot_left
	sta (temp_16bit_4), y	; e1_bot_right
	jsr choose_tile_placement
	iny
	ldx temp_8bit_2
	lda e_pos, x
	and #$0f
	rol
	rol
	rol
	rol
	and #$f0
	sta (temp_16bit_1), y	; e1_top_left+3;
	sta (temp_16bit_3), y	; e1_bot_left+3;
	clc
	adc #$08
	sta (temp_16bit_2), y	; e1_top_right+3;
	sta (temp_16bit_4), y	; e1_bot_right+3;
	rts


choose_tile_placement:
	iny
	ldx #$00
	lda temp_8bit_2
	bne :+
		lda e1_sprite_tiles, x
		sta (temp_16bit_1), y
		inx
		lda e1_sprite_tiles, x
		sta (temp_16bit_2), y
		inx
		lda e1_sprite_tiles, x
		sta (temp_16bit_3), y
		inx
		lda e1_sprite_tiles, x
		sta (temp_16bit_4), y
		inx
		iny
		lda e1_sprite_tiles, x
		sta (temp_16bit_1), y
		inx
		lda e1_sprite_tiles, x
		sta (temp_16bit_2), y
		inx
		lda e1_sprite_tiles, x
		sta (temp_16bit_3), y
		inx
		lda e1_sprite_tiles, x
		sta (temp_16bit_4), y
		rts
:	cmp #$01
	bne :+
		lda e2_sprite_tiles, x
		sta (temp_16bit_1), y
		inx
		lda e2_sprite_tiles, x
		sta (temp_16bit_2), y
		inx
		lda e2_sprite_tiles, x
		sta (temp_16bit_3), y
		inx
		lda e2_sprite_tiles, x
		sta (temp_16bit_4), y
		inx
		iny
		lda e2_sprite_tiles, x
		sta (temp_16bit_1), y
		inx
		lda e2_sprite_tiles, x
		sta (temp_16bit_2), y
		inx
		lda e2_sprite_tiles, x
		sta (temp_16bit_3), y
		inx
		lda e2_sprite_tiles, x
		sta (temp_16bit_4), y
		rts
:	cmp #$02
	bne :+
		lda e3_sprite_tiles, x
		sta (temp_16bit_1), y
		inx
		lda e3_sprite_tiles, x
		sta (temp_16bit_2), y
		inx
		lda e3_sprite_tiles, x
		sta (temp_16bit_3), y
		inx
		lda e3_sprite_tiles, x
		sta (temp_16bit_4), y
		inx
		iny
		lda e3_sprite_tiles, x
		sta (temp_16bit_1), y
		inx
		lda e3_sprite_tiles, x
		sta (temp_16bit_2), y
		inx
		lda e3_sprite_tiles, x
		sta (temp_16bit_3), y
		inx
		lda e3_sprite_tiles, x
		sta (temp_16bit_4), y
		rts
:	lda e4_sprite_tiles, x
	sta (temp_16bit_1), y
	inx
	lda e4_sprite_tiles, x
	sta (temp_16bit_2), y
	inx
	lda e4_sprite_tiles, x
	sta (temp_16bit_3), y
	inx
	lda e4_sprite_tiles, x
	sta (temp_16bit_4), y
	inx
	iny
	lda e4_sprite_tiles, x
	sta (temp_16bit_1), y
	inx
	lda e4_sprite_tiles, x
	sta (temp_16bit_2), y
	inx
	lda e4_sprite_tiles, x
	sta (temp_16bit_3), y
	inx
	lda e4_sprite_tiles, x
	sta (temp_16bit_4), y
	rts

clear_enemies:
	lda #$ff
	sta e_pos+0
	sta e_pos+1
	sta e_pos+2
	sta e_pos+3
	ldx #$00
	txa
:	sta e1_sprite_tiles, x
	sta e2_sprite_tiles, x
	sta e3_sprite_tiles, x
	sta e4_sprite_tiles, x
	sta e1_left, x
	inx
	cpx #$10
	bne :-
	ldx #$00
	stx e_types+0
	stx e_types+1
	stx e_types+2
	stx e_types+3
	txa
:	sta e1_anim_state, x
	inx
	cpx #68
	bne :-
	lda #$ff
	sta e1_top_left
	sta e1_top_right
	sta e1_bot_left
	sta e1_bot_right
	sta e2_top_left
	sta e2_top_right
	sta e2_bot_left
	sta e2_bot_right
	sta e3_top_left
	sta e3_top_right
	sta e3_bot_left
	sta e3_bot_right
	sta e4_top_left
	sta e4_top_right
	sta e4_bot_left
	sta e4_bot_right
	rts

hekl_damage_by_enemies:
	lda hekl_hurt
	and #$80
	cmp #$80
	beq @done_coll
	ldx #$00
:	lda e1_left, x
	cmp p_right
		bcs @no_coll
	lda e1_right, x
	cmp p_left
		bcc @no_coll
	lda e1_top, x
	cmp p_bot
		bcs @no_coll
	lda e1_bot, x
	cmp p_top
		bcc @no_coll
			lda #$0b
			jsr music_loadsfx
			lda #$f8
			sta hekl_hurt
			dec hekl_life_meter
			jsr decrement_the_life
			jsr life_meter_routine
			jmp @done_coll
@no_coll:
	inx
	cpx #$04
	bne :-
@done_coll:
	rts
hekl_damage_by_shots:
	lda hekl_hurt
	and #$80
	cmp #$80
	beq @done_coll
	ldx #$00
:	lda e1shot_left, x
	cmp p_right
		bcs @no_coll
	lda e1shot_right, x
	cmp p_left
		bcc @no_coll
	lda e1shot_top, x
	cmp p_bot
		bcs @no_coll
	lda e1shot_bot, x
	cmp p_top
		bcc @no_coll
			lda #$0b
			jsr music_loadsfx
			lda #$f8
			sta hekl_hurt
			dec hekl_life_meter
			jsr decrement_the_life
			jsr life_meter_routine
			jmp @done_coll
@no_coll:
	inx
	cpx #$06
	bne :-
@done_coll:
	rts


e_shots_hitboxes:
	lda e1_shot1
	cmp #$ff
	bne :+
		sta e1shot_top
		sta e1shot_bot
		sta e1shot_left
		sta e1shot_right
		jmp @second
:		clc
		adc #$01
		sta e1shot_top
		clc
		adc #$03
		sta e1shot_bot
		lda e1_shot1+3
		clc
		adc #$02
		sta e1shot_left
		clc
		adc #$03
		sta e1shot_right
@second:
	lda e2_shot1
	cmp #$ff
	bne :+
		sta e2shot_top
		sta e2shot_bot
		sta e2shot_left
		sta e2shot_right
		jmp @third
:
	clc
	adc #$01
	sta e2shot_top
	clc
	adc #$03
	sta e2shot_bot
	lda e2_shot1+3
	clc
	adc #$02
	sta e2shot_left
	clc
	adc #$03
	sta e2shot_right
@third:
	lda e3_shot1
	cmp #$ff
	bne :+
		sta e3shot_top
		sta e3shot_bot
		sta e3shot_left
		sta e3shot_right
		jmp @fourth
:
	clc
	adc #$01
	sta e3shot_top
	clc
	adc #$03
	sta e3shot_bot
	lda e3_shot1+3
	clc
	adc #$02
	sta e3shot_left
	clc
	adc #$03
	sta e3shot_right
@fourth:
	lda e4_shot1
	cmp #$ff
	bne :+
		sta e4shot_top
		sta e4shot_bot
		sta e4shot_left
		sta e4shot_right
		jmp @done
:
	clc
	adc #$01
	sta e4shot_top
	clc
	adc #$03
	sta e4shot_bot
	lda e4_shot1+3
	clc
	adc #$02
	sta e4shot_left
	clc
	adc #$03
	sta e4shot_right
@done:
	lda extra_shot1
	cmp #$ff
	bne :+
		sta extra_top
		sta extra_bot
		sta extra_left
		sta extra_right
		jmp @last
:		clc
		adc #$01
		sta extra_top
		clc
		adc #$03
		sta extra_bot
		lda extra_shot1+3
		clc
		adc #$02
		sta extra_left
		clc
		adc #$03
		sta extra_right
@last:
	lda extra_shot2
	cmp #$ff
	bne :+
		sta extra_top2
		sta extra_bot2
		sta extra_left2
		sta extra_right2
		jmp @really_last
:		clc
		adc #$01
		sta extra_top2
		clc
		adc #$03
		sta extra_bot2
		lda extra_shot2+3
		clc
		adc #$02
		sta extra_left2
		clc
		adc #$03
		sta extra_right2
@really_last:
	rts

boss_dead_room:
	.byte 104,126,93,108,1,0

