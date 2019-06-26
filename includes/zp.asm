

; player stats byte0:	bit0		=	lev.speed
;						bit1/bit2	=	lev.vertical
;						bit3/bit4	=	lev.horizontal
;						bit5		=	bridge
;						bit6		=	teleport
;						bit7		=	cloud
; player stats byte1:	bit0		=	lightning
;						bit1/bit2	=	magic missile
;						bit3/bit4	=	life meter
;						bit5		=	magic conjunction

nmi_num:				.res 1
scroll_x:				.res 1
scroll_y:				.res 1
control_pad:			.res 1
control_old:			.res 1
loop_pointer:			.res 2
nmi_pointer:			.res 2
room_pointer:			.res 2
ppu_addy:				.res 2
e_slot_pointer:			.res 2
addy:					.res 2
player_stats0:			.res 1
player_stats1:			.res 1
p_lives:				.res 1
p_entrance:				.res 1
p_dir_enter:			.res 1
p_anim_enter:			.res 1
p_state_enter:			.res 1
p_side_enter:			.res 1
p_up_enter:				.res 1
p_left:					.res 1
p_right:				.res 1	; x1b
p_top:					.res 1
p_bot:					.res 1
p_pos:					.res 1
map_pos:				.res 1
p_state:				.res 1	; x20
move_counter:			.res 1
move_left_right:		.res 1
p_speed_lo:				.res 1
levitate_speed:			.res 1
levitate_counter:		.res 1
levitate_switch:		.res 1
levitate_side_amount:	.res 1	; 27
levitate_up:			.res 1
levitate_up_amount:		.res 1
p_anim_state:			.res 1
p_anim_count:			.res 1	; x2b
p_anim_addy:			.res 2
temp_addy:				.res 2
p_shot_damage:			.res 1	; x30
p_shot_sprite:			.res 1
p_dir:					.res 1
quick_turn:				.res 1
bridge_switcher:		.res 1
anim_ticker:			.res 1
anim_offset:			.res 1
magic_switch:			.res 1
move_back_byte:			.res 1
shooting:				.res 1
shot_dir:				.res 1
shot_max:				.res 1
shot_max_ram:			.res 1
sprite_flicker:			.res 1	; x3d
region:					.res 1
s_top:					.res 1
s_bot:					.res 1
s_left:					.res 1
s_right:				.res 1	; x42
temp_8bit_1:			.res 1	; 1)offset for background decompression, 2)item pickup timer
temp_8bit_2:			.res 1	; 1)offset for bg_ram decompression, 2)offset for loading attribs
								; 3)store for player stats on powerup
temp_8bit_3:			.res 1	; 1)bat_v bakforf
boss_wait:				.res 1
temp_16bit_1:			.res 2
temp_16bit_2:			.res 2
temp_16bit_3:			.res 2
temp_16bit_4:			.res 2
hekl_hurt:				.res 1
hekl_life_meter:		.res 1	; x50


temp:					.res 1


e1_left:				.res 1
e2_left:				.res 1
e3_left:				.res 1
e4_left:				.res 1
e1_right:				.res 1
e2_right:				.res 1
e3_right:				.res 1
e4_right:				.res 1
e1_top:					.res 1
e2_top:					.res 1
e3_top:					.res 1
e4_top:					.res 1
e1_bot:					.res 1
e2_bot:					.res 1
e3_bot:					.res 1	; x60
e4_bot:					.res 1
e1_anim_state:			.res 1
e2_anim_state:			.res 1
e3_anim_state:			.res 1
e4_anim_state:			.res 1
e1_anim_count:			.res 1
e2_anim_count:			.res 1
e3_anim_count:			.res 1
e4_anim_count:			.res 1
e1_anim_addy:			.res 2
e2_anim_addy:			.res 2
e3_anim_addy:			.res 2
e4_anim_addy:			.res 2
e1_dir:					.res 1	; x72
e2_dir:					.res 1
e3_dir:					.res 1
e4_dir:					.res 1
e1_speed_lo:			.res 1
e2_speed_lo:			.res 1
e3_speed_lo:			.res 1
e4_speed_lo:			.res 1
e1_speed_lo2:			.res 1
e2_speed_lo2:			.res 1
e3_speed_lo2:			.res 1
e4_speed_lo2:			.res 1
e1_offset_gen:			.res 1
e2_offset_gen:			.res 1
e3_offset_gen:			.res 1	; x80
e4_offset_gen:			.res 1
e1_move_count:			.res 1
e2_move_count:			.res 1
e3_move_count:			.res 1
e4_move_count:			.res 1
e1_shooting:			.res 1	; x86
e2_shooting:			.res 1
e3_shooting:			.res 1
e4_shooting:			.res 1
e1_catchall:			.res 1
e2_catchall:			.res 1
e3_catchall:			.res 1
e4_catchall:			.res 1
e1shot_left:			.res 1
e2shot_left:			.res 1
e3shot_left:			.res 1	; 90
e4shot_left:			.res 1
extra_left:				.res 1
extra_left2:			.res 1
e1shot_right:			.res 1
e2shot_right:			.res 1
e3shot_right:			.res 1
e4shot_right:			.res 1
extra_right:			.res 1
extra_right2:			.res 1
e1shot_top:				.res 1
e2shot_top:				.res 1
e3shot_top:				.res 1
e4shot_top:				.res 1
extra_top:				.res 1
extra_top2:				.res 1
e1shot_bot:				.res 1	; a0
e2shot_bot:				.res 1
e3shot_bot:				.res 1
e4shot_bot:				.res 1
extra_bot:				.res 1
extra_bot2:				.res 1
e1_hp:					.res 1
e2_hp:					.res 1
e3_hp:					.res 1
e4_hp:					.res 1
e1_liz_off:				.res 1
e2_liz_off:				.res 1
e3_liz_off:				.res 1
e4_liz_off:				.res 1


left_blocker_save:		.res 1
right_blocker_save:		.res 1

cube_left:				.res 1	; b0
cube_right:				.res 1
cube_top:				.res 1
cube_bot:				.res 1

no_control:				.res 1

prior_map:				.res 1
temp_map:				.res 1

splash:					.res 1

title_switch:			.res 1	; b9

;pal_address:			.res 32

bridge_offset1:			.res 1	; da
bridge_offset2:			.res 1
bridge_offset3:			.res 1
cloud_offset:			.res 1
tele_pos:			.res 1
tele_offset:			.res 1
tele_dir:			.res 1		; e0
tele_ticker:			.res 1
lifey_1:			.res 1
lifey_2:			.res 1
lifey_3:			.res 1
lifey_4:			.res 1
lifey_5:			.res 1
lev_spd_offset:			.res 1
lev_ver_offset:			.res 1	; e8
lev_hor_offset:			.res 1
bridge_write_offset:		.res 1
tele_write_offset:			.res 1
cloud_write_offset:			.res 1
light_write_offset:			.res 1
mm_write_offset:			.res 1
life_meter_offset:			.res 1
magic_join_offset:			.res 1

e1_sprite_tiles:			.res 4
e1_sprite_attribs:			.res 4
e1_hit_points:			.res 1
e2_sprite_tiles:			.res 4
e2_sprite_attribs:			.res 4
e2_hit_points:			.res 1
e3_sprite_tiles:			.res 4
e3_sprite_attribs:			.res 4
e3_hit_points:			.res 1
e4_sprite_tiles:			.res 4
e4_sprite_attribs:			.res 4
e4_hit_points:			.res 1
shake_offset:			.res 1


bank:				.res 1


