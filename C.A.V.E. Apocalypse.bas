   inline PlusROM_functions.asm

   set kernel_options pfcolors player1colors
   set romsize 8kSC
   set smartbranching on

   const pfres=4
   const pfscore = 1

   rem gravity is acceleration (https://atariage.com/forums/topic/226881-gravity/?do=findComment&comment=3017307)
   rem the smallest fraction is 1/256 rounded up here to 0.004
   rem assuming gravity is applied each drawscreen this should
   rem work out to ~7 pixels in 1 second, 28 pixels in 2 seconds
   rem 63 pixels in 3 seconds
   def gravity_player1=0.004
   def gravity_missile0=0.024

   const player_min_x = 10
   const player_max_x = 134
   const player_min_y = 2
   const player_max_y = 76
   const _M_Edge_Top = 2
   const _M_Edge_Bottom = 88
   const _M_Edge_Left = 14
   const _M_Edge_Right = 148

   const scback = #$08


;  NTSC colors.
   const _00 = $00
   const _02 = $02
   const _04 = $04
   const _06 = $06
   const _08 = $08
   const _0A = $0A
   const _0C = $0C
   const _0E = $0E
   const _10 = $10
   const _12 = $12
   const _14 = $14
   const _16 = $16
   const _18 = $18
   const _1A = $1A
   const _1C = $1C
   const _1E = $1E
   const _20 = $20
   const _22 = $22
   const _24 = $24
   const _26 = $26
   const _28 = $28
   const _2A = $2A
   const _2C = $2C
   const _2E = $2E
   const _30 = $30
   const _32 = $32
   const _34 = $34
   const _36 = $36
   const _38 = $38
   const _3A = $3A
   const _3C = $3C
   const _3E = $3E
   const _40 = $40
   const _42 = $42
   const _44 = $44
   const _46 = $46
   const _48 = $48
   const _4A = $4A
   const _4C = $4C
   const _4E = $4E
   const _50 = $50
   const _52 = $52
   const _54 = $54
   const _56 = $56
   const _58 = $58
   const _5A = $5A
   const _5C = $5C
   const _5E = $5E
   const _60 = $60
   const _62 = $62
   const _64 = $64
   const _66 = $66
   const _68 = $68
   const _6A = $6A
   const _6C = $6C
   const _6E = $6E
   const _70 = $70
   const _72 = $72
   const _74 = $74
   const _76 = $76
   const _78 = $78
   const _7A = $7A
   const _7C = $7C
   const _7E = $7E
   const _80 = $80
   const _82 = $82
   const _84 = $84
   const _86 = $86
   const _88 = $88
   const _8A = $8A
   const _8C = $8C
   const _8E = $8E
   const _90 = $90
   const _92 = $92
   const _94 = $94
   const _96 = $96
   const _98 = $98
   const _9A = $9A
   const _9C = $9C
   const _9E = $9E
   const _A0 = $A0
   const _A2 = $A2
   const _A4 = $A4
   const _A6 = $A6
   const _A8 = $A8
   const _AA = $AA
   const _AC = $AC
   const _AE = $AE
   const _B0 = $B0
   const _B2 = $B2
   const _B4 = $B4
   const _B6 = $B6
   const _B8 = $B8
   const _BA = $BA
   const _BC = $BC
   const _BE = $BE
   const _C0 = $C0
   const _C2 = $C2
   const _C4 = $C4
   const _C6 = $C6
   const _C8 = $C8
   const _CA = $CA
   const _CC = $CC
   const _CE = $CE
   const _D0 = $D0
   const _D2 = $D2
   const _D4 = $D4
   const _D6 = $D6
   const _D8 = $D8
   const _DA = $DA
   const _DC = $DC
   const _DE = $DE
   const _E0 = $E0
   const _E2 = $E2
   const _E4 = $E4
   const _E6 = $E6
   const _E8 = $E8
   const _EA = $EA
   const _EC = $EC
   const _EE = $EE
   const _F0 = $F0
   const _F2 = $F2
   const _F4 = $F4
   const _F6 = $F6
   const _F8 = $F8
   const _FA = $FA
   const _FC = $FC
   const _FE = $FE

/*
; PAL colors.
   const _00 = $00
   const _02 = $02
   const _04 = $04
   const _06 = $06
   const _08 = $08
   const _0A = $0A
   const _0C = $0C
   const _0E = $0E
   const _10 = $20
   const _12 = $22
   const _14 = $24
   const _16 = $26
   const _18 = $28
   const _1A = $2A
   const _1C = $2C
   const _1E = $2E
   const _20 = $40
   const _22 = $42
   const _24 = $44
   const _26 = $46
   const _28 = $48
   const _2A = $4A
   const _2C = $4C
   const _2E = $4E
   const _30 = $40
   const _32 = $42
   const _34 = $44
   const _36 = $46
   const _38 = $48
   const _3A = $4A
   const _3C = $4C
   const _3E = $4E
   const _40 = $60
   const _42 = $62
   const _44 = $64
   const _46 = $66
   const _48 = $68
   const _4A = $6A
   const _4C = $6C
   const _4E = $6E
   const _50 = $80
   const _52 = $82
   const _54 = $84
   const _56 = $86
   const _58 = $88
   const _5A = $8A
   const _5C = $8C
   const _5E = $8E
   const _60 = $A0
   const _62 = $A2
   const _64 = $A4
   const _66 = $A6
   const _68 = $A8
   const _6A = $AA
   const _6C = $AC
   const _6E = $AE
   const _70 = $C0
   const _72 = $C2
   const _74 = $C4
   const _76 = $C6
   const _78 = $C8
   const _7A = $CA
   const _7C = $CC
   const _7E = $CE
   const _80 = $D0
   const _82 = $D2
   const _84 = $D4
   const _86 = $D6
   const _88 = $D8
   const _8A = $DA
   const _8C = $DC
   const _8E = $DE
   const _90 = $B0
   const _92 = $B2
   const _94 = $B4
   const _96 = $B6
   const _98 = $B8
   const _9A = $BA
   const _9C = $BC
   const _9E = $BE
   const _A0 = $90
   const _A2 = $92
   const _A4 = $94
   const _A6 = $96
   const _A8 = $98
   const _AA = $9A
   const _AC = $9C
   const _AE = $9E
   const _B0 = $70
   const _B2 = $72
   const _B4 = $74
   const _B6 = $76
   const _B8 = $78
   const _BA = $7A
   const _BC = $7C
   const _BE = $7E
   const _C0 = $50
   const _C2 = $52
   const _C4 = $54
   const _C6 = $56
   const _C8 = $58
   const _CA = $5A
   const _CC = $5C
   const _CE = $5E
   const _D0 = $30
   const _D2 = $32
   const _D4 = $34
   const _D6 = $36
   const _D8 = $38
   const _DA = $3A
   const _DC = $3C
   const _DE = $3E
   const _E0 = $20
   const _E2 = $22
   const _E4 = $24
   const _E6 = $26
   const _E8 = $28
   const _EA = $2A
   const _EC = $2C
   const _EE = $2E
   const _F0 = $20
   const _F2 = $22
   const _F4 = $24
   const _F6 = $26
   const _F8 = $28
   const _FA = $2A
   const _FC = $2C
   const _FE = $2E





*/
; Variables

   dim request_pending = a
   dim delay_counter = b
   dim frame_counter = c

   dim _BitOp_M0_Dir = d
   dim _Bit0_M0_Dir_Up = d
   dim _Bit1_M0_Dir_Down = d
   dim _Bit2_M0_Dir_Left = d
   dim _Bit3_M0_Dir_Right = d

   dim _BitOp_P1_Dir      = e
   dim _Bit0_P1_Dir_Up    = e
   dim _Bit1_P1_Dir_Down  = e
   dim _Bit2_P1_Dir_Left  = e
   dim _Bit3_P1_Dir_Right = e
   dim P1_facing = f
   ;  Channel 0 sound variables.
   dim _Ch0_Sound = g
   dim _Ch0_Duration = h
   dim _Ch0_Counter = i
   ; extra wall
   dim extra_wall_move_x = j
   dim roommate_move_x = k
   dim roommate_type = l


   rem 16 bit velocity
   dim M0y_velocity = s.t
   rem 16 bit missile0 y position
   dim M0y_position = missile0y.u

   rem 16 bit velocity
   dim P1y_velocity = v.w
   rem 16 bit player1 y position
   dim P1y_position = player1y.x

   rem First nibble of y is for direction
   dim _BitOp_misc     = y
   dim _Bit0_P0_Dir    = y  ; direction of enemy (P0) or soldiers (P0), (0=right, 1=left)
   dim _Bit1_Wall_Dir  = y  ; direction of moveable wall (Ball), (0=right, 1=left)
   dim _Bit6_Flip_P0   = y
   dim _Bit7_M0_Moving = y

; SuperChip RAM used for room definitions before playfield definition area (w112/r112)
   dim r_extra_wall_startpos = r111
   dim w_extra_wall_startpos = w111
   dim r_extra_wall_type = r110  
   dim w_extra_wall_type = w110
   dim r_extra_wall_width = r109
   dim w_extra_wall_width = w109
   dim r_enemy_x_startpos = r108
   dim w_enemy_x_startpos = w108
   dim r_enemy_y_startpos = r107
   dim w_enemy_y_startpos = w107
   dim r_P0_type_and_range = r106   ; $03 is P0 type (00=enemy, 01=air missile, 10=Fuel station, 11=soldier)
   dim w_P0_type_and_range = w106
   dim w_room_definition_start = w106



_Start
   WriteSendBuffer = 0 : request_pending = 1
   frame_counter = 0 : COLUP0 = _1C
   score = 0 : pfscore1 = 255 : pfscore2 = 255 : pfscorecolor = _1C : scorecolor = _0E
   player1x = 30 : player1y = 0
   AUDV0 = 0 : AUDV1 = 0
   missile0x = 200 : missile0y = 200 : missile0height = 1 : bally = 0
   w_extra_wall_startpos = 200   ; disable extra wall on start screen
   w_enemy_y_startpos = 200 : player0y = 200 : player0x = 0 ; disable player0 on startscreen

   pfclear
   playfield:
   XXXXXXXXXXXX.......XXXXXXXXXXXXX
   XXXXX.....................XXXXXX
   XXXXXXXXXXXX.......XXXXXXXXXXXXX
end

   player1color:
   _1E
   _82
   _84
   _46
   _44
   _42
   _12
   _08
end

_inital_wait
/*
   ; my colortable in SC RAM
   w000 = _22
   w001 = _24
   w002 = _26
   w003 = _26
; hack to set pfcolortable to SC RAM read port...
   pfcolortable = $00   ; $f0 (lowbyte)
   aux2 = $10           ; $f1 (highbyte)
*/
   pfcolors:
   _22
   _24
   _26
   _26
end

   COLUBK = _00
   drawscreen
   if  ! joy0fire then goto _inital_wait

   player1y = player_min_y



__Main_Loop
   pfcolors:
   _22
   _24
   _26
end

   NUSIZ1 = $05
   NUSIZ0 = $10
   COLUBK = _00

   if switchreset then goto _Start ; toDo wait for end of request with timeout if request_pending = 0 

   if frame_counter{2} then player1: 
   %00011011
   %00001110
   %00011111
   %10111101
   %11111001
   %10011110
   %00001000
   %01111100
end
   if ! frame_counter{2} then player1:
   %00011011
   %00001110
   %00011111
   %10111101
   %11111001
   %10011110
   %00001000
   %00011111
end

   on roommate_type goto _P0_Enemy_def _P0_Air_Missile_def _P0_Fuel_def _P0_Soldier_def

_P0_Enemy_def
   if frame_counter{2} then player0: 
   %01010101
   %10101010
   %11111111
   %00111100
   %00011000
   %00001000
   %00000100
end
   if !frame_counter{2} then player0: 
   %10101010
   %01010101
   %11111111
   %00111100
   %00011000
   %00001000
   %00000100
end
   goto _P0_End_def

_P0_Air_Missile_def
   player0: 
   %10100000
   %01000000
   %11100000
   %10100000
   %01000000
   %00000000
   %00000000
   %00000101
   %00000010
   %00000111
   %00000101
   %00000010
end
   goto _P0_End_def

_P0_Fuel_def
   player0: 
   %00111000
   %00100000
   %00100000
   %00100000
   %00100000
   %00000000
   %00111000
   %00100000
   %00110000
   %00100000
   %00111000
   %00000000
   %00010000
   %00101000
   %00101000
   %00101000
   %00101000
   %00000000
   %00100000
   %00100000
   %00110000
   %00100000
   %10111010
   %10000010
   %11111110

end
   goto _P0_End_def

_P0_Soldier_def
   if frame_counter{2} then player0: 
   %10100110
   %01000010
   %11000110
   %01000010
end
   if !frame_counter{2} then player0: 
   %11000101
   %01000010
   %11000110
   %01000010
end
_P0_End_def

; compute movement of enemy, wall and soldiers
   if r_extra_wall_type < 4 then _Skip_Wall_Movement
   if _Bit1_Wall_Dir{1} then _Wall_move_left
   if frame_counter{4} then extra_wall_move_x = extra_wall_move_x + 1 : if extra_wall_move_x = r_extra_wall_type then _Bit1_Wall_Dir{1} = 1
   goto _Skip_Wall_Movement
_Wall_move_left
   if frame_counter{4} then extra_wall_move_x = extra_wall_move_x - 1 : if !extra_wall_move_x then _Bit1_Wall_Dir{1} = 0
_Skip_Wall_Movement

   if r_P0_type_and_range < 4 then _Skip_Enemy_Movement
   if _Bit0_P0_Dir{0} then _Enemy_move_left
   if !frame_counter{4} then roommate_move_x = roommate_move_x + 1 : if roommate_move_x = r_P0_type_and_range then _Bit0_P0_Dir{0} = 1
   goto _Skip_Enemy_Movement
_Enemy_move_left
   if !frame_counter{4} then roommate_move_x = roommate_move_x - 1 : if !roommate_move_x then _Bit0_P0_Dir{0} = 0
_Skip_Enemy_Movement

   frame_counter = frame_counter + 1

; Check buffer and request status
   if ReceiveBufferSize > 17 then goto change_room

   if request_pending || !pfscore1 then goto _skip_game_action ; game over screen or wait for new room

   if frame_counter then _Skip_dec_game_counter

   if !pfscore2 then _Decrease_small_counter
   pfscore2 = pfscore2 / 2
   goto _Skip_dec_game_counter
_Decrease_small_counter
   pfscore1 = pfscore1 / 2

   if !pfscore1 then _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0 : goto _skip_game_action

_Skip_dec_game_counter
   if delay_counter > 0 then delay_counter = delay_counter - 1 : goto _skip_game_action

   ;  Fire button check.
   ;  Skips this section if the fire button is not pressed.
   if !joy0fire then goto __Skip_Fire

   ;  Skips this section if missile0 is moving.
   if _Bit7_M0_Moving{7} then goto __Skip_Fire

   ;  Takes a 'snapshot' of player1 direction so missile0 will
   ;  stay on track until it hits something.
   _BitOp_M0_Dir = _BitOp_P1_Dir     ;  & $0F

   ;  No shoting up !
   if _Bit0_M0_Dir_Up{0} then goto __Skip_Fire

   if _BitOp_M0_Dir = 0 && _Bit6_Flip_P0{6} then _BitOp_M0_Dir = 4
   if _BitOp_M0_Dir = 0 && ! _Bit6_Flip_P0{6} then _BitOp_M0_Dir = 8

   ;  Turns on missile0 movement.
   _Bit7_M0_Moving{7} = 1

   ; reset missile gravity
   M0y_velocity = 0.0 : u = 0

   ;  Sets up starting position of missile0.
   if _Bit1_M0_Dir_Down{1} then missile0x = player1x + 9 : missile0y = player1y - 1
   if _Bit2_M0_Dir_Left{2} then missile0x = player1x + 2 : missile0y = player1y - 3
   if _Bit3_M0_Dir_Right{3} then missile0x = player1x + 16 : missile0y = player1y - 3

   ;  Turns on sound effect.
   if _Ch0_Sound <> 3 then _Ch0_Sound = 2 : _Ch0_Duration = 1 : _Ch0_Counter = 0

__Skip_Fire


   ;  Missile0 movement check.
   ;  Skips this section if missile0 isn't moving.
   if !_Bit7_M0_Moving{7} then goto __Skip_Missile

   ;  Moves missile0 in the appropriate direction.
   if _Bit1_M0_Dir_Down{1} then missile0y = missile0y + 2
   if _Bit2_M0_Dir_Left{2} then missile0x = missile0x - 2
   if _Bit3_M0_Dir_Right{3} then missile0x = missile0x + 2

   rem apply gravity
   M0y_velocity = M0y_velocity + gravity_missile0
   M0y_position = M0y_position + M0y_velocity


   ;  Clears missile0 if it hits the edge of the screen.
   if missile0y < _M_Edge_Top then goto __Delete_Missile
   if missile0y > _M_Edge_Bottom then goto __Delete_Missile
   if missile0x < _M_Edge_Left then goto __Delete_Missile
   if missile0x > _M_Edge_Right then goto __Delete_Missile

   ;  Skips rest of section if no collision.
   if !collision(playfield,missile0) then goto __Skip_Missile

   ;  Turns on sound effect.
   if _Ch0_Sound <> 3 then _Ch0_Sound = 1 : _Ch0_Duration = 1 : _Ch0_Counter = 0

__Delete_Missile

   ;  Clears missile0 bit and moves missile0 off the screen.
   _Bit7_M0_Moving{7} = 0 : missile0x = 200 : missile0y = 200
   
__Skip_Missile


   ;  Enemy/missile collision check.
   ;  Skips section if there is no collision.
   if !collision(player0,missile0) then __Skip_Shot_Enemy

   ;  Clears missile0 bit and moves missile0 off the screen.
   _Bit7_M0_Moving{7} = 0 : missile0x = 200 : missile0y = 200

   if roommate_type > 1 then __Skip_Shot_Enemy
   ;  Turns on sound effect.
   _Ch0_Sound = 3 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   
   ;  Clear enemy and air missile from screen.
   player0y = 200 : w_enemy_y_startpos = 200 : score = score + 40

__Skip_Shot_Enemy


   ;  Ball/missile collision check.
   ;  Skips section if there is no collision.
   if !collision(ball, missile0) then __Skip_Shot_Extra_Wall

   ;  Turns on sound effect.
   _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0

   ;  Clears missile0 bit and moves missile0 off the screen.
   _Bit7_M0_Moving{7} = 0 : missile0x = 200 : missile0y = 200

   ;  Clear wall from screen, if it is not a moving wall.
   if r_extra_wall_type > 3 then __Skip_Shot_Extra_Wall
   w_extra_wall_startpos = 200 : bally = 0 : score = score + 10

__Skip_Shot_Extra_Wall

   ;  Enemy/player collision check.
   ;  Skips section if there is no collision.
   if !collision(player1,player0) then goto __Skip_P1_Touched_P0

   ;  Turns on sound effect.
   if roommate_type > 1 then __Skip_P1_Touched_Enemy
   ; doo the kill ?
   if _Ch0_Sound <> 4 then _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   goto __Skip_P1_Touched_P0
__Skip_P1_Touched_Enemy
   if roommate_type = 2 then pfscore2 = pfscore2 * 2 | 1 : player1y = player1y - 1
   if _Ch0_Sound <> 3 then _Ch0_Sound = 3 : _Ch0_Duration = 1 : _Ch0_Counter = 0
__Skip_P1_Touched_P0

; Check for extra walls
   if r_extra_wall_startpos = 200 then goto _Skip_extra_Wall
   ballx = r_extra_wall_startpos + extra_wall_move_x
   bally = 47
   ballheight = 23
   CTRLPF = r_extra_wall_width | 1 ; * Ball 8 pixels wide ($00=1, $10=2, $20=4, $30=8).
_Skip_extra_Wall

; Check for enemy
   if r_enemy_y_startpos = 200 then goto _Skip_enemy
   player0x = r_enemy_x_startpos + roommate_move_x
   player0y = r_enemy_y_startpos
_Skip_enemy



   if collision(player1,playfield) && _Bit2_P1_Dir_Left{2} then player1x = player1x + 1
   if collision(player1,playfield) && _Bit3_P1_Dir_Right{3} then player1x = player1x - 1
   if collision(player1,playfield) && _Bit0_P1_Dir_Up{0} then player1y = player1y + 1
   if collision(player1,playfield) && _Bit1_P1_Dir_Down{1} then player1y = player1y - 1

   _BitOp_P1_Dir = _BitOp_P1_Dir & $F0 ; delete old directions

   if joy0up then P1y_velocity = 0.0 : player1y = player1y - 1 : _Bit0_P1_Dir_Up{0} = 1 : x = 0 : goto skip_gravity
   if joy0down then P1y_velocity = 0.0 : player1y = player1y + 1 : _Bit1_P1_Dir_Down{1} = 1 : x = 0 : goto skip_gravity

   if collision(player1,playfield) then P1y_velocity = 0.0 : goto skip_gravity

   rem apply gravity
   P1y_velocity = P1y_velocity + gravity_player1
   P1y_position = P1y_position + P1y_velocity

skip_gravity

   if joy0left then _Bit6_Flip_P0{6} = 1 : _Bit2_P1_Dir_Left{2} = 1 : player1x = player1x - 1 : goto _skip_move
   if joy0right then _Bit6_Flip_P0{6} = 0 : _Bit3_P1_Dir_Right{3} = 1 : player1x = player1x + 1
_skip_move

; check for leaving the room 3=left, 4=top, 5=right, 6=bottom
   if player1x < player_min_x then player1x = player_max_x : gosub _send_room_state : WriteSendBuffer = 3 : goto _skip_game_action
   if player1y < player_min_y then player1y = player_max_y : gosub _send_room_state : WriteSendBuffer = 4 : goto _skip_game_action
   if player1x > player_max_x then player1x = player_min_x : gosub _send_room_state : WriteSendBuffer = 5 : goto _skip_game_action
   if player1y > player_max_y then player1y = player_min_y : gosub _send_room_state : WriteSendBuffer = 6 : goto _skip_game_action

_skip_game_action
;  Channel 0 sound effect check.
   ;  Skips all channel 0 sounds if sounds are off.
   if !_Ch0_Sound then goto __Skip_Ch_0

   ;  Decreases the channel 0 duration counter.
   _Ch0_Duration = _Ch0_Duration - 1

   ;  Skips all channel 0 sounds if duration counter is greater
   ;  than zero
   if _Ch0_Duration then goto __Skip_Ch_0

   ;  Channel 0 sound effect 001.
   ;  Up sound effect.
   ;  Skips this section if sound 001 isn't on.
   if _Ch0_Sound <> 1 then goto __Skip_Ch0_Sound_001

   ;  Retrieves first part of channel 0 data.
   temp4 = _SD_Shot_Wall[_Ch0_Counter]

   ;  Checks for end of data.
   if temp4 = 255 then goto __Clear_Ch_0

   ;  Retrieves more channel 0 data.
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shot_Wall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shot_Wall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Plays channel 0.
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;  Sets Duration.
   _Ch0_Duration = _SD_Shot_Wall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Jumps to end of channel 0 area.
   goto __Skip_Ch_0

__Skip_Ch0_Sound_001

   ;  Channel 0 sound effect 002.
   ;  Shoot missile sound effect.
   ;  Skips this section if sound 002 isn't on.
   if _Ch0_Sound <> 2 then goto __Skip_Ch0_Sound_002

   ;  Retrieves first part of channel 0 data.
   temp4 = _SD_Shoot_Miss[_Ch0_Counter]

   ;  Checks for end of data.
   if temp4 = 255 then goto __Clear_Ch_0

   ;  Retrieves more channel 0 data.
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Plays channel 0.
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;  Sets Duration.
   _Ch0_Duration = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Jumps to end of channel 0 area.
   goto __Skip_Ch_0

__Skip_Ch0_Sound_002

   ;  Channel 0 sound effect 003.
   ;  Shoot enemy.
   ;  Skips this section if sound 003 isn't on.
   if _Ch0_Sound <> 3 then goto __Skip_Ch0_Sound_003

   ;  Retrieves first part of channel 0 data.
   temp4 = _SD_Shoot_Enemy[_Ch0_Counter]

   ;  Checks for end of data.
   if temp4 = 255 then goto __Clear_Ch_0

   ;  Retrieves more channel 0 data.
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shoot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shoot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Plays channel 0.
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;  Sets Duration.
   _Ch0_Duration = _SD_Shoot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Jumps to end of channel 0 area.
   goto __Skip_Ch_0

__Skip_Ch0_Sound_003

   ;  Channel 0 sound effect 004.
   ;  Touch enemy.
   ;  Skips this section if sound 004 isn't on.
   if _Ch0_Sound <> 4 then goto __Skip_Ch0_Sound_004

   ;  Retrieves first part of channel 0 data.
   temp4 = _SD_Touch_Enemy[_Ch0_Counter]

   ;  Checks for end of data.
   if temp4 = 255 then goto __Clear_Ch_0

   ;  Retrieves more channel 0 data.
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Touch_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Touch_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Plays channel 0.
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;  Sets Duration.
   _Ch0_Duration = _SD_Touch_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;  Jumps to end of channel 0 area.
   goto __Skip_Ch_0

__Skip_Ch0_Sound_004

   ;  Clears channel 0.
__Clear_Ch_0
   _Ch0_Sound = 0 : AUDV0 = 0

   ;  End of channel 0 area.
__Skip_Ch_0




   if _Bit6_Flip_P0{6} then REFP1 = 8

   drawscreen

   goto __Main_Loop




;  Sound data for shot hitting wall.
   data _SD_Shot_Wall
   8,8,0
   1
   8,8,1
   1
   8,14,1
   1
   8,8,0
   1
   8,8,2
   1
   8,14,2
   1
   8,8,1
   1
   7,8,3
   1
   6,8,2
   1
   5,8,4
   1
   4,8,3
   1
   3,8,5
   1
   2,14,4
   4
   255
end

;  Sound data for shooting missile.
   data _SD_Shoot_Miss
   8,15,0
   1
   12,15,1
   1
   8,7,20
   1
   10,15,3
   1
   8,7,22
   1
   10,15,5
   1
   8,15,6
   1
   10,7,24
   1
   8,15,8
   1
   9,7,27
   1
   8,15,10
   1
   7,14,11
   1
   6,15,12
   1
   5,6,13
   1
   4,15,14
   1
   3,6,27
   1
   2,6,30
   8
   255
end

;  Sound data for shooting enemy.
   data _SD_Shoot_Enemy
   12,4,23
   4
   10,4,29
   4
   8,4,23
   4
   6,4,29
   4
   4,4,23
   4
   3,4,29
   4
   2,4,23
   1
   1,4,29
   1
   255
end

;  Sound data for touching enemy.
   data _SD_Touch_Enemy
   2,7,11
   2
   10,7,12
   2
   8,7,13
   2
   8,7,14
   2
   8,7,21
   8
   4,7,22
   2
   2,7,23
   1
   255
end








 rem Add the room state of the room we are just leaving to the request to store it at the backend
_send_room_state
   request_pending = 1
   WriteToBuffer = r106 ; r_P0_type_and_range
   WriteToBuffer = r107 ; r_enemy_y_startpos
   WriteToBuffer = r108 ; r_enemy_x_startpos
   WriteToBuffer = r109 ; r_extra_wall_width
   WriteToBuffer = r110 ; r_extra_wall_type
   WriteToBuffer = r111 ; r_extra_wall_startpos
   return


 rem loading room (12 pf bytes + ) from backend
 rem and write to playfield RAM 
change_room
   delay_counter = 2 : player0y = 200
   _BitOp_misc = _BitOp_misc & %11111100  ; reset direction of enemy and wall to right
   asm
    LDA	#0
    STA	request_pending
    STA	bally
    STA	extra_wall_move_x
    STA	roommate_move_x
    TAX
.tile_loop
    LDA	ReceiveBuffer   		; 4
    STA	w_room_definition_start,x				    ; 5   @9
    INX					        ; 2   @11
    LDA	ReceiveBufferSize		; 4   @15
    BNE	.tile_loop			    ; 2/3 @18
end
   roommate_type = r_P0_type_and_range & 3
   goto _skip_game_action



 rem define PlusROM backend URL here
 rem don't let your program flow run into this code
 asm
 SET_PLUSROM_API "a.php", "ca.firmaplus.de"
end

   bank 2

   asm
XXminikernel
   sta WSYNC
   lda scback
   sta COLUBK
   rts
end