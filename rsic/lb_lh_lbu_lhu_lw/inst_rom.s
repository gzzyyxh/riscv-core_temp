ori x3, x0, 0xee
slli x3, x3, 8
ori x3, x3, 0xff	x3 = 0xeeff

sb x3, 3(x0)		[0x3] = 0xff

srli x3, x3, 8		x3 = 0xee

sb x3, 2(x0)		[0x2] = 0xee

ori x3, x0, 0xcc	x3 = 0xcc

sb x3, 1(x0)		[0x1] = 0xcc

lb x1, 3(x0)		x1 = 0xffffffff
lbu x1, 2(x0)		x1 = 0xee

ori x3, x0, 0xaa
slli x3, x3, 8
ori x3, x3, 0xbb	x3 = 0xaabb

sh x3, 4(x0)		[0x4] = 0xaa [0x5] = 0xbb

lhu x1, 4(x0)		x1 = 0xaabb
lh x1, 4(x0)		x1 = 0xffffaabb

ori x3, x0, 0x88
slli x3, x3, 8
ori x3, x3, 0x99	x3 = 0x8899

sh x3, 6(x0)		[0x6] = 0x88 [0x7] = 0x99

lh x1, 6(x0)		x1 = 0xffff8899
lhu x1, 6(x0)		x1 = 0x8899

ori x3, x0, 0x44
slli x3, x3, 8
ori x3, x3, 0x55	x3 = 0x4455
slli x3, x3, 8
ori x3, x3, 0x66	x3 = 0x445566
slli x3, x3, 8
ori x3, x3, 0x77	x3 = 0x44556677

sw x3, 8(x0)		[0x8] = 0x44 [0x9] = 0x55
			[0xa] = 0x66 [0xb] = 0x77
lw x1, 8(x0)		x1 = 0x44556677



9361e00e
93918100
93e1f10f
a3013000
93d18100
23013000
9361c00c
a3003000
83003000
83402000
9361a00a
93918100
93e1b10b
23123000
83504000
83104000
93618008
93918100
93e19109
23133000
83106000
83506000
93614004
93918100
93e15105
93918100
93e16106
93918100
93e17107
23243000
83208000













































