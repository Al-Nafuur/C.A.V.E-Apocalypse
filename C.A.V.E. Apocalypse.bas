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

   const response_size_minus_1 = 26 ; = (w127 - w_room_definition_start - 1)
   const response_menu_size = 6


;  NTSC constants and colors
   ; requests 
   const req_load        = 0
   const req_level_up    = 1
   const req_game_over   = 2
   const req_move_left   = 3
   const req_move_up     = 4
   const req_move_right  = 5
   const req_move_down   = 6
   const req_level_reset = 7
   const req_safe_point  = 8
   const req_load_menu   = 9
   ; colors
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
; PAL constants and colors
   ; requests 
   const req_load        = 128 ; PAL x+128
   const req_level_up    = 129
   const req_game_over   = 130
   const req_move_left   = 131
   const req_move_up     = 132
   const req_move_right  = 133
   const req_move_down   = 134
   const req_level_reset = 135
   const req_safe_point  = 136
   const req_load_menu   = 137
   ; colors
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
   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2


   dim delay_counter = a
   dim frame_counter = b

   dim _BitOp_Ball_Shot_Dir = c
   dim _Bit0_Ball_Shot_Dir_Left1 = c
   dim _Bit1_Ball_Shot_Dir_Left2 = c
   dim _Bit2_Ball_Shot_Dir_Right1 = c
   dim _Bit3_Ball_Shot_Dir_Right2 = c

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

   ;  Channel 0 sound variables.
   dim _Ch0_Sound = f
   dim _Ch0_Duration = g
   dim _Ch0_Counter = h
   ; extra wall
   dim extra_wall_move_x = i
   dim roommate_move_x = j
   dim roommate_type = k

   dim _BitOp_Safe_Point_New_Room = l
   dim _Bit0_Safe_Point_reached   = l
   dim _Bit1_Safe_Point_P1_Flip   = l
   dim _Bit2_New_Room_Flip_P1     = l
   dim Safe_Point_P1_x  = m
   dim Safe_Point_P1_y  = n

   rem 16 bit velocity
   dim Bally_velocity = p.q
   rem 16 bit ball y position
   dim Bally_position = bally.r

   rem 16 bit velocity
   dim M0y_velocity = s.t
   rem 16 bit missile0 y position
   dim M0y_position = missile0y.u

   rem 16 bit velocity
   dim P1y_velocity = v.w
   rem 16 bit player1 y position
   dim P1y_position = player1y.x

   rem Various game states
   dim _Bit_Game_State        = y
   dim _Bit0_roommate_Dir     = y  ; direction of enemy (P0) or soldiers (P0), (0=right, 1=left)
   dim _Bit1_Wall_Dir         = y  ; direction of moveable wall (Ball), (0=right, 1=left)
   dim _Bit2_Level_finished   = y
   dim _Bit3_Ball_Shot_Moving = y
   dim _Bit4_Game_Over        = y
   dim _Bit5_Request_Pending  = y
   dim _Bit6_Flip_P1          = y
   dim _Bit7_M0_Moving        = y

   dim new_room_player1y     = var0
   dim new_room_player1x     = var1
   dim gamenumber            = var2

   dim max_pub_level_bcd1  = var3
   dim max_pub_level_bcd2  = var4
   dim max_pub_level_bcd3  = var5
   dim max_priv_level_bcd1 = var6
   dim max_priv_level_bcd2 = var7
   dim max_priv_level_bcd3 = var8


