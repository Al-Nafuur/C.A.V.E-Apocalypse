
 ;*** The height of the displayed data...
bmp_48x2_1_window = 5

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_48x2_1_height = 5

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif
 BYTE 0 ; leave this here!


 ;*** The color of each line in the bitmap, in reverse order...
bmp_48x2_1_colors 
	BYTE _84
	BYTE _88
	BYTE _48
	BYTE _46
	BYTE _44

 ifnconst bmp_48x2_1_PF1
bmp_48x2_1_PF1
 endif
        BYTE %00000000
 ifnconst bmp_48x2_1_PF2
bmp_48x2_1_PF2
 endif
        BYTE %00000000
 ifnconst bmp_48x2_1_background
bmp_48x2_1_background
 endif
        BYTE $c2

   if >. != >[.+bmp_48x2_1_height]
      align 256
   endif


bmp_48x2_1_00
	BYTE %11101110
	BYTE %10001000
	BYTE %10001100
	BYTE %10001000
	BYTE %10001110
	BYTE %10001000

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_01
	BYTE %01001110
	BYTE %01001000
	BYTE %10101100
	BYTE %10101000
	BYTE %10101110
	BYTE %01001000

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_02
	BYTE %11100000
	BYTE %10000000
	BYTE %10000000
	BYTE %10000000
	BYTE %10000000
	BYTE %10000000

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_03
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_04
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   if >. != >[.+(bmp_48x2_1_height)]
      align 256
   endif

bmp_48x2_1_05
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

