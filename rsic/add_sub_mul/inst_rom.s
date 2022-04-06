ori x1, x0, 0x0x0040
slli x1, x1, 16		//x1 = 0x400000
ori x1, x1, 0x0010	//x1 = 0x400010

or x2, x0, x1	//x2 = 0x400010
ori x3, x0, 0x0

addi x3, x2, 0x1

ori x4, x0, 0xfff
slli x4, x4, 16

ori x5, x0, 0x0

addi x5, x4, 0x1
add x5, x4, x4

add x3, x1, x2
addi x3, x3, 0x1

sub x3, x3, x1

ori x6, x1, 0xfff
slli x6, x6, 16		//x6 = 0xfff0000

slt x7, x6, x0		//x7 = 1
sltu x7, x6, x0		//x7 = 0
slti x7, x6, 0		//x7 = 1
sltiu x7, x6, 0		//x7 = 0

ori x8, x0, 0x3
ori x9, x0, 0x1
sub x10, x9, x8

04006093
01009093
0100e093
00106133
00006193
00110193
fff06213
01021213
00006293
00120293
004202b3
002081b3
00118193
401181b3
fff0e313
01031313
000323b3
000333b3
00032393
00033393
00306413
00106493
40848533


# mul mulh mulhu mulhsu





ori x1, x0, 0x00ff
slli, x1, x1, 8
ori x1, x1, 0x00ff
slli x1, x1, 16		x1 = 0xffff0000

ori x2, x0, 0x00ff
slli, x2, x2, 8
ori x2, x2, 0x00fb	x2 = 0xfffb

or x1, x1, x2		x1 = -5
ori x3, x0, 6		x3 = 6
mul x4, x1, x3		x4 = -30 = 0xffffffe2		0000001-00011-00001-000-00100-0110011

mulh x5, x1, x3		x5 = 0xffffffff		0000001-00011-00001-001-00101-0110011

mulhsu x6, x1, x3	x6 = 0xffffffff		0000001-00011-00001-010-00110-0110011

ori x7, x0, 0x40
ori x8, x0, 0x50

mul x9, x7, x8		0000001-01000-00111-000-01001-0110011
mulh x10, x7, x8		0000001-01000-00111-001-01010-0110011
mulhu x11, x7, x8		0000001-01000-00111-011-01011-0110011



0ff06093
00809093
0ff0e093
01009093
0ff06113
00811113
0fb16113
0020e0b3
00606193
02308233
023092b3
0230a333
04006393
05006413
028384b3
02839533
0283b5b3



# div divu


ori x2, x0, 0x00ff
slli x2, x2, 8
or x3, x0, x2		x3 = x2 = 0xff00
ori x2, x2, 0xff
slli x2, x2, 16		x2 = 0xffff0000
ori x3, x3, 0xf1	x3 = 0xfff1
or x2, x2, x3		x2 = 0xfffffff1 = -15
ori x4, x0, 0x11	x4 = 17

div x5, x2, x4		x5 = 0x0		0000001-00100-00010-100-00101-0110011
divu x6, x2, x4		x6 = 0x0f0f0f0e		0000001-00100-00010-101-00110-0110011
div x7 x4, x2		x7 = 0xffffffff		0000001-00010-00100-100-00111-0110011
rem x5, x2, x4		x5 = 0xfffffff1
remu x6, x2, x4		x6 = 0x00000003
rem x7, x4, x2		x7 = 0x2

0ff06113
00811113
002061b3
0ff16113
01011113
0f11e193
00316133
01106213
024142b3
02415333
022243b3
024162b3
02417333
022263b3






















