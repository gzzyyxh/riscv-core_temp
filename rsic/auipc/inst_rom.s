ori x2, x0, 0x0001
jal x1, 0x0010		//pc = 0x4 + 0x10 = 0x0014
ori x2, x0, 0x0002	//x1 = 0x8
ori x2, x0, 0x0003
jalr x1, x1, 0x0	//pc = 0x24,x1 = 0x14
ori x2, x0, 0x0004
ori x2, x0, 0x0005
ori x3, x0, 0x0006
jalr x1, x1, 0x4	//pc = 0x8 + 0x4 = 0xc,x1 = 0x24
ori x2, x0, 0x0007
ori x2, x0, 0x0008


00106113 
ef000001
00206113
00306113
000080e7
00406113
00506113
00606113
004080e7
00706113
00806113


大端法：

13611000
ef000001
13612000
13613000
e7800000
13614000
13615000
93616000
e7804000
13617000
13618000






分支指令

ori x1, x0, 0x1
ori x2, x0, 0x1
ori x3, x0, 0x2

ori x4, x0, 0x3
ori x4, x0, 0x4

beq x1, x2, 0x4

ori x4, x0, 0x5
ori x4, x0, 0x6
ori x4, x0, 0x7

bne x2, x3, 0x4

ori x4, x0, 0x8
ori x4, x0, 0x9
ori x4, x0, 0xa

blt x1, x3, 0x4

ori x4, x0, 0xb
ori x4, x0, 0xc
ori x4, x0, 0xd

ori x5, x0, 0xff
slli x5, x5, 8
ori x5, x5, 0xff
or x6, x0, x5
slli x5, x5, 16
or x5, x5, x6

bge x1, x5, 0x4

ori x4, x0, 0xe
ori x4, x0, 0xf
ori x4, x0, 0x10

bgeu x5, x1, 0x4

ori x4, x0, 0x11
ori x4, x0, 0x12
ori x4, x0, 0x13

bltu x1, x5, 0x4

ori x4, x0, 0x14



93601000
13611000
93612000
13623000
13624000
63822000
93621000
13625000
13626000
13627000
63123100
93821200
13628000
13629000
1362a000
63c23000
93821200
1362b000
1362c000
1362d000
9362f00f
93928200
93e2f20f
33635000
93920201
b3e26200
63d25000
93821200
1362e000
1362f000
13600001
63f21200
93821200
13621001
13622001
13623001
63e25000
93821200
13624001




beq:  √
ori x1, x0, 0x1
or x2, x0, x1
beq x1, x2, 0x10
ori x3, x0, 0x1
addi x3, x3, 0x1
addi x3, x3, 0x1
ori x4, x0, 0x1
addi x4, x4, 0x1

93601000
33611000
63882000
93611000
93811100
93811100
13621000
13021200

bnq:  √
ori x1, x0, 0x1
ori x2, x0, 0x2
bne x1, x2, 0x10
ori x3, x0, 0x1
addi x3, x3, 0x1
addi x3, x3, 0x1
ori x4, x0, 0x1
addi x4, x4, 0x1

93601000
13612000
63982000
93611000
93811100
93811100
13621000
13021200


bge: √

ori x1, x0, 0x2
ori x2, x0, 0x1
bge x1, x2, 0x10
ori x3, x0, 0x1
addi x3, x3, 0x1
addi x3, x3, 0x1
ori x4, x0, 0x1
addi x4, x4, 0x1

93602000
13611000
63d82000
93611000
93811100
93811100
13621000
13021200

blt:   √

ori x1, x0, 0x2
ori x2, x0, 0x1
blt x2, x1, 0x10
ori x3, x0, 0x1
addi x3, x3, 0x1
addi x3, x3, 0x1
ori x4, x0, 0x1
addi x4, x4, 0x1

93602000
13611000
63481100
93611000
93811100
93811100
13621000
13021200


bgeu:  √

ori x1, x0, 0xff
slli x1, x1, 8
ori x1, x1, 0xff
or x5, x0, x1
slli x1, x1, 16
or x1, x1, x5		x1 = 0xffffffff

ori x2, x0, 0x1
bge x1, x2, 0x10
ori x6, x0, x1
ori x7, x0, x1
bgeu x1, x2, 0x10
ori x3, x0, 0x1
addi x3, x3, 0x1
addi x3, x3, 0x1
ori x4, x0, 0x1
addi x4, x4, 0x1

9360f00f
93908000
93e0f00f
b3621000
93900001
b3e05000
13611000
63d82000
13631000
93631000
63f82000
93611000
93811100
93811100
13621000
13021200


bltu:		√


ori x1, x0, 0xff
slli x1, x1, 8
ori x1, x1, 0xff
or x5, x0, x1
slli x1, x1, 16
or x1, x1, x5		x1 = 0xffffffff

ori x2, x0, 0x1
blt x2, x1, 0x10
ori x6, x0, x1
ori x7, x0, x1
bltu x2, x1, 0x10
ori x3, x0, 0x1
addi x3, x3, 0x1
addi x3, x3, 0x1
ori x4, x0, 0x1
addi x4, x4, 0x1

9360f00f
93908000
93e0f00f
b3621000
93900001
b3e05000
13611000
63481100
13631000
93631000
63681100
93611000
93811100
93811100
13621000
13021200



auipc:

ori x1, x0, 0x1
ori x2, x0, 0x2
auipc x3, 0x3
ori x4, x0, 0x4


93601000
13612000
97010300
13624000