; SuperChip RAM used for room definitions before playfield area (w112/r112)
   dim w_room_definition_start      = w097

   dim r_BitOp_room_type            = r097
   dim w_BitOp_room_type            = r097
   dim r_Bit0_room_type_top         = r097
   dim r_room_color_top             = r098
   dim w_room_color_top             = w098
   dim r_room_color_middle          = r099
   dim w_room_color_middle          = w099
   dim r_room_color_bottom          = r103
   dim w_room_color_bottom          = w103
   dim r_roommate_type_and_range    = r104 ; $03 is P0 type (00=enemy, 01=air missile, 10=Fuel station, 11=soldier)
   dim w_roommate_type_and_range    = w104 ; $FC and $03 is moving range to the right
   dim r_roommate_startpos_x        = r105
   dim w_roommate_startpos_x        = w105
   dim r_roommate_startpos_y        = r106
   dim w_roommate_startpos_y        = w106
   dim r_extra_wall_type_and_range  = r107 ; type ($03) and wall range or blink frequenz (laser!)
   dim w_extra_wall_type_and_range  = w107
   dim r_extra_wall_width           = r108 ; wall width (D4 and D5) for CTRLPF
   dim w_extra_wall_width           = w108
   dim r_extra_wall_height          = r109 ; wall height default (23)
   dim w_extra_wall_height          = w109
   dim r_extra_wall_startpos_x      = r110
   dim w_extra_wall_startpos_x      = w110
   dim r_extra_wall_startpos_y      = r111 ; default 47
   dim w_extra_wall_startpos_y      = w111


_Start
   asm
   lda #0
   ldx #75
.clear_ram
   dex
   sta var0,x 
   bne .clear_ram
end

   WriteSendBuffer = req_load_menu : _Bit5_Request_Pending{5} = 1 : COLUP0 = _1C
   gamenumber = 1 : score = 1 : scorecolor = _0E
   player1x = 30 : player1y = 0 ; disable player1 on startscreen 
   new_room_player1y = player_min_y : new_room_player1x = 30
   AUDV0 = 0 : AUDV1 = 0
   missile0x = 200 : missile0y = 200 : missile0height = 1 : bally = 0
   w_extra_wall_startpos_x = 200   ; disable extra wall on start screen
   w_roommate_startpos_y = 200 : player0y = 200 : player0x = 0 ; disable player0 on startscreen

   Safe_Point_P1_x = 30 : Safe_Point_P1_y = player_min_y

   pfclear
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Title Menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_titlescreen_menu
   COLUBK = _00

   gosub titledrawscreen bank2

   if delay_counter > 0 then delay_counter = delay_counter - 1 : goto _titlescreen_menu

   if ReceiveBufferSize < response_menu_size then _Skip_Read_Menu_Response
   _Bit5_Request_Pending{5} = 0
   max_pub_level_bcd1 = ReceiveBuffer
   max_pub_level_bcd2 = ReceiveBuffer
   max_pub_level_bcd3 = ReceiveBuffer
   max_priv_level_bcd1 = ReceiveBuffer
   max_priv_level_bcd2 = ReceiveBuffer
   max_priv_level_bcd3 = ReceiveBuffer
_Skip_Read_Menu_Response

   if _Bit5_Request_Pending{5} then _titlescreen_menu ; wait for menu response

   if joy0left then score = score - 100 : delay_counter = 5
   if joy0down then score = score - 1 : delay_counter = 5
   if joy0right then score = score + 100 : delay_counter = 5
   if joy0up then score = score + 1 : delay_counter = 5

   ; asm compare of a 3 bcd number, adapted by Karl G with input from bogax.
   asm
   sed                              ; Set the Decimal Mode Flag
   lda max_pub_level_bcd3           ; Load the Accumulator
   cmp _sc3                         ; Compare Memory and the Accumulator
   lda max_pub_level_bcd2           ; Load the Accumulator
   sbc _sc2                         ; Subtract With Carry
   lda max_pub_level_bcd1           ; Load the Accumulator
   sbc _sc1                         ; Subtract With Carry
   cld                              ; Clear the Decimal Flag
   bcs ._Skip_Level_Reset           ; Branch if Carry Set
                                    ; (goto label if carry is set)
end
   score = 1

_Skip_Level_Reset
   if _sc1 = 0 && _sc2 = 0 && _sc3 = 0 then _sc1 = max_pub_level_bcd1 : _sc2 = max_pub_level_bcd2 : _sc3 = max_pub_level_bcd3

   if switchselect then gamenumber = gamenumber + 1 : delay_counter = 20 : if gamenumber > 2 then gamenumber = 1
   if !joy0fire then goto _titlescreen_menu

   WriteToBuffer = _sc1 : WriteToBuffer = _sc2 : WriteToBuffer = _sc3 : WriteToBuffer = gamenumber : WriteSendBuffer = req_load : _Bit5_Request_Pending{5} = 1

   player1y = player_min_y : score = 0 : _Bit4_Game_Over{4} = 0
   pfscore1 = %00101010 : pfscore2 = 255 : pfscorecolor = _1C

