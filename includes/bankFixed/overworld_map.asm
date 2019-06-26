pal_home:
	.incbin "includes\bankFixed\hekl_home.pal"
pal_cave:
	.incbin "includes\bankFixed\hekl_cave.pal"
pal_well:
	.incbin "includes\bankFixed\hekl_well.pal"
pal_treehouse:
	.incbin "includes\bankFixed\hekl_treehouse.pal"
pal_trees_grass_canopy:
	.incbin "includes\bankFixed\hekl_trees_grass_canopy.pal"
pal_final:
	.incbin "includes\bankFixed\hekl_final_castle.pal"
pal_water:
	.incbin "includes\bankFixed\hekl_water.pal"
pal_bridge_grass_water:
	.incbin "includes\bankFixed\hekl_bridge.pal"
pal_grave:
	.incbin "includes\bankFixed\hekl_graveyard.pal"
pal_fire:
	.incbin "includes\bankFixed\hekl_fire.pal"
pal_final_canopy:
	.incbin "includes\bankFixed\hekl_final_canopy.pal"

shake_screen_table:
	.byte $01,$01,$ff,$ff,$01,$01,$ff,$ff
loop_shake:
	ldy shake_offset
	cpy #$08
	bne :+
		lda #$00
		sta shake_offset
		jsr music_stopsfx
		lda #<loop_gameplay
		sta loop_pointer+0
		lda #>loop_gameplay
		sta loop_pointer+1
		jmp end_loop
:	lda scroll_x
	clc
	adc shake_screen_table, y
	sta scroll_x
	iny
	sty shake_offset
	jmp end_loop
restore_sprite_color_test:
	ldx #22
:	lda palette, x
	sta pal_address, x
	inx
	cpx #32
	bne :-
;	lda map_pos
;	cmp #$71
;	bcs :+
;		rts
;:	cmp #$7c
;	bcc :+
;		rts
;:	lda #$17
;	sta pal_address+29
	rts

load_screen_pointers:
	jsr black_three_palettes
	jsr cloud_offscreen
	jsr bridge_offscreen
	ldx #$00
	stx scroll_x
	stx shooting
	stx move_counter
	lda #$ff
:	sta p_shot1, x
	inx
	inx
	inx
	inx
	cpx #64
	bne :-
;	lda #$ff
;	sta bridge1
;	sta bridge2
;	sta bridge3
;	sta bridge4
;	sta bridge5
;	sta bridge6
;	sta tele1
;	sta tele2
;	sta tele3
;	sta tele4
;	sta p_shot1
;	sta p_shot2
;	lda #$00
;	sta scroll_x
;	sta shooting
;	sta move_counter
	lda p_state
	cmp #$07
	beq :+
		lda #$00
		sta p_state
:
	lda #$20
	sta ppu_addy+1
	lda #$00
	sta ppu_addy
	sta temp_8bit_1
	sta temp_8bit_2
	ldx map_pos
	lda overworld_lo, x
	sta room_pointer+0
	lda overworld_hi, x
	sta room_pointer+1
	lda #<loop_loadmap
	sta loop_pointer+0
	lda #>loop_loadmap
	sta loop_pointer+1
	rts

black_three_palettes:
	ldx #$04
	lda #$0f
:	sta pal_address, x
	inx
	cpx #$10
	bne :-
	rts
overworld_lo:	; hekl's house to start at either room 55,56,71 or 72
	.byte <room000,<room001,<room002,<room003,<room004,<room005,<room006,<room007,<room008,<room009,<room010,<room011,<room012,<room013,<room014,<room015
	.byte <room016,<room017,<room018,<room019,<room020,<room021,<room022,<room023,<room024,<room025,<room026,<room027,<room028,<room029,<room030,<room031
	.byte <room032,<room033,<room034,<room035,<room036,<room037,<room038,<room039,<room040,<room041,<room042,<room043,<room044,<room045,<room046,<room047
	.byte <room048,<room049,<room050,<room051,<room052,<room053,<room054,<room055,<room056,<room057,<room058,<room059,<room060,<room061,<room062,<room063
	.byte <room064,<room065,<room066,<room067,<room068,<room069,<room070,<room071,<room072,<room073,<room074,<room075,<room076,<room077,<room078,<room079
	.byte <room080,<room081,<room082,<room083,<room084,<room085,<room086,<room087,<room088,<room089,<room090,<room091,<room092,<room093,<room094,<room095
	.byte <room096,<room097,<room098,<room099,<room100,<room101,<room102,<room103,<room104,<room105,<room106,<room107,<room108,<room109,<room110,<room111
	.byte <room112,<room113,<room114,<room115,<room116,<room117,<room118,<room119,<room120,<room121,<room122,<room123,<room124,<room125,<room126,<room127
overworld_hi:
	.byte >room000,>room001,>room002,>room003,>room004,>room005,>room006,>room007,>room008,>room009,>room010,>room011,>room012,>room013,>room014,>room015
	.byte >room016,>room017,>room018,>room019,>room020,>room021,>room022,>room023,>room024,>room025,>room026,>room027,>room028,>room029,>room030,>room031
	.byte >room032,>room033,>room034,>room035,>room036,>room037,>room038,>room039,>room040,>room041,>room042,>room043,>room044,>room045,>room046,>room047
	.byte >room048,>room049,>room050,>room051,>room052,>room053,>room054,>room055,>room056,>room057,>room058,>room059,>room060,>room061,>room062,>room063
	.byte >room064,>room065,>room066,>room067,>room068,>room069,>room070,>room071,>room072,>room073,>room074,>room075,>room076,>room077,>room078,>room079
	.byte >room080,>room081,>room082,>room083,>room084,>room085,>room086,>room087,>room088,>room089,>room090,>room091,>room092,>room093,>room094,>room095
	.byte >room096,>room097,>room098,>room099,>room100,>room101,>room102,>room103,>room104,>room105,>room106,>room107,>room108,>room109,>room110,>room111
	.byte >room112,>room113,>room114,>room115,>room116,>room117,>room118,>room119,>room120,>room121,>room122,>room123,>room124,>room125,>room126,>room127
