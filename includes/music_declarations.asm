sq1_r0			= $4000
sq1_r1			= $4001
sq1_r2			= $4002
sq1_r3			= $4003
sq2_r0			= $4004
sq2_r1			= $4005
sq2_r2			= $4006
sq2_r3			= $4007
tri_r0			= $4008
tri_r2			= $400A
tri_r3			= $400B
nse_r0			= $400C
nse_r2			= $400E
nse_r3			= $400F

base 			= $0300	;This determines where the music engine's variables are.
sq1				= base
sq2				= base+$10
tri				= base+$20
nse				= base+$30

sq2base			= sq2-sq1
tribase			= tri-sq1
nsebase			= nse-sq1

mus_tempo		= base+$80
mus_tempocnt	= mus_tempo+$01
mus_curchn		= mus_tempo+$02
mus_songflags	= mus_tempo+$03
;; Song Flags:
;; 80 - Cycle advance

mus_ptr			= $f8
mus_ptrH		= mus_ptr+$01
mus_scratch1	= mus_ptrH+$01
mus_scratch2	= mus_scratch1+$01
mus_scratch3	= mus_scratch2+$01
mus_scratch4	= mus_scratch3+$01
chn_proplen		= sq2-sq1

mus_sfxbase		= $c0

sq1_ptr			= sq1
sq1_ptrH		= sq1+$01
sq1_flags		= sq1+$02
sq1_notelen		= sq1+$03
sq1_precut		= sq1+$04
sq1_env			= sq1+$05
sq1_envpos		= sq1+$06
sq1_loopcount	= sq1+$07
sq1_detune		= sq1+$08
sq1_volume		= sq1+$09
sq1_bend		= sq1+$0A
sq1_periodL		= sq1+$0B
sq1_periodH		= sq1+$0C

;; Channel flags:
;; 80 - Mute channel (channel's output isn't sent to hardware)
;; 40 - Channel ended (only actually used for sfx)
;; 20 - Priority (only used for sfx, prevents other sfx from being loaded over this)
;; 10 - Silence channel (playing rests, etc)
;; 08 - Tempo-dependent pitch bend

sq2_ptr			= sq2
sq2_ptrH		= sq2+$01

tri_ptr			= tri
tri_ptrH		= tri+$01

nse_ptr			= nse
nse_ptrH		= nse+$01