; My hack to move pfcolortable to SC RAM read port...
   asm
   lda	#>(r_room_color_middle-132+pfres*pfwidth)
   sta	pfcolortable+1
   lda	#<(r_room_color_middle-132+pfres*pfwidth)
   sta	pfcolortable
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__Main_Loop
   COLUPF = r_room_color_top
   NUSIZ1 = $05
   NUSIZ0 = $10
   COLUBK = _00

   if switchreset then goto _Start ; toDo wait for end of request with timeout if _Bit5_Request_Pending{5} = 0 

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

   on roommate_type goto _roommate_Enemy_def _roommate_Air_Missile_def _roommate_Fuel_def _roommate_Soldier_def

_roommate_Enemy_def
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
   goto _roommate_End_def

_roommate_Air_Missile_def
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
   goto _roommate_End_def

_roommate_Fuel_def
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
   goto _roommate_End_def

_roommate_Soldier_def
   if frame_counter{2} then player0: 
   %10100110
   %01000010
   %01100011
   %01000010
end
   if !frame_counter{2} then player0: 
   %11000101
   %01000010
   %01100011
   %01000010
end
_roommate_End_def

; compute movement of enemy, wall and soldiers
   if !frame_counter{4} then _Skip_Wall_Movement
   if r_extra_wall_type_and_range < 4 then _Finish_Interior_Movement
   if _Bit1_Wall_Dir{1} then extra_wall_move_x = extra_wall_move_x - 1 else extra_wall_move_x = extra_wall_move_x + 1
   if extra_wall_move_x = r_extra_wall_type_and_range then _Bit1_Wall_Dir{1} = 1
   if !extra_wall_move_x then _Bit1_Wall_Dir{1} = 0
   goto _Finish_Interior_Movement
_Skip_Wall_Movement

   if r_roommate_type_and_range < 4 then _Finish_Interior_Movement
   if _Bit0_roommate_Dir{0} then roommate_move_x = roommate_move_x - 1 else roommate_move_x = roommate_move_x + 1
   if roommate_move_x = r_roommate_type_and_range then _Bit0_roommate_Dir{0} = 1
   if !roommate_move_x then _Bit0_roommate_Dir{0} = 0

_Finish_Interior_Movement

   frame_counter = frame_counter + 1

; Check for extra walls
   if r_extra_wall_startpos_x = 200 then _Skip_extra_Wall
   ballx = r_extra_wall_startpos_x + extra_wall_move_x
   bally = 47
   ballheight = 23
   CTRLPF = r_extra_wall_width | 1 ; * Ball 8 pixels wide ($00=1, $10=2, $20=4, $30=8).
_Skip_extra_Wall

   if !_Bit3_Ball_Shot_Moving{3} then _Skip_ball_shot
   ballheight = 2
   CTRLPF = %00010001 ; * Ball 8 pixels wide ($00=1, $10=2, $20=4, $30=8).
_Skip_ball_shot

; Check for enemy
   if r_roommate_startpos_y = 200 then _Skip_enemy
   player0x = r_roommate_startpos_x + roommate_move_x
   player0y = r_roommate_startpos_y
_Skip_enemy



; Check buffer and request status
   if delay_counter > 0 then delay_counter = delay_counter - 1 : goto _skip_game_action

   if ReceiveBufferSize > response_size_minus_1 then goto _Change_Room

   if _Bit5_Request_Pending{5} || _Bit4_Game_Over{4} then goto _skip_game_action ; game over screen or wait for new room

   if !_Bit2_Level_finished{2} then _game_action
   _Ch0_Sound = 3 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   delay_counter = 25
   
   ; 100 points for timer point left
   if pfscore2 then pfscore2 = pfscore2 / 2 : score = score + 100 : goto _skip_game_action

   ; 200 points for each life left
   score = score + 200
   pfscore1 = pfscore1 / 4
   if !pfscore1 then _Bit2_Level_finished{2} = 0 : goto _Level_Up
   goto _skip_game_action


_game_action

   if frame_counter then _Skip_dec_game_counter

   if !pfscore2 then _Decrease_live_counter
   pfscore2 = pfscore2 / 2
   goto _Skip_dec_game_counter
_Decrease_live_counter
   pfscore1 = pfscore1 / 4

    _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   if !pfscore1 then goto _Set_Game_Over else goto _Reset_Level
_Skip_dec_game_counter


   ;  Skips this section if Enemy shoot is moving.
   if player0y = 200 then goto __Skip_Enemy_Fire
   if _Bit3_Ball_Shot_Moving{3} || roommate_type then goto __Skip_Enemy_Fire
    ;  Turns on ball shoot movement.
   _Bit3_Ball_Shot_Moving{3} = 1 : _BitOp_Ball_Shot_Dir = 0 : Bally_velocity = 0.0 : q = 0

   ballx = player0x + 4 : bally = player0y - 5

   ; sound for enemy shot !
   if _Ch0_Sound <> 3 then _Ch0_Sound = 2 : _Ch0_Duration = 1 : _Ch0_Counter = 0

   if player1x > player0x then _Bit2_Ball_Shot_Dir_Right1{2} = 1 else _Bit0_Ball_Shot_Dir_Left1{0} = 1
   if !_Bit2_Ball_Shot_Dir_Right1{2} then __Skip_Additional_Right
   temp4 =  player1x - player0x
   if temp4 > 25 then _Bit3_Ball_Shot_Dir_Right2{3} = 1
__Skip_Additional_Right
   if !_Bit0_Ball_Shot_Dir_Left1{0} then __Skip_Enemy_Fire
   temp4 =  player0x - player1x
   if temp4 > 25 then _Bit1_Ball_Shot_Dir_Left2{1} = 1

__Skip_Enemy_Fire

   ;  Missile0 movement check.
   ;  Skips this section if missile0 isn't moving.
   if !_Bit3_Ball_Shot_Moving{3} then goto __Skip_Enemy_Missile

   ;  Moves missile0 in the appropriate direction.
   if bally > player1y then bally = bally - 1
   if _Bit0_Ball_Shot_Dir_Left1{0} then ballx = ballx - 1 : if _Bit1_Ball_Shot_Dir_Left2{1} then ballx = ballx - 1
   if _Bit2_Ball_Shot_Dir_Right1{2} then ballx = ballx + 1 : if _Bit3_Ball_Shot_Dir_Right2{3} then ballx = ballx + 1

   rem apply gravity
   Bally_velocity = Bally_velocity + gravity_missile0
   Bally_position = Bally_position + Bally_velocity


   ;  Clears missile0 if it hits the edge of the screen.
   if bally < _M_Edge_Top then goto __Delete_Enemy_Missile
   if bally > _M_Edge_Bottom then goto __Delete_Enemy_Missile
   if ballx < _M_Edge_Left then goto __Delete_Enemy_Missile
   if ballx > _M_Edge_Right then goto __Delete_Enemy_Missile

   ;  Skips rest of section if no collision.
   if !collision(playfield,ball) then goto __Skip_Enemy_Missile

__Delete_Enemy_Missile

   ;  Clears missile0 bit and moves missile0 off the screen.
   _Bit3_Ball_Shot_Moving{3} = 0 : ballx = 200 : bally = 200
   
__Skip_Enemy_Missile



   ;  Fire button check.
   ;  Skips this section if the fire button is not pressed.
   if !joy0fire then goto __Skip_Fire

   ;  Skips this section if missile0 is moving, or Player moves up
   if _Bit7_M0_Moving{7} || _Bit0_P1_Dir_Up{0} then goto __Skip_Fire

   ;  Takes a 'snapshot' of player1 direction so missile0 will
   ;  stay on track until it hits something.
   _BitOp_M0_Dir = _BitOp_P1_Dir     ;  & $0F

   if _BitOp_M0_Dir = 0 && _Bit6_Flip_P1{6} then _BitOp_M0_Dir = 4
   if _BitOp_M0_Dir = 0 && ! _Bit6_Flip_P1{6} then _BitOp_M0_Dir = 8

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

   ;  Turns on sound effect for missile0 hits playfield.
   ;if _Ch0_Sound <> 3 then _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0

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
   _Ch0_Sound = 1 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   
   ;  Clear enemy and air missile from screen.
   player0y = 200 : w_roommate_startpos_y = 200 : score = score + 40

__Skip_Shot_Enemy


   ;  Ball/missile collision check.
   ;  Skips section if there is no collision.
   if !collision(ball, missile0) then __Skip_Shot_Extra_Wall

   ;  Clears missile0 bit and moves missile0 off the screen.
   _Bit7_M0_Moving{7} = 0 : missile0x = 200 : missile0y = 200

   ;  Turns on sound effect and clear wall from screen, if it is not a moving wall.
   if r_extra_wall_type_and_range > 3 then __Skip_Shot_Extra_Wall

   _Ch0_Sound = 1 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   w_extra_wall_startpos_x = 200 : bally = 0 : score = score + 10

__Skip_Shot_Extra_Wall

   ;  player/roomate collision check.
   ;  Skips section if there is no collision.
   if !collision(player1,player0) then goto __Skip_P1_Touched_P0

   ;  Enemy touched.
   if roommate_type < 2 then goto _Decrease_live_counter

   ;  Friend touched.
   if _Ch0_Sound <> 3 then _Ch0_Sound = 3 : _Ch0_Duration = 1 : _Ch0_Counter = 0
   if roommate_type = 3 then _Bit2_Level_finished{2} = 1 : player0y = 200 : w_roommate_startpos_y = 200 : score = score + frame_counter : goto _skip_game_action
   if roommate_type = 2 then P1y_velocity = 0.0 : x = 0 : pfscore2 = pfscore2 * 2 | 1 : player1y = player1y - 1 : if !_Bit0_Safe_Point_reached{0} then WriteSendBuffer = req_safe_point : _Bit0_Safe_Point_reached{0} = 1 : Safe_Point_P1_x = player1x : Safe_Point_P1_y = player1y : _Bit1_Safe_Point_P1_Flip{1} = _Bit6_Flip_P1{6}
__Skip_P1_Touched_P0

   ;  player/(ball, playfield) collision check.
   ;  Skips section if there is no collision.
   if collision(player1,ball) || collision(player1,playfield) then goto _Decrease_live_counter


   _BitOp_P1_Dir = _BitOp_P1_Dir & $F0 ; delete old directions (do we still need this?)

   if joy0up then P1y_velocity = 0.0 : x = 0 : player1y = player1y - 1 : _Bit0_P1_Dir_Up{0} = 1 : goto skip_gravity
   if joy0down then player1y = player1y + 1 : _Bit1_P1_Dir_Down{1} = 1

   rem apply gravity
   P1y_velocity = P1y_velocity + gravity_player1
   P1y_position = P1y_position + P1y_velocity

skip_gravity

   if joy0left then _Bit6_Flip_P1{6} = 1 : _Bit2_P1_Dir_Left{2} = 1 : player1x = player1x - 1 : goto _skip_move
   if joy0right then _Bit6_Flip_P1{6} = 0 : _Bit3_P1_Dir_Right{3} = 1 : player1x = player1x + 1
_skip_move

   ; dont leave top rooms to the top.
   if player1y < player_min_y && r_Bit0_room_type_top{0} then player1y = player_min_y : goto _skip_game_action
; check for leaving the room
   if player1x < player_min_x then _Bit2_New_Room_Flip_P1{2} = _Bit6_Flip_P1{6} : new_room_player1y = player1y : new_room_player1x = player_max_x : gosub _Add_Room_State : WriteSendBuffer = req_move_left : goto _skip_game_action
   if player1y < player_min_y then _Bit2_New_Room_Flip_P1{2} = _Bit6_Flip_P1{6} : new_room_player1x = player1x : new_room_player1y = player_max_y : gosub _Add_Room_State : WriteSendBuffer = req_move_up : goto _skip_game_action
   if player1x > player_max_x then _Bit2_New_Room_Flip_P1{2} = _Bit6_Flip_P1{6} : new_room_player1y = player1y : new_room_player1x = player_min_x : gosub _Add_Room_State : WriteSendBuffer = req_move_right : goto _skip_game_action
   if player1y > player_max_y then _Bit2_New_Room_Flip_P1{2} = _Bit6_Flip_P1{6} : new_room_player1x = player1x : new_room_player1y = player_min_y : gosub _Add_Room_State : WriteSendBuffer = req_move_down : goto _skip_game_action

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
   if _Ch0_Counter{0} then COLUBK = _E0

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




   if _Bit6_Flip_P1{6} then REFP1 = 8
   if _Bit0_roommate_Dir{0} then REFP0 = 8

   drawscreen

   goto __Main_Loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions / Subroutines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_Set_Game_Over
   WriteToBuffer = _sc1
   WriteToBuffer = _sc2
   WriteToBuffer = _sc3
   WriteSendBuffer = req_game_over
   _Bit4_Game_Over{4} = 1
   goto _skip_game_action
 
_Reset_Level
   WriteSendBuffer = req_level_reset
   _Bit2_New_Room_Flip_P1{2} = _Bit1_Safe_Point_P1_Flip{1}

_Common_Reset
   delay_counter = 60
   _Bit5_Request_Pending{5} = 1
   pfscore2 = 255
   P1y_velocity = 0.0 : x = 0
   new_room_player1x = Safe_Point_P1_x
   new_room_player1y = Safe_Point_P1_y
   goto _skip_game_action

_Level_Up
   WriteToBuffer = _sc1
   WriteToBuffer = _sc2
   WriteToBuffer = _sc3
   WriteSendBuffer = req_level_up
   _BitOp_Safe_Point_New_Room = 0 ;  == _Bit2_New_Room_Flip_P1{2} = 0 :_Bit1_Safe_Point_P1_Flip{1} = 0 : _Bit0_Safe_Point_reached{0} = 0
   Safe_Point_P1_x = 30
   Safe_Point_P1_y = player_min_y
   pfscore1 = %00101010
   score = 0
   goto _Common_Reset

; Add the room state of the room we are just leaving to the request,
; to store it in the backend session
_Add_Room_State
   _Bit5_Request_Pending{5} = 1
   WriteToBuffer = r104 ; r_roommate_type_and_range
   WriteToBuffer = r105 ; r_roommate_startpos_x
   WriteToBuffer = r106 ; r_roommate_startpos_y
   WriteToBuffer = r107 ; r_extra_wall_type_and_range
   WriteToBuffer = r108 ; r_extra_wall_width
   WriteToBuffer = r109 ; r_extra_wall_height
   WriteToBuffer = r110 ; r_extra_wall_startpos_x
   WriteToBuffer = r111 ; r_extra_wall_startpos_y
   return


; loading room (12 pf bytes + interior ) from backend
; and write to SC/playfield RAM 
_Change_Room
   delay_counter = 2 : player0y = 200
   _Bit_Game_State = _Bit_Game_State & %11111100  ; reset direction of enemy and wall to right
   _Bit5_Request_Pending{5} = 0
   _Bit0_Safe_Point_reached{0} = 0
   player1y = new_room_player1y : player1x = new_room_player1x : _Bit6_Flip_P1{6} = _Bit2_New_Room_Flip_P1{2}
   asm
    LDA	#0
    STA	bally
    STA	extra_wall_move_x
    STA	roommate_move_x
    TAX
.copy_loop
    LDA	ReceiveBuffer   		; 4
    STA	w_room_definition_start,x				    ; 5   @9
    INX					        ; 2   @11
    LDA	ReceiveBufferSize		; 4   @15
    BNE	.copy_loop			    ; 2/3 @18
end
   roommate_type = r_roommate_type_and_range & 3
   goto _skip_game_action

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data Tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


; define PlusROM backend URL here
; don't let your program flow run into this code
 asm
 SET_PLUSROM_API "a.php", "ca.firmaplus.de"
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bank 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   bank 2

   asm
   include "titlescreen/asm/titlescreen.asm"
end

   asm
minikernel
   sta WSYNC
   lda scback
   sta COLUBK
   rts
end