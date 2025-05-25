
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	97013103          	ld	sp,-1680(sp) # 80008970 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// set up to receive timer interrupts in machine mode,
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64 r_mhartid()
{
    uint64 x;
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80000022:	f14027f3          	csrr	a5,mhartid
    // each CPU has a separate source of timer interrupts.
    int id = r_mhartid();

    // ask the CLINT for a timer interrupt.
    int interval = 1000000; // cycles; about 1/10th second in qemu.
    *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

    // prepare information in scratch[] for timervec.
    // scratch[0..3] : space for timervec to save registers.
    // scratch[4] : address of CLINT MTIMECMP register.
    // scratch[5] : desired interval (in cycles) between timer interrupts.
    uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	addi	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
    scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
    scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
    asm volatile("csrw sscratch, %0" : : "r"(x));
}

static inline void w_mscratch(uint64 x)
{
    asm volatile("csrw mscratch, %0" : : "r"(x));
    80000058:	34079073          	csrw	mscratch,a5
    asm volatile("csrw mtvec, %0" : : "r"(x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	12478793          	addi	a5,a5,292 # 80006180 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    80000068:	300027f3          	csrr	a5,mstatus

    // set the machine-mode trap handler.
    w_mtvec((uint64)timervec);

    // enable machine-mode interrupts.
    w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    80000070:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    80000074:	304027f3          	csrr	a5,mie

    // enable machine-mode timer interrupts.
    w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mstatus" : "=r"(x));
    8000008e:	300027f3          	csrr	a5,mstatus
    x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    80000098:	8ff9                	and	a5,a5,a4
    x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800000a2:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e0278793          	addi	a5,a5,-510 # 80000ea8 <main>
    800000ae:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    800000c0:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    800000c4:	104027f3          	csrr	a5,sie
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    800000cc:	10479073          	csrw	sie,a5
    timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    800000d8:	f14027f3          	csrr	a5,mhartid
    w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
    uint64 x;
    asm volatile("mv %0, tp" : "=r"(x));
    return x;
}

static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    800000de:	823e                	mv	tp,a5
    asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
    int i;

    acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	addi	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	af2080e7          	jalr	-1294(ra) # 80000bfe <acquire>
    for (i = 0; i < n; i++)
    80000114:	05305b63          	blez	s3,8000016a <consolewrite+0x7e>
    80000118:	4901                	li	s2,0
    {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	364080e7          	jalr	868(ra) # 8000248a <either_copyin>
    8000012e:	01550c63          	beq	a0,s5,80000146 <consolewrite+0x5a>
            break;
        uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	796080e7          	jalr	1942(ra) # 800008cc <uartputc>
    for (i = 0; i < n; i++)
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
    }
    release(&cons.lock);
    80000146:	00011517          	auipc	a0,0x11
    8000014a:	6ea50513          	addi	a0,a0,1770 # 80011830 <cons>
    8000014e:	00001097          	auipc	ra,0x1
    80000152:	b64080e7          	jalr	-1180(ra) # 80000cb2 <release>

    return i;
}
    80000156:	854a                	mv	a0,s2
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	7942                	ld	s2,48(sp)
    80000160:	79a2                	ld	s3,40(sp)
    80000162:	7a02                	ld	s4,32(sp)
    80000164:	6ae2                	ld	s5,24(sp)
    80000166:	6161                	addi	sp,sp,80
    80000168:	8082                	ret
    for (i = 0; i < n; i++)
    8000016a:	4901                	li	s2,0
    8000016c:	bfe9                	j	80000146 <consolewrite+0x5a>

000000008000016e <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	7159                	addi	sp,sp,-112
    80000170:	f486                	sd	ra,104(sp)
    80000172:	f0a2                	sd	s0,96(sp)
    80000174:	eca6                	sd	s1,88(sp)
    80000176:	e8ca                	sd	s2,80(sp)
    80000178:	e4ce                	sd	s3,72(sp)
    8000017a:	e0d2                	sd	s4,64(sp)
    8000017c:	fc56                	sd	s5,56(sp)
    8000017e:	f85a                	sd	s6,48(sp)
    80000180:	f45e                	sd	s7,40(sp)
    80000182:	f062                	sd	s8,32(sp)
    80000184:	ec66                	sd	s9,24(sp)
    80000186:	e86a                	sd	s10,16(sp)
    80000188:	1880                	addi	s0,sp,112
    8000018a:	8aaa                	mv	s5,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
    uint target;
    int c;
    char cbuf;

    target = n;
    80000190:	00060b1b          	sext.w	s6,a2
    acquire(&cons.lock);
    80000194:	00011517          	auipc	a0,0x11
    80000198:	69c50513          	addi	a0,a0,1692 # 80011830 <cons>
    8000019c:	00001097          	auipc	ra,0x1
    800001a0:	a62080e7          	jalr	-1438(ra) # 80000bfe <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001a4:	00011497          	auipc	s1,0x11
    800001a8:	68c48493          	addi	s1,s1,1676 # 80011830 <cons>
            if (myproc()->killed)
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001ac:	00011917          	auipc	s2,0x11
    800001b0:	71c90913          	addi	s2,s2,1820 # 800118c8 <cons+0x98>
        }

        c = cons.buf[cons.r++ % INPUT_BUF];

        if (c == C('D'))
    800001b4:	4b91                	li	s7,4
            break;
        }

        // copy the input byte to the user-space buffer.
        cbuf = c;
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b6:	5c7d                	li	s8,-1
            break;

        dst++;
        --n;

        if (c == '\n')
    800001b8:	4ca9                	li	s9,10
    while (n > 0)
    800001ba:	07305863          	blez	s3,8000022a <consoleread+0xbc>
        while (cons.r == cons.w)
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	02f71463          	bne	a4,a5,800001ee <consoleread+0x80>
            if (myproc()->killed)
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	800080e7          	jalr	-2048(ra) # 800019ca <myproc>
    800001d2:	591c                	lw	a5,48(a0)
    800001d4:	e7b5                	bnez	a5,80000240 <consoleread+0xd2>
            sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	000080e7          	jalr	ra # 800021da <sleep>
        while (cons.r == cons.w)
    800001e2:	0984a783          	lw	a5,152(s1)
    800001e6:	09c4a703          	lw	a4,156(s1)
    800001ea:	fef700e3          	beq	a4,a5,800001ca <consoleread+0x5c>
        c = cons.buf[cons.r++ % INPUT_BUF];
    800001ee:	0017871b          	addiw	a4,a5,1
    800001f2:	08e4ac23          	sw	a4,152(s1)
    800001f6:	07f7f713          	andi	a4,a5,127
    800001fa:	9726                	add	a4,a4,s1
    800001fc:	01874703          	lbu	a4,24(a4)
    80000200:	00070d1b          	sext.w	s10,a4
        if (c == C('D'))
    80000204:	077d0563          	beq	s10,s7,8000026e <consoleread+0x100>
        cbuf = c;
    80000208:	f8e40fa3          	sb	a4,-97(s0)
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020c:	4685                	li	a3,1
    8000020e:	f9f40613          	addi	a2,s0,-97
    80000212:	85d2                	mv	a1,s4
    80000214:	8556                	mv	a0,s5
    80000216:	00002097          	auipc	ra,0x2
    8000021a:	21e080e7          	jalr	542(ra) # 80002434 <either_copyout>
    8000021e:	01850663          	beq	a0,s8,8000022a <consoleread+0xbc>
        dst++;
    80000222:	0a05                	addi	s4,s4,1
        --n;
    80000224:	39fd                	addiw	s3,s3,-1
        if (c == '\n')
    80000226:	f99d1ae3          	bne	s10,s9,800001ba <consoleread+0x4c>
            // a whole line has arrived, return to
            // the user-level read().
            break;
        }
    }
    release(&cons.lock);
    8000022a:	00011517          	auipc	a0,0x11
    8000022e:	60650513          	addi	a0,a0,1542 # 80011830 <cons>
    80000232:	00001097          	auipc	ra,0x1
    80000236:	a80080e7          	jalr	-1408(ra) # 80000cb2 <release>

    return target - n;
    8000023a:	413b053b          	subw	a0,s6,s3
    8000023e:	a811                	j	80000252 <consoleread+0xe4>
                release(&cons.lock);
    80000240:	00011517          	auipc	a0,0x11
    80000244:	5f050513          	addi	a0,a0,1520 # 80011830 <cons>
    80000248:	00001097          	auipc	ra,0x1
    8000024c:	a6a080e7          	jalr	-1430(ra) # 80000cb2 <release>
                return -1;
    80000250:	557d                	li	a0,-1
}
    80000252:	70a6                	ld	ra,104(sp)
    80000254:	7406                	ld	s0,96(sp)
    80000256:	64e6                	ld	s1,88(sp)
    80000258:	6946                	ld	s2,80(sp)
    8000025a:	69a6                	ld	s3,72(sp)
    8000025c:	6a06                	ld	s4,64(sp)
    8000025e:	7ae2                	ld	s5,56(sp)
    80000260:	7b42                	ld	s6,48(sp)
    80000262:	7ba2                	ld	s7,40(sp)
    80000264:	7c02                	ld	s8,32(sp)
    80000266:	6ce2                	ld	s9,24(sp)
    80000268:	6d42                	ld	s10,16(sp)
    8000026a:	6165                	addi	sp,sp,112
    8000026c:	8082                	ret
            if (n < target)
    8000026e:	0009871b          	sext.w	a4,s3
    80000272:	fb677ce3          	bgeu	a4,s6,8000022a <consoleread+0xbc>
                cons.r--;
    80000276:	00011717          	auipc	a4,0x11
    8000027a:	64f72923          	sw	a5,1618(a4) # 800118c8 <cons+0x98>
    8000027e:	b775                	j	8000022a <consoleread+0xbc>

0000000080000280 <consputc>:
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e406                	sd	ra,8(sp)
    80000284:	e022                	sd	s0,0(sp)
    80000286:	0800                	addi	s0,sp,16
    if (c == BACKSPACE)
    80000288:	10000793          	li	a5,256
    8000028c:	00f50a63          	beq	a0,a5,800002a0 <consputc+0x20>
        uartputc_sync(c);
    80000290:	00000097          	auipc	ra,0x0
    80000294:	55e080e7          	jalr	1374(ra) # 800007ee <uartputc_sync>
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret
        uartputc_sync('\b');
    800002a0:	4521                	li	a0,8
    800002a2:	00000097          	auipc	ra,0x0
    800002a6:	54c080e7          	jalr	1356(ra) # 800007ee <uartputc_sync>
        uartputc_sync(' ');
    800002aa:	02000513          	li	a0,32
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	540080e7          	jalr	1344(ra) # 800007ee <uartputc_sync>
        uartputc_sync('\b');
    800002b6:	4521                	li	a0,8
    800002b8:	00000097          	auipc	ra,0x0
    800002bc:	536080e7          	jalr	1334(ra) # 800007ee <uartputc_sync>
    800002c0:	bfe1                	j	80000298 <consputc+0x18>

00000000800002c2 <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002c2:	1101                	addi	sp,sp,-32
    800002c4:	ec06                	sd	ra,24(sp)
    800002c6:	e822                	sd	s0,16(sp)
    800002c8:	e426                	sd	s1,8(sp)
    800002ca:	e04a                	sd	s2,0(sp)
    800002cc:	1000                	addi	s0,sp,32
    800002ce:	84aa                	mv	s1,a0
    acquire(&cons.lock);
    800002d0:	00011517          	auipc	a0,0x11
    800002d4:	56050513          	addi	a0,a0,1376 # 80011830 <cons>
    800002d8:	00001097          	auipc	ra,0x1
    800002dc:	926080e7          	jalr	-1754(ra) # 80000bfe <acquire>

    switch (c)
    800002e0:	47d5                	li	a5,21
    800002e2:	0af48663          	beq	s1,a5,8000038e <consoleintr+0xcc>
    800002e6:	0297ca63          	blt	a5,s1,8000031a <consoleintr+0x58>
    800002ea:	47a1                	li	a5,8
    800002ec:	0ef48763          	beq	s1,a5,800003da <consoleintr+0x118>
    800002f0:	47c1                	li	a5,16
    800002f2:	10f49a63          	bne	s1,a5,80000406 <consoleintr+0x144>
    {
    case C('P'): // Print process list.
        procdump();
    800002f6:	00002097          	auipc	ra,0x2
    800002fa:	1ea080e7          	jalr	490(ra) # 800024e0 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    800002fe:	00011517          	auipc	a0,0x11
    80000302:	53250513          	addi	a0,a0,1330 # 80011830 <cons>
    80000306:	00001097          	auipc	ra,0x1
    8000030a:	9ac080e7          	jalr	-1620(ra) # 80000cb2 <release>
}
    8000030e:	60e2                	ld	ra,24(sp)
    80000310:	6442                	ld	s0,16(sp)
    80000312:	64a2                	ld	s1,8(sp)
    80000314:	6902                	ld	s2,0(sp)
    80000316:	6105                	addi	sp,sp,32
    80000318:	8082                	ret
    switch (c)
    8000031a:	07f00793          	li	a5,127
    8000031e:	0af48e63          	beq	s1,a5,800003da <consoleintr+0x118>
        if (c != 0 && cons.e - cons.r < INPUT_BUF)
    80000322:	00011717          	auipc	a4,0x11
    80000326:	50e70713          	addi	a4,a4,1294 # 80011830 <cons>
    8000032a:	0a072783          	lw	a5,160(a4)
    8000032e:	09872703          	lw	a4,152(a4)
    80000332:	9f99                	subw	a5,a5,a4
    80000334:	07f00713          	li	a4,127
    80000338:	fcf763e3          	bltu	a4,a5,800002fe <consoleintr+0x3c>
            c = (c == '\r') ? '\n' : c;
    8000033c:	47b5                	li	a5,13
    8000033e:	0cf48763          	beq	s1,a5,8000040c <consoleintr+0x14a>
            consputc(c);
    80000342:	8526                	mv	a0,s1
    80000344:	00000097          	auipc	ra,0x0
    80000348:	f3c080e7          	jalr	-196(ra) # 80000280 <consputc>
            cons.buf[cons.e++ % INPUT_BUF] = c;
    8000034c:	00011797          	auipc	a5,0x11
    80000350:	4e478793          	addi	a5,a5,1252 # 80011830 <cons>
    80000354:	0a07a703          	lw	a4,160(a5)
    80000358:	0017069b          	addiw	a3,a4,1
    8000035c:	0006861b          	sext.w	a2,a3
    80000360:	0ad7a023          	sw	a3,160(a5)
    80000364:	07f77713          	andi	a4,a4,127
    80000368:	97ba                	add	a5,a5,a4
    8000036a:	00978c23          	sb	s1,24(a5)
            if (c == '\n' || c == C('D') || cons.e == cons.r + INPUT_BUF)
    8000036e:	47a9                	li	a5,10
    80000370:	0cf48563          	beq	s1,a5,8000043a <consoleintr+0x178>
    80000374:	4791                	li	a5,4
    80000376:	0cf48263          	beq	s1,a5,8000043a <consoleintr+0x178>
    8000037a:	00011797          	auipc	a5,0x11
    8000037e:	54e7a783          	lw	a5,1358(a5) # 800118c8 <cons+0x98>
    80000382:	0807879b          	addiw	a5,a5,128
    80000386:	f6f61ce3          	bne	a2,a5,800002fe <consoleintr+0x3c>
            cons.buf[cons.e++ % INPUT_BUF] = c;
    8000038a:	863e                	mv	a2,a5
    8000038c:	a07d                	j	8000043a <consoleintr+0x178>
        while (cons.e != cons.w && cons.buf[(cons.e - 1) % INPUT_BUF] != '\n')
    8000038e:	00011717          	auipc	a4,0x11
    80000392:	4a270713          	addi	a4,a4,1186 # 80011830 <cons>
    80000396:	0a072783          	lw	a5,160(a4)
    8000039a:	09c72703          	lw	a4,156(a4)
    8000039e:	00011497          	auipc	s1,0x11
    800003a2:	49248493          	addi	s1,s1,1170 # 80011830 <cons>
    800003a6:	4929                	li	s2,10
    800003a8:	f4f70be3          	beq	a4,a5,800002fe <consoleintr+0x3c>
    800003ac:	37fd                	addiw	a5,a5,-1
    800003ae:	07f7f713          	andi	a4,a5,127
    800003b2:	9726                	add	a4,a4,s1
    800003b4:	01874703          	lbu	a4,24(a4)
    800003b8:	f52703e3          	beq	a4,s2,800002fe <consoleintr+0x3c>
            cons.e--;
    800003bc:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    800003c0:	10000513          	li	a0,256
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	ebc080e7          	jalr	-324(ra) # 80000280 <consputc>
        while (cons.e != cons.w && cons.buf[(cons.e - 1) % INPUT_BUF] != '\n')
    800003cc:	0a04a783          	lw	a5,160(s1)
    800003d0:	09c4a703          	lw	a4,156(s1)
    800003d4:	fcf71ce3          	bne	a4,a5,800003ac <consoleintr+0xea>
    800003d8:	b71d                	j	800002fe <consoleintr+0x3c>
        if (cons.e != cons.w)
    800003da:	00011717          	auipc	a4,0x11
    800003de:	45670713          	addi	a4,a4,1110 # 80011830 <cons>
    800003e2:	0a072783          	lw	a5,160(a4)
    800003e6:	09c72703          	lw	a4,156(a4)
    800003ea:	f0f70ae3          	beq	a4,a5,800002fe <consoleintr+0x3c>
            cons.e--;
    800003ee:	37fd                	addiw	a5,a5,-1
    800003f0:	00011717          	auipc	a4,0x11
    800003f4:	4ef72023          	sw	a5,1248(a4) # 800118d0 <cons+0xa0>
            consputc(BACKSPACE);
    800003f8:	10000513          	li	a0,256
    800003fc:	00000097          	auipc	ra,0x0
    80000400:	e84080e7          	jalr	-380(ra) # 80000280 <consputc>
    80000404:	bded                	j	800002fe <consoleintr+0x3c>
        if (c != 0 && cons.e - cons.r < INPUT_BUF)
    80000406:	ee048ce3          	beqz	s1,800002fe <consoleintr+0x3c>
    8000040a:	bf21                	j	80000322 <consoleintr+0x60>
            consputc(c);
    8000040c:	4529                	li	a0,10
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	e72080e7          	jalr	-398(ra) # 80000280 <consputc>
            cons.buf[cons.e++ % INPUT_BUF] = c;
    80000416:	00011797          	auipc	a5,0x11
    8000041a:	41a78793          	addi	a5,a5,1050 # 80011830 <cons>
    8000041e:	0a07a703          	lw	a4,160(a5)
    80000422:	0017069b          	addiw	a3,a4,1
    80000426:	0006861b          	sext.w	a2,a3
    8000042a:	0ad7a023          	sw	a3,160(a5)
    8000042e:	07f77713          	andi	a4,a4,127
    80000432:	97ba                	add	a5,a5,a4
    80000434:	4729                	li	a4,10
    80000436:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    8000043a:	00011797          	auipc	a5,0x11
    8000043e:	48c7a923          	sw	a2,1170(a5) # 800118cc <cons+0x9c>
                wakeup(&cons.r);
    80000442:	00011517          	auipc	a0,0x11
    80000446:	48650513          	addi	a0,a0,1158 # 800118c8 <cons+0x98>
    8000044a:	00002097          	auipc	ra,0x2
    8000044e:	f10080e7          	jalr	-240(ra) # 8000235a <wakeup>
    80000452:	b575                	j	800002fe <consoleintr+0x3c>

0000000080000454 <consoleinit>:

void consoleinit(void)
{
    80000454:	1141                	addi	sp,sp,-16
    80000456:	e406                	sd	ra,8(sp)
    80000458:	e022                	sd	s0,0(sp)
    8000045a:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    8000045c:	00008597          	auipc	a1,0x8
    80000460:	bb458593          	addi	a1,a1,-1100 # 80008010 <etext+0x10>
    80000464:	00011517          	auipc	a0,0x11
    80000468:	3cc50513          	addi	a0,a0,972 # 80011830 <cons>
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	702080e7          	jalr	1794(ra) # 80000b6e <initlock>

    uartinit();
    80000474:	00000097          	auipc	ra,0x0
    80000478:	32a080e7          	jalr	810(ra) # 8000079e <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    8000047c:	00021797          	auipc	a5,0x21
    80000480:	53478793          	addi	a5,a5,1332 # 800219b0 <devsw>
    80000484:	00000717          	auipc	a4,0x0
    80000488:	cea70713          	addi	a4,a4,-790 # 8000016e <consoleread>
    8000048c:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    8000048e:	00000717          	auipc	a4,0x0
    80000492:	c5e70713          	addi	a4,a4,-930 # 800000ec <consolewrite>
    80000496:	ef98                	sd	a4,24(a5)
}
    80000498:	60a2                	ld	ra,8(sp)
    8000049a:	6402                	ld	s0,0(sp)
    8000049c:	0141                	addi	sp,sp,16
    8000049e:	8082                	ret

00000000800004a0 <printint>:
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    800004a0:	7179                	addi	sp,sp,-48
    800004a2:	f406                	sd	ra,40(sp)
    800004a4:	f022                	sd	s0,32(sp)
    800004a6:	ec26                	sd	s1,24(sp)
    800004a8:	e84a                	sd	s2,16(sp)
    800004aa:	1800                	addi	s0,sp,48
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
    800004ac:	c219                	beqz	a2,800004b2 <printint+0x12>
    800004ae:	08054663          	bltz	a0,8000053a <printint+0x9a>
        x = -xx;
    else
        x = xx;
    800004b2:	2501                	sext.w	a0,a0
    800004b4:	4881                	li	a7,0
    800004b6:	fd040693          	addi	a3,s0,-48

    i = 0;
    800004ba:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
    800004bc:	2581                	sext.w	a1,a1
    800004be:	00008617          	auipc	a2,0x8
    800004c2:	b8260613          	addi	a2,a2,-1150 # 80008040 <digits>
    800004c6:	883a                	mv	a6,a4
    800004c8:	2705                	addiw	a4,a4,1
    800004ca:	02b577bb          	remuw	a5,a0,a1
    800004ce:	1782                	slli	a5,a5,0x20
    800004d0:	9381                	srli	a5,a5,0x20
    800004d2:	97b2                	add	a5,a5,a2
    800004d4:	0007c783          	lbu	a5,0(a5)
    800004d8:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    800004dc:	0005079b          	sext.w	a5,a0
    800004e0:	02b5553b          	divuw	a0,a0,a1
    800004e4:	0685                	addi	a3,a3,1
    800004e6:	feb7f0e3          	bgeu	a5,a1,800004c6 <printint+0x26>

    if (sign)
    800004ea:	00088b63          	beqz	a7,80000500 <printint+0x60>
        buf[i++] = '-';
    800004ee:	fe040793          	addi	a5,s0,-32
    800004f2:	973e                	add	a4,a4,a5
    800004f4:	02d00793          	li	a5,45
    800004f8:	fef70823          	sb	a5,-16(a4)
    800004fc:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    80000500:	02e05763          	blez	a4,8000052e <printint+0x8e>
    80000504:	fd040793          	addi	a5,s0,-48
    80000508:	00e784b3          	add	s1,a5,a4
    8000050c:	fff78913          	addi	s2,a5,-1
    80000510:	993a                	add	s2,s2,a4
    80000512:	377d                	addiw	a4,a4,-1
    80000514:	1702                	slli	a4,a4,0x20
    80000516:	9301                	srli	a4,a4,0x20
    80000518:	40e90933          	sub	s2,s2,a4
        consputc(buf[i]);
    8000051c:	fff4c503          	lbu	a0,-1(s1)
    80000520:	00000097          	auipc	ra,0x0
    80000524:	d60080e7          	jalr	-672(ra) # 80000280 <consputc>
    while (--i >= 0)
    80000528:	14fd                	addi	s1,s1,-1
    8000052a:	ff2499e3          	bne	s1,s2,8000051c <printint+0x7c>
}
    8000052e:	70a2                	ld	ra,40(sp)
    80000530:	7402                	ld	s0,32(sp)
    80000532:	64e2                	ld	s1,24(sp)
    80000534:	6942                	ld	s2,16(sp)
    80000536:	6145                	addi	sp,sp,48
    80000538:	8082                	ret
        x = -xx;
    8000053a:	40a0053b          	negw	a0,a0
    if (sign && (sign = xx < 0))
    8000053e:	4885                	li	a7,1
        x = -xx;
    80000540:	bf9d                	j	800004b6 <printint+0x16>

0000000080000542 <panic>:
    if (locking)
        release(&pr.lock);
}

void panic(char *s)
{
    80000542:	1101                	addi	sp,sp,-32
    80000544:	ec06                	sd	ra,24(sp)
    80000546:	e822                	sd	s0,16(sp)
    80000548:	e426                	sd	s1,8(sp)
    8000054a:	1000                	addi	s0,sp,32
    8000054c:	84aa                	mv	s1,a0
    pr.locking = 0;
    8000054e:	00011797          	auipc	a5,0x11
    80000552:	3a07a123          	sw	zero,930(a5) # 800118f0 <pr+0x18>
    printf("panic: ");
    80000556:	00008517          	auipc	a0,0x8
    8000055a:	ac250513          	addi	a0,a0,-1342 # 80008018 <etext+0x18>
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	02e080e7          	jalr	46(ra) # 8000058c <printf>
    printf(s);
    80000566:	8526                	mv	a0,s1
    80000568:	00000097          	auipc	ra,0x0
    8000056c:	024080e7          	jalr	36(ra) # 8000058c <printf>
    printf("\n");
    80000570:	00008517          	auipc	a0,0x8
    80000574:	b5850513          	addi	a0,a0,-1192 # 800080c8 <digits+0x88>
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	014080e7          	jalr	20(ra) # 8000058c <printf>
    panicked = 1; // freeze uart output from other CPUs
    80000580:	4785                	li	a5,1
    80000582:	00009717          	auipc	a4,0x9
    80000586:	a6f72f23          	sw	a5,-1410(a4) # 80009000 <panicked>
    for (;;)
    8000058a:	a001                	j	8000058a <panic+0x48>

000000008000058c <printf>:
{
    8000058c:	7131                	addi	sp,sp,-192
    8000058e:	fc86                	sd	ra,120(sp)
    80000590:	f8a2                	sd	s0,112(sp)
    80000592:	f4a6                	sd	s1,104(sp)
    80000594:	f0ca                	sd	s2,96(sp)
    80000596:	ecce                	sd	s3,88(sp)
    80000598:	e8d2                	sd	s4,80(sp)
    8000059a:	e4d6                	sd	s5,72(sp)
    8000059c:	e0da                	sd	s6,64(sp)
    8000059e:	fc5e                	sd	s7,56(sp)
    800005a0:	f862                	sd	s8,48(sp)
    800005a2:	f466                	sd	s9,40(sp)
    800005a4:	f06a                	sd	s10,32(sp)
    800005a6:	ec6e                	sd	s11,24(sp)
    800005a8:	0100                	addi	s0,sp,128
    800005aa:	8a2a                	mv	s4,a0
    800005ac:	e40c                	sd	a1,8(s0)
    800005ae:	e810                	sd	a2,16(s0)
    800005b0:	ec14                	sd	a3,24(s0)
    800005b2:	f018                	sd	a4,32(s0)
    800005b4:	f41c                	sd	a5,40(s0)
    800005b6:	03043823          	sd	a6,48(s0)
    800005ba:	03143c23          	sd	a7,56(s0)
    locking = pr.locking;
    800005be:	00011d97          	auipc	s11,0x11
    800005c2:	332dad83          	lw	s11,818(s11) # 800118f0 <pr+0x18>
    if (locking)
    800005c6:	020d9b63          	bnez	s11,800005fc <printf+0x70>
    if (fmt == 0)
    800005ca:	040a0263          	beqz	s4,8000060e <printf+0x82>
    va_start(ap, fmt);
    800005ce:	00840793          	addi	a5,s0,8
    800005d2:	f8f43423          	sd	a5,-120(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800005d6:	000a4503          	lbu	a0,0(s4)
    800005da:	14050f63          	beqz	a0,80000738 <printf+0x1ac>
    800005de:	4981                	li	s3,0
        if (c != '%')
    800005e0:	02500a93          	li	s5,37
        switch (c)
    800005e4:	07000b93          	li	s7,112
    consputc('x');
    800005e8:	4d41                	li	s10,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005ea:	00008b17          	auipc	s6,0x8
    800005ee:	a56b0b13          	addi	s6,s6,-1450 # 80008040 <digits>
        switch (c)
    800005f2:	07300c93          	li	s9,115
    800005f6:	06400c13          	li	s8,100
    800005fa:	a82d                	j	80000634 <printf+0xa8>
        acquire(&pr.lock);
    800005fc:	00011517          	auipc	a0,0x11
    80000600:	2dc50513          	addi	a0,a0,732 # 800118d8 <pr>
    80000604:	00000097          	auipc	ra,0x0
    80000608:	5fa080e7          	jalr	1530(ra) # 80000bfe <acquire>
    8000060c:	bf7d                	j	800005ca <printf+0x3e>
        panic("null fmt");
    8000060e:	00008517          	auipc	a0,0x8
    80000612:	a1a50513          	addi	a0,a0,-1510 # 80008028 <etext+0x28>
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	f2c080e7          	jalr	-212(ra) # 80000542 <panic>
            consputc(c);
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	c62080e7          	jalr	-926(ra) # 80000280 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000626:	2985                	addiw	s3,s3,1
    80000628:	013a07b3          	add	a5,s4,s3
    8000062c:	0007c503          	lbu	a0,0(a5)
    80000630:	10050463          	beqz	a0,80000738 <printf+0x1ac>
        if (c != '%')
    80000634:	ff5515e3          	bne	a0,s5,8000061e <printf+0x92>
        c = fmt[++i] & 0xff;
    80000638:	2985                	addiw	s3,s3,1
    8000063a:	013a07b3          	add	a5,s4,s3
    8000063e:	0007c783          	lbu	a5,0(a5)
    80000642:	0007849b          	sext.w	s1,a5
        if (c == 0)
    80000646:	cbed                	beqz	a5,80000738 <printf+0x1ac>
        switch (c)
    80000648:	05778a63          	beq	a5,s7,8000069c <printf+0x110>
    8000064c:	02fbf663          	bgeu	s7,a5,80000678 <printf+0xec>
    80000650:	09978863          	beq	a5,s9,800006e0 <printf+0x154>
    80000654:	07800713          	li	a4,120
    80000658:	0ce79563          	bne	a5,a4,80000722 <printf+0x196>
            printint(va_arg(ap, int), 16, 1);
    8000065c:	f8843783          	ld	a5,-120(s0)
    80000660:	00878713          	addi	a4,a5,8
    80000664:	f8e43423          	sd	a4,-120(s0)
    80000668:	4605                	li	a2,1
    8000066a:	85ea                	mv	a1,s10
    8000066c:	4388                	lw	a0,0(a5)
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	e32080e7          	jalr	-462(ra) # 800004a0 <printint>
            break;
    80000676:	bf45                	j	80000626 <printf+0x9a>
        switch (c)
    80000678:	09578f63          	beq	a5,s5,80000716 <printf+0x18a>
    8000067c:	0b879363          	bne	a5,s8,80000722 <printf+0x196>
            printint(va_arg(ap, int), 10, 1);
    80000680:	f8843783          	ld	a5,-120(s0)
    80000684:	00878713          	addi	a4,a5,8
    80000688:	f8e43423          	sd	a4,-120(s0)
    8000068c:	4605                	li	a2,1
    8000068e:	45a9                	li	a1,10
    80000690:	4388                	lw	a0,0(a5)
    80000692:	00000097          	auipc	ra,0x0
    80000696:	e0e080e7          	jalr	-498(ra) # 800004a0 <printint>
            break;
    8000069a:	b771                	j	80000626 <printf+0x9a>
            printptr(va_arg(ap, uint64));
    8000069c:	f8843783          	ld	a5,-120(s0)
    800006a0:	00878713          	addi	a4,a5,8
    800006a4:	f8e43423          	sd	a4,-120(s0)
    800006a8:	0007b903          	ld	s2,0(a5)
    consputc('0');
    800006ac:	03000513          	li	a0,48
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	bd0080e7          	jalr	-1072(ra) # 80000280 <consputc>
    consputc('x');
    800006b8:	07800513          	li	a0,120
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	bc4080e7          	jalr	-1084(ra) # 80000280 <consputc>
    800006c4:	84ea                	mv	s1,s10
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c6:	03c95793          	srli	a5,s2,0x3c
    800006ca:	97da                	add	a5,a5,s6
    800006cc:	0007c503          	lbu	a0,0(a5)
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	bb0080e7          	jalr	-1104(ra) # 80000280 <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d8:	0912                	slli	s2,s2,0x4
    800006da:	34fd                	addiw	s1,s1,-1
    800006dc:	f4ed                	bnez	s1,800006c6 <printf+0x13a>
    800006de:	b7a1                	j	80000626 <printf+0x9a>
            if ((s = va_arg(ap, char *)) == 0)
    800006e0:	f8843783          	ld	a5,-120(s0)
    800006e4:	00878713          	addi	a4,a5,8
    800006e8:	f8e43423          	sd	a4,-120(s0)
    800006ec:	6384                	ld	s1,0(a5)
    800006ee:	cc89                	beqz	s1,80000708 <printf+0x17c>
            for (; *s; s++)
    800006f0:	0004c503          	lbu	a0,0(s1)
    800006f4:	d90d                	beqz	a0,80000626 <printf+0x9a>
                consputc(*s);
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	b8a080e7          	jalr	-1142(ra) # 80000280 <consputc>
            for (; *s; s++)
    800006fe:	0485                	addi	s1,s1,1
    80000700:	0004c503          	lbu	a0,0(s1)
    80000704:	f96d                	bnez	a0,800006f6 <printf+0x16a>
    80000706:	b705                	j	80000626 <printf+0x9a>
                s = "(null)";
    80000708:	00008497          	auipc	s1,0x8
    8000070c:	91848493          	addi	s1,s1,-1768 # 80008020 <etext+0x20>
            for (; *s; s++)
    80000710:	02800513          	li	a0,40
    80000714:	b7cd                	j	800006f6 <printf+0x16a>
            consputc('%');
    80000716:	8556                	mv	a0,s5
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	b68080e7          	jalr	-1176(ra) # 80000280 <consputc>
            break;
    80000720:	b719                	j	80000626 <printf+0x9a>
            consputc('%');
    80000722:	8556                	mv	a0,s5
    80000724:	00000097          	auipc	ra,0x0
    80000728:	b5c080e7          	jalr	-1188(ra) # 80000280 <consputc>
            consputc(c);
    8000072c:	8526                	mv	a0,s1
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	b52080e7          	jalr	-1198(ra) # 80000280 <consputc>
            break;
    80000736:	bdc5                	j	80000626 <printf+0x9a>
    if (locking)
    80000738:	020d9163          	bnez	s11,8000075a <printf+0x1ce>
}
    8000073c:	70e6                	ld	ra,120(sp)
    8000073e:	7446                	ld	s0,112(sp)
    80000740:	74a6                	ld	s1,104(sp)
    80000742:	7906                	ld	s2,96(sp)
    80000744:	69e6                	ld	s3,88(sp)
    80000746:	6a46                	ld	s4,80(sp)
    80000748:	6aa6                	ld	s5,72(sp)
    8000074a:	6b06                	ld	s6,64(sp)
    8000074c:	7be2                	ld	s7,56(sp)
    8000074e:	7c42                	ld	s8,48(sp)
    80000750:	7ca2                	ld	s9,40(sp)
    80000752:	7d02                	ld	s10,32(sp)
    80000754:	6de2                	ld	s11,24(sp)
    80000756:	6129                	addi	sp,sp,192
    80000758:	8082                	ret
        release(&pr.lock);
    8000075a:	00011517          	auipc	a0,0x11
    8000075e:	17e50513          	addi	a0,a0,382 # 800118d8 <pr>
    80000762:	00000097          	auipc	ra,0x0
    80000766:	550080e7          	jalr	1360(ra) # 80000cb2 <release>
}
    8000076a:	bfc9                	j	8000073c <printf+0x1b0>

000000008000076c <printfinit>:
        ;
}

void printfinit(void)
{
    8000076c:	1101                	addi	sp,sp,-32
    8000076e:	ec06                	sd	ra,24(sp)
    80000770:	e822                	sd	s0,16(sp)
    80000772:	e426                	sd	s1,8(sp)
    80000774:	1000                	addi	s0,sp,32
    initlock(&pr.lock, "pr");
    80000776:	00011497          	auipc	s1,0x11
    8000077a:	16248493          	addi	s1,s1,354 # 800118d8 <pr>
    8000077e:	00008597          	auipc	a1,0x8
    80000782:	8ba58593          	addi	a1,a1,-1862 # 80008038 <etext+0x38>
    80000786:	8526                	mv	a0,s1
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	3e6080e7          	jalr	998(ra) # 80000b6e <initlock>
    pr.locking = 1;
    80000790:	4785                	li	a5,1
    80000792:	cc9c                	sw	a5,24(s1)
}
    80000794:	60e2                	ld	ra,24(sp)
    80000796:	6442                	ld	s0,16(sp)
    80000798:	64a2                	ld	s1,8(sp)
    8000079a:	6105                	addi	sp,sp,32
    8000079c:	8082                	ret

000000008000079e <uartinit>:
extern volatile int panicked; // from printf.c

void uartstart();

void uartinit(void)
{
    8000079e:	1141                	addi	sp,sp,-16
    800007a0:	e406                	sd	ra,8(sp)
    800007a2:	e022                	sd	s0,0(sp)
    800007a4:	0800                	addi	s0,sp,16
    // disable interrupts.
    WriteReg(IER, 0x00);
    800007a6:	100007b7          	lui	a5,0x10000
    800007aa:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

    // special mode to set baud rate.
    WriteReg(LCR, LCR_BAUD_LATCH);
    800007ae:	f8000713          	li	a4,-128
    800007b2:	00e781a3          	sb	a4,3(a5)

    // LSB for baud rate of 38.4K.
    WriteReg(0, 0x03);
    800007b6:	470d                	li	a4,3
    800007b8:	00e78023          	sb	a4,0(a5)

    // MSB for baud rate of 38.4K.
    WriteReg(1, 0x00);
    800007bc:	000780a3          	sb	zero,1(a5)

    // leave set-baud mode,
    // and set word length to 8 bits, no parity.
    WriteReg(LCR, LCR_EIGHT_BITS);
    800007c0:	00e781a3          	sb	a4,3(a5)

    // reset and enable FIFOs.
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c4:	469d                	li	a3,7
    800007c6:	00d78123          	sb	a3,2(a5)

    // enable transmit and receive interrupts.
    WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ca:	00e780a3          	sb	a4,1(a5)

    initlock(&uart_tx_lock, "uart");
    800007ce:	00008597          	auipc	a1,0x8
    800007d2:	88a58593          	addi	a1,a1,-1910 # 80008058 <digits+0x18>
    800007d6:	00011517          	auipc	a0,0x11
    800007da:	12250513          	addi	a0,a0,290 # 800118f8 <uart_tx_lock>
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	390080e7          	jalr	912(ra) # 80000b6e <initlock>
}
    800007e6:	60a2                	ld	ra,8(sp)
    800007e8:	6402                	ld	s0,0(sp)
    800007ea:	0141                	addi	sp,sp,16
    800007ec:	8082                	ret

00000000800007ee <uartputc_sync>:
// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c)
{
    800007ee:	1101                	addi	sp,sp,-32
    800007f0:	ec06                	sd	ra,24(sp)
    800007f2:	e822                	sd	s0,16(sp)
    800007f4:	e426                	sd	s1,8(sp)
    800007f6:	1000                	addi	s0,sp,32
    800007f8:	84aa                	mv	s1,a0
    push_off();
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	3b8080e7          	jalr	952(ra) # 80000bb2 <push_off>

    if (panicked)
    80000802:	00008797          	auipc	a5,0x8
    80000806:	7fe7a783          	lw	a5,2046(a5) # 80009000 <panicked>
        for (;;)
            ;
    }

    // wait for Transmit Holding Empty to be set in LSR.
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080a:	10000737          	lui	a4,0x10000
    if (panicked)
    8000080e:	c391                	beqz	a5,80000812 <uartputc_sync+0x24>
        for (;;)
    80000810:	a001                	j	80000810 <uartputc_sync+0x22>
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000812:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000816:	0207f793          	andi	a5,a5,32
    8000081a:	dfe5                	beqz	a5,80000812 <uartputc_sync+0x24>
        ;
    WriteReg(THR, c);
    8000081c:	0ff4f513          	andi	a0,s1,255
    80000820:	100007b7          	lui	a5,0x10000
    80000824:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

    pop_off();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	42a080e7          	jalr	1066(ra) # 80000c52 <pop_off>
}
    80000830:	60e2                	ld	ra,24(sp)
    80000832:	6442                	ld	s0,16(sp)
    80000834:	64a2                	ld	s1,8(sp)
    80000836:	6105                	addi	sp,sp,32
    80000838:	8082                	ret

000000008000083a <uartstart>:
// called from both the top- and bottom-half.
void uartstart()
{
    while (1)
    {
        if (uart_tx_w == uart_tx_r)
    8000083a:	00008797          	auipc	a5,0x8
    8000083e:	7ca7a783          	lw	a5,1994(a5) # 80009004 <uart_tx_r>
    80000842:	00008717          	auipc	a4,0x8
    80000846:	7c672703          	lw	a4,1990(a4) # 80009008 <uart_tx_w>
    8000084a:	08f70063          	beq	a4,a5,800008ca <uartstart+0x90>
{
    8000084e:	7139                	addi	sp,sp,-64
    80000850:	fc06                	sd	ra,56(sp)
    80000852:	f822                	sd	s0,48(sp)
    80000854:	f426                	sd	s1,40(sp)
    80000856:	f04a                	sd	s2,32(sp)
    80000858:	ec4e                	sd	s3,24(sp)
    8000085a:	e852                	sd	s4,16(sp)
    8000085c:	e456                	sd	s5,8(sp)
    8000085e:	0080                	addi	s0,sp,64
        {
            // transmit buffer is empty.
            return;
        }

        if ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000860:	10000937          	lui	s2,0x10000
            // so we cannot give it another byte.
            // it will interrupt when it's ready for a new byte.
            return;
        }

        int c = uart_tx_buf[uart_tx_r];
    80000864:	00011a97          	auipc	s5,0x11
    80000868:	094a8a93          	addi	s5,s5,148 # 800118f8 <uart_tx_lock>
        uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000086c:	00008497          	auipc	s1,0x8
    80000870:	79848493          	addi	s1,s1,1944 # 80009004 <uart_tx_r>
        if (uart_tx_w == uart_tx_r)
    80000874:	00008a17          	auipc	s4,0x8
    80000878:	794a0a13          	addi	s4,s4,1940 # 80009008 <uart_tx_w>
        if ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000087c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000880:	02077713          	andi	a4,a4,32
    80000884:	cb15                	beqz	a4,800008b8 <uartstart+0x7e>
        int c = uart_tx_buf[uart_tx_r];
    80000886:	00fa8733          	add	a4,s5,a5
    8000088a:	01874983          	lbu	s3,24(a4)
        uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000088e:	2785                	addiw	a5,a5,1
    80000890:	41f7d71b          	sraiw	a4,a5,0x1f
    80000894:	01b7571b          	srliw	a4,a4,0x1b
    80000898:	9fb9                	addw	a5,a5,a4
    8000089a:	8bfd                	andi	a5,a5,31
    8000089c:	9f99                	subw	a5,a5,a4
    8000089e:	c09c                	sw	a5,0(s1)

        // maybe uartputc() is waiting for space in the buffer.
        wakeup(&uart_tx_r);
    800008a0:	8526                	mv	a0,s1
    800008a2:	00002097          	auipc	ra,0x2
    800008a6:	ab8080e7          	jalr	-1352(ra) # 8000235a <wakeup>

        WriteReg(THR, c);
    800008aa:	01390023          	sb	s3,0(s2)
        if (uart_tx_w == uart_tx_r)
    800008ae:	409c                	lw	a5,0(s1)
    800008b0:	000a2703          	lw	a4,0(s4)
    800008b4:	fcf714e3          	bne	a4,a5,8000087c <uartstart+0x42>
    }
}
    800008b8:	70e2                	ld	ra,56(sp)
    800008ba:	7442                	ld	s0,48(sp)
    800008bc:	74a2                	ld	s1,40(sp)
    800008be:	7902                	ld	s2,32(sp)
    800008c0:	69e2                	ld	s3,24(sp)
    800008c2:	6a42                	ld	s4,16(sp)
    800008c4:	6aa2                	ld	s5,8(sp)
    800008c6:	6121                	addi	sp,sp,64
    800008c8:	8082                	ret
    800008ca:	8082                	ret

00000000800008cc <uartputc>:
{
    800008cc:	7179                	addi	sp,sp,-48
    800008ce:	f406                	sd	ra,40(sp)
    800008d0:	f022                	sd	s0,32(sp)
    800008d2:	ec26                	sd	s1,24(sp)
    800008d4:	e84a                	sd	s2,16(sp)
    800008d6:	e44e                	sd	s3,8(sp)
    800008d8:	e052                	sd	s4,0(sp)
    800008da:	1800                	addi	s0,sp,48
    800008dc:	84aa                	mv	s1,a0
    acquire(&uart_tx_lock);
    800008de:	00011517          	auipc	a0,0x11
    800008e2:	01a50513          	addi	a0,a0,26 # 800118f8 <uart_tx_lock>
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	318080e7          	jalr	792(ra) # 80000bfe <acquire>
    if (panicked)
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	7127a783          	lw	a5,1810(a5) # 80009000 <panicked>
    800008f6:	c391                	beqz	a5,800008fa <uartputc+0x2e>
        for (;;)
    800008f8:	a001                	j	800008f8 <uartputc+0x2c>
        if (((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r)
    800008fa:	00008697          	auipc	a3,0x8
    800008fe:	70e6a683          	lw	a3,1806(a3) # 80009008 <uart_tx_w>
    80000902:	0016879b          	addiw	a5,a3,1
    80000906:	41f7d71b          	sraiw	a4,a5,0x1f
    8000090a:	01b7571b          	srliw	a4,a4,0x1b
    8000090e:	9fb9                	addw	a5,a5,a4
    80000910:	8bfd                	andi	a5,a5,31
    80000912:	9f99                	subw	a5,a5,a4
    80000914:	00008717          	auipc	a4,0x8
    80000918:	6f072703          	lw	a4,1776(a4) # 80009004 <uart_tx_r>
    8000091c:	04f71363          	bne	a4,a5,80000962 <uartputc+0x96>
            sleep(&uart_tx_r, &uart_tx_lock);
    80000920:	00011a17          	auipc	s4,0x11
    80000924:	fd8a0a13          	addi	s4,s4,-40 # 800118f8 <uart_tx_lock>
    80000928:	00008917          	auipc	s2,0x8
    8000092c:	6dc90913          	addi	s2,s2,1756 # 80009004 <uart_tx_r>
        if (((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r)
    80000930:	00008997          	auipc	s3,0x8
    80000934:	6d898993          	addi	s3,s3,1752 # 80009008 <uart_tx_w>
            sleep(&uart_tx_r, &uart_tx_lock);
    80000938:	85d2                	mv	a1,s4
    8000093a:	854a                	mv	a0,s2
    8000093c:	00002097          	auipc	ra,0x2
    80000940:	89e080e7          	jalr	-1890(ra) # 800021da <sleep>
        if (((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r)
    80000944:	0009a683          	lw	a3,0(s3)
    80000948:	0016879b          	addiw	a5,a3,1
    8000094c:	41f7d71b          	sraiw	a4,a5,0x1f
    80000950:	01b7571b          	srliw	a4,a4,0x1b
    80000954:	9fb9                	addw	a5,a5,a4
    80000956:	8bfd                	andi	a5,a5,31
    80000958:	9f99                	subw	a5,a5,a4
    8000095a:	00092703          	lw	a4,0(s2)
    8000095e:	fcf70de3          	beq	a4,a5,80000938 <uartputc+0x6c>
            uart_tx_buf[uart_tx_w] = c;
    80000962:	00011917          	auipc	s2,0x11
    80000966:	f9690913          	addi	s2,s2,-106 # 800118f8 <uart_tx_lock>
    8000096a:	96ca                	add	a3,a3,s2
    8000096c:	00968c23          	sb	s1,24(a3)
            uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000970:	00008717          	auipc	a4,0x8
    80000974:	68f72c23          	sw	a5,1688(a4) # 80009008 <uart_tx_w>
            uartstart();
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	ec2080e7          	jalr	-318(ra) # 8000083a <uartstart>
            release(&uart_tx_lock);
    80000980:	854a                	mv	a0,s2
    80000982:	00000097          	auipc	ra,0x0
    80000986:	330080e7          	jalr	816(ra) # 80000cb2 <release>
}
    8000098a:	70a2                	ld	ra,40(sp)
    8000098c:	7402                	ld	s0,32(sp)
    8000098e:	64e2                	ld	s1,24(sp)
    80000990:	6942                	ld	s2,16(sp)
    80000992:	69a2                	ld	s3,8(sp)
    80000994:	6a02                	ld	s4,0(sp)
    80000996:	6145                	addi	sp,sp,48
    80000998:	8082                	ret

000000008000099a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void)
{
    8000099a:	1141                	addi	sp,sp,-16
    8000099c:	e422                	sd	s0,8(sp)
    8000099e:	0800                	addi	s0,sp,16
    if (ReadReg(LSR) & 0x01)
    800009a0:	100007b7          	lui	a5,0x10000
    800009a4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	cb91                	beqz	a5,800009be <uartgetc+0x24>
    {
        // input data is ready.
        return ReadReg(RHR);
    800009ac:	100007b7          	lui	a5,0x10000
    800009b0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009b4:	0ff57513          	andi	a0,a0,255
    }
    else
    {
        return -1;
    }
}
    800009b8:	6422                	ld	s0,8(sp)
    800009ba:	0141                	addi	sp,sp,16
    800009bc:	8082                	ret
        return -1;
    800009be:	557d                	li	a0,-1
    800009c0:	bfe5                	j	800009b8 <uartgetc+0x1e>

00000000800009c2 <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void uartintr(void)
{
    800009c2:	1101                	addi	sp,sp,-32
    800009c4:	ec06                	sd	ra,24(sp)
    800009c6:	e822                	sd	s0,16(sp)
    800009c8:	e426                	sd	s1,8(sp)
    800009ca:	1000                	addi	s0,sp,32
    // read and process incoming characters.
    while (1)
    {
        int c = uartgetc();
        if (c == -1)
    800009cc:	54fd                	li	s1,-1
    800009ce:	a029                	j	800009d8 <uartintr+0x16>
            break;
        consoleintr(c);
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	8f2080e7          	jalr	-1806(ra) # 800002c2 <consoleintr>
        int c = uartgetc();
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	fc2080e7          	jalr	-62(ra) # 8000099a <uartgetc>
        if (c == -1)
    800009e0:	fe9518e3          	bne	a0,s1,800009d0 <uartintr+0xe>
    }

    // send buffered characters.
    acquire(&uart_tx_lock);
    800009e4:	00011497          	auipc	s1,0x11
    800009e8:	f1448493          	addi	s1,s1,-236 # 800118f8 <uart_tx_lock>
    800009ec:	8526                	mv	a0,s1
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	210080e7          	jalr	528(ra) # 80000bfe <acquire>
    uartstart();
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	e44080e7          	jalr	-444(ra) # 8000083a <uartstart>
    release(&uart_tx_lock);
    800009fe:	8526                	mv	a0,s1
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	2b2080e7          	jalr	690(ra) # 80000cb2 <release>
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret

0000000080000a12 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000a12:	1101                	addi	sp,sp,-32
    80000a14:	ec06                	sd	ra,24(sp)
    80000a16:	e822                	sd	s0,16(sp)
    80000a18:	e426                	sd	s1,8(sp)
    80000a1a:	e04a                	sd	s2,0(sp)
    80000a1c:	1000                	addi	s0,sp,32
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a1e:	03451793          	slli	a5,a0,0x34
    80000a22:	ebb9                	bnez	a5,80000a78 <kfree+0x66>
    80000a24:	84aa                	mv	s1,a0
    80000a26:	00025797          	auipc	a5,0x25
    80000a2a:	5da78793          	addi	a5,a5,1498 # 80026000 <end>
    80000a2e:	04f56563          	bltu	a0,a5,80000a78 <kfree+0x66>
    80000a32:	47c5                	li	a5,17
    80000a34:	07ee                	slli	a5,a5,0x1b
    80000a36:	04f57163          	bgeu	a0,a5,80000a78 <kfree+0x66>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	4585                	li	a1,1
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	2bc080e7          	jalr	700(ra) # 80000cfa <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000a46:	00011917          	auipc	s2,0x11
    80000a4a:	eea90913          	addi	s2,s2,-278 # 80011930 <kmem>
    80000a4e:	854a                	mv	a0,s2
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	1ae080e7          	jalr	430(ra) # 80000bfe <acquire>
    r->next = kmem.freelist;
    80000a58:	01893783          	ld	a5,24(s2)
    80000a5c:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000a5e:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    80000a62:	854a                	mv	a0,s2
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	24e080e7          	jalr	590(ra) # 80000cb2 <release>
}
    80000a6c:	60e2                	ld	ra,24(sp)
    80000a6e:	6442                	ld	s0,16(sp)
    80000a70:	64a2                	ld	s1,8(sp)
    80000a72:	6902                	ld	s2,0(sp)
    80000a74:	6105                	addi	sp,sp,32
    80000a76:	8082                	ret
        panic("kfree");
    80000a78:	00007517          	auipc	a0,0x7
    80000a7c:	5e850513          	addi	a0,a0,1512 # 80008060 <digits+0x20>
    80000a80:	00000097          	auipc	ra,0x0
    80000a84:	ac2080e7          	jalr	-1342(ra) # 80000542 <panic>

0000000080000a88 <freerange>:
{
    80000a88:	7179                	addi	sp,sp,-48
    80000a8a:	f406                	sd	ra,40(sp)
    80000a8c:	f022                	sd	s0,32(sp)
    80000a8e:	ec26                	sd	s1,24(sp)
    80000a90:	e84a                	sd	s2,16(sp)
    80000a92:	e44e                	sd	s3,8(sp)
    80000a94:	e052                	sd	s4,0(sp)
    80000a96:	1800                	addi	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    80000a98:	6785                	lui	a5,0x1
    80000a9a:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a9e:	94aa                	add	s1,s1,a0
    80000aa0:	757d                	lui	a0,0xfffff
    80000aa2:	8ce9                	and	s1,s1,a0
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aa4:	94be                	add	s1,s1,a5
    80000aa6:	0095ee63          	bltu	a1,s1,80000ac2 <freerange+0x3a>
    80000aaa:	892e                	mv	s2,a1
        kfree(p);
    80000aac:	7a7d                	lui	s4,0xfffff
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aae:	6985                	lui	s3,0x1
        kfree(p);
    80000ab0:	01448533          	add	a0,s1,s4
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	f5e080e7          	jalr	-162(ra) # 80000a12 <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000abc:	94ce                	add	s1,s1,s3
    80000abe:	fe9979e3          	bgeu	s2,s1,80000ab0 <freerange+0x28>
}
    80000ac2:	70a2                	ld	ra,40(sp)
    80000ac4:	7402                	ld	s0,32(sp)
    80000ac6:	64e2                	ld	s1,24(sp)
    80000ac8:	6942                	ld	s2,16(sp)
    80000aca:	69a2                	ld	s3,8(sp)
    80000acc:	6a02                	ld	s4,0(sp)
    80000ace:	6145                	addi	sp,sp,48
    80000ad0:	8082                	ret

0000000080000ad2 <kinit>:
{
    80000ad2:	1141                	addi	sp,sp,-16
    80000ad4:	e406                	sd	ra,8(sp)
    80000ad6:	e022                	sd	s0,0(sp)
    80000ad8:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    80000ada:	00007597          	auipc	a1,0x7
    80000ade:	58e58593          	addi	a1,a1,1422 # 80008068 <digits+0x28>
    80000ae2:	00011517          	auipc	a0,0x11
    80000ae6:	e4e50513          	addi	a0,a0,-434 # 80011930 <kmem>
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	084080e7          	jalr	132(ra) # 80000b6e <initlock>
    freerange(end, (void *)PHYSTOP);
    80000af2:	45c5                	li	a1,17
    80000af4:	05ee                	slli	a1,a1,0x1b
    80000af6:	00025517          	auipc	a0,0x25
    80000afa:	50a50513          	addi	a0,a0,1290 # 80026000 <end>
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	f8a080e7          	jalr	-118(ra) # 80000a88 <freerange>
}
    80000b06:	60a2                	ld	ra,8(sp)
    80000b08:	6402                	ld	s0,0(sp)
    80000b0a:	0141                	addi	sp,sp,16
    80000b0c:	8082                	ret

0000000080000b0e <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    80000b0e:	1101                	addi	sp,sp,-32
    80000b10:	ec06                	sd	ra,24(sp)
    80000b12:	e822                	sd	s0,16(sp)
    80000b14:	e426                	sd	s1,8(sp)
    80000b16:	1000                	addi	s0,sp,32
    struct run *r;

    acquire(&kmem.lock);
    80000b18:	00011497          	auipc	s1,0x11
    80000b1c:	e1848493          	addi	s1,s1,-488 # 80011930 <kmem>
    80000b20:	8526                	mv	a0,s1
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	0dc080e7          	jalr	220(ra) # 80000bfe <acquire>
    r = kmem.freelist;
    80000b2a:	6c84                	ld	s1,24(s1)
    if (r)
    80000b2c:	c885                	beqz	s1,80000b5c <kalloc+0x4e>
        kmem.freelist = r->next;
    80000b2e:	609c                	ld	a5,0(s1)
    80000b30:	00011517          	auipc	a0,0x11
    80000b34:	e0050513          	addi	a0,a0,-512 # 80011930 <kmem>
    80000b38:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	178080e7          	jalr	376(ra) # 80000cb2 <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000b42:	6605                	lui	a2,0x1
    80000b44:	4595                	li	a1,5
    80000b46:	8526                	mv	a0,s1
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	1b2080e7          	jalr	434(ra) # 80000cfa <memset>
    return (void *)r;
}
    80000b50:	8526                	mv	a0,s1
    80000b52:	60e2                	ld	ra,24(sp)
    80000b54:	6442                	ld	s0,16(sp)
    80000b56:	64a2                	ld	s1,8(sp)
    80000b58:	6105                	addi	sp,sp,32
    80000b5a:	8082                	ret
    release(&kmem.lock);
    80000b5c:	00011517          	auipc	a0,0x11
    80000b60:	dd450513          	addi	a0,a0,-556 # 80011930 <kmem>
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	14e080e7          	jalr	334(ra) # 80000cb2 <release>
    if (r)
    80000b6c:	b7d5                	j	80000b50 <kalloc+0x42>

0000000080000b6e <initlock>:
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void initlock(struct spinlock *lk, char *name)
{
    80000b6e:	1141                	addi	sp,sp,-16
    80000b70:	e422                	sd	s0,8(sp)
    80000b72:	0800                	addi	s0,sp,16
    lk->name = name;
    80000b74:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
    80000b76:	00052023          	sw	zero,0(a0)
    lk->cpu = 0;
    80000b7a:	00053823          	sd	zero,16(a0)
}
    80000b7e:	6422                	ld	s0,8(sp)
    80000b80:	0141                	addi	sp,sp,16
    80000b82:	8082                	ret

0000000080000b84 <holding>:
// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk)
{
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    80000b84:	411c                	lw	a5,0(a0)
    80000b86:	e399                	bnez	a5,80000b8c <holding+0x8>
    80000b88:	4501                	li	a0,0
    return r;
}
    80000b8a:	8082                	ret
{
    80000b8c:	1101                	addi	sp,sp,-32
    80000b8e:	ec06                	sd	ra,24(sp)
    80000b90:	e822                	sd	s0,16(sp)
    80000b92:	e426                	sd	s1,8(sp)
    80000b94:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    80000b96:	6904                	ld	s1,16(a0)
    80000b98:	00001097          	auipc	ra,0x1
    80000b9c:	e16080e7          	jalr	-490(ra) # 800019ae <mycpu>
    80000ba0:	40a48533          	sub	a0,s1,a0
    80000ba4:	00153513          	seqz	a0,a0
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret

0000000080000bb2 <push_off>:
// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void)
{
    80000bb2:	1101                	addi	sp,sp,-32
    80000bb4:	ec06                	sd	ra,24(sp)
    80000bb6:	e822                	sd	s0,16(sp)
    80000bb8:	e426                	sd	s1,8(sp)
    80000bba:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000bbc:	100024f3          	csrr	s1,sstatus
    80000bc0:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80000bc4:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000bc6:	10079073          	csrw	sstatus,a5
    int old = intr_get();

    intr_off();
    if (mycpu()->noff == 0)
    80000bca:	00001097          	auipc	ra,0x1
    80000bce:	de4080e7          	jalr	-540(ra) # 800019ae <mycpu>
    80000bd2:	5d3c                	lw	a5,120(a0)
    80000bd4:	cf89                	beqz	a5,80000bee <push_off+0x3c>
        mycpu()->intena = old;
    mycpu()->noff += 1;
    80000bd6:	00001097          	auipc	ra,0x1
    80000bda:	dd8080e7          	jalr	-552(ra) # 800019ae <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	2785                	addiw	a5,a5,1
    80000be2:	dd3c                	sw	a5,120(a0)
}
    80000be4:	60e2                	ld	ra,24(sp)
    80000be6:	6442                	ld	s0,16(sp)
    80000be8:	64a2                	ld	s1,8(sp)
    80000bea:	6105                	addi	sp,sp,32
    80000bec:	8082                	ret
        mycpu()->intena = old;
    80000bee:	00001097          	auipc	ra,0x1
    80000bf2:	dc0080e7          	jalr	-576(ra) # 800019ae <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80000bf6:	8085                	srli	s1,s1,0x1
    80000bf8:	8885                	andi	s1,s1,1
    80000bfa:	dd64                	sw	s1,124(a0)
    80000bfc:	bfe9                	j	80000bd6 <push_off+0x24>

0000000080000bfe <acquire>:
{
    80000bfe:	1101                	addi	sp,sp,-32
    80000c00:	ec06                	sd	ra,24(sp)
    80000c02:	e822                	sd	s0,16(sp)
    80000c04:	e426                	sd	s1,8(sp)
    80000c06:	1000                	addi	s0,sp,32
    80000c08:	84aa                	mv	s1,a0
    push_off(); // disable interrupts to avoid deadlock.
    80000c0a:	00000097          	auipc	ra,0x0
    80000c0e:	fa8080e7          	jalr	-88(ra) # 80000bb2 <push_off>
    if (holding(lk))
    80000c12:	8526                	mv	a0,s1
    80000c14:	00000097          	auipc	ra,0x0
    80000c18:	f70080e7          	jalr	-144(ra) # 80000b84 <holding>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1c:	4705                	li	a4,1
    if (holding(lk))
    80000c1e:	e115                	bnez	a0,80000c42 <acquire+0x44>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c20:	87ba                	mv	a5,a4
    80000c22:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c26:	2781                	sext.w	a5,a5
    80000c28:	ffe5                	bnez	a5,80000c20 <acquire+0x22>
    __sync_synchronize();
    80000c2a:	0ff0000f          	fence
    lk->cpu = mycpu();
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	d80080e7          	jalr	-640(ra) # 800019ae <mycpu>
    80000c36:	e888                	sd	a0,16(s1)
}
    80000c38:	60e2                	ld	ra,24(sp)
    80000c3a:	6442                	ld	s0,16(sp)
    80000c3c:	64a2                	ld	s1,8(sp)
    80000c3e:	6105                	addi	sp,sp,32
    80000c40:	8082                	ret
        panic("acquire");
    80000c42:	00007517          	auipc	a0,0x7
    80000c46:	42e50513          	addi	a0,a0,1070 # 80008070 <digits+0x30>
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	8f8080e7          	jalr	-1800(ra) # 80000542 <panic>

0000000080000c52 <pop_off>:

void pop_off(void)
{
    80000c52:	1141                	addi	sp,sp,-16
    80000c54:	e406                	sd	ra,8(sp)
    80000c56:	e022                	sd	s0,0(sp)
    80000c58:	0800                	addi	s0,sp,16
    struct cpu *c = mycpu();
    80000c5a:	00001097          	auipc	ra,0x1
    80000c5e:	d54080e7          	jalr	-684(ra) # 800019ae <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c62:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80000c66:	8b89                	andi	a5,a5,2
    if (intr_get())
    80000c68:	e78d                	bnez	a5,80000c92 <pop_off+0x40>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    80000c6a:	5d3c                	lw	a5,120(a0)
    80000c6c:	02f05b63          	blez	a5,80000ca2 <pop_off+0x50>
        panic("pop_off");
    c->noff -= 1;
    80000c70:	37fd                	addiw	a5,a5,-1
    80000c72:	0007871b          	sext.w	a4,a5
    80000c76:	dd3c                	sw	a5,120(a0)
    if (c->noff == 0 && c->intena)
    80000c78:	eb09                	bnez	a4,80000c8a <pop_off+0x38>
    80000c7a:	5d7c                	lw	a5,124(a0)
    80000c7c:	c799                	beqz	a5,80000c8a <pop_off+0x38>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c7e:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80000c82:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000c86:	10079073          	csrw	sstatus,a5
        intr_on();
}
    80000c8a:	60a2                	ld	ra,8(sp)
    80000c8c:	6402                	ld	s0,0(sp)
    80000c8e:	0141                	addi	sp,sp,16
    80000c90:	8082                	ret
        panic("pop_off - interruptible");
    80000c92:	00007517          	auipc	a0,0x7
    80000c96:	3e650513          	addi	a0,a0,998 # 80008078 <digits+0x38>
    80000c9a:	00000097          	auipc	ra,0x0
    80000c9e:	8a8080e7          	jalr	-1880(ra) # 80000542 <panic>
        panic("pop_off");
    80000ca2:	00007517          	auipc	a0,0x7
    80000ca6:	3ee50513          	addi	a0,a0,1006 # 80008090 <digits+0x50>
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	898080e7          	jalr	-1896(ra) # 80000542 <panic>

0000000080000cb2 <release>:
{
    80000cb2:	1101                	addi	sp,sp,-32
    80000cb4:	ec06                	sd	ra,24(sp)
    80000cb6:	e822                	sd	s0,16(sp)
    80000cb8:	e426                	sd	s1,8(sp)
    80000cba:	1000                	addi	s0,sp,32
    80000cbc:	84aa                	mv	s1,a0
    if (!holding(lk))
    80000cbe:	00000097          	auipc	ra,0x0
    80000cc2:	ec6080e7          	jalr	-314(ra) # 80000b84 <holding>
    80000cc6:	c115                	beqz	a0,80000cea <release+0x38>
    lk->cpu = 0;
    80000cc8:	0004b823          	sd	zero,16(s1)
    __sync_synchronize();
    80000ccc:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    80000cd0:	0f50000f          	fence	iorw,ow
    80000cd4:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	f7a080e7          	jalr	-134(ra) # 80000c52 <pop_off>
}
    80000ce0:	60e2                	ld	ra,24(sp)
    80000ce2:	6442                	ld	s0,16(sp)
    80000ce4:	64a2                	ld	s1,8(sp)
    80000ce6:	6105                	addi	sp,sp,32
    80000ce8:	8082                	ret
        panic("release");
    80000cea:	00007517          	auipc	a0,0x7
    80000cee:	3ae50513          	addi	a0,a0,942 # 80008098 <digits+0x58>
    80000cf2:	00000097          	auipc	ra,0x0
    80000cf6:	850080e7          	jalr	-1968(ra) # 80000542 <panic>

0000000080000cfa <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    80000cfa:	1141                	addi	sp,sp,-16
    80000cfc:	e422                	sd	s0,8(sp)
    80000cfe:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
    80000d00:	ca19                	beqz	a2,80000d16 <memset+0x1c>
    80000d02:	87aa                	mv	a5,a0
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
    80000d0c:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
    80000d10:	0785                	addi	a5,a5,1
    80000d12:	fee79de3          	bne	a5,a4,80000d0c <memset+0x12>
    }
    return dst;
}
    80000d16:	6422                	ld	s0,8(sp)
    80000d18:	0141                	addi	sp,sp,16
    80000d1a:	8082                	ret

0000000080000d1c <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80000d1c:	1141                	addi	sp,sp,-16
    80000d1e:	e422                	sd	s0,8(sp)
    80000d20:	0800                	addi	s0,sp,16
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0)
    80000d22:	ca05                	beqz	a2,80000d52 <memcmp+0x36>
    80000d24:	fff6069b          	addiw	a3,a2,-1
    80000d28:	1682                	slli	a3,a3,0x20
    80000d2a:	9281                	srli	a3,a3,0x20
    80000d2c:	0685                	addi	a3,a3,1
    80000d2e:	96aa                	add	a3,a3,a0
    {
        if (*s1 != *s2)
    80000d30:	00054783          	lbu	a5,0(a0)
    80000d34:	0005c703          	lbu	a4,0(a1)
    80000d38:	00e79863          	bne	a5,a4,80000d48 <memcmp+0x2c>
            return *s1 - *s2;
        s1++, s2++;
    80000d3c:	0505                	addi	a0,a0,1
    80000d3e:	0585                	addi	a1,a1,1
    while (n-- > 0)
    80000d40:	fed518e3          	bne	a0,a3,80000d30 <memcmp+0x14>
    }

    return 0;
    80000d44:	4501                	li	a0,0
    80000d46:	a019                	j	80000d4c <memcmp+0x30>
            return *s1 - *s2;
    80000d48:	40e7853b          	subw	a0,a5,a4
}
    80000d4c:	6422                	ld	s0,8(sp)
    80000d4e:	0141                	addi	sp,sp,16
    80000d50:	8082                	ret
    return 0;
    80000d52:	4501                	li	a0,0
    80000d54:	bfe5                	j	80000d4c <memcmp+0x30>

0000000080000d56 <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e422                	sd	s0,8(sp)
    80000d5a:	0800                	addi	s0,sp,16
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d)
    80000d5c:	02a5e563          	bltu	a1,a0,80000d86 <memmove+0x30>
        d += n;
        while (n-- > 0)
            *--d = *--s;
    }
    else
        while (n-- > 0)
    80000d60:	fff6069b          	addiw	a3,a2,-1
    80000d64:	ce11                	beqz	a2,80000d80 <memmove+0x2a>
    80000d66:	1682                	slli	a3,a3,0x20
    80000d68:	9281                	srli	a3,a3,0x20
    80000d6a:	0685                	addi	a3,a3,1
    80000d6c:	96ae                	add	a3,a3,a1
    80000d6e:	87aa                	mv	a5,a0
            *d++ = *s++;
    80000d70:	0585                	addi	a1,a1,1
    80000d72:	0785                	addi	a5,a5,1
    80000d74:	fff5c703          	lbu	a4,-1(a1)
    80000d78:	fee78fa3          	sb	a4,-1(a5)
        while (n-- > 0)
    80000d7c:	fed59ae3          	bne	a1,a3,80000d70 <memmove+0x1a>

    return dst;
}
    80000d80:	6422                	ld	s0,8(sp)
    80000d82:	0141                	addi	sp,sp,16
    80000d84:	8082                	ret
    if (s < d && s + n > d)
    80000d86:	02061713          	slli	a4,a2,0x20
    80000d8a:	9301                	srli	a4,a4,0x20
    80000d8c:	00e587b3          	add	a5,a1,a4
    80000d90:	fcf578e3          	bgeu	a0,a5,80000d60 <memmove+0xa>
        d += n;
    80000d94:	972a                	add	a4,a4,a0
        while (n-- > 0)
    80000d96:	fff6069b          	addiw	a3,a2,-1
    80000d9a:	d27d                	beqz	a2,80000d80 <memmove+0x2a>
    80000d9c:	02069613          	slli	a2,a3,0x20
    80000da0:	9201                	srli	a2,a2,0x20
    80000da2:	fff64613          	not	a2,a2
    80000da6:	963e                	add	a2,a2,a5
            *--d = *--s;
    80000da8:	17fd                	addi	a5,a5,-1
    80000daa:	177d                	addi	a4,a4,-1
    80000dac:	0007c683          	lbu	a3,0(a5)
    80000db0:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    80000db4:	fef61ae3          	bne	a2,a5,80000da8 <memmove+0x52>
    80000db8:	b7e1                	j	80000d80 <memmove+0x2a>

0000000080000dba <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    80000dba:	1141                	addi	sp,sp,-16
    80000dbc:	e406                	sd	ra,8(sp)
    80000dbe:	e022                	sd	s0,0(sp)
    80000dc0:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	f94080e7          	jalr	-108(ra) # 80000d56 <memmove>
}
    80000dca:	60a2                	ld	ra,8(sp)
    80000dcc:	6402                	ld	s0,0(sp)
    80000dce:	0141                	addi	sp,sp,16
    80000dd0:	8082                	ret

0000000080000dd2 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80000dd2:	1141                	addi	sp,sp,-16
    80000dd4:	e422                	sd	s0,8(sp)
    80000dd6:	0800                	addi	s0,sp,16
    while (n > 0 && *p && *p == *q)
    80000dd8:	ce11                	beqz	a2,80000df4 <strncmp+0x22>
    80000dda:	00054783          	lbu	a5,0(a0)
    80000dde:	cf89                	beqz	a5,80000df8 <strncmp+0x26>
    80000de0:	0005c703          	lbu	a4,0(a1)
    80000de4:	00f71a63          	bne	a4,a5,80000df8 <strncmp+0x26>
        n--, p++, q++;
    80000de8:	367d                	addiw	a2,a2,-1
    80000dea:	0505                	addi	a0,a0,1
    80000dec:	0585                	addi	a1,a1,1
    while (n > 0 && *p && *p == *q)
    80000dee:	f675                	bnez	a2,80000dda <strncmp+0x8>
    if (n == 0)
        return 0;
    80000df0:	4501                	li	a0,0
    80000df2:	a809                	j	80000e04 <strncmp+0x32>
    80000df4:	4501                	li	a0,0
    80000df6:	a039                	j	80000e04 <strncmp+0x32>
    if (n == 0)
    80000df8:	ca09                	beqz	a2,80000e0a <strncmp+0x38>
    return (uchar)*p - (uchar)*q;
    80000dfa:	00054503          	lbu	a0,0(a0)
    80000dfe:	0005c783          	lbu	a5,0(a1)
    80000e02:	9d1d                	subw	a0,a0,a5
}
    80000e04:	6422                	ld	s0,8(sp)
    80000e06:	0141                	addi	sp,sp,16
    80000e08:	8082                	ret
        return 0;
    80000e0a:	4501                	li	a0,0
    80000e0c:	bfe5                	j	80000e04 <strncmp+0x32>

0000000080000e0e <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0)
    80000e14:	872a                	mv	a4,a0
    80000e16:	8832                	mv	a6,a2
    80000e18:	367d                	addiw	a2,a2,-1
    80000e1a:	01005963          	blez	a6,80000e2c <strncpy+0x1e>
    80000e1e:	0705                	addi	a4,a4,1
    80000e20:	0005c783          	lbu	a5,0(a1)
    80000e24:	fef70fa3          	sb	a5,-1(a4)
    80000e28:	0585                	addi	a1,a1,1
    80000e2a:	f7f5                	bnez	a5,80000e16 <strncpy+0x8>
        ;
    while (n-- > 0)
    80000e2c:	86ba                	mv	a3,a4
    80000e2e:	00c05c63          	blez	a2,80000e46 <strncpy+0x38>
        *s++ = 0;
    80000e32:	0685                	addi	a3,a3,1
    80000e34:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
    80000e38:	fff6c793          	not	a5,a3
    80000e3c:	9fb9                	addw	a5,a5,a4
    80000e3e:	010787bb          	addw	a5,a5,a6
    80000e42:	fef048e3          	bgtz	a5,80000e32 <strncpy+0x24>
    return os;
}
    80000e46:	6422                	ld	s0,8(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e422                	sd	s0,8(sp)
    80000e50:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    if (n <= 0)
    80000e52:	02c05363          	blez	a2,80000e78 <safestrcpy+0x2c>
    80000e56:	fff6069b          	addiw	a3,a2,-1
    80000e5a:	1682                	slli	a3,a3,0x20
    80000e5c:	9281                	srli	a3,a3,0x20
    80000e5e:	96ae                	add	a3,a3,a1
    80000e60:	87aa                	mv	a5,a0
        return os;
    while (--n > 0 && (*s++ = *t++) != 0)
    80000e62:	00d58963          	beq	a1,a3,80000e74 <safestrcpy+0x28>
    80000e66:	0585                	addi	a1,a1,1
    80000e68:	0785                	addi	a5,a5,1
    80000e6a:	fff5c703          	lbu	a4,-1(a1)
    80000e6e:	fee78fa3          	sb	a4,-1(a5)
    80000e72:	fb65                	bnez	a4,80000e62 <safestrcpy+0x16>
        ;
    *s = 0;
    80000e74:	00078023          	sb	zero,0(a5)
    return os;
}
    80000e78:	6422                	ld	s0,8(sp)
    80000e7a:	0141                	addi	sp,sp,16
    80000e7c:	8082                	ret

0000000080000e7e <strlen>:

int strlen(const char *s)
{
    80000e7e:	1141                	addi	sp,sp,-16
    80000e80:	e422                	sd	s0,8(sp)
    80000e82:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
    80000e84:	00054783          	lbu	a5,0(a0)
    80000e88:	cf91                	beqz	a5,80000ea4 <strlen+0x26>
    80000e8a:	0505                	addi	a0,a0,1
    80000e8c:	87aa                	mv	a5,a0
    80000e8e:	4685                	li	a3,1
    80000e90:	9e89                	subw	a3,a3,a0
    80000e92:	00f6853b          	addw	a0,a3,a5
    80000e96:	0785                	addi	a5,a5,1
    80000e98:	fff7c703          	lbu	a4,-1(a5)
    80000e9c:	fb7d                	bnez	a4,80000e92 <strlen+0x14>
        ;
    return n;
}
    80000e9e:	6422                	ld	s0,8(sp)
    80000ea0:	0141                	addi	sp,sp,16
    80000ea2:	8082                	ret
    for (n = 0; s[n]; n++)
    80000ea4:	4501                	li	a0,0
    80000ea6:	bfe5                	j	80000e9e <strlen+0x20>

0000000080000ea8 <main>:

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main()
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e406                	sd	ra,8(sp)
    80000eac:	e022                	sd	s0,0(sp)
    80000eae:	0800                	addi	s0,sp,16
    if (cpuid() == 0)
    80000eb0:	00001097          	auipc	ra,0x1
    80000eb4:	aee080e7          	jalr	-1298(ra) # 8000199e <cpuid>
        __sync_synchronize();
        started = 1;
    }
    else
    {
        while (started == 0)
    80000eb8:	00008717          	auipc	a4,0x8
    80000ebc:	15470713          	addi	a4,a4,340 # 8000900c <started>
    if (cpuid() == 0)
    80000ec0:	c139                	beqz	a0,80000f06 <main+0x5e>
        while (started == 0)
    80000ec2:	431c                	lw	a5,0(a4)
    80000ec4:	2781                	sext.w	a5,a5
    80000ec6:	dff5                	beqz	a5,80000ec2 <main+0x1a>
            ;
        __sync_synchronize();
    80000ec8:	0ff0000f          	fence
        printf("hart %d starting\n", cpuid());
    80000ecc:	00001097          	auipc	ra,0x1
    80000ed0:	ad2080e7          	jalr	-1326(ra) # 8000199e <cpuid>
    80000ed4:	85aa                	mv	a1,a0
    80000ed6:	00007517          	auipc	a0,0x7
    80000eda:	1e250513          	addi	a0,a0,482 # 800080b8 <digits+0x78>
    80000ede:	fffff097          	auipc	ra,0xfffff
    80000ee2:	6ae080e7          	jalr	1710(ra) # 8000058c <printf>
        kvminithart();  // turn on paging
    80000ee6:	00000097          	auipc	ra,0x0
    80000eea:	0d8080e7          	jalr	216(ra) # 80000fbe <kvminithart>
        trapinithart(); // install kernel trap vector
    80000eee:	00001097          	auipc	ra,0x1
    80000ef2:	732080e7          	jalr	1842(ra) # 80002620 <trapinithart>
        plicinithart(); // ask PLIC for device interrupts
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	2ca080e7          	jalr	714(ra) # 800061c0 <plicinithart>
    }

    scheduler();
    80000efe:	00001097          	auipc	ra,0x1
    80000f02:	000080e7          	jalr	ra # 80001efe <scheduler>
        consoleinit();
    80000f06:	fffff097          	auipc	ra,0xfffff
    80000f0a:	54e080e7          	jalr	1358(ra) # 80000454 <consoleinit>
        printfinit();
    80000f0e:	00000097          	auipc	ra,0x0
    80000f12:	85e080e7          	jalr	-1954(ra) # 8000076c <printfinit>
        printf("\n");
    80000f16:	00007517          	auipc	a0,0x7
    80000f1a:	1b250513          	addi	a0,a0,434 # 800080c8 <digits+0x88>
    80000f1e:	fffff097          	auipc	ra,0xfffff
    80000f22:	66e080e7          	jalr	1646(ra) # 8000058c <printf>
        printf("xv6 kernel is booting\n");
    80000f26:	00007517          	auipc	a0,0x7
    80000f2a:	17a50513          	addi	a0,a0,378 # 800080a0 <digits+0x60>
    80000f2e:	fffff097          	auipc	ra,0xfffff
    80000f32:	65e080e7          	jalr	1630(ra) # 8000058c <printf>
        printf("\n");
    80000f36:	00007517          	auipc	a0,0x7
    80000f3a:	19250513          	addi	a0,a0,402 # 800080c8 <digits+0x88>
    80000f3e:	fffff097          	auipc	ra,0xfffff
    80000f42:	64e080e7          	jalr	1614(ra) # 8000058c <printf>
        kinit();            // physical page allocator
    80000f46:	00000097          	auipc	ra,0x0
    80000f4a:	b8c080e7          	jalr	-1140(ra) # 80000ad2 <kinit>
        kvminit();          // create kernel page table
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	2a0080e7          	jalr	672(ra) # 800011ee <kvminit>
        kvminithart();      // turn on paging
    80000f56:	00000097          	auipc	ra,0x0
    80000f5a:	068080e7          	jalr	104(ra) # 80000fbe <kvminithart>
        procinit();         // process table
    80000f5e:	00001097          	auipc	ra,0x1
    80000f62:	970080e7          	jalr	-1680(ra) # 800018ce <procinit>
        trapinit();         // trap vectors
    80000f66:	00001097          	auipc	ra,0x1
    80000f6a:	692080e7          	jalr	1682(ra) # 800025f8 <trapinit>
        trapinithart();     // install kernel trap vector
    80000f6e:	00001097          	auipc	ra,0x1
    80000f72:	6b2080e7          	jalr	1714(ra) # 80002620 <trapinithart>
        plicinit();         // set up interrupt controller
    80000f76:	00005097          	auipc	ra,0x5
    80000f7a:	234080e7          	jalr	564(ra) # 800061aa <plicinit>
        plicinithart();     // ask PLIC for device interrupts
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	242080e7          	jalr	578(ra) # 800061c0 <plicinithart>
        binit();            // buffer cache
    80000f86:	00002097          	auipc	ra,0x2
    80000f8a:	e72080e7          	jalr	-398(ra) # 80002df8 <binit>
        iinit();            // inode cache
    80000f8e:	00002097          	auipc	ra,0x2
    80000f92:	470080e7          	jalr	1136(ra) # 800033fe <iinit>
        fileinit();         // file table
    80000f96:	00003097          	auipc	ra,0x3
    80000f9a:	6dc080e7          	jalr	1756(ra) # 80004672 <fileinit>
        virtio_disk_init(); // emulated hard disk
    80000f9e:	00005097          	auipc	ra,0x5
    80000fa2:	32a080e7          	jalr	810(ra) # 800062c8 <virtio_disk_init>
        userinit();         // first user process
    80000fa6:	00001097          	auipc	ra,0x1
    80000faa:	cee080e7          	jalr	-786(ra) # 80001c94 <userinit>
        __sync_synchronize();
    80000fae:	0ff0000f          	fence
        started = 1;
    80000fb2:	4785                	li	a5,1
    80000fb4:	00008717          	auipc	a4,0x8
    80000fb8:	04f72c23          	sw	a5,88(a4) # 8000900c <started>
    80000fbc:	b789                	j	80000efe <main+0x56>

0000000080000fbe <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000fbe:	1141                	addi	sp,sp,-16
    80000fc0:	e422                	sd	s0,8(sp)
    80000fc2:	0800                	addi	s0,sp,16
    w_satp(MAKE_SATP(kernel_pagetable));
    80000fc4:	00008797          	auipc	a5,0x8
    80000fc8:	04c7b783          	ld	a5,76(a5) # 80009010 <kernel_pagetable>
    80000fcc:	83b1                	srli	a5,a5,0xc
    80000fce:	577d                	li	a4,-1
    80000fd0:	177e                	slli	a4,a4,0x3f
    80000fd2:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    80000fd4:	18079073          	csrw	satp,a5

// flush the TLB.
static inline void sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    80000fd8:	12000073          	sfence.vma
    sfence_vma();
}
    80000fdc:	6422                	ld	s0,8(sp)
    80000fde:	0141                	addi	sp,sp,16
    80000fe0:	8082                	ret

0000000080000fe2 <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fe2:	7139                	addi	sp,sp,-64
    80000fe4:	fc06                	sd	ra,56(sp)
    80000fe6:	f822                	sd	s0,48(sp)
    80000fe8:	f426                	sd	s1,40(sp)
    80000fea:	f04a                	sd	s2,32(sp)
    80000fec:	ec4e                	sd	s3,24(sp)
    80000fee:	e852                	sd	s4,16(sp)
    80000ff0:	e456                	sd	s5,8(sp)
    80000ff2:	e05a                	sd	s6,0(sp)
    80000ff4:	0080                	addi	s0,sp,64
    80000ff6:	84aa                	mv	s1,a0
    80000ff8:	89ae                	mv	s3,a1
    80000ffa:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    80000ffc:	57fd                	li	a5,-1
    80000ffe:	83e9                	srli	a5,a5,0x1a
    80001000:	4a79                	li	s4,30
        panic("walk");

    for (int level = 2; level > 0; level--)
    80001002:	4b31                	li	s6,12
    if (va >= MAXVA)
    80001004:	04b7f263          	bgeu	a5,a1,80001048 <walk+0x66>
        panic("walk");
    80001008:	00007517          	auipc	a0,0x7
    8000100c:	0c850513          	addi	a0,a0,200 # 800080d0 <digits+0x90>
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	532080e7          	jalr	1330(ra) # 80000542 <panic>
        {
            pagetable = (pagetable_t)PTE2PA(*pte);
        }
        else
        {
            if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80001018:	060a8663          	beqz	s5,80001084 <walk+0xa2>
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	af2080e7          	jalr	-1294(ra) # 80000b0e <kalloc>
    80001024:	84aa                	mv	s1,a0
    80001026:	c529                	beqz	a0,80001070 <walk+0x8e>
                return 0;
            memset(pagetable, 0, PGSIZE);
    80001028:	6605                	lui	a2,0x1
    8000102a:	4581                	li	a1,0
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	cce080e7          	jalr	-818(ra) # 80000cfa <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    80001034:	00c4d793          	srli	a5,s1,0xc
    80001038:	07aa                	slli	a5,a5,0xa
    8000103a:	0017e793          	ori	a5,a5,1
    8000103e:	00f93023          	sd	a5,0(s2)
    for (int level = 2; level > 0; level--)
    80001042:	3a5d                	addiw	s4,s4,-9
    80001044:	036a0063          	beq	s4,s6,80001064 <walk+0x82>
        pte_t *pte = &pagetable[PX(level, va)];
    80001048:	0149d933          	srl	s2,s3,s4
    8000104c:	1ff97913          	andi	s2,s2,511
    80001050:	090e                	slli	s2,s2,0x3
    80001052:	9926                	add	s2,s2,s1
        if (*pte & PTE_V)
    80001054:	00093483          	ld	s1,0(s2)
    80001058:	0014f793          	andi	a5,s1,1
    8000105c:	dfd5                	beqz	a5,80001018 <walk+0x36>
            pagetable = (pagetable_t)PTE2PA(*pte);
    8000105e:	80a9                	srli	s1,s1,0xa
    80001060:	04b2                	slli	s1,s1,0xc
    80001062:	b7c5                	j	80001042 <walk+0x60>
        }
    }
    return &pagetable[PX(0, va)];
    80001064:	00c9d513          	srli	a0,s3,0xc
    80001068:	1ff57513          	andi	a0,a0,511
    8000106c:	050e                	slli	a0,a0,0x3
    8000106e:	9526                	add	a0,a0,s1
}
    80001070:	70e2                	ld	ra,56(sp)
    80001072:	7442                	ld	s0,48(sp)
    80001074:	74a2                	ld	s1,40(sp)
    80001076:	7902                	ld	s2,32(sp)
    80001078:	69e2                	ld	s3,24(sp)
    8000107a:	6a42                	ld	s4,16(sp)
    8000107c:	6aa2                	ld	s5,8(sp)
    8000107e:	6b02                	ld	s6,0(sp)
    80001080:	6121                	addi	sp,sp,64
    80001082:	8082                	ret
                return 0;
    80001084:	4501                	li	a0,0
    80001086:	b7ed                	j	80001070 <walk+0x8e>

0000000080001088 <walkaddr>:
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    80001088:	57fd                	li	a5,-1
    8000108a:	83e9                	srli	a5,a5,0x1a
    8000108c:	00b7f463          	bgeu	a5,a1,80001094 <walkaddr+0xc>
        return 0;
    80001090:	4501                	li	a0,0
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80001092:	8082                	ret
{
    80001094:	1141                	addi	sp,sp,-16
    80001096:	e406                	sd	ra,8(sp)
    80001098:	e022                	sd	s0,0(sp)
    8000109a:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    8000109c:	4601                	li	a2,0
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	f44080e7          	jalr	-188(ra) # 80000fe2 <walk>
    if (pte == 0)
    800010a6:	c105                	beqz	a0,800010c6 <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    800010a8:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    800010aa:	0117f693          	andi	a3,a5,17
    800010ae:	4745                	li	a4,17
        return 0;
    800010b0:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
    800010b2:	00e68663          	beq	a3,a4,800010be <walkaddr+0x36>
}
    800010b6:	60a2                	ld	ra,8(sp)
    800010b8:	6402                	ld	s0,0(sp)
    800010ba:	0141                	addi	sp,sp,16
    800010bc:	8082                	ret
    pa = PTE2PA(*pte);
    800010be:	00a7d513          	srli	a0,a5,0xa
    800010c2:	0532                	slli	a0,a0,0xc
    return pa;
    800010c4:	bfcd                	j	800010b6 <walkaddr+0x2e>
        return 0;
    800010c6:	4501                	li	a0,0
    800010c8:	b7fd                	j	800010b6 <walkaddr+0x2e>

00000000800010ca <kvmpa>:
// translate a kernel virtual address to
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64 kvmpa(uint64 va)
{
    800010ca:	1101                	addi	sp,sp,-32
    800010cc:	ec06                	sd	ra,24(sp)
    800010ce:	e822                	sd	s0,16(sp)
    800010d0:	e426                	sd	s1,8(sp)
    800010d2:	1000                	addi	s0,sp,32
    800010d4:	85aa                	mv	a1,a0
    uint64 off = va % PGSIZE;
    800010d6:	1552                	slli	a0,a0,0x34
    800010d8:	03455493          	srli	s1,a0,0x34
    pte_t *pte;
    uint64 pa;

    pte = walk(kernel_pagetable, va, 0);
    800010dc:	4601                	li	a2,0
    800010de:	00008517          	auipc	a0,0x8
    800010e2:	f3253503          	ld	a0,-206(a0) # 80009010 <kernel_pagetable>
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	efc080e7          	jalr	-260(ra) # 80000fe2 <walk>
    if (pte == 0)
    800010ee:	cd09                	beqz	a0,80001108 <kvmpa+0x3e>
        panic("kvmpa");
    if ((*pte & PTE_V) == 0)
    800010f0:	6108                	ld	a0,0(a0)
    800010f2:	00157793          	andi	a5,a0,1
    800010f6:	c38d                	beqz	a5,80001118 <kvmpa+0x4e>
        panic("kvmpa");
    pa = PTE2PA(*pte);
    800010f8:	8129                	srli	a0,a0,0xa
    800010fa:	0532                	slli	a0,a0,0xc
    return pa + off;
}
    800010fc:	9526                	add	a0,a0,s1
    800010fe:	60e2                	ld	ra,24(sp)
    80001100:	6442                	ld	s0,16(sp)
    80001102:	64a2                	ld	s1,8(sp)
    80001104:	6105                	addi	sp,sp,32
    80001106:	8082                	ret
        panic("kvmpa");
    80001108:	00007517          	auipc	a0,0x7
    8000110c:	fd050513          	addi	a0,a0,-48 # 800080d8 <digits+0x98>
    80001110:	fffff097          	auipc	ra,0xfffff
    80001114:	432080e7          	jalr	1074(ra) # 80000542 <panic>
        panic("kvmpa");
    80001118:	00007517          	auipc	a0,0x7
    8000111c:	fc050513          	addi	a0,a0,-64 # 800080d8 <digits+0x98>
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	422080e7          	jalr	1058(ra) # 80000542 <panic>

0000000080001128 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001128:	715d                	addi	sp,sp,-80
    8000112a:	e486                	sd	ra,72(sp)
    8000112c:	e0a2                	sd	s0,64(sp)
    8000112e:	fc26                	sd	s1,56(sp)
    80001130:	f84a                	sd	s2,48(sp)
    80001132:	f44e                	sd	s3,40(sp)
    80001134:	f052                	sd	s4,32(sp)
    80001136:	ec56                	sd	s5,24(sp)
    80001138:	e85a                	sd	s6,16(sp)
    8000113a:	e45e                	sd	s7,8(sp)
    8000113c:	0880                	addi	s0,sp,80
    8000113e:	8aaa                	mv	s5,a0
    80001140:	8b3a                	mv	s6,a4
    uint64 a, last;
    pte_t *pte;

    a = PGROUNDDOWN(va);
    80001142:	777d                	lui	a4,0xfffff
    80001144:	00e5f7b3          	and	a5,a1,a4
    last = PGROUNDDOWN(va + size - 1);
    80001148:	167d                	addi	a2,a2,-1
    8000114a:	00b609b3          	add	s3,a2,a1
    8000114e:	00e9f9b3          	and	s3,s3,a4
    a = PGROUNDDOWN(va);
    80001152:	893e                	mv	s2,a5
    80001154:	40f68a33          	sub	s4,a3,a5
        if (*pte & PTE_V)
            panic("remap");
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last)
            break;
        a += PGSIZE;
    80001158:	6b85                	lui	s7,0x1
    8000115a:	012a04b3          	add	s1,s4,s2
        if ((pte = walk(pagetable, a, 1)) == 0)
    8000115e:	4605                	li	a2,1
    80001160:	85ca                	mv	a1,s2
    80001162:	8556                	mv	a0,s5
    80001164:	00000097          	auipc	ra,0x0
    80001168:	e7e080e7          	jalr	-386(ra) # 80000fe2 <walk>
    8000116c:	c51d                	beqz	a0,8000119a <mappages+0x72>
        if (*pte & PTE_V)
    8000116e:	611c                	ld	a5,0(a0)
    80001170:	8b85                	andi	a5,a5,1
    80001172:	ef81                	bnez	a5,8000118a <mappages+0x62>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80001174:	80b1                	srli	s1,s1,0xc
    80001176:	04aa                	slli	s1,s1,0xa
    80001178:	0164e4b3          	or	s1,s1,s6
    8000117c:	0014e493          	ori	s1,s1,1
    80001180:	e104                	sd	s1,0(a0)
        if (a == last)
    80001182:	03390863          	beq	s2,s3,800011b2 <mappages+0x8a>
        a += PGSIZE;
    80001186:	995e                	add	s2,s2,s7
        if ((pte = walk(pagetable, a, 1)) == 0)
    80001188:	bfc9                	j	8000115a <mappages+0x32>
            panic("remap");
    8000118a:	00007517          	auipc	a0,0x7
    8000118e:	f5650513          	addi	a0,a0,-170 # 800080e0 <digits+0xa0>
    80001192:	fffff097          	auipc	ra,0xfffff
    80001196:	3b0080e7          	jalr	944(ra) # 80000542 <panic>
            return -1;
    8000119a:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    8000119c:	60a6                	ld	ra,72(sp)
    8000119e:	6406                	ld	s0,64(sp)
    800011a0:	74e2                	ld	s1,56(sp)
    800011a2:	7942                	ld	s2,48(sp)
    800011a4:	79a2                	ld	s3,40(sp)
    800011a6:	7a02                	ld	s4,32(sp)
    800011a8:	6ae2                	ld	s5,24(sp)
    800011aa:	6b42                	ld	s6,16(sp)
    800011ac:	6ba2                	ld	s7,8(sp)
    800011ae:	6161                	addi	sp,sp,80
    800011b0:	8082                	ret
    return 0;
    800011b2:	4501                	li	a0,0
    800011b4:	b7e5                	j	8000119c <mappages+0x74>

00000000800011b6 <kvmmap>:
{
    800011b6:	1141                	addi	sp,sp,-16
    800011b8:	e406                	sd	ra,8(sp)
    800011ba:	e022                	sd	s0,0(sp)
    800011bc:	0800                	addi	s0,sp,16
    800011be:	8736                	mv	a4,a3
    if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800011c0:	86ae                	mv	a3,a1
    800011c2:	85aa                	mv	a1,a0
    800011c4:	00008517          	auipc	a0,0x8
    800011c8:	e4c53503          	ld	a0,-436(a0) # 80009010 <kernel_pagetable>
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f5c080e7          	jalr	-164(ra) # 80001128 <mappages>
    800011d4:	e509                	bnez	a0,800011de <kvmmap+0x28>
}
    800011d6:	60a2                	ld	ra,8(sp)
    800011d8:	6402                	ld	s0,0(sp)
    800011da:	0141                	addi	sp,sp,16
    800011dc:	8082                	ret
        panic("kvmmap");
    800011de:	00007517          	auipc	a0,0x7
    800011e2:	f0a50513          	addi	a0,a0,-246 # 800080e8 <digits+0xa8>
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	35c080e7          	jalr	860(ra) # 80000542 <panic>

00000000800011ee <kvminit>:
{
    800011ee:	1101                	addi	sp,sp,-32
    800011f0:	ec06                	sd	ra,24(sp)
    800011f2:	e822                	sd	s0,16(sp)
    800011f4:	e426                	sd	s1,8(sp)
    800011f6:	1000                	addi	s0,sp,32
    kernel_pagetable = (pagetable_t)kalloc();
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	916080e7          	jalr	-1770(ra) # 80000b0e <kalloc>
    80001200:	00008797          	auipc	a5,0x8
    80001204:	e0a7b823          	sd	a0,-496(a5) # 80009010 <kernel_pagetable>
    memset(kernel_pagetable, 0, PGSIZE);
    80001208:	6605                	lui	a2,0x1
    8000120a:	4581                	li	a1,0
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	aee080e7          	jalr	-1298(ra) # 80000cfa <memset>
    kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001214:	4699                	li	a3,6
    80001216:	6605                	lui	a2,0x1
    80001218:	100005b7          	lui	a1,0x10000
    8000121c:	10000537          	lui	a0,0x10000
    80001220:	00000097          	auipc	ra,0x0
    80001224:	f96080e7          	jalr	-106(ra) # 800011b6 <kvmmap>
    kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001228:	4699                	li	a3,6
    8000122a:	6605                	lui	a2,0x1
    8000122c:	100015b7          	lui	a1,0x10001
    80001230:	10001537          	lui	a0,0x10001
    80001234:	00000097          	auipc	ra,0x0
    80001238:	f82080e7          	jalr	-126(ra) # 800011b6 <kvmmap>
    kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000123c:	4699                	li	a3,6
    8000123e:	6641                	lui	a2,0x10
    80001240:	020005b7          	lui	a1,0x2000
    80001244:	02000537          	lui	a0,0x2000
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f6e080e7          	jalr	-146(ra) # 800011b6 <kvmmap>
    kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001250:	4699                	li	a3,6
    80001252:	00400637          	lui	a2,0x400
    80001256:	0c0005b7          	lui	a1,0xc000
    8000125a:	0c000537          	lui	a0,0xc000
    8000125e:	00000097          	auipc	ra,0x0
    80001262:	f58080e7          	jalr	-168(ra) # 800011b6 <kvmmap>
    kvmmap(KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001266:	00007497          	auipc	s1,0x7
    8000126a:	d9a48493          	addi	s1,s1,-614 # 80008000 <etext>
    8000126e:	46a9                	li	a3,10
    80001270:	80007617          	auipc	a2,0x80007
    80001274:	d9060613          	addi	a2,a2,-624 # 8000 <_entry-0x7fff8000>
    80001278:	4585                	li	a1,1
    8000127a:	05fe                	slli	a1,a1,0x1f
    8000127c:	852e                	mv	a0,a1
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	f38080e7          	jalr	-200(ra) # 800011b6 <kvmmap>
    kvmmap((uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001286:	4699                	li	a3,6
    80001288:	4645                	li	a2,17
    8000128a:	066e                	slli	a2,a2,0x1b
    8000128c:	8e05                	sub	a2,a2,s1
    8000128e:	85a6                	mv	a1,s1
    80001290:	8526                	mv	a0,s1
    80001292:	00000097          	auipc	ra,0x0
    80001296:	f24080e7          	jalr	-220(ra) # 800011b6 <kvmmap>
    kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000129a:	46a9                	li	a3,10
    8000129c:	6605                	lui	a2,0x1
    8000129e:	00006597          	auipc	a1,0x6
    800012a2:	d6258593          	addi	a1,a1,-670 # 80007000 <_trampoline>
    800012a6:	04000537          	lui	a0,0x4000
    800012aa:	157d                	addi	a0,a0,-1
    800012ac:	0532                	slli	a0,a0,0xc
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	f08080e7          	jalr	-248(ra) # 800011b6 <kvmmap>
}
    800012b6:	60e2                	ld	ra,24(sp)
    800012b8:	6442                	ld	s0,16(sp)
    800012ba:	64a2                	ld	s1,8(sp)
    800012bc:	6105                	addi	sp,sp,32
    800012be:	8082                	ret

00000000800012c0 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012c0:	715d                	addi	sp,sp,-80
    800012c2:	e486                	sd	ra,72(sp)
    800012c4:	e0a2                	sd	s0,64(sp)
    800012c6:	fc26                	sd	s1,56(sp)
    800012c8:	f84a                	sd	s2,48(sp)
    800012ca:	f44e                	sd	s3,40(sp)
    800012cc:	f052                	sd	s4,32(sp)
    800012ce:	ec56                	sd	s5,24(sp)
    800012d0:	e85a                	sd	s6,16(sp)
    800012d2:	e45e                	sd	s7,8(sp)
    800012d4:	0880                	addi	s0,sp,80
    uint64 a;
    pte_t *pte;

    if ((va % PGSIZE) != 0)
    800012d6:	03459793          	slli	a5,a1,0x34
    800012da:	e795                	bnez	a5,80001306 <uvmunmap+0x46>
    800012dc:	8a2a                	mv	s4,a0
    800012de:	892e                	mv	s2,a1
    800012e0:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800012e2:	0632                	slli	a2,a2,0xc
    800012e4:	00b609b3          	add	s3,a2,a1
    {
        if ((pte = walk(pagetable, a, 0)) == 0)
            panic("uvmunmap: walk");
        if ((*pte & PTE_V) == 0)
            panic("uvmunmap: not mapped");
        if (PTE_FLAGS(*pte) == PTE_V)
    800012e8:	4b85                	li	s7,1
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800012ea:	6b05                	lui	s6,0x1
    800012ec:	0735e263          	bltu	a1,s3,80001350 <uvmunmap+0x90>
            uint64 pa = PTE2PA(*pte);
            kfree((void *)pa);
        }
        *pte = 0;
    }
}
    800012f0:	60a6                	ld	ra,72(sp)
    800012f2:	6406                	ld	s0,64(sp)
    800012f4:	74e2                	ld	s1,56(sp)
    800012f6:	7942                	ld	s2,48(sp)
    800012f8:	79a2                	ld	s3,40(sp)
    800012fa:	7a02                	ld	s4,32(sp)
    800012fc:	6ae2                	ld	s5,24(sp)
    800012fe:	6b42                	ld	s6,16(sp)
    80001300:	6ba2                	ld	s7,8(sp)
    80001302:	6161                	addi	sp,sp,80
    80001304:	8082                	ret
        panic("uvmunmap: not aligned");
    80001306:	00007517          	auipc	a0,0x7
    8000130a:	dea50513          	addi	a0,a0,-534 # 800080f0 <digits+0xb0>
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	234080e7          	jalr	564(ra) # 80000542 <panic>
            panic("uvmunmap: walk");
    80001316:	00007517          	auipc	a0,0x7
    8000131a:	df250513          	addi	a0,a0,-526 # 80008108 <digits+0xc8>
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	224080e7          	jalr	548(ra) # 80000542 <panic>
            panic("uvmunmap: not mapped");
    80001326:	00007517          	auipc	a0,0x7
    8000132a:	df250513          	addi	a0,a0,-526 # 80008118 <digits+0xd8>
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	214080e7          	jalr	532(ra) # 80000542 <panic>
            panic("uvmunmap: not a leaf");
    80001336:	00007517          	auipc	a0,0x7
    8000133a:	dfa50513          	addi	a0,a0,-518 # 80008130 <digits+0xf0>
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	204080e7          	jalr	516(ra) # 80000542 <panic>
        *pte = 0;
    80001346:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000134a:	995a                	add	s2,s2,s6
    8000134c:	fb3972e3          	bgeu	s2,s3,800012f0 <uvmunmap+0x30>
        if ((pte = walk(pagetable, a, 0)) == 0)
    80001350:	4601                	li	a2,0
    80001352:	85ca                	mv	a1,s2
    80001354:	8552                	mv	a0,s4
    80001356:	00000097          	auipc	ra,0x0
    8000135a:	c8c080e7          	jalr	-884(ra) # 80000fe2 <walk>
    8000135e:	84aa                	mv	s1,a0
    80001360:	d95d                	beqz	a0,80001316 <uvmunmap+0x56>
        if ((*pte & PTE_V) == 0)
    80001362:	6108                	ld	a0,0(a0)
    80001364:	00157793          	andi	a5,a0,1
    80001368:	dfdd                	beqz	a5,80001326 <uvmunmap+0x66>
        if (PTE_FLAGS(*pte) == PTE_V)
    8000136a:	3ff57793          	andi	a5,a0,1023
    8000136e:	fd7784e3          	beq	a5,s7,80001336 <uvmunmap+0x76>
        if (do_free)
    80001372:	fc0a8ae3          	beqz	s5,80001346 <uvmunmap+0x86>
            uint64 pa = PTE2PA(*pte);
    80001376:	8129                	srli	a0,a0,0xa
            kfree((void *)pa);
    80001378:	0532                	slli	a0,a0,0xc
    8000137a:	fffff097          	auipc	ra,0xfffff
    8000137e:	698080e7          	jalr	1688(ra) # 80000a12 <kfree>
    80001382:	b7d1                	j	80001346 <uvmunmap+0x86>

0000000080001384 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate()
{
    80001384:	1101                	addi	sp,sp,-32
    80001386:	ec06                	sd	ra,24(sp)
    80001388:	e822                	sd	s0,16(sp)
    8000138a:	e426                	sd	s1,8(sp)
    8000138c:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    8000138e:	fffff097          	auipc	ra,0xfffff
    80001392:	780080e7          	jalr	1920(ra) # 80000b0e <kalloc>
    80001396:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001398:	c519                	beqz	a0,800013a6 <uvmcreate+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    8000139a:	6605                	lui	a2,0x1
    8000139c:	4581                	li	a1,0
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	95c080e7          	jalr	-1700(ra) # 80000cfa <memset>
    return pagetable;
}
    800013a6:	8526                	mv	a0,s1
    800013a8:	60e2                	ld	ra,24(sp)
    800013aa:	6442                	ld	s0,16(sp)
    800013ac:	64a2                	ld	s1,8(sp)
    800013ae:	6105                	addi	sp,sp,32
    800013b0:	8082                	ret

00000000800013b2 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013b2:	7179                	addi	sp,sp,-48
    800013b4:	f406                	sd	ra,40(sp)
    800013b6:	f022                	sd	s0,32(sp)
    800013b8:	ec26                	sd	s1,24(sp)
    800013ba:	e84a                	sd	s2,16(sp)
    800013bc:	e44e                	sd	s3,8(sp)
    800013be:	e052                	sd	s4,0(sp)
    800013c0:	1800                	addi	s0,sp,48
    char *mem;

    if (sz >= PGSIZE)
    800013c2:	6785                	lui	a5,0x1
    800013c4:	04f67863          	bgeu	a2,a5,80001414 <uvminit+0x62>
    800013c8:	8a2a                	mv	s4,a0
    800013ca:	89ae                	mv	s3,a1
    800013cc:	84b2                	mv	s1,a2
        panic("inituvm: more than a page");
    mem = kalloc();
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	740080e7          	jalr	1856(ra) # 80000b0e <kalloc>
    800013d6:	892a                	mv	s2,a0
    memset(mem, 0, PGSIZE);
    800013d8:	6605                	lui	a2,0x1
    800013da:	4581                	li	a1,0
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	91e080e7          	jalr	-1762(ra) # 80000cfa <memset>
    mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800013e4:	4779                	li	a4,30
    800013e6:	86ca                	mv	a3,s2
    800013e8:	6605                	lui	a2,0x1
    800013ea:	4581                	li	a1,0
    800013ec:	8552                	mv	a0,s4
    800013ee:	00000097          	auipc	ra,0x0
    800013f2:	d3a080e7          	jalr	-710(ra) # 80001128 <mappages>
    memmove(mem, src, sz);
    800013f6:	8626                	mv	a2,s1
    800013f8:	85ce                	mv	a1,s3
    800013fa:	854a                	mv	a0,s2
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	95a080e7          	jalr	-1702(ra) # 80000d56 <memmove>
}
    80001404:	70a2                	ld	ra,40(sp)
    80001406:	7402                	ld	s0,32(sp)
    80001408:	64e2                	ld	s1,24(sp)
    8000140a:	6942                	ld	s2,16(sp)
    8000140c:	69a2                	ld	s3,8(sp)
    8000140e:	6a02                	ld	s4,0(sp)
    80001410:	6145                	addi	sp,sp,48
    80001412:	8082                	ret
        panic("inituvm: more than a page");
    80001414:	00007517          	auipc	a0,0x7
    80001418:	d3450513          	addi	a0,a0,-716 # 80008148 <digits+0x108>
    8000141c:	fffff097          	auipc	ra,0xfffff
    80001420:	126080e7          	jalr	294(ra) # 80000542 <panic>

0000000080001424 <uvmdealloc>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001424:	1101                	addi	sp,sp,-32
    80001426:	ec06                	sd	ra,24(sp)
    80001428:	e822                	sd	s0,16(sp)
    8000142a:	e426                	sd	s1,8(sp)
    8000142c:	1000                	addi	s0,sp,32
    if (newsz >= oldsz)
        return oldsz;
    8000142e:	84ae                	mv	s1,a1
    if (newsz >= oldsz)
    80001430:	00b67d63          	bgeu	a2,a1,8000144a <uvmdealloc+0x26>
    80001434:	84b2                	mv	s1,a2

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80001436:	6785                	lui	a5,0x1
    80001438:	17fd                	addi	a5,a5,-1
    8000143a:	00f60733          	add	a4,a2,a5
    8000143e:	767d                	lui	a2,0xfffff
    80001440:	8f71                	and	a4,a4,a2
    80001442:	97ae                	add	a5,a5,a1
    80001444:	8ff1                	and	a5,a5,a2
    80001446:	00f76863          	bltu	a4,a5,80001456 <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    8000144a:	8526                	mv	a0,s1
    8000144c:	60e2                	ld	ra,24(sp)
    8000144e:	6442                	ld	s0,16(sp)
    80001450:	64a2                	ld	s1,8(sp)
    80001452:	6105                	addi	sp,sp,32
    80001454:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001456:	8f99                	sub	a5,a5,a4
    80001458:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000145a:	4685                	li	a3,1
    8000145c:	0007861b          	sext.w	a2,a5
    80001460:	85ba                	mv	a1,a4
    80001462:	00000097          	auipc	ra,0x0
    80001466:	e5e080e7          	jalr	-418(ra) # 800012c0 <uvmunmap>
    8000146a:	b7c5                	j	8000144a <uvmdealloc+0x26>

000000008000146c <uvmalloc>:
    if (newsz < oldsz)
    8000146c:	0ab66163          	bltu	a2,a1,8000150e <uvmalloc+0xa2>
{
    80001470:	7139                	addi	sp,sp,-64
    80001472:	fc06                	sd	ra,56(sp)
    80001474:	f822                	sd	s0,48(sp)
    80001476:	f426                	sd	s1,40(sp)
    80001478:	f04a                	sd	s2,32(sp)
    8000147a:	ec4e                	sd	s3,24(sp)
    8000147c:	e852                	sd	s4,16(sp)
    8000147e:	e456                	sd	s5,8(sp)
    80001480:	0080                	addi	s0,sp,64
    80001482:	8aaa                	mv	s5,a0
    80001484:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    80001486:	6985                	lui	s3,0x1
    80001488:	19fd                	addi	s3,s3,-1
    8000148a:	95ce                	add	a1,a1,s3
    8000148c:	79fd                	lui	s3,0xfffff
    8000148e:	0135f9b3          	and	s3,a1,s3
    for (a = oldsz; a < newsz; a += PGSIZE)
    80001492:	08c9f063          	bgeu	s3,a2,80001512 <uvmalloc+0xa6>
    80001496:	894e                	mv	s2,s3
        mem = kalloc();
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	676080e7          	jalr	1654(ra) # 80000b0e <kalloc>
    800014a0:	84aa                	mv	s1,a0
        if (mem == 0)
    800014a2:	c51d                	beqz	a0,800014d0 <uvmalloc+0x64>
        memset(mem, 0, PGSIZE);
    800014a4:	6605                	lui	a2,0x1
    800014a6:	4581                	li	a1,0
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	852080e7          	jalr	-1966(ra) # 80000cfa <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64)mem,
    800014b0:	4779                	li	a4,30
    800014b2:	86a6                	mv	a3,s1
    800014b4:	6605                	lui	a2,0x1
    800014b6:	85ca                	mv	a1,s2
    800014b8:	8556                	mv	a0,s5
    800014ba:	00000097          	auipc	ra,0x0
    800014be:	c6e080e7          	jalr	-914(ra) # 80001128 <mappages>
    800014c2:	e905                	bnez	a0,800014f2 <uvmalloc+0x86>
    for (a = oldsz; a < newsz; a += PGSIZE)
    800014c4:	6785                	lui	a5,0x1
    800014c6:	993e                	add	s2,s2,a5
    800014c8:	fd4968e3          	bltu	s2,s4,80001498 <uvmalloc+0x2c>
    return newsz;
    800014cc:	8552                	mv	a0,s4
    800014ce:	a809                	j	800014e0 <uvmalloc+0x74>
            uvmdealloc(pagetable, a, oldsz);
    800014d0:	864e                	mv	a2,s3
    800014d2:	85ca                	mv	a1,s2
    800014d4:	8556                	mv	a0,s5
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	f4e080e7          	jalr	-178(ra) # 80001424 <uvmdealloc>
            return 0;
    800014de:	4501                	li	a0,0
}
    800014e0:	70e2                	ld	ra,56(sp)
    800014e2:	7442                	ld	s0,48(sp)
    800014e4:	74a2                	ld	s1,40(sp)
    800014e6:	7902                	ld	s2,32(sp)
    800014e8:	69e2                	ld	s3,24(sp)
    800014ea:	6a42                	ld	s4,16(sp)
    800014ec:	6aa2                	ld	s5,8(sp)
    800014ee:	6121                	addi	sp,sp,64
    800014f0:	8082                	ret
            kfree(mem);
    800014f2:	8526                	mv	a0,s1
    800014f4:	fffff097          	auipc	ra,0xfffff
    800014f8:	51e080e7          	jalr	1310(ra) # 80000a12 <kfree>
            uvmdealloc(pagetable, a, oldsz);
    800014fc:	864e                	mv	a2,s3
    800014fe:	85ca                	mv	a1,s2
    80001500:	8556                	mv	a0,s5
    80001502:	00000097          	auipc	ra,0x0
    80001506:	f22080e7          	jalr	-222(ra) # 80001424 <uvmdealloc>
            return 0;
    8000150a:	4501                	li	a0,0
    8000150c:	bfd1                	j	800014e0 <uvmalloc+0x74>
        return oldsz;
    8000150e:	852e                	mv	a0,a1
}
    80001510:	8082                	ret
    return newsz;
    80001512:	8532                	mv	a0,a2
    80001514:	b7f1                	j	800014e0 <uvmalloc+0x74>

0000000080001516 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80001516:	7179                	addi	sp,sp,-48
    80001518:	f406                	sd	ra,40(sp)
    8000151a:	f022                	sd	s0,32(sp)
    8000151c:	ec26                	sd	s1,24(sp)
    8000151e:	e84a                	sd	s2,16(sp)
    80001520:	e44e                	sd	s3,8(sp)
    80001522:	e052                	sd	s4,0(sp)
    80001524:	1800                	addi	s0,sp,48
    80001526:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++)
    80001528:	84aa                	mv	s1,a0
    8000152a:	6905                	lui	s2,0x1
    8000152c:	992a                	add	s2,s2,a0
    {
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    8000152e:	4985                	li	s3,1
    80001530:	a821                	j	80001548 <freewalk+0x32>
        {
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    80001532:	8129                	srli	a0,a0,0xa
            freewalk((pagetable_t)child);
    80001534:	0532                	slli	a0,a0,0xc
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	fe0080e7          	jalr	-32(ra) # 80001516 <freewalk>
            pagetable[i] = 0;
    8000153e:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++)
    80001542:	04a1                	addi	s1,s1,8
    80001544:	03248163          	beq	s1,s2,80001566 <freewalk+0x50>
        pte_t pte = pagetable[i];
    80001548:	6088                	ld	a0,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    8000154a:	00f57793          	andi	a5,a0,15
    8000154e:	ff3782e3          	beq	a5,s3,80001532 <freewalk+0x1c>
        }
        else if (pte & PTE_V)
    80001552:	8905                	andi	a0,a0,1
    80001554:	d57d                	beqz	a0,80001542 <freewalk+0x2c>
        {
            panic("freewalk: leaf");
    80001556:	00007517          	auipc	a0,0x7
    8000155a:	c1250513          	addi	a0,a0,-1006 # 80008168 <digits+0x128>
    8000155e:	fffff097          	auipc	ra,0xfffff
    80001562:	fe4080e7          	jalr	-28(ra) # 80000542 <panic>
        }
    }
    kfree((void *)pagetable);
    80001566:	8552                	mv	a0,s4
    80001568:	fffff097          	auipc	ra,0xfffff
    8000156c:	4aa080e7          	jalr	1194(ra) # 80000a12 <kfree>
}
    80001570:	70a2                	ld	ra,40(sp)
    80001572:	7402                	ld	s0,32(sp)
    80001574:	64e2                	ld	s1,24(sp)
    80001576:	6942                	ld	s2,16(sp)
    80001578:	69a2                	ld	s3,8(sp)
    8000157a:	6a02                	ld	s4,0(sp)
    8000157c:	6145                	addi	sp,sp,48
    8000157e:	8082                	ret

0000000080001580 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001580:	1101                	addi	sp,sp,-32
    80001582:	ec06                	sd	ra,24(sp)
    80001584:	e822                	sd	s0,16(sp)
    80001586:	e426                	sd	s1,8(sp)
    80001588:	1000                	addi	s0,sp,32
    8000158a:	84aa                	mv	s1,a0
    if (sz > 0)
    8000158c:	e999                	bnez	a1,800015a2 <uvmfree+0x22>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    freewalk(pagetable);
    8000158e:	8526                	mv	a0,s1
    80001590:	00000097          	auipc	ra,0x0
    80001594:	f86080e7          	jalr	-122(ra) # 80001516 <freewalk>
}
    80001598:	60e2                	ld	ra,24(sp)
    8000159a:	6442                	ld	s0,16(sp)
    8000159c:	64a2                	ld	s1,8(sp)
    8000159e:	6105                	addi	sp,sp,32
    800015a0:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800015a2:	6605                	lui	a2,0x1
    800015a4:	167d                	addi	a2,a2,-1
    800015a6:	962e                	add	a2,a2,a1
    800015a8:	4685                	li	a3,1
    800015aa:	8231                	srli	a2,a2,0xc
    800015ac:	4581                	li	a1,0
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	d12080e7          	jalr	-750(ra) # 800012c0 <uvmunmap>
    800015b6:	bfe1                	j	8000158e <uvmfree+0xe>

00000000800015b8 <uvmcopy>:
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;

    for (i = 0; i < sz; i += PGSIZE)
    800015b8:	c679                	beqz	a2,80001686 <uvmcopy+0xce>
{
    800015ba:	715d                	addi	sp,sp,-80
    800015bc:	e486                	sd	ra,72(sp)
    800015be:	e0a2                	sd	s0,64(sp)
    800015c0:	fc26                	sd	s1,56(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f44e                	sd	s3,40(sp)
    800015c6:	f052                	sd	s4,32(sp)
    800015c8:	ec56                	sd	s5,24(sp)
    800015ca:	e85a                	sd	s6,16(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	0880                	addi	s0,sp,80
    800015d0:	8b2a                	mv	s6,a0
    800015d2:	8aae                	mv	s5,a1
    800015d4:	8a32                	mv	s4,a2
    for (i = 0; i < sz; i += PGSIZE)
    800015d6:	4981                	li	s3,0
    {
        if ((pte = walk(old, i, 0)) == 0)
    800015d8:	4601                	li	a2,0
    800015da:	85ce                	mv	a1,s3
    800015dc:	855a                	mv	a0,s6
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	a04080e7          	jalr	-1532(ra) # 80000fe2 <walk>
    800015e6:	c531                	beqz	a0,80001632 <uvmcopy+0x7a>
            panic("uvmcopy: pte should exist");
        if ((*pte & PTE_V) == 0)
    800015e8:	6118                	ld	a4,0(a0)
    800015ea:	00177793          	andi	a5,a4,1
    800015ee:	cbb1                	beqz	a5,80001642 <uvmcopy+0x8a>
            panic("uvmcopy: page not present");
        pa = PTE2PA(*pte);
    800015f0:	00a75593          	srli	a1,a4,0xa
    800015f4:	00c59b93          	slli	s7,a1,0xc
        flags = PTE_FLAGS(*pte);
    800015f8:	3ff77493          	andi	s1,a4,1023
        if ((mem = kalloc()) == 0)
    800015fc:	fffff097          	auipc	ra,0xfffff
    80001600:	512080e7          	jalr	1298(ra) # 80000b0e <kalloc>
    80001604:	892a                	mv	s2,a0
    80001606:	c939                	beqz	a0,8000165c <uvmcopy+0xa4>
            goto err;
        memmove(mem, (char *)pa, PGSIZE);
    80001608:	6605                	lui	a2,0x1
    8000160a:	85de                	mv	a1,s7
    8000160c:	fffff097          	auipc	ra,0xfffff
    80001610:	74a080e7          	jalr	1866(ra) # 80000d56 <memmove>
        if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80001614:	8726                	mv	a4,s1
    80001616:	86ca                	mv	a3,s2
    80001618:	6605                	lui	a2,0x1
    8000161a:	85ce                	mv	a1,s3
    8000161c:	8556                	mv	a0,s5
    8000161e:	00000097          	auipc	ra,0x0
    80001622:	b0a080e7          	jalr	-1270(ra) # 80001128 <mappages>
    80001626:	e515                	bnez	a0,80001652 <uvmcopy+0x9a>
    for (i = 0; i < sz; i += PGSIZE)
    80001628:	6785                	lui	a5,0x1
    8000162a:	99be                	add	s3,s3,a5
    8000162c:	fb49e6e3          	bltu	s3,s4,800015d8 <uvmcopy+0x20>
    80001630:	a081                	j	80001670 <uvmcopy+0xb8>
            panic("uvmcopy: pte should exist");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	b4650513          	addi	a0,a0,-1210 # 80008178 <digits+0x138>
    8000163a:	fffff097          	auipc	ra,0xfffff
    8000163e:	f08080e7          	jalr	-248(ra) # 80000542 <panic>
            panic("uvmcopy: page not present");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	b5650513          	addi	a0,a0,-1194 # 80008198 <digits+0x158>
    8000164a:	fffff097          	auipc	ra,0xfffff
    8000164e:	ef8080e7          	jalr	-264(ra) # 80000542 <panic>
        {
            kfree(mem);
    80001652:	854a                	mv	a0,s2
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	3be080e7          	jalr	958(ra) # 80000a12 <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    8000165c:	4685                	li	a3,1
    8000165e:	00c9d613          	srli	a2,s3,0xc
    80001662:	4581                	li	a1,0
    80001664:	8556                	mv	a0,s5
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	c5a080e7          	jalr	-934(ra) # 800012c0 <uvmunmap>
    return -1;
    8000166e:	557d                	li	a0,-1
}
    80001670:	60a6                	ld	ra,72(sp)
    80001672:	6406                	ld	s0,64(sp)
    80001674:	74e2                	ld	s1,56(sp)
    80001676:	7942                	ld	s2,48(sp)
    80001678:	79a2                	ld	s3,40(sp)
    8000167a:	7a02                	ld	s4,32(sp)
    8000167c:	6ae2                	ld	s5,24(sp)
    8000167e:	6b42                	ld	s6,16(sp)
    80001680:	6ba2                	ld	s7,8(sp)
    80001682:	6161                	addi	sp,sp,80
    80001684:	8082                	ret
    return 0;
    80001686:	4501                	li	a0,0
}
    80001688:	8082                	ret

000000008000168a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    8000168a:	1141                	addi	sp,sp,-16
    8000168c:	e406                	sd	ra,8(sp)
    8000168e:	e022                	sd	s0,0(sp)
    80001690:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80001692:	4601                	li	a2,0
    80001694:	00000097          	auipc	ra,0x0
    80001698:	94e080e7          	jalr	-1714(ra) # 80000fe2 <walk>
    if (pte == 0)
    8000169c:	c901                	beqz	a0,800016ac <uvmclear+0x22>
        panic("uvmclear");
    *pte &= ~PTE_U;
    8000169e:	611c                	ld	a5,0(a0)
    800016a0:	9bbd                	andi	a5,a5,-17
    800016a2:	e11c                	sd	a5,0(a0)
}
    800016a4:	60a2                	ld	ra,8(sp)
    800016a6:	6402                	ld	s0,0(sp)
    800016a8:	0141                	addi	sp,sp,16
    800016aa:	8082                	ret
        panic("uvmclear");
    800016ac:	00007517          	auipc	a0,0x7
    800016b0:	b0c50513          	addi	a0,a0,-1268 # 800081b8 <digits+0x178>
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	e8e080e7          	jalr	-370(ra) # 80000542 <panic>

00000000800016bc <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    800016bc:	c6bd                	beqz	a3,8000172a <copyout+0x6e>
{
    800016be:	715d                	addi	sp,sp,-80
    800016c0:	e486                	sd	ra,72(sp)
    800016c2:	e0a2                	sd	s0,64(sp)
    800016c4:	fc26                	sd	s1,56(sp)
    800016c6:	f84a                	sd	s2,48(sp)
    800016c8:	f44e                	sd	s3,40(sp)
    800016ca:	f052                	sd	s4,32(sp)
    800016cc:	ec56                	sd	s5,24(sp)
    800016ce:	e85a                	sd	s6,16(sp)
    800016d0:	e45e                	sd	s7,8(sp)
    800016d2:	e062                	sd	s8,0(sp)
    800016d4:	0880                	addi	s0,sp,80
    800016d6:	8b2a                	mv	s6,a0
    800016d8:	8c2e                	mv	s8,a1
    800016da:	8a32                	mv	s4,a2
    800016dc:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(dstva);
    800016de:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (dstva - va0);
    800016e0:	6a85                	lui	s5,0x1
    800016e2:	a015                	j	80001706 <copyout+0x4a>
        if (n > len)
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016e4:	9562                	add	a0,a0,s8
    800016e6:	0004861b          	sext.w	a2,s1
    800016ea:	85d2                	mv	a1,s4
    800016ec:	41250533          	sub	a0,a0,s2
    800016f0:	fffff097          	auipc	ra,0xfffff
    800016f4:	666080e7          	jalr	1638(ra) # 80000d56 <memmove>

        len -= n;
    800016f8:	409989b3          	sub	s3,s3,s1
        src += n;
    800016fc:	9a26                	add	s4,s4,s1
        dstva = va0 + PGSIZE;
    800016fe:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80001702:	02098263          	beqz	s3,80001726 <copyout+0x6a>
        va0 = PGROUNDDOWN(dstva);
    80001706:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    8000170a:	85ca                	mv	a1,s2
    8000170c:	855a                	mv	a0,s6
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	97a080e7          	jalr	-1670(ra) # 80001088 <walkaddr>
        if (pa0 == 0)
    80001716:	cd01                	beqz	a0,8000172e <copyout+0x72>
        n = PGSIZE - (dstva - va0);
    80001718:	418904b3          	sub	s1,s2,s8
    8000171c:	94d6                	add	s1,s1,s5
        if (n > len)
    8000171e:	fc99f3e3          	bgeu	s3,s1,800016e4 <copyout+0x28>
    80001722:	84ce                	mv	s1,s3
    80001724:	b7c1                	j	800016e4 <copyout+0x28>
    }
    return 0;
    80001726:	4501                	li	a0,0
    80001728:	a021                	j	80001730 <copyout+0x74>
    8000172a:	4501                	li	a0,0
}
    8000172c:	8082                	ret
            return -1;
    8000172e:	557d                	li	a0,-1
}
    80001730:	60a6                	ld	ra,72(sp)
    80001732:	6406                	ld	s0,64(sp)
    80001734:	74e2                	ld	s1,56(sp)
    80001736:	7942                	ld	s2,48(sp)
    80001738:	79a2                	ld	s3,40(sp)
    8000173a:	7a02                	ld	s4,32(sp)
    8000173c:	6ae2                	ld	s5,24(sp)
    8000173e:	6b42                	ld	s6,16(sp)
    80001740:	6ba2                	ld	s7,8(sp)
    80001742:	6c02                	ld	s8,0(sp)
    80001744:	6161                	addi	sp,sp,80
    80001746:	8082                	ret

0000000080001748 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    80001748:	caa5                	beqz	a3,800017b8 <copyin+0x70>
{
    8000174a:	715d                	addi	sp,sp,-80
    8000174c:	e486                	sd	ra,72(sp)
    8000174e:	e0a2                	sd	s0,64(sp)
    80001750:	fc26                	sd	s1,56(sp)
    80001752:	f84a                	sd	s2,48(sp)
    80001754:	f44e                	sd	s3,40(sp)
    80001756:	f052                	sd	s4,32(sp)
    80001758:	ec56                	sd	s5,24(sp)
    8000175a:	e85a                	sd	s6,16(sp)
    8000175c:	e45e                	sd	s7,8(sp)
    8000175e:	e062                	sd	s8,0(sp)
    80001760:	0880                	addi	s0,sp,80
    80001762:	8b2a                	mv	s6,a0
    80001764:	8a2e                	mv	s4,a1
    80001766:	8c32                	mv	s8,a2
    80001768:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(srcva);
    8000176a:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    8000176c:	6a85                	lui	s5,0x1
    8000176e:	a01d                	j	80001794 <copyin+0x4c>
        if (n > len)
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001770:	018505b3          	add	a1,a0,s8
    80001774:	0004861b          	sext.w	a2,s1
    80001778:	412585b3          	sub	a1,a1,s2
    8000177c:	8552                	mv	a0,s4
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	5d8080e7          	jalr	1496(ra) # 80000d56 <memmove>

        len -= n;
    80001786:	409989b3          	sub	s3,s3,s1
        dst += n;
    8000178a:	9a26                	add	s4,s4,s1
        srcva = va0 + PGSIZE;
    8000178c:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80001790:	02098263          	beqz	s3,800017b4 <copyin+0x6c>
        va0 = PGROUNDDOWN(srcva);
    80001794:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80001798:	85ca                	mv	a1,s2
    8000179a:	855a                	mv	a0,s6
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	8ec080e7          	jalr	-1812(ra) # 80001088 <walkaddr>
        if (pa0 == 0)
    800017a4:	cd01                	beqz	a0,800017bc <copyin+0x74>
        n = PGSIZE - (srcva - va0);
    800017a6:	418904b3          	sub	s1,s2,s8
    800017aa:	94d6                	add	s1,s1,s5
        if (n > len)
    800017ac:	fc99f2e3          	bgeu	s3,s1,80001770 <copyin+0x28>
    800017b0:	84ce                	mv	s1,s3
    800017b2:	bf7d                	j	80001770 <copyin+0x28>
    }
    return 0;
    800017b4:	4501                	li	a0,0
    800017b6:	a021                	j	800017be <copyin+0x76>
    800017b8:	4501                	li	a0,0
}
    800017ba:	8082                	ret
            return -1;
    800017bc:	557d                	li	a0,-1
}
    800017be:	60a6                	ld	ra,72(sp)
    800017c0:	6406                	ld	s0,64(sp)
    800017c2:	74e2                	ld	s1,56(sp)
    800017c4:	7942                	ld	s2,48(sp)
    800017c6:	79a2                	ld	s3,40(sp)
    800017c8:	7a02                	ld	s4,32(sp)
    800017ca:	6ae2                	ld	s5,24(sp)
    800017cc:	6b42                	ld	s6,16(sp)
    800017ce:	6ba2                	ld	s7,8(sp)
    800017d0:	6c02                	ld	s8,0(sp)
    800017d2:	6161                	addi	sp,sp,80
    800017d4:	8082                	ret

00000000800017d6 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0)
    800017d6:	c6c5                	beqz	a3,8000187e <copyinstr+0xa8>
{
    800017d8:	715d                	addi	sp,sp,-80
    800017da:	e486                	sd	ra,72(sp)
    800017dc:	e0a2                	sd	s0,64(sp)
    800017de:	fc26                	sd	s1,56(sp)
    800017e0:	f84a                	sd	s2,48(sp)
    800017e2:	f44e                	sd	s3,40(sp)
    800017e4:	f052                	sd	s4,32(sp)
    800017e6:	ec56                	sd	s5,24(sp)
    800017e8:	e85a                	sd	s6,16(sp)
    800017ea:	e45e                	sd	s7,8(sp)
    800017ec:	0880                	addi	s0,sp,80
    800017ee:	8a2a                	mv	s4,a0
    800017f0:	8b2e                	mv	s6,a1
    800017f2:	8bb2                	mv	s7,a2
    800017f4:	84b6                	mv	s1,a3
    {
        va0 = PGROUNDDOWN(srcva);
    800017f6:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    800017f8:	6985                	lui	s3,0x1
    800017fa:	a035                	j	80001826 <copyinstr+0x50>
        char *p = (char *)(pa0 + (srcva - va0));
        while (n > 0)
        {
            if (*p == '\0')
            {
                *dst = '\0';
    800017fc:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001800:	4785                	li	a5,1
            dst++;
        }

        srcva = va0 + PGSIZE;
    }
    if (got_null)
    80001802:	0017b793          	seqz	a5,a5
    80001806:	40f00533          	neg	a0,a5
    }
    else
    {
        return -1;
    }
}
    8000180a:	60a6                	ld	ra,72(sp)
    8000180c:	6406                	ld	s0,64(sp)
    8000180e:	74e2                	ld	s1,56(sp)
    80001810:	7942                	ld	s2,48(sp)
    80001812:	79a2                	ld	s3,40(sp)
    80001814:	7a02                	ld	s4,32(sp)
    80001816:	6ae2                	ld	s5,24(sp)
    80001818:	6b42                	ld	s6,16(sp)
    8000181a:	6ba2                	ld	s7,8(sp)
    8000181c:	6161                	addi	sp,sp,80
    8000181e:	8082                	ret
        srcva = va0 + PGSIZE;
    80001820:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && max > 0)
    80001824:	c8a9                	beqz	s1,80001876 <copyinstr+0xa0>
        va0 = PGROUNDDOWN(srcva);
    80001826:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    8000182a:	85ca                	mv	a1,s2
    8000182c:	8552                	mv	a0,s4
    8000182e:	00000097          	auipc	ra,0x0
    80001832:	85a080e7          	jalr	-1958(ra) # 80001088 <walkaddr>
        if (pa0 == 0)
    80001836:	c131                	beqz	a0,8000187a <copyinstr+0xa4>
        n = PGSIZE - (srcva - va0);
    80001838:	41790833          	sub	a6,s2,s7
    8000183c:	984e                	add	a6,a6,s3
        if (n > max)
    8000183e:	0104f363          	bgeu	s1,a6,80001844 <copyinstr+0x6e>
    80001842:	8826                	mv	a6,s1
        char *p = (char *)(pa0 + (srcva - va0));
    80001844:	955e                	add	a0,a0,s7
    80001846:	41250533          	sub	a0,a0,s2
        while (n > 0)
    8000184a:	fc080be3          	beqz	a6,80001820 <copyinstr+0x4a>
    8000184e:	985a                	add	a6,a6,s6
    80001850:	87da                	mv	a5,s6
            if (*p == '\0')
    80001852:	41650633          	sub	a2,a0,s6
    80001856:	14fd                	addi	s1,s1,-1
    80001858:	9b26                	add	s6,s6,s1
    8000185a:	00f60733          	add	a4,a2,a5
    8000185e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80001862:	df49                	beqz	a4,800017fc <copyinstr+0x26>
                *dst = *p;
    80001864:	00e78023          	sb	a4,0(a5)
            --max;
    80001868:	40fb04b3          	sub	s1,s6,a5
            dst++;
    8000186c:	0785                	addi	a5,a5,1
        while (n > 0)
    8000186e:	ff0796e3          	bne	a5,a6,8000185a <copyinstr+0x84>
            dst++;
    80001872:	8b42                	mv	s6,a6
    80001874:	b775                	j	80001820 <copyinstr+0x4a>
    80001876:	4781                	li	a5,0
    80001878:	b769                	j	80001802 <copyinstr+0x2c>
            return -1;
    8000187a:	557d                	li	a0,-1
    8000187c:	b779                	j	8000180a <copyinstr+0x34>
    int got_null = 0;
    8000187e:	4781                	li	a5,0
    if (got_null)
    80001880:	0017b793          	seqz	a5,a5
    80001884:	40f00533          	neg	a0,a5
}
    80001888:	8082                	ret

000000008000188a <wakeup1>:
}

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void wakeup1(struct proc *p)
{
    8000188a:	1101                	addi	sp,sp,-32
    8000188c:	ec06                	sd	ra,24(sp)
    8000188e:	e822                	sd	s0,16(sp)
    80001890:	e426                	sd	s1,8(sp)
    80001892:	1000                	addi	s0,sp,32
    80001894:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80001896:	fffff097          	auipc	ra,0xfffff
    8000189a:	2ee080e7          	jalr	750(ra) # 80000b84 <holding>
    8000189e:	c909                	beqz	a0,800018b0 <wakeup1+0x26>
        panic("wakeup1");
    if (p->chan == p && p->state == SLEEPING)
    800018a0:	749c                	ld	a5,40(s1)
    800018a2:	00978f63          	beq	a5,s1,800018c0 <wakeup1+0x36>
    {
        p->state = RUNNABLE;
    }
}
    800018a6:	60e2                	ld	ra,24(sp)
    800018a8:	6442                	ld	s0,16(sp)
    800018aa:	64a2                	ld	s1,8(sp)
    800018ac:	6105                	addi	sp,sp,32
    800018ae:	8082                	ret
        panic("wakeup1");
    800018b0:	00007517          	auipc	a0,0x7
    800018b4:	91850513          	addi	a0,a0,-1768 # 800081c8 <digits+0x188>
    800018b8:	fffff097          	auipc	ra,0xfffff
    800018bc:	c8a080e7          	jalr	-886(ra) # 80000542 <panic>
    if (p->chan == p && p->state == SLEEPING)
    800018c0:	4c98                	lw	a4,24(s1)
    800018c2:	4785                	li	a5,1
    800018c4:	fef711e3          	bne	a4,a5,800018a6 <wakeup1+0x1c>
        p->state = RUNNABLE;
    800018c8:	4789                	li	a5,2
    800018ca:	cc9c                	sw	a5,24(s1)
}
    800018cc:	bfe9                	j	800018a6 <wakeup1+0x1c>

00000000800018ce <procinit>:
{
    800018ce:	715d                	addi	sp,sp,-80
    800018d0:	e486                	sd	ra,72(sp)
    800018d2:	e0a2                	sd	s0,64(sp)
    800018d4:	fc26                	sd	s1,56(sp)
    800018d6:	f84a                	sd	s2,48(sp)
    800018d8:	f44e                	sd	s3,40(sp)
    800018da:	f052                	sd	s4,32(sp)
    800018dc:	ec56                	sd	s5,24(sp)
    800018de:	e85a                	sd	s6,16(sp)
    800018e0:	e45e                	sd	s7,8(sp)
    800018e2:	0880                	addi	s0,sp,80
    initlock(&pid_lock, "nextpid");
    800018e4:	00007597          	auipc	a1,0x7
    800018e8:	8ec58593          	addi	a1,a1,-1812 # 800081d0 <digits+0x190>
    800018ec:	00010517          	auipc	a0,0x10
    800018f0:	06450513          	addi	a0,a0,100 # 80011950 <pid_lock>
    800018f4:	fffff097          	auipc	ra,0xfffff
    800018f8:	27a080e7          	jalr	634(ra) # 80000b6e <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    800018fc:	00010917          	auipc	s2,0x10
    80001900:	46c90913          	addi	s2,s2,1132 # 80011d68 <proc>
        initlock(&p->lock, "proc");
    80001904:	00007b97          	auipc	s7,0x7
    80001908:	8d4b8b93          	addi	s7,s7,-1836 # 800081d8 <digits+0x198>
        uint64 va = KSTACK((int)(p - proc));
    8000190c:	8b4a                	mv	s6,s2
    8000190e:	00006a97          	auipc	s5,0x6
    80001912:	6f2a8a93          	addi	s5,s5,1778 # 80008000 <etext>
    80001916:	040009b7          	lui	s3,0x4000
    8000191a:	19fd                	addi	s3,s3,-1
    8000191c:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    8000191e:	00016a17          	auipc	s4,0x16
    80001922:	e4aa0a13          	addi	s4,s4,-438 # 80017768 <tickslock>
        initlock(&p->lock, "proc");
    80001926:	85de                	mv	a1,s7
    80001928:	854a                	mv	a0,s2
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	244080e7          	jalr	580(ra) # 80000b6e <initlock>
        char *pa = kalloc();
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	1dc080e7          	jalr	476(ra) # 80000b0e <kalloc>
    8000193a:	85aa                	mv	a1,a0
        if (pa == 0)
    8000193c:	c929                	beqz	a0,8000198e <procinit+0xc0>
        uint64 va = KSTACK((int)(p - proc));
    8000193e:	416904b3          	sub	s1,s2,s6
    80001942:	848d                	srai	s1,s1,0x3
    80001944:	000ab783          	ld	a5,0(s5)
    80001948:	02f484b3          	mul	s1,s1,a5
    8000194c:	2485                	addiw	s1,s1,1
    8000194e:	00d4949b          	slliw	s1,s1,0xd
    80001952:	409984b3          	sub	s1,s3,s1
        kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001956:	4699                	li	a3,6
    80001958:	6605                	lui	a2,0x1
    8000195a:	8526                	mv	a0,s1
    8000195c:	00000097          	auipc	ra,0x0
    80001960:	85a080e7          	jalr	-1958(ra) # 800011b6 <kvmmap>
        p->kstack = va;
    80001964:	04993023          	sd	s1,64(s2)
    for (p = proc; p < &proc[NPROC]; p++)
    80001968:	16890913          	addi	s2,s2,360
    8000196c:	fb491de3          	bne	s2,s4,80001926 <procinit+0x58>
    kvminithart();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	64e080e7          	jalr	1614(ra) # 80000fbe <kvminithart>
}
    80001978:	60a6                	ld	ra,72(sp)
    8000197a:	6406                	ld	s0,64(sp)
    8000197c:	74e2                	ld	s1,56(sp)
    8000197e:	7942                	ld	s2,48(sp)
    80001980:	79a2                	ld	s3,40(sp)
    80001982:	7a02                	ld	s4,32(sp)
    80001984:	6ae2                	ld	s5,24(sp)
    80001986:	6b42                	ld	s6,16(sp)
    80001988:	6ba2                	ld	s7,8(sp)
    8000198a:	6161                	addi	sp,sp,80
    8000198c:	8082                	ret
            panic("kalloc");
    8000198e:	00007517          	auipc	a0,0x7
    80001992:	85250513          	addi	a0,a0,-1966 # 800081e0 <digits+0x1a0>
    80001996:	fffff097          	auipc	ra,0xfffff
    8000199a:	bac080e7          	jalr	-1108(ra) # 80000542 <panic>

000000008000199e <cpuid>:
{
    8000199e:	1141                	addi	sp,sp,-16
    800019a0:	e422                	sd	s0,8(sp)
    800019a2:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    800019a4:	8512                	mv	a0,tp
}
    800019a6:	2501                	sext.w	a0,a0
    800019a8:	6422                	ld	s0,8(sp)
    800019aa:	0141                	addi	sp,sp,16
    800019ac:	8082                	ret

00000000800019ae <mycpu>:
{
    800019ae:	1141                	addi	sp,sp,-16
    800019b0:	e422                	sd	s0,8(sp)
    800019b2:	0800                	addi	s0,sp,16
    800019b4:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    800019b6:	2781                	sext.w	a5,a5
    800019b8:	079e                	slli	a5,a5,0x7
}
    800019ba:	00010517          	auipc	a0,0x10
    800019be:	fae50513          	addi	a0,a0,-82 # 80011968 <cpus>
    800019c2:	953e                	add	a0,a0,a5
    800019c4:	6422                	ld	s0,8(sp)
    800019c6:	0141                	addi	sp,sp,16
    800019c8:	8082                	ret

00000000800019ca <myproc>:
{
    800019ca:	1101                	addi	sp,sp,-32
    800019cc:	ec06                	sd	ra,24(sp)
    800019ce:	e822                	sd	s0,16(sp)
    800019d0:	e426                	sd	s1,8(sp)
    800019d2:	1000                	addi	s0,sp,32
    push_off();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	1de080e7          	jalr	478(ra) # 80000bb2 <push_off>
    800019dc:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    800019de:	2781                	sext.w	a5,a5
    800019e0:	079e                	slli	a5,a5,0x7
    800019e2:	00010717          	auipc	a4,0x10
    800019e6:	f6e70713          	addi	a4,a4,-146 # 80011950 <pid_lock>
    800019ea:	97ba                	add	a5,a5,a4
    800019ec:	6f84                	ld	s1,24(a5)
    pop_off();
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	264080e7          	jalr	612(ra) # 80000c52 <pop_off>
}
    800019f6:	8526                	mv	a0,s1
    800019f8:	60e2                	ld	ra,24(sp)
    800019fa:	6442                	ld	s0,16(sp)
    800019fc:	64a2                	ld	s1,8(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret

0000000080001a02 <forkret>:
{
    80001a02:	1141                	addi	sp,sp,-16
    80001a04:	e406                	sd	ra,8(sp)
    80001a06:	e022                	sd	s0,0(sp)
    80001a08:	0800                	addi	s0,sp,16
    release(&myproc()->lock);
    80001a0a:	00000097          	auipc	ra,0x0
    80001a0e:	fc0080e7          	jalr	-64(ra) # 800019ca <myproc>
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	2a0080e7          	jalr	672(ra) # 80000cb2 <release>
    if (first)
    80001a1a:	00007797          	auipc	a5,0x7
    80001a1e:	f067a783          	lw	a5,-250(a5) # 80008920 <first.1>
    80001a22:	eb89                	bnez	a5,80001a34 <forkret+0x32>
    usertrapret();
    80001a24:	00001097          	auipc	ra,0x1
    80001a28:	c14080e7          	jalr	-1004(ra) # 80002638 <usertrapret>
}
    80001a2c:	60a2                	ld	ra,8(sp)
    80001a2e:	6402                	ld	s0,0(sp)
    80001a30:	0141                	addi	sp,sp,16
    80001a32:	8082                	ret
        first = 0;
    80001a34:	00007797          	auipc	a5,0x7
    80001a38:	ee07a623          	sw	zero,-276(a5) # 80008920 <first.1>
        fsinit(ROOTDEV);
    80001a3c:	4505                	li	a0,1
    80001a3e:	00002097          	auipc	ra,0x2
    80001a42:	940080e7          	jalr	-1728(ra) # 8000337e <fsinit>
    80001a46:	bff9                	j	80001a24 <forkret+0x22>

0000000080001a48 <allocpid>:
{
    80001a48:	1101                	addi	sp,sp,-32
    80001a4a:	ec06                	sd	ra,24(sp)
    80001a4c:	e822                	sd	s0,16(sp)
    80001a4e:	e426                	sd	s1,8(sp)
    80001a50:	e04a                	sd	s2,0(sp)
    80001a52:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001a54:	00010917          	auipc	s2,0x10
    80001a58:	efc90913          	addi	s2,s2,-260 # 80011950 <pid_lock>
    80001a5c:	854a                	mv	a0,s2
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	1a0080e7          	jalr	416(ra) # 80000bfe <acquire>
    pid = nextpid;
    80001a66:	00007797          	auipc	a5,0x7
    80001a6a:	ebe78793          	addi	a5,a5,-322 # 80008924 <nextpid>
    80001a6e:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001a70:	0014871b          	addiw	a4,s1,1
    80001a74:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001a76:	854a                	mv	a0,s2
    80001a78:	fffff097          	auipc	ra,0xfffff
    80001a7c:	23a080e7          	jalr	570(ra) # 80000cb2 <release>
}
    80001a80:	8526                	mv	a0,s1
    80001a82:	60e2                	ld	ra,24(sp)
    80001a84:	6442                	ld	s0,16(sp)
    80001a86:	64a2                	ld	s1,8(sp)
    80001a88:	6902                	ld	s2,0(sp)
    80001a8a:	6105                	addi	sp,sp,32
    80001a8c:	8082                	ret

0000000080001a8e <proc_pagetable>:
{
    80001a8e:	1101                	addi	sp,sp,-32
    80001a90:	ec06                	sd	ra,24(sp)
    80001a92:	e822                	sd	s0,16(sp)
    80001a94:	e426                	sd	s1,8(sp)
    80001a96:	e04a                	sd	s2,0(sp)
    80001a98:	1000                	addi	s0,sp,32
    80001a9a:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001a9c:	00000097          	auipc	ra,0x0
    80001aa0:	8e8080e7          	jalr	-1816(ra) # 80001384 <uvmcreate>
    80001aa4:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001aa6:	c121                	beqz	a0,80001ae6 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001aa8:	4729                	li	a4,10
    80001aaa:	00005697          	auipc	a3,0x5
    80001aae:	55668693          	addi	a3,a3,1366 # 80007000 <_trampoline>
    80001ab2:	6605                	lui	a2,0x1
    80001ab4:	040005b7          	lui	a1,0x4000
    80001ab8:	15fd                	addi	a1,a1,-1
    80001aba:	05b2                	slli	a1,a1,0xc
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	66c080e7          	jalr	1644(ra) # 80001128 <mappages>
    80001ac4:	02054863          	bltz	a0,80001af4 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001ac8:	4719                	li	a4,6
    80001aca:	05893683          	ld	a3,88(s2)
    80001ace:	6605                	lui	a2,0x1
    80001ad0:	020005b7          	lui	a1,0x2000
    80001ad4:	15fd                	addi	a1,a1,-1
    80001ad6:	05b6                	slli	a1,a1,0xd
    80001ad8:	8526                	mv	a0,s1
    80001ada:	fffff097          	auipc	ra,0xfffff
    80001ade:	64e080e7          	jalr	1614(ra) # 80001128 <mappages>
    80001ae2:	02054163          	bltz	a0,80001b04 <proc_pagetable+0x76>
}
    80001ae6:	8526                	mv	a0,s1
    80001ae8:	60e2                	ld	ra,24(sp)
    80001aea:	6442                	ld	s0,16(sp)
    80001aec:	64a2                	ld	s1,8(sp)
    80001aee:	6902                	ld	s2,0(sp)
    80001af0:	6105                	addi	sp,sp,32
    80001af2:	8082                	ret
        uvmfree(pagetable, 0);
    80001af4:	4581                	li	a1,0
    80001af6:	8526                	mv	a0,s1
    80001af8:	00000097          	auipc	ra,0x0
    80001afc:	a88080e7          	jalr	-1400(ra) # 80001580 <uvmfree>
        return 0;
    80001b00:	4481                	li	s1,0
    80001b02:	b7d5                	j	80001ae6 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b04:	4681                	li	a3,0
    80001b06:	4605                	li	a2,1
    80001b08:	040005b7          	lui	a1,0x4000
    80001b0c:	15fd                	addi	a1,a1,-1
    80001b0e:	05b2                	slli	a1,a1,0xc
    80001b10:	8526                	mv	a0,s1
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	7ae080e7          	jalr	1966(ra) # 800012c0 <uvmunmap>
        uvmfree(pagetable, 0);
    80001b1a:	4581                	li	a1,0
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	00000097          	auipc	ra,0x0
    80001b22:	a62080e7          	jalr	-1438(ra) # 80001580 <uvmfree>
        return 0;
    80001b26:	4481                	li	s1,0
    80001b28:	bf7d                	j	80001ae6 <proc_pagetable+0x58>

0000000080001b2a <proc_freepagetable>:
{
    80001b2a:	1101                	addi	sp,sp,-32
    80001b2c:	ec06                	sd	ra,24(sp)
    80001b2e:	e822                	sd	s0,16(sp)
    80001b30:	e426                	sd	s1,8(sp)
    80001b32:	e04a                	sd	s2,0(sp)
    80001b34:	1000                	addi	s0,sp,32
    80001b36:	84aa                	mv	s1,a0
    80001b38:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b3a:	4681                	li	a3,0
    80001b3c:	4605                	li	a2,1
    80001b3e:	040005b7          	lui	a1,0x4000
    80001b42:	15fd                	addi	a1,a1,-1
    80001b44:	05b2                	slli	a1,a1,0xc
    80001b46:	fffff097          	auipc	ra,0xfffff
    80001b4a:	77a080e7          	jalr	1914(ra) # 800012c0 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b4e:	4681                	li	a3,0
    80001b50:	4605                	li	a2,1
    80001b52:	020005b7          	lui	a1,0x2000
    80001b56:	15fd                	addi	a1,a1,-1
    80001b58:	05b6                	slli	a1,a1,0xd
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	fffff097          	auipc	ra,0xfffff
    80001b60:	764080e7          	jalr	1892(ra) # 800012c0 <uvmunmap>
    uvmfree(pagetable, sz);
    80001b64:	85ca                	mv	a1,s2
    80001b66:	8526                	mv	a0,s1
    80001b68:	00000097          	auipc	ra,0x0
    80001b6c:	a18080e7          	jalr	-1512(ra) # 80001580 <uvmfree>
}
    80001b70:	60e2                	ld	ra,24(sp)
    80001b72:	6442                	ld	s0,16(sp)
    80001b74:	64a2                	ld	s1,8(sp)
    80001b76:	6902                	ld	s2,0(sp)
    80001b78:	6105                	addi	sp,sp,32
    80001b7a:	8082                	ret

0000000080001b7c <freeproc>:
{
    80001b7c:	1101                	addi	sp,sp,-32
    80001b7e:	ec06                	sd	ra,24(sp)
    80001b80:	e822                	sd	s0,16(sp)
    80001b82:	e426                	sd	s1,8(sp)
    80001b84:	1000                	addi	s0,sp,32
    80001b86:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001b88:	6d28                	ld	a0,88(a0)
    80001b8a:	c509                	beqz	a0,80001b94 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	e86080e7          	jalr	-378(ra) # 80000a12 <kfree>
    p->trapframe = 0;
    80001b94:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001b98:	68a8                	ld	a0,80(s1)
    80001b9a:	c511                	beqz	a0,80001ba6 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001b9c:	64ac                	ld	a1,72(s1)
    80001b9e:	00000097          	auipc	ra,0x0
    80001ba2:	f8c080e7          	jalr	-116(ra) # 80001b2a <proc_freepagetable>
    p->pagetable = 0;
    80001ba6:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001baa:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001bae:	0204ac23          	sw	zero,56(s1)
    p->parent = 0;
    80001bb2:	0204b023          	sd	zero,32(s1)
    p->name[0] = 0;
    80001bb6:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001bba:	0204b423          	sd	zero,40(s1)
    p->killed = 0;
    80001bbe:	0204a823          	sw	zero,48(s1)
    p->xstate = 0;
    80001bc2:	0204aa23          	sw	zero,52(s1)
    p->state = UNUSED;
    80001bc6:	0004ac23          	sw	zero,24(s1)
}
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	64a2                	ld	s1,8(sp)
    80001bd0:	6105                	addi	sp,sp,32
    80001bd2:	8082                	ret

0000000080001bd4 <allocproc>:
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	e426                	sd	s1,8(sp)
    80001bdc:	e04a                	sd	s2,0(sp)
    80001bde:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001be0:	00010497          	auipc	s1,0x10
    80001be4:	18848493          	addi	s1,s1,392 # 80011d68 <proc>
    80001be8:	00016917          	auipc	s2,0x16
    80001bec:	b8090913          	addi	s2,s2,-1152 # 80017768 <tickslock>
        acquire(&p->lock);
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	fffff097          	auipc	ra,0xfffff
    80001bf6:	00c080e7          	jalr	12(ra) # 80000bfe <acquire>
        if (p->state == UNUSED)
    80001bfa:	4c9c                	lw	a5,24(s1)
    80001bfc:	cf81                	beqz	a5,80001c14 <allocproc+0x40>
            release(&p->lock);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	0b2080e7          	jalr	178(ra) # 80000cb2 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001c08:	16848493          	addi	s1,s1,360
    80001c0c:	ff2492e3          	bne	s1,s2,80001bf0 <allocproc+0x1c>
    return 0;
    80001c10:	4481                	li	s1,0
    80001c12:	a0b9                	j	80001c60 <allocproc+0x8c>
    p->pid = allocpid();
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	e34080e7          	jalr	-460(ra) # 80001a48 <allocpid>
    80001c1c:	dc88                	sw	a0,56(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	ef0080e7          	jalr	-272(ra) # 80000b0e <kalloc>
    80001c26:	892a                	mv	s2,a0
    80001c28:	eca8                	sd	a0,88(s1)
    80001c2a:	c131                	beqz	a0,80001c6e <allocproc+0x9a>
    p->pagetable = proc_pagetable(p);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	e60080e7          	jalr	-416(ra) # 80001a8e <proc_pagetable>
    80001c36:	892a                	mv	s2,a0
    80001c38:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001c3a:	c129                	beqz	a0,80001c7c <allocproc+0xa8>
    memset(&p->context, 0, sizeof(p->context));
    80001c3c:	07000613          	li	a2,112
    80001c40:	4581                	li	a1,0
    80001c42:	06048513          	addi	a0,s1,96
    80001c46:	fffff097          	auipc	ra,0xfffff
    80001c4a:	0b4080e7          	jalr	180(ra) # 80000cfa <memset>
    p->context.ra = (uint64)forkret;
    80001c4e:	00000797          	auipc	a5,0x0
    80001c52:	db478793          	addi	a5,a5,-588 # 80001a02 <forkret>
    80001c56:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001c58:	60bc                	ld	a5,64(s1)
    80001c5a:	6705                	lui	a4,0x1
    80001c5c:	97ba                	add	a5,a5,a4
    80001c5e:	f4bc                	sd	a5,104(s1)
}
    80001c60:	8526                	mv	a0,s1
    80001c62:	60e2                	ld	ra,24(sp)
    80001c64:	6442                	ld	s0,16(sp)
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	6902                	ld	s2,0(sp)
    80001c6a:	6105                	addi	sp,sp,32
    80001c6c:	8082                	ret
        release(&p->lock);
    80001c6e:	8526                	mv	a0,s1
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	042080e7          	jalr	66(ra) # 80000cb2 <release>
        return 0;
    80001c78:	84ca                	mv	s1,s2
    80001c7a:	b7dd                	j	80001c60 <allocproc+0x8c>
        freeproc(p);
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	efe080e7          	jalr	-258(ra) # 80001b7c <freeproc>
        release(&p->lock);
    80001c86:	8526                	mv	a0,s1
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	02a080e7          	jalr	42(ra) # 80000cb2 <release>
        return 0;
    80001c90:	84ca                	mv	s1,s2
    80001c92:	b7f9                	j	80001c60 <allocproc+0x8c>

0000000080001c94 <userinit>:
{
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	1000                	addi	s0,sp,32
    p = allocproc();
    80001c9e:	00000097          	auipc	ra,0x0
    80001ca2:	f36080e7          	jalr	-202(ra) # 80001bd4 <allocproc>
    80001ca6:	84aa                	mv	s1,a0
    initproc = p;
    80001ca8:	00007797          	auipc	a5,0x7
    80001cac:	36a7b823          	sd	a0,880(a5) # 80009018 <initproc>
    uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cb0:	03400613          	li	a2,52
    80001cb4:	00007597          	auipc	a1,0x7
    80001cb8:	c7c58593          	addi	a1,a1,-900 # 80008930 <initcode>
    80001cbc:	6928                	ld	a0,80(a0)
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	6f4080e7          	jalr	1780(ra) # 800013b2 <uvminit>
    p->sz = PGSIZE;
    80001cc6:	6785                	lui	a5,0x1
    80001cc8:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001cca:	6cb8                	ld	a4,88(s1)
    80001ccc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001cd0:	6cb8                	ld	a4,88(s1)
    80001cd2:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cd4:	4641                	li	a2,16
    80001cd6:	00006597          	auipc	a1,0x6
    80001cda:	51258593          	addi	a1,a1,1298 # 800081e8 <digits+0x1a8>
    80001cde:	15848513          	addi	a0,s1,344
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	16a080e7          	jalr	362(ra) # 80000e4c <safestrcpy>
    p->cwd = namei("/");
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	50e50513          	addi	a0,a0,1294 # 800081f8 <digits+0x1b8>
    80001cf2:	00002097          	auipc	ra,0x2
    80001cf6:	1ce080e7          	jalr	462(ra) # 80003ec0 <namei>
    80001cfa:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001cfe:	4789                	li	a5,2
    80001d00:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001d02:	8526                	mv	a0,s1
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	fae080e7          	jalr	-82(ra) # 80000cb2 <release>
}
    80001d0c:	60e2                	ld	ra,24(sp)
    80001d0e:	6442                	ld	s0,16(sp)
    80001d10:	64a2                	ld	s1,8(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret

0000000080001d16 <growproc>:
{
    80001d16:	1101                	addi	sp,sp,-32
    80001d18:	ec06                	sd	ra,24(sp)
    80001d1a:	e822                	sd	s0,16(sp)
    80001d1c:	e426                	sd	s1,8(sp)
    80001d1e:	e04a                	sd	s2,0(sp)
    80001d20:	1000                	addi	s0,sp,32
    80001d22:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	ca6080e7          	jalr	-858(ra) # 800019ca <myproc>
    80001d2c:	892a                	mv	s2,a0
    sz = p->sz;
    80001d2e:	652c                	ld	a1,72(a0)
    80001d30:	0005861b          	sext.w	a2,a1
    if (n > 0)
    80001d34:	00904f63          	bgtz	s1,80001d52 <growproc+0x3c>
    else if (n < 0)
    80001d38:	0204cc63          	bltz	s1,80001d70 <growproc+0x5a>
    p->sz = sz;
    80001d3c:	1602                	slli	a2,a2,0x20
    80001d3e:	9201                	srli	a2,a2,0x20
    80001d40:	04c93423          	sd	a2,72(s2)
    return 0;
    80001d44:	4501                	li	a0,0
}
    80001d46:	60e2                	ld	ra,24(sp)
    80001d48:	6442                	ld	s0,16(sp)
    80001d4a:	64a2                	ld	s1,8(sp)
    80001d4c:	6902                	ld	s2,0(sp)
    80001d4e:	6105                	addi	sp,sp,32
    80001d50:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    80001d52:	9e25                	addw	a2,a2,s1
    80001d54:	1602                	slli	a2,a2,0x20
    80001d56:	9201                	srli	a2,a2,0x20
    80001d58:	1582                	slli	a1,a1,0x20
    80001d5a:	9181                	srli	a1,a1,0x20
    80001d5c:	6928                	ld	a0,80(a0)
    80001d5e:	fffff097          	auipc	ra,0xfffff
    80001d62:	70e080e7          	jalr	1806(ra) # 8000146c <uvmalloc>
    80001d66:	0005061b          	sext.w	a2,a0
    80001d6a:	fa69                	bnez	a2,80001d3c <growproc+0x26>
            return -1;
    80001d6c:	557d                	li	a0,-1
    80001d6e:	bfe1                	j	80001d46 <growproc+0x30>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d70:	9e25                	addw	a2,a2,s1
    80001d72:	1602                	slli	a2,a2,0x20
    80001d74:	9201                	srli	a2,a2,0x20
    80001d76:	1582                	slli	a1,a1,0x20
    80001d78:	9181                	srli	a1,a1,0x20
    80001d7a:	6928                	ld	a0,80(a0)
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	6a8080e7          	jalr	1704(ra) # 80001424 <uvmdealloc>
    80001d84:	0005061b          	sext.w	a2,a0
    80001d88:	bf55                	j	80001d3c <growproc+0x26>

0000000080001d8a <fork>:
{
    80001d8a:	7139                	addi	sp,sp,-64
    80001d8c:	fc06                	sd	ra,56(sp)
    80001d8e:	f822                	sd	s0,48(sp)
    80001d90:	f426                	sd	s1,40(sp)
    80001d92:	f04a                	sd	s2,32(sp)
    80001d94:	ec4e                	sd	s3,24(sp)
    80001d96:	e852                	sd	s4,16(sp)
    80001d98:	e456                	sd	s5,8(sp)
    80001d9a:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001d9c:	00000097          	auipc	ra,0x0
    80001da0:	c2e080e7          	jalr	-978(ra) # 800019ca <myproc>
    80001da4:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	e2e080e7          	jalr	-466(ra) # 80001bd4 <allocproc>
    80001dae:	c17d                	beqz	a0,80001e94 <fork+0x10a>
    80001db0:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001db2:	048ab603          	ld	a2,72(s5)
    80001db6:	692c                	ld	a1,80(a0)
    80001db8:	050ab503          	ld	a0,80(s5)
    80001dbc:	fffff097          	auipc	ra,0xfffff
    80001dc0:	7fc080e7          	jalr	2044(ra) # 800015b8 <uvmcopy>
    80001dc4:	04054a63          	bltz	a0,80001e18 <fork+0x8e>
    np->sz = p->sz;
    80001dc8:	048ab783          	ld	a5,72(s5)
    80001dcc:	04fa3423          	sd	a5,72(s4)
    np->parent = p;
    80001dd0:	035a3023          	sd	s5,32(s4)
    *(np->trapframe) = *(p->trapframe);
    80001dd4:	058ab683          	ld	a3,88(s5)
    80001dd8:	87b6                	mv	a5,a3
    80001dda:	058a3703          	ld	a4,88(s4)
    80001dde:	12068693          	addi	a3,a3,288
    80001de2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001de6:	6788                	ld	a0,8(a5)
    80001de8:	6b8c                	ld	a1,16(a5)
    80001dea:	6f90                	ld	a2,24(a5)
    80001dec:	01073023          	sd	a6,0(a4)
    80001df0:	e708                	sd	a0,8(a4)
    80001df2:	eb0c                	sd	a1,16(a4)
    80001df4:	ef10                	sd	a2,24(a4)
    80001df6:	02078793          	addi	a5,a5,32
    80001dfa:	02070713          	addi	a4,a4,32
    80001dfe:	fed792e3          	bne	a5,a3,80001de2 <fork+0x58>
    np->trapframe->a0 = 0;
    80001e02:	058a3783          	ld	a5,88(s4)
    80001e06:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80001e0a:	0d0a8493          	addi	s1,s5,208
    80001e0e:	0d0a0913          	addi	s2,s4,208
    80001e12:	150a8993          	addi	s3,s5,336
    80001e16:	a00d                	j	80001e38 <fork+0xae>
        freeproc(np);
    80001e18:	8552                	mv	a0,s4
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	d62080e7          	jalr	-670(ra) # 80001b7c <freeproc>
        release(&np->lock);
    80001e22:	8552                	mv	a0,s4
    80001e24:	fffff097          	auipc	ra,0xfffff
    80001e28:	e8e080e7          	jalr	-370(ra) # 80000cb2 <release>
        return -1;
    80001e2c:	54fd                	li	s1,-1
    80001e2e:	a889                	j	80001e80 <fork+0xf6>
    for (i = 0; i < NOFILE; i++)
    80001e30:	04a1                	addi	s1,s1,8
    80001e32:	0921                	addi	s2,s2,8
    80001e34:	01348b63          	beq	s1,s3,80001e4a <fork+0xc0>
        if (p->ofile[i])
    80001e38:	6088                	ld	a0,0(s1)
    80001e3a:	d97d                	beqz	a0,80001e30 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80001e3c:	00003097          	auipc	ra,0x3
    80001e40:	8c8080e7          	jalr	-1848(ra) # 80004704 <filedup>
    80001e44:	00a93023          	sd	a0,0(s2)
    80001e48:	b7e5                	j	80001e30 <fork+0xa6>
    np->cwd = idup(p->cwd);
    80001e4a:	150ab503          	ld	a0,336(s5)
    80001e4e:	00001097          	auipc	ra,0x1
    80001e52:	768080e7          	jalr	1896(ra) # 800035b6 <idup>
    80001e56:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001e5a:	4641                	li	a2,16
    80001e5c:	158a8593          	addi	a1,s5,344
    80001e60:	158a0513          	addi	a0,s4,344
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	fe8080e7          	jalr	-24(ra) # 80000e4c <safestrcpy>
    pid = np->pid;
    80001e6c:	038a2483          	lw	s1,56(s4)
    np->state = RUNNABLE;
    80001e70:	4789                	li	a5,2
    80001e72:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80001e76:	8552                	mv	a0,s4
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	e3a080e7          	jalr	-454(ra) # 80000cb2 <release>
}
    80001e80:	8526                	mv	a0,s1
    80001e82:	70e2                	ld	ra,56(sp)
    80001e84:	7442                	ld	s0,48(sp)
    80001e86:	74a2                	ld	s1,40(sp)
    80001e88:	7902                	ld	s2,32(sp)
    80001e8a:	69e2                	ld	s3,24(sp)
    80001e8c:	6a42                	ld	s4,16(sp)
    80001e8e:	6aa2                	ld	s5,8(sp)
    80001e90:	6121                	addi	sp,sp,64
    80001e92:	8082                	ret
        return -1;
    80001e94:	54fd                	li	s1,-1
    80001e96:	b7ed                	j	80001e80 <fork+0xf6>

0000000080001e98 <reparent>:
{
    80001e98:	7179                	addi	sp,sp,-48
    80001e9a:	f406                	sd	ra,40(sp)
    80001e9c:	f022                	sd	s0,32(sp)
    80001e9e:	ec26                	sd	s1,24(sp)
    80001ea0:	e84a                	sd	s2,16(sp)
    80001ea2:	e44e                	sd	s3,8(sp)
    80001ea4:	e052                	sd	s4,0(sp)
    80001ea6:	1800                	addi	s0,sp,48
    80001ea8:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001eaa:	00010497          	auipc	s1,0x10
    80001eae:	ebe48493          	addi	s1,s1,-322 # 80011d68 <proc>
            pp->parent = initproc;
    80001eb2:	00007a17          	auipc	s4,0x7
    80001eb6:	166a0a13          	addi	s4,s4,358 # 80009018 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001eba:	00016997          	auipc	s3,0x16
    80001ebe:	8ae98993          	addi	s3,s3,-1874 # 80017768 <tickslock>
    80001ec2:	a029                	j	80001ecc <reparent+0x34>
    80001ec4:	16848493          	addi	s1,s1,360
    80001ec8:	03348363          	beq	s1,s3,80001eee <reparent+0x56>
        if (pp->parent == p)
    80001ecc:	709c                	ld	a5,32(s1)
    80001ece:	ff279be3          	bne	a5,s2,80001ec4 <reparent+0x2c>
            acquire(&pp->lock);
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	d2a080e7          	jalr	-726(ra) # 80000bfe <acquire>
            pp->parent = initproc;
    80001edc:	000a3783          	ld	a5,0(s4)
    80001ee0:	f09c                	sd	a5,32(s1)
            release(&pp->lock);
    80001ee2:	8526                	mv	a0,s1
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	dce080e7          	jalr	-562(ra) # 80000cb2 <release>
    80001eec:	bfe1                	j	80001ec4 <reparent+0x2c>
}
    80001eee:	70a2                	ld	ra,40(sp)
    80001ef0:	7402                	ld	s0,32(sp)
    80001ef2:	64e2                	ld	s1,24(sp)
    80001ef4:	6942                	ld	s2,16(sp)
    80001ef6:	69a2                	ld	s3,8(sp)
    80001ef8:	6a02                	ld	s4,0(sp)
    80001efa:	6145                	addi	sp,sp,48
    80001efc:	8082                	ret

0000000080001efe <scheduler>:
{
    80001efe:	715d                	addi	sp,sp,-80
    80001f00:	e486                	sd	ra,72(sp)
    80001f02:	e0a2                	sd	s0,64(sp)
    80001f04:	fc26                	sd	s1,56(sp)
    80001f06:	f84a                	sd	s2,48(sp)
    80001f08:	f44e                	sd	s3,40(sp)
    80001f0a:	f052                	sd	s4,32(sp)
    80001f0c:	ec56                	sd	s5,24(sp)
    80001f0e:	e85a                	sd	s6,16(sp)
    80001f10:	e45e                	sd	s7,8(sp)
    80001f12:	e062                	sd	s8,0(sp)
    80001f14:	0880                	addi	s0,sp,80
    80001f16:	8792                	mv	a5,tp
    int id = r_tp();
    80001f18:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001f1a:	00779b13          	slli	s6,a5,0x7
    80001f1e:	00010717          	auipc	a4,0x10
    80001f22:	a3270713          	addi	a4,a4,-1486 # 80011950 <pid_lock>
    80001f26:	975a                	add	a4,a4,s6
    80001f28:	00073c23          	sd	zero,24(a4)
                swtch(&c->context, &p->context);
    80001f2c:	00010717          	auipc	a4,0x10
    80001f30:	a4470713          	addi	a4,a4,-1468 # 80011970 <cpus+0x8>
    80001f34:	9b3a                	add	s6,s6,a4
                p->state = RUNNING;
    80001f36:	4c0d                	li	s8,3
                c->proc = p;
    80001f38:	079e                	slli	a5,a5,0x7
    80001f3a:	00010a17          	auipc	s4,0x10
    80001f3e:	a16a0a13          	addi	s4,s4,-1514 # 80011950 <pid_lock>
    80001f42:	9a3e                	add	s4,s4,a5
                found = 1;
    80001f44:	4b85                	li	s7,1
        for (p = proc; p < &proc[NPROC]; p++)
    80001f46:	00016997          	auipc	s3,0x16
    80001f4a:	82298993          	addi	s3,s3,-2014 # 80017768 <tickslock>
    80001f4e:	a899                	j	80001fa4 <scheduler+0xa6>
            release(&p->lock);
    80001f50:	8526                	mv	a0,s1
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	d60080e7          	jalr	-672(ra) # 80000cb2 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001f5a:	16848493          	addi	s1,s1,360
    80001f5e:	03348963          	beq	s1,s3,80001f90 <scheduler+0x92>
            acquire(&p->lock);
    80001f62:	8526                	mv	a0,s1
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	c9a080e7          	jalr	-870(ra) # 80000bfe <acquire>
            if (p->state == RUNNABLE)
    80001f6c:	4c9c                	lw	a5,24(s1)
    80001f6e:	ff2791e3          	bne	a5,s2,80001f50 <scheduler+0x52>
                p->state = RUNNING;
    80001f72:	0184ac23          	sw	s8,24(s1)
                c->proc = p;
    80001f76:	009a3c23          	sd	s1,24(s4)
                swtch(&c->context, &p->context);
    80001f7a:	06048593          	addi	a1,s1,96
    80001f7e:	855a                	mv	a0,s6
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	60e080e7          	jalr	1550(ra) # 8000258e <swtch>
                c->proc = 0;
    80001f88:	000a3c23          	sd	zero,24(s4)
                found = 1;
    80001f8c:	8ade                	mv	s5,s7
    80001f8e:	b7c9                	j	80001f50 <scheduler+0x52>
        if (found == 0)
    80001f90:	000a9a63          	bnez	s5,80001fa4 <scheduler+0xa6>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f94:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001f98:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001f9c:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    80001fa0:	10500073          	wfi
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001fa4:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001fa8:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001fac:	10079073          	csrw	sstatus,a5
        int found = 0;
    80001fb0:	4a81                	li	s5,0
        for (p = proc; p < &proc[NPROC]; p++)
    80001fb2:	00010497          	auipc	s1,0x10
    80001fb6:	db648493          	addi	s1,s1,-586 # 80011d68 <proc>
            if (p->state == RUNNABLE)
    80001fba:	4909                	li	s2,2
    80001fbc:	b75d                	j	80001f62 <scheduler+0x64>

0000000080001fbe <sched>:
{
    80001fbe:	7179                	addi	sp,sp,-48
    80001fc0:	f406                	sd	ra,40(sp)
    80001fc2:	f022                	sd	s0,32(sp)
    80001fc4:	ec26                	sd	s1,24(sp)
    80001fc6:	e84a                	sd	s2,16(sp)
    80001fc8:	e44e                	sd	s3,8(sp)
    80001fca:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	9fe080e7          	jalr	-1538(ra) # 800019ca <myproc>
    80001fd4:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	bae080e7          	jalr	-1106(ra) # 80000b84 <holding>
    80001fde:	c93d                	beqz	a0,80002054 <sched+0x96>
    asm volatile("mv %0, tp" : "=r"(x));
    80001fe0:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001fe2:	2781                	sext.w	a5,a5
    80001fe4:	079e                	slli	a5,a5,0x7
    80001fe6:	00010717          	auipc	a4,0x10
    80001fea:	96a70713          	addi	a4,a4,-1686 # 80011950 <pid_lock>
    80001fee:	97ba                	add	a5,a5,a4
    80001ff0:	0907a703          	lw	a4,144(a5)
    80001ff4:	4785                	li	a5,1
    80001ff6:	06f71763          	bne	a4,a5,80002064 <sched+0xa6>
    if (p->state == RUNNING)
    80001ffa:	4c98                	lw	a4,24(s1)
    80001ffc:	478d                	li	a5,3
    80001ffe:	06f70b63          	beq	a4,a5,80002074 <sched+0xb6>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002002:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80002006:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002008:	efb5                	bnez	a5,80002084 <sched+0xc6>
    asm volatile("mv %0, tp" : "=r"(x));
    8000200a:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    8000200c:	00010917          	auipc	s2,0x10
    80002010:	94490913          	addi	s2,s2,-1724 # 80011950 <pid_lock>
    80002014:	2781                	sext.w	a5,a5
    80002016:	079e                	slli	a5,a5,0x7
    80002018:	97ca                	add	a5,a5,s2
    8000201a:	0947a983          	lw	s3,148(a5)
    8000201e:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80002020:	2781                	sext.w	a5,a5
    80002022:	079e                	slli	a5,a5,0x7
    80002024:	00010597          	auipc	a1,0x10
    80002028:	94c58593          	addi	a1,a1,-1716 # 80011970 <cpus+0x8>
    8000202c:	95be                	add	a1,a1,a5
    8000202e:	06048513          	addi	a0,s1,96
    80002032:	00000097          	auipc	ra,0x0
    80002036:	55c080e7          	jalr	1372(ra) # 8000258e <swtch>
    8000203a:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000203c:	2781                	sext.w	a5,a5
    8000203e:	079e                	slli	a5,a5,0x7
    80002040:	97ca                	add	a5,a5,s2
    80002042:	0937aa23          	sw	s3,148(a5)
}
    80002046:	70a2                	ld	ra,40(sp)
    80002048:	7402                	ld	s0,32(sp)
    8000204a:	64e2                	ld	s1,24(sp)
    8000204c:	6942                	ld	s2,16(sp)
    8000204e:	69a2                	ld	s3,8(sp)
    80002050:	6145                	addi	sp,sp,48
    80002052:	8082                	ret
        panic("sched p->lock");
    80002054:	00006517          	auipc	a0,0x6
    80002058:	1ac50513          	addi	a0,a0,428 # 80008200 <digits+0x1c0>
    8000205c:	ffffe097          	auipc	ra,0xffffe
    80002060:	4e6080e7          	jalr	1254(ra) # 80000542 <panic>
        panic("sched locks");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	1ac50513          	addi	a0,a0,428 # 80008210 <digits+0x1d0>
    8000206c:	ffffe097          	auipc	ra,0xffffe
    80002070:	4d6080e7          	jalr	1238(ra) # 80000542 <panic>
        panic("sched running");
    80002074:	00006517          	auipc	a0,0x6
    80002078:	1ac50513          	addi	a0,a0,428 # 80008220 <digits+0x1e0>
    8000207c:	ffffe097          	auipc	ra,0xffffe
    80002080:	4c6080e7          	jalr	1222(ra) # 80000542 <panic>
        panic("sched interruptible");
    80002084:	00006517          	auipc	a0,0x6
    80002088:	1ac50513          	addi	a0,a0,428 # 80008230 <digits+0x1f0>
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	4b6080e7          	jalr	1206(ra) # 80000542 <panic>

0000000080002094 <exit>:
{
    80002094:	7179                	addi	sp,sp,-48
    80002096:	f406                	sd	ra,40(sp)
    80002098:	f022                	sd	s0,32(sp)
    8000209a:	ec26                	sd	s1,24(sp)
    8000209c:	e84a                	sd	s2,16(sp)
    8000209e:	e44e                	sd	s3,8(sp)
    800020a0:	e052                	sd	s4,0(sp)
    800020a2:	1800                	addi	s0,sp,48
    800020a4:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	924080e7          	jalr	-1756(ra) # 800019ca <myproc>
    800020ae:	89aa                	mv	s3,a0
    if (p == initproc)
    800020b0:	00007797          	auipc	a5,0x7
    800020b4:	f687b783          	ld	a5,-152(a5) # 80009018 <initproc>
    800020b8:	0d050493          	addi	s1,a0,208
    800020bc:	15050913          	addi	s2,a0,336
    800020c0:	02a79363          	bne	a5,a0,800020e6 <exit+0x52>
        panic("init exiting");
    800020c4:	00006517          	auipc	a0,0x6
    800020c8:	18450513          	addi	a0,a0,388 # 80008248 <digits+0x208>
    800020cc:	ffffe097          	auipc	ra,0xffffe
    800020d0:	476080e7          	jalr	1142(ra) # 80000542 <panic>
            fileclose(f);
    800020d4:	00002097          	auipc	ra,0x2
    800020d8:	682080e7          	jalr	1666(ra) # 80004756 <fileclose>
            p->ofile[fd] = 0;
    800020dc:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    800020e0:	04a1                	addi	s1,s1,8
    800020e2:	01248563          	beq	s1,s2,800020ec <exit+0x58>
        if (p->ofile[fd])
    800020e6:	6088                	ld	a0,0(s1)
    800020e8:	f575                	bnez	a0,800020d4 <exit+0x40>
    800020ea:	bfdd                	j	800020e0 <exit+0x4c>
    begin_op();
    800020ec:	00002097          	auipc	ra,0x2
    800020f0:	198080e7          	jalr	408(ra) # 80004284 <begin_op>
    iput(p->cwd);
    800020f4:	1509b503          	ld	a0,336(s3)
    800020f8:	00001097          	auipc	ra,0x1
    800020fc:	7cc080e7          	jalr	1996(ra) # 800038c4 <iput>
    end_op();
    80002100:	00002097          	auipc	ra,0x2
    80002104:	204080e7          	jalr	516(ra) # 80004304 <end_op>
    p->cwd = 0;
    80002108:	1409b823          	sd	zero,336(s3)
    acquire(&initproc->lock);
    8000210c:	00007497          	auipc	s1,0x7
    80002110:	f0c48493          	addi	s1,s1,-244 # 80009018 <initproc>
    80002114:	6088                	ld	a0,0(s1)
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	ae8080e7          	jalr	-1304(ra) # 80000bfe <acquire>
    wakeup1(initproc);
    8000211e:	6088                	ld	a0,0(s1)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	76a080e7          	jalr	1898(ra) # 8000188a <wakeup1>
    release(&initproc->lock);
    80002128:	6088                	ld	a0,0(s1)
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	b88080e7          	jalr	-1144(ra) # 80000cb2 <release>
    acquire(&p->lock);
    80002132:	854e                	mv	a0,s3
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	aca080e7          	jalr	-1334(ra) # 80000bfe <acquire>
    struct proc *original_parent = p->parent;
    8000213c:	0209b483          	ld	s1,32(s3)
    release(&p->lock);
    80002140:	854e                	mv	a0,s3
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	b70080e7          	jalr	-1168(ra) # 80000cb2 <release>
    acquire(&original_parent->lock);
    8000214a:	8526                	mv	a0,s1
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	ab2080e7          	jalr	-1358(ra) # 80000bfe <acquire>
    acquire(&p->lock);
    80002154:	854e                	mv	a0,s3
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	aa8080e7          	jalr	-1368(ra) # 80000bfe <acquire>
    reparent(p);
    8000215e:	854e                	mv	a0,s3
    80002160:	00000097          	auipc	ra,0x0
    80002164:	d38080e7          	jalr	-712(ra) # 80001e98 <reparent>
    wakeup1(original_parent);
    80002168:	8526                	mv	a0,s1
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	720080e7          	jalr	1824(ra) # 8000188a <wakeup1>
    p->xstate = status;
    80002172:	0349aa23          	sw	s4,52(s3)
    p->state = ZOMBIE;
    80002176:	4791                	li	a5,4
    80002178:	00f9ac23          	sw	a5,24(s3)
    release(&original_parent->lock);
    8000217c:	8526                	mv	a0,s1
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	b34080e7          	jalr	-1228(ra) # 80000cb2 <release>
    sched();
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	e38080e7          	jalr	-456(ra) # 80001fbe <sched>
    panic("zombie exit");
    8000218e:	00006517          	auipc	a0,0x6
    80002192:	0ca50513          	addi	a0,a0,202 # 80008258 <digits+0x218>
    80002196:	ffffe097          	auipc	ra,0xffffe
    8000219a:	3ac080e7          	jalr	940(ra) # 80000542 <panic>

000000008000219e <yield>:
{
    8000219e:	1101                	addi	sp,sp,-32
    800021a0:	ec06                	sd	ra,24(sp)
    800021a2:	e822                	sd	s0,16(sp)
    800021a4:	e426                	sd	s1,8(sp)
    800021a6:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	822080e7          	jalr	-2014(ra) # 800019ca <myproc>
    800021b0:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	a4c080e7          	jalr	-1460(ra) # 80000bfe <acquire>
    p->state = RUNNABLE;
    800021ba:	4789                	li	a5,2
    800021bc:	cc9c                	sw	a5,24(s1)
    sched();
    800021be:	00000097          	auipc	ra,0x0
    800021c2:	e00080e7          	jalr	-512(ra) # 80001fbe <sched>
    release(&p->lock);
    800021c6:	8526                	mv	a0,s1
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	aea080e7          	jalr	-1302(ra) # 80000cb2 <release>
}
    800021d0:	60e2                	ld	ra,24(sp)
    800021d2:	6442                	ld	s0,16(sp)
    800021d4:	64a2                	ld	s1,8(sp)
    800021d6:	6105                	addi	sp,sp,32
    800021d8:	8082                	ret

00000000800021da <sleep>:
{
    800021da:	7179                	addi	sp,sp,-48
    800021dc:	f406                	sd	ra,40(sp)
    800021de:	f022                	sd	s0,32(sp)
    800021e0:	ec26                	sd	s1,24(sp)
    800021e2:	e84a                	sd	s2,16(sp)
    800021e4:	e44e                	sd	s3,8(sp)
    800021e6:	1800                	addi	s0,sp,48
    800021e8:	89aa                	mv	s3,a0
    800021ea:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	7de080e7          	jalr	2014(ra) # 800019ca <myproc>
    800021f4:	84aa                	mv	s1,a0
    if (lk != &p->lock)
    800021f6:	05250663          	beq	a0,s2,80002242 <sleep+0x68>
        acquire(&p->lock); // DOC: sleeplock1
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	a04080e7          	jalr	-1532(ra) # 80000bfe <acquire>
        release(lk);
    80002202:	854a                	mv	a0,s2
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	aae080e7          	jalr	-1362(ra) # 80000cb2 <release>
    p->chan = chan;
    8000220c:	0334b423          	sd	s3,40(s1)
    p->state = SLEEPING;
    80002210:	4785                	li	a5,1
    80002212:	cc9c                	sw	a5,24(s1)
    sched();
    80002214:	00000097          	auipc	ra,0x0
    80002218:	daa080e7          	jalr	-598(ra) # 80001fbe <sched>
    p->chan = 0;
    8000221c:	0204b423          	sd	zero,40(s1)
        release(&p->lock);
    80002220:	8526                	mv	a0,s1
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	a90080e7          	jalr	-1392(ra) # 80000cb2 <release>
        acquire(lk);
    8000222a:	854a                	mv	a0,s2
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	9d2080e7          	jalr	-1582(ra) # 80000bfe <acquire>
}
    80002234:	70a2                	ld	ra,40(sp)
    80002236:	7402                	ld	s0,32(sp)
    80002238:	64e2                	ld	s1,24(sp)
    8000223a:	6942                	ld	s2,16(sp)
    8000223c:	69a2                	ld	s3,8(sp)
    8000223e:	6145                	addi	sp,sp,48
    80002240:	8082                	ret
    p->chan = chan;
    80002242:	03353423          	sd	s3,40(a0)
    p->state = SLEEPING;
    80002246:	4785                	li	a5,1
    80002248:	cd1c                	sw	a5,24(a0)
    sched();
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	d74080e7          	jalr	-652(ra) # 80001fbe <sched>
    p->chan = 0;
    80002252:	0204b423          	sd	zero,40(s1)
    if (lk != &p->lock)
    80002256:	bff9                	j	80002234 <sleep+0x5a>

0000000080002258 <wait>:
{
    80002258:	715d                	addi	sp,sp,-80
    8000225a:	e486                	sd	ra,72(sp)
    8000225c:	e0a2                	sd	s0,64(sp)
    8000225e:	fc26                	sd	s1,56(sp)
    80002260:	f84a                	sd	s2,48(sp)
    80002262:	f44e                	sd	s3,40(sp)
    80002264:	f052                	sd	s4,32(sp)
    80002266:	ec56                	sd	s5,24(sp)
    80002268:	e85a                	sd	s6,16(sp)
    8000226a:	e45e                	sd	s7,8(sp)
    8000226c:	0880                	addi	s0,sp,80
    8000226e:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	75a080e7          	jalr	1882(ra) # 800019ca <myproc>
    80002278:	892a                	mv	s2,a0
    acquire(&p->lock);
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	984080e7          	jalr	-1660(ra) # 80000bfe <acquire>
        havekids = 0;
    80002282:	4b81                	li	s7,0
                if (np->state == ZOMBIE)
    80002284:	4a11                	li	s4,4
                havekids = 1;
    80002286:	4a85                	li	s5,1
        for (np = proc; np < &proc[NPROC]; np++)
    80002288:	00015997          	auipc	s3,0x15
    8000228c:	4e098993          	addi	s3,s3,1248 # 80017768 <tickslock>
        havekids = 0;
    80002290:	875e                	mv	a4,s7
        for (np = proc; np < &proc[NPROC]; np++)
    80002292:	00010497          	auipc	s1,0x10
    80002296:	ad648493          	addi	s1,s1,-1322 # 80011d68 <proc>
    8000229a:	a08d                	j	800022fc <wait+0xa4>
                    pid = np->pid;
    8000229c:	0384a983          	lw	s3,56(s1)
                    if (addr != 0 &&
    800022a0:	000b0e63          	beqz	s6,800022bc <wait+0x64>
                        copyout(p->pagetable, addr, (char *)&np->xstate,
    800022a4:	4691                	li	a3,4
    800022a6:	03448613          	addi	a2,s1,52
    800022aa:	85da                	mv	a1,s6
    800022ac:	05093503          	ld	a0,80(s2)
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	40c080e7          	jalr	1036(ra) # 800016bc <copyout>
                    if (addr != 0 &&
    800022b8:	02054263          	bltz	a0,800022dc <wait+0x84>
                    freeproc(np);
    800022bc:	8526                	mv	a0,s1
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	8be080e7          	jalr	-1858(ra) # 80001b7c <freeproc>
                    release(&np->lock);
    800022c6:	8526                	mv	a0,s1
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	9ea080e7          	jalr	-1558(ra) # 80000cb2 <release>
                    release(&p->lock);
    800022d0:	854a                	mv	a0,s2
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	9e0080e7          	jalr	-1568(ra) # 80000cb2 <release>
                    return pid;
    800022da:	a8a9                	j	80002334 <wait+0xdc>
                        release(&np->lock);
    800022dc:	8526                	mv	a0,s1
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	9d4080e7          	jalr	-1580(ra) # 80000cb2 <release>
                        release(&p->lock);
    800022e6:	854a                	mv	a0,s2
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	9ca080e7          	jalr	-1590(ra) # 80000cb2 <release>
                        return -1;
    800022f0:	59fd                	li	s3,-1
    800022f2:	a089                	j	80002334 <wait+0xdc>
        for (np = proc; np < &proc[NPROC]; np++)
    800022f4:	16848493          	addi	s1,s1,360
    800022f8:	03348463          	beq	s1,s3,80002320 <wait+0xc8>
            if (np->parent == p)
    800022fc:	709c                	ld	a5,32(s1)
    800022fe:	ff279be3          	bne	a5,s2,800022f4 <wait+0x9c>
                acquire(&np->lock);
    80002302:	8526                	mv	a0,s1
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	8fa080e7          	jalr	-1798(ra) # 80000bfe <acquire>
                if (np->state == ZOMBIE)
    8000230c:	4c9c                	lw	a5,24(s1)
    8000230e:	f94787e3          	beq	a5,s4,8000229c <wait+0x44>
                release(&np->lock);
    80002312:	8526                	mv	a0,s1
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	99e080e7          	jalr	-1634(ra) # 80000cb2 <release>
                havekids = 1;
    8000231c:	8756                	mv	a4,s5
    8000231e:	bfd9                	j	800022f4 <wait+0x9c>
        if (!havekids || p->killed)
    80002320:	c701                	beqz	a4,80002328 <wait+0xd0>
    80002322:	03092783          	lw	a5,48(s2)
    80002326:	c39d                	beqz	a5,8000234c <wait+0xf4>
            release(&p->lock);
    80002328:	854a                	mv	a0,s2
    8000232a:	fffff097          	auipc	ra,0xfffff
    8000232e:	988080e7          	jalr	-1656(ra) # 80000cb2 <release>
            return -1;
    80002332:	59fd                	li	s3,-1
}
    80002334:	854e                	mv	a0,s3
    80002336:	60a6                	ld	ra,72(sp)
    80002338:	6406                	ld	s0,64(sp)
    8000233a:	74e2                	ld	s1,56(sp)
    8000233c:	7942                	ld	s2,48(sp)
    8000233e:	79a2                	ld	s3,40(sp)
    80002340:	7a02                	ld	s4,32(sp)
    80002342:	6ae2                	ld	s5,24(sp)
    80002344:	6b42                	ld	s6,16(sp)
    80002346:	6ba2                	ld	s7,8(sp)
    80002348:	6161                	addi	sp,sp,80
    8000234a:	8082                	ret
        sleep(p, &p->lock); // DOC: wait-sleep
    8000234c:	85ca                	mv	a1,s2
    8000234e:	854a                	mv	a0,s2
    80002350:	00000097          	auipc	ra,0x0
    80002354:	e8a080e7          	jalr	-374(ra) # 800021da <sleep>
        havekids = 0;
    80002358:	bf25                	j	80002290 <wait+0x38>

000000008000235a <wakeup>:
{
    8000235a:	7139                	addi	sp,sp,-64
    8000235c:	fc06                	sd	ra,56(sp)
    8000235e:	f822                	sd	s0,48(sp)
    80002360:	f426                	sd	s1,40(sp)
    80002362:	f04a                	sd	s2,32(sp)
    80002364:	ec4e                	sd	s3,24(sp)
    80002366:	e852                	sd	s4,16(sp)
    80002368:	e456                	sd	s5,8(sp)
    8000236a:	0080                	addi	s0,sp,64
    8000236c:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    8000236e:	00010497          	auipc	s1,0x10
    80002372:	9fa48493          	addi	s1,s1,-1542 # 80011d68 <proc>
        if (p->state == SLEEPING && p->chan == chan)
    80002376:	4985                	li	s3,1
            p->state = RUNNABLE;
    80002378:	4a89                	li	s5,2
    for (p = proc; p < &proc[NPROC]; p++)
    8000237a:	00015917          	auipc	s2,0x15
    8000237e:	3ee90913          	addi	s2,s2,1006 # 80017768 <tickslock>
    80002382:	a811                	j	80002396 <wakeup+0x3c>
        release(&p->lock);
    80002384:	8526                	mv	a0,s1
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	92c080e7          	jalr	-1748(ra) # 80000cb2 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000238e:	16848493          	addi	s1,s1,360
    80002392:	03248063          	beq	s1,s2,800023b2 <wakeup+0x58>
        acquire(&p->lock);
    80002396:	8526                	mv	a0,s1
    80002398:	fffff097          	auipc	ra,0xfffff
    8000239c:	866080e7          	jalr	-1946(ra) # 80000bfe <acquire>
        if (p->state == SLEEPING && p->chan == chan)
    800023a0:	4c9c                	lw	a5,24(s1)
    800023a2:	ff3791e3          	bne	a5,s3,80002384 <wakeup+0x2a>
    800023a6:	749c                	ld	a5,40(s1)
    800023a8:	fd479ee3          	bne	a5,s4,80002384 <wakeup+0x2a>
            p->state = RUNNABLE;
    800023ac:	0154ac23          	sw	s5,24(s1)
    800023b0:	bfd1                	j	80002384 <wakeup+0x2a>
}
    800023b2:	70e2                	ld	ra,56(sp)
    800023b4:	7442                	ld	s0,48(sp)
    800023b6:	74a2                	ld	s1,40(sp)
    800023b8:	7902                	ld	s2,32(sp)
    800023ba:	69e2                	ld	s3,24(sp)
    800023bc:	6a42                	ld	s4,16(sp)
    800023be:	6aa2                	ld	s5,8(sp)
    800023c0:	6121                	addi	sp,sp,64
    800023c2:	8082                	ret

00000000800023c4 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800023c4:	7179                	addi	sp,sp,-48
    800023c6:	f406                	sd	ra,40(sp)
    800023c8:	f022                	sd	s0,32(sp)
    800023ca:	ec26                	sd	s1,24(sp)
    800023cc:	e84a                	sd	s2,16(sp)
    800023ce:	e44e                	sd	s3,8(sp)
    800023d0:	1800                	addi	s0,sp,48
    800023d2:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800023d4:	00010497          	auipc	s1,0x10
    800023d8:	99448493          	addi	s1,s1,-1644 # 80011d68 <proc>
    800023dc:	00015997          	auipc	s3,0x15
    800023e0:	38c98993          	addi	s3,s3,908 # 80017768 <tickslock>
    {
        acquire(&p->lock);
    800023e4:	8526                	mv	a0,s1
    800023e6:	fffff097          	auipc	ra,0xfffff
    800023ea:	818080e7          	jalr	-2024(ra) # 80000bfe <acquire>
        if (p->pid == pid)
    800023ee:	5c9c                	lw	a5,56(s1)
    800023f0:	01278d63          	beq	a5,s2,8000240a <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800023f4:	8526                	mv	a0,s1
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	8bc080e7          	jalr	-1860(ra) # 80000cb2 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800023fe:	16848493          	addi	s1,s1,360
    80002402:	ff3491e3          	bne	s1,s3,800023e4 <kill+0x20>
    }
    return -1;
    80002406:	557d                	li	a0,-1
    80002408:	a821                	j	80002420 <kill+0x5c>
            p->killed = 1;
    8000240a:	4785                	li	a5,1
    8000240c:	d89c                	sw	a5,48(s1)
            if (p->state == SLEEPING)
    8000240e:	4c98                	lw	a4,24(s1)
    80002410:	00f70f63          	beq	a4,a5,8000242e <kill+0x6a>
            release(&p->lock);
    80002414:	8526                	mv	a0,s1
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	89c080e7          	jalr	-1892(ra) # 80000cb2 <release>
            return 0;
    8000241e:	4501                	li	a0,0
}
    80002420:	70a2                	ld	ra,40(sp)
    80002422:	7402                	ld	s0,32(sp)
    80002424:	64e2                	ld	s1,24(sp)
    80002426:	6942                	ld	s2,16(sp)
    80002428:	69a2                	ld	s3,8(sp)
    8000242a:	6145                	addi	sp,sp,48
    8000242c:	8082                	ret
                p->state = RUNNABLE;
    8000242e:	4789                	li	a5,2
    80002430:	cc9c                	sw	a5,24(s1)
    80002432:	b7cd                	j	80002414 <kill+0x50>

0000000080002434 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	e052                	sd	s4,0(sp)
    80002442:	1800                	addi	s0,sp,48
    80002444:	84aa                	mv	s1,a0
    80002446:	892e                	mv	s2,a1
    80002448:	89b2                	mv	s3,a2
    8000244a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	57e080e7          	jalr	1406(ra) # 800019ca <myproc>
    if (user_dst)
    80002454:	c08d                	beqz	s1,80002476 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002456:	86d2                	mv	a3,s4
    80002458:	864e                	mv	a2,s3
    8000245a:	85ca                	mv	a1,s2
    8000245c:	6928                	ld	a0,80(a0)
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	25e080e7          	jalr	606(ra) # 800016bc <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002466:	70a2                	ld	ra,40(sp)
    80002468:	7402                	ld	s0,32(sp)
    8000246a:	64e2                	ld	s1,24(sp)
    8000246c:	6942                	ld	s2,16(sp)
    8000246e:	69a2                	ld	s3,8(sp)
    80002470:	6a02                	ld	s4,0(sp)
    80002472:	6145                	addi	sp,sp,48
    80002474:	8082                	ret
        memmove((char *)dst, src, len);
    80002476:	000a061b          	sext.w	a2,s4
    8000247a:	85ce                	mv	a1,s3
    8000247c:	854a                	mv	a0,s2
    8000247e:	fffff097          	auipc	ra,0xfffff
    80002482:	8d8080e7          	jalr	-1832(ra) # 80000d56 <memmove>
        return 0;
    80002486:	8526                	mv	a0,s1
    80002488:	bff9                	j	80002466 <either_copyout+0x32>

000000008000248a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000248a:	7179                	addi	sp,sp,-48
    8000248c:	f406                	sd	ra,40(sp)
    8000248e:	f022                	sd	s0,32(sp)
    80002490:	ec26                	sd	s1,24(sp)
    80002492:	e84a                	sd	s2,16(sp)
    80002494:	e44e                	sd	s3,8(sp)
    80002496:	e052                	sd	s4,0(sp)
    80002498:	1800                	addi	s0,sp,48
    8000249a:	892a                	mv	s2,a0
    8000249c:	84ae                	mv	s1,a1
    8000249e:	89b2                	mv	s3,a2
    800024a0:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800024a2:	fffff097          	auipc	ra,0xfffff
    800024a6:	528080e7          	jalr	1320(ra) # 800019ca <myproc>
    if (user_src)
    800024aa:	c08d                	beqz	s1,800024cc <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800024ac:	86d2                	mv	a3,s4
    800024ae:	864e                	mv	a2,s3
    800024b0:	85ca                	mv	a1,s2
    800024b2:	6928                	ld	a0,80(a0)
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	294080e7          	jalr	660(ra) # 80001748 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800024bc:	70a2                	ld	ra,40(sp)
    800024be:	7402                	ld	s0,32(sp)
    800024c0:	64e2                	ld	s1,24(sp)
    800024c2:	6942                	ld	s2,16(sp)
    800024c4:	69a2                	ld	s3,8(sp)
    800024c6:	6a02                	ld	s4,0(sp)
    800024c8:	6145                	addi	sp,sp,48
    800024ca:	8082                	ret
        memmove(dst, (char *)src, len);
    800024cc:	000a061b          	sext.w	a2,s4
    800024d0:	85ce                	mv	a1,s3
    800024d2:	854a                	mv	a0,s2
    800024d4:	fffff097          	auipc	ra,0xfffff
    800024d8:	882080e7          	jalr	-1918(ra) # 80000d56 <memmove>
        return 0;
    800024dc:	8526                	mv	a0,s1
    800024de:	bff9                	j	800024bc <either_copyin+0x32>

00000000800024e0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800024e0:	715d                	addi	sp,sp,-80
    800024e2:	e486                	sd	ra,72(sp)
    800024e4:	e0a2                	sd	s0,64(sp)
    800024e6:	fc26                	sd	s1,56(sp)
    800024e8:	f84a                	sd	s2,48(sp)
    800024ea:	f44e                	sd	s3,40(sp)
    800024ec:	f052                	sd	s4,32(sp)
    800024ee:	ec56                	sd	s5,24(sp)
    800024f0:	e85a                	sd	s6,16(sp)
    800024f2:	e45e                	sd	s7,8(sp)
    800024f4:	0880                	addi	s0,sp,80
                             [RUNNING] "run   ",
                             [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800024f6:	00006517          	auipc	a0,0x6
    800024fa:	bd250513          	addi	a0,a0,-1070 # 800080c8 <digits+0x88>
    800024fe:	ffffe097          	auipc	ra,0xffffe
    80002502:	08e080e7          	jalr	142(ra) # 8000058c <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002506:	00010497          	auipc	s1,0x10
    8000250a:	9ba48493          	addi	s1,s1,-1606 # 80011ec0 <proc+0x158>
    8000250e:	00015917          	auipc	s2,0x15
    80002512:	3b290913          	addi	s2,s2,946 # 800178c0 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002516:	4b11                	li	s6,4
            state = states[p->state];
        else
            state = "???";
    80002518:	00006997          	auipc	s3,0x6
    8000251c:	d5098993          	addi	s3,s3,-688 # 80008268 <digits+0x228>
        printf("%d %s %s", p->pid, state, p->name);
    80002520:	00006a97          	auipc	s5,0x6
    80002524:	d50a8a93          	addi	s5,s5,-688 # 80008270 <digits+0x230>
        printf("\n");
    80002528:	00006a17          	auipc	s4,0x6
    8000252c:	ba0a0a13          	addi	s4,s4,-1120 # 800080c8 <digits+0x88>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002530:	00006b97          	auipc	s7,0x6
    80002534:	d78b8b93          	addi	s7,s7,-648 # 800082a8 <states.0>
    80002538:	a00d                	j	8000255a <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    8000253a:	ee06a583          	lw	a1,-288(a3)
    8000253e:	8556                	mv	a0,s5
    80002540:	ffffe097          	auipc	ra,0xffffe
    80002544:	04c080e7          	jalr	76(ra) # 8000058c <printf>
        printf("\n");
    80002548:	8552                	mv	a0,s4
    8000254a:	ffffe097          	auipc	ra,0xffffe
    8000254e:	042080e7          	jalr	66(ra) # 8000058c <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002552:	16848493          	addi	s1,s1,360
    80002556:	03248163          	beq	s1,s2,80002578 <procdump+0x98>
        if (p->state == UNUSED)
    8000255a:	86a6                	mv	a3,s1
    8000255c:	ec04a783          	lw	a5,-320(s1)
    80002560:	dbed                	beqz	a5,80002552 <procdump+0x72>
            state = "???";
    80002562:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002564:	fcfb6be3          	bltu	s6,a5,8000253a <procdump+0x5a>
    80002568:	1782                	slli	a5,a5,0x20
    8000256a:	9381                	srli	a5,a5,0x20
    8000256c:	078e                	slli	a5,a5,0x3
    8000256e:	97de                	add	a5,a5,s7
    80002570:	6390                	ld	a2,0(a5)
    80002572:	f661                	bnez	a2,8000253a <procdump+0x5a>
            state = "???";
    80002574:	864e                	mv	a2,s3
    80002576:	b7d1                	j	8000253a <procdump+0x5a>
    }
}
    80002578:	60a6                	ld	ra,72(sp)
    8000257a:	6406                	ld	s0,64(sp)
    8000257c:	74e2                	ld	s1,56(sp)
    8000257e:	7942                	ld	s2,48(sp)
    80002580:	79a2                	ld	s3,40(sp)
    80002582:	7a02                	ld	s4,32(sp)
    80002584:	6ae2                	ld	s5,24(sp)
    80002586:	6b42                	ld	s6,16(sp)
    80002588:	6ba2                	ld	s7,8(sp)
    8000258a:	6161                	addi	sp,sp,80
    8000258c:	8082                	ret

000000008000258e <swtch>:
    8000258e:	00153023          	sd	ra,0(a0)
    80002592:	00253423          	sd	sp,8(a0)
    80002596:	e900                	sd	s0,16(a0)
    80002598:	ed04                	sd	s1,24(a0)
    8000259a:	03253023          	sd	s2,32(a0)
    8000259e:	03353423          	sd	s3,40(a0)
    800025a2:	03453823          	sd	s4,48(a0)
    800025a6:	03553c23          	sd	s5,56(a0)
    800025aa:	05653023          	sd	s6,64(a0)
    800025ae:	05753423          	sd	s7,72(a0)
    800025b2:	05853823          	sd	s8,80(a0)
    800025b6:	05953c23          	sd	s9,88(a0)
    800025ba:	07a53023          	sd	s10,96(a0)
    800025be:	07b53423          	sd	s11,104(a0)
    800025c2:	0005b083          	ld	ra,0(a1)
    800025c6:	0085b103          	ld	sp,8(a1)
    800025ca:	6980                	ld	s0,16(a1)
    800025cc:	6d84                	ld	s1,24(a1)
    800025ce:	0205b903          	ld	s2,32(a1)
    800025d2:	0285b983          	ld	s3,40(a1)
    800025d6:	0305ba03          	ld	s4,48(a1)
    800025da:	0385ba83          	ld	s5,56(a1)
    800025de:	0405bb03          	ld	s6,64(a1)
    800025e2:	0485bb83          	ld	s7,72(a1)
    800025e6:	0505bc03          	ld	s8,80(a1)
    800025ea:	0585bc83          	ld	s9,88(a1)
    800025ee:	0605bd03          	ld	s10,96(a1)
    800025f2:	0685bd83          	ld	s11,104(a1)
    800025f6:	8082                	ret

00000000800025f8 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    800025f8:	1141                	addi	sp,sp,-16
    800025fa:	e406                	sd	ra,8(sp)
    800025fc:	e022                	sd	s0,0(sp)
    800025fe:	0800                	addi	s0,sp,16
    80002600:	00006597          	auipc	a1,0x6
    80002604:	cd058593          	addi	a1,a1,-816 # 800082d0 <states.0+0x28>
    80002608:	00015517          	auipc	a0,0x15
    8000260c:	16050513          	addi	a0,a0,352 # 80017768 <tickslock>
    80002610:	ffffe097          	auipc	ra,0xffffe
    80002614:	55e080e7          	jalr	1374(ra) # 80000b6e <initlock>
    80002618:	60a2                	ld	ra,8(sp)
    8000261a:	6402                	ld	s0,0(sp)
    8000261c:	0141                	addi	sp,sp,16
    8000261e:	8082                	ret

0000000080002620 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002620:	1141                	addi	sp,sp,-16
    80002622:	e422                	sd	s0,8(sp)
    80002624:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002626:	00004797          	auipc	a5,0x4
    8000262a:	aca78793          	addi	a5,a5,-1334 # 800060f0 <kernelvec>
    8000262e:	10579073          	csrw	stvec,a5
    80002632:	6422                	ld	s0,8(sp)
    80002634:	0141                	addi	sp,sp,16
    80002636:	8082                	ret

0000000080002638 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002638:	1141                	addi	sp,sp,-16
    8000263a:	e406                	sd	ra,8(sp)
    8000263c:	e022                	sd	s0,0(sp)
    8000263e:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002640:	fffff097          	auipc	ra,0xfffff
    80002644:	38a080e7          	jalr	906(ra) # 800019ca <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002648:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    8000264c:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    8000264e:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to trampoline.S
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002652:	00005617          	auipc	a2,0x5
    80002656:	9ae60613          	addi	a2,a2,-1618 # 80007000 <_trampoline>
    8000265a:	00005697          	auipc	a3,0x5
    8000265e:	9a668693          	addi	a3,a3,-1626 # 80007000 <_trampoline>
    80002662:	8e91                	sub	a3,a3,a2
    80002664:	040007b7          	lui	a5,0x4000
    80002668:	17fd                	addi	a5,a5,-1
    8000266a:	07b2                	slli	a5,a5,0xc
    8000266c:	96be                	add	a3,a3,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    8000266e:	10569073          	csrw	stvec,a3

    // set up trapframe values that uservec will need when
    // the process next re-enters the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002672:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80002674:	180026f3          	csrr	a3,satp
    80002678:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000267a:	6d38                	ld	a4,88(a0)
    8000267c:	6134                	ld	a3,64(a0)
    8000267e:	6585                	lui	a1,0x1
    80002680:	96ae                	add	a3,a3,a1
    80002682:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002684:	6d38                	ld	a4,88(a0)
    80002686:	00000697          	auipc	a3,0x0
    8000268a:	13868693          	addi	a3,a3,312 # 800027be <usertrap>
    8000268e:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002690:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80002692:	8692                	mv	a3,tp
    80002694:	f314                	sd	a3,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002696:	100026f3          	csrr	a3,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000269a:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000269e:	0206e693          	ori	a3,a3,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800026a2:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    800026a6:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    800026a8:	6f18                	ld	a4,24(a4)
    800026aa:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    800026ae:	692c                	ld	a1,80(a0)
    800026b0:	81b1                	srli	a1,a1,0xc

    // jump to trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026b2:	00005717          	auipc	a4,0x5
    800026b6:	9de70713          	addi	a4,a4,-1570 # 80007090 <userret>
    800026ba:	8f11                	sub	a4,a4,a2
    800026bc:	97ba                	add	a5,a5,a4
    ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    800026be:	577d                	li	a4,-1
    800026c0:	177e                	slli	a4,a4,0x3f
    800026c2:	8dd9                	or	a1,a1,a4
    800026c4:	02000537          	lui	a0,0x2000
    800026c8:	157d                	addi	a0,a0,-1
    800026ca:	0536                	slli	a0,a0,0xd
    800026cc:	9782                	jalr	a5
}
    800026ce:	60a2                	ld	ra,8(sp)
    800026d0:	6402                	ld	s0,0(sp)
    800026d2:	0141                	addi	sp,sp,16
    800026d4:	8082                	ret

00000000800026d6 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    800026d6:	1101                	addi	sp,sp,-32
    800026d8:	ec06                	sd	ra,24(sp)
    800026da:	e822                	sd	s0,16(sp)
    800026dc:	e426                	sd	s1,8(sp)
    800026de:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    800026e0:	00015497          	auipc	s1,0x15
    800026e4:	08848493          	addi	s1,s1,136 # 80017768 <tickslock>
    800026e8:	8526                	mv	a0,s1
    800026ea:	ffffe097          	auipc	ra,0xffffe
    800026ee:	514080e7          	jalr	1300(ra) # 80000bfe <acquire>
    ticks++;
    800026f2:	00007517          	auipc	a0,0x7
    800026f6:	92e50513          	addi	a0,a0,-1746 # 80009020 <ticks>
    800026fa:	411c                	lw	a5,0(a0)
    800026fc:	2785                	addiw	a5,a5,1
    800026fe:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002700:	00000097          	auipc	ra,0x0
    80002704:	c5a080e7          	jalr	-934(ra) # 8000235a <wakeup>
    release(&tickslock);
    80002708:	8526                	mv	a0,s1
    8000270a:	ffffe097          	auipc	ra,0xffffe
    8000270e:	5a8080e7          	jalr	1448(ra) # 80000cb2 <release>
}
    80002712:	60e2                	ld	ra,24(sp)
    80002714:	6442                	ld	s0,16(sp)
    80002716:	64a2                	ld	s1,8(sp)
    80002718:	6105                	addi	sp,sp,32
    8000271a:	8082                	ret

000000008000271c <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    8000271c:	1101                	addi	sp,sp,-32
    8000271e:	ec06                	sd	ra,24(sp)
    80002720:	e822                	sd	s0,16(sp)
    80002722:	e426                	sd	s1,8(sp)
    80002724:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, scause" : "=r"(x));
    80002726:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9)
    8000272a:	00074d63          	bltz	a4,80002744 <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L)
    8000272e:	57fd                	li	a5,-1
    80002730:	17fe                	slli	a5,a5,0x3f
    80002732:	0785                	addi	a5,a5,1

        return 2;
    }
    else
    {
        return 0;
    80002734:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002736:	06f70363          	beq	a4,a5,8000279c <devintr+0x80>
    }
}
    8000273a:	60e2                	ld	ra,24(sp)
    8000273c:	6442                	ld	s0,16(sp)
    8000273e:	64a2                	ld	s1,8(sp)
    80002740:	6105                	addi	sp,sp,32
    80002742:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9)
    80002744:	0ff77793          	andi	a5,a4,255
    80002748:	46a5                	li	a3,9
    8000274a:	fed792e3          	bne	a5,a3,8000272e <devintr+0x12>
        int irq = plic_claim();
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	aaa080e7          	jalr	-1366(ra) # 800061f8 <plic_claim>
    80002756:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002758:	47a9                	li	a5,10
    8000275a:	02f50763          	beq	a0,a5,80002788 <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ)
    8000275e:	4785                	li	a5,1
    80002760:	02f50963          	beq	a0,a5,80002792 <devintr+0x76>
        return 1;
    80002764:	4505                	li	a0,1
        else if (irq)
    80002766:	d8f1                	beqz	s1,8000273a <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80002768:	85a6                	mv	a1,s1
    8000276a:	00006517          	auipc	a0,0x6
    8000276e:	b6e50513          	addi	a0,a0,-1170 # 800082d8 <states.0+0x30>
    80002772:	ffffe097          	auipc	ra,0xffffe
    80002776:	e1a080e7          	jalr	-486(ra) # 8000058c <printf>
            plic_complete(irq);
    8000277a:	8526                	mv	a0,s1
    8000277c:	00004097          	auipc	ra,0x4
    80002780:	aa0080e7          	jalr	-1376(ra) # 8000621c <plic_complete>
        return 1;
    80002784:	4505                	li	a0,1
    80002786:	bf55                	j	8000273a <devintr+0x1e>
            uartintr();
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	23a080e7          	jalr	570(ra) # 800009c2 <uartintr>
    80002790:	b7ed                	j	8000277a <devintr+0x5e>
            virtio_disk_intr();
    80002792:	00004097          	auipc	ra,0x4
    80002796:	f04080e7          	jalr	-252(ra) # 80006696 <virtio_disk_intr>
    8000279a:	b7c5                	j	8000277a <devintr+0x5e>
        if (cpuid() == 0)
    8000279c:	fffff097          	auipc	ra,0xfffff
    800027a0:	202080e7          	jalr	514(ra) # 8000199e <cpuid>
    800027a4:	c901                	beqz	a0,800027b4 <devintr+0x98>
    asm volatile("csrr %0, sip" : "=r"(x));
    800027a6:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    800027aa:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    800027ac:	14479073          	csrw	sip,a5
        return 2;
    800027b0:	4509                	li	a0,2
    800027b2:	b761                	j	8000273a <devintr+0x1e>
            clockintr();
    800027b4:	00000097          	auipc	ra,0x0
    800027b8:	f22080e7          	jalr	-222(ra) # 800026d6 <clockintr>
    800027bc:	b7ed                	j	800027a6 <devintr+0x8a>

00000000800027be <usertrap>:
{
    800027be:	1101                	addi	sp,sp,-32
    800027c0:	ec06                	sd	ra,24(sp)
    800027c2:	e822                	sd	s0,16(sp)
    800027c4:	e426                	sd	s1,8(sp)
    800027c6:	e04a                	sd	s2,0(sp)
    800027c8:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800027ca:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    800027ce:	1007f793          	andi	a5,a5,256
    800027d2:	e3ad                	bnez	a5,80002834 <usertrap+0x76>
    asm volatile("csrw stvec, %0" : : "r"(x));
    800027d4:	00004797          	auipc	a5,0x4
    800027d8:	91c78793          	addi	a5,a5,-1764 # 800060f0 <kernelvec>
    800027dc:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    800027e0:	fffff097          	auipc	ra,0xfffff
    800027e4:	1ea080e7          	jalr	490(ra) # 800019ca <myproc>
    800027e8:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    800027ea:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    800027ec:	14102773          	csrr	a4,sepc
    800027f0:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    800027f2:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    800027f6:	47a1                	li	a5,8
    800027f8:	04f71c63          	bne	a4,a5,80002850 <usertrap+0x92>
        if (p->killed)
    800027fc:	591c                	lw	a5,48(a0)
    800027fe:	e3b9                	bnez	a5,80002844 <usertrap+0x86>
        p->trapframe->epc += 4;
    80002800:	6cb8                	ld	a4,88(s1)
    80002802:	6f1c                	ld	a5,24(a4)
    80002804:	0791                	addi	a5,a5,4
    80002806:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002808:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000280c:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002810:	10079073          	csrw	sstatus,a5
        syscall();
    80002814:	00000097          	auipc	ra,0x0
    80002818:	2e0080e7          	jalr	736(ra) # 80002af4 <syscall>
    if (p->killed)
    8000281c:	589c                	lw	a5,48(s1)
    8000281e:	ebc1                	bnez	a5,800028ae <usertrap+0xf0>
    usertrapret();
    80002820:	00000097          	auipc	ra,0x0
    80002824:	e18080e7          	jalr	-488(ra) # 80002638 <usertrapret>
}
    80002828:	60e2                	ld	ra,24(sp)
    8000282a:	6442                	ld	s0,16(sp)
    8000282c:	64a2                	ld	s1,8(sp)
    8000282e:	6902                	ld	s2,0(sp)
    80002830:	6105                	addi	sp,sp,32
    80002832:	8082                	ret
        panic("usertrap: not from user mode");
    80002834:	00006517          	auipc	a0,0x6
    80002838:	ac450513          	addi	a0,a0,-1340 # 800082f8 <states.0+0x50>
    8000283c:	ffffe097          	auipc	ra,0xffffe
    80002840:	d06080e7          	jalr	-762(ra) # 80000542 <panic>
            exit(-1);
    80002844:	557d                	li	a0,-1
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	84e080e7          	jalr	-1970(ra) # 80002094 <exit>
    8000284e:	bf4d                	j	80002800 <usertrap+0x42>
    else if ((which_dev = devintr()) != 0)
    80002850:	00000097          	auipc	ra,0x0
    80002854:	ecc080e7          	jalr	-308(ra) # 8000271c <devintr>
    80002858:	892a                	mv	s2,a0
    8000285a:	c501                	beqz	a0,80002862 <usertrap+0xa4>
    if (p->killed)
    8000285c:	589c                	lw	a5,48(s1)
    8000285e:	c3a1                	beqz	a5,8000289e <usertrap+0xe0>
    80002860:	a815                	j	80002894 <usertrap+0xd6>
    asm volatile("csrr %0, scause" : "=r"(x));
    80002862:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002866:	5c90                	lw	a2,56(s1)
    80002868:	00006517          	auipc	a0,0x6
    8000286c:	ab050513          	addi	a0,a0,-1360 # 80008318 <states.0+0x70>
    80002870:	ffffe097          	auipc	ra,0xffffe
    80002874:	d1c080e7          	jalr	-740(ra) # 8000058c <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002878:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    8000287c:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002880:	00006517          	auipc	a0,0x6
    80002884:	ac850513          	addi	a0,a0,-1336 # 80008348 <states.0+0xa0>
    80002888:	ffffe097          	auipc	ra,0xffffe
    8000288c:	d04080e7          	jalr	-764(ra) # 8000058c <printf>
        p->killed = 1;
    80002890:	4785                	li	a5,1
    80002892:	d89c                	sw	a5,48(s1)
        exit(-1);
    80002894:	557d                	li	a0,-1
    80002896:	fffff097          	auipc	ra,0xfffff
    8000289a:	7fe080e7          	jalr	2046(ra) # 80002094 <exit>
    if (which_dev == 2)
    8000289e:	4789                	li	a5,2
    800028a0:	f8f910e3          	bne	s2,a5,80002820 <usertrap+0x62>
        yield();
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	8fa080e7          	jalr	-1798(ra) # 8000219e <yield>
    800028ac:	bf95                	j	80002820 <usertrap+0x62>
    int which_dev = 0;
    800028ae:	4901                	li	s2,0
    800028b0:	b7d5                	j	80002894 <usertrap+0xd6>

00000000800028b2 <kerneltrap>:
{
    800028b2:	7179                	addi	sp,sp,-48
    800028b4:	f406                	sd	ra,40(sp)
    800028b6:	f022                	sd	s0,32(sp)
    800028b8:	ec26                	sd	s1,24(sp)
    800028ba:	e84a                	sd	s2,16(sp)
    800028bc:	e44e                	sd	s3,8(sp)
    800028be:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    800028c0:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800028c4:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    800028c8:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    800028cc:	1004f793          	andi	a5,s1,256
    800028d0:	cb85                	beqz	a5,80002900 <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800028d2:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    800028d6:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    800028d8:	ef85                	bnez	a5,80002910 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    800028da:	00000097          	auipc	ra,0x0
    800028de:	e42080e7          	jalr	-446(ra) # 8000271c <devintr>
    800028e2:	cd1d                	beqz	a0,80002920 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028e4:	4789                	li	a5,2
    800028e6:	06f50a63          	beq	a0,a5,8000295a <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    800028ea:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800028ee:	10049073          	csrw	sstatus,s1
}
    800028f2:	70a2                	ld	ra,40(sp)
    800028f4:	7402                	ld	s0,32(sp)
    800028f6:	64e2                	ld	s1,24(sp)
    800028f8:	6942                	ld	s2,16(sp)
    800028fa:	69a2                	ld	s3,8(sp)
    800028fc:	6145                	addi	sp,sp,48
    800028fe:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002900:	00006517          	auipc	a0,0x6
    80002904:	a6850513          	addi	a0,a0,-1432 # 80008368 <states.0+0xc0>
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	c3a080e7          	jalr	-966(ra) # 80000542 <panic>
        panic("kerneltrap: interrupts enabled");
    80002910:	00006517          	auipc	a0,0x6
    80002914:	a8050513          	addi	a0,a0,-1408 # 80008390 <states.0+0xe8>
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	c2a080e7          	jalr	-982(ra) # 80000542 <panic>
        printf("scause %p\n", scause);
    80002920:	85ce                	mv	a1,s3
    80002922:	00006517          	auipc	a0,0x6
    80002926:	a8e50513          	addi	a0,a0,-1394 # 800083b0 <states.0+0x108>
    8000292a:	ffffe097          	auipc	ra,0xffffe
    8000292e:	c62080e7          	jalr	-926(ra) # 8000058c <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002932:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80002936:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	a8650513          	addi	a0,a0,-1402 # 800083c0 <states.0+0x118>
    80002942:	ffffe097          	auipc	ra,0xffffe
    80002946:	c4a080e7          	jalr	-950(ra) # 8000058c <printf>
        panic("kerneltrap");
    8000294a:	00006517          	auipc	a0,0x6
    8000294e:	a8e50513          	addi	a0,a0,-1394 # 800083d8 <states.0+0x130>
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	bf0080e7          	jalr	-1040(ra) # 80000542 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000295a:	fffff097          	auipc	ra,0xfffff
    8000295e:	070080e7          	jalr	112(ra) # 800019ca <myproc>
    80002962:	d541                	beqz	a0,800028ea <kerneltrap+0x38>
    80002964:	fffff097          	auipc	ra,0xfffff
    80002968:	066080e7          	jalr	102(ra) # 800019ca <myproc>
    8000296c:	4d18                	lw	a4,24(a0)
    8000296e:	478d                	li	a5,3
    80002970:	f6f71de3          	bne	a4,a5,800028ea <kerneltrap+0x38>
        yield();
    80002974:	00000097          	auipc	ra,0x0
    80002978:	82a080e7          	jalr	-2006(ra) # 8000219e <yield>
    8000297c:	b7bd                	j	800028ea <kerneltrap+0x38>

000000008000297e <argraw>:
        return err;
    return strlen(buf);
}

static uint64 argraw(int n)
{
    8000297e:	1101                	addi	sp,sp,-32
    80002980:	ec06                	sd	ra,24(sp)
    80002982:	e822                	sd	s0,16(sp)
    80002984:	e426                	sd	s1,8(sp)
    80002986:	1000                	addi	s0,sp,32
    80002988:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    8000298a:	fffff097          	auipc	ra,0xfffff
    8000298e:	040080e7          	jalr	64(ra) # 800019ca <myproc>
    switch (n)
    80002992:	4795                	li	a5,5
    80002994:	0497e163          	bltu	a5,s1,800029d6 <argraw+0x58>
    80002998:	048a                	slli	s1,s1,0x2
    8000299a:	00006717          	auipc	a4,0x6
    8000299e:	a7670713          	addi	a4,a4,-1418 # 80008410 <states.0+0x168>
    800029a2:	94ba                	add	s1,s1,a4
    800029a4:	409c                	lw	a5,0(s1)
    800029a6:	97ba                	add	a5,a5,a4
    800029a8:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    800029aa:	6d3c                	ld	a5,88(a0)
    800029ac:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    800029ae:	60e2                	ld	ra,24(sp)
    800029b0:	6442                	ld	s0,16(sp)
    800029b2:	64a2                	ld	s1,8(sp)
    800029b4:	6105                	addi	sp,sp,32
    800029b6:	8082                	ret
        return p->trapframe->a1;
    800029b8:	6d3c                	ld	a5,88(a0)
    800029ba:	7fa8                	ld	a0,120(a5)
    800029bc:	bfcd                	j	800029ae <argraw+0x30>
        return p->trapframe->a2;
    800029be:	6d3c                	ld	a5,88(a0)
    800029c0:	63c8                	ld	a0,128(a5)
    800029c2:	b7f5                	j	800029ae <argraw+0x30>
        return p->trapframe->a3;
    800029c4:	6d3c                	ld	a5,88(a0)
    800029c6:	67c8                	ld	a0,136(a5)
    800029c8:	b7dd                	j	800029ae <argraw+0x30>
        return p->trapframe->a4;
    800029ca:	6d3c                	ld	a5,88(a0)
    800029cc:	6bc8                	ld	a0,144(a5)
    800029ce:	b7c5                	j	800029ae <argraw+0x30>
        return p->trapframe->a5;
    800029d0:	6d3c                	ld	a5,88(a0)
    800029d2:	6fc8                	ld	a0,152(a5)
    800029d4:	bfe9                	j	800029ae <argraw+0x30>
    panic("argraw");
    800029d6:	00006517          	auipc	a0,0x6
    800029da:	a1250513          	addi	a0,a0,-1518 # 800083e8 <states.0+0x140>
    800029de:	ffffe097          	auipc	ra,0xffffe
    800029e2:	b64080e7          	jalr	-1180(ra) # 80000542 <panic>

00000000800029e6 <fetchaddr>:
{
    800029e6:	1101                	addi	sp,sp,-32
    800029e8:	ec06                	sd	ra,24(sp)
    800029ea:	e822                	sd	s0,16(sp)
    800029ec:	e426                	sd	s1,8(sp)
    800029ee:	e04a                	sd	s2,0(sp)
    800029f0:	1000                	addi	s0,sp,32
    800029f2:	84aa                	mv	s1,a0
    800029f4:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800029f6:	fffff097          	auipc	ra,0xfffff
    800029fa:	fd4080e7          	jalr	-44(ra) # 800019ca <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    800029fe:	653c                	ld	a5,72(a0)
    80002a00:	02f4f863          	bgeu	s1,a5,80002a30 <fetchaddr+0x4a>
    80002a04:	00848713          	addi	a4,s1,8
    80002a08:	02e7e663          	bltu	a5,a4,80002a34 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a0c:	46a1                	li	a3,8
    80002a0e:	8626                	mv	a2,s1
    80002a10:	85ca                	mv	a1,s2
    80002a12:	6928                	ld	a0,80(a0)
    80002a14:	fffff097          	auipc	ra,0xfffff
    80002a18:	d34080e7          	jalr	-716(ra) # 80001748 <copyin>
    80002a1c:	00a03533          	snez	a0,a0
    80002a20:	40a00533          	neg	a0,a0
}
    80002a24:	60e2                	ld	ra,24(sp)
    80002a26:	6442                	ld	s0,16(sp)
    80002a28:	64a2                	ld	s1,8(sp)
    80002a2a:	6902                	ld	s2,0(sp)
    80002a2c:	6105                	addi	sp,sp,32
    80002a2e:	8082                	ret
        return -1;
    80002a30:	557d                	li	a0,-1
    80002a32:	bfcd                	j	80002a24 <fetchaddr+0x3e>
    80002a34:	557d                	li	a0,-1
    80002a36:	b7fd                	j	80002a24 <fetchaddr+0x3e>

0000000080002a38 <fetchstr>:
{
    80002a38:	7179                	addi	sp,sp,-48
    80002a3a:	f406                	sd	ra,40(sp)
    80002a3c:	f022                	sd	s0,32(sp)
    80002a3e:	ec26                	sd	s1,24(sp)
    80002a40:	e84a                	sd	s2,16(sp)
    80002a42:	e44e                	sd	s3,8(sp)
    80002a44:	1800                	addi	s0,sp,48
    80002a46:	892a                	mv	s2,a0
    80002a48:	84ae                	mv	s1,a1
    80002a4a:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002a4c:	fffff097          	auipc	ra,0xfffff
    80002a50:	f7e080e7          	jalr	-130(ra) # 800019ca <myproc>
    int err = copyinstr(p->pagetable, buf, addr, max);
    80002a54:	86ce                	mv	a3,s3
    80002a56:	864a                	mv	a2,s2
    80002a58:	85a6                	mv	a1,s1
    80002a5a:	6928                	ld	a0,80(a0)
    80002a5c:	fffff097          	auipc	ra,0xfffff
    80002a60:	d7a080e7          	jalr	-646(ra) # 800017d6 <copyinstr>
    if (err < 0)
    80002a64:	00054763          	bltz	a0,80002a72 <fetchstr+0x3a>
    return strlen(buf);
    80002a68:	8526                	mv	a0,s1
    80002a6a:	ffffe097          	auipc	ra,0xffffe
    80002a6e:	414080e7          	jalr	1044(ra) # 80000e7e <strlen>
}
    80002a72:	70a2                	ld	ra,40(sp)
    80002a74:	7402                	ld	s0,32(sp)
    80002a76:	64e2                	ld	s1,24(sp)
    80002a78:	6942                	ld	s2,16(sp)
    80002a7a:	69a2                	ld	s3,8(sp)
    80002a7c:	6145                	addi	sp,sp,48
    80002a7e:	8082                	ret

0000000080002a80 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
    80002a80:	1101                	addi	sp,sp,-32
    80002a82:	ec06                	sd	ra,24(sp)
    80002a84:	e822                	sd	s0,16(sp)
    80002a86:	e426                	sd	s1,8(sp)
    80002a88:	1000                	addi	s0,sp,32
    80002a8a:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	ef2080e7          	jalr	-270(ra) # 8000297e <argraw>
    80002a94:	c088                	sw	a0,0(s1)
    return 0;
}
    80002a96:	4501                	li	a0,0
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	64a2                	ld	s1,8(sp)
    80002a9e:	6105                	addi	sp,sp,32
    80002aa0:	8082                	ret

0000000080002aa2 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip)
{
    80002aa2:	1101                	addi	sp,sp,-32
    80002aa4:	ec06                	sd	ra,24(sp)
    80002aa6:	e822                	sd	s0,16(sp)
    80002aa8:	e426                	sd	s1,8(sp)
    80002aaa:	1000                	addi	s0,sp,32
    80002aac:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	ed0080e7          	jalr	-304(ra) # 8000297e <argraw>
    80002ab6:	e088                	sd	a0,0(s1)
    return 0;
}
    80002ab8:	4501                	li	a0,0
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	64a2                	ld	s1,8(sp)
    80002ac0:	6105                	addi	sp,sp,32
    80002ac2:	8082                	ret

0000000080002ac4 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002ac4:	1101                	addi	sp,sp,-32
    80002ac6:	ec06                	sd	ra,24(sp)
    80002ac8:	e822                	sd	s0,16(sp)
    80002aca:	e426                	sd	s1,8(sp)
    80002acc:	e04a                	sd	s2,0(sp)
    80002ace:	1000                	addi	s0,sp,32
    80002ad0:	84ae                	mv	s1,a1
    80002ad2:	8932                	mv	s2,a2
    *ip = argraw(n);
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	eaa080e7          	jalr	-342(ra) # 8000297e <argraw>
    uint64 addr;
    if (argaddr(n, &addr) < 0)
        return -1;
    return fetchstr(addr, buf, max);
    80002adc:	864a                	mv	a2,s2
    80002ade:	85a6                	mv	a1,s1
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	f58080e7          	jalr	-168(ra) # 80002a38 <fetchstr>
}
    80002ae8:	60e2                	ld	ra,24(sp)
    80002aea:	6442                	ld	s0,16(sp)
    80002aec:	64a2                	ld	s1,8(sp)
    80002aee:	6902                	ld	s2,0(sp)
    80002af0:	6105                	addi	sp,sp,32
    80002af2:	8082                	ret

0000000080002af4 <syscall>:
    [SYS_force_disk_fail] sys_force_disk_fail,
    [SYS_chmod] sys_chmod,
};

void syscall(void)
{
    80002af4:	1101                	addi	sp,sp,-32
    80002af6:	ec06                	sd	ra,24(sp)
    80002af8:	e822                	sd	s0,16(sp)
    80002afa:	e426                	sd	s1,8(sp)
    80002afc:	e04a                	sd	s2,0(sp)
    80002afe:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002b00:	fffff097          	auipc	ra,0xfffff
    80002b04:	eca080e7          	jalr	-310(ra) # 800019ca <myproc>
    80002b08:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002b0a:	05853903          	ld	s2,88(a0)
    80002b0e:	0a893783          	ld	a5,168(s2)
    80002b12:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002b16:	37fd                	addiw	a5,a5,-1
    80002b18:	4771                	li	a4,28
    80002b1a:	00f76f63          	bltu	a4,a5,80002b38 <syscall+0x44>
    80002b1e:	00369713          	slli	a4,a3,0x3
    80002b22:	00006797          	auipc	a5,0x6
    80002b26:	90678793          	addi	a5,a5,-1786 # 80008428 <syscalls>
    80002b2a:	97ba                	add	a5,a5,a4
    80002b2c:	639c                	ld	a5,0(a5)
    80002b2e:	c789                	beqz	a5,80002b38 <syscall+0x44>
    {
        p->trapframe->a0 = syscalls[num]();
    80002b30:	9782                	jalr	a5
    80002b32:	06a93823          	sd	a0,112(s2)
    80002b36:	a839                	j	80002b54 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002b38:	15848613          	addi	a2,s1,344
    80002b3c:	5c8c                	lw	a1,56(s1)
    80002b3e:	00006517          	auipc	a0,0x6
    80002b42:	8b250513          	addi	a0,a0,-1870 # 800083f0 <states.0+0x148>
    80002b46:	ffffe097          	auipc	ra,0xffffe
    80002b4a:	a46080e7          	jalr	-1466(ra) # 8000058c <printf>
        p->trapframe->a0 = -1;
    80002b4e:	6cbc                	ld	a5,88(s1)
    80002b50:	577d                	li	a4,-1
    80002b52:	fbb8                	sd	a4,112(a5)
    }
}
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6902                	ld	s2,0(sp)
    80002b5c:	6105                	addi	sp,sp,32
    80002b5e:	8082                	ret

0000000080002b60 <sys_exit>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void)
{
    80002b60:	1101                	addi	sp,sp,-32
    80002b62:	ec06                	sd	ra,24(sp)
    80002b64:	e822                	sd	s0,16(sp)
    80002b66:	1000                	addi	s0,sp,32
    int n;
    if (argint(0, &n) < 0)
    80002b68:	fec40593          	addi	a1,s0,-20
    80002b6c:	4501                	li	a0,0
    80002b6e:	00000097          	auipc	ra,0x0
    80002b72:	f12080e7          	jalr	-238(ra) # 80002a80 <argint>
        return -1;
    80002b76:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    80002b78:	00054963          	bltz	a0,80002b8a <sys_exit+0x2a>
    exit(n);
    80002b7c:	fec42503          	lw	a0,-20(s0)
    80002b80:	fffff097          	auipc	ra,0xfffff
    80002b84:	514080e7          	jalr	1300(ra) # 80002094 <exit>
    return 0; // not reached
    80002b88:	4781                	li	a5,0
}
    80002b8a:	853e                	mv	a0,a5
    80002b8c:	60e2                	ld	ra,24(sp)
    80002b8e:	6442                	ld	s0,16(sp)
    80002b90:	6105                	addi	sp,sp,32
    80002b92:	8082                	ret

0000000080002b94 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002b94:	1141                	addi	sp,sp,-16
    80002b96:	e406                	sd	ra,8(sp)
    80002b98:	e022                	sd	s0,0(sp)
    80002b9a:	0800                	addi	s0,sp,16
    80002b9c:	fffff097          	auipc	ra,0xfffff
    80002ba0:	e2e080e7          	jalr	-466(ra) # 800019ca <myproc>
    80002ba4:	5d08                	lw	a0,56(a0)
    80002ba6:	60a2                	ld	ra,8(sp)
    80002ba8:	6402                	ld	s0,0(sp)
    80002baa:	0141                	addi	sp,sp,16
    80002bac:	8082                	ret

0000000080002bae <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002bae:	1141                	addi	sp,sp,-16
    80002bb0:	e406                	sd	ra,8(sp)
    80002bb2:	e022                	sd	s0,0(sp)
    80002bb4:	0800                	addi	s0,sp,16
    80002bb6:	fffff097          	auipc	ra,0xfffff
    80002bba:	1d4080e7          	jalr	468(ra) # 80001d8a <fork>
    80002bbe:	60a2                	ld	ra,8(sp)
    80002bc0:	6402                	ld	s0,0(sp)
    80002bc2:	0141                	addi	sp,sp,16
    80002bc4:	8082                	ret

0000000080002bc6 <sys_wait>:

uint64 sys_wait(void)
{
    80002bc6:	1101                	addi	sp,sp,-32
    80002bc8:	ec06                	sd	ra,24(sp)
    80002bca:	e822                	sd	s0,16(sp)
    80002bcc:	1000                	addi	s0,sp,32
    uint64 p;
    if (argaddr(0, &p) < 0)
    80002bce:	fe840593          	addi	a1,s0,-24
    80002bd2:	4501                	li	a0,0
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	ece080e7          	jalr	-306(ra) # 80002aa2 <argaddr>
    80002bdc:	87aa                	mv	a5,a0
        return -1;
    80002bde:	557d                	li	a0,-1
    if (argaddr(0, &p) < 0)
    80002be0:	0007c863          	bltz	a5,80002bf0 <sys_wait+0x2a>
    return wait(p);
    80002be4:	fe843503          	ld	a0,-24(s0)
    80002be8:	fffff097          	auipc	ra,0xfffff
    80002bec:	670080e7          	jalr	1648(ra) # 80002258 <wait>
}
    80002bf0:	60e2                	ld	ra,24(sp)
    80002bf2:	6442                	ld	s0,16(sp)
    80002bf4:	6105                	addi	sp,sp,32
    80002bf6:	8082                	ret

0000000080002bf8 <sys_sbrk>:

uint64 sys_sbrk(void)
{
    80002bf8:	7179                	addi	sp,sp,-48
    80002bfa:	f406                	sd	ra,40(sp)
    80002bfc:	f022                	sd	s0,32(sp)
    80002bfe:	ec26                	sd	s1,24(sp)
    80002c00:	1800                	addi	s0,sp,48
    int addr;
    int n;

    if (argint(0, &n) < 0)
    80002c02:	fdc40593          	addi	a1,s0,-36
    80002c06:	4501                	li	a0,0
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	e78080e7          	jalr	-392(ra) # 80002a80 <argint>
        return -1;
    80002c10:	54fd                	li	s1,-1
    if (argint(0, &n) < 0)
    80002c12:	00054f63          	bltz	a0,80002c30 <sys_sbrk+0x38>
    addr = myproc()->sz;
    80002c16:	fffff097          	auipc	ra,0xfffff
    80002c1a:	db4080e7          	jalr	-588(ra) # 800019ca <myproc>
    80002c1e:	4524                	lw	s1,72(a0)
    if (growproc(n) < 0)
    80002c20:	fdc42503          	lw	a0,-36(s0)
    80002c24:	fffff097          	auipc	ra,0xfffff
    80002c28:	0f2080e7          	jalr	242(ra) # 80001d16 <growproc>
    80002c2c:	00054863          	bltz	a0,80002c3c <sys_sbrk+0x44>
        return -1;
    return addr;
}
    80002c30:	8526                	mv	a0,s1
    80002c32:	70a2                	ld	ra,40(sp)
    80002c34:	7402                	ld	s0,32(sp)
    80002c36:	64e2                	ld	s1,24(sp)
    80002c38:	6145                	addi	sp,sp,48
    80002c3a:	8082                	ret
        return -1;
    80002c3c:	54fd                	li	s1,-1
    80002c3e:	bfcd                	j	80002c30 <sys_sbrk+0x38>

0000000080002c40 <sys_sleep>:

uint64 sys_sleep(void)
{
    80002c40:	7139                	addi	sp,sp,-64
    80002c42:	fc06                	sd	ra,56(sp)
    80002c44:	f822                	sd	s0,48(sp)
    80002c46:	f426                	sd	s1,40(sp)
    80002c48:	f04a                	sd	s2,32(sp)
    80002c4a:	ec4e                	sd	s3,24(sp)
    80002c4c:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
    80002c4e:	fcc40593          	addi	a1,s0,-52
    80002c52:	4501                	li	a0,0
    80002c54:	00000097          	auipc	ra,0x0
    80002c58:	e2c080e7          	jalr	-468(ra) # 80002a80 <argint>
        return -1;
    80002c5c:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    80002c5e:	06054563          	bltz	a0,80002cc8 <sys_sleep+0x88>
    acquire(&tickslock);
    80002c62:	00015517          	auipc	a0,0x15
    80002c66:	b0650513          	addi	a0,a0,-1274 # 80017768 <tickslock>
    80002c6a:	ffffe097          	auipc	ra,0xffffe
    80002c6e:	f94080e7          	jalr	-108(ra) # 80000bfe <acquire>
    ticks0 = ticks;
    80002c72:	00006917          	auipc	s2,0x6
    80002c76:	3ae92903          	lw	s2,942(s2) # 80009020 <ticks>
    while (ticks - ticks0 < n)
    80002c7a:	fcc42783          	lw	a5,-52(s0)
    80002c7e:	cf85                	beqz	a5,80002cb6 <sys_sleep+0x76>
        if (myproc()->killed)
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80002c80:	00015997          	auipc	s3,0x15
    80002c84:	ae898993          	addi	s3,s3,-1304 # 80017768 <tickslock>
    80002c88:	00006497          	auipc	s1,0x6
    80002c8c:	39848493          	addi	s1,s1,920 # 80009020 <ticks>
        if (myproc()->killed)
    80002c90:	fffff097          	auipc	ra,0xfffff
    80002c94:	d3a080e7          	jalr	-710(ra) # 800019ca <myproc>
    80002c98:	591c                	lw	a5,48(a0)
    80002c9a:	ef9d                	bnez	a5,80002cd8 <sys_sleep+0x98>
        sleep(&ticks, &tickslock);
    80002c9c:	85ce                	mv	a1,s3
    80002c9e:	8526                	mv	a0,s1
    80002ca0:	fffff097          	auipc	ra,0xfffff
    80002ca4:	53a080e7          	jalr	1338(ra) # 800021da <sleep>
    while (ticks - ticks0 < n)
    80002ca8:	409c                	lw	a5,0(s1)
    80002caa:	412787bb          	subw	a5,a5,s2
    80002cae:	fcc42703          	lw	a4,-52(s0)
    80002cb2:	fce7efe3          	bltu	a5,a4,80002c90 <sys_sleep+0x50>
    }
    release(&tickslock);
    80002cb6:	00015517          	auipc	a0,0x15
    80002cba:	ab250513          	addi	a0,a0,-1358 # 80017768 <tickslock>
    80002cbe:	ffffe097          	auipc	ra,0xffffe
    80002cc2:	ff4080e7          	jalr	-12(ra) # 80000cb2 <release>
    return 0;
    80002cc6:	4781                	li	a5,0
}
    80002cc8:	853e                	mv	a0,a5
    80002cca:	70e2                	ld	ra,56(sp)
    80002ccc:	7442                	ld	s0,48(sp)
    80002cce:	74a2                	ld	s1,40(sp)
    80002cd0:	7902                	ld	s2,32(sp)
    80002cd2:	69e2                	ld	s3,24(sp)
    80002cd4:	6121                	addi	sp,sp,64
    80002cd6:	8082                	ret
            release(&tickslock);
    80002cd8:	00015517          	auipc	a0,0x15
    80002cdc:	a9050513          	addi	a0,a0,-1392 # 80017768 <tickslock>
    80002ce0:	ffffe097          	auipc	ra,0xffffe
    80002ce4:	fd2080e7          	jalr	-46(ra) # 80000cb2 <release>
            return -1;
    80002ce8:	57fd                	li	a5,-1
    80002cea:	bff9                	j	80002cc8 <sys_sleep+0x88>

0000000080002cec <sys_kill>:

uint64 sys_kill(void)
{
    80002cec:	1101                	addi	sp,sp,-32
    80002cee:	ec06                	sd	ra,24(sp)
    80002cf0:	e822                	sd	s0,16(sp)
    80002cf2:	1000                	addi	s0,sp,32
    int pid;

    if (argint(0, &pid) < 0)
    80002cf4:	fec40593          	addi	a1,s0,-20
    80002cf8:	4501                	li	a0,0
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	d86080e7          	jalr	-634(ra) # 80002a80 <argint>
    80002d02:	87aa                	mv	a5,a0
        return -1;
    80002d04:	557d                	li	a0,-1
    if (argint(0, &pid) < 0)
    80002d06:	0007c863          	bltz	a5,80002d16 <sys_kill+0x2a>
    return kill(pid);
    80002d0a:	fec42503          	lw	a0,-20(s0)
    80002d0e:	fffff097          	auipc	ra,0xfffff
    80002d12:	6b6080e7          	jalr	1718(ra) # 800023c4 <kill>
}
    80002d16:	60e2                	ld	ra,24(sp)
    80002d18:	6442                	ld	s0,16(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret

0000000080002d1e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void)
{
    80002d1e:	1101                	addi	sp,sp,-32
    80002d20:	ec06                	sd	ra,24(sp)
    80002d22:	e822                	sd	s0,16(sp)
    80002d24:	e426                	sd	s1,8(sp)
    80002d26:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80002d28:	00015517          	auipc	a0,0x15
    80002d2c:	a4050513          	addi	a0,a0,-1472 # 80017768 <tickslock>
    80002d30:	ffffe097          	auipc	ra,0xffffe
    80002d34:	ece080e7          	jalr	-306(ra) # 80000bfe <acquire>
    xticks = ticks;
    80002d38:	00006497          	auipc	s1,0x6
    80002d3c:	2e84a483          	lw	s1,744(s1) # 80009020 <ticks>
    release(&tickslock);
    80002d40:	00015517          	auipc	a0,0x15
    80002d44:	a2850513          	addi	a0,a0,-1496 # 80017768 <tickslock>
    80002d48:	ffffe097          	auipc	ra,0xffffe
    80002d4c:	f6a080e7          	jalr	-150(ra) # 80000cb2 <release>
    return xticks;
}
    80002d50:	02049513          	slli	a0,s1,0x20
    80002d54:	9101                	srli	a0,a0,0x20
    80002d56:	60e2                	ld	ra,24(sp)
    80002d58:	6442                	ld	s0,16(sp)
    80002d5a:	64a2                	ld	s1,8(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret

0000000080002d60 <sys_force_fail>:

// System call to simulate a read error on a specific physical block of Disk 0.
// Argument: pbn - the physical block number (0 to LOGICAL_DISK_SIZE-1) to fail,
// or -1 to disable.
uint64 sys_force_fail(void)
{
    80002d60:	1101                	addi	sp,sp,-32
    80002d62:	ec06                	sd	ra,24(sp)
    80002d64:	e822                	sd	s0,16(sp)
    80002d66:	1000                	addi	s0,sp,32
    int pbn;
    if (argint(0, &pbn) < 0)
    80002d68:	fec40593          	addi	a1,s0,-20
    80002d6c:	4501                	li	a0,0
    80002d6e:	00000097          	auipc	ra,0x0
    80002d72:	d12080e7          	jalr	-750(ra) # 80002a80 <argint>
    80002d76:	02054563          	bltz	a0,80002da0 <sys_force_fail+0x40>
        return -1;

    if (pbn >= LOGICAL_DISK_SIZE || pbn < -1)
    80002d7a:	fec42703          	lw	a4,-20(s0)
    80002d7e:	0017069b          	addiw	a3,a4,1
    80002d82:	6785                	lui	a5,0x1
    80002d84:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
        return -1;
    80002d88:	557d                	li	a0,-1
    if (pbn >= LOGICAL_DISK_SIZE || pbn < -1)
    80002d8a:	00d7e763          	bltu	a5,a3,80002d98 <sys_force_fail+0x38>

    force_read_error_pbn = pbn;
    80002d8e:	00006797          	auipc	a5,0x6
    80002d92:	b8e7af23          	sw	a4,-1122(a5) # 8000892c <force_read_error_pbn>
    return 0;
    80002d96:	4501                	li	a0,0
}
    80002d98:	60e2                	ld	ra,24(sp)
    80002d9a:	6442                	ld	s0,16(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
        return -1;
    80002da0:	557d                	li	a0,-1
    80002da2:	bfdd                	j	80002d98 <sys_force_fail+0x38>

0000000080002da4 <sys_get_force_fail>:

// System call to get the current value of force_read_error_pbn
uint64 sys_get_force_fail(void) { return (uint64)force_read_error_pbn; }
    80002da4:	1141                	addi	sp,sp,-16
    80002da6:	e422                	sd	s0,8(sp)
    80002da8:	0800                	addi	s0,sp,16
    80002daa:	00006517          	auipc	a0,0x6
    80002dae:	b8252503          	lw	a0,-1150(a0) # 8000892c <force_read_error_pbn>
    80002db2:	6422                	ld	s0,8(sp)
    80002db4:	0141                	addi	sp,sp,16
    80002db6:	8082                	ret

0000000080002db8 <sys_force_disk_fail>:

// System call to force disk 0/1 fail
uint64 sys_force_disk_fail(void)
{
    80002db8:	1101                	addi	sp,sp,-32
    80002dba:	ec06                	sd	ra,24(sp)
    80002dbc:	e822                	sd	s0,16(sp)
    80002dbe:	1000                	addi	s0,sp,32
    int disk_id;
    if (argint(0, &disk_id) < 0)
    80002dc0:	fec40593          	addi	a1,s0,-20
    80002dc4:	4501                	li	a0,0
    80002dc6:	00000097          	auipc	ra,0x0
    80002dca:	cba080e7          	jalr	-838(ra) # 80002a80 <argint>
    80002dce:	02054363          	bltz	a0,80002df4 <sys_force_disk_fail+0x3c>
        return -1;
    if (disk_id < -1 || disk_id > 1)
    80002dd2:	fec42783          	lw	a5,-20(s0)
    80002dd6:	0017869b          	addiw	a3,a5,1
    80002dda:	4709                	li	a4,2
        return -1;
    80002ddc:	557d                	li	a0,-1
    if (disk_id < -1 || disk_id > 1)
    80002dde:	00d76763          	bltu	a4,a3,80002dec <sys_force_disk_fail+0x34>
    force_disk_fail_id = disk_id;
    80002de2:	00006717          	auipc	a4,0x6
    80002de6:	b4f72323          	sw	a5,-1210(a4) # 80008928 <force_disk_fail_id>
    return 0;
    80002dea:	4501                	li	a0,0
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret
        return -1;
    80002df4:	557d                	li	a0,-1
    80002df6:	bfdd                	j	80002dec <sys_force_disk_fail+0x34>

0000000080002df8 <binit>:
    // head.next is most recent, head.prev is least.
    struct buf head;
} bcache;

void binit(void)
{
    80002df8:	7179                	addi	sp,sp,-48
    80002dfa:	f406                	sd	ra,40(sp)
    80002dfc:	f022                	sd	s0,32(sp)
    80002dfe:	ec26                	sd	s1,24(sp)
    80002e00:	e84a                	sd	s2,16(sp)
    80002e02:	e44e                	sd	s3,8(sp)
    80002e04:	e052                	sd	s4,0(sp)
    80002e06:	1800                	addi	s0,sp,48
    struct buf *b;

    initlock(&bcache.lock, "bcache");
    80002e08:	00005597          	auipc	a1,0x5
    80002e0c:	71058593          	addi	a1,a1,1808 # 80008518 <syscalls+0xf0>
    80002e10:	00015517          	auipc	a0,0x15
    80002e14:	97050513          	addi	a0,a0,-1680 # 80017780 <bcache>
    80002e18:	ffffe097          	auipc	ra,0xffffe
    80002e1c:	d56080e7          	jalr	-682(ra) # 80000b6e <initlock>

    // Create linked list of buffers
    bcache.head.prev = &bcache.head;
    80002e20:	0001d797          	auipc	a5,0x1d
    80002e24:	96078793          	addi	a5,a5,-1696 # 8001f780 <bcache+0x8000>
    80002e28:	0001d717          	auipc	a4,0x1d
    80002e2c:	bc070713          	addi	a4,a4,-1088 # 8001f9e8 <bcache+0x8268>
    80002e30:	2ae7b823          	sd	a4,688(a5)
    bcache.head.next = &bcache.head;
    80002e34:	2ae7bc23          	sd	a4,696(a5)
    for (b = bcache.buf; b < bcache.buf + NBUF; b++)
    80002e38:	00015497          	auipc	s1,0x15
    80002e3c:	96048493          	addi	s1,s1,-1696 # 80017798 <bcache+0x18>
    {
        b->next = bcache.head.next;
    80002e40:	893e                	mv	s2,a5
        b->prev = &bcache.head;
    80002e42:	89ba                	mv	s3,a4
        initsleeplock(&b->lock, "buffer");
    80002e44:	00005a17          	auipc	s4,0x5
    80002e48:	6dca0a13          	addi	s4,s4,1756 # 80008520 <syscalls+0xf8>
        b->next = bcache.head.next;
    80002e4c:	2b893783          	ld	a5,696(s2)
    80002e50:	e8bc                	sd	a5,80(s1)
        b->prev = &bcache.head;
    80002e52:	0534b423          	sd	s3,72(s1)
        initsleeplock(&b->lock, "buffer");
    80002e56:	85d2                	mv	a1,s4
    80002e58:	01048513          	addi	a0,s1,16
    80002e5c:	00001097          	auipc	ra,0x1
    80002e60:	6ec080e7          	jalr	1772(ra) # 80004548 <initsleeplock>
        bcache.head.next->prev = b;
    80002e64:	2b893783          	ld	a5,696(s2)
    80002e68:	e7a4                	sd	s1,72(a5)
        bcache.head.next = b;
    80002e6a:	2a993c23          	sd	s1,696(s2)
    for (b = bcache.buf; b < bcache.buf + NBUF; b++)
    80002e6e:	45848493          	addi	s1,s1,1112
    80002e72:	fd349de3          	bne	s1,s3,80002e4c <binit+0x54>
    }
}
    80002e76:	70a2                	ld	ra,40(sp)
    80002e78:	7402                	ld	s0,32(sp)
    80002e7a:	64e2                	ld	s1,24(sp)
    80002e7c:	6942                	ld	s2,16(sp)
    80002e7e:	69a2                	ld	s3,8(sp)
    80002e80:	6a02                	ld	s4,0(sp)
    80002e82:	6145                	addi	sp,sp,48
    80002e84:	8082                	ret

0000000080002e86 <bget>:

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
struct buf *bget(uint dev, uint blockno)
{
    80002e86:	7179                	addi	sp,sp,-48
    80002e88:	f406                	sd	ra,40(sp)
    80002e8a:	f022                	sd	s0,32(sp)
    80002e8c:	ec26                	sd	s1,24(sp)
    80002e8e:	e84a                	sd	s2,16(sp)
    80002e90:	e44e                	sd	s3,8(sp)
    80002e92:	1800                	addi	s0,sp,48
    80002e94:	892a                	mv	s2,a0
    80002e96:	89ae                	mv	s3,a1
    struct buf *b;

    acquire(&bcache.lock);
    80002e98:	00015517          	auipc	a0,0x15
    80002e9c:	8e850513          	addi	a0,a0,-1816 # 80017780 <bcache>
    80002ea0:	ffffe097          	auipc	ra,0xffffe
    80002ea4:	d5e080e7          	jalr	-674(ra) # 80000bfe <acquire>

    // Is the block already cached?
    for (b = bcache.head.next; b != &bcache.head; b = b->next)
    80002ea8:	0001d497          	auipc	s1,0x1d
    80002eac:	b904b483          	ld	s1,-1136(s1) # 8001fa38 <bcache+0x82b8>
    80002eb0:	0001d797          	auipc	a5,0x1d
    80002eb4:	b3878793          	addi	a5,a5,-1224 # 8001f9e8 <bcache+0x8268>
    80002eb8:	02f48f63          	beq	s1,a5,80002ef6 <bget+0x70>
    80002ebc:	873e                	mv	a4,a5
    80002ebe:	a021                	j	80002ec6 <bget+0x40>
    80002ec0:	68a4                	ld	s1,80(s1)
    80002ec2:	02e48a63          	beq	s1,a4,80002ef6 <bget+0x70>
    {
        if (b->dev == dev && b->blockno == blockno)
    80002ec6:	449c                	lw	a5,8(s1)
    80002ec8:	ff279ce3          	bne	a5,s2,80002ec0 <bget+0x3a>
    80002ecc:	44dc                	lw	a5,12(s1)
    80002ece:	ff3799e3          	bne	a5,s3,80002ec0 <bget+0x3a>
        {
            b->refcnt++;
    80002ed2:	40bc                	lw	a5,64(s1)
    80002ed4:	2785                	addiw	a5,a5,1
    80002ed6:	c0bc                	sw	a5,64(s1)
            release(&bcache.lock);
    80002ed8:	00015517          	auipc	a0,0x15
    80002edc:	8a850513          	addi	a0,a0,-1880 # 80017780 <bcache>
    80002ee0:	ffffe097          	auipc	ra,0xffffe
    80002ee4:	dd2080e7          	jalr	-558(ra) # 80000cb2 <release>
            acquiresleep(&b->lock);
    80002ee8:	01048513          	addi	a0,s1,16
    80002eec:	00001097          	auipc	ra,0x1
    80002ef0:	696080e7          	jalr	1686(ra) # 80004582 <acquiresleep>
            return b;
    80002ef4:	a8b9                	j	80002f52 <bget+0xcc>
        }
    }

    // Not cached.
    // Recycle the least recently used (LRU) unused buffer.
    for (b = bcache.head.prev; b != &bcache.head; b = b->prev)
    80002ef6:	0001d497          	auipc	s1,0x1d
    80002efa:	b3a4b483          	ld	s1,-1222(s1) # 8001fa30 <bcache+0x82b0>
    80002efe:	0001d797          	auipc	a5,0x1d
    80002f02:	aea78793          	addi	a5,a5,-1302 # 8001f9e8 <bcache+0x8268>
    80002f06:	00f48863          	beq	s1,a5,80002f16 <bget+0x90>
    80002f0a:	873e                	mv	a4,a5
    {
        if (b->refcnt == 0)
    80002f0c:	40bc                	lw	a5,64(s1)
    80002f0e:	cf81                	beqz	a5,80002f26 <bget+0xa0>
    for (b = bcache.head.prev; b != &bcache.head; b = b->prev)
    80002f10:	64a4                	ld	s1,72(s1)
    80002f12:	fee49de3          	bne	s1,a4,80002f0c <bget+0x86>
            release(&bcache.lock);
            acquiresleep(&b->lock);
            return b;
        }
    }
    panic("bget: no buffers");
    80002f16:	00005517          	auipc	a0,0x5
    80002f1a:	61250513          	addi	a0,a0,1554 # 80008528 <syscalls+0x100>
    80002f1e:	ffffd097          	auipc	ra,0xffffd
    80002f22:	624080e7          	jalr	1572(ra) # 80000542 <panic>
            b->dev = dev;
    80002f26:	0124a423          	sw	s2,8(s1)
            b->blockno = blockno;
    80002f2a:	0134a623          	sw	s3,12(s1)
            b->valid = 0;
    80002f2e:	0004a023          	sw	zero,0(s1)
            b->refcnt = 1;
    80002f32:	4785                	li	a5,1
    80002f34:	c0bc                	sw	a5,64(s1)
            release(&bcache.lock);
    80002f36:	00015517          	auipc	a0,0x15
    80002f3a:	84a50513          	addi	a0,a0,-1974 # 80017780 <bcache>
    80002f3e:	ffffe097          	auipc	ra,0xffffe
    80002f42:	d74080e7          	jalr	-652(ra) # 80000cb2 <release>
            acquiresleep(&b->lock);
    80002f46:	01048513          	addi	a0,s1,16
    80002f4a:	00001097          	auipc	ra,0x1
    80002f4e:	638080e7          	jalr	1592(ra) # 80004582 <acquiresleep>
}
    80002f52:	8526                	mv	a0,s1
    80002f54:	70a2                	ld	ra,40(sp)
    80002f56:	7402                	ld	s0,32(sp)
    80002f58:	64e2                	ld	s1,24(sp)
    80002f5a:	6942                	ld	s2,16(sp)
    80002f5c:	69a2                	ld	s3,8(sp)
    80002f5e:	6145                	addi	sp,sp,48
    80002f60:	8082                	ret

0000000080002f62 <bread>:

// TODO: RAID 1 simulation
// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno)
{
    80002f62:	1101                	addi	sp,sp,-32
    80002f64:	ec06                	sd	ra,24(sp)
    80002f66:	e822                	sd	s0,16(sp)
    80002f68:	e426                	sd	s1,8(sp)
    80002f6a:	e04a                	sd	s2,0(sp)
    80002f6c:	1000                	addi	s0,sp,32
    struct buf *b;
    // Added: Flag used in fallback_test (Don't modify their name!!)
    int is_forced_fail_target = 0;
    int fail_disk = -1;
    
    fail_disk = force_disk_fail_id;
    80002f6e:	00006917          	auipc	s2,0x6
    80002f72:	9ba92903          	lw	s2,-1606(s2) # 80008928 <force_disk_fail_id>
    b = bget(dev, blockno);
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	f10080e7          	jalr	-240(ra) # 80002e86 <bget>
    80002f7e:	84aa                	mv	s1,a0

    // Force cache miss if simulation error
    if ((b->blockno == force_read_error_pbn && force_read_error_pbn != -1) ||
    80002f80:	00006797          	auipc	a5,0x6
    80002f84:	9ac7a783          	lw	a5,-1620(a5) # 8000892c <force_read_error_pbn>
    80002f88:	4558                	lw	a4,12(a0)
    80002f8a:	02f70463          	beq	a4,a5,80002fb2 <bread+0x50>
    80002f8e:	57fd                	li	a5,-1
    80002f90:	02f90563          	beq	s2,a5,80002fba <bread+0x58>
        is_forced_fail_target = 1;
    }

    if (!b->valid || is_forced_fail_target)
    {
        virtio_disk_rw(b, 0);
    80002f94:	4581                	li	a1,0
    80002f96:	8526                	mv	a0,s1
    80002f98:	00003097          	auipc	ra,0x3
    80002f9c:	474080e7          	jalr	1140(ra) # 8000640c <virtio_disk_rw>
        b->valid = 1;
    80002fa0:	4785                	li	a5,1
    80002fa2:	c09c                	sw	a5,0(s1)
    }
    return b;
}
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	60e2                	ld	ra,24(sp)
    80002fa8:	6442                	ld	s0,16(sp)
    80002faa:	64a2                	ld	s1,8(sp)
    80002fac:	6902                	ld	s2,0(sp)
    80002fae:	6105                	addi	sp,sp,32
    80002fb0:	8082                	ret
    if ((b->blockno == force_read_error_pbn && force_read_error_pbn != -1) ||
    80002fb2:	577d                	li	a4,-1
    80002fb4:	fee790e3          	bne	a5,a4,80002f94 <bread+0x32>
    80002fb8:	bfd9                	j	80002f8e <bread+0x2c>
    if (!b->valid || is_forced_fail_target)
    80002fba:	409c                	lw	a5,0(s1)
    80002fbc:	f7e5                	bnez	a5,80002fa4 <bread+0x42>
    80002fbe:	bfd9                	j	80002f94 <bread+0x32>

0000000080002fc0 <bwrite>:

// TODO: RAID 1 simulation
// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
    80002fc0:	1101                	addi	sp,sp,-32
    80002fc2:	ec06                	sd	ra,24(sp)
    80002fc4:	e822                	sd	s0,16(sp)
    80002fc6:	e426                	sd	s1,8(sp)
    80002fc8:	1000                	addi	s0,sp,32
    80002fca:	84aa                	mv	s1,a0
    if (!holdingsleep(&b->lock))
    80002fcc:	0541                	addi	a0,a0,16
    80002fce:	00001097          	auipc	ra,0x1
    80002fd2:	64e080e7          	jalr	1614(ra) # 8000461c <holdingsleep>
    80002fd6:	cd01                	beqz	a0,80002fee <bwrite+0x2e>
        panic("bwrite");
    virtio_disk_rw(b, 1);
    80002fd8:	4585                	li	a1,1
    80002fda:	8526                	mv	a0,s1
    80002fdc:	00003097          	auipc	ra,0x3
    80002fe0:	430080e7          	jalr	1072(ra) # 8000640c <virtio_disk_rw>
}
    80002fe4:	60e2                	ld	ra,24(sp)
    80002fe6:	6442                	ld	s0,16(sp)
    80002fe8:	64a2                	ld	s1,8(sp)
    80002fea:	6105                	addi	sp,sp,32
    80002fec:	8082                	ret
        panic("bwrite");
    80002fee:	00005517          	auipc	a0,0x5
    80002ff2:	55250513          	addi	a0,a0,1362 # 80008540 <syscalls+0x118>
    80002ff6:	ffffd097          	auipc	ra,0xffffd
    80002ffa:	54c080e7          	jalr	1356(ra) # 80000542 <panic>

0000000080002ffe <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
    80002ffe:	1101                	addi	sp,sp,-32
    80003000:	ec06                	sd	ra,24(sp)
    80003002:	e822                	sd	s0,16(sp)
    80003004:	e426                	sd	s1,8(sp)
    80003006:	e04a                	sd	s2,0(sp)
    80003008:	1000                	addi	s0,sp,32
    8000300a:	84aa                	mv	s1,a0
    if (!holdingsleep(&b->lock))
    8000300c:	01050913          	addi	s2,a0,16
    80003010:	854a                	mv	a0,s2
    80003012:	00001097          	auipc	ra,0x1
    80003016:	60a080e7          	jalr	1546(ra) # 8000461c <holdingsleep>
    8000301a:	c92d                	beqz	a0,8000308c <brelse+0x8e>
        panic("brelse");

    releasesleep(&b->lock);
    8000301c:	854a                	mv	a0,s2
    8000301e:	00001097          	auipc	ra,0x1
    80003022:	5ba080e7          	jalr	1466(ra) # 800045d8 <releasesleep>

    acquire(&bcache.lock);
    80003026:	00014517          	auipc	a0,0x14
    8000302a:	75a50513          	addi	a0,a0,1882 # 80017780 <bcache>
    8000302e:	ffffe097          	auipc	ra,0xffffe
    80003032:	bd0080e7          	jalr	-1072(ra) # 80000bfe <acquire>
    b->refcnt--;
    80003036:	40bc                	lw	a5,64(s1)
    80003038:	37fd                	addiw	a5,a5,-1
    8000303a:	0007871b          	sext.w	a4,a5
    8000303e:	c0bc                	sw	a5,64(s1)
    if (b->refcnt == 0)
    80003040:	eb05                	bnez	a4,80003070 <brelse+0x72>
    {
        // no one is waiting for it.
        b->next->prev = b->prev;
    80003042:	68bc                	ld	a5,80(s1)
    80003044:	64b8                	ld	a4,72(s1)
    80003046:	e7b8                	sd	a4,72(a5)
        b->prev->next = b->next;
    80003048:	64bc                	ld	a5,72(s1)
    8000304a:	68b8                	ld	a4,80(s1)
    8000304c:	ebb8                	sd	a4,80(a5)
        b->next = bcache.head.next;
    8000304e:	0001c797          	auipc	a5,0x1c
    80003052:	73278793          	addi	a5,a5,1842 # 8001f780 <bcache+0x8000>
    80003056:	2b87b703          	ld	a4,696(a5)
    8000305a:	e8b8                	sd	a4,80(s1)
        b->prev = &bcache.head;
    8000305c:	0001d717          	auipc	a4,0x1d
    80003060:	98c70713          	addi	a4,a4,-1652 # 8001f9e8 <bcache+0x8268>
    80003064:	e4b8                	sd	a4,72(s1)
        bcache.head.next->prev = b;
    80003066:	2b87b703          	ld	a4,696(a5)
    8000306a:	e724                	sd	s1,72(a4)
        bcache.head.next = b;
    8000306c:	2a97bc23          	sd	s1,696(a5)
    }

    release(&bcache.lock);
    80003070:	00014517          	auipc	a0,0x14
    80003074:	71050513          	addi	a0,a0,1808 # 80017780 <bcache>
    80003078:	ffffe097          	auipc	ra,0xffffe
    8000307c:	c3a080e7          	jalr	-966(ra) # 80000cb2 <release>
}
    80003080:	60e2                	ld	ra,24(sp)
    80003082:	6442                	ld	s0,16(sp)
    80003084:	64a2                	ld	s1,8(sp)
    80003086:	6902                	ld	s2,0(sp)
    80003088:	6105                	addi	sp,sp,32
    8000308a:	8082                	ret
        panic("brelse");
    8000308c:	00005517          	auipc	a0,0x5
    80003090:	4bc50513          	addi	a0,a0,1212 # 80008548 <syscalls+0x120>
    80003094:	ffffd097          	auipc	ra,0xffffd
    80003098:	4ae080e7          	jalr	1198(ra) # 80000542 <panic>

000000008000309c <bpin>:

void bpin(struct buf *b)
{
    8000309c:	1101                	addi	sp,sp,-32
    8000309e:	ec06                	sd	ra,24(sp)
    800030a0:	e822                	sd	s0,16(sp)
    800030a2:	e426                	sd	s1,8(sp)
    800030a4:	1000                	addi	s0,sp,32
    800030a6:	84aa                	mv	s1,a0
    acquire(&bcache.lock);
    800030a8:	00014517          	auipc	a0,0x14
    800030ac:	6d850513          	addi	a0,a0,1752 # 80017780 <bcache>
    800030b0:	ffffe097          	auipc	ra,0xffffe
    800030b4:	b4e080e7          	jalr	-1202(ra) # 80000bfe <acquire>
    b->refcnt++;
    800030b8:	40bc                	lw	a5,64(s1)
    800030ba:	2785                	addiw	a5,a5,1
    800030bc:	c0bc                	sw	a5,64(s1)
    release(&bcache.lock);
    800030be:	00014517          	auipc	a0,0x14
    800030c2:	6c250513          	addi	a0,a0,1730 # 80017780 <bcache>
    800030c6:	ffffe097          	auipc	ra,0xffffe
    800030ca:	bec080e7          	jalr	-1044(ra) # 80000cb2 <release>
}
    800030ce:	60e2                	ld	ra,24(sp)
    800030d0:	6442                	ld	s0,16(sp)
    800030d2:	64a2                	ld	s1,8(sp)
    800030d4:	6105                	addi	sp,sp,32
    800030d6:	8082                	ret

00000000800030d8 <bunpin>:

void bunpin(struct buf *b)
{
    800030d8:	1101                	addi	sp,sp,-32
    800030da:	ec06                	sd	ra,24(sp)
    800030dc:	e822                	sd	s0,16(sp)
    800030de:	e426                	sd	s1,8(sp)
    800030e0:	1000                	addi	s0,sp,32
    800030e2:	84aa                	mv	s1,a0
    acquire(&bcache.lock);
    800030e4:	00014517          	auipc	a0,0x14
    800030e8:	69c50513          	addi	a0,a0,1692 # 80017780 <bcache>
    800030ec:	ffffe097          	auipc	ra,0xffffe
    800030f0:	b12080e7          	jalr	-1262(ra) # 80000bfe <acquire>
    b->refcnt--;
    800030f4:	40bc                	lw	a5,64(s1)
    800030f6:	37fd                	addiw	a5,a5,-1
    800030f8:	c0bc                	sw	a5,64(s1)
    release(&bcache.lock);
    800030fa:	00014517          	auipc	a0,0x14
    800030fe:	68650513          	addi	a0,a0,1670 # 80017780 <bcache>
    80003102:	ffffe097          	auipc	ra,0xffffe
    80003106:	bb0080e7          	jalr	-1104(ra) # 80000cb2 <release>
}
    8000310a:	60e2                	ld	ra,24(sp)
    8000310c:	6442                	ld	s0,16(sp)
    8000310e:	64a2                	ld	s1,8(sp)
    80003110:	6105                	addi	sp,sp,32
    80003112:	8082                	ret

0000000080003114 <balloc>:

// Blocks.

// Allocate a zeroed disk block.
static uint balloc(uint dev)
{
    80003114:	711d                	addi	sp,sp,-96
    80003116:	ec86                	sd	ra,88(sp)
    80003118:	e8a2                	sd	s0,80(sp)
    8000311a:	e4a6                	sd	s1,72(sp)
    8000311c:	e0ca                	sd	s2,64(sp)
    8000311e:	fc4e                	sd	s3,56(sp)
    80003120:	f852                	sd	s4,48(sp)
    80003122:	f456                	sd	s5,40(sp)
    80003124:	f05a                	sd	s6,32(sp)
    80003126:	ec5e                	sd	s7,24(sp)
    80003128:	e862                	sd	s8,16(sp)
    8000312a:	e466                	sd	s9,8(sp)
    8000312c:	1080                	addi	s0,sp,96
    int b, bi, m;
    struct buf *bp;

    bp = 0;
    for (b = 0; b < sb.size; b += BPB)
    8000312e:	0001d797          	auipc	a5,0x1d
    80003132:	d167a783          	lw	a5,-746(a5) # 8001fe44 <sb+0x4>
    80003136:	cbd1                	beqz	a5,800031ca <balloc+0xb6>
    80003138:	8baa                	mv	s7,a0
    8000313a:	4a81                	li	s5,0
    {
        bp = bread(dev, BBLOCK(b, sb));
    8000313c:	0001db17          	auipc	s6,0x1d
    80003140:	d04b0b13          	addi	s6,s6,-764 # 8001fe40 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003144:	4c01                	li	s8,0
        {
            m = 1 << (bi % 8);
    80003146:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003148:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB)
    8000314a:	6c89                	lui	s9,0x2
    8000314c:	a831                	j	80003168 <balloc+0x54>
                brelse(bp);
                bzero(dev, b + bi);
                return b + bi;
            }
        }
        brelse(bp);
    8000314e:	854a                	mv	a0,s2
    80003150:	00000097          	auipc	ra,0x0
    80003154:	eae080e7          	jalr	-338(ra) # 80002ffe <brelse>
    for (b = 0; b < sb.size; b += BPB)
    80003158:	015c87bb          	addw	a5,s9,s5
    8000315c:	00078a9b          	sext.w	s5,a5
    80003160:	004b2703          	lw	a4,4(s6)
    80003164:	06eaf363          	bgeu	s5,a4,800031ca <balloc+0xb6>
        bp = bread(dev, BBLOCK(b, sb));
    80003168:	41fad79b          	sraiw	a5,s5,0x1f
    8000316c:	0137d79b          	srliw	a5,a5,0x13
    80003170:	015787bb          	addw	a5,a5,s5
    80003174:	40d7d79b          	sraiw	a5,a5,0xd
    80003178:	01cb2583          	lw	a1,28(s6)
    8000317c:	9dbd                	addw	a1,a1,a5
    8000317e:	855e                	mv	a0,s7
    80003180:	00000097          	auipc	ra,0x0
    80003184:	de2080e7          	jalr	-542(ra) # 80002f62 <bread>
    80003188:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8000318a:	004b2503          	lw	a0,4(s6)
    8000318e:	000a849b          	sext.w	s1,s5
    80003192:	8662                	mv	a2,s8
    80003194:	faa4fde3          	bgeu	s1,a0,8000314e <balloc+0x3a>
            m = 1 << (bi % 8);
    80003198:	41f6579b          	sraiw	a5,a2,0x1f
    8000319c:	01d7d69b          	srliw	a3,a5,0x1d
    800031a0:	00c6873b          	addw	a4,a3,a2
    800031a4:	00777793          	andi	a5,a4,7
    800031a8:	9f95                	subw	a5,a5,a3
    800031aa:	00f997bb          	sllw	a5,s3,a5
            if ((bp->data[bi / 8] & m) == 0)
    800031ae:	4037571b          	sraiw	a4,a4,0x3
    800031b2:	00e906b3          	add	a3,s2,a4
    800031b6:	0586c683          	lbu	a3,88(a3)
    800031ba:	00d7f5b3          	and	a1,a5,a3
    800031be:	cd91                	beqz	a1,800031da <balloc+0xc6>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800031c0:	2605                	addiw	a2,a2,1
    800031c2:	2485                	addiw	s1,s1,1
    800031c4:	fd4618e3          	bne	a2,s4,80003194 <balloc+0x80>
    800031c8:	b759                	j	8000314e <balloc+0x3a>
    }
    panic("balloc: out of blocks");
    800031ca:	00005517          	auipc	a0,0x5
    800031ce:	38650513          	addi	a0,a0,902 # 80008550 <syscalls+0x128>
    800031d2:	ffffd097          	auipc	ra,0xffffd
    800031d6:	370080e7          	jalr	880(ra) # 80000542 <panic>
                bp->data[bi / 8] |= m; // Mark block in use.
    800031da:	974a                	add	a4,a4,s2
    800031dc:	8fd5                	or	a5,a5,a3
    800031de:	04f70c23          	sb	a5,88(a4)
                log_write(bp);
    800031e2:	854a                	mv	a0,s2
    800031e4:	00001097          	auipc	ra,0x1
    800031e8:	276080e7          	jalr	630(ra) # 8000445a <log_write>
                brelse(bp);
    800031ec:	854a                	mv	a0,s2
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	e10080e7          	jalr	-496(ra) # 80002ffe <brelse>
    bp = bread(dev, bno);
    800031f6:	85a6                	mv	a1,s1
    800031f8:	855e                	mv	a0,s7
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	d68080e7          	jalr	-664(ra) # 80002f62 <bread>
    80003202:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    80003204:	40000613          	li	a2,1024
    80003208:	4581                	li	a1,0
    8000320a:	05850513          	addi	a0,a0,88
    8000320e:	ffffe097          	auipc	ra,0xffffe
    80003212:	aec080e7          	jalr	-1300(ra) # 80000cfa <memset>
    log_write(bp);
    80003216:	854a                	mv	a0,s2
    80003218:	00001097          	auipc	ra,0x1
    8000321c:	242080e7          	jalr	578(ra) # 8000445a <log_write>
    brelse(bp);
    80003220:	854a                	mv	a0,s2
    80003222:	00000097          	auipc	ra,0x0
    80003226:	ddc080e7          	jalr	-548(ra) # 80002ffe <brelse>
}
    8000322a:	8526                	mv	a0,s1
    8000322c:	60e6                	ld	ra,88(sp)
    8000322e:	6446                	ld	s0,80(sp)
    80003230:	64a6                	ld	s1,72(sp)
    80003232:	6906                	ld	s2,64(sp)
    80003234:	79e2                	ld	s3,56(sp)
    80003236:	7a42                	ld	s4,48(sp)
    80003238:	7aa2                	ld	s5,40(sp)
    8000323a:	7b02                	ld	s6,32(sp)
    8000323c:	6be2                	ld	s7,24(sp)
    8000323e:	6c42                	ld	s8,16(sp)
    80003240:	6ca2                	ld	s9,8(sp)
    80003242:	6125                	addi	sp,sp,96
    80003244:	8082                	ret

0000000080003246 <bfree>:

// Free a disk block.
static void bfree(int dev, uint b)
{
    80003246:	1101                	addi	sp,sp,-32
    80003248:	ec06                	sd	ra,24(sp)
    8000324a:	e822                	sd	s0,16(sp)
    8000324c:	e426                	sd	s1,8(sp)
    8000324e:	e04a                	sd	s2,0(sp)
    80003250:	1000                	addi	s0,sp,32
    80003252:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    80003254:	00d5d59b          	srliw	a1,a1,0xd
    80003258:	0001d797          	auipc	a5,0x1d
    8000325c:	c047a783          	lw	a5,-1020(a5) # 8001fe5c <sb+0x1c>
    80003260:	9dbd                	addw	a1,a1,a5
    80003262:	00000097          	auipc	ra,0x0
    80003266:	d00080e7          	jalr	-768(ra) # 80002f62 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    8000326a:	0074f713          	andi	a4,s1,7
    8000326e:	4785                	li	a5,1
    80003270:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    80003274:	14ce                	slli	s1,s1,0x33
    80003276:	90d9                	srli	s1,s1,0x36
    80003278:	00950733          	add	a4,a0,s1
    8000327c:	05874703          	lbu	a4,88(a4)
    80003280:	00e7f6b3          	and	a3,a5,a4
    80003284:	c69d                	beqz	a3,800032b2 <bfree+0x6c>
    80003286:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    80003288:	94aa                	add	s1,s1,a0
    8000328a:	fff7c793          	not	a5,a5
    8000328e:	8ff9                	and	a5,a5,a4
    80003290:	04f48c23          	sb	a5,88(s1)
    log_write(bp);
    80003294:	00001097          	auipc	ra,0x1
    80003298:	1c6080e7          	jalr	454(ra) # 8000445a <log_write>
    brelse(bp);
    8000329c:	854a                	mv	a0,s2
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	d60080e7          	jalr	-672(ra) # 80002ffe <brelse>
}
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	64a2                	ld	s1,8(sp)
    800032ac:	6902                	ld	s2,0(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret
        panic("freeing free block");
    800032b2:	00005517          	auipc	a0,0x5
    800032b6:	2b650513          	addi	a0,a0,694 # 80008568 <syscalls+0x140>
    800032ba:	ffffd097          	auipc	ra,0xffffd
    800032be:	288080e7          	jalr	648(ra) # 80000542 <panic>

00000000800032c2 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode *iget(uint dev, uint inum)
{
    800032c2:	7179                	addi	sp,sp,-48
    800032c4:	f406                	sd	ra,40(sp)
    800032c6:	f022                	sd	s0,32(sp)
    800032c8:	ec26                	sd	s1,24(sp)
    800032ca:	e84a                	sd	s2,16(sp)
    800032cc:	e44e                	sd	s3,8(sp)
    800032ce:	e052                	sd	s4,0(sp)
    800032d0:	1800                	addi	s0,sp,48
    800032d2:	89aa                	mv	s3,a0
    800032d4:	8a2e                	mv	s4,a1
    struct inode *ip, *empty;

    acquire(&icache.lock);
    800032d6:	0001d517          	auipc	a0,0x1d
    800032da:	b8a50513          	addi	a0,a0,-1142 # 8001fe60 <icache>
    800032de:	ffffe097          	auipc	ra,0xffffe
    800032e2:	920080e7          	jalr	-1760(ra) # 80000bfe <acquire>

    // Is the inode already cached?
    empty = 0;
    800032e6:	4901                	li	s2,0
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++)
    800032e8:	0001d497          	auipc	s1,0x1d
    800032ec:	b9048493          	addi	s1,s1,-1136 # 8001fe78 <icache+0x18>
    800032f0:	0001e697          	auipc	a3,0x1e
    800032f4:	61868693          	addi	a3,a3,1560 # 80021908 <log>
    800032f8:	a039                	j	80003306 <iget+0x44>
        {
            ip->ref++;
            release(&icache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800032fa:	02090b63          	beqz	s2,80003330 <iget+0x6e>
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++)
    800032fe:	08848493          	addi	s1,s1,136
    80003302:	02d48a63          	beq	s1,a3,80003336 <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    80003306:	449c                	lw	a5,8(s1)
    80003308:	fef059e3          	blez	a5,800032fa <iget+0x38>
    8000330c:	4098                	lw	a4,0(s1)
    8000330e:	ff3716e3          	bne	a4,s3,800032fa <iget+0x38>
    80003312:	40d8                	lw	a4,4(s1)
    80003314:	ff4713e3          	bne	a4,s4,800032fa <iget+0x38>
            ip->ref++;
    80003318:	2785                	addiw	a5,a5,1
    8000331a:	c49c                	sw	a5,8(s1)
            release(&icache.lock);
    8000331c:	0001d517          	auipc	a0,0x1d
    80003320:	b4450513          	addi	a0,a0,-1212 # 8001fe60 <icache>
    80003324:	ffffe097          	auipc	ra,0xffffe
    80003328:	98e080e7          	jalr	-1650(ra) # 80000cb2 <release>
            return ip;
    8000332c:	8926                	mv	s2,s1
    8000332e:	a03d                	j	8000335c <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003330:	f7f9                	bnez	a5,800032fe <iget+0x3c>
    80003332:	8926                	mv	s2,s1
    80003334:	b7e9                	j	800032fe <iget+0x3c>
            empty = ip;
    }

    // Recycle an inode cache entry.
    if (empty == 0)
    80003336:	02090c63          	beqz	s2,8000336e <iget+0xac>
        panic("iget: no inodes");

    ip = empty;
    ip->dev = dev;
    8000333a:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    8000333e:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    80003342:	4785                	li	a5,1
    80003344:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80003348:	04092023          	sw	zero,64(s2)
    release(&icache.lock);
    8000334c:	0001d517          	auipc	a0,0x1d
    80003350:	b1450513          	addi	a0,a0,-1260 # 8001fe60 <icache>
    80003354:	ffffe097          	auipc	ra,0xffffe
    80003358:	95e080e7          	jalr	-1698(ra) # 80000cb2 <release>

    return ip;
}
    8000335c:	854a                	mv	a0,s2
    8000335e:	70a2                	ld	ra,40(sp)
    80003360:	7402                	ld	s0,32(sp)
    80003362:	64e2                	ld	s1,24(sp)
    80003364:	6942                	ld	s2,16(sp)
    80003366:	69a2                	ld	s3,8(sp)
    80003368:	6a02                	ld	s4,0(sp)
    8000336a:	6145                	addi	sp,sp,48
    8000336c:	8082                	ret
        panic("iget: no inodes");
    8000336e:	00005517          	auipc	a0,0x5
    80003372:	21250513          	addi	a0,a0,530 # 80008580 <syscalls+0x158>
    80003376:	ffffd097          	auipc	ra,0xffffd
    8000337a:	1cc080e7          	jalr	460(ra) # 80000542 <panic>

000000008000337e <fsinit>:
{
    8000337e:	7179                	addi	sp,sp,-48
    80003380:	f406                	sd	ra,40(sp)
    80003382:	f022                	sd	s0,32(sp)
    80003384:	ec26                	sd	s1,24(sp)
    80003386:	e84a                	sd	s2,16(sp)
    80003388:	e44e                	sd	s3,8(sp)
    8000338a:	1800                	addi	s0,sp,48
    8000338c:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    8000338e:	4585                	li	a1,1
    80003390:	00000097          	auipc	ra,0x0
    80003394:	bd2080e7          	jalr	-1070(ra) # 80002f62 <bread>
    80003398:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    8000339a:	0001d997          	auipc	s3,0x1d
    8000339e:	aa698993          	addi	s3,s3,-1370 # 8001fe40 <sb>
    800033a2:	02000613          	li	a2,32
    800033a6:	05850593          	addi	a1,a0,88
    800033aa:	854e                	mv	a0,s3
    800033ac:	ffffe097          	auipc	ra,0xffffe
    800033b0:	9aa080e7          	jalr	-1622(ra) # 80000d56 <memmove>
    brelse(bp);
    800033b4:	8526                	mv	a0,s1
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	c48080e7          	jalr	-952(ra) # 80002ffe <brelse>
    if (sb.magic != FSMAGIC)
    800033be:	0009a703          	lw	a4,0(s3)
    800033c2:	102037b7          	lui	a5,0x10203
    800033c6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033ca:	02f71263          	bne	a4,a5,800033ee <fsinit+0x70>
    initlog(dev, &sb);
    800033ce:	0001d597          	auipc	a1,0x1d
    800033d2:	a7258593          	addi	a1,a1,-1422 # 8001fe40 <sb>
    800033d6:	854a                	mv	a0,s2
    800033d8:	00001097          	auipc	ra,0x1
    800033dc:	e0a080e7          	jalr	-502(ra) # 800041e2 <initlog>
}
    800033e0:	70a2                	ld	ra,40(sp)
    800033e2:	7402                	ld	s0,32(sp)
    800033e4:	64e2                	ld	s1,24(sp)
    800033e6:	6942                	ld	s2,16(sp)
    800033e8:	69a2                	ld	s3,8(sp)
    800033ea:	6145                	addi	sp,sp,48
    800033ec:	8082                	ret
        panic("invalid file system");
    800033ee:	00005517          	auipc	a0,0x5
    800033f2:	1a250513          	addi	a0,a0,418 # 80008590 <syscalls+0x168>
    800033f6:	ffffd097          	auipc	ra,0xffffd
    800033fa:	14c080e7          	jalr	332(ra) # 80000542 <panic>

00000000800033fe <iinit>:
{
    800033fe:	7179                	addi	sp,sp,-48
    80003400:	f406                	sd	ra,40(sp)
    80003402:	f022                	sd	s0,32(sp)
    80003404:	ec26                	sd	s1,24(sp)
    80003406:	e84a                	sd	s2,16(sp)
    80003408:	e44e                	sd	s3,8(sp)
    8000340a:	1800                	addi	s0,sp,48
    initlock(&icache.lock, "icache");
    8000340c:	00005597          	auipc	a1,0x5
    80003410:	19c58593          	addi	a1,a1,412 # 800085a8 <syscalls+0x180>
    80003414:	0001d517          	auipc	a0,0x1d
    80003418:	a4c50513          	addi	a0,a0,-1460 # 8001fe60 <icache>
    8000341c:	ffffd097          	auipc	ra,0xffffd
    80003420:	752080e7          	jalr	1874(ra) # 80000b6e <initlock>
    for (i = 0; i < NINODE; i++)
    80003424:	0001d497          	auipc	s1,0x1d
    80003428:	a6448493          	addi	s1,s1,-1436 # 8001fe88 <icache+0x28>
    8000342c:	0001e997          	auipc	s3,0x1e
    80003430:	4ec98993          	addi	s3,s3,1260 # 80021918 <log+0x10>
        initsleeplock(&icache.inode[i].lock, "inode");
    80003434:	00005917          	auipc	s2,0x5
    80003438:	17c90913          	addi	s2,s2,380 # 800085b0 <syscalls+0x188>
    8000343c:	85ca                	mv	a1,s2
    8000343e:	8526                	mv	a0,s1
    80003440:	00001097          	auipc	ra,0x1
    80003444:	108080e7          	jalr	264(ra) # 80004548 <initsleeplock>
    for (i = 0; i < NINODE; i++)
    80003448:	08848493          	addi	s1,s1,136
    8000344c:	ff3498e3          	bne	s1,s3,8000343c <iinit+0x3e>
}
    80003450:	70a2                	ld	ra,40(sp)
    80003452:	7402                	ld	s0,32(sp)
    80003454:	64e2                	ld	s1,24(sp)
    80003456:	6942                	ld	s2,16(sp)
    80003458:	69a2                	ld	s3,8(sp)
    8000345a:	6145                	addi	sp,sp,48
    8000345c:	8082                	ret

000000008000345e <ialloc>:
{
    8000345e:	715d                	addi	sp,sp,-80
    80003460:	e486                	sd	ra,72(sp)
    80003462:	e0a2                	sd	s0,64(sp)
    80003464:	fc26                	sd	s1,56(sp)
    80003466:	f84a                	sd	s2,48(sp)
    80003468:	f44e                	sd	s3,40(sp)
    8000346a:	f052                	sd	s4,32(sp)
    8000346c:	ec56                	sd	s5,24(sp)
    8000346e:	e85a                	sd	s6,16(sp)
    80003470:	e45e                	sd	s7,8(sp)
    80003472:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++)
    80003474:	0001d717          	auipc	a4,0x1d
    80003478:	9d872703          	lw	a4,-1576(a4) # 8001fe4c <sb+0xc>
    8000347c:	4785                	li	a5,1
    8000347e:	04e7fa63          	bgeu	a5,a4,800034d2 <ialloc+0x74>
    80003482:	8aaa                	mv	s5,a0
    80003484:	8bae                	mv	s7,a1
    80003486:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80003488:	0001da17          	auipc	s4,0x1d
    8000348c:	9b8a0a13          	addi	s4,s4,-1608 # 8001fe40 <sb>
    80003490:	00048b1b          	sext.w	s6,s1
    80003494:	0044d793          	srli	a5,s1,0x4
    80003498:	018a2583          	lw	a1,24(s4)
    8000349c:	9dbd                	addw	a1,a1,a5
    8000349e:	8556                	mv	a0,s5
    800034a0:	00000097          	auipc	ra,0x0
    800034a4:	ac2080e7          	jalr	-1342(ra) # 80002f62 <bread>
    800034a8:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    800034aa:	05850993          	addi	s3,a0,88
    800034ae:	00f4f793          	andi	a5,s1,15
    800034b2:	079a                	slli	a5,a5,0x6
    800034b4:	99be                	add	s3,s3,a5
        if (dip->type == 0)
    800034b6:	03899783          	lh	a5,56(s3)
    800034ba:	c785                	beqz	a5,800034e2 <ialloc+0x84>
        brelse(bp);
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	b42080e7          	jalr	-1214(ra) # 80002ffe <brelse>
    for (inum = 1; inum < sb.ninodes; inum++)
    800034c4:	0485                	addi	s1,s1,1
    800034c6:	00ca2703          	lw	a4,12(s4)
    800034ca:	0004879b          	sext.w	a5,s1
    800034ce:	fce7e1e3          	bltu	a5,a4,80003490 <ialloc+0x32>
    panic("ialloc: no inodes");
    800034d2:	00005517          	auipc	a0,0x5
    800034d6:	0e650513          	addi	a0,a0,230 # 800085b8 <syscalls+0x190>
    800034da:	ffffd097          	auipc	ra,0xffffd
    800034de:	068080e7          	jalr	104(ra) # 80000542 <panic>
            memset(dip, 0, sizeof(*dip));
    800034e2:	04000613          	li	a2,64
    800034e6:	4581                	li	a1,0
    800034e8:	854e                	mv	a0,s3
    800034ea:	ffffe097          	auipc	ra,0xffffe
    800034ee:	810080e7          	jalr	-2032(ra) # 80000cfa <memset>
            dip->type = type;
    800034f2:	03799c23          	sh	s7,56(s3)
            dip->mode = M_ALL;
    800034f6:	478d                	li	a5,3
    800034f8:	02f99e23          	sh	a5,60(s3)
            log_write(bp); // mark it allocated on the disk
    800034fc:	854a                	mv	a0,s2
    800034fe:	00001097          	auipc	ra,0x1
    80003502:	f5c080e7          	jalr	-164(ra) # 8000445a <log_write>
            brelse(bp);
    80003506:	854a                	mv	a0,s2
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	af6080e7          	jalr	-1290(ra) # 80002ffe <brelse>
            return iget(dev, inum);
    80003510:	85da                	mv	a1,s6
    80003512:	8556                	mv	a0,s5
    80003514:	00000097          	auipc	ra,0x0
    80003518:	dae080e7          	jalr	-594(ra) # 800032c2 <iget>
}
    8000351c:	60a6                	ld	ra,72(sp)
    8000351e:	6406                	ld	s0,64(sp)
    80003520:	74e2                	ld	s1,56(sp)
    80003522:	7942                	ld	s2,48(sp)
    80003524:	79a2                	ld	s3,40(sp)
    80003526:	7a02                	ld	s4,32(sp)
    80003528:	6ae2                	ld	s5,24(sp)
    8000352a:	6b42                	ld	s6,16(sp)
    8000352c:	6ba2                	ld	s7,8(sp)
    8000352e:	6161                	addi	sp,sp,80
    80003530:	8082                	ret

0000000080003532 <iupdate>:
{
    80003532:	1101                	addi	sp,sp,-32
    80003534:	ec06                	sd	ra,24(sp)
    80003536:	e822                	sd	s0,16(sp)
    80003538:	e426                	sd	s1,8(sp)
    8000353a:	e04a                	sd	s2,0(sp)
    8000353c:	1000                	addi	s0,sp,32
    8000353e:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003540:	415c                	lw	a5,4(a0)
    80003542:	0047d79b          	srliw	a5,a5,0x4
    80003546:	0001d597          	auipc	a1,0x1d
    8000354a:	9125a583          	lw	a1,-1774(a1) # 8001fe58 <sb+0x18>
    8000354e:	9dbd                	addw	a1,a1,a5
    80003550:	4108                	lw	a0,0(a0)
    80003552:	00000097          	auipc	ra,0x0
    80003556:	a10080e7          	jalr	-1520(ra) # 80002f62 <bread>
    8000355a:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000355c:	05850793          	addi	a5,a0,88
    80003560:	40c8                	lw	a0,4(s1)
    80003562:	893d                	andi	a0,a0,15
    80003564:	051a                	slli	a0,a0,0x6
    80003566:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80003568:	04449703          	lh	a4,68(s1)
    8000356c:	02e51c23          	sh	a4,56(a0)
    dip->nlink = ip->nlink;
    80003570:	04a49703          	lh	a4,74(s1)
    80003574:	02e51d23          	sh	a4,58(a0)
    dip->size = ip->size;
    80003578:	44f8                	lw	a4,76(s1)
    8000357a:	c118                	sw	a4,0(a0)
    dip->mode = ip->mode;
    8000357c:	08449703          	lh	a4,132(s1)
    80003580:	02e51e23          	sh	a4,60(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003584:	03400613          	li	a2,52
    80003588:	05048593          	addi	a1,s1,80
    8000358c:	0511                	addi	a0,a0,4
    8000358e:	ffffd097          	auipc	ra,0xffffd
    80003592:	7c8080e7          	jalr	1992(ra) # 80000d56 <memmove>
    log_write(bp);
    80003596:	854a                	mv	a0,s2
    80003598:	00001097          	auipc	ra,0x1
    8000359c:	ec2080e7          	jalr	-318(ra) # 8000445a <log_write>
    brelse(bp);
    800035a0:	854a                	mv	a0,s2
    800035a2:	00000097          	auipc	ra,0x0
    800035a6:	a5c080e7          	jalr	-1444(ra) # 80002ffe <brelse>
}
    800035aa:	60e2                	ld	ra,24(sp)
    800035ac:	6442                	ld	s0,16(sp)
    800035ae:	64a2                	ld	s1,8(sp)
    800035b0:	6902                	ld	s2,0(sp)
    800035b2:	6105                	addi	sp,sp,32
    800035b4:	8082                	ret

00000000800035b6 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode *idup(struct inode *ip)
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	1000                	addi	s0,sp,32
    800035c0:	84aa                	mv	s1,a0
    acquire(&icache.lock);
    800035c2:	0001d517          	auipc	a0,0x1d
    800035c6:	89e50513          	addi	a0,a0,-1890 # 8001fe60 <icache>
    800035ca:	ffffd097          	auipc	ra,0xffffd
    800035ce:	634080e7          	jalr	1588(ra) # 80000bfe <acquire>
    ip->ref++;
    800035d2:	449c                	lw	a5,8(s1)
    800035d4:	2785                	addiw	a5,a5,1
    800035d6:	c49c                	sw	a5,8(s1)
    release(&icache.lock);
    800035d8:	0001d517          	auipc	a0,0x1d
    800035dc:	88850513          	addi	a0,a0,-1912 # 8001fe60 <icache>
    800035e0:	ffffd097          	auipc	ra,0xffffd
    800035e4:	6d2080e7          	jalr	1746(ra) # 80000cb2 <release>
    return ip;
}
    800035e8:	8526                	mv	a0,s1
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	64a2                	ld	s1,8(sp)
    800035f0:	6105                	addi	sp,sp,32
    800035f2:	8082                	ret

00000000800035f4 <ilock>:

/* TODO: Access Control & Symbolic Link */
// Lock the given inode.
// Reads the inode from disk if necessary.
void ilock(struct inode *ip)
{
    800035f4:	1101                	addi	sp,sp,-32
    800035f6:	ec06                	sd	ra,24(sp)
    800035f8:	e822                	sd	s0,16(sp)
    800035fa:	e426                	sd	s1,8(sp)
    800035fc:	e04a                	sd	s2,0(sp)
    800035fe:	1000                	addi	s0,sp,32
    struct buf *bp;
    struct dinode *dip;

    if (ip == 0 || ip->ref < 1)
    80003600:	c115                	beqz	a0,80003624 <ilock+0x30>
    80003602:	84aa                	mv	s1,a0
    80003604:	451c                	lw	a5,8(a0)
    80003606:	00f05f63          	blez	a5,80003624 <ilock+0x30>
        panic("ilock");

    acquiresleep(&ip->lock);
    8000360a:	0541                	addi	a0,a0,16
    8000360c:	00001097          	auipc	ra,0x1
    80003610:	f76080e7          	jalr	-138(ra) # 80004582 <acquiresleep>

    if (ip->valid == 0)
    80003614:	40bc                	lw	a5,64(s1)
    80003616:	cf99                	beqz	a5,80003634 <ilock+0x40>
        brelse(bp);
        ip->valid = 1;
        if (ip->type == 0)
            panic("ilock: no type");
    }
}
    80003618:	60e2                	ld	ra,24(sp)
    8000361a:	6442                	ld	s0,16(sp)
    8000361c:	64a2                	ld	s1,8(sp)
    8000361e:	6902                	ld	s2,0(sp)
    80003620:	6105                	addi	sp,sp,32
    80003622:	8082                	ret
        panic("ilock");
    80003624:	00005517          	auipc	a0,0x5
    80003628:	fac50513          	addi	a0,a0,-84 # 800085d0 <syscalls+0x1a8>
    8000362c:	ffffd097          	auipc	ra,0xffffd
    80003630:	f16080e7          	jalr	-234(ra) # 80000542 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003634:	40dc                	lw	a5,4(s1)
    80003636:	0047d79b          	srliw	a5,a5,0x4
    8000363a:	0001d597          	auipc	a1,0x1d
    8000363e:	81e5a583          	lw	a1,-2018(a1) # 8001fe58 <sb+0x18>
    80003642:	9dbd                	addw	a1,a1,a5
    80003644:	4088                	lw	a0,0(s1)
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	91c080e7          	jalr	-1764(ra) # 80002f62 <bread>
    8000364e:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003650:	05850593          	addi	a1,a0,88
    80003654:	40dc                	lw	a5,4(s1)
    80003656:	8bbd                	andi	a5,a5,15
    80003658:	079a                	slli	a5,a5,0x6
    8000365a:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    8000365c:	03859783          	lh	a5,56(a1)
    80003660:	04f49223          	sh	a5,68(s1)
        ip->nlink = dip->nlink;
    80003664:	03a59783          	lh	a5,58(a1)
    80003668:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    8000366c:	419c                	lw	a5,0(a1)
    8000366e:	c4fc                	sw	a5,76(s1)
        ip->mode = dip->mode;
    80003670:	03c59783          	lh	a5,60(a1)
    80003674:	08f49223          	sh	a5,132(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003678:	03400613          	li	a2,52
    8000367c:	0591                	addi	a1,a1,4
    8000367e:	05048513          	addi	a0,s1,80
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	6d4080e7          	jalr	1748(ra) # 80000d56 <memmove>
        brelse(bp);
    8000368a:	854a                	mv	a0,s2
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	972080e7          	jalr	-1678(ra) # 80002ffe <brelse>
        ip->valid = 1;
    80003694:	4785                	li	a5,1
    80003696:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80003698:	04449783          	lh	a5,68(s1)
    8000369c:	ffb5                	bnez	a5,80003618 <ilock+0x24>
            panic("ilock: no type");
    8000369e:	00005517          	auipc	a0,0x5
    800036a2:	f3a50513          	addi	a0,a0,-198 # 800085d8 <syscalls+0x1b0>
    800036a6:	ffffd097          	auipc	ra,0xffffd
    800036aa:	e9c080e7          	jalr	-356(ra) # 80000542 <panic>

00000000800036ae <iunlock>:

// Unlock the given inode.
void iunlock(struct inode *ip)
{
    800036ae:	1101                	addi	sp,sp,-32
    800036b0:	ec06                	sd	ra,24(sp)
    800036b2:	e822                	sd	s0,16(sp)
    800036b4:	e426                	sd	s1,8(sp)
    800036b6:	e04a                	sd	s2,0(sp)
    800036b8:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036ba:	c905                	beqz	a0,800036ea <iunlock+0x3c>
    800036bc:	84aa                	mv	s1,a0
    800036be:	01050913          	addi	s2,a0,16
    800036c2:	854a                	mv	a0,s2
    800036c4:	00001097          	auipc	ra,0x1
    800036c8:	f58080e7          	jalr	-168(ra) # 8000461c <holdingsleep>
    800036cc:	cd19                	beqz	a0,800036ea <iunlock+0x3c>
    800036ce:	449c                	lw	a5,8(s1)
    800036d0:	00f05d63          	blez	a5,800036ea <iunlock+0x3c>
        panic("iunlock");

    releasesleep(&ip->lock);
    800036d4:	854a                	mv	a0,s2
    800036d6:	00001097          	auipc	ra,0x1
    800036da:	f02080e7          	jalr	-254(ra) # 800045d8 <releasesleep>
}
    800036de:	60e2                	ld	ra,24(sp)
    800036e0:	6442                	ld	s0,16(sp)
    800036e2:	64a2                	ld	s1,8(sp)
    800036e4:	6902                	ld	s2,0(sp)
    800036e6:	6105                	addi	sp,sp,32
    800036e8:	8082                	ret
        panic("iunlock");
    800036ea:	00005517          	auipc	a0,0x5
    800036ee:	efe50513          	addi	a0,a0,-258 # 800085e8 <syscalls+0x1c0>
    800036f2:	ffffd097          	auipc	ra,0xffffd
    800036f6:	e50080e7          	jalr	-432(ra) # 80000542 <panic>

00000000800036fa <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.

uint bmap(struct inode *ip, uint bn)
{
    800036fa:	7179                	addi	sp,sp,-48
    800036fc:	f406                	sd	ra,40(sp)
    800036fe:	f022                	sd	s0,32(sp)
    80003700:	ec26                	sd	s1,24(sp)
    80003702:	e84a                	sd	s2,16(sp)
    80003704:	e44e                	sd	s3,8(sp)
    80003706:	e052                	sd	s4,0(sp)
    80003708:	1800                	addi	s0,sp,48
    8000370a:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) //
    8000370c:	47ad                	li	a5,11
    8000370e:	02b7ef63          	bltu	a5,a1,8000374c <bmap+0x52>
    {
        if ((addr = ip->addrs[bn]) == 0)
    80003712:	02059493          	slli	s1,a1,0x20
    80003716:	9081                	srli	s1,s1,0x20
    80003718:	048a                	slli	s1,s1,0x2
    8000371a:	94aa                	add	s1,s1,a0
    8000371c:	0504a903          	lw	s2,80(s1)
    80003720:	0a091263          	bnez	s2,800037c4 <bmap+0xca>
        {
            addr = balloc(ip->dev);
    80003724:	4108                	lw	a0,0(a0)
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	9ee080e7          	jalr	-1554(ra) # 80003114 <balloc>
    8000372e:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80003732:	00090563          	beqz	s2,8000373c <bmap+0x42>
                panic("bmap: balloc failed");
            ip->addrs[bn] = addr;
    80003736:	0524a823          	sw	s2,80(s1)
    8000373a:	a069                	j	800037c4 <bmap+0xca>
                panic("bmap: balloc failed");
    8000373c:	00005517          	auipc	a0,0x5
    80003740:	eb450513          	addi	a0,a0,-332 # 800085f0 <syscalls+0x1c8>
    80003744:	ffffd097          	auipc	ra,0xffffd
    80003748:	dfe080e7          	jalr	-514(ra) # 80000542 <panic>
        }
        return addr;
    }
    bn -= NDIRECT;
    8000374c:	ff45849b          	addiw	s1,a1,-12
    80003750:	0004871b          	sext.w	a4,s1
    if (bn < NINDIRECT)
    80003754:	0ff00793          	li	a5,255
    80003758:	08e7ef63          	bltu	a5,a4,800037f6 <bmap+0xfc>
    {
        if ((addr = ip->addrs[NDIRECT]) == 0)
    8000375c:	08052583          	lw	a1,128(a0)
    80003760:	e999                	bnez	a1,80003776 <bmap+0x7c>
        {
            addr = balloc(ip->dev);
    80003762:	4108                	lw	a0,0(a0)
    80003764:	00000097          	auipc	ra,0x0
    80003768:	9b0080e7          	jalr	-1616(ra) # 80003114 <balloc>
    8000376c:	0005059b          	sext.w	a1,a0
            if (addr == 0)
    80003770:	c1bd                	beqz	a1,800037d6 <bmap+0xdc>
                panic("bmap: balloc failed for indirect block");
            ip->addrs[NDIRECT] = addr;
    80003772:	08b9a023          	sw	a1,128(s3)
        }

        bp = bread(ip->dev, addr);
    80003776:	0009a503          	lw	a0,0(s3)
    8000377a:	fffff097          	auipc	ra,0xfffff
    8000377e:	7e8080e7          	jalr	2024(ra) # 80002f62 <bread>
    80003782:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    80003784:	05850793          	addi	a5,a0,88

        uint target_addr = a[bn];
    80003788:	1482                	slli	s1,s1,0x20
    8000378a:	9081                	srli	s1,s1,0x20
    8000378c:	048a                	slli	s1,s1,0x2
    8000378e:	94be                	add	s1,s1,a5
    80003790:	0004a903          	lw	s2,0(s1)

        if (target_addr == 0)
    80003794:	02091363          	bnez	s2,800037ba <bmap+0xc0>
        {
            target_addr = balloc(ip->dev);
    80003798:	0009a503          	lw	a0,0(s3)
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	978080e7          	jalr	-1672(ra) # 80003114 <balloc>
    800037a4:	0005091b          	sext.w	s2,a0
            if (target_addr == 0)
    800037a8:	02090f63          	beqz	s2,800037e6 <bmap+0xec>
                panic("bmap: balloc failed for data block via indirect");
            a[bn] = target_addr;
    800037ac:	0124a023          	sw	s2,0(s1)
            log_write(bp);
    800037b0:	8552                	mv	a0,s4
    800037b2:	00001097          	auipc	ra,0x1
    800037b6:	ca8080e7          	jalr	-856(ra) # 8000445a <log_write>
        }
        brelse(bp);
    800037ba:	8552                	mv	a0,s4
    800037bc:	00000097          	auipc	ra,0x0
    800037c0:	842080e7          	jalr	-1982(ra) # 80002ffe <brelse>
    }

    printf("bmap: ERROR! file_bn %d is out of range for inode %d\n",
           bn + NDIRECT, ip->inum);
    panic("bmap: out of range");
}
    800037c4:	854a                	mv	a0,s2
    800037c6:	70a2                	ld	ra,40(sp)
    800037c8:	7402                	ld	s0,32(sp)
    800037ca:	64e2                	ld	s1,24(sp)
    800037cc:	6942                	ld	s2,16(sp)
    800037ce:	69a2                	ld	s3,8(sp)
    800037d0:	6a02                	ld	s4,0(sp)
    800037d2:	6145                	addi	sp,sp,48
    800037d4:	8082                	ret
                panic("bmap: balloc failed for indirect block");
    800037d6:	00005517          	auipc	a0,0x5
    800037da:	e3250513          	addi	a0,a0,-462 # 80008608 <syscalls+0x1e0>
    800037de:	ffffd097          	auipc	ra,0xffffd
    800037e2:	d64080e7          	jalr	-668(ra) # 80000542 <panic>
                panic("bmap: balloc failed for data block via indirect");
    800037e6:	00005517          	auipc	a0,0x5
    800037ea:	e4a50513          	addi	a0,a0,-438 # 80008630 <syscalls+0x208>
    800037ee:	ffffd097          	auipc	ra,0xffffd
    800037f2:	d54080e7          	jalr	-684(ra) # 80000542 <panic>
    printf("bmap: ERROR! file_bn %d is out of range for inode %d\n",
    800037f6:	4150                	lw	a2,4(a0)
    800037f8:	00005517          	auipc	a0,0x5
    800037fc:	e6850513          	addi	a0,a0,-408 # 80008660 <syscalls+0x238>
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	d8c080e7          	jalr	-628(ra) # 8000058c <printf>
    panic("bmap: out of range");
    80003808:	00005517          	auipc	a0,0x5
    8000380c:	e9050513          	addi	a0,a0,-368 # 80008698 <syscalls+0x270>
    80003810:	ffffd097          	auipc	ra,0xffffd
    80003814:	d32080e7          	jalr	-718(ra) # 80000542 <panic>

0000000080003818 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80003818:	7179                	addi	sp,sp,-48
    8000381a:	f406                	sd	ra,40(sp)
    8000381c:	f022                	sd	s0,32(sp)
    8000381e:	ec26                	sd	s1,24(sp)
    80003820:	e84a                	sd	s2,16(sp)
    80003822:	e44e                	sd	s3,8(sp)
    80003824:	e052                	sd	s4,0(sp)
    80003826:	1800                	addi	s0,sp,48
    80003828:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    8000382a:	05050493          	addi	s1,a0,80
    8000382e:	08050913          	addi	s2,a0,128
    80003832:	a021                	j	8000383a <itrunc+0x22>
    80003834:	0491                	addi	s1,s1,4
    80003836:	01248d63          	beq	s1,s2,80003850 <itrunc+0x38>
    {
        if (ip->addrs[i])
    8000383a:	408c                	lw	a1,0(s1)
    8000383c:	dde5                	beqz	a1,80003834 <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    8000383e:	0009a503          	lw	a0,0(s3)
    80003842:	00000097          	auipc	ra,0x0
    80003846:	a04080e7          	jalr	-1532(ra) # 80003246 <bfree>
            ip->addrs[i] = 0;
    8000384a:	0004a023          	sw	zero,0(s1)
    8000384e:	b7dd                	j	80003834 <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80003850:	0809a583          	lw	a1,128(s3)
    80003854:	e185                	bnez	a1,80003874 <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80003856:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    8000385a:	854e                	mv	a0,s3
    8000385c:	00000097          	auipc	ra,0x0
    80003860:	cd6080e7          	jalr	-810(ra) # 80003532 <iupdate>
}
    80003864:	70a2                	ld	ra,40(sp)
    80003866:	7402                	ld	s0,32(sp)
    80003868:	64e2                	ld	s1,24(sp)
    8000386a:	6942                	ld	s2,16(sp)
    8000386c:	69a2                	ld	s3,8(sp)
    8000386e:	6a02                	ld	s4,0(sp)
    80003870:	6145                	addi	sp,sp,48
    80003872:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003874:	0009a503          	lw	a0,0(s3)
    80003878:	fffff097          	auipc	ra,0xfffff
    8000387c:	6ea080e7          	jalr	1770(ra) # 80002f62 <bread>
    80003880:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80003882:	05850493          	addi	s1,a0,88
    80003886:	45850913          	addi	s2,a0,1112
    8000388a:	a021                	j	80003892 <itrunc+0x7a>
    8000388c:	0491                	addi	s1,s1,4
    8000388e:	01248b63          	beq	s1,s2,800038a4 <itrunc+0x8c>
            if (a[j])
    80003892:	408c                	lw	a1,0(s1)
    80003894:	dde5                	beqz	a1,8000388c <itrunc+0x74>
                bfree(ip->dev, a[j]);
    80003896:	0009a503          	lw	a0,0(s3)
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	9ac080e7          	jalr	-1620(ra) # 80003246 <bfree>
    800038a2:	b7ed                	j	8000388c <itrunc+0x74>
        brelse(bp);
    800038a4:	8552                	mv	a0,s4
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	758080e7          	jalr	1880(ra) # 80002ffe <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    800038ae:	0809a583          	lw	a1,128(s3)
    800038b2:	0009a503          	lw	a0,0(s3)
    800038b6:	00000097          	auipc	ra,0x0
    800038ba:	990080e7          	jalr	-1648(ra) # 80003246 <bfree>
        ip->addrs[NDIRECT] = 0;
    800038be:	0809a023          	sw	zero,128(s3)
    800038c2:	bf51                	j	80003856 <itrunc+0x3e>

00000000800038c4 <iput>:
{
    800038c4:	1101                	addi	sp,sp,-32
    800038c6:	ec06                	sd	ra,24(sp)
    800038c8:	e822                	sd	s0,16(sp)
    800038ca:	e426                	sd	s1,8(sp)
    800038cc:	e04a                	sd	s2,0(sp)
    800038ce:	1000                	addi	s0,sp,32
    800038d0:	84aa                	mv	s1,a0
    acquire(&icache.lock);
    800038d2:	0001c517          	auipc	a0,0x1c
    800038d6:	58e50513          	addi	a0,a0,1422 # 8001fe60 <icache>
    800038da:	ffffd097          	auipc	ra,0xffffd
    800038de:	324080e7          	jalr	804(ra) # 80000bfe <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    800038e2:	4498                	lw	a4,8(s1)
    800038e4:	4785                	li	a5,1
    800038e6:	02f70363          	beq	a4,a5,8000390c <iput+0x48>
    ip->ref--;
    800038ea:	449c                	lw	a5,8(s1)
    800038ec:	37fd                	addiw	a5,a5,-1
    800038ee:	c49c                	sw	a5,8(s1)
    release(&icache.lock);
    800038f0:	0001c517          	auipc	a0,0x1c
    800038f4:	57050513          	addi	a0,a0,1392 # 8001fe60 <icache>
    800038f8:	ffffd097          	auipc	ra,0xffffd
    800038fc:	3ba080e7          	jalr	954(ra) # 80000cb2 <release>
}
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	64a2                	ld	s1,8(sp)
    80003906:	6902                	ld	s2,0(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    8000390c:	40bc                	lw	a5,64(s1)
    8000390e:	dff1                	beqz	a5,800038ea <iput+0x26>
    80003910:	04a49783          	lh	a5,74(s1)
    80003914:	fbf9                	bnez	a5,800038ea <iput+0x26>
        acquiresleep(&ip->lock);
    80003916:	01048913          	addi	s2,s1,16
    8000391a:	854a                	mv	a0,s2
    8000391c:	00001097          	auipc	ra,0x1
    80003920:	c66080e7          	jalr	-922(ra) # 80004582 <acquiresleep>
        release(&icache.lock);
    80003924:	0001c517          	auipc	a0,0x1c
    80003928:	53c50513          	addi	a0,a0,1340 # 8001fe60 <icache>
    8000392c:	ffffd097          	auipc	ra,0xffffd
    80003930:	386080e7          	jalr	902(ra) # 80000cb2 <release>
        itrunc(ip);
    80003934:	8526                	mv	a0,s1
    80003936:	00000097          	auipc	ra,0x0
    8000393a:	ee2080e7          	jalr	-286(ra) # 80003818 <itrunc>
        ip->type = 0;
    8000393e:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80003942:	8526                	mv	a0,s1
    80003944:	00000097          	auipc	ra,0x0
    80003948:	bee080e7          	jalr	-1042(ra) # 80003532 <iupdate>
        ip->valid = 0;
    8000394c:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80003950:	854a                	mv	a0,s2
    80003952:	00001097          	auipc	ra,0x1
    80003956:	c86080e7          	jalr	-890(ra) # 800045d8 <releasesleep>
        acquire(&icache.lock);
    8000395a:	0001c517          	auipc	a0,0x1c
    8000395e:	50650513          	addi	a0,a0,1286 # 8001fe60 <icache>
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	29c080e7          	jalr	668(ra) # 80000bfe <acquire>
    8000396a:	b741                	j	800038ea <iput+0x26>

000000008000396c <iunlockput>:
{
    8000396c:	1101                	addi	sp,sp,-32
    8000396e:	ec06                	sd	ra,24(sp)
    80003970:	e822                	sd	s0,16(sp)
    80003972:	e426                	sd	s1,8(sp)
    80003974:	1000                	addi	s0,sp,32
    80003976:	84aa                	mv	s1,a0
    iunlock(ip);
    80003978:	00000097          	auipc	ra,0x0
    8000397c:	d36080e7          	jalr	-714(ra) # 800036ae <iunlock>
    iput(ip);
    80003980:	8526                	mv	a0,s1
    80003982:	00000097          	auipc	ra,0x0
    80003986:	f42080e7          	jalr	-190(ra) # 800038c4 <iput>
}
    8000398a:	60e2                	ld	ra,24(sp)
    8000398c:	6442                	ld	s0,16(sp)
    8000398e:	64a2                	ld	s1,8(sp)
    80003990:	6105                	addi	sp,sp,32
    80003992:	8082                	ret

0000000080003994 <stati>:

/* TODO: Access Control & Symbolic Link */
// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80003994:	1141                	addi	sp,sp,-16
    80003996:	e422                	sd	s0,8(sp)
    80003998:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    8000399a:	411c                	lw	a5,0(a0)
    8000399c:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    8000399e:	415c                	lw	a5,4(a0)
    800039a0:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    800039a2:	04451783          	lh	a5,68(a0)
    800039a6:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    800039aa:	04a51783          	lh	a5,74(a0)
    800039ae:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    800039b2:	04c56783          	lwu	a5,76(a0)
    800039b6:	e99c                	sd	a5,16(a1)
    //Loretta
    st->mode = ip->mode;
    800039b8:	08451783          	lh	a5,132(a0)
    800039bc:	00f59c23          	sh	a5,24(a1)
}
    800039c0:	6422                	ld	s0,8(sp)
    800039c2:	0141                	addi	sp,sp,16
    800039c4:	8082                	ret

00000000800039c6 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    800039c6:	457c                	lw	a5,76(a0)
    800039c8:	0ed7e863          	bltu	a5,a3,80003ab8 <readi+0xf2>
{
    800039cc:	7159                	addi	sp,sp,-112
    800039ce:	f486                	sd	ra,104(sp)
    800039d0:	f0a2                	sd	s0,96(sp)
    800039d2:	eca6                	sd	s1,88(sp)
    800039d4:	e8ca                	sd	s2,80(sp)
    800039d6:	e4ce                	sd	s3,72(sp)
    800039d8:	e0d2                	sd	s4,64(sp)
    800039da:	fc56                	sd	s5,56(sp)
    800039dc:	f85a                	sd	s6,48(sp)
    800039de:	f45e                	sd	s7,40(sp)
    800039e0:	f062                	sd	s8,32(sp)
    800039e2:	ec66                	sd	s9,24(sp)
    800039e4:	e86a                	sd	s10,16(sp)
    800039e6:	e46e                	sd	s11,8(sp)
    800039e8:	1880                	addi	s0,sp,112
    800039ea:	8baa                	mv	s7,a0
    800039ec:	8c2e                	mv	s8,a1
    800039ee:	8ab2                	mv	s5,a2
    800039f0:	84b6                	mv	s1,a3
    800039f2:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    800039f4:	9f35                	addw	a4,a4,a3
        return 0;
    800039f6:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    800039f8:	08d76f63          	bltu	a4,a3,80003a96 <readi+0xd0>
    if (off + n > ip->size)
    800039fc:	00e7f463          	bgeu	a5,a4,80003a04 <readi+0x3e>
        n = ip->size - off;
    80003a00:	40d78b3b          	subw	s6,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003a04:	0a0b0863          	beqz	s6,80003ab4 <readi+0xee>
    80003a08:	4981                	li	s3,0
    {
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
        m = min(n - tot, BSIZE - off % BSIZE);
    80003a0a:	40000d13          	li	s10,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80003a0e:	5cfd                	li	s9,-1
    80003a10:	a82d                	j	80003a4a <readi+0x84>
    80003a12:	020a1d93          	slli	s11,s4,0x20
    80003a16:	020ddd93          	srli	s11,s11,0x20
    80003a1a:	05890793          	addi	a5,s2,88
    80003a1e:	86ee                	mv	a3,s11
    80003a20:	963e                	add	a2,a2,a5
    80003a22:	85d6                	mv	a1,s5
    80003a24:	8562                	mv	a0,s8
    80003a26:	fffff097          	auipc	ra,0xfffff
    80003a2a:	a0e080e7          	jalr	-1522(ra) # 80002434 <either_copyout>
    80003a2e:	05950d63          	beq	a0,s9,80003a88 <readi+0xc2>
        {
            brelse(bp);
            break;
        }
        brelse(bp);
    80003a32:	854a                	mv	a0,s2
    80003a34:	fffff097          	auipc	ra,0xfffff
    80003a38:	5ca080e7          	jalr	1482(ra) # 80002ffe <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003a3c:	013a09bb          	addw	s3,s4,s3
    80003a40:	009a04bb          	addw	s1,s4,s1
    80003a44:	9aee                	add	s5,s5,s11
    80003a46:	0569f663          	bgeu	s3,s6,80003a92 <readi+0xcc>
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80003a4a:	000ba903          	lw	s2,0(s7)
    80003a4e:	00a4d59b          	srliw	a1,s1,0xa
    80003a52:	855e                	mv	a0,s7
    80003a54:	00000097          	auipc	ra,0x0
    80003a58:	ca6080e7          	jalr	-858(ra) # 800036fa <bmap>
    80003a5c:	0005059b          	sext.w	a1,a0
    80003a60:	854a                	mv	a0,s2
    80003a62:	fffff097          	auipc	ra,0xfffff
    80003a66:	500080e7          	jalr	1280(ra) # 80002f62 <bread>
    80003a6a:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003a6c:	3ff4f613          	andi	a2,s1,1023
    80003a70:	40cd07bb          	subw	a5,s10,a2
    80003a74:	413b073b          	subw	a4,s6,s3
    80003a78:	8a3e                	mv	s4,a5
    80003a7a:	2781                	sext.w	a5,a5
    80003a7c:	0007069b          	sext.w	a3,a4
    80003a80:	f8f6f9e3          	bgeu	a3,a5,80003a12 <readi+0x4c>
    80003a84:	8a3a                	mv	s4,a4
    80003a86:	b771                	j	80003a12 <readi+0x4c>
            brelse(bp);
    80003a88:	854a                	mv	a0,s2
    80003a8a:	fffff097          	auipc	ra,0xfffff
    80003a8e:	574080e7          	jalr	1396(ra) # 80002ffe <brelse>
    }
    return tot;
    80003a92:	0009851b          	sext.w	a0,s3
}
    80003a96:	70a6                	ld	ra,104(sp)
    80003a98:	7406                	ld	s0,96(sp)
    80003a9a:	64e6                	ld	s1,88(sp)
    80003a9c:	6946                	ld	s2,80(sp)
    80003a9e:	69a6                	ld	s3,72(sp)
    80003aa0:	6a06                	ld	s4,64(sp)
    80003aa2:	7ae2                	ld	s5,56(sp)
    80003aa4:	7b42                	ld	s6,48(sp)
    80003aa6:	7ba2                	ld	s7,40(sp)
    80003aa8:	7c02                	ld	s8,32(sp)
    80003aaa:	6ce2                	ld	s9,24(sp)
    80003aac:	6d42                	ld	s10,16(sp)
    80003aae:	6da2                	ld	s11,8(sp)
    80003ab0:	6165                	addi	sp,sp,112
    80003ab2:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003ab4:	89da                	mv	s3,s6
    80003ab6:	bff1                	j	80003a92 <readi+0xcc>
        return 0;
    80003ab8:	4501                	li	a0,0
}
    80003aba:	8082                	ret

0000000080003abc <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80003abc:	457c                	lw	a5,76(a0)
    80003abe:	10d7e563          	bltu	a5,a3,80003bc8 <writei+0x10c>
{
    80003ac2:	7159                	addi	sp,sp,-112
    80003ac4:	f486                	sd	ra,104(sp)
    80003ac6:	f0a2                	sd	s0,96(sp)
    80003ac8:	eca6                	sd	s1,88(sp)
    80003aca:	e8ca                	sd	s2,80(sp)
    80003acc:	e4ce                	sd	s3,72(sp)
    80003ace:	e0d2                	sd	s4,64(sp)
    80003ad0:	fc56                	sd	s5,56(sp)
    80003ad2:	f85a                	sd	s6,48(sp)
    80003ad4:	f45e                	sd	s7,40(sp)
    80003ad6:	f062                	sd	s8,32(sp)
    80003ad8:	ec66                	sd	s9,24(sp)
    80003ada:	e86a                	sd	s10,16(sp)
    80003adc:	e46e                	sd	s11,8(sp)
    80003ade:	1880                	addi	s0,sp,112
    80003ae0:	8baa                	mv	s7,a0
    80003ae2:	8c2e                	mv	s8,a1
    80003ae4:	8ab2                	mv	s5,a2
    80003ae6:	8936                	mv	s2,a3
    80003ae8:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80003aea:	00e687bb          	addw	a5,a3,a4
    80003aee:	0cd7ef63          	bltu	a5,a3,80003bcc <writei+0x110>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80003af2:	00043737          	lui	a4,0x43
    80003af6:	0cf76d63          	bltu	a4,a5,80003bd0 <writei+0x114>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003afa:	0a0b0663          	beqz	s6,80003ba6 <writei+0xea>
    80003afe:	4a01                	li	s4,0
    {
        uint bn = off / BSIZE;
        uint disk_lbn = bmap(ip, bn);
        bp = bread(ip->dev, disk_lbn);
        m = min(n - tot, BSIZE - off % BSIZE);
    80003b00:	40000d13          	li	s10,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80003b04:	5cfd                	li	s9,-1
    80003b06:	a091                	j	80003b4a <writei+0x8e>
    80003b08:	02099d93          	slli	s11,s3,0x20
    80003b0c:	020ddd93          	srli	s11,s11,0x20
    80003b10:	05848793          	addi	a5,s1,88
    80003b14:	86ee                	mv	a3,s11
    80003b16:	8656                	mv	a2,s5
    80003b18:	85e2                	mv	a1,s8
    80003b1a:	953e                	add	a0,a0,a5
    80003b1c:	fffff097          	auipc	ra,0xfffff
    80003b20:	96e080e7          	jalr	-1682(ra) # 8000248a <either_copyin>
    80003b24:	07950163          	beq	a0,s9,80003b86 <writei+0xca>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    80003b28:	8526                	mv	a0,s1
    80003b2a:	00001097          	auipc	ra,0x1
    80003b2e:	930080e7          	jalr	-1744(ra) # 8000445a <log_write>
        brelse(bp);
    80003b32:	8526                	mv	a0,s1
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	4ca080e7          	jalr	1226(ra) # 80002ffe <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003b3c:	01498a3b          	addw	s4,s3,s4
    80003b40:	0129893b          	addw	s2,s3,s2
    80003b44:	9aee                	add	s5,s5,s11
    80003b46:	056a7563          	bgeu	s4,s6,80003b90 <writei+0xd4>
        uint disk_lbn = bmap(ip, bn);
    80003b4a:	00a9559b          	srliw	a1,s2,0xa
    80003b4e:	855e                	mv	a0,s7
    80003b50:	00000097          	auipc	ra,0x0
    80003b54:	baa080e7          	jalr	-1110(ra) # 800036fa <bmap>
        bp = bread(ip->dev, disk_lbn);
    80003b58:	0005059b          	sext.w	a1,a0
    80003b5c:	000ba503          	lw	a0,0(s7)
    80003b60:	fffff097          	auipc	ra,0xfffff
    80003b64:	402080e7          	jalr	1026(ra) # 80002f62 <bread>
    80003b68:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003b6a:	3ff97513          	andi	a0,s2,1023
    80003b6e:	40ad07bb          	subw	a5,s10,a0
    80003b72:	414b073b          	subw	a4,s6,s4
    80003b76:	89be                	mv	s3,a5
    80003b78:	2781                	sext.w	a5,a5
    80003b7a:	0007069b          	sext.w	a3,a4
    80003b7e:	f8f6f5e3          	bgeu	a3,a5,80003b08 <writei+0x4c>
    80003b82:	89ba                	mv	s3,a4
    80003b84:	b751                	j	80003b08 <writei+0x4c>
            brelse(bp);
    80003b86:	8526                	mv	a0,s1
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	476080e7          	jalr	1142(ra) # 80002ffe <brelse>
    }

    if (n > 0)
    {
        if (off > ip->size)
    80003b90:	04cba783          	lw	a5,76(s7)
    80003b94:	0127f463          	bgeu	a5,s2,80003b9c <writei+0xe0>
            ip->size = off;
    80003b98:	052ba623          	sw	s2,76(s7)
        // write the i-node back to disk even if the size didn't change
        // because the loop above might have called bmap() and added a new
        // block to ip->addrs[].
        iupdate(ip);
    80003b9c:	855e                	mv	a0,s7
    80003b9e:	00000097          	auipc	ra,0x0
    80003ba2:	994080e7          	jalr	-1644(ra) # 80003532 <iupdate>
    }

    return n;
    80003ba6:	000b051b          	sext.w	a0,s6
}
    80003baa:	70a6                	ld	ra,104(sp)
    80003bac:	7406                	ld	s0,96(sp)
    80003bae:	64e6                	ld	s1,88(sp)
    80003bb0:	6946                	ld	s2,80(sp)
    80003bb2:	69a6                	ld	s3,72(sp)
    80003bb4:	6a06                	ld	s4,64(sp)
    80003bb6:	7ae2                	ld	s5,56(sp)
    80003bb8:	7b42                	ld	s6,48(sp)
    80003bba:	7ba2                	ld	s7,40(sp)
    80003bbc:	7c02                	ld	s8,32(sp)
    80003bbe:	6ce2                	ld	s9,24(sp)
    80003bc0:	6d42                	ld	s10,16(sp)
    80003bc2:	6da2                	ld	s11,8(sp)
    80003bc4:	6165                	addi	sp,sp,112
    80003bc6:	8082                	ret
        return -1;
    80003bc8:	557d                	li	a0,-1
}
    80003bca:	8082                	ret
        return -1;
    80003bcc:	557d                	li	a0,-1
    80003bce:	bff1                	j	80003baa <writei+0xee>
        return -1;
    80003bd0:	557d                	li	a0,-1
    80003bd2:	bfe1                	j	80003baa <writei+0xee>

0000000080003bd4 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    80003bd4:	1141                	addi	sp,sp,-16
    80003bd6:	e406                	sd	ra,8(sp)
    80003bd8:	e022                	sd	s0,0(sp)
    80003bda:	0800                	addi	s0,sp,16
    80003bdc:	4639                	li	a2,14
    80003bde:	ffffd097          	auipc	ra,0xffffd
    80003be2:	1f4080e7          	jalr	500(ra) # 80000dd2 <strncmp>
    80003be6:	60a2                	ld	ra,8(sp)
    80003be8:	6402                	ld	s0,0(sp)
    80003bea:	0141                	addi	sp,sp,16
    80003bec:	8082                	ret

0000000080003bee <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003bee:	7139                	addi	sp,sp,-64
    80003bf0:	fc06                	sd	ra,56(sp)
    80003bf2:	f822                	sd	s0,48(sp)
    80003bf4:	f426                	sd	s1,40(sp)
    80003bf6:	f04a                	sd	s2,32(sp)
    80003bf8:	ec4e                	sd	s3,24(sp)
    80003bfa:	e852                	sd	s4,16(sp)
    80003bfc:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    80003bfe:	04451703          	lh	a4,68(a0)
    80003c02:	4785                	li	a5,1
    80003c04:	00f71a63          	bne	a4,a5,80003c18 <dirlookup+0x2a>
    80003c08:	892a                	mv	s2,a0
    80003c0a:	89ae                	mv	s3,a1
    80003c0c:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    80003c0e:	457c                	lw	a5,76(a0)
    80003c10:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    80003c12:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    80003c14:	e79d                	bnez	a5,80003c42 <dirlookup+0x54>
    80003c16:	a8a5                	j	80003c8e <dirlookup+0xa0>
        panic("dirlookup not DIR");
    80003c18:	00005517          	auipc	a0,0x5
    80003c1c:	a9850513          	addi	a0,a0,-1384 # 800086b0 <syscalls+0x288>
    80003c20:	ffffd097          	auipc	ra,0xffffd
    80003c24:	922080e7          	jalr	-1758(ra) # 80000542 <panic>
            panic("dirlookup read");
    80003c28:	00005517          	auipc	a0,0x5
    80003c2c:	aa050513          	addi	a0,a0,-1376 # 800086c8 <syscalls+0x2a0>
    80003c30:	ffffd097          	auipc	ra,0xffffd
    80003c34:	912080e7          	jalr	-1774(ra) # 80000542 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003c38:	24c1                	addiw	s1,s1,16
    80003c3a:	04c92783          	lw	a5,76(s2)
    80003c3e:	04f4f763          	bgeu	s1,a5,80003c8c <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c42:	4741                	li	a4,16
    80003c44:	86a6                	mv	a3,s1
    80003c46:	fc040613          	addi	a2,s0,-64
    80003c4a:	4581                	li	a1,0
    80003c4c:	854a                	mv	a0,s2
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	d78080e7          	jalr	-648(ra) # 800039c6 <readi>
    80003c56:	47c1                	li	a5,16
    80003c58:	fcf518e3          	bne	a0,a5,80003c28 <dirlookup+0x3a>
        if (de.inum == 0)
    80003c5c:	fc045783          	lhu	a5,-64(s0)
    80003c60:	dfe1                	beqz	a5,80003c38 <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    80003c62:	fc240593          	addi	a1,s0,-62
    80003c66:	854e                	mv	a0,s3
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	f6c080e7          	jalr	-148(ra) # 80003bd4 <namecmp>
    80003c70:	f561                	bnez	a0,80003c38 <dirlookup+0x4a>
            if (poff)
    80003c72:	000a0463          	beqz	s4,80003c7a <dirlookup+0x8c>
                *poff = off;
    80003c76:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    80003c7a:	fc045583          	lhu	a1,-64(s0)
    80003c7e:	00092503          	lw	a0,0(s2)
    80003c82:	fffff097          	auipc	ra,0xfffff
    80003c86:	640080e7          	jalr	1600(ra) # 800032c2 <iget>
    80003c8a:	a011                	j	80003c8e <dirlookup+0xa0>
    return 0;
    80003c8c:	4501                	li	a0,0
}
    80003c8e:	70e2                	ld	ra,56(sp)
    80003c90:	7442                	ld	s0,48(sp)
    80003c92:	74a2                	ld	s1,40(sp)
    80003c94:	7902                	ld	s2,32(sp)
    80003c96:	69e2                	ld	s3,24(sp)
    80003c98:	6a42                	ld	s4,16(sp)
    80003c9a:	6121                	addi	sp,sp,64
    80003c9c:	8082                	ret

0000000080003c9e <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name)
{
    80003c9e:	711d                	addi	sp,sp,-96
    80003ca0:	ec86                	sd	ra,88(sp)
    80003ca2:	e8a2                	sd	s0,80(sp)
    80003ca4:	e4a6                	sd	s1,72(sp)
    80003ca6:	e0ca                	sd	s2,64(sp)
    80003ca8:	fc4e                	sd	s3,56(sp)
    80003caa:	f852                	sd	s4,48(sp)
    80003cac:	f456                	sd	s5,40(sp)
    80003cae:	f05a                	sd	s6,32(sp)
    80003cb0:	ec5e                	sd	s7,24(sp)
    80003cb2:	e862                	sd	s8,16(sp)
    80003cb4:	e466                	sd	s9,8(sp)
    80003cb6:	1080                	addi	s0,sp,96
    80003cb8:	84aa                	mv	s1,a0
    80003cba:	8aae                	mv	s5,a1
    80003cbc:	8a32                	mv	s4,a2
    struct inode *ip, *next;

    if (*path == '/')
    80003cbe:	00054703          	lbu	a4,0(a0)
    80003cc2:	02f00793          	li	a5,47
    80003cc6:	02f70363          	beq	a4,a5,80003cec <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    80003cca:	ffffe097          	auipc	ra,0xffffe
    80003cce:	d00080e7          	jalr	-768(ra) # 800019ca <myproc>
    80003cd2:	15053503          	ld	a0,336(a0)
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	8e0080e7          	jalr	-1824(ra) # 800035b6 <idup>
    80003cde:	89aa                	mv	s3,a0
    while (*path == '/')
    80003ce0:	02f00913          	li	s2,47
    len = path - s;
    80003ce4:	4b01                	li	s6,0
    if (len >= DIRSIZ)
    80003ce6:	4c35                	li	s8,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    80003ce8:	4b85                	li	s7,1
    80003cea:	a865                	j	80003da2 <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    80003cec:	4585                	li	a1,1
    80003cee:	4505                	li	a0,1
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	5d2080e7          	jalr	1490(ra) # 800032c2 <iget>
    80003cf8:	89aa                	mv	s3,a0
    80003cfa:	b7dd                	j	80003ce0 <namex+0x42>
        {
            iunlockput(ip);
    80003cfc:	854e                	mv	a0,s3
    80003cfe:	00000097          	auipc	ra,0x0
    80003d02:	c6e080e7          	jalr	-914(ra) # 8000396c <iunlockput>
            return 0;
    80003d06:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    80003d08:	854e                	mv	a0,s3
    80003d0a:	60e6                	ld	ra,88(sp)
    80003d0c:	6446                	ld	s0,80(sp)
    80003d0e:	64a6                	ld	s1,72(sp)
    80003d10:	6906                	ld	s2,64(sp)
    80003d12:	79e2                	ld	s3,56(sp)
    80003d14:	7a42                	ld	s4,48(sp)
    80003d16:	7aa2                	ld	s5,40(sp)
    80003d18:	7b02                	ld	s6,32(sp)
    80003d1a:	6be2                	ld	s7,24(sp)
    80003d1c:	6c42                	ld	s8,16(sp)
    80003d1e:	6ca2                	ld	s9,8(sp)
    80003d20:	6125                	addi	sp,sp,96
    80003d22:	8082                	ret
            iunlock(ip);
    80003d24:	854e                	mv	a0,s3
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	988080e7          	jalr	-1656(ra) # 800036ae <iunlock>
            return ip;
    80003d2e:	bfe9                	j	80003d08 <namex+0x6a>
            iunlockput(ip);
    80003d30:	854e                	mv	a0,s3
    80003d32:	00000097          	auipc	ra,0x0
    80003d36:	c3a080e7          	jalr	-966(ra) # 8000396c <iunlockput>
            return 0;
    80003d3a:	89e6                	mv	s3,s9
    80003d3c:	b7f1                	j	80003d08 <namex+0x6a>
    len = path - s;
    80003d3e:	40b48633          	sub	a2,s1,a1
    80003d42:	00060c9b          	sext.w	s9,a2
    if (len >= DIRSIZ)
    80003d46:	099c5463          	bge	s8,s9,80003dce <namex+0x130>
        memmove(name, s, DIRSIZ);
    80003d4a:	4639                	li	a2,14
    80003d4c:	8552                	mv	a0,s4
    80003d4e:	ffffd097          	auipc	ra,0xffffd
    80003d52:	008080e7          	jalr	8(ra) # 80000d56 <memmove>
    while (*path == '/')
    80003d56:	0004c783          	lbu	a5,0(s1)
    80003d5a:	01279763          	bne	a5,s2,80003d68 <namex+0xca>
        path++;
    80003d5e:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003d60:	0004c783          	lbu	a5,0(s1)
    80003d64:	ff278de3          	beq	a5,s2,80003d5e <namex+0xc0>
        ilock(ip);
    80003d68:	854e                	mv	a0,s3
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	88a080e7          	jalr	-1910(ra) # 800035f4 <ilock>
        if (ip->type != T_DIR)
    80003d72:	04499783          	lh	a5,68(s3)
    80003d76:	f97793e3          	bne	a5,s7,80003cfc <namex+0x5e>
        if (nameiparent && *path == '\0')
    80003d7a:	000a8563          	beqz	s5,80003d84 <namex+0xe6>
    80003d7e:	0004c783          	lbu	a5,0(s1)
    80003d82:	d3cd                	beqz	a5,80003d24 <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    80003d84:	865a                	mv	a2,s6
    80003d86:	85d2                	mv	a1,s4
    80003d88:	854e                	mv	a0,s3
    80003d8a:	00000097          	auipc	ra,0x0
    80003d8e:	e64080e7          	jalr	-412(ra) # 80003bee <dirlookup>
    80003d92:	8caa                	mv	s9,a0
    80003d94:	dd51                	beqz	a0,80003d30 <namex+0x92>
        iunlockput(ip);
    80003d96:	854e                	mv	a0,s3
    80003d98:	00000097          	auipc	ra,0x0
    80003d9c:	bd4080e7          	jalr	-1068(ra) # 8000396c <iunlockput>
        ip = next;
    80003da0:	89e6                	mv	s3,s9
    while (*path == '/')
    80003da2:	0004c783          	lbu	a5,0(s1)
    80003da6:	05279763          	bne	a5,s2,80003df4 <namex+0x156>
        path++;
    80003daa:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003dac:	0004c783          	lbu	a5,0(s1)
    80003db0:	ff278de3          	beq	a5,s2,80003daa <namex+0x10c>
    if (*path == 0)
    80003db4:	c79d                	beqz	a5,80003de2 <namex+0x144>
        path++;
    80003db6:	85a6                	mv	a1,s1
    len = path - s;
    80003db8:	8cda                	mv	s9,s6
    80003dba:	865a                	mv	a2,s6
    while (*path != '/' && *path != 0)
    80003dbc:	01278963          	beq	a5,s2,80003dce <namex+0x130>
    80003dc0:	dfbd                	beqz	a5,80003d3e <namex+0xa0>
        path++;
    80003dc2:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    80003dc4:	0004c783          	lbu	a5,0(s1)
    80003dc8:	ff279ce3          	bne	a5,s2,80003dc0 <namex+0x122>
    80003dcc:	bf8d                	j	80003d3e <namex+0xa0>
        memmove(name, s, len);
    80003dce:	2601                	sext.w	a2,a2
    80003dd0:	8552                	mv	a0,s4
    80003dd2:	ffffd097          	auipc	ra,0xffffd
    80003dd6:	f84080e7          	jalr	-124(ra) # 80000d56 <memmove>
        name[len] = 0;
    80003dda:	9cd2                	add	s9,s9,s4
    80003ddc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003de0:	bf9d                	j	80003d56 <namex+0xb8>
    if (nameiparent)
    80003de2:	f20a83e3          	beqz	s5,80003d08 <namex+0x6a>
        iput(ip);
    80003de6:	854e                	mv	a0,s3
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	adc080e7          	jalr	-1316(ra) # 800038c4 <iput>
        return 0;
    80003df0:	4981                	li	s3,0
    80003df2:	bf19                	j	80003d08 <namex+0x6a>
    if (*path == 0)
    80003df4:	d7fd                	beqz	a5,80003de2 <namex+0x144>
    while (*path != '/' && *path != 0)
    80003df6:	0004c783          	lbu	a5,0(s1)
    80003dfa:	85a6                	mv	a1,s1
    80003dfc:	b7d1                	j	80003dc0 <namex+0x122>

0000000080003dfe <dirlink>:
{
    80003dfe:	7139                	addi	sp,sp,-64
    80003e00:	fc06                	sd	ra,56(sp)
    80003e02:	f822                	sd	s0,48(sp)
    80003e04:	f426                	sd	s1,40(sp)
    80003e06:	f04a                	sd	s2,32(sp)
    80003e08:	ec4e                	sd	s3,24(sp)
    80003e0a:	e852                	sd	s4,16(sp)
    80003e0c:	0080                	addi	s0,sp,64
    80003e0e:	892a                	mv	s2,a0
    80003e10:	8a2e                	mv	s4,a1
    80003e12:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    80003e14:	4601                	li	a2,0
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	dd8080e7          	jalr	-552(ra) # 80003bee <dirlookup>
    80003e1e:	e93d                	bnez	a0,80003e94 <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003e20:	04c92483          	lw	s1,76(s2)
    80003e24:	c49d                	beqz	s1,80003e52 <dirlink+0x54>
    80003e26:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e28:	4741                	li	a4,16
    80003e2a:	86a6                	mv	a3,s1
    80003e2c:	fc040613          	addi	a2,s0,-64
    80003e30:	4581                	li	a1,0
    80003e32:	854a                	mv	a0,s2
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	b92080e7          	jalr	-1134(ra) # 800039c6 <readi>
    80003e3c:	47c1                	li	a5,16
    80003e3e:	06f51163          	bne	a0,a5,80003ea0 <dirlink+0xa2>
        if (de.inum == 0)
    80003e42:	fc045783          	lhu	a5,-64(s0)
    80003e46:	c791                	beqz	a5,80003e52 <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003e48:	24c1                	addiw	s1,s1,16
    80003e4a:	04c92783          	lw	a5,76(s2)
    80003e4e:	fcf4ede3          	bltu	s1,a5,80003e28 <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    80003e52:	4639                	li	a2,14
    80003e54:	85d2                	mv	a1,s4
    80003e56:	fc240513          	addi	a0,s0,-62
    80003e5a:	ffffd097          	auipc	ra,0xffffd
    80003e5e:	fb4080e7          	jalr	-76(ra) # 80000e0e <strncpy>
    de.inum = inum;
    80003e62:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e66:	4741                	li	a4,16
    80003e68:	86a6                	mv	a3,s1
    80003e6a:	fc040613          	addi	a2,s0,-64
    80003e6e:	4581                	li	a1,0
    80003e70:	854a                	mv	a0,s2
    80003e72:	00000097          	auipc	ra,0x0
    80003e76:	c4a080e7          	jalr	-950(ra) # 80003abc <writei>
    80003e7a:	872a                	mv	a4,a0
    80003e7c:	47c1                	li	a5,16
    return 0;
    80003e7e:	4501                	li	a0,0
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e80:	02f71863          	bne	a4,a5,80003eb0 <dirlink+0xb2>
}
    80003e84:	70e2                	ld	ra,56(sp)
    80003e86:	7442                	ld	s0,48(sp)
    80003e88:	74a2                	ld	s1,40(sp)
    80003e8a:	7902                	ld	s2,32(sp)
    80003e8c:	69e2                	ld	s3,24(sp)
    80003e8e:	6a42                	ld	s4,16(sp)
    80003e90:	6121                	addi	sp,sp,64
    80003e92:	8082                	ret
        iput(ip);
    80003e94:	00000097          	auipc	ra,0x0
    80003e98:	a30080e7          	jalr	-1488(ra) # 800038c4 <iput>
        return -1;
    80003e9c:	557d                	li	a0,-1
    80003e9e:	b7dd                	j	80003e84 <dirlink+0x86>
            panic("dirlink read");
    80003ea0:	00005517          	auipc	a0,0x5
    80003ea4:	83850513          	addi	a0,a0,-1992 # 800086d8 <syscalls+0x2b0>
    80003ea8:	ffffc097          	auipc	ra,0xffffc
    80003eac:	69a080e7          	jalr	1690(ra) # 80000542 <panic>
        panic("dirlink");
    80003eb0:	00005517          	auipc	a0,0x5
    80003eb4:	94850513          	addi	a0,a0,-1720 # 800087f8 <syscalls+0x3d0>
    80003eb8:	ffffc097          	auipc	ra,0xffffc
    80003ebc:	68a080e7          	jalr	1674(ra) # 80000542 <panic>

0000000080003ec0 <namei>:

struct inode *namei(char *path)
{
    80003ec0:	1101                	addi	sp,sp,-32
    80003ec2:	ec06                	sd	ra,24(sp)
    80003ec4:	e822                	sd	s0,16(sp)
    80003ec6:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    80003ec8:	fe040613          	addi	a2,s0,-32
    80003ecc:	4581                	li	a1,0
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	dd0080e7          	jalr	-560(ra) # 80003c9e <namex>
}
    80003ed6:	60e2                	ld	ra,24(sp)
    80003ed8:	6442                	ld	s0,16(sp)
    80003eda:	6105                	addi	sp,sp,32
    80003edc:	8082                	ret

0000000080003ede <chperm>:
{
    80003ede:	7151                	addi	sp,sp,-240
    80003ee0:	f586                	sd	ra,232(sp)
    80003ee2:	f1a2                	sd	s0,224(sp)
    80003ee4:	eda6                	sd	s1,216(sp)
    80003ee6:	e9ca                	sd	s2,208(sp)
    80003ee8:	e5ce                	sd	s3,200(sp)
    80003eea:	e1d2                	sd	s4,192(sp)
    80003eec:	fd56                	sd	s5,184(sp)
    80003eee:	f95a                	sd	s6,176(sp)
    80003ef0:	f55e                	sd	s7,168(sp)
    80003ef2:	f162                	sd	s8,160(sp)
    80003ef4:	ed66                	sd	s9,152(sp)
    80003ef6:	e96a                	sd	s10,144(sp)
    80003ef8:	1980                	addi	s0,sp,240
    80003efa:	892a                	mv	s2,a0
    80003efc:	8aae                	mv	s5,a1
    80003efe:	89b2                	mv	s3,a2
    80003f00:	8a36                	mv	s4,a3
    begin_op();
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	382080e7          	jalr	898(ra) # 80004284 <begin_op>
    if ((ip = namei(path)) == 0) {
    80003f0a:	854a                	mv	a0,s2
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	fb4080e7          	jalr	-76(ra) # 80003ec0 <namei>
    80003f14:	c535                	beqz	a0,80003f80 <chperm+0xa2>
    80003f16:	84aa                	mv	s1,a0
    ilock(ip);
    80003f18:	fffff097          	auipc	ra,0xfffff
    80003f1c:	6dc080e7          	jalr	1756(ra) # 800035f4 <ilock>
    if (is_add)
    80003f20:	06098663          	beqz	s3,80003f8c <chperm+0xae>
        ip->perm |= mode;
    80003f24:	0864d783          	lhu	a5,134(s1)
    80003f28:	00fae7b3          	or	a5,s5,a5
    80003f2c:	0107979b          	slliw	a5,a5,0x10
    80003f30:	4107d79b          	sraiw	a5,a5,0x10
    80003f34:	08f49323          	sh	a5,134(s1)
    iupdate(ip);  // 將 inode 寫回磁碟
    80003f38:	8526                	mv	a0,s1
    80003f3a:	fffff097          	auipc	ra,0xfffff
    80003f3e:	5f8080e7          	jalr	1528(ra) # 80003532 <iupdate>
    if (recursive && ip->type == T_DIR) {
    80003f42:	000a0763          	beqz	s4,80003f50 <chperm+0x72>
    80003f46:	04449703          	lh	a4,68(s1)
    80003f4a:	4785                	li	a5,1
    80003f4c:	04f70a63          	beq	a4,a5,80003fa0 <chperm+0xc2>
    iunlockput(ip);
    80003f50:	8526                	mv	a0,s1
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	a1a080e7          	jalr	-1510(ra) # 8000396c <iunlockput>
    end_op();
    80003f5a:	00000097          	auipc	ra,0x0
    80003f5e:	3aa080e7          	jalr	938(ra) # 80004304 <end_op>
    return 0;
    80003f62:	4501                	li	a0,0
}
    80003f64:	70ae                	ld	ra,232(sp)
    80003f66:	740e                	ld	s0,224(sp)
    80003f68:	64ee                	ld	s1,216(sp)
    80003f6a:	694e                	ld	s2,208(sp)
    80003f6c:	69ae                	ld	s3,200(sp)
    80003f6e:	6a0e                	ld	s4,192(sp)
    80003f70:	7aea                	ld	s5,184(sp)
    80003f72:	7b4a                	ld	s6,176(sp)
    80003f74:	7baa                	ld	s7,168(sp)
    80003f76:	7c0a                	ld	s8,160(sp)
    80003f78:	6cea                	ld	s9,152(sp)
    80003f7a:	6d4a                	ld	s10,144(sp)
    80003f7c:	616d                	addi	sp,sp,240
    80003f7e:	8082                	ret
        end_op();
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	384080e7          	jalr	900(ra) # 80004304 <end_op>
        return -1;
    80003f88:	557d                	li	a0,-1
    80003f8a:	bfe9                	j	80003f64 <chperm+0x86>
        ip->perm &= ~mode;
    80003f8c:	fffac793          	not	a5,s5
    80003f90:	0864d703          	lhu	a4,134(s1)
    80003f94:	8ff9                	and	a5,a5,a4
    80003f96:	0107979b          	slliw	a5,a5,0x10
    80003f9a:	4107d79b          	sraiw	a5,a5,0x10
    80003f9e:	bf59                	j	80003f34 <chperm+0x56>
        for (int off = 0; off < ip->size; off += sizeof(de)) {
    80003fa0:	44fc                	lw	a5,76(s1)
    80003fa2:	d7dd                	beqz	a5,80003f50 <chperm+0x72>
    80003fa4:	4b01                	li	s6,0
            if (de.inum == 0 || strncmp(de.name, ".", DIRSIZ) == 0 || strncmp(de.name, "..", DIRSIZ) == 0
    80003fa6:	00004b97          	auipc	s7,0x4
    80003faa:	742b8b93          	addi	s7,s7,1858 # 800086e8 <syscalls+0x2c0>
    80003fae:	00004c17          	auipc	s8,0x4
    80003fb2:	742c0c13          	addi	s8,s8,1858 # 800086f0 <syscalls+0x2c8>
            if (child_path[len - 1] != '/')
    80003fb6:	02f00c93          	li	s9,47
            safestrcpy(child_path + len, de.name, sizeof(child_path) - len);
    80003fba:	08000d13          	li	s10,128
    80003fbe:	a099                	j	80004004 <chperm+0x126>
    80003fc0:	40ad063b          	subw	a2,s10,a0
    80003fc4:	f1240593          	addi	a1,s0,-238
    80003fc8:	f2040793          	addi	a5,s0,-224
    80003fcc:	953e                	add	a0,a0,a5
    80003fce:	ffffd097          	auipc	ra,0xffffd
    80003fd2:	e7e080e7          	jalr	-386(ra) # 80000e4c <safestrcpy>
            iunlock(ip);
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	fffff097          	auipc	ra,0xfffff
    80003fdc:	6d6080e7          	jalr	1750(ra) # 800036ae <iunlock>
            chperm(child_path, mode, is_add, recursive);
    80003fe0:	86d2                	mv	a3,s4
    80003fe2:	864e                	mv	a2,s3
    80003fe4:	85d6                	mv	a1,s5
    80003fe6:	f2040513          	addi	a0,s0,-224
    80003fea:	00000097          	auipc	ra,0x0
    80003fee:	ef4080e7          	jalr	-268(ra) # 80003ede <chperm>
            ilock(ip); // 回到當前目錄，繼續迴圈
    80003ff2:	8526                	mv	a0,s1
    80003ff4:	fffff097          	auipc	ra,0xfffff
    80003ff8:	600080e7          	jalr	1536(ra) # 800035f4 <ilock>
        for (int off = 0; off < ip->size; off += sizeof(de)) {
    80003ffc:	2b41                	addiw	s6,s6,16
    80003ffe:	44fc                	lw	a5,76(s1)
    80004000:	f4fb78e3          	bgeu	s6,a5,80003f50 <chperm+0x72>
            if (readi(ip, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004004:	4741                	li	a4,16
    80004006:	86da                	mv	a3,s6
    80004008:	f1040613          	addi	a2,s0,-240
    8000400c:	4581                	li	a1,0
    8000400e:	8526                	mv	a0,s1
    80004010:	00000097          	auipc	ra,0x0
    80004014:	9b6080e7          	jalr	-1610(ra) # 800039c6 <readi>
    80004018:	47c1                	li	a5,16
    8000401a:	fef511e3          	bne	a0,a5,80003ffc <chperm+0x11e>
            if (de.inum == 0 || strncmp(de.name, ".", DIRSIZ) == 0 || strncmp(de.name, "..", DIRSIZ) == 0
    8000401e:	f1045783          	lhu	a5,-240(s0)
    80004022:	dfe9                	beqz	a5,80003ffc <chperm+0x11e>
    80004024:	4639                	li	a2,14
    80004026:	85de                	mv	a1,s7
    80004028:	f1240513          	addi	a0,s0,-238
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	da6080e7          	jalr	-602(ra) # 80000dd2 <strncmp>
    80004034:	d561                	beqz	a0,80003ffc <chperm+0x11e>
    80004036:	4639                	li	a2,14
    80004038:	85e2                	mv	a1,s8
    8000403a:	f1240513          	addi	a0,s0,-238
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	d94080e7          	jalr	-620(ra) # 80000dd2 <strncmp>
    80004046:	d95d                	beqz	a0,80003ffc <chperm+0x11e>
            memset(child_path, 0, sizeof(child_path));
    80004048:	08000613          	li	a2,128
    8000404c:	4581                	li	a1,0
    8000404e:	f2040513          	addi	a0,s0,-224
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	ca8080e7          	jalr	-856(ra) # 80000cfa <memset>
            safestrcpy(child_path, path, sizeof(child_path));
    8000405a:	08000613          	li	a2,128
    8000405e:	85ca                	mv	a1,s2
    80004060:	f2040513          	addi	a0,s0,-224
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	de8080e7          	jalr	-536(ra) # 80000e4c <safestrcpy>
            int len = strlen(child_path);
    8000406c:	f2040513          	addi	a0,s0,-224
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	e0e080e7          	jalr	-498(ra) # 80000e7e <strlen>
            if (child_path[len - 1] != '/')
    80004078:	fff5079b          	addiw	a5,a0,-1
    8000407c:	fa040713          	addi	a4,s0,-96
    80004080:	97ba                	add	a5,a5,a4
    80004082:	f807c783          	lbu	a5,-128(a5)
    80004086:	f3978de3          	beq	a5,s9,80003fc0 <chperm+0xe2>
                child_path[len++] = '/';
    8000408a:	00a707b3          	add	a5,a4,a0
    8000408e:	f9978023          	sb	s9,-128(a5)
    80004092:	2505                	addiw	a0,a0,1
    80004094:	b735                	j	80003fc0 <chperm+0xe2>

0000000080004096 <nameiparent>:

struct inode *nameiparent(char *path, char *name)
{
    80004096:	1141                	addi	sp,sp,-16
    80004098:	e406                	sd	ra,8(sp)
    8000409a:	e022                	sd	s0,0(sp)
    8000409c:	0800                	addi	s0,sp,16
    8000409e:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800040a0:	4585                	li	a1,1
    800040a2:	00000097          	auipc	ra,0x0
    800040a6:	bfc080e7          	jalr	-1028(ra) # 80003c9e <namex>
}
    800040aa:	60a2                	ld	ra,8(sp)
    800040ac:	6402                	ld	s0,0(sp)
    800040ae:	0141                	addi	sp,sp,16
    800040b0:	8082                	ret

00000000800040b2 <write_head>:

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void)
{
    800040b2:	1101                	addi	sp,sp,-32
    800040b4:	ec06                	sd	ra,24(sp)
    800040b6:	e822                	sd	s0,16(sp)
    800040b8:	e426                	sd	s1,8(sp)
    800040ba:	e04a                	sd	s2,0(sp)
    800040bc:	1000                	addi	s0,sp,32
    struct buf *buf = bread(log.dev, log.start);
    800040be:	0001e917          	auipc	s2,0x1e
    800040c2:	84a90913          	addi	s2,s2,-1974 # 80021908 <log>
    800040c6:	01892583          	lw	a1,24(s2)
    800040ca:	02892503          	lw	a0,40(s2)
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	e94080e7          	jalr	-364(ra) # 80002f62 <bread>
    800040d6:	84aa                	mv	s1,a0
    struct logheader *hb = (struct logheader *)(buf->data);
    int i;
    hb->n = log.lh.n;
    800040d8:	02c92683          	lw	a3,44(s2)
    800040dc:	cd34                	sw	a3,88(a0)
    for (i = 0; i < log.lh.n; i++)
    800040de:	02d05763          	blez	a3,8000410c <write_head+0x5a>
    800040e2:	0001e797          	auipc	a5,0x1e
    800040e6:	85678793          	addi	a5,a5,-1962 # 80021938 <log+0x30>
    800040ea:	05c50713          	addi	a4,a0,92
    800040ee:	36fd                	addiw	a3,a3,-1
    800040f0:	1682                	slli	a3,a3,0x20
    800040f2:	9281                	srli	a3,a3,0x20
    800040f4:	068a                	slli	a3,a3,0x2
    800040f6:	0001e617          	auipc	a2,0x1e
    800040fa:	84660613          	addi	a2,a2,-1978 # 8002193c <log+0x34>
    800040fe:	96b2                	add	a3,a3,a2
    {
        hb->block[i] = log.lh.block[i];
    80004100:	4390                	lw	a2,0(a5)
    80004102:	c310                	sw	a2,0(a4)
    for (i = 0; i < log.lh.n; i++)
    80004104:	0791                	addi	a5,a5,4
    80004106:	0711                	addi	a4,a4,4
    80004108:	fed79ce3          	bne	a5,a3,80004100 <write_head+0x4e>
    }
    bwrite(buf);
    8000410c:	8526                	mv	a0,s1
    8000410e:	fffff097          	auipc	ra,0xfffff
    80004112:	eb2080e7          	jalr	-334(ra) # 80002fc0 <bwrite>
    brelse(buf);
    80004116:	8526                	mv	a0,s1
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	ee6080e7          	jalr	-282(ra) # 80002ffe <brelse>
}
    80004120:	60e2                	ld	ra,24(sp)
    80004122:	6442                	ld	s0,16(sp)
    80004124:	64a2                	ld	s1,8(sp)
    80004126:	6902                	ld	s2,0(sp)
    80004128:	6105                	addi	sp,sp,32
    8000412a:	8082                	ret

000000008000412c <install_trans>:
    for (tail = 0; tail < log.lh.n; tail++)
    8000412c:	0001e797          	auipc	a5,0x1e
    80004130:	8087a783          	lw	a5,-2040(a5) # 80021934 <log+0x2c>
    80004134:	0af05663          	blez	a5,800041e0 <install_trans+0xb4>
{
    80004138:	7139                	addi	sp,sp,-64
    8000413a:	fc06                	sd	ra,56(sp)
    8000413c:	f822                	sd	s0,48(sp)
    8000413e:	f426                	sd	s1,40(sp)
    80004140:	f04a                	sd	s2,32(sp)
    80004142:	ec4e                	sd	s3,24(sp)
    80004144:	e852                	sd	s4,16(sp)
    80004146:	e456                	sd	s5,8(sp)
    80004148:	0080                	addi	s0,sp,64
    8000414a:	0001da97          	auipc	s5,0x1d
    8000414e:	7eea8a93          	addi	s5,s5,2030 # 80021938 <log+0x30>
    for (tail = 0; tail < log.lh.n; tail++)
    80004152:	4a01                	li	s4,0
            bread(log.dev, log.start + tail + 1);              // read log block
    80004154:	0001d997          	auipc	s3,0x1d
    80004158:	7b498993          	addi	s3,s3,1972 # 80021908 <log>
    8000415c:	0189a583          	lw	a1,24(s3)
    80004160:	014585bb          	addw	a1,a1,s4
    80004164:	2585                	addiw	a1,a1,1
    80004166:	0289a503          	lw	a0,40(s3)
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	df8080e7          	jalr	-520(ra) # 80002f62 <bread>
    80004172:	892a                	mv	s2,a0
        struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004174:	000aa583          	lw	a1,0(s5)
    80004178:	0289a503          	lw	a0,40(s3)
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	de6080e7          	jalr	-538(ra) # 80002f62 <bread>
    80004184:	84aa                	mv	s1,a0
        memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80004186:	40000613          	li	a2,1024
    8000418a:	05890593          	addi	a1,s2,88
    8000418e:	05850513          	addi	a0,a0,88
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	bc4080e7          	jalr	-1084(ra) # 80000d56 <memmove>
        bwrite(dbuf);                           // write dst to disk
    8000419a:	8526                	mv	a0,s1
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	e24080e7          	jalr	-476(ra) # 80002fc0 <bwrite>
        bunpin(dbuf);
    800041a4:	8526                	mv	a0,s1
    800041a6:	fffff097          	auipc	ra,0xfffff
    800041aa:	f32080e7          	jalr	-206(ra) # 800030d8 <bunpin>
        brelse(lbuf);
    800041ae:	854a                	mv	a0,s2
    800041b0:	fffff097          	auipc	ra,0xfffff
    800041b4:	e4e080e7          	jalr	-434(ra) # 80002ffe <brelse>
        brelse(dbuf);
    800041b8:	8526                	mv	a0,s1
    800041ba:	fffff097          	auipc	ra,0xfffff
    800041be:	e44080e7          	jalr	-444(ra) # 80002ffe <brelse>
    for (tail = 0; tail < log.lh.n; tail++)
    800041c2:	2a05                	addiw	s4,s4,1
    800041c4:	0a91                	addi	s5,s5,4
    800041c6:	02c9a783          	lw	a5,44(s3)
    800041ca:	f8fa49e3          	blt	s4,a5,8000415c <install_trans+0x30>
}
    800041ce:	70e2                	ld	ra,56(sp)
    800041d0:	7442                	ld	s0,48(sp)
    800041d2:	74a2                	ld	s1,40(sp)
    800041d4:	7902                	ld	s2,32(sp)
    800041d6:	69e2                	ld	s3,24(sp)
    800041d8:	6a42                	ld	s4,16(sp)
    800041da:	6aa2                	ld	s5,8(sp)
    800041dc:	6121                	addi	sp,sp,64
    800041de:	8082                	ret
    800041e0:	8082                	ret

00000000800041e2 <initlog>:
{
    800041e2:	7179                	addi	sp,sp,-48
    800041e4:	f406                	sd	ra,40(sp)
    800041e6:	f022                	sd	s0,32(sp)
    800041e8:	ec26                	sd	s1,24(sp)
    800041ea:	e84a                	sd	s2,16(sp)
    800041ec:	e44e                	sd	s3,8(sp)
    800041ee:	1800                	addi	s0,sp,48
    800041f0:	892a                	mv	s2,a0
    800041f2:	89ae                	mv	s3,a1
    initlock(&log.lock, "log");
    800041f4:	0001d497          	auipc	s1,0x1d
    800041f8:	71448493          	addi	s1,s1,1812 # 80021908 <log>
    800041fc:	00004597          	auipc	a1,0x4
    80004200:	4fc58593          	addi	a1,a1,1276 # 800086f8 <syscalls+0x2d0>
    80004204:	8526                	mv	a0,s1
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	968080e7          	jalr	-1688(ra) # 80000b6e <initlock>
    log.start = sb->logstart;
    8000420e:	0149a583          	lw	a1,20(s3)
    80004212:	cc8c                	sw	a1,24(s1)
    log.size = sb->nlog;
    80004214:	0109a783          	lw	a5,16(s3)
    80004218:	ccdc                	sw	a5,28(s1)
    log.dev = dev;
    8000421a:	0324a423          	sw	s2,40(s1)
    struct buf *buf = bread(log.dev, log.start);
    8000421e:	854a                	mv	a0,s2
    80004220:	fffff097          	auipc	ra,0xfffff
    80004224:	d42080e7          	jalr	-702(ra) # 80002f62 <bread>
    log.lh.n = lh->n;
    80004228:	4d34                	lw	a3,88(a0)
    8000422a:	d4d4                	sw	a3,44(s1)
    for (i = 0; i < log.lh.n; i++)
    8000422c:	02d05563          	blez	a3,80004256 <initlog+0x74>
    80004230:	05c50793          	addi	a5,a0,92
    80004234:	0001d717          	auipc	a4,0x1d
    80004238:	70470713          	addi	a4,a4,1796 # 80021938 <log+0x30>
    8000423c:	36fd                	addiw	a3,a3,-1
    8000423e:	1682                	slli	a3,a3,0x20
    80004240:	9281                	srli	a3,a3,0x20
    80004242:	068a                	slli	a3,a3,0x2
    80004244:	06050613          	addi	a2,a0,96
    80004248:	96b2                	add	a3,a3,a2
        log.lh.block[i] = lh->block[i];
    8000424a:	4390                	lw	a2,0(a5)
    8000424c:	c310                	sw	a2,0(a4)
    for (i = 0; i < log.lh.n; i++)
    8000424e:	0791                	addi	a5,a5,4
    80004250:	0711                	addi	a4,a4,4
    80004252:	fed79ce3          	bne	a5,a3,8000424a <initlog+0x68>
    brelse(buf);
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	da8080e7          	jalr	-600(ra) # 80002ffe <brelse>

static void recover_from_log(void)
{
    read_head();
    install_trans(); // if committed, copy from log to disk
    8000425e:	00000097          	auipc	ra,0x0
    80004262:	ece080e7          	jalr	-306(ra) # 8000412c <install_trans>
    log.lh.n = 0;
    80004266:	0001d797          	auipc	a5,0x1d
    8000426a:	6c07a723          	sw	zero,1742(a5) # 80021934 <log+0x2c>
    write_head(); // clear the log
    8000426e:	00000097          	auipc	ra,0x0
    80004272:	e44080e7          	jalr	-444(ra) # 800040b2 <write_head>
}
    80004276:	70a2                	ld	ra,40(sp)
    80004278:	7402                	ld	s0,32(sp)
    8000427a:	64e2                	ld	s1,24(sp)
    8000427c:	6942                	ld	s2,16(sp)
    8000427e:	69a2                	ld	s3,8(sp)
    80004280:	6145                	addi	sp,sp,48
    80004282:	8082                	ret

0000000080004284 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void)
{
    80004284:	1101                	addi	sp,sp,-32
    80004286:	ec06                	sd	ra,24(sp)
    80004288:	e822                	sd	s0,16(sp)
    8000428a:	e426                	sd	s1,8(sp)
    8000428c:	e04a                	sd	s2,0(sp)
    8000428e:	1000                	addi	s0,sp,32
    acquire(&log.lock);
    80004290:	0001d517          	auipc	a0,0x1d
    80004294:	67850513          	addi	a0,a0,1656 # 80021908 <log>
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	966080e7          	jalr	-1690(ra) # 80000bfe <acquire>
    while (1)
    {
        if (log.committing)
    800042a0:	0001d497          	auipc	s1,0x1d
    800042a4:	66848493          	addi	s1,s1,1640 # 80021908 <log>
        {
            sleep(&log, &log.lock);
        }
        else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE)
    800042a8:	4979                	li	s2,30
    800042aa:	a039                	j	800042b8 <begin_op+0x34>
            sleep(&log, &log.lock);
    800042ac:	85a6                	mv	a1,s1
    800042ae:	8526                	mv	a0,s1
    800042b0:	ffffe097          	auipc	ra,0xffffe
    800042b4:	f2a080e7          	jalr	-214(ra) # 800021da <sleep>
        if (log.committing)
    800042b8:	50dc                	lw	a5,36(s1)
    800042ba:	fbed                	bnez	a5,800042ac <begin_op+0x28>
        else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE)
    800042bc:	509c                	lw	a5,32(s1)
    800042be:	0017871b          	addiw	a4,a5,1
    800042c2:	0007069b          	sext.w	a3,a4
    800042c6:	0027179b          	slliw	a5,a4,0x2
    800042ca:	9fb9                	addw	a5,a5,a4
    800042cc:	0017979b          	slliw	a5,a5,0x1
    800042d0:	54d8                	lw	a4,44(s1)
    800042d2:	9fb9                	addw	a5,a5,a4
    800042d4:	00f95963          	bge	s2,a5,800042e6 <begin_op+0x62>
        {
            // this op might exhaust log space; wait for commit.
            sleep(&log, &log.lock);
    800042d8:	85a6                	mv	a1,s1
    800042da:	8526                	mv	a0,s1
    800042dc:	ffffe097          	auipc	ra,0xffffe
    800042e0:	efe080e7          	jalr	-258(ra) # 800021da <sleep>
    800042e4:	bfd1                	j	800042b8 <begin_op+0x34>
        }
        else
        {
            log.outstanding += 1;
    800042e6:	0001d517          	auipc	a0,0x1d
    800042ea:	62250513          	addi	a0,a0,1570 # 80021908 <log>
    800042ee:	d114                	sw	a3,32(a0)
            release(&log.lock);
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	9c2080e7          	jalr	-1598(ra) # 80000cb2 <release>
            break;
        }
    }
}
    800042f8:	60e2                	ld	ra,24(sp)
    800042fa:	6442                	ld	s0,16(sp)
    800042fc:	64a2                	ld	s1,8(sp)
    800042fe:	6902                	ld	s2,0(sp)
    80004300:	6105                	addi	sp,sp,32
    80004302:	8082                	ret

0000000080004304 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void)
{
    80004304:	7139                	addi	sp,sp,-64
    80004306:	fc06                	sd	ra,56(sp)
    80004308:	f822                	sd	s0,48(sp)
    8000430a:	f426                	sd	s1,40(sp)
    8000430c:	f04a                	sd	s2,32(sp)
    8000430e:	ec4e                	sd	s3,24(sp)
    80004310:	e852                	sd	s4,16(sp)
    80004312:	e456                	sd	s5,8(sp)
    80004314:	0080                	addi	s0,sp,64
    int do_commit = 0;

    acquire(&log.lock);
    80004316:	0001d497          	auipc	s1,0x1d
    8000431a:	5f248493          	addi	s1,s1,1522 # 80021908 <log>
    8000431e:	8526                	mv	a0,s1
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	8de080e7          	jalr	-1826(ra) # 80000bfe <acquire>
    log.outstanding -= 1;
    80004328:	509c                	lw	a5,32(s1)
    8000432a:	37fd                	addiw	a5,a5,-1
    8000432c:	0007891b          	sext.w	s2,a5
    80004330:	d09c                	sw	a5,32(s1)
    if (log.committing)
    80004332:	50dc                	lw	a5,36(s1)
    80004334:	e7b9                	bnez	a5,80004382 <end_op+0x7e>
        panic("log.committing");
    if (log.outstanding == 0)
    80004336:	04091e63          	bnez	s2,80004392 <end_op+0x8e>
    {
        do_commit = 1;
        log.committing = 1;
    8000433a:	0001d497          	auipc	s1,0x1d
    8000433e:	5ce48493          	addi	s1,s1,1486 # 80021908 <log>
    80004342:	4785                	li	a5,1
    80004344:	d0dc                	sw	a5,36(s1)
        // begin_op() may be waiting for log space,
        // and decrementing log.outstanding has decreased
        // the amount of reserved space.
        wakeup(&log);
    }
    release(&log.lock);
    80004346:	8526                	mv	a0,s1
    80004348:	ffffd097          	auipc	ra,0xffffd
    8000434c:	96a080e7          	jalr	-1686(ra) # 80000cb2 <release>
    }
}

static void commit()
{
    if (log.lh.n > 0)
    80004350:	54dc                	lw	a5,44(s1)
    80004352:	06f04763          	bgtz	a5,800043c0 <end_op+0xbc>
        acquire(&log.lock);
    80004356:	0001d497          	auipc	s1,0x1d
    8000435a:	5b248493          	addi	s1,s1,1458 # 80021908 <log>
    8000435e:	8526                	mv	a0,s1
    80004360:	ffffd097          	auipc	ra,0xffffd
    80004364:	89e080e7          	jalr	-1890(ra) # 80000bfe <acquire>
        log.committing = 0;
    80004368:	0204a223          	sw	zero,36(s1)
        wakeup(&log);
    8000436c:	8526                	mv	a0,s1
    8000436e:	ffffe097          	auipc	ra,0xffffe
    80004372:	fec080e7          	jalr	-20(ra) # 8000235a <wakeup>
        release(&log.lock);
    80004376:	8526                	mv	a0,s1
    80004378:	ffffd097          	auipc	ra,0xffffd
    8000437c:	93a080e7          	jalr	-1734(ra) # 80000cb2 <release>
}
    80004380:	a03d                	j	800043ae <end_op+0xaa>
        panic("log.committing");
    80004382:	00004517          	auipc	a0,0x4
    80004386:	37e50513          	addi	a0,a0,894 # 80008700 <syscalls+0x2d8>
    8000438a:	ffffc097          	auipc	ra,0xffffc
    8000438e:	1b8080e7          	jalr	440(ra) # 80000542 <panic>
        wakeup(&log);
    80004392:	0001d497          	auipc	s1,0x1d
    80004396:	57648493          	addi	s1,s1,1398 # 80021908 <log>
    8000439a:	8526                	mv	a0,s1
    8000439c:	ffffe097          	auipc	ra,0xffffe
    800043a0:	fbe080e7          	jalr	-66(ra) # 8000235a <wakeup>
    release(&log.lock);
    800043a4:	8526                	mv	a0,s1
    800043a6:	ffffd097          	auipc	ra,0xffffd
    800043aa:	90c080e7          	jalr	-1780(ra) # 80000cb2 <release>
}
    800043ae:	70e2                	ld	ra,56(sp)
    800043b0:	7442                	ld	s0,48(sp)
    800043b2:	74a2                	ld	s1,40(sp)
    800043b4:	7902                	ld	s2,32(sp)
    800043b6:	69e2                	ld	s3,24(sp)
    800043b8:	6a42                	ld	s4,16(sp)
    800043ba:	6aa2                	ld	s5,8(sp)
    800043bc:	6121                	addi	sp,sp,64
    800043be:	8082                	ret
    for (tail = 0; tail < log.lh.n; tail++)
    800043c0:	0001da97          	auipc	s5,0x1d
    800043c4:	578a8a93          	addi	s5,s5,1400 # 80021938 <log+0x30>
        struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    800043c8:	0001da17          	auipc	s4,0x1d
    800043cc:	540a0a13          	addi	s4,s4,1344 # 80021908 <log>
    800043d0:	018a2583          	lw	a1,24(s4)
    800043d4:	012585bb          	addw	a1,a1,s2
    800043d8:	2585                	addiw	a1,a1,1
    800043da:	028a2503          	lw	a0,40(s4)
    800043de:	fffff097          	auipc	ra,0xfffff
    800043e2:	b84080e7          	jalr	-1148(ra) # 80002f62 <bread>
    800043e6:	84aa                	mv	s1,a0
        struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800043e8:	000aa583          	lw	a1,0(s5)
    800043ec:	028a2503          	lw	a0,40(s4)
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	b72080e7          	jalr	-1166(ra) # 80002f62 <bread>
    800043f8:	89aa                	mv	s3,a0
        memmove(to->data, from->data, BSIZE);
    800043fa:	40000613          	li	a2,1024
    800043fe:	05850593          	addi	a1,a0,88
    80004402:	05848513          	addi	a0,s1,88
    80004406:	ffffd097          	auipc	ra,0xffffd
    8000440a:	950080e7          	jalr	-1712(ra) # 80000d56 <memmove>
        bwrite(to); // write the log
    8000440e:	8526                	mv	a0,s1
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	bb0080e7          	jalr	-1104(ra) # 80002fc0 <bwrite>
        brelse(from);
    80004418:	854e                	mv	a0,s3
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	be4080e7          	jalr	-1052(ra) # 80002ffe <brelse>
        brelse(to);
    80004422:	8526                	mv	a0,s1
    80004424:	fffff097          	auipc	ra,0xfffff
    80004428:	bda080e7          	jalr	-1062(ra) # 80002ffe <brelse>
    for (tail = 0; tail < log.lh.n; tail++)
    8000442c:	2905                	addiw	s2,s2,1
    8000442e:	0a91                	addi	s5,s5,4
    80004430:	02ca2783          	lw	a5,44(s4)
    80004434:	f8f94ee3          	blt	s2,a5,800043d0 <end_op+0xcc>
    {
        write_log();     // Write modified blocks from cache to log
        write_head();    // Write header to disk -- the real commit
    80004438:	00000097          	auipc	ra,0x0
    8000443c:	c7a080e7          	jalr	-902(ra) # 800040b2 <write_head>
        install_trans(); // Now install writes to home locations
    80004440:	00000097          	auipc	ra,0x0
    80004444:	cec080e7          	jalr	-788(ra) # 8000412c <install_trans>
        log.lh.n = 0;
    80004448:	0001d797          	auipc	a5,0x1d
    8000444c:	4e07a623          	sw	zero,1260(a5) # 80021934 <log+0x2c>
        write_head(); // Erase the transaction from the log
    80004450:	00000097          	auipc	ra,0x0
    80004454:	c62080e7          	jalr	-926(ra) # 800040b2 <write_head>
    80004458:	bdfd                	j	80004356 <end_op+0x52>

000000008000445a <log_write>:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b)
{
    8000445a:	1101                	addi	sp,sp,-32
    8000445c:	ec06                	sd	ra,24(sp)
    8000445e:	e822                	sd	s0,16(sp)
    80004460:	e426                	sd	s1,8(sp)
    80004462:	e04a                	sd	s2,0(sp)
    80004464:	1000                	addi	s0,sp,32
    int i;

    if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004466:	0001d717          	auipc	a4,0x1d
    8000446a:	4ce72703          	lw	a4,1230(a4) # 80021934 <log+0x2c>
    8000446e:	47f5                	li	a5,29
    80004470:	08e7c063          	blt	a5,a4,800044f0 <log_write+0x96>
    80004474:	84aa                	mv	s1,a0
    80004476:	0001d797          	auipc	a5,0x1d
    8000447a:	4ae7a783          	lw	a5,1198(a5) # 80021924 <log+0x1c>
    8000447e:	37fd                	addiw	a5,a5,-1
    80004480:	06f75863          	bge	a4,a5,800044f0 <log_write+0x96>
        panic("too big a transaction");
    if (log.outstanding < 1)
    80004484:	0001d797          	auipc	a5,0x1d
    80004488:	4a47a783          	lw	a5,1188(a5) # 80021928 <log+0x20>
    8000448c:	06f05a63          	blez	a5,80004500 <log_write+0xa6>
        panic("log_write outside of trans");

    acquire(&log.lock);
    80004490:	0001d917          	auipc	s2,0x1d
    80004494:	47890913          	addi	s2,s2,1144 # 80021908 <log>
    80004498:	854a                	mv	a0,s2
    8000449a:	ffffc097          	auipc	ra,0xffffc
    8000449e:	764080e7          	jalr	1892(ra) # 80000bfe <acquire>
    for (i = 0; i < log.lh.n; i++)
    800044a2:	02c92603          	lw	a2,44(s2)
    800044a6:	06c05563          	blez	a2,80004510 <log_write+0xb6>
    {
        if (log.lh.block[i] == b->blockno) // log absorbtion
    800044aa:	44cc                	lw	a1,12(s1)
    800044ac:	0001d717          	auipc	a4,0x1d
    800044b0:	48c70713          	addi	a4,a4,1164 # 80021938 <log+0x30>
    for (i = 0; i < log.lh.n; i++)
    800044b4:	4781                	li	a5,0
        if (log.lh.block[i] == b->blockno) // log absorbtion
    800044b6:	4314                	lw	a3,0(a4)
    800044b8:	04b68d63          	beq	a3,a1,80004512 <log_write+0xb8>
    for (i = 0; i < log.lh.n; i++)
    800044bc:	2785                	addiw	a5,a5,1
    800044be:	0711                	addi	a4,a4,4
    800044c0:	fec79be3          	bne	a5,a2,800044b6 <log_write+0x5c>
            break;
    }
    log.lh.block[i] = b->blockno;
    800044c4:	0621                	addi	a2,a2,8
    800044c6:	060a                	slli	a2,a2,0x2
    800044c8:	0001d797          	auipc	a5,0x1d
    800044cc:	44078793          	addi	a5,a5,1088 # 80021908 <log>
    800044d0:	963e                	add	a2,a2,a5
    800044d2:	44dc                	lw	a5,12(s1)
    800044d4:	ca1c                	sw	a5,16(a2)
    if (i == log.lh.n)
    { // Add new block to log?
        bpin(b);
    800044d6:	8526                	mv	a0,s1
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	bc4080e7          	jalr	-1084(ra) # 8000309c <bpin>
        log.lh.n++;
    800044e0:	0001d717          	auipc	a4,0x1d
    800044e4:	42870713          	addi	a4,a4,1064 # 80021908 <log>
    800044e8:	575c                	lw	a5,44(a4)
    800044ea:	2785                	addiw	a5,a5,1
    800044ec:	d75c                	sw	a5,44(a4)
    800044ee:	a83d                	j	8000452c <log_write+0xd2>
        panic("too big a transaction");
    800044f0:	00004517          	auipc	a0,0x4
    800044f4:	22050513          	addi	a0,a0,544 # 80008710 <syscalls+0x2e8>
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	04a080e7          	jalr	74(ra) # 80000542 <panic>
        panic("log_write outside of trans");
    80004500:	00004517          	auipc	a0,0x4
    80004504:	22850513          	addi	a0,a0,552 # 80008728 <syscalls+0x300>
    80004508:	ffffc097          	auipc	ra,0xffffc
    8000450c:	03a080e7          	jalr	58(ra) # 80000542 <panic>
    for (i = 0; i < log.lh.n; i++)
    80004510:	4781                	li	a5,0
    log.lh.block[i] = b->blockno;
    80004512:	00878713          	addi	a4,a5,8
    80004516:	00271693          	slli	a3,a4,0x2
    8000451a:	0001d717          	auipc	a4,0x1d
    8000451e:	3ee70713          	addi	a4,a4,1006 # 80021908 <log>
    80004522:	9736                	add	a4,a4,a3
    80004524:	44d4                	lw	a3,12(s1)
    80004526:	cb14                	sw	a3,16(a4)
    if (i == log.lh.n)
    80004528:	faf607e3          	beq	a2,a5,800044d6 <log_write+0x7c>
    }
    release(&log.lock);
    8000452c:	0001d517          	auipc	a0,0x1d
    80004530:	3dc50513          	addi	a0,a0,988 # 80021908 <log>
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	77e080e7          	jalr	1918(ra) # 80000cb2 <release>
}
    8000453c:	60e2                	ld	ra,24(sp)
    8000453e:	6442                	ld	s0,16(sp)
    80004540:	64a2                	ld	s1,8(sp)
    80004542:	6902                	ld	s2,0(sp)
    80004544:	6105                	addi	sp,sp,32
    80004546:	8082                	ret

0000000080004548 <initsleeplock>:
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name)
{
    80004548:	1101                	addi	sp,sp,-32
    8000454a:	ec06                	sd	ra,24(sp)
    8000454c:	e822                	sd	s0,16(sp)
    8000454e:	e426                	sd	s1,8(sp)
    80004550:	e04a                	sd	s2,0(sp)
    80004552:	1000                	addi	s0,sp,32
    80004554:	84aa                	mv	s1,a0
    80004556:	892e                	mv	s2,a1
    initlock(&lk->lk, "sleep lock");
    80004558:	00004597          	auipc	a1,0x4
    8000455c:	1f058593          	addi	a1,a1,496 # 80008748 <syscalls+0x320>
    80004560:	0521                	addi	a0,a0,8
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	60c080e7          	jalr	1548(ra) # 80000b6e <initlock>
    lk->name = name;
    8000456a:	0324b023          	sd	s2,32(s1)
    lk->locked = 0;
    8000456e:	0004a023          	sw	zero,0(s1)
    lk->pid = 0;
    80004572:	0204a423          	sw	zero,40(s1)
}
    80004576:	60e2                	ld	ra,24(sp)
    80004578:	6442                	ld	s0,16(sp)
    8000457a:	64a2                	ld	s1,8(sp)
    8000457c:	6902                	ld	s2,0(sp)
    8000457e:	6105                	addi	sp,sp,32
    80004580:	8082                	ret

0000000080004582 <acquiresleep>:

void acquiresleep(struct sleeplock *lk)
{
    80004582:	1101                	addi	sp,sp,-32
    80004584:	ec06                	sd	ra,24(sp)
    80004586:	e822                	sd	s0,16(sp)
    80004588:	e426                	sd	s1,8(sp)
    8000458a:	e04a                	sd	s2,0(sp)
    8000458c:	1000                	addi	s0,sp,32
    8000458e:	84aa                	mv	s1,a0
    acquire(&lk->lk);
    80004590:	00850913          	addi	s2,a0,8
    80004594:	854a                	mv	a0,s2
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	668080e7          	jalr	1640(ra) # 80000bfe <acquire>
    while (lk->locked)
    8000459e:	409c                	lw	a5,0(s1)
    800045a0:	cb89                	beqz	a5,800045b2 <acquiresleep+0x30>
    {
        sleep(lk, &lk->lk);
    800045a2:	85ca                	mv	a1,s2
    800045a4:	8526                	mv	a0,s1
    800045a6:	ffffe097          	auipc	ra,0xffffe
    800045aa:	c34080e7          	jalr	-972(ra) # 800021da <sleep>
    while (lk->locked)
    800045ae:	409c                	lw	a5,0(s1)
    800045b0:	fbed                	bnez	a5,800045a2 <acquiresleep+0x20>
    }
    lk->locked = 1;
    800045b2:	4785                	li	a5,1
    800045b4:	c09c                	sw	a5,0(s1)
    lk->pid = myproc()->pid;
    800045b6:	ffffd097          	auipc	ra,0xffffd
    800045ba:	414080e7          	jalr	1044(ra) # 800019ca <myproc>
    800045be:	5d1c                	lw	a5,56(a0)
    800045c0:	d49c                	sw	a5,40(s1)
    release(&lk->lk);
    800045c2:	854a                	mv	a0,s2
    800045c4:	ffffc097          	auipc	ra,0xffffc
    800045c8:	6ee080e7          	jalr	1774(ra) # 80000cb2 <release>
}
    800045cc:	60e2                	ld	ra,24(sp)
    800045ce:	6442                	ld	s0,16(sp)
    800045d0:	64a2                	ld	s1,8(sp)
    800045d2:	6902                	ld	s2,0(sp)
    800045d4:	6105                	addi	sp,sp,32
    800045d6:	8082                	ret

00000000800045d8 <releasesleep>:

void releasesleep(struct sleeplock *lk)
{
    800045d8:	1101                	addi	sp,sp,-32
    800045da:	ec06                	sd	ra,24(sp)
    800045dc:	e822                	sd	s0,16(sp)
    800045de:	e426                	sd	s1,8(sp)
    800045e0:	e04a                	sd	s2,0(sp)
    800045e2:	1000                	addi	s0,sp,32
    800045e4:	84aa                	mv	s1,a0
    acquire(&lk->lk);
    800045e6:	00850913          	addi	s2,a0,8
    800045ea:	854a                	mv	a0,s2
    800045ec:	ffffc097          	auipc	ra,0xffffc
    800045f0:	612080e7          	jalr	1554(ra) # 80000bfe <acquire>
    lk->locked = 0;
    800045f4:	0004a023          	sw	zero,0(s1)
    lk->pid = 0;
    800045f8:	0204a423          	sw	zero,40(s1)
    wakeup(lk);
    800045fc:	8526                	mv	a0,s1
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	d5c080e7          	jalr	-676(ra) # 8000235a <wakeup>
    release(&lk->lk);
    80004606:	854a                	mv	a0,s2
    80004608:	ffffc097          	auipc	ra,0xffffc
    8000460c:	6aa080e7          	jalr	1706(ra) # 80000cb2 <release>
}
    80004610:	60e2                	ld	ra,24(sp)
    80004612:	6442                	ld	s0,16(sp)
    80004614:	64a2                	ld	s1,8(sp)
    80004616:	6902                	ld	s2,0(sp)
    80004618:	6105                	addi	sp,sp,32
    8000461a:	8082                	ret

000000008000461c <holdingsleep>:

int holdingsleep(struct sleeplock *lk)
{
    8000461c:	7179                	addi	sp,sp,-48
    8000461e:	f406                	sd	ra,40(sp)
    80004620:	f022                	sd	s0,32(sp)
    80004622:	ec26                	sd	s1,24(sp)
    80004624:	e84a                	sd	s2,16(sp)
    80004626:	e44e                	sd	s3,8(sp)
    80004628:	1800                	addi	s0,sp,48
    8000462a:	84aa                	mv	s1,a0
    int r;

    acquire(&lk->lk);
    8000462c:	00850913          	addi	s2,a0,8
    80004630:	854a                	mv	a0,s2
    80004632:	ffffc097          	auipc	ra,0xffffc
    80004636:	5cc080e7          	jalr	1484(ra) # 80000bfe <acquire>
    r = lk->locked && (lk->pid == myproc()->pid);
    8000463a:	409c                	lw	a5,0(s1)
    8000463c:	ef99                	bnez	a5,8000465a <holdingsleep+0x3e>
    8000463e:	4481                	li	s1,0
    release(&lk->lk);
    80004640:	854a                	mv	a0,s2
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	670080e7          	jalr	1648(ra) # 80000cb2 <release>
    return r;
}
    8000464a:	8526                	mv	a0,s1
    8000464c:	70a2                	ld	ra,40(sp)
    8000464e:	7402                	ld	s0,32(sp)
    80004650:	64e2                	ld	s1,24(sp)
    80004652:	6942                	ld	s2,16(sp)
    80004654:	69a2                	ld	s3,8(sp)
    80004656:	6145                	addi	sp,sp,48
    80004658:	8082                	ret
    r = lk->locked && (lk->pid == myproc()->pid);
    8000465a:	0284a983          	lw	s3,40(s1)
    8000465e:	ffffd097          	auipc	ra,0xffffd
    80004662:	36c080e7          	jalr	876(ra) # 800019ca <myproc>
    80004666:	5d04                	lw	s1,56(a0)
    80004668:	413484b3          	sub	s1,s1,s3
    8000466c:	0014b493          	seqz	s1,s1
    80004670:	bfc1                	j	80004640 <holdingsleep+0x24>

0000000080004672 <fileinit>:
{
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    80004672:	1141                	addi	sp,sp,-16
    80004674:	e406                	sd	ra,8(sp)
    80004676:	e022                	sd	s0,0(sp)
    80004678:	0800                	addi	s0,sp,16
    8000467a:	00004597          	auipc	a1,0x4
    8000467e:	0de58593          	addi	a1,a1,222 # 80008758 <syscalls+0x330>
    80004682:	0001d517          	auipc	a0,0x1d
    80004686:	3ce50513          	addi	a0,a0,974 # 80021a50 <ftable>
    8000468a:	ffffc097          	auipc	ra,0xffffc
    8000468e:	4e4080e7          	jalr	1252(ra) # 80000b6e <initlock>
    80004692:	60a2                	ld	ra,8(sp)
    80004694:	6402                	ld	s0,0(sp)
    80004696:	0141                	addi	sp,sp,16
    80004698:	8082                	ret

000000008000469a <filealloc>:

// Allocate a file structure.
struct file *filealloc(void)
{
    8000469a:	1101                	addi	sp,sp,-32
    8000469c:	ec06                	sd	ra,24(sp)
    8000469e:	e822                	sd	s0,16(sp)
    800046a0:	e426                	sd	s1,8(sp)
    800046a2:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    800046a4:	0001d517          	auipc	a0,0x1d
    800046a8:	3ac50513          	addi	a0,a0,940 # 80021a50 <ftable>
    800046ac:	ffffc097          	auipc	ra,0xffffc
    800046b0:	552080e7          	jalr	1362(ra) # 80000bfe <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    800046b4:	0001d497          	auipc	s1,0x1d
    800046b8:	3b448493          	addi	s1,s1,948 # 80021a68 <ftable+0x18>
    800046bc:	0001e717          	auipc	a4,0x1e
    800046c0:	34c70713          	addi	a4,a4,844 # 80022a08 <ftable+0xfb8>
    {
        if (f->ref == 0)
    800046c4:	40dc                	lw	a5,4(s1)
    800046c6:	cf99                	beqz	a5,800046e4 <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    800046c8:	02848493          	addi	s1,s1,40
    800046cc:	fee49ce3          	bne	s1,a4,800046c4 <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    800046d0:	0001d517          	auipc	a0,0x1d
    800046d4:	38050513          	addi	a0,a0,896 # 80021a50 <ftable>
    800046d8:	ffffc097          	auipc	ra,0xffffc
    800046dc:	5da080e7          	jalr	1498(ra) # 80000cb2 <release>
    return 0;
    800046e0:	4481                	li	s1,0
    800046e2:	a819                	j	800046f8 <filealloc+0x5e>
            f->ref = 1;
    800046e4:	4785                	li	a5,1
    800046e6:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    800046e8:	0001d517          	auipc	a0,0x1d
    800046ec:	36850513          	addi	a0,a0,872 # 80021a50 <ftable>
    800046f0:	ffffc097          	auipc	ra,0xffffc
    800046f4:	5c2080e7          	jalr	1474(ra) # 80000cb2 <release>
}
    800046f8:	8526                	mv	a0,s1
    800046fa:	60e2                	ld	ra,24(sp)
    800046fc:	6442                	ld	s0,16(sp)
    800046fe:	64a2                	ld	s1,8(sp)
    80004700:	6105                	addi	sp,sp,32
    80004702:	8082                	ret

0000000080004704 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f)
{
    80004704:	1101                	addi	sp,sp,-32
    80004706:	ec06                	sd	ra,24(sp)
    80004708:	e822                	sd	s0,16(sp)
    8000470a:	e426                	sd	s1,8(sp)
    8000470c:	1000                	addi	s0,sp,32
    8000470e:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80004710:	0001d517          	auipc	a0,0x1d
    80004714:	34050513          	addi	a0,a0,832 # 80021a50 <ftable>
    80004718:	ffffc097          	auipc	ra,0xffffc
    8000471c:	4e6080e7          	jalr	1254(ra) # 80000bfe <acquire>
    if (f->ref < 1)
    80004720:	40dc                	lw	a5,4(s1)
    80004722:	02f05263          	blez	a5,80004746 <filedup+0x42>
        panic("filedup");
    f->ref++;
    80004726:	2785                	addiw	a5,a5,1
    80004728:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    8000472a:	0001d517          	auipc	a0,0x1d
    8000472e:	32650513          	addi	a0,a0,806 # 80021a50 <ftable>
    80004732:	ffffc097          	auipc	ra,0xffffc
    80004736:	580080e7          	jalr	1408(ra) # 80000cb2 <release>
    return f;
}
    8000473a:	8526                	mv	a0,s1
    8000473c:	60e2                	ld	ra,24(sp)
    8000473e:	6442                	ld	s0,16(sp)
    80004740:	64a2                	ld	s1,8(sp)
    80004742:	6105                	addi	sp,sp,32
    80004744:	8082                	ret
        panic("filedup");
    80004746:	00004517          	auipc	a0,0x4
    8000474a:	01a50513          	addi	a0,a0,26 # 80008760 <syscalls+0x338>
    8000474e:	ffffc097          	auipc	ra,0xffffc
    80004752:	df4080e7          	jalr	-524(ra) # 80000542 <panic>

0000000080004756 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80004756:	7139                	addi	sp,sp,-64
    80004758:	fc06                	sd	ra,56(sp)
    8000475a:	f822                	sd	s0,48(sp)
    8000475c:	f426                	sd	s1,40(sp)
    8000475e:	f04a                	sd	s2,32(sp)
    80004760:	ec4e                	sd	s3,24(sp)
    80004762:	e852                	sd	s4,16(sp)
    80004764:	e456                	sd	s5,8(sp)
    80004766:	0080                	addi	s0,sp,64
    80004768:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    8000476a:	0001d517          	auipc	a0,0x1d
    8000476e:	2e650513          	addi	a0,a0,742 # 80021a50 <ftable>
    80004772:	ffffc097          	auipc	ra,0xffffc
    80004776:	48c080e7          	jalr	1164(ra) # 80000bfe <acquire>
    if (f->ref < 1)
    8000477a:	40dc                	lw	a5,4(s1)
    8000477c:	06f05163          	blez	a5,800047de <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    80004780:	37fd                	addiw	a5,a5,-1
    80004782:	0007871b          	sext.w	a4,a5
    80004786:	c0dc                	sw	a5,4(s1)
    80004788:	06e04363          	bgtz	a4,800047ee <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    8000478c:	0004a903          	lw	s2,0(s1)
    80004790:	0094ca83          	lbu	s5,9(s1)
    80004794:	0104ba03          	ld	s4,16(s1)
    80004798:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    8000479c:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    800047a0:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    800047a4:	0001d517          	auipc	a0,0x1d
    800047a8:	2ac50513          	addi	a0,a0,684 # 80021a50 <ftable>
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	506080e7          	jalr	1286(ra) # 80000cb2 <release>

    if (ff.type == FD_PIPE)
    800047b4:	4785                	li	a5,1
    800047b6:	04f90d63          	beq	s2,a5,80004810 <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    800047ba:	3979                	addiw	s2,s2,-2
    800047bc:	4785                	li	a5,1
    800047be:	0527e063          	bltu	a5,s2,800047fe <fileclose+0xa8>
    {
        begin_op();
    800047c2:	00000097          	auipc	ra,0x0
    800047c6:	ac2080e7          	jalr	-1342(ra) # 80004284 <begin_op>
        iput(ff.ip);
    800047ca:	854e                	mv	a0,s3
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	0f8080e7          	jalr	248(ra) # 800038c4 <iput>
        end_op();
    800047d4:	00000097          	auipc	ra,0x0
    800047d8:	b30080e7          	jalr	-1232(ra) # 80004304 <end_op>
    800047dc:	a00d                	j	800047fe <fileclose+0xa8>
        panic("fileclose");
    800047de:	00004517          	auipc	a0,0x4
    800047e2:	f8a50513          	addi	a0,a0,-118 # 80008768 <syscalls+0x340>
    800047e6:	ffffc097          	auipc	ra,0xffffc
    800047ea:	d5c080e7          	jalr	-676(ra) # 80000542 <panic>
        release(&ftable.lock);
    800047ee:	0001d517          	auipc	a0,0x1d
    800047f2:	26250513          	addi	a0,a0,610 # 80021a50 <ftable>
    800047f6:	ffffc097          	auipc	ra,0xffffc
    800047fa:	4bc080e7          	jalr	1212(ra) # 80000cb2 <release>
    }
}
    800047fe:	70e2                	ld	ra,56(sp)
    80004800:	7442                	ld	s0,48(sp)
    80004802:	74a2                	ld	s1,40(sp)
    80004804:	7902                	ld	s2,32(sp)
    80004806:	69e2                	ld	s3,24(sp)
    80004808:	6a42                	ld	s4,16(sp)
    8000480a:	6aa2                	ld	s5,8(sp)
    8000480c:	6121                	addi	sp,sp,64
    8000480e:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80004810:	85d6                	mv	a1,s5
    80004812:	8552                	mv	a0,s4
    80004814:	00000097          	auipc	ra,0x0
    80004818:	374080e7          	jalr	884(ra) # 80004b88 <pipeclose>
    8000481c:	b7cd                	j	800047fe <fileclose+0xa8>

000000008000481e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    8000481e:	715d                	addi	sp,sp,-80
    80004820:	e486                	sd	ra,72(sp)
    80004822:	e0a2                	sd	s0,64(sp)
    80004824:	fc26                	sd	s1,56(sp)
    80004826:	f84a                	sd	s2,48(sp)
    80004828:	f44e                	sd	s3,40(sp)
    8000482a:	0880                	addi	s0,sp,80
    8000482c:	84aa                	mv	s1,a0
    8000482e:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80004830:	ffffd097          	auipc	ra,0xffffd
    80004834:	19a080e7          	jalr	410(ra) # 800019ca <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80004838:	409c                	lw	a5,0(s1)
    8000483a:	37f9                	addiw	a5,a5,-2
    8000483c:	4705                	li	a4,1
    8000483e:	04f76863          	bltu	a4,a5,8000488e <filestat+0x70>
    80004842:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80004844:	6c88                	ld	a0,24(s1)
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	dae080e7          	jalr	-594(ra) # 800035f4 <ilock>
        stati(f->ip, &st);
    8000484e:	fb040593          	addi	a1,s0,-80
    80004852:	6c88                	ld	a0,24(s1)
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	140080e7          	jalr	320(ra) # 80003994 <stati>
        iunlock(f->ip);
    8000485c:	6c88                	ld	a0,24(s1)
    8000485e:	fffff097          	auipc	ra,0xfffff
    80004862:	e50080e7          	jalr	-432(ra) # 800036ae <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004866:	02000693          	li	a3,32
    8000486a:	fb040613          	addi	a2,s0,-80
    8000486e:	85ce                	mv	a1,s3
    80004870:	05093503          	ld	a0,80(s2)
    80004874:	ffffd097          	auipc	ra,0xffffd
    80004878:	e48080e7          	jalr	-440(ra) # 800016bc <copyout>
    8000487c:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80004880:	60a6                	ld	ra,72(sp)
    80004882:	6406                	ld	s0,64(sp)
    80004884:	74e2                	ld	s1,56(sp)
    80004886:	7942                	ld	s2,48(sp)
    80004888:	79a2                	ld	s3,40(sp)
    8000488a:	6161                	addi	sp,sp,80
    8000488c:	8082                	ret
    return -1;
    8000488e:	557d                	li	a0,-1
    80004890:	bfc5                	j	80004880 <filestat+0x62>

0000000080004892 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80004892:	7179                	addi	sp,sp,-48
    80004894:	f406                	sd	ra,40(sp)
    80004896:	f022                	sd	s0,32(sp)
    80004898:	ec26                	sd	s1,24(sp)
    8000489a:	e84a                	sd	s2,16(sp)
    8000489c:	e44e                	sd	s3,8(sp)
    8000489e:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    800048a0:	00854783          	lbu	a5,8(a0)
    800048a4:	c3d5                	beqz	a5,80004948 <fileread+0xb6>
    800048a6:	84aa                	mv	s1,a0
    800048a8:	89ae                	mv	s3,a1
    800048aa:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    800048ac:	411c                	lw	a5,0(a0)
    800048ae:	4705                	li	a4,1
    800048b0:	04e78963          	beq	a5,a4,80004902 <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    800048b4:	470d                	li	a4,3
    800048b6:	04e78d63          	beq	a5,a4,80004910 <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    800048ba:	4709                	li	a4,2
    800048bc:	06e79e63          	bne	a5,a4,80004938 <fileread+0xa6>
    {
        ilock(f->ip);
    800048c0:	6d08                	ld	a0,24(a0)
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	d32080e7          	jalr	-718(ra) # 800035f4 <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800048ca:	874a                	mv	a4,s2
    800048cc:	5094                	lw	a3,32(s1)
    800048ce:	864e                	mv	a2,s3
    800048d0:	4585                	li	a1,1
    800048d2:	6c88                	ld	a0,24(s1)
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	0f2080e7          	jalr	242(ra) # 800039c6 <readi>
    800048dc:	892a                	mv	s2,a0
    800048de:	00a05563          	blez	a0,800048e8 <fileread+0x56>
            f->off += r;
    800048e2:	509c                	lw	a5,32(s1)
    800048e4:	9fa9                	addw	a5,a5,a0
    800048e6:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    800048e8:	6c88                	ld	a0,24(s1)
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	dc4080e7          	jalr	-572(ra) # 800036ae <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    800048f2:	854a                	mv	a0,s2
    800048f4:	70a2                	ld	ra,40(sp)
    800048f6:	7402                	ld	s0,32(sp)
    800048f8:	64e2                	ld	s1,24(sp)
    800048fa:	6942                	ld	s2,16(sp)
    800048fc:	69a2                	ld	s3,8(sp)
    800048fe:	6145                	addi	sp,sp,48
    80004900:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80004902:	6908                	ld	a0,16(a0)
    80004904:	00000097          	auipc	ra,0x0
    80004908:	3f4080e7          	jalr	1012(ra) # 80004cf8 <piperead>
    8000490c:	892a                	mv	s2,a0
    8000490e:	b7d5                	j	800048f2 <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004910:	02451783          	lh	a5,36(a0)
    80004914:	03079693          	slli	a3,a5,0x30
    80004918:	92c1                	srli	a3,a3,0x30
    8000491a:	4725                	li	a4,9
    8000491c:	02d76863          	bltu	a4,a3,8000494c <fileread+0xba>
    80004920:	0792                	slli	a5,a5,0x4
    80004922:	0001d717          	auipc	a4,0x1d
    80004926:	08e70713          	addi	a4,a4,142 # 800219b0 <devsw>
    8000492a:	97ba                	add	a5,a5,a4
    8000492c:	639c                	ld	a5,0(a5)
    8000492e:	c38d                	beqz	a5,80004950 <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80004930:	4505                	li	a0,1
    80004932:	9782                	jalr	a5
    80004934:	892a                	mv	s2,a0
    80004936:	bf75                	j	800048f2 <fileread+0x60>
        panic("fileread");
    80004938:	00004517          	auipc	a0,0x4
    8000493c:	e4050513          	addi	a0,a0,-448 # 80008778 <syscalls+0x350>
    80004940:	ffffc097          	auipc	ra,0xffffc
    80004944:	c02080e7          	jalr	-1022(ra) # 80000542 <panic>
        return -1;
    80004948:	597d                	li	s2,-1
    8000494a:	b765                	j	800048f2 <fileread+0x60>
            return -1;
    8000494c:	597d                	li	s2,-1
    8000494e:	b755                	j	800048f2 <fileread+0x60>
    80004950:	597d                	li	s2,-1
    80004952:	b745                	j	800048f2 <fileread+0x60>

0000000080004954 <filewrite>:
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    int r, ret = 0;

    if (f->writable == 0)
    80004954:	00954783          	lbu	a5,9(a0)
    80004958:	14078563          	beqz	a5,80004aa2 <filewrite+0x14e>
{
    8000495c:	715d                	addi	sp,sp,-80
    8000495e:	e486                	sd	ra,72(sp)
    80004960:	e0a2                	sd	s0,64(sp)
    80004962:	fc26                	sd	s1,56(sp)
    80004964:	f84a                	sd	s2,48(sp)
    80004966:	f44e                	sd	s3,40(sp)
    80004968:	f052                	sd	s4,32(sp)
    8000496a:	ec56                	sd	s5,24(sp)
    8000496c:	e85a                	sd	s6,16(sp)
    8000496e:	e45e                	sd	s7,8(sp)
    80004970:	e062                	sd	s8,0(sp)
    80004972:	0880                	addi	s0,sp,80
    80004974:	892a                	mv	s2,a0
    80004976:	8aae                	mv	s5,a1
    80004978:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    8000497a:	411c                	lw	a5,0(a0)
    8000497c:	4705                	li	a4,1
    8000497e:	02e78263          	beq	a5,a4,800049a2 <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80004982:	470d                	li	a4,3
    80004984:	02e78563          	beq	a5,a4,800049ae <filewrite+0x5a>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80004988:	4709                	li	a4,2
    8000498a:	10e79463          	bne	a5,a4,80004a92 <filewrite+0x13e>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    8000498e:	0ec05e63          	blez	a2,80004a8a <filewrite+0x136>
        int i = 0;
    80004992:	4981                	li	s3,0
    80004994:	6b05                	lui	s6,0x1
    80004996:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000499a:	6b85                	lui	s7,0x1
    8000499c:	c00b8b9b          	addiw	s7,s7,-1024
    800049a0:	a851                	j	80004a34 <filewrite+0xe0>
        ret = pipewrite(f->pipe, addr, n);
    800049a2:	6908                	ld	a0,16(a0)
    800049a4:	00000097          	auipc	ra,0x0
    800049a8:	254080e7          	jalr	596(ra) # 80004bf8 <pipewrite>
    800049ac:	a85d                	j	80004a62 <filewrite+0x10e>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800049ae:	02451783          	lh	a5,36(a0)
    800049b2:	03079693          	slli	a3,a5,0x30
    800049b6:	92c1                	srli	a3,a3,0x30
    800049b8:	4725                	li	a4,9
    800049ba:	0ed76663          	bltu	a4,a3,80004aa6 <filewrite+0x152>
    800049be:	0792                	slli	a5,a5,0x4
    800049c0:	0001d717          	auipc	a4,0x1d
    800049c4:	ff070713          	addi	a4,a4,-16 # 800219b0 <devsw>
    800049c8:	97ba                	add	a5,a5,a4
    800049ca:	679c                	ld	a5,8(a5)
    800049cc:	cff9                	beqz	a5,80004aaa <filewrite+0x156>
        ret = devsw[f->major].write(1, addr, n);
    800049ce:	4505                	li	a0,1
    800049d0:	9782                	jalr	a5
    800049d2:	a841                	j	80004a62 <filewrite+0x10e>
    800049d4:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	8ac080e7          	jalr	-1876(ra) # 80004284 <begin_op>
            ilock(f->ip);
    800049e0:	01893503          	ld	a0,24(s2)
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	c10080e7          	jalr	-1008(ra) # 800035f4 <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800049ec:	8762                	mv	a4,s8
    800049ee:	02092683          	lw	a3,32(s2)
    800049f2:	01598633          	add	a2,s3,s5
    800049f6:	4585                	li	a1,1
    800049f8:	01893503          	ld	a0,24(s2)
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	0c0080e7          	jalr	192(ra) # 80003abc <writei>
    80004a04:	84aa                	mv	s1,a0
    80004a06:	02a05f63          	blez	a0,80004a44 <filewrite+0xf0>
                f->off += r;
    80004a0a:	02092783          	lw	a5,32(s2)
    80004a0e:	9fa9                	addw	a5,a5,a0
    80004a10:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80004a14:	01893503          	ld	a0,24(s2)
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	c96080e7          	jalr	-874(ra) # 800036ae <iunlock>
            end_op();
    80004a20:	00000097          	auipc	ra,0x0
    80004a24:	8e4080e7          	jalr	-1820(ra) # 80004304 <end_op>

            if (r < 0)
                break;
            if (r != n1)
    80004a28:	049c1963          	bne	s8,s1,80004a7a <filewrite+0x126>
                panic("short filewrite");
            i += r;
    80004a2c:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80004a30:	0349d663          	bge	s3,s4,80004a5c <filewrite+0x108>
            int n1 = n - i;
    80004a34:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80004a38:	84be                	mv	s1,a5
    80004a3a:	2781                	sext.w	a5,a5
    80004a3c:	f8fb5ce3          	bge	s6,a5,800049d4 <filewrite+0x80>
    80004a40:	84de                	mv	s1,s7
    80004a42:	bf49                	j	800049d4 <filewrite+0x80>
            iunlock(f->ip);
    80004a44:	01893503          	ld	a0,24(s2)
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	c66080e7          	jalr	-922(ra) # 800036ae <iunlock>
            end_op();
    80004a50:	00000097          	auipc	ra,0x0
    80004a54:	8b4080e7          	jalr	-1868(ra) # 80004304 <end_op>
            if (r < 0)
    80004a58:	fc04d8e3          	bgez	s1,80004a28 <filewrite+0xd4>
        }
        ret = (i == n ? n : -1);
    80004a5c:	8552                	mv	a0,s4
    80004a5e:	033a1863          	bne	s4,s3,80004a8e <filewrite+0x13a>
    {
        panic("filewrite");
    }

    return ret;
}
    80004a62:	60a6                	ld	ra,72(sp)
    80004a64:	6406                	ld	s0,64(sp)
    80004a66:	74e2                	ld	s1,56(sp)
    80004a68:	7942                	ld	s2,48(sp)
    80004a6a:	79a2                	ld	s3,40(sp)
    80004a6c:	7a02                	ld	s4,32(sp)
    80004a6e:	6ae2                	ld	s5,24(sp)
    80004a70:	6b42                	ld	s6,16(sp)
    80004a72:	6ba2                	ld	s7,8(sp)
    80004a74:	6c02                	ld	s8,0(sp)
    80004a76:	6161                	addi	sp,sp,80
    80004a78:	8082                	ret
                panic("short filewrite");
    80004a7a:	00004517          	auipc	a0,0x4
    80004a7e:	d0e50513          	addi	a0,a0,-754 # 80008788 <syscalls+0x360>
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	ac0080e7          	jalr	-1344(ra) # 80000542 <panic>
        int i = 0;
    80004a8a:	4981                	li	s3,0
    80004a8c:	bfc1                	j	80004a5c <filewrite+0x108>
        ret = (i == n ? n : -1);
    80004a8e:	557d                	li	a0,-1
    80004a90:	bfc9                	j	80004a62 <filewrite+0x10e>
        panic("filewrite");
    80004a92:	00004517          	auipc	a0,0x4
    80004a96:	d0650513          	addi	a0,a0,-762 # 80008798 <syscalls+0x370>
    80004a9a:	ffffc097          	auipc	ra,0xffffc
    80004a9e:	aa8080e7          	jalr	-1368(ra) # 80000542 <panic>
        return -1;
    80004aa2:	557d                	li	a0,-1
}
    80004aa4:	8082                	ret
            return -1;
    80004aa6:	557d                	li	a0,-1
    80004aa8:	bf6d                	j	80004a62 <filewrite+0x10e>
    80004aaa:	557d                	li	a0,-1
    80004aac:	bf5d                	j	80004a62 <filewrite+0x10e>

0000000080004aae <pipealloc>:
    int readopen;  // read fd is still open
    int writeopen; // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1)
{
    80004aae:	7179                	addi	sp,sp,-48
    80004ab0:	f406                	sd	ra,40(sp)
    80004ab2:	f022                	sd	s0,32(sp)
    80004ab4:	ec26                	sd	s1,24(sp)
    80004ab6:	e84a                	sd	s2,16(sp)
    80004ab8:	e44e                	sd	s3,8(sp)
    80004aba:	e052                	sd	s4,0(sp)
    80004abc:	1800                	addi	s0,sp,48
    80004abe:	84aa                	mv	s1,a0
    80004ac0:	8a2e                	mv	s4,a1
    struct pipe *pi;

    pi = 0;
    *f0 = *f1 = 0;
    80004ac2:	0005b023          	sd	zero,0(a1)
    80004ac6:	00053023          	sd	zero,0(a0)
    if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004aca:	00000097          	auipc	ra,0x0
    80004ace:	bd0080e7          	jalr	-1072(ra) # 8000469a <filealloc>
    80004ad2:	e088                	sd	a0,0(s1)
    80004ad4:	c551                	beqz	a0,80004b60 <pipealloc+0xb2>
    80004ad6:	00000097          	auipc	ra,0x0
    80004ada:	bc4080e7          	jalr	-1084(ra) # 8000469a <filealloc>
    80004ade:	00aa3023          	sd	a0,0(s4)
    80004ae2:	c92d                	beqz	a0,80004b54 <pipealloc+0xa6>
        goto bad;
    if ((pi = (struct pipe *)kalloc()) == 0)
    80004ae4:	ffffc097          	auipc	ra,0xffffc
    80004ae8:	02a080e7          	jalr	42(ra) # 80000b0e <kalloc>
    80004aec:	892a                	mv	s2,a0
    80004aee:	c125                	beqz	a0,80004b4e <pipealloc+0xa0>
        goto bad;
    pi->readopen = 1;
    80004af0:	4985                	li	s3,1
    80004af2:	23352023          	sw	s3,544(a0)
    pi->writeopen = 1;
    80004af6:	23352223          	sw	s3,548(a0)
    pi->nwrite = 0;
    80004afa:	20052e23          	sw	zero,540(a0)
    pi->nread = 0;
    80004afe:	20052c23          	sw	zero,536(a0)
    initlock(&pi->lock, "pipe");
    80004b02:	00004597          	auipc	a1,0x4
    80004b06:	ca658593          	addi	a1,a1,-858 # 800087a8 <syscalls+0x380>
    80004b0a:	ffffc097          	auipc	ra,0xffffc
    80004b0e:	064080e7          	jalr	100(ra) # 80000b6e <initlock>
    (*f0)->type = FD_PIPE;
    80004b12:	609c                	ld	a5,0(s1)
    80004b14:	0137a023          	sw	s3,0(a5)
    (*f0)->readable = 1;
    80004b18:	609c                	ld	a5,0(s1)
    80004b1a:	01378423          	sb	s3,8(a5)
    (*f0)->writable = 0;
    80004b1e:	609c                	ld	a5,0(s1)
    80004b20:	000784a3          	sb	zero,9(a5)
    (*f0)->pipe = pi;
    80004b24:	609c                	ld	a5,0(s1)
    80004b26:	0127b823          	sd	s2,16(a5)
    (*f1)->type = FD_PIPE;
    80004b2a:	000a3783          	ld	a5,0(s4)
    80004b2e:	0137a023          	sw	s3,0(a5)
    (*f1)->readable = 0;
    80004b32:	000a3783          	ld	a5,0(s4)
    80004b36:	00078423          	sb	zero,8(a5)
    (*f1)->writable = 1;
    80004b3a:	000a3783          	ld	a5,0(s4)
    80004b3e:	013784a3          	sb	s3,9(a5)
    (*f1)->pipe = pi;
    80004b42:	000a3783          	ld	a5,0(s4)
    80004b46:	0127b823          	sd	s2,16(a5)
    return 0;
    80004b4a:	4501                	li	a0,0
    80004b4c:	a025                	j	80004b74 <pipealloc+0xc6>

bad:
    if (pi)
        kfree((char *)pi);
    if (*f0)
    80004b4e:	6088                	ld	a0,0(s1)
    80004b50:	e501                	bnez	a0,80004b58 <pipealloc+0xaa>
    80004b52:	a039                	j	80004b60 <pipealloc+0xb2>
    80004b54:	6088                	ld	a0,0(s1)
    80004b56:	c51d                	beqz	a0,80004b84 <pipealloc+0xd6>
        fileclose(*f0);
    80004b58:	00000097          	auipc	ra,0x0
    80004b5c:	bfe080e7          	jalr	-1026(ra) # 80004756 <fileclose>
    if (*f1)
    80004b60:	000a3783          	ld	a5,0(s4)
        fileclose(*f1);
    return -1;
    80004b64:	557d                	li	a0,-1
    if (*f1)
    80004b66:	c799                	beqz	a5,80004b74 <pipealloc+0xc6>
        fileclose(*f1);
    80004b68:	853e                	mv	a0,a5
    80004b6a:	00000097          	auipc	ra,0x0
    80004b6e:	bec080e7          	jalr	-1044(ra) # 80004756 <fileclose>
    return -1;
    80004b72:	557d                	li	a0,-1
}
    80004b74:	70a2                	ld	ra,40(sp)
    80004b76:	7402                	ld	s0,32(sp)
    80004b78:	64e2                	ld	s1,24(sp)
    80004b7a:	6942                	ld	s2,16(sp)
    80004b7c:	69a2                	ld	s3,8(sp)
    80004b7e:	6a02                	ld	s4,0(sp)
    80004b80:	6145                	addi	sp,sp,48
    80004b82:	8082                	ret
    return -1;
    80004b84:	557d                	li	a0,-1
    80004b86:	b7fd                	j	80004b74 <pipealloc+0xc6>

0000000080004b88 <pipeclose>:

void pipeclose(struct pipe *pi, int writable)
{
    80004b88:	1101                	addi	sp,sp,-32
    80004b8a:	ec06                	sd	ra,24(sp)
    80004b8c:	e822                	sd	s0,16(sp)
    80004b8e:	e426                	sd	s1,8(sp)
    80004b90:	e04a                	sd	s2,0(sp)
    80004b92:	1000                	addi	s0,sp,32
    80004b94:	84aa                	mv	s1,a0
    80004b96:	892e                	mv	s2,a1
    acquire(&pi->lock);
    80004b98:	ffffc097          	auipc	ra,0xffffc
    80004b9c:	066080e7          	jalr	102(ra) # 80000bfe <acquire>
    if (writable)
    80004ba0:	02090d63          	beqz	s2,80004bda <pipeclose+0x52>
    {
        pi->writeopen = 0;
    80004ba4:	2204a223          	sw	zero,548(s1)
        wakeup(&pi->nread);
    80004ba8:	21848513          	addi	a0,s1,536
    80004bac:	ffffd097          	auipc	ra,0xffffd
    80004bb0:	7ae080e7          	jalr	1966(ra) # 8000235a <wakeup>
    else
    {
        pi->readopen = 0;
        wakeup(&pi->nwrite);
    }
    if (pi->readopen == 0 && pi->writeopen == 0)
    80004bb4:	2204b783          	ld	a5,544(s1)
    80004bb8:	eb95                	bnez	a5,80004bec <pipeclose+0x64>
    {
        release(&pi->lock);
    80004bba:	8526                	mv	a0,s1
    80004bbc:	ffffc097          	auipc	ra,0xffffc
    80004bc0:	0f6080e7          	jalr	246(ra) # 80000cb2 <release>
        kfree((char *)pi);
    80004bc4:	8526                	mv	a0,s1
    80004bc6:	ffffc097          	auipc	ra,0xffffc
    80004bca:	e4c080e7          	jalr	-436(ra) # 80000a12 <kfree>
    }
    else
        release(&pi->lock);
}
    80004bce:	60e2                	ld	ra,24(sp)
    80004bd0:	6442                	ld	s0,16(sp)
    80004bd2:	64a2                	ld	s1,8(sp)
    80004bd4:	6902                	ld	s2,0(sp)
    80004bd6:	6105                	addi	sp,sp,32
    80004bd8:	8082                	ret
        pi->readopen = 0;
    80004bda:	2204a023          	sw	zero,544(s1)
        wakeup(&pi->nwrite);
    80004bde:	21c48513          	addi	a0,s1,540
    80004be2:	ffffd097          	auipc	ra,0xffffd
    80004be6:	778080e7          	jalr	1912(ra) # 8000235a <wakeup>
    80004bea:	b7e9                	j	80004bb4 <pipeclose+0x2c>
        release(&pi->lock);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffc097          	auipc	ra,0xffffc
    80004bf2:	0c4080e7          	jalr	196(ra) # 80000cb2 <release>
}
    80004bf6:	bfe1                	j	80004bce <pipeclose+0x46>

0000000080004bf8 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004bf8:	711d                	addi	sp,sp,-96
    80004bfa:	ec86                	sd	ra,88(sp)
    80004bfc:	e8a2                	sd	s0,80(sp)
    80004bfe:	e4a6                	sd	s1,72(sp)
    80004c00:	e0ca                	sd	s2,64(sp)
    80004c02:	fc4e                	sd	s3,56(sp)
    80004c04:	f852                	sd	s4,48(sp)
    80004c06:	f456                	sd	s5,40(sp)
    80004c08:	f05a                	sd	s6,32(sp)
    80004c0a:	ec5e                	sd	s7,24(sp)
    80004c0c:	e862                	sd	s8,16(sp)
    80004c0e:	1080                	addi	s0,sp,96
    80004c10:	84aa                	mv	s1,a0
    80004c12:	8b2e                	mv	s6,a1
    80004c14:	8ab2                	mv	s5,a2
    int i;
    char ch;
    struct proc *pr = myproc();
    80004c16:	ffffd097          	auipc	ra,0xffffd
    80004c1a:	db4080e7          	jalr	-588(ra) # 800019ca <myproc>
    80004c1e:	892a                	mv	s2,a0

    acquire(&pi->lock);
    80004c20:	8526                	mv	a0,s1
    80004c22:	ffffc097          	auipc	ra,0xffffc
    80004c26:	fdc080e7          	jalr	-36(ra) # 80000bfe <acquire>
    for (i = 0; i < n; i++)
    80004c2a:	09505763          	blez	s5,80004cb8 <pipewrite+0xc0>
    80004c2e:	4b81                	li	s7,0
            if (pi->readopen == 0 || pr->killed)
            {
                release(&pi->lock);
                return -1;
            }
            wakeup(&pi->nread);
    80004c30:	21848a13          	addi	s4,s1,536
            sleep(&pi->nwrite, &pi->lock);
    80004c34:	21c48993          	addi	s3,s1,540
        }
        if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c38:	5c7d                	li	s8,-1
        while (pi->nwrite == pi->nread + PIPESIZE)
    80004c3a:	2184a783          	lw	a5,536(s1)
    80004c3e:	21c4a703          	lw	a4,540(s1)
    80004c42:	2007879b          	addiw	a5,a5,512
    80004c46:	02f71b63          	bne	a4,a5,80004c7c <pipewrite+0x84>
            if (pi->readopen == 0 || pr->killed)
    80004c4a:	2204a783          	lw	a5,544(s1)
    80004c4e:	c3d1                	beqz	a5,80004cd2 <pipewrite+0xda>
    80004c50:	03092783          	lw	a5,48(s2)
    80004c54:	efbd                	bnez	a5,80004cd2 <pipewrite+0xda>
            wakeup(&pi->nread);
    80004c56:	8552                	mv	a0,s4
    80004c58:	ffffd097          	auipc	ra,0xffffd
    80004c5c:	702080e7          	jalr	1794(ra) # 8000235a <wakeup>
            sleep(&pi->nwrite, &pi->lock);
    80004c60:	85a6                	mv	a1,s1
    80004c62:	854e                	mv	a0,s3
    80004c64:	ffffd097          	auipc	ra,0xffffd
    80004c68:	576080e7          	jalr	1398(ra) # 800021da <sleep>
        while (pi->nwrite == pi->nread + PIPESIZE)
    80004c6c:	2184a783          	lw	a5,536(s1)
    80004c70:	21c4a703          	lw	a4,540(s1)
    80004c74:	2007879b          	addiw	a5,a5,512
    80004c78:	fcf709e3          	beq	a4,a5,80004c4a <pipewrite+0x52>
        if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c7c:	4685                	li	a3,1
    80004c7e:	865a                	mv	a2,s6
    80004c80:	faf40593          	addi	a1,s0,-81
    80004c84:	05093503          	ld	a0,80(s2)
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	ac0080e7          	jalr	-1344(ra) # 80001748 <copyin>
    80004c90:	03850563          	beq	a0,s8,80004cba <pipewrite+0xc2>
            break;
        pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c94:	21c4a783          	lw	a5,540(s1)
    80004c98:	0017871b          	addiw	a4,a5,1
    80004c9c:	20e4ae23          	sw	a4,540(s1)
    80004ca0:	1ff7f793          	andi	a5,a5,511
    80004ca4:	97a6                	add	a5,a5,s1
    80004ca6:	faf44703          	lbu	a4,-81(s0)
    80004caa:	00e78c23          	sb	a4,24(a5)
    for (i = 0; i < n; i++)
    80004cae:	2b85                	addiw	s7,s7,1
    80004cb0:	0b05                	addi	s6,s6,1
    80004cb2:	f97a94e3          	bne	s5,s7,80004c3a <pipewrite+0x42>
    80004cb6:	a011                	j	80004cba <pipewrite+0xc2>
    80004cb8:	4b81                	li	s7,0
    }
    wakeup(&pi->nread);
    80004cba:	21848513          	addi	a0,s1,536
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	69c080e7          	jalr	1692(ra) # 8000235a <wakeup>
    release(&pi->lock);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffc097          	auipc	ra,0xffffc
    80004ccc:	fea080e7          	jalr	-22(ra) # 80000cb2 <release>
    return i;
    80004cd0:	a039                	j	80004cde <pipewrite+0xe6>
                release(&pi->lock);
    80004cd2:	8526                	mv	a0,s1
    80004cd4:	ffffc097          	auipc	ra,0xffffc
    80004cd8:	fde080e7          	jalr	-34(ra) # 80000cb2 <release>
                return -1;
    80004cdc:	5bfd                	li	s7,-1
}
    80004cde:	855e                	mv	a0,s7
    80004ce0:	60e6                	ld	ra,88(sp)
    80004ce2:	6446                	ld	s0,80(sp)
    80004ce4:	64a6                	ld	s1,72(sp)
    80004ce6:	6906                	ld	s2,64(sp)
    80004ce8:	79e2                	ld	s3,56(sp)
    80004cea:	7a42                	ld	s4,48(sp)
    80004cec:	7aa2                	ld	s5,40(sp)
    80004cee:	7b02                	ld	s6,32(sp)
    80004cf0:	6be2                	ld	s7,24(sp)
    80004cf2:	6c42                	ld	s8,16(sp)
    80004cf4:	6125                	addi	sp,sp,96
    80004cf6:	8082                	ret

0000000080004cf8 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n)
{
    80004cf8:	715d                	addi	sp,sp,-80
    80004cfa:	e486                	sd	ra,72(sp)
    80004cfc:	e0a2                	sd	s0,64(sp)
    80004cfe:	fc26                	sd	s1,56(sp)
    80004d00:	f84a                	sd	s2,48(sp)
    80004d02:	f44e                	sd	s3,40(sp)
    80004d04:	f052                	sd	s4,32(sp)
    80004d06:	ec56                	sd	s5,24(sp)
    80004d08:	e85a                	sd	s6,16(sp)
    80004d0a:	0880                	addi	s0,sp,80
    80004d0c:	84aa                	mv	s1,a0
    80004d0e:	892e                	mv	s2,a1
    80004d10:	8ab2                	mv	s5,a2
    int i;
    struct proc *pr = myproc();
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	cb8080e7          	jalr	-840(ra) # 800019ca <myproc>
    80004d1a:	8a2a                	mv	s4,a0
    char ch;

    acquire(&pi->lock);
    80004d1c:	8526                	mv	a0,s1
    80004d1e:	ffffc097          	auipc	ra,0xffffc
    80004d22:	ee0080e7          	jalr	-288(ra) # 80000bfe <acquire>
    while (pi->nread == pi->nwrite && pi->writeopen)
    80004d26:	2184a703          	lw	a4,536(s1)
    80004d2a:	21c4a783          	lw	a5,540(s1)
        if (pr->killed)
        {
            release(&pi->lock);
            return -1;
        }
        sleep(&pi->nread, &pi->lock); // DOC: piperead-sleep
    80004d2e:	21848993          	addi	s3,s1,536
    while (pi->nread == pi->nwrite && pi->writeopen)
    80004d32:	02f71463          	bne	a4,a5,80004d5a <piperead+0x62>
    80004d36:	2244a783          	lw	a5,548(s1)
    80004d3a:	c385                	beqz	a5,80004d5a <piperead+0x62>
        if (pr->killed)
    80004d3c:	030a2783          	lw	a5,48(s4)
    80004d40:	ebc1                	bnez	a5,80004dd0 <piperead+0xd8>
        sleep(&pi->nread, &pi->lock); // DOC: piperead-sleep
    80004d42:	85a6                	mv	a1,s1
    80004d44:	854e                	mv	a0,s3
    80004d46:	ffffd097          	auipc	ra,0xffffd
    80004d4a:	494080e7          	jalr	1172(ra) # 800021da <sleep>
    while (pi->nread == pi->nwrite && pi->writeopen)
    80004d4e:	2184a703          	lw	a4,536(s1)
    80004d52:	21c4a783          	lw	a5,540(s1)
    80004d56:	fef700e3          	beq	a4,a5,80004d36 <piperead+0x3e>
    }
    for (i = 0; i < n; i++)
    80004d5a:	4981                	li	s3,0
    { // DOC: piperead-copy
        if (pi->nread == pi->nwrite)
            break;
        ch = pi->data[pi->nread++ % PIPESIZE];
        if (copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d5c:	5b7d                	li	s6,-1
    for (i = 0; i < n; i++)
    80004d5e:	05505363          	blez	s5,80004da4 <piperead+0xac>
        if (pi->nread == pi->nwrite)
    80004d62:	2184a783          	lw	a5,536(s1)
    80004d66:	21c4a703          	lw	a4,540(s1)
    80004d6a:	02f70d63          	beq	a4,a5,80004da4 <piperead+0xac>
        ch = pi->data[pi->nread++ % PIPESIZE];
    80004d6e:	0017871b          	addiw	a4,a5,1
    80004d72:	20e4ac23          	sw	a4,536(s1)
    80004d76:	1ff7f793          	andi	a5,a5,511
    80004d7a:	97a6                	add	a5,a5,s1
    80004d7c:	0187c783          	lbu	a5,24(a5)
    80004d80:	faf40fa3          	sb	a5,-65(s0)
        if (copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d84:	4685                	li	a3,1
    80004d86:	fbf40613          	addi	a2,s0,-65
    80004d8a:	85ca                	mv	a1,s2
    80004d8c:	050a3503          	ld	a0,80(s4)
    80004d90:	ffffd097          	auipc	ra,0xffffd
    80004d94:	92c080e7          	jalr	-1748(ra) # 800016bc <copyout>
    80004d98:	01650663          	beq	a0,s6,80004da4 <piperead+0xac>
    for (i = 0; i < n; i++)
    80004d9c:	2985                	addiw	s3,s3,1
    80004d9e:	0905                	addi	s2,s2,1
    80004da0:	fd3a91e3          	bne	s5,s3,80004d62 <piperead+0x6a>
            break;
    }
    wakeup(&pi->nwrite); // DOC: piperead-wakeup
    80004da4:	21c48513          	addi	a0,s1,540
    80004da8:	ffffd097          	auipc	ra,0xffffd
    80004dac:	5b2080e7          	jalr	1458(ra) # 8000235a <wakeup>
    release(&pi->lock);
    80004db0:	8526                	mv	a0,s1
    80004db2:	ffffc097          	auipc	ra,0xffffc
    80004db6:	f00080e7          	jalr	-256(ra) # 80000cb2 <release>
    return i;
}
    80004dba:	854e                	mv	a0,s3
    80004dbc:	60a6                	ld	ra,72(sp)
    80004dbe:	6406                	ld	s0,64(sp)
    80004dc0:	74e2                	ld	s1,56(sp)
    80004dc2:	7942                	ld	s2,48(sp)
    80004dc4:	79a2                	ld	s3,40(sp)
    80004dc6:	7a02                	ld	s4,32(sp)
    80004dc8:	6ae2                	ld	s5,24(sp)
    80004dca:	6b42                	ld	s6,16(sp)
    80004dcc:	6161                	addi	sp,sp,80
    80004dce:	8082                	ret
            release(&pi->lock);
    80004dd0:	8526                	mv	a0,s1
    80004dd2:	ffffc097          	auipc	ra,0xffffc
    80004dd6:	ee0080e7          	jalr	-288(ra) # 80000cb2 <release>
            return -1;
    80004dda:	59fd                	li	s3,-1
    80004ddc:	bff9                	j	80004dba <piperead+0xc2>

0000000080004dde <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv)
{
    80004dde:	de010113          	addi	sp,sp,-544
    80004de2:	20113c23          	sd	ra,536(sp)
    80004de6:	20813823          	sd	s0,528(sp)
    80004dea:	20913423          	sd	s1,520(sp)
    80004dee:	21213023          	sd	s2,512(sp)
    80004df2:	ffce                	sd	s3,504(sp)
    80004df4:	fbd2                	sd	s4,496(sp)
    80004df6:	f7d6                	sd	s5,488(sp)
    80004df8:	f3da                	sd	s6,480(sp)
    80004dfa:	efde                	sd	s7,472(sp)
    80004dfc:	ebe2                	sd	s8,464(sp)
    80004dfe:	e7e6                	sd	s9,456(sp)
    80004e00:	e3ea                	sd	s10,448(sp)
    80004e02:	ff6e                	sd	s11,440(sp)
    80004e04:	1400                	addi	s0,sp,544
    80004e06:	892a                	mv	s2,a0
    80004e08:	dea43423          	sd	a0,-536(s0)
    80004e0c:	deb43823          	sd	a1,-528(s0)
    uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0, oldpagetable;
    struct proc *p = myproc();
    80004e10:	ffffd097          	auipc	ra,0xffffd
    80004e14:	bba080e7          	jalr	-1094(ra) # 800019ca <myproc>
    80004e18:	84aa                	mv	s1,a0

    begin_op();
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	46a080e7          	jalr	1130(ra) # 80004284 <begin_op>

    if ((ip = namei(path)) == 0)
    80004e22:	854a                	mv	a0,s2
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	09c080e7          	jalr	156(ra) # 80003ec0 <namei>
    80004e2c:	c93d                	beqz	a0,80004ea2 <exec+0xc4>
    80004e2e:	8aaa                	mv	s5,a0
    {
        end_op();
        return -1;
    }
    ilock(ip);
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	7c4080e7          	jalr	1988(ra) # 800035f4 <ilock>

    // Check ELF header
    if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e38:	04000713          	li	a4,64
    80004e3c:	4681                	li	a3,0
    80004e3e:	e4840613          	addi	a2,s0,-440
    80004e42:	4581                	li	a1,0
    80004e44:	8556                	mv	a0,s5
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	b80080e7          	jalr	-1152(ra) # 800039c6 <readi>
    80004e4e:	04000793          	li	a5,64
    80004e52:	00f51a63          	bne	a0,a5,80004e66 <exec+0x88>
        goto bad;
    if (elf.magic != ELF_MAGIC)
    80004e56:	e4842703          	lw	a4,-440(s0)
    80004e5a:	464c47b7          	lui	a5,0x464c4
    80004e5e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004e62:	04f70663          	beq	a4,a5,80004eae <exec+0xd0>
bad:
    if (pagetable)
        proc_freepagetable(pagetable, sz);
    if (ip)
    {
        iunlockput(ip);
    80004e66:	8556                	mv	a0,s5
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	b04080e7          	jalr	-1276(ra) # 8000396c <iunlockput>
        end_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	494080e7          	jalr	1172(ra) # 80004304 <end_op>
    }
    return -1;
    80004e78:	557d                	li	a0,-1
}
    80004e7a:	21813083          	ld	ra,536(sp)
    80004e7e:	21013403          	ld	s0,528(sp)
    80004e82:	20813483          	ld	s1,520(sp)
    80004e86:	20013903          	ld	s2,512(sp)
    80004e8a:	79fe                	ld	s3,504(sp)
    80004e8c:	7a5e                	ld	s4,496(sp)
    80004e8e:	7abe                	ld	s5,488(sp)
    80004e90:	7b1e                	ld	s6,480(sp)
    80004e92:	6bfe                	ld	s7,472(sp)
    80004e94:	6c5e                	ld	s8,464(sp)
    80004e96:	6cbe                	ld	s9,456(sp)
    80004e98:	6d1e                	ld	s10,448(sp)
    80004e9a:	7dfa                	ld	s11,440(sp)
    80004e9c:	22010113          	addi	sp,sp,544
    80004ea0:	8082                	ret
        end_op();
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	462080e7          	jalr	1122(ra) # 80004304 <end_op>
        return -1;
    80004eaa:	557d                	li	a0,-1
    80004eac:	b7f9                	j	80004e7a <exec+0x9c>
    if ((pagetable = proc_pagetable(p)) == 0)
    80004eae:	8526                	mv	a0,s1
    80004eb0:	ffffd097          	auipc	ra,0xffffd
    80004eb4:	bde080e7          	jalr	-1058(ra) # 80001a8e <proc_pagetable>
    80004eb8:	8b2a                	mv	s6,a0
    80004eba:	d555                	beqz	a0,80004e66 <exec+0x88>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004ebc:	e6842783          	lw	a5,-408(s0)
    80004ec0:	e8045703          	lhu	a4,-384(s0)
    80004ec4:	c735                	beqz	a4,80004f30 <exec+0x152>
    uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80004ec6:	4481                	li	s1,0
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004ec8:	e0043423          	sd	zero,-504(s0)
        if (ph.vaddr % PGSIZE != 0)
    80004ecc:	6a05                	lui	s4,0x1
    80004ece:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004ed2:	dee43023          	sd	a4,-544(s0)
    uint64 pa;

    if ((va % PGSIZE) != 0)
        panic("loadseg: va must be page aligned");

    for (i = 0; i < sz; i += PGSIZE)
    80004ed6:	6d85                	lui	s11,0x1
    80004ed8:	7d7d                	lui	s10,0xfffff
    80004eda:	ac1d                	j	80005110 <exec+0x332>
    {
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
    80004edc:	00004517          	auipc	a0,0x4
    80004ee0:	8d450513          	addi	a0,a0,-1836 # 800087b0 <syscalls+0x388>
    80004ee4:	ffffb097          	auipc	ra,0xffffb
    80004ee8:	65e080e7          	jalr	1630(ra) # 80000542 <panic>
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004eec:	874a                	mv	a4,s2
    80004eee:	009c86bb          	addw	a3,s9,s1
    80004ef2:	4581                	li	a1,0
    80004ef4:	8556                	mv	a0,s5
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	ad0080e7          	jalr	-1328(ra) # 800039c6 <readi>
    80004efe:	2501                	sext.w	a0,a0
    80004f00:	1aa91863          	bne	s2,a0,800050b0 <exec+0x2d2>
    for (i = 0; i < sz; i += PGSIZE)
    80004f04:	009d84bb          	addw	s1,s11,s1
    80004f08:	013d09bb          	addw	s3,s10,s3
    80004f0c:	1f74f263          	bgeu	s1,s7,800050f0 <exec+0x312>
        pa = walkaddr(pagetable, va + i);
    80004f10:	02049593          	slli	a1,s1,0x20
    80004f14:	9181                	srli	a1,a1,0x20
    80004f16:	95e2                	add	a1,a1,s8
    80004f18:	855a                	mv	a0,s6
    80004f1a:	ffffc097          	auipc	ra,0xffffc
    80004f1e:	16e080e7          	jalr	366(ra) # 80001088 <walkaddr>
    80004f22:	862a                	mv	a2,a0
        if (pa == 0)
    80004f24:	dd45                	beqz	a0,80004edc <exec+0xfe>
            n = PGSIZE;
    80004f26:	8952                	mv	s2,s4
        if (sz - i < PGSIZE)
    80004f28:	fd49f2e3          	bgeu	s3,s4,80004eec <exec+0x10e>
            n = sz - i;
    80004f2c:	894e                	mv	s2,s3
    80004f2e:	bf7d                	j	80004eec <exec+0x10e>
    uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80004f30:	4481                	li	s1,0
    iunlockput(ip);
    80004f32:	8556                	mv	a0,s5
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	a38080e7          	jalr	-1480(ra) # 8000396c <iunlockput>
    end_op();
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	3c8080e7          	jalr	968(ra) # 80004304 <end_op>
    p = myproc();
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	a86080e7          	jalr	-1402(ra) # 800019ca <myproc>
    80004f4c:	8baa                	mv	s7,a0
    uint64 oldsz = p->sz;
    80004f4e:	04853d03          	ld	s10,72(a0)
    sz = PGROUNDUP(sz);
    80004f52:	6785                	lui	a5,0x1
    80004f54:	17fd                	addi	a5,a5,-1
    80004f56:	94be                	add	s1,s1,a5
    80004f58:	77fd                	lui	a5,0xfffff
    80004f5a:	8fe5                	and	a5,a5,s1
    80004f5c:	def43c23          	sd	a5,-520(s0)
    if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80004f60:	6609                	lui	a2,0x2
    80004f62:	963e                	add	a2,a2,a5
    80004f64:	85be                	mv	a1,a5
    80004f66:	855a                	mv	a0,s6
    80004f68:	ffffc097          	auipc	ra,0xffffc
    80004f6c:	504080e7          	jalr	1284(ra) # 8000146c <uvmalloc>
    80004f70:	8c2a                	mv	s8,a0
    ip = 0;
    80004f72:	4a81                	li	s5,0
    if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80004f74:	12050e63          	beqz	a0,800050b0 <exec+0x2d2>
    uvmclear(pagetable, sz - 2 * PGSIZE);
    80004f78:	75f9                	lui	a1,0xffffe
    80004f7a:	95aa                	add	a1,a1,a0
    80004f7c:	855a                	mv	a0,s6
    80004f7e:	ffffc097          	auipc	ra,0xffffc
    80004f82:	70c080e7          	jalr	1804(ra) # 8000168a <uvmclear>
    stackbase = sp - PGSIZE;
    80004f86:	7afd                	lui	s5,0xfffff
    80004f88:	9ae2                	add	s5,s5,s8
    for (argc = 0; argv[argc]; argc++)
    80004f8a:	df043783          	ld	a5,-528(s0)
    80004f8e:	6388                	ld	a0,0(a5)
    80004f90:	c925                	beqz	a0,80005000 <exec+0x222>
    80004f92:	e8840993          	addi	s3,s0,-376
    80004f96:	f8840c93          	addi	s9,s0,-120
    sp = sz;
    80004f9a:	8962                	mv	s2,s8
    for (argc = 0; argv[argc]; argc++)
    80004f9c:	4481                	li	s1,0
        sp -= strlen(argv[argc]) + 1;
    80004f9e:	ffffc097          	auipc	ra,0xffffc
    80004fa2:	ee0080e7          	jalr	-288(ra) # 80000e7e <strlen>
    80004fa6:	0015079b          	addiw	a5,a0,1
    80004faa:	40f90933          	sub	s2,s2,a5
        sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004fae:	ff097913          	andi	s2,s2,-16
        if (sp < stackbase)
    80004fb2:	13596363          	bltu	s2,s5,800050d8 <exec+0x2fa>
        if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004fb6:	df043d83          	ld	s11,-528(s0)
    80004fba:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004fbe:	8552                	mv	a0,s4
    80004fc0:	ffffc097          	auipc	ra,0xffffc
    80004fc4:	ebe080e7          	jalr	-322(ra) # 80000e7e <strlen>
    80004fc8:	0015069b          	addiw	a3,a0,1
    80004fcc:	8652                	mv	a2,s4
    80004fce:	85ca                	mv	a1,s2
    80004fd0:	855a                	mv	a0,s6
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	6ea080e7          	jalr	1770(ra) # 800016bc <copyout>
    80004fda:	10054363          	bltz	a0,800050e0 <exec+0x302>
        ustack[argc] = sp;
    80004fde:	0129b023          	sd	s2,0(s3)
    for (argc = 0; argv[argc]; argc++)
    80004fe2:	0485                	addi	s1,s1,1
    80004fe4:	008d8793          	addi	a5,s11,8
    80004fe8:	def43823          	sd	a5,-528(s0)
    80004fec:	008db503          	ld	a0,8(s11)
    80004ff0:	c911                	beqz	a0,80005004 <exec+0x226>
        if (argc >= MAXARG)
    80004ff2:	09a1                	addi	s3,s3,8
    80004ff4:	fb3c95e3          	bne	s9,s3,80004f9e <exec+0x1c0>
    sz = sz1;
    80004ff8:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    80004ffc:	4a81                	li	s5,0
    80004ffe:	a84d                	j	800050b0 <exec+0x2d2>
    sp = sz;
    80005000:	8962                	mv	s2,s8
    for (argc = 0; argv[argc]; argc++)
    80005002:	4481                	li	s1,0
    ustack[argc] = 0;
    80005004:	00349793          	slli	a5,s1,0x3
    80005008:	f9040713          	addi	a4,s0,-112
    8000500c:	97ba                	add	a5,a5,a4
    8000500e:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
    sp -= (argc + 1) * sizeof(uint64);
    80005012:	00148693          	addi	a3,s1,1
    80005016:	068e                	slli	a3,a3,0x3
    80005018:	40d90933          	sub	s2,s2,a3
    sp -= sp % 16;
    8000501c:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    80005020:	01597663          	bgeu	s2,s5,8000502c <exec+0x24e>
    sz = sz1;
    80005024:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    80005028:	4a81                	li	s5,0
    8000502a:	a059                	j	800050b0 <exec+0x2d2>
    if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000502c:	e8840613          	addi	a2,s0,-376
    80005030:	85ca                	mv	a1,s2
    80005032:	855a                	mv	a0,s6
    80005034:	ffffc097          	auipc	ra,0xffffc
    80005038:	688080e7          	jalr	1672(ra) # 800016bc <copyout>
    8000503c:	0a054663          	bltz	a0,800050e8 <exec+0x30a>
    p->trapframe->a1 = sp;
    80005040:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80005044:	0727bc23          	sd	s2,120(a5)
    for (last = s = path; *s; s++)
    80005048:	de843783          	ld	a5,-536(s0)
    8000504c:	0007c703          	lbu	a4,0(a5)
    80005050:	cf11                	beqz	a4,8000506c <exec+0x28e>
    80005052:	0785                	addi	a5,a5,1
        if (*s == '/')
    80005054:	02f00693          	li	a3,47
    80005058:	a039                	j	80005066 <exec+0x288>
            last = s + 1;
    8000505a:	def43423          	sd	a5,-536(s0)
    for (last = s = path; *s; s++)
    8000505e:	0785                	addi	a5,a5,1
    80005060:	fff7c703          	lbu	a4,-1(a5)
    80005064:	c701                	beqz	a4,8000506c <exec+0x28e>
        if (*s == '/')
    80005066:	fed71ce3          	bne	a4,a3,8000505e <exec+0x280>
    8000506a:	bfc5                	j	8000505a <exec+0x27c>
    safestrcpy(p->name, last, sizeof(p->name));
    8000506c:	4641                	li	a2,16
    8000506e:	de843583          	ld	a1,-536(s0)
    80005072:	158b8513          	addi	a0,s7,344
    80005076:	ffffc097          	auipc	ra,0xffffc
    8000507a:	dd6080e7          	jalr	-554(ra) # 80000e4c <safestrcpy>
    oldpagetable = p->pagetable;
    8000507e:	050bb503          	ld	a0,80(s7)
    p->pagetable = pagetable;
    80005082:	056bb823          	sd	s6,80(s7)
    p->sz = sz;
    80005086:	058bb423          	sd	s8,72(s7)
    p->trapframe->epc = elf.entry; // initial program counter = main
    8000508a:	058bb783          	ld	a5,88(s7)
    8000508e:	e6043703          	ld	a4,-416(s0)
    80005092:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sp;         // initial stack pointer
    80005094:	058bb783          	ld	a5,88(s7)
    80005098:	0327b823          	sd	s2,48(a5)
    proc_freepagetable(oldpagetable, oldsz);
    8000509c:	85ea                	mv	a1,s10
    8000509e:	ffffd097          	auipc	ra,0xffffd
    800050a2:	a8c080e7          	jalr	-1396(ra) # 80001b2a <proc_freepagetable>
    return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050a6:	0004851b          	sext.w	a0,s1
    800050aa:	bbc1                	j	80004e7a <exec+0x9c>
    800050ac:	de943c23          	sd	s1,-520(s0)
        proc_freepagetable(pagetable, sz);
    800050b0:	df843583          	ld	a1,-520(s0)
    800050b4:	855a                	mv	a0,s6
    800050b6:	ffffd097          	auipc	ra,0xffffd
    800050ba:	a74080e7          	jalr	-1420(ra) # 80001b2a <proc_freepagetable>
    if (ip)
    800050be:	da0a94e3          	bnez	s5,80004e66 <exec+0x88>
    return -1;
    800050c2:	557d                	li	a0,-1
    800050c4:	bb5d                	j	80004e7a <exec+0x9c>
    800050c6:	de943c23          	sd	s1,-520(s0)
    800050ca:	b7dd                	j	800050b0 <exec+0x2d2>
    800050cc:	de943c23          	sd	s1,-520(s0)
    800050d0:	b7c5                	j	800050b0 <exec+0x2d2>
    800050d2:	de943c23          	sd	s1,-520(s0)
    800050d6:	bfe9                	j	800050b0 <exec+0x2d2>
    sz = sz1;
    800050d8:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800050dc:	4a81                	li	s5,0
    800050de:	bfc9                	j	800050b0 <exec+0x2d2>
    sz = sz1;
    800050e0:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800050e4:	4a81                	li	s5,0
    800050e6:	b7e9                	j	800050b0 <exec+0x2d2>
    sz = sz1;
    800050e8:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800050ec:	4a81                	li	s5,0
    800050ee:	b7c9                	j	800050b0 <exec+0x2d2>
        if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800050f0:	df843483          	ld	s1,-520(s0)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    800050f4:	e0843783          	ld	a5,-504(s0)
    800050f8:	0017869b          	addiw	a3,a5,1
    800050fc:	e0d43423          	sd	a3,-504(s0)
    80005100:	e0043783          	ld	a5,-512(s0)
    80005104:	0387879b          	addiw	a5,a5,56
    80005108:	e8045703          	lhu	a4,-384(s0)
    8000510c:	e2e6d3e3          	bge	a3,a4,80004f32 <exec+0x154>
        if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005110:	2781                	sext.w	a5,a5
    80005112:	e0f43023          	sd	a5,-512(s0)
    80005116:	03800713          	li	a4,56
    8000511a:	86be                	mv	a3,a5
    8000511c:	e1040613          	addi	a2,s0,-496
    80005120:	4581                	li	a1,0
    80005122:	8556                	mv	a0,s5
    80005124:	fffff097          	auipc	ra,0xfffff
    80005128:	8a2080e7          	jalr	-1886(ra) # 800039c6 <readi>
    8000512c:	03800793          	li	a5,56
    80005130:	f6f51ee3          	bne	a0,a5,800050ac <exec+0x2ce>
        if (ph.type != ELF_PROG_LOAD)
    80005134:	e1042783          	lw	a5,-496(s0)
    80005138:	4705                	li	a4,1
    8000513a:	fae79de3          	bne	a5,a4,800050f4 <exec+0x316>
        if (ph.memsz < ph.filesz)
    8000513e:	e3843603          	ld	a2,-456(s0)
    80005142:	e3043783          	ld	a5,-464(s0)
    80005146:	f8f660e3          	bltu	a2,a5,800050c6 <exec+0x2e8>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    8000514a:	e2043783          	ld	a5,-480(s0)
    8000514e:	963e                	add	a2,a2,a5
    80005150:	f6f66ee3          	bltu	a2,a5,800050cc <exec+0x2ee>
        if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005154:	85a6                	mv	a1,s1
    80005156:	855a                	mv	a0,s6
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	314080e7          	jalr	788(ra) # 8000146c <uvmalloc>
    80005160:	dea43c23          	sd	a0,-520(s0)
    80005164:	d53d                	beqz	a0,800050d2 <exec+0x2f4>
        if (ph.vaddr % PGSIZE != 0)
    80005166:	e2043c03          	ld	s8,-480(s0)
    8000516a:	de043783          	ld	a5,-544(s0)
    8000516e:	00fc77b3          	and	a5,s8,a5
    80005172:	ff9d                	bnez	a5,800050b0 <exec+0x2d2>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005174:	e1842c83          	lw	s9,-488(s0)
    80005178:	e3042b83          	lw	s7,-464(s0)
    for (i = 0; i < sz; i += PGSIZE)
    8000517c:	f60b8ae3          	beqz	s7,800050f0 <exec+0x312>
    80005180:	89de                	mv	s3,s7
    80005182:	4481                	li	s1,0
    80005184:	b371                	j	80004f10 <exec+0x132>

0000000080005186 <argfd>:
#include "buf.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf)
{
    80005186:	7179                	addi	sp,sp,-48
    80005188:	f406                	sd	ra,40(sp)
    8000518a:	f022                	sd	s0,32(sp)
    8000518c:	ec26                	sd	s1,24(sp)
    8000518e:	e84a                	sd	s2,16(sp)
    80005190:	1800                	addi	s0,sp,48
    80005192:	892e                	mv	s2,a1
    80005194:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    if (argint(n, &fd) < 0)
    80005196:	fdc40593          	addi	a1,s0,-36
    8000519a:	ffffe097          	auipc	ra,0xffffe
    8000519e:	8e6080e7          	jalr	-1818(ra) # 80002a80 <argint>
    800051a2:	04054063          	bltz	a0,800051e2 <argfd+0x5c>
        return -1;
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    800051a6:	fdc42703          	lw	a4,-36(s0)
    800051aa:	47bd                	li	a5,15
    800051ac:	02e7ed63          	bltu	a5,a4,800051e6 <argfd+0x60>
    800051b0:	ffffd097          	auipc	ra,0xffffd
    800051b4:	81a080e7          	jalr	-2022(ra) # 800019ca <myproc>
    800051b8:	fdc42703          	lw	a4,-36(s0)
    800051bc:	01a70793          	addi	a5,a4,26
    800051c0:	078e                	slli	a5,a5,0x3
    800051c2:	953e                	add	a0,a0,a5
    800051c4:	611c                	ld	a5,0(a0)
    800051c6:	c395                	beqz	a5,800051ea <argfd+0x64>
        return -1;
    if (pfd)
    800051c8:	00090463          	beqz	s2,800051d0 <argfd+0x4a>
        *pfd = fd;
    800051cc:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    800051d0:	4501                	li	a0,0
    if (pf)
    800051d2:	c091                	beqz	s1,800051d6 <argfd+0x50>
        *pf = f;
    800051d4:	e09c                	sd	a5,0(s1)
}
    800051d6:	70a2                	ld	ra,40(sp)
    800051d8:	7402                	ld	s0,32(sp)
    800051da:	64e2                	ld	s1,24(sp)
    800051dc:	6942                	ld	s2,16(sp)
    800051de:	6145                	addi	sp,sp,48
    800051e0:	8082                	ret
        return -1;
    800051e2:	557d                	li	a0,-1
    800051e4:	bfcd                	j	800051d6 <argfd+0x50>
        return -1;
    800051e6:	557d                	li	a0,-1
    800051e8:	b7fd                	j	800051d6 <argfd+0x50>
    800051ea:	557d                	li	a0,-1
    800051ec:	b7ed                	j	800051d6 <argfd+0x50>

00000000800051ee <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f)
{
    800051ee:	1101                	addi	sp,sp,-32
    800051f0:	ec06                	sd	ra,24(sp)
    800051f2:	e822                	sd	s0,16(sp)
    800051f4:	e426                	sd	s1,8(sp)
    800051f6:	1000                	addi	s0,sp,32
    800051f8:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    800051fa:	ffffc097          	auipc	ra,0xffffc
    800051fe:	7d0080e7          	jalr	2000(ra) # 800019ca <myproc>
    80005202:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    80005204:	0d050793          	addi	a5,a0,208
    80005208:	4501                	li	a0,0
    8000520a:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    8000520c:	6398                	ld	a4,0(a5)
    8000520e:	cb19                	beqz	a4,80005224 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    80005210:	2505                	addiw	a0,a0,1
    80005212:	07a1                	addi	a5,a5,8
    80005214:	fed51ce3          	bne	a0,a3,8000520c <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    80005218:	557d                	li	a0,-1
}
    8000521a:	60e2                	ld	ra,24(sp)
    8000521c:	6442                	ld	s0,16(sp)
    8000521e:	64a2                	ld	s1,8(sp)
    80005220:	6105                	addi	sp,sp,32
    80005222:	8082                	ret
            p->ofile[fd] = f;
    80005224:	01a50793          	addi	a5,a0,26
    80005228:	078e                	slli	a5,a5,0x3
    8000522a:	963e                	add	a2,a2,a5
    8000522c:	e204                	sd	s1,0(a2)
            return fd;
    8000522e:	b7f5                	j	8000521a <fdalloc+0x2c>

0000000080005230 <create>:
    end_op();
    return -1;
}

static struct inode *create(char *path, short type, short major, short minor)
{
    80005230:	715d                	addi	sp,sp,-80
    80005232:	e486                	sd	ra,72(sp)
    80005234:	e0a2                	sd	s0,64(sp)
    80005236:	fc26                	sd	s1,56(sp)
    80005238:	f84a                	sd	s2,48(sp)
    8000523a:	f44e                	sd	s3,40(sp)
    8000523c:	f052                	sd	s4,32(sp)
    8000523e:	ec56                	sd	s5,24(sp)
    80005240:	0880                	addi	s0,sp,80
    80005242:	89ae                	mv	s3,a1
    80005244:	8ab2                	mv	s5,a2
    80005246:	8a36                	mv	s4,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    80005248:	fb040593          	addi	a1,s0,-80
    8000524c:	fffff097          	auipc	ra,0xfffff
    80005250:	e4a080e7          	jalr	-438(ra) # 80004096 <nameiparent>
    80005254:	892a                	mv	s2,a0
    80005256:	12050e63          	beqz	a0,80005392 <create+0x162>
        return 0;

    ilock(dp);
    8000525a:	ffffe097          	auipc	ra,0xffffe
    8000525e:	39a080e7          	jalr	922(ra) # 800035f4 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    80005262:	4601                	li	a2,0
    80005264:	fb040593          	addi	a1,s0,-80
    80005268:	854a                	mv	a0,s2
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	984080e7          	jalr	-1660(ra) # 80003bee <dirlookup>
    80005272:	84aa                	mv	s1,a0
    80005274:	c921                	beqz	a0,800052c4 <create+0x94>
    {
        iunlockput(dp);
    80005276:	854a                	mv	a0,s2
    80005278:	ffffe097          	auipc	ra,0xffffe
    8000527c:	6f4080e7          	jalr	1780(ra) # 8000396c <iunlockput>
        ilock(ip);
    80005280:	8526                	mv	a0,s1
    80005282:	ffffe097          	auipc	ra,0xffffe
    80005286:	372080e7          	jalr	882(ra) # 800035f4 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000528a:	2981                	sext.w	s3,s3
    8000528c:	4789                	li	a5,2
    8000528e:	02f99463          	bne	s3,a5,800052b6 <create+0x86>
    80005292:	0444d783          	lhu	a5,68(s1)
    80005296:	37f9                	addiw	a5,a5,-2
    80005298:	17c2                	slli	a5,a5,0x30
    8000529a:	93c1                	srli	a5,a5,0x30
    8000529c:	4705                	li	a4,1
    8000529e:	00f76c63          	bltu	a4,a5,800052b6 <create+0x86>
        panic("create: dirlink");

    iunlockput(dp);

    return ip;
}
    800052a2:	8526                	mv	a0,s1
    800052a4:	60a6                	ld	ra,72(sp)
    800052a6:	6406                	ld	s0,64(sp)
    800052a8:	74e2                	ld	s1,56(sp)
    800052aa:	7942                	ld	s2,48(sp)
    800052ac:	79a2                	ld	s3,40(sp)
    800052ae:	7a02                	ld	s4,32(sp)
    800052b0:	6ae2                	ld	s5,24(sp)
    800052b2:	6161                	addi	sp,sp,80
    800052b4:	8082                	ret
        iunlockput(ip);
    800052b6:	8526                	mv	a0,s1
    800052b8:	ffffe097          	auipc	ra,0xffffe
    800052bc:	6b4080e7          	jalr	1716(ra) # 8000396c <iunlockput>
        return 0;
    800052c0:	4481                	li	s1,0
    800052c2:	b7c5                	j	800052a2 <create+0x72>
    if ((ip = ialloc(dp->dev, type)) == 0)
    800052c4:	85ce                	mv	a1,s3
    800052c6:	00092503          	lw	a0,0(s2)
    800052ca:	ffffe097          	auipc	ra,0xffffe
    800052ce:	194080e7          	jalr	404(ra) # 8000345e <ialloc>
    800052d2:	84aa                	mv	s1,a0
    800052d4:	c521                	beqz	a0,8000531c <create+0xec>
    ilock(ip);
    800052d6:	ffffe097          	auipc	ra,0xffffe
    800052da:	31e080e7          	jalr	798(ra) # 800035f4 <ilock>
    ip->major = major;
    800052de:	05549323          	sh	s5,70(s1)
    ip->minor = minor;
    800052e2:	05449423          	sh	s4,72(s1)
    ip->nlink = 1;
    800052e6:	4a05                	li	s4,1
    800052e8:	05449523          	sh	s4,74(s1)
    iupdate(ip);
    800052ec:	8526                	mv	a0,s1
    800052ee:	ffffe097          	auipc	ra,0xffffe
    800052f2:	244080e7          	jalr	580(ra) # 80003532 <iupdate>
    if (type == T_DIR)
    800052f6:	2981                	sext.w	s3,s3
    800052f8:	03498a63          	beq	s3,s4,8000532c <create+0xfc>
    if (dirlink(dp, name, ip->inum) < 0)
    800052fc:	40d0                	lw	a2,4(s1)
    800052fe:	fb040593          	addi	a1,s0,-80
    80005302:	854a                	mv	a0,s2
    80005304:	fffff097          	auipc	ra,0xfffff
    80005308:	afa080e7          	jalr	-1286(ra) # 80003dfe <dirlink>
    8000530c:	06054b63          	bltz	a0,80005382 <create+0x152>
    iunlockput(dp);
    80005310:	854a                	mv	a0,s2
    80005312:	ffffe097          	auipc	ra,0xffffe
    80005316:	65a080e7          	jalr	1626(ra) # 8000396c <iunlockput>
    return ip;
    8000531a:	b761                	j	800052a2 <create+0x72>
        panic("create: ialloc");
    8000531c:	00003517          	auipc	a0,0x3
    80005320:	4b450513          	addi	a0,a0,1204 # 800087d0 <syscalls+0x3a8>
    80005324:	ffffb097          	auipc	ra,0xffffb
    80005328:	21e080e7          	jalr	542(ra) # 80000542 <panic>
        dp->nlink++; // for ".."
    8000532c:	04a95783          	lhu	a5,74(s2)
    80005330:	2785                	addiw	a5,a5,1
    80005332:	04f91523          	sh	a5,74(s2)
        iupdate(dp);
    80005336:	854a                	mv	a0,s2
    80005338:	ffffe097          	auipc	ra,0xffffe
    8000533c:	1fa080e7          	jalr	506(ra) # 80003532 <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005340:	40d0                	lw	a2,4(s1)
    80005342:	00003597          	auipc	a1,0x3
    80005346:	3a658593          	addi	a1,a1,934 # 800086e8 <syscalls+0x2c0>
    8000534a:	8526                	mv	a0,s1
    8000534c:	fffff097          	auipc	ra,0xfffff
    80005350:	ab2080e7          	jalr	-1358(ra) # 80003dfe <dirlink>
    80005354:	00054f63          	bltz	a0,80005372 <create+0x142>
    80005358:	00492603          	lw	a2,4(s2)
    8000535c:	00003597          	auipc	a1,0x3
    80005360:	39458593          	addi	a1,a1,916 # 800086f0 <syscalls+0x2c8>
    80005364:	8526                	mv	a0,s1
    80005366:	fffff097          	auipc	ra,0xfffff
    8000536a:	a98080e7          	jalr	-1384(ra) # 80003dfe <dirlink>
    8000536e:	f80557e3          	bgez	a0,800052fc <create+0xcc>
            panic("create dots");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	46e50513          	addi	a0,a0,1134 # 800087e0 <syscalls+0x3b8>
    8000537a:	ffffb097          	auipc	ra,0xffffb
    8000537e:	1c8080e7          	jalr	456(ra) # 80000542 <panic>
        panic("create: dirlink");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	46e50513          	addi	a0,a0,1134 # 800087f0 <syscalls+0x3c8>
    8000538a:	ffffb097          	auipc	ra,0xffffb
    8000538e:	1b8080e7          	jalr	440(ra) # 80000542 <panic>
        return 0;
    80005392:	84aa                	mv	s1,a0
    80005394:	b739                	j	800052a2 <create+0x72>

0000000080005396 <sys_dup>:
{
    80005396:	7179                	addi	sp,sp,-48
    80005398:	f406                	sd	ra,40(sp)
    8000539a:	f022                	sd	s0,32(sp)
    8000539c:	ec26                	sd	s1,24(sp)
    8000539e:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    800053a0:	fd840613          	addi	a2,s0,-40
    800053a4:	4581                	li	a1,0
    800053a6:	4501                	li	a0,0
    800053a8:	00000097          	auipc	ra,0x0
    800053ac:	dde080e7          	jalr	-546(ra) # 80005186 <argfd>
        return -1;
    800053b0:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    800053b2:	02054363          	bltz	a0,800053d8 <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    800053b6:	fd843503          	ld	a0,-40(s0)
    800053ba:	00000097          	auipc	ra,0x0
    800053be:	e34080e7          	jalr	-460(ra) # 800051ee <fdalloc>
    800053c2:	84aa                	mv	s1,a0
        return -1;
    800053c4:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    800053c6:	00054963          	bltz	a0,800053d8 <sys_dup+0x42>
    filedup(f);
    800053ca:	fd843503          	ld	a0,-40(s0)
    800053ce:	fffff097          	auipc	ra,0xfffff
    800053d2:	336080e7          	jalr	822(ra) # 80004704 <filedup>
    return fd;
    800053d6:	87a6                	mv	a5,s1
}
    800053d8:	853e                	mv	a0,a5
    800053da:	70a2                	ld	ra,40(sp)
    800053dc:	7402                	ld	s0,32(sp)
    800053de:	64e2                	ld	s1,24(sp)
    800053e0:	6145                	addi	sp,sp,48
    800053e2:	8082                	ret

00000000800053e4 <sys_read>:
{
    800053e4:	7179                	addi	sp,sp,-48
    800053e6:	f406                	sd	ra,40(sp)
    800053e8:	f022                	sd	s0,32(sp)
    800053ea:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800053ec:	fe840613          	addi	a2,s0,-24
    800053f0:	4581                	li	a1,0
    800053f2:	4501                	li	a0,0
    800053f4:	00000097          	auipc	ra,0x0
    800053f8:	d92080e7          	jalr	-622(ra) # 80005186 <argfd>
        return -1;
    800053fc:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800053fe:	04054163          	bltz	a0,80005440 <sys_read+0x5c>
    80005402:	fe440593          	addi	a1,s0,-28
    80005406:	4509                	li	a0,2
    80005408:	ffffd097          	auipc	ra,0xffffd
    8000540c:	678080e7          	jalr	1656(ra) # 80002a80 <argint>
        return -1;
    80005410:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005412:	02054763          	bltz	a0,80005440 <sys_read+0x5c>
    80005416:	fd840593          	addi	a1,s0,-40
    8000541a:	4505                	li	a0,1
    8000541c:	ffffd097          	auipc	ra,0xffffd
    80005420:	686080e7          	jalr	1670(ra) # 80002aa2 <argaddr>
        return -1;
    80005424:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005426:	00054d63          	bltz	a0,80005440 <sys_read+0x5c>
    return fileread(f, p, n);
    8000542a:	fe442603          	lw	a2,-28(s0)
    8000542e:	fd843583          	ld	a1,-40(s0)
    80005432:	fe843503          	ld	a0,-24(s0)
    80005436:	fffff097          	auipc	ra,0xfffff
    8000543a:	45c080e7          	jalr	1116(ra) # 80004892 <fileread>
    8000543e:	87aa                	mv	a5,a0
}
    80005440:	853e                	mv	a0,a5
    80005442:	70a2                	ld	ra,40(sp)
    80005444:	7402                	ld	s0,32(sp)
    80005446:	6145                	addi	sp,sp,48
    80005448:	8082                	ret

000000008000544a <sys_write>:
{
    8000544a:	7179                	addi	sp,sp,-48
    8000544c:	f406                	sd	ra,40(sp)
    8000544e:	f022                	sd	s0,32(sp)
    80005450:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005452:	fe840613          	addi	a2,s0,-24
    80005456:	4581                	li	a1,0
    80005458:	4501                	li	a0,0
    8000545a:	00000097          	auipc	ra,0x0
    8000545e:	d2c080e7          	jalr	-724(ra) # 80005186 <argfd>
        return -1;
    80005462:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005464:	04054163          	bltz	a0,800054a6 <sys_write+0x5c>
    80005468:	fe440593          	addi	a1,s0,-28
    8000546c:	4509                	li	a0,2
    8000546e:	ffffd097          	auipc	ra,0xffffd
    80005472:	612080e7          	jalr	1554(ra) # 80002a80 <argint>
        return -1;
    80005476:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005478:	02054763          	bltz	a0,800054a6 <sys_write+0x5c>
    8000547c:	fd840593          	addi	a1,s0,-40
    80005480:	4505                	li	a0,1
    80005482:	ffffd097          	auipc	ra,0xffffd
    80005486:	620080e7          	jalr	1568(ra) # 80002aa2 <argaddr>
        return -1;
    8000548a:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000548c:	00054d63          	bltz	a0,800054a6 <sys_write+0x5c>
    return filewrite(f, p, n);
    80005490:	fe442603          	lw	a2,-28(s0)
    80005494:	fd843583          	ld	a1,-40(s0)
    80005498:	fe843503          	ld	a0,-24(s0)
    8000549c:	fffff097          	auipc	ra,0xfffff
    800054a0:	4b8080e7          	jalr	1208(ra) # 80004954 <filewrite>
    800054a4:	87aa                	mv	a5,a0
}
    800054a6:	853e                	mv	a0,a5
    800054a8:	70a2                	ld	ra,40(sp)
    800054aa:	7402                	ld	s0,32(sp)
    800054ac:	6145                	addi	sp,sp,48
    800054ae:	8082                	ret

00000000800054b0 <sys_close>:
{
    800054b0:	1101                	addi	sp,sp,-32
    800054b2:	ec06                	sd	ra,24(sp)
    800054b4:	e822                	sd	s0,16(sp)
    800054b6:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    800054b8:	fe040613          	addi	a2,s0,-32
    800054bc:	fec40593          	addi	a1,s0,-20
    800054c0:	4501                	li	a0,0
    800054c2:	00000097          	auipc	ra,0x0
    800054c6:	cc4080e7          	jalr	-828(ra) # 80005186 <argfd>
        return -1;
    800054ca:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    800054cc:	02054463          	bltz	a0,800054f4 <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    800054d0:	ffffc097          	auipc	ra,0xffffc
    800054d4:	4fa080e7          	jalr	1274(ra) # 800019ca <myproc>
    800054d8:	fec42783          	lw	a5,-20(s0)
    800054dc:	07e9                	addi	a5,a5,26
    800054de:	078e                	slli	a5,a5,0x3
    800054e0:	97aa                	add	a5,a5,a0
    800054e2:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    800054e6:	fe043503          	ld	a0,-32(s0)
    800054ea:	fffff097          	auipc	ra,0xfffff
    800054ee:	26c080e7          	jalr	620(ra) # 80004756 <fileclose>
    return 0;
    800054f2:	4781                	li	a5,0
}
    800054f4:	853e                	mv	a0,a5
    800054f6:	60e2                	ld	ra,24(sp)
    800054f8:	6442                	ld	s0,16(sp)
    800054fa:	6105                	addi	sp,sp,32
    800054fc:	8082                	ret

00000000800054fe <sys_fstat>:
{
    800054fe:	1101                	addi	sp,sp,-32
    80005500:	ec06                	sd	ra,24(sp)
    80005502:	e822                	sd	s0,16(sp)
    80005504:	1000                	addi	s0,sp,32
    if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005506:	fe840613          	addi	a2,s0,-24
    8000550a:	4581                	li	a1,0
    8000550c:	4501                	li	a0,0
    8000550e:	00000097          	auipc	ra,0x0
    80005512:	c78080e7          	jalr	-904(ra) # 80005186 <argfd>
        return -1;
    80005516:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005518:	02054563          	bltz	a0,80005542 <sys_fstat+0x44>
    8000551c:	fe040593          	addi	a1,s0,-32
    80005520:	4505                	li	a0,1
    80005522:	ffffd097          	auipc	ra,0xffffd
    80005526:	580080e7          	jalr	1408(ra) # 80002aa2 <argaddr>
        return -1;
    8000552a:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000552c:	00054b63          	bltz	a0,80005542 <sys_fstat+0x44>
    return filestat(f, st);
    80005530:	fe043583          	ld	a1,-32(s0)
    80005534:	fe843503          	ld	a0,-24(s0)
    80005538:	fffff097          	auipc	ra,0xfffff
    8000553c:	2e6080e7          	jalr	742(ra) # 8000481e <filestat>
    80005540:	87aa                	mv	a5,a0
}
    80005542:	853e                	mv	a0,a5
    80005544:	60e2                	ld	ra,24(sp)
    80005546:	6442                	ld	s0,16(sp)
    80005548:	6105                	addi	sp,sp,32
    8000554a:	8082                	ret

000000008000554c <sys_link>:
{
    8000554c:	7169                	addi	sp,sp,-304
    8000554e:	f606                	sd	ra,296(sp)
    80005550:	f222                	sd	s0,288(sp)
    80005552:	ee26                	sd	s1,280(sp)
    80005554:	ea4a                	sd	s2,272(sp)
    80005556:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005558:	08000613          	li	a2,128
    8000555c:	ed040593          	addi	a1,s0,-304
    80005560:	4501                	li	a0,0
    80005562:	ffffd097          	auipc	ra,0xffffd
    80005566:	562080e7          	jalr	1378(ra) # 80002ac4 <argstr>
        return -1;
    8000556a:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000556c:	10054e63          	bltz	a0,80005688 <sys_link+0x13c>
    80005570:	08000613          	li	a2,128
    80005574:	f5040593          	addi	a1,s0,-176
    80005578:	4505                	li	a0,1
    8000557a:	ffffd097          	auipc	ra,0xffffd
    8000557e:	54a080e7          	jalr	1354(ra) # 80002ac4 <argstr>
        return -1;
    80005582:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005584:	10054263          	bltz	a0,80005688 <sys_link+0x13c>
    begin_op();
    80005588:	fffff097          	auipc	ra,0xfffff
    8000558c:	cfc080e7          	jalr	-772(ra) # 80004284 <begin_op>
    if ((ip = namei(old)) == 0)
    80005590:	ed040513          	addi	a0,s0,-304
    80005594:	fffff097          	auipc	ra,0xfffff
    80005598:	92c080e7          	jalr	-1748(ra) # 80003ec0 <namei>
    8000559c:	84aa                	mv	s1,a0
    8000559e:	c551                	beqz	a0,8000562a <sys_link+0xde>
    ilock(ip);
    800055a0:	ffffe097          	auipc	ra,0xffffe
    800055a4:	054080e7          	jalr	84(ra) # 800035f4 <ilock>
    if (ip->type == T_DIR)
    800055a8:	04449703          	lh	a4,68(s1)
    800055ac:	4785                	li	a5,1
    800055ae:	08f70463          	beq	a4,a5,80005636 <sys_link+0xea>
    ip->nlink++;
    800055b2:	04a4d783          	lhu	a5,74(s1)
    800055b6:	2785                	addiw	a5,a5,1
    800055b8:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800055bc:	8526                	mv	a0,s1
    800055be:	ffffe097          	auipc	ra,0xffffe
    800055c2:	f74080e7          	jalr	-140(ra) # 80003532 <iupdate>
    iunlock(ip);
    800055c6:	8526                	mv	a0,s1
    800055c8:	ffffe097          	auipc	ra,0xffffe
    800055cc:	0e6080e7          	jalr	230(ra) # 800036ae <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    800055d0:	fd040593          	addi	a1,s0,-48
    800055d4:	f5040513          	addi	a0,s0,-176
    800055d8:	fffff097          	auipc	ra,0xfffff
    800055dc:	abe080e7          	jalr	-1346(ra) # 80004096 <nameiparent>
    800055e0:	892a                	mv	s2,a0
    800055e2:	c935                	beqz	a0,80005656 <sys_link+0x10a>
    ilock(dp);
    800055e4:	ffffe097          	auipc	ra,0xffffe
    800055e8:	010080e7          	jalr	16(ra) # 800035f4 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    800055ec:	00092703          	lw	a4,0(s2)
    800055f0:	409c                	lw	a5,0(s1)
    800055f2:	04f71d63          	bne	a4,a5,8000564c <sys_link+0x100>
    800055f6:	40d0                	lw	a2,4(s1)
    800055f8:	fd040593          	addi	a1,s0,-48
    800055fc:	854a                	mv	a0,s2
    800055fe:	fffff097          	auipc	ra,0xfffff
    80005602:	800080e7          	jalr	-2048(ra) # 80003dfe <dirlink>
    80005606:	04054363          	bltz	a0,8000564c <sys_link+0x100>
    iunlockput(dp);
    8000560a:	854a                	mv	a0,s2
    8000560c:	ffffe097          	auipc	ra,0xffffe
    80005610:	360080e7          	jalr	864(ra) # 8000396c <iunlockput>
    iput(ip);
    80005614:	8526                	mv	a0,s1
    80005616:	ffffe097          	auipc	ra,0xffffe
    8000561a:	2ae080e7          	jalr	686(ra) # 800038c4 <iput>
    end_op();
    8000561e:	fffff097          	auipc	ra,0xfffff
    80005622:	ce6080e7          	jalr	-794(ra) # 80004304 <end_op>
    return 0;
    80005626:	4781                	li	a5,0
    80005628:	a085                	j	80005688 <sys_link+0x13c>
        end_op();
    8000562a:	fffff097          	auipc	ra,0xfffff
    8000562e:	cda080e7          	jalr	-806(ra) # 80004304 <end_op>
        return -1;
    80005632:	57fd                	li	a5,-1
    80005634:	a891                	j	80005688 <sys_link+0x13c>
        iunlockput(ip);
    80005636:	8526                	mv	a0,s1
    80005638:	ffffe097          	auipc	ra,0xffffe
    8000563c:	334080e7          	jalr	820(ra) # 8000396c <iunlockput>
        end_op();
    80005640:	fffff097          	auipc	ra,0xfffff
    80005644:	cc4080e7          	jalr	-828(ra) # 80004304 <end_op>
        return -1;
    80005648:	57fd                	li	a5,-1
    8000564a:	a83d                	j	80005688 <sys_link+0x13c>
        iunlockput(dp);
    8000564c:	854a                	mv	a0,s2
    8000564e:	ffffe097          	auipc	ra,0xffffe
    80005652:	31e080e7          	jalr	798(ra) # 8000396c <iunlockput>
    ilock(ip);
    80005656:	8526                	mv	a0,s1
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	f9c080e7          	jalr	-100(ra) # 800035f4 <ilock>
    ip->nlink--;
    80005660:	04a4d783          	lhu	a5,74(s1)
    80005664:	37fd                	addiw	a5,a5,-1
    80005666:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    8000566a:	8526                	mv	a0,s1
    8000566c:	ffffe097          	auipc	ra,0xffffe
    80005670:	ec6080e7          	jalr	-314(ra) # 80003532 <iupdate>
    iunlockput(ip);
    80005674:	8526                	mv	a0,s1
    80005676:	ffffe097          	auipc	ra,0xffffe
    8000567a:	2f6080e7          	jalr	758(ra) # 8000396c <iunlockput>
    end_op();
    8000567e:	fffff097          	auipc	ra,0xfffff
    80005682:	c86080e7          	jalr	-890(ra) # 80004304 <end_op>
    return -1;
    80005686:	57fd                	li	a5,-1
}
    80005688:	853e                	mv	a0,a5
    8000568a:	70b2                	ld	ra,296(sp)
    8000568c:	7412                	ld	s0,288(sp)
    8000568e:	64f2                	ld	s1,280(sp)
    80005690:	6952                	ld	s2,272(sp)
    80005692:	6155                	addi	sp,sp,304
    80005694:	8082                	ret

0000000080005696 <sys_unlink>:
{
    80005696:	7151                	addi	sp,sp,-240
    80005698:	f586                	sd	ra,232(sp)
    8000569a:	f1a2                	sd	s0,224(sp)
    8000569c:	eda6                	sd	s1,216(sp)
    8000569e:	e9ca                	sd	s2,208(sp)
    800056a0:	e5ce                	sd	s3,200(sp)
    800056a2:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    800056a4:	08000613          	li	a2,128
    800056a8:	f3040593          	addi	a1,s0,-208
    800056ac:	4501                	li	a0,0
    800056ae:	ffffd097          	auipc	ra,0xffffd
    800056b2:	416080e7          	jalr	1046(ra) # 80002ac4 <argstr>
    800056b6:	18054163          	bltz	a0,80005838 <sys_unlink+0x1a2>
    begin_op();
    800056ba:	fffff097          	auipc	ra,0xfffff
    800056be:	bca080e7          	jalr	-1078(ra) # 80004284 <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    800056c2:	fb040593          	addi	a1,s0,-80
    800056c6:	f3040513          	addi	a0,s0,-208
    800056ca:	fffff097          	auipc	ra,0xfffff
    800056ce:	9cc080e7          	jalr	-1588(ra) # 80004096 <nameiparent>
    800056d2:	84aa                	mv	s1,a0
    800056d4:	c979                	beqz	a0,800057aa <sys_unlink+0x114>
    ilock(dp);
    800056d6:	ffffe097          	auipc	ra,0xffffe
    800056da:	f1e080e7          	jalr	-226(ra) # 800035f4 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800056de:	00003597          	auipc	a1,0x3
    800056e2:	00a58593          	addi	a1,a1,10 # 800086e8 <syscalls+0x2c0>
    800056e6:	fb040513          	addi	a0,s0,-80
    800056ea:	ffffe097          	auipc	ra,0xffffe
    800056ee:	4ea080e7          	jalr	1258(ra) # 80003bd4 <namecmp>
    800056f2:	14050a63          	beqz	a0,80005846 <sys_unlink+0x1b0>
    800056f6:	00003597          	auipc	a1,0x3
    800056fa:	ffa58593          	addi	a1,a1,-6 # 800086f0 <syscalls+0x2c8>
    800056fe:	fb040513          	addi	a0,s0,-80
    80005702:	ffffe097          	auipc	ra,0xffffe
    80005706:	4d2080e7          	jalr	1234(ra) # 80003bd4 <namecmp>
    8000570a:	12050e63          	beqz	a0,80005846 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    8000570e:	f2c40613          	addi	a2,s0,-212
    80005712:	fb040593          	addi	a1,s0,-80
    80005716:	8526                	mv	a0,s1
    80005718:	ffffe097          	auipc	ra,0xffffe
    8000571c:	4d6080e7          	jalr	1238(ra) # 80003bee <dirlookup>
    80005720:	892a                	mv	s2,a0
    80005722:	12050263          	beqz	a0,80005846 <sys_unlink+0x1b0>
    ilock(ip);
    80005726:	ffffe097          	auipc	ra,0xffffe
    8000572a:	ece080e7          	jalr	-306(ra) # 800035f4 <ilock>
    if (ip->nlink < 1)
    8000572e:	04a91783          	lh	a5,74(s2)
    80005732:	08f05263          	blez	a5,800057b6 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80005736:	04491703          	lh	a4,68(s2)
    8000573a:	4785                	li	a5,1
    8000573c:	08f70563          	beq	a4,a5,800057c6 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80005740:	4641                	li	a2,16
    80005742:	4581                	li	a1,0
    80005744:	fc040513          	addi	a0,s0,-64
    80005748:	ffffb097          	auipc	ra,0xffffb
    8000574c:	5b2080e7          	jalr	1458(ra) # 80000cfa <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005750:	4741                	li	a4,16
    80005752:	f2c42683          	lw	a3,-212(s0)
    80005756:	fc040613          	addi	a2,s0,-64
    8000575a:	4581                	li	a1,0
    8000575c:	8526                	mv	a0,s1
    8000575e:	ffffe097          	auipc	ra,0xffffe
    80005762:	35e080e7          	jalr	862(ra) # 80003abc <writei>
    80005766:	47c1                	li	a5,16
    80005768:	0af51563          	bne	a0,a5,80005812 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    8000576c:	04491703          	lh	a4,68(s2)
    80005770:	4785                	li	a5,1
    80005772:	0af70863          	beq	a4,a5,80005822 <sys_unlink+0x18c>
    iunlockput(dp);
    80005776:	8526                	mv	a0,s1
    80005778:	ffffe097          	auipc	ra,0xffffe
    8000577c:	1f4080e7          	jalr	500(ra) # 8000396c <iunlockput>
    ip->nlink--;
    80005780:	04a95783          	lhu	a5,74(s2)
    80005784:	37fd                	addiw	a5,a5,-1
    80005786:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    8000578a:	854a                	mv	a0,s2
    8000578c:	ffffe097          	auipc	ra,0xffffe
    80005790:	da6080e7          	jalr	-602(ra) # 80003532 <iupdate>
    iunlockput(ip);
    80005794:	854a                	mv	a0,s2
    80005796:	ffffe097          	auipc	ra,0xffffe
    8000579a:	1d6080e7          	jalr	470(ra) # 8000396c <iunlockput>
    end_op();
    8000579e:	fffff097          	auipc	ra,0xfffff
    800057a2:	b66080e7          	jalr	-1178(ra) # 80004304 <end_op>
    return 0;
    800057a6:	4501                	li	a0,0
    800057a8:	a84d                	j	8000585a <sys_unlink+0x1c4>
        end_op();
    800057aa:	fffff097          	auipc	ra,0xfffff
    800057ae:	b5a080e7          	jalr	-1190(ra) # 80004304 <end_op>
        return -1;
    800057b2:	557d                	li	a0,-1
    800057b4:	a05d                	j	8000585a <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    800057b6:	00003517          	auipc	a0,0x3
    800057ba:	04a50513          	addi	a0,a0,74 # 80008800 <syscalls+0x3d8>
    800057be:	ffffb097          	auipc	ra,0xffffb
    800057c2:	d84080e7          	jalr	-636(ra) # 80000542 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    800057c6:	04c92703          	lw	a4,76(s2)
    800057ca:	02000793          	li	a5,32
    800057ce:	f6e7f9e3          	bgeu	a5,a4,80005740 <sys_unlink+0xaa>
    800057d2:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057d6:	4741                	li	a4,16
    800057d8:	86ce                	mv	a3,s3
    800057da:	f1840613          	addi	a2,s0,-232
    800057de:	4581                	li	a1,0
    800057e0:	854a                	mv	a0,s2
    800057e2:	ffffe097          	auipc	ra,0xffffe
    800057e6:	1e4080e7          	jalr	484(ra) # 800039c6 <readi>
    800057ea:	47c1                	li	a5,16
    800057ec:	00f51b63          	bne	a0,a5,80005802 <sys_unlink+0x16c>
        if (de.inum != 0)
    800057f0:	f1845783          	lhu	a5,-232(s0)
    800057f4:	e7a1                	bnez	a5,8000583c <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    800057f6:	29c1                	addiw	s3,s3,16
    800057f8:	04c92783          	lw	a5,76(s2)
    800057fc:	fcf9ede3          	bltu	s3,a5,800057d6 <sys_unlink+0x140>
    80005800:	b781                	j	80005740 <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80005802:	00003517          	auipc	a0,0x3
    80005806:	01650513          	addi	a0,a0,22 # 80008818 <syscalls+0x3f0>
    8000580a:	ffffb097          	auipc	ra,0xffffb
    8000580e:	d38080e7          	jalr	-712(ra) # 80000542 <panic>
        panic("unlink: writei");
    80005812:	00003517          	auipc	a0,0x3
    80005816:	01e50513          	addi	a0,a0,30 # 80008830 <syscalls+0x408>
    8000581a:	ffffb097          	auipc	ra,0xffffb
    8000581e:	d28080e7          	jalr	-728(ra) # 80000542 <panic>
        dp->nlink--;
    80005822:	04a4d783          	lhu	a5,74(s1)
    80005826:	37fd                	addiw	a5,a5,-1
    80005828:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    8000582c:	8526                	mv	a0,s1
    8000582e:	ffffe097          	auipc	ra,0xffffe
    80005832:	d04080e7          	jalr	-764(ra) # 80003532 <iupdate>
    80005836:	b781                	j	80005776 <sys_unlink+0xe0>
        return -1;
    80005838:	557d                	li	a0,-1
    8000583a:	a005                	j	8000585a <sys_unlink+0x1c4>
        iunlockput(ip);
    8000583c:	854a                	mv	a0,s2
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	12e080e7          	jalr	302(ra) # 8000396c <iunlockput>
    iunlockput(dp);
    80005846:	8526                	mv	a0,s1
    80005848:	ffffe097          	auipc	ra,0xffffe
    8000584c:	124080e7          	jalr	292(ra) # 8000396c <iunlockput>
    end_op();
    80005850:	fffff097          	auipc	ra,0xfffff
    80005854:	ab4080e7          	jalr	-1356(ra) # 80004304 <end_op>
    return -1;
    80005858:	557d                	li	a0,-1
}
    8000585a:	70ae                	ld	ra,232(sp)
    8000585c:	740e                	ld	s0,224(sp)
    8000585e:	64ee                	ld	s1,216(sp)
    80005860:	694e                	ld	s2,208(sp)
    80005862:	69ae                	ld	s3,200(sp)
    80005864:	616d                	addi	sp,sp,240
    80005866:	8082                	ret

0000000080005868 <sys_open>:

/* TODO: Access Control & Symbolic Link */
uint64 sys_open(void)
{
    80005868:	7131                	addi	sp,sp,-192
    8000586a:	fd06                	sd	ra,184(sp)
    8000586c:	f922                	sd	s0,176(sp)
    8000586e:	f526                	sd	s1,168(sp)
    80005870:	f14a                	sd	s2,160(sp)
    80005872:	ed4e                	sd	s3,152(sp)
    80005874:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005876:	08000613          	li	a2,128
    8000587a:	f5040593          	addi	a1,s0,-176
    8000587e:	4501                	li	a0,0
    80005880:	ffffd097          	auipc	ra,0xffffd
    80005884:	244080e7          	jalr	580(ra) # 80002ac4 <argstr>
        return -1;
    80005888:	54fd                	li	s1,-1
    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000588a:	0c054163          	bltz	a0,8000594c <sys_open+0xe4>
    8000588e:	f4c40593          	addi	a1,s0,-180
    80005892:	4505                	li	a0,1
    80005894:	ffffd097          	auipc	ra,0xffffd
    80005898:	1ec080e7          	jalr	492(ra) # 80002a80 <argint>
    8000589c:	0a054863          	bltz	a0,8000594c <sys_open+0xe4>

    begin_op();
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	9e4080e7          	jalr	-1564(ra) # 80004284 <begin_op>

    if (omode & O_CREATE)
    800058a8:	f4c42783          	lw	a5,-180(s0)
    800058ac:	2007f793          	andi	a5,a5,512
    800058b0:	cbdd                	beqz	a5,80005966 <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    800058b2:	4681                	li	a3,0
    800058b4:	4601                	li	a2,0
    800058b6:	4589                	li	a1,2
    800058b8:	f5040513          	addi	a0,s0,-176
    800058bc:	00000097          	auipc	ra,0x0
    800058c0:	974080e7          	jalr	-1676(ra) # 80005230 <create>
    800058c4:	892a                	mv	s2,a0
        if (ip == 0)
    800058c6:	c959                	beqz	a0,8000595c <sys_open+0xf4>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    800058c8:	04491703          	lh	a4,68(s2)
    800058cc:	478d                	li	a5,3
    800058ce:	00f71763          	bne	a4,a5,800058dc <sys_open+0x74>
    800058d2:	04695703          	lhu	a4,70(s2)
    800058d6:	47a5                	li	a5,9
    800058d8:	0ce7ec63          	bltu	a5,a4,800059b0 <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    800058dc:	fffff097          	auipc	ra,0xfffff
    800058e0:	dbe080e7          	jalr	-578(ra) # 8000469a <filealloc>
    800058e4:	89aa                	mv	s3,a0
    800058e6:	10050263          	beqz	a0,800059ea <sys_open+0x182>
    800058ea:	00000097          	auipc	ra,0x0
    800058ee:	904080e7          	jalr	-1788(ra) # 800051ee <fdalloc>
    800058f2:	84aa                	mv	s1,a0
    800058f4:	0e054663          	bltz	a0,800059e0 <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    800058f8:	04491703          	lh	a4,68(s2)
    800058fc:	478d                	li	a5,3
    800058fe:	0cf70463          	beq	a4,a5,800059c6 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80005902:	4789                	li	a5,2
    80005904:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80005908:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    8000590c:	0129bc23          	sd	s2,24(s3)
    f->readable = !(omode & O_WRONLY);
    80005910:	f4c42783          	lw	a5,-180(s0)
    80005914:	0017c713          	xori	a4,a5,1
    80005918:	8b05                	andi	a4,a4,1
    8000591a:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000591e:	0037f713          	andi	a4,a5,3
    80005922:	00e03733          	snez	a4,a4
    80005926:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    8000592a:	4007f793          	andi	a5,a5,1024
    8000592e:	c791                	beqz	a5,8000593a <sys_open+0xd2>
    80005930:	04491703          	lh	a4,68(s2)
    80005934:	4789                	li	a5,2
    80005936:	08f70f63          	beq	a4,a5,800059d4 <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    8000593a:	854a                	mv	a0,s2
    8000593c:	ffffe097          	auipc	ra,0xffffe
    80005940:	d72080e7          	jalr	-654(ra) # 800036ae <iunlock>
    end_op();
    80005944:	fffff097          	auipc	ra,0xfffff
    80005948:	9c0080e7          	jalr	-1600(ra) # 80004304 <end_op>

    return fd;
}
    8000594c:	8526                	mv	a0,s1
    8000594e:	70ea                	ld	ra,184(sp)
    80005950:	744a                	ld	s0,176(sp)
    80005952:	74aa                	ld	s1,168(sp)
    80005954:	790a                	ld	s2,160(sp)
    80005956:	69ea                	ld	s3,152(sp)
    80005958:	6129                	addi	sp,sp,192
    8000595a:	8082                	ret
            end_op();
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	9a8080e7          	jalr	-1624(ra) # 80004304 <end_op>
            return -1;
    80005964:	b7e5                	j	8000594c <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    80005966:	f5040513          	addi	a0,s0,-176
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	556080e7          	jalr	1366(ra) # 80003ec0 <namei>
    80005972:	892a                	mv	s2,a0
    80005974:	c905                	beqz	a0,800059a4 <sys_open+0x13c>
        ilock(ip);
    80005976:	ffffe097          	auipc	ra,0xffffe
    8000597a:	c7e080e7          	jalr	-898(ra) # 800035f4 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    8000597e:	04491703          	lh	a4,68(s2)
    80005982:	4785                	li	a5,1
    80005984:	f4f712e3          	bne	a4,a5,800058c8 <sys_open+0x60>
    80005988:	f4c42783          	lw	a5,-180(s0)
    8000598c:	dba1                	beqz	a5,800058dc <sys_open+0x74>
            iunlockput(ip);
    8000598e:	854a                	mv	a0,s2
    80005990:	ffffe097          	auipc	ra,0xffffe
    80005994:	fdc080e7          	jalr	-36(ra) # 8000396c <iunlockput>
            end_op();
    80005998:	fffff097          	auipc	ra,0xfffff
    8000599c:	96c080e7          	jalr	-1684(ra) # 80004304 <end_op>
            return -1;
    800059a0:	54fd                	li	s1,-1
    800059a2:	b76d                	j	8000594c <sys_open+0xe4>
            end_op();
    800059a4:	fffff097          	auipc	ra,0xfffff
    800059a8:	960080e7          	jalr	-1696(ra) # 80004304 <end_op>
            return -1;
    800059ac:	54fd                	li	s1,-1
    800059ae:	bf79                	j	8000594c <sys_open+0xe4>
        iunlockput(ip);
    800059b0:	854a                	mv	a0,s2
    800059b2:	ffffe097          	auipc	ra,0xffffe
    800059b6:	fba080e7          	jalr	-70(ra) # 8000396c <iunlockput>
        end_op();
    800059ba:	fffff097          	auipc	ra,0xfffff
    800059be:	94a080e7          	jalr	-1718(ra) # 80004304 <end_op>
        return -1;
    800059c2:	54fd                	li	s1,-1
    800059c4:	b761                	j	8000594c <sys_open+0xe4>
        f->type = FD_DEVICE;
    800059c6:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    800059ca:	04691783          	lh	a5,70(s2)
    800059ce:	02f99223          	sh	a5,36(s3)
    800059d2:	bf2d                	j	8000590c <sys_open+0xa4>
        itrunc(ip);
    800059d4:	854a                	mv	a0,s2
    800059d6:	ffffe097          	auipc	ra,0xffffe
    800059da:	e42080e7          	jalr	-446(ra) # 80003818 <itrunc>
    800059de:	bfb1                	j	8000593a <sys_open+0xd2>
            fileclose(f);
    800059e0:	854e                	mv	a0,s3
    800059e2:	fffff097          	auipc	ra,0xfffff
    800059e6:	d74080e7          	jalr	-652(ra) # 80004756 <fileclose>
        iunlockput(ip);
    800059ea:	854a                	mv	a0,s2
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	f80080e7          	jalr	-128(ra) # 8000396c <iunlockput>
        end_op();
    800059f4:	fffff097          	auipc	ra,0xfffff
    800059f8:	910080e7          	jalr	-1776(ra) # 80004304 <end_op>
        return -1;
    800059fc:	54fd                	li	s1,-1
    800059fe:	b7b9                	j	8000594c <sys_open+0xe4>

0000000080005a00 <sys_mkdir>:

uint64 sys_mkdir(void)
{
    80005a00:	7175                	addi	sp,sp,-144
    80005a02:	e506                	sd	ra,136(sp)
    80005a04:	e122                	sd	s0,128(sp)
    80005a06:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80005a08:	fffff097          	auipc	ra,0xfffff
    80005a0c:	87c080e7          	jalr	-1924(ra) # 80004284 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80005a10:	08000613          	li	a2,128
    80005a14:	f7040593          	addi	a1,s0,-144
    80005a18:	4501                	li	a0,0
    80005a1a:	ffffd097          	auipc	ra,0xffffd
    80005a1e:	0aa080e7          	jalr	170(ra) # 80002ac4 <argstr>
    80005a22:	02054963          	bltz	a0,80005a54 <sys_mkdir+0x54>
    80005a26:	4681                	li	a3,0
    80005a28:	4601                	li	a2,0
    80005a2a:	4585                	li	a1,1
    80005a2c:	f7040513          	addi	a0,s0,-144
    80005a30:	00000097          	auipc	ra,0x0
    80005a34:	800080e7          	jalr	-2048(ra) # 80005230 <create>
    80005a38:	cd11                	beqz	a0,80005a54 <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005a3a:	ffffe097          	auipc	ra,0xffffe
    80005a3e:	f32080e7          	jalr	-206(ra) # 8000396c <iunlockput>
    end_op();
    80005a42:	fffff097          	auipc	ra,0xfffff
    80005a46:	8c2080e7          	jalr	-1854(ra) # 80004304 <end_op>
    return 0;
    80005a4a:	4501                	li	a0,0
}
    80005a4c:	60aa                	ld	ra,136(sp)
    80005a4e:	640a                	ld	s0,128(sp)
    80005a50:	6149                	addi	sp,sp,144
    80005a52:	8082                	ret
        end_op();
    80005a54:	fffff097          	auipc	ra,0xfffff
    80005a58:	8b0080e7          	jalr	-1872(ra) # 80004304 <end_op>
        return -1;
    80005a5c:	557d                	li	a0,-1
    80005a5e:	b7fd                	j	80005a4c <sys_mkdir+0x4c>

0000000080005a60 <sys_mknod>:

uint64 sys_mknod(void)
{
    80005a60:	7135                	addi	sp,sp,-160
    80005a62:	ed06                	sd	ra,152(sp)
    80005a64:	e922                	sd	s0,144(sp)
    80005a66:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80005a68:	fffff097          	auipc	ra,0xfffff
    80005a6c:	81c080e7          	jalr	-2020(ra) # 80004284 <begin_op>
    if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005a70:	08000613          	li	a2,128
    80005a74:	f7040593          	addi	a1,s0,-144
    80005a78:	4501                	li	a0,0
    80005a7a:	ffffd097          	auipc	ra,0xffffd
    80005a7e:	04a080e7          	jalr	74(ra) # 80002ac4 <argstr>
    80005a82:	04054a63          	bltz	a0,80005ad6 <sys_mknod+0x76>
    80005a86:	f6c40593          	addi	a1,s0,-148
    80005a8a:	4505                	li	a0,1
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	ff4080e7          	jalr	-12(ra) # 80002a80 <argint>
    80005a94:	04054163          	bltz	a0,80005ad6 <sys_mknod+0x76>
        argint(2, &minor) < 0 ||
    80005a98:	f6840593          	addi	a1,s0,-152
    80005a9c:	4509                	li	a0,2
    80005a9e:	ffffd097          	auipc	ra,0xffffd
    80005aa2:	fe2080e7          	jalr	-30(ra) # 80002a80 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005aa6:	02054863          	bltz	a0,80005ad6 <sys_mknod+0x76>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    80005aaa:	f6841683          	lh	a3,-152(s0)
    80005aae:	f6c41603          	lh	a2,-148(s0)
    80005ab2:	458d                	li	a1,3
    80005ab4:	f7040513          	addi	a0,s0,-144
    80005ab8:	fffff097          	auipc	ra,0xfffff
    80005abc:	778080e7          	jalr	1912(ra) # 80005230 <create>
        argint(2, &minor) < 0 ||
    80005ac0:	c919                	beqz	a0,80005ad6 <sys_mknod+0x76>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005ac2:	ffffe097          	auipc	ra,0xffffe
    80005ac6:	eaa080e7          	jalr	-342(ra) # 8000396c <iunlockput>
    end_op();
    80005aca:	fffff097          	auipc	ra,0xfffff
    80005ace:	83a080e7          	jalr	-1990(ra) # 80004304 <end_op>
    return 0;
    80005ad2:	4501                	li	a0,0
    80005ad4:	a031                	j	80005ae0 <sys_mknod+0x80>
        end_op();
    80005ad6:	fffff097          	auipc	ra,0xfffff
    80005ada:	82e080e7          	jalr	-2002(ra) # 80004304 <end_op>
        return -1;
    80005ade:	557d                	li	a0,-1
}
    80005ae0:	60ea                	ld	ra,152(sp)
    80005ae2:	644a                	ld	s0,144(sp)
    80005ae4:	610d                	addi	sp,sp,160
    80005ae6:	8082                	ret

0000000080005ae8 <sys_chdir>:

uint64 sys_chdir(void)
{
    80005ae8:	7135                	addi	sp,sp,-160
    80005aea:	ed06                	sd	ra,152(sp)
    80005aec:	e922                	sd	s0,144(sp)
    80005aee:	e526                	sd	s1,136(sp)
    80005af0:	e14a                	sd	s2,128(sp)
    80005af2:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80005af4:	ffffc097          	auipc	ra,0xffffc
    80005af8:	ed6080e7          	jalr	-298(ra) # 800019ca <myproc>
    80005afc:	892a                	mv	s2,a0

    begin_op();
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	786080e7          	jalr	1926(ra) # 80004284 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80005b06:	08000613          	li	a2,128
    80005b0a:	f6040593          	addi	a1,s0,-160
    80005b0e:	4501                	li	a0,0
    80005b10:	ffffd097          	auipc	ra,0xffffd
    80005b14:	fb4080e7          	jalr	-76(ra) # 80002ac4 <argstr>
    80005b18:	04054b63          	bltz	a0,80005b6e <sys_chdir+0x86>
    80005b1c:	f6040513          	addi	a0,s0,-160
    80005b20:	ffffe097          	auipc	ra,0xffffe
    80005b24:	3a0080e7          	jalr	928(ra) # 80003ec0 <namei>
    80005b28:	84aa                	mv	s1,a0
    80005b2a:	c131                	beqz	a0,80005b6e <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    80005b2c:	ffffe097          	auipc	ra,0xffffe
    80005b30:	ac8080e7          	jalr	-1336(ra) # 800035f4 <ilock>
    if (ip->type != T_DIR)
    80005b34:	04449703          	lh	a4,68(s1)
    80005b38:	4785                	li	a5,1
    80005b3a:	04f71063          	bne	a4,a5,80005b7a <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80005b3e:	8526                	mv	a0,s1
    80005b40:	ffffe097          	auipc	ra,0xffffe
    80005b44:	b6e080e7          	jalr	-1170(ra) # 800036ae <iunlock>
    iput(p->cwd);
    80005b48:	15093503          	ld	a0,336(s2)
    80005b4c:	ffffe097          	auipc	ra,0xffffe
    80005b50:	d78080e7          	jalr	-648(ra) # 800038c4 <iput>
    end_op();
    80005b54:	ffffe097          	auipc	ra,0xffffe
    80005b58:	7b0080e7          	jalr	1968(ra) # 80004304 <end_op>
    p->cwd = ip;
    80005b5c:	14993823          	sd	s1,336(s2)
    return 0;
    80005b60:	4501                	li	a0,0
}
    80005b62:	60ea                	ld	ra,152(sp)
    80005b64:	644a                	ld	s0,144(sp)
    80005b66:	64aa                	ld	s1,136(sp)
    80005b68:	690a                	ld	s2,128(sp)
    80005b6a:	610d                	addi	sp,sp,160
    80005b6c:	8082                	ret
        end_op();
    80005b6e:	ffffe097          	auipc	ra,0xffffe
    80005b72:	796080e7          	jalr	1942(ra) # 80004304 <end_op>
        return -1;
    80005b76:	557d                	li	a0,-1
    80005b78:	b7ed                	j	80005b62 <sys_chdir+0x7a>
        iunlockput(ip);
    80005b7a:	8526                	mv	a0,s1
    80005b7c:	ffffe097          	auipc	ra,0xffffe
    80005b80:	df0080e7          	jalr	-528(ra) # 8000396c <iunlockput>
        end_op();
    80005b84:	ffffe097          	auipc	ra,0xffffe
    80005b88:	780080e7          	jalr	1920(ra) # 80004304 <end_op>
        return -1;
    80005b8c:	557d                	li	a0,-1
    80005b8e:	bfd1                	j	80005b62 <sys_chdir+0x7a>

0000000080005b90 <sys_exec>:

uint64 sys_exec(void)
{
    80005b90:	7145                	addi	sp,sp,-464
    80005b92:	e786                	sd	ra,456(sp)
    80005b94:	e3a2                	sd	s0,448(sp)
    80005b96:	ff26                	sd	s1,440(sp)
    80005b98:	fb4a                	sd	s2,432(sp)
    80005b9a:	f74e                	sd	s3,424(sp)
    80005b9c:	f352                	sd	s4,416(sp)
    80005b9e:	ef56                	sd	s5,408(sp)
    80005ba0:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80005ba2:	08000613          	li	a2,128
    80005ba6:	f4040593          	addi	a1,s0,-192
    80005baa:	4501                	li	a0,0
    80005bac:	ffffd097          	auipc	ra,0xffffd
    80005bb0:	f18080e7          	jalr	-232(ra) # 80002ac4 <argstr>
    {
        return -1;
    80005bb4:	597d                	li	s2,-1
    if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80005bb6:	0c054a63          	bltz	a0,80005c8a <sys_exec+0xfa>
    80005bba:	e3840593          	addi	a1,s0,-456
    80005bbe:	4505                	li	a0,1
    80005bc0:	ffffd097          	auipc	ra,0xffffd
    80005bc4:	ee2080e7          	jalr	-286(ra) # 80002aa2 <argaddr>
    80005bc8:	0c054163          	bltz	a0,80005c8a <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    80005bcc:	10000613          	li	a2,256
    80005bd0:	4581                	li	a1,0
    80005bd2:	e4040513          	addi	a0,s0,-448
    80005bd6:	ffffb097          	auipc	ra,0xffffb
    80005bda:	124080e7          	jalr	292(ra) # 80000cfa <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    80005bde:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    80005be2:	89a6                	mv	s3,s1
    80005be4:	4901                	li	s2,0
        if (i >= NELEM(argv))
    80005be6:	02000a13          	li	s4,32
    80005bea:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80005bee:	00391793          	slli	a5,s2,0x3
    80005bf2:	e3040593          	addi	a1,s0,-464
    80005bf6:	e3843503          	ld	a0,-456(s0)
    80005bfa:	953e                	add	a0,a0,a5
    80005bfc:	ffffd097          	auipc	ra,0xffffd
    80005c00:	dea080e7          	jalr	-534(ra) # 800029e6 <fetchaddr>
    80005c04:	02054a63          	bltz	a0,80005c38 <sys_exec+0xa8>
        {
            goto bad;
        }
        if (uarg == 0)
    80005c08:	e3043783          	ld	a5,-464(s0)
    80005c0c:	c3b9                	beqz	a5,80005c52 <sys_exec+0xc2>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    80005c0e:	ffffb097          	auipc	ra,0xffffb
    80005c12:	f00080e7          	jalr	-256(ra) # 80000b0e <kalloc>
    80005c16:	85aa                	mv	a1,a0
    80005c18:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    80005c1c:	cd11                	beqz	a0,80005c38 <sys_exec+0xa8>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005c1e:	6605                	lui	a2,0x1
    80005c20:	e3043503          	ld	a0,-464(s0)
    80005c24:	ffffd097          	auipc	ra,0xffffd
    80005c28:	e14080e7          	jalr	-492(ra) # 80002a38 <fetchstr>
    80005c2c:	00054663          	bltz	a0,80005c38 <sys_exec+0xa8>
        if (i >= NELEM(argv))
    80005c30:	0905                	addi	s2,s2,1
    80005c32:	09a1                	addi	s3,s3,8
    80005c34:	fb491be3          	bne	s2,s4,80005bea <sys_exec+0x5a>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c38:	10048913          	addi	s2,s1,256
    80005c3c:	6088                	ld	a0,0(s1)
    80005c3e:	c529                	beqz	a0,80005c88 <sys_exec+0xf8>
        kfree(argv[i]);
    80005c40:	ffffb097          	auipc	ra,0xffffb
    80005c44:	dd2080e7          	jalr	-558(ra) # 80000a12 <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c48:	04a1                	addi	s1,s1,8
    80005c4a:	ff2499e3          	bne	s1,s2,80005c3c <sys_exec+0xac>
    return -1;
    80005c4e:	597d                	li	s2,-1
    80005c50:	a82d                	j	80005c8a <sys_exec+0xfa>
            argv[i] = 0;
    80005c52:	0a8e                	slli	s5,s5,0x3
    80005c54:	fc040793          	addi	a5,s0,-64
    80005c58:	9abe                	add	s5,s5,a5
    80005c5a:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
    int ret = exec(path, argv);
    80005c5e:	e4040593          	addi	a1,s0,-448
    80005c62:	f4040513          	addi	a0,s0,-192
    80005c66:	fffff097          	auipc	ra,0xfffff
    80005c6a:	178080e7          	jalr	376(ra) # 80004dde <exec>
    80005c6e:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c70:	10048993          	addi	s3,s1,256
    80005c74:	6088                	ld	a0,0(s1)
    80005c76:	c911                	beqz	a0,80005c8a <sys_exec+0xfa>
        kfree(argv[i]);
    80005c78:	ffffb097          	auipc	ra,0xffffb
    80005c7c:	d9a080e7          	jalr	-614(ra) # 80000a12 <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c80:	04a1                	addi	s1,s1,8
    80005c82:	ff3499e3          	bne	s1,s3,80005c74 <sys_exec+0xe4>
    80005c86:	a011                	j	80005c8a <sys_exec+0xfa>
    return -1;
    80005c88:	597d                	li	s2,-1
}
    80005c8a:	854a                	mv	a0,s2
    80005c8c:	60be                	ld	ra,456(sp)
    80005c8e:	641e                	ld	s0,448(sp)
    80005c90:	74fa                	ld	s1,440(sp)
    80005c92:	795a                	ld	s2,432(sp)
    80005c94:	79ba                	ld	s3,424(sp)
    80005c96:	7a1a                	ld	s4,416(sp)
    80005c98:	6afa                	ld	s5,408(sp)
    80005c9a:	6179                	addi	sp,sp,464
    80005c9c:	8082                	ret

0000000080005c9e <sys_pipe>:

uint64 sys_pipe(void)
{
    80005c9e:	7139                	addi	sp,sp,-64
    80005ca0:	fc06                	sd	ra,56(sp)
    80005ca2:	f822                	sd	s0,48(sp)
    80005ca4:	f426                	sd	s1,40(sp)
    80005ca6:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80005ca8:	ffffc097          	auipc	ra,0xffffc
    80005cac:	d22080e7          	jalr	-734(ra) # 800019ca <myproc>
    80005cb0:	84aa                	mv	s1,a0

    if (argaddr(0, &fdarray) < 0)
    80005cb2:	fd840593          	addi	a1,s0,-40
    80005cb6:	4501                	li	a0,0
    80005cb8:	ffffd097          	auipc	ra,0xffffd
    80005cbc:	dea080e7          	jalr	-534(ra) # 80002aa2 <argaddr>
        return -1;
    80005cc0:	57fd                	li	a5,-1
    if (argaddr(0, &fdarray) < 0)
    80005cc2:	0e054063          	bltz	a0,80005da2 <sys_pipe+0x104>
    if (pipealloc(&rf, &wf) < 0)
    80005cc6:	fc840593          	addi	a1,s0,-56
    80005cca:	fd040513          	addi	a0,s0,-48
    80005cce:	fffff097          	auipc	ra,0xfffff
    80005cd2:	de0080e7          	jalr	-544(ra) # 80004aae <pipealloc>
        return -1;
    80005cd6:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    80005cd8:	0c054563          	bltz	a0,80005da2 <sys_pipe+0x104>
    fd0 = -1;
    80005cdc:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005ce0:	fd043503          	ld	a0,-48(s0)
    80005ce4:	fffff097          	auipc	ra,0xfffff
    80005ce8:	50a080e7          	jalr	1290(ra) # 800051ee <fdalloc>
    80005cec:	fca42223          	sw	a0,-60(s0)
    80005cf0:	08054c63          	bltz	a0,80005d88 <sys_pipe+0xea>
    80005cf4:	fc843503          	ld	a0,-56(s0)
    80005cf8:	fffff097          	auipc	ra,0xfffff
    80005cfc:	4f6080e7          	jalr	1270(ra) # 800051ee <fdalloc>
    80005d00:	fca42023          	sw	a0,-64(s0)
    80005d04:	06054863          	bltz	a0,80005d74 <sys_pipe+0xd6>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005d08:	4691                	li	a3,4
    80005d0a:	fc440613          	addi	a2,s0,-60
    80005d0e:	fd843583          	ld	a1,-40(s0)
    80005d12:	68a8                	ld	a0,80(s1)
    80005d14:	ffffc097          	auipc	ra,0xffffc
    80005d18:	9a8080e7          	jalr	-1624(ra) # 800016bc <copyout>
    80005d1c:	02054063          	bltz	a0,80005d3c <sys_pipe+0x9e>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1,
    80005d20:	4691                	li	a3,4
    80005d22:	fc040613          	addi	a2,s0,-64
    80005d26:	fd843583          	ld	a1,-40(s0)
    80005d2a:	0591                	addi	a1,a1,4
    80005d2c:	68a8                	ld	a0,80(s1)
    80005d2e:	ffffc097          	auipc	ra,0xffffc
    80005d32:	98e080e7          	jalr	-1650(ra) # 800016bc <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005d36:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005d38:	06055563          	bgez	a0,80005da2 <sys_pipe+0x104>
        p->ofile[fd0] = 0;
    80005d3c:	fc442783          	lw	a5,-60(s0)
    80005d40:	07e9                	addi	a5,a5,26
    80005d42:	078e                	slli	a5,a5,0x3
    80005d44:	97a6                	add	a5,a5,s1
    80005d46:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005d4a:	fc042503          	lw	a0,-64(s0)
    80005d4e:	0569                	addi	a0,a0,26
    80005d50:	050e                	slli	a0,a0,0x3
    80005d52:	9526                	add	a0,a0,s1
    80005d54:	00053023          	sd	zero,0(a0)
        fileclose(rf);
    80005d58:	fd043503          	ld	a0,-48(s0)
    80005d5c:	fffff097          	auipc	ra,0xfffff
    80005d60:	9fa080e7          	jalr	-1542(ra) # 80004756 <fileclose>
        fileclose(wf);
    80005d64:	fc843503          	ld	a0,-56(s0)
    80005d68:	fffff097          	auipc	ra,0xfffff
    80005d6c:	9ee080e7          	jalr	-1554(ra) # 80004756 <fileclose>
        return -1;
    80005d70:	57fd                	li	a5,-1
    80005d72:	a805                	j	80005da2 <sys_pipe+0x104>
        if (fd0 >= 0)
    80005d74:	fc442783          	lw	a5,-60(s0)
    80005d78:	0007c863          	bltz	a5,80005d88 <sys_pipe+0xea>
            p->ofile[fd0] = 0;
    80005d7c:	01a78513          	addi	a0,a5,26
    80005d80:	050e                	slli	a0,a0,0x3
    80005d82:	9526                	add	a0,a0,s1
    80005d84:	00053023          	sd	zero,0(a0)
        fileclose(rf);
    80005d88:	fd043503          	ld	a0,-48(s0)
    80005d8c:	fffff097          	auipc	ra,0xfffff
    80005d90:	9ca080e7          	jalr	-1590(ra) # 80004756 <fileclose>
        fileclose(wf);
    80005d94:	fc843503          	ld	a0,-56(s0)
    80005d98:	fffff097          	auipc	ra,0xfffff
    80005d9c:	9be080e7          	jalr	-1602(ra) # 80004756 <fileclose>
        return -1;
    80005da0:	57fd                	li	a5,-1
}
    80005da2:	853e                	mv	a0,a5
    80005da4:	70e2                	ld	ra,56(sp)
    80005da6:	7442                	ld	s0,48(sp)
    80005da8:	74a2                	ld	s1,40(sp)
    80005daa:	6121                	addi	sp,sp,64
    80005dac:	8082                	ret

0000000080005dae <sys_chmod>:
/* TODO: Access Control & Symbolic Link */
extern int chperm(char *path, int mode, int is_add, int recursive);

uint64
sys_chmod(void)
{
    80005dae:	7135                	addi	sp,sp,-160
    80005db0:	ed06                	sd	ra,152(sp)
    80005db2:	e922                	sd	s0,144(sp)
    80005db4:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    int mode;
    int is_add;
    int recursive;

    if (argstr(0, path, MAXPATH) < 0)
    80005db6:	08000613          	li	a2,128
    80005dba:	f7040593          	addi	a1,s0,-144
    80005dbe:	4501                	li	a0,0
    80005dc0:	ffffd097          	auipc	ra,0xffffd
    80005dc4:	d04080e7          	jalr	-764(ra) # 80002ac4 <argstr>
        return -1;
    80005dc8:	57fd                	li	a5,-1
    if (argstr(0, path, MAXPATH) < 0)
    80005dca:	04054d63          	bltz	a0,80005e24 <sys_chmod+0x76>
    if (argint(1, &mode) < 0)
    80005dce:	f6c40593          	addi	a1,s0,-148
    80005dd2:	4505                	li	a0,1
    80005dd4:	ffffd097          	auipc	ra,0xffffd
    80005dd8:	cac080e7          	jalr	-852(ra) # 80002a80 <argint>
        return -1;
    80005ddc:	57fd                	li	a5,-1
    if (argint(1, &mode) < 0)
    80005dde:	04054363          	bltz	a0,80005e24 <sys_chmod+0x76>
    if (argint(2, &is_add) < 0)
    80005de2:	f6840593          	addi	a1,s0,-152
    80005de6:	4509                	li	a0,2
    80005de8:	ffffd097          	auipc	ra,0xffffd
    80005dec:	c98080e7          	jalr	-872(ra) # 80002a80 <argint>
        return -1;
    80005df0:	57fd                	li	a5,-1
    if (argint(2, &is_add) < 0)
    80005df2:	02054963          	bltz	a0,80005e24 <sys_chmod+0x76>
    if (argint(3, &recursive) < 0)
    80005df6:	f6440593          	addi	a1,s0,-156
    80005dfa:	450d                	li	a0,3
    80005dfc:	ffffd097          	auipc	ra,0xffffd
    80005e00:	c84080e7          	jalr	-892(ra) # 80002a80 <argint>
        return -1;
    80005e04:	57fd                	li	a5,-1
    if (argint(3, &recursive) < 0)
    80005e06:	00054f63          	bltz	a0,80005e24 <sys_chmod+0x76>

    return chperm(path, mode, is_add, recursive);
    80005e0a:	f6442683          	lw	a3,-156(s0)
    80005e0e:	f6842603          	lw	a2,-152(s0)
    80005e12:	f6c42583          	lw	a1,-148(s0)
    80005e16:	f7040513          	addi	a0,s0,-144
    80005e1a:	ffffe097          	auipc	ra,0xffffe
    80005e1e:	0c4080e7          	jalr	196(ra) # 80003ede <chperm>
    80005e22:	87aa                	mv	a5,a0
}
    80005e24:	853e                	mv	a0,a5
    80005e26:	60ea                	ld	ra,152(sp)
    80005e28:	644a                	ld	s0,144(sp)
    80005e2a:	610d                	addi	sp,sp,160
    80005e2c:	8082                	ret

0000000080005e2e <sys_symlink>:


/* TODO: Access Control & Symbolic Link */
// Loretta
uint64 sys_symlink(void)
{
    80005e2e:	712d                	addi	sp,sp,-288
    80005e30:	ee06                	sd	ra,280(sp)
    80005e32:	ea22                	sd	s0,272(sp)
    80005e34:	e626                	sd	s1,264(sp)
    80005e36:	e24a                	sd	s2,256(sp)
    80005e38:	1200                	addi	s0,sp,288
    /* just for your reference, change it if you want to */

    char target[MAXPATH], path[MAXPATH];

    if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005e3a:	08000613          	li	a2,128
    80005e3e:	f6040593          	addi	a1,s0,-160
    80005e42:	4501                	li	a0,0
    80005e44:	ffffd097          	auipc	ra,0xffffd
    80005e48:	c80080e7          	jalr	-896(ra) # 80002ac4 <argstr>
        return -1;
    80005e4c:	57fd                	li	a5,-1
    if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005e4e:	08054163          	bltz	a0,80005ed0 <sys_symlink+0xa2>
    80005e52:	08000613          	li	a2,128
    80005e56:	ee040593          	addi	a1,s0,-288
    80005e5a:	4505                	li	a0,1
    80005e5c:	ffffd097          	auipc	ra,0xffffd
    80005e60:	c68080e7          	jalr	-920(ra) # 80002ac4 <argstr>
        return -1;
    80005e64:	57fd                	li	a5,-1
    if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005e66:	06054563          	bltz	a0,80005ed0 <sys_symlink+0xa2>

    struct inode *ip;
    begin_op();
    80005e6a:	ffffe097          	auipc	ra,0xffffe
    80005e6e:	41a080e7          	jalr	1050(ra) # 80004284 <begin_op>

    ip = create(path, T_SYMLINK, 0, 0);
    80005e72:	4681                	li	a3,0
    80005e74:	4601                	li	a2,0
    80005e76:	4591                	li	a1,4
    80005e78:	ee040513          	addi	a0,s0,-288
    80005e7c:	fffff097          	auipc	ra,0xfffff
    80005e80:	3b4080e7          	jalr	948(ra) # 80005230 <create>
    80005e84:	84aa                	mv	s1,a0
    if (ip == 0)
    80005e86:	cd21                	beqz	a0,80005ede <sys_symlink+0xb0>
    {
        end_op();
        return -1;
    }

    if(writei(ip, 0, (uint64)target, 0, strlen(target)) != strlen(target))
    80005e88:	f6040513          	addi	a0,s0,-160
    80005e8c:	ffffb097          	auipc	ra,0xffffb
    80005e90:	ff2080e7          	jalr	-14(ra) # 80000e7e <strlen>
    80005e94:	0005071b          	sext.w	a4,a0
    80005e98:	4681                	li	a3,0
    80005e9a:	f6040613          	addi	a2,s0,-160
    80005e9e:	4581                	li	a1,0
    80005ea0:	8526                	mv	a0,s1
    80005ea2:	ffffe097          	auipc	ra,0xffffe
    80005ea6:	c1a080e7          	jalr	-998(ra) # 80003abc <writei>
    80005eaa:	892a                	mv	s2,a0
    80005eac:	f6040513          	addi	a0,s0,-160
    80005eb0:	ffffb097          	auipc	ra,0xffffb
    80005eb4:	fce080e7          	jalr	-50(ra) # 80000e7e <strlen>
    80005eb8:	02a91963          	bne	s2,a0,80005eea <sys_symlink+0xbc>
        iunlockput(ip);
        end_op();
        return -1;
    }

    iunlockput(ip);
    80005ebc:	8526                	mv	a0,s1
    80005ebe:	ffffe097          	auipc	ra,0xffffe
    80005ec2:	aae080e7          	jalr	-1362(ra) # 8000396c <iunlockput>
    end_op();
    80005ec6:	ffffe097          	auipc	ra,0xffffe
    80005eca:	43e080e7          	jalr	1086(ra) # 80004304 <end_op>

    return 0;
    80005ece:	4781                	li	a5,0
}
    80005ed0:	853e                	mv	a0,a5
    80005ed2:	60f2                	ld	ra,280(sp)
    80005ed4:	6452                	ld	s0,272(sp)
    80005ed6:	64b2                	ld	s1,264(sp)
    80005ed8:	6912                	ld	s2,256(sp)
    80005eda:	6115                	addi	sp,sp,288
    80005edc:	8082                	ret
        end_op();
    80005ede:	ffffe097          	auipc	ra,0xffffe
    80005ee2:	426080e7          	jalr	1062(ra) # 80004304 <end_op>
        return -1;
    80005ee6:	57fd                	li	a5,-1
    80005ee8:	b7e5                	j	80005ed0 <sys_symlink+0xa2>
        iunlockput(ip);
    80005eea:	8526                	mv	a0,s1
    80005eec:	ffffe097          	auipc	ra,0xffffe
    80005ef0:	a80080e7          	jalr	-1408(ra) # 8000396c <iunlockput>
        end_op();
    80005ef4:	ffffe097          	auipc	ra,0xffffe
    80005ef8:	410080e7          	jalr	1040(ra) # 80004304 <end_op>
        return -1;
    80005efc:	57fd                	li	a5,-1
    80005efe:	bfc9                	j	80005ed0 <sys_symlink+0xa2>

0000000080005f00 <sys_raw_read>:

uint64 sys_raw_read(void)
{
    80005f00:	7179                	addi	sp,sp,-48
    80005f02:	f406                	sd	ra,40(sp)
    80005f04:	f022                	sd	s0,32(sp)
    80005f06:	ec26                	sd	s1,24(sp)
    80005f08:	1800                	addi	s0,sp,48
    int pbn;
    uint64 user_buf_addr;
    struct buf *b;

    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    80005f0a:	fdc40593          	addi	a1,s0,-36
    80005f0e:	4501                	li	a0,0
    80005f10:	ffffd097          	auipc	ra,0xffffd
    80005f14:	b70080e7          	jalr	-1168(ra) # 80002a80 <argint>
    {
        return -1;
    80005f18:	57fd                	li	a5,-1
    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    80005f1a:	06054463          	bltz	a0,80005f82 <sys_raw_read+0x82>
    80005f1e:	fd040593          	addi	a1,s0,-48
    80005f22:	4505                	li	a0,1
    80005f24:	ffffd097          	auipc	ra,0xffffd
    80005f28:	b7e080e7          	jalr	-1154(ra) # 80002aa2 <argaddr>
    80005f2c:	06054863          	bltz	a0,80005f9c <sys_raw_read+0x9c>
    }

    if (pbn < 0 || pbn >= FSSIZE)
    80005f30:	fdc42583          	lw	a1,-36(s0)
    80005f34:	6705                	lui	a4,0x1
    {
        return -1;
    80005f36:	57fd                	li	a5,-1
    if (pbn < 0 || pbn >= FSSIZE)
    80005f38:	04e5f563          	bgeu	a1,a4,80005f82 <sys_raw_read+0x82>
    }

    b = bget(ROOTDEV, pbn);
    80005f3c:	4505                	li	a0,1
    80005f3e:	ffffd097          	auipc	ra,0xffffd
    80005f42:	f48080e7          	jalr	-184(ra) # 80002e86 <bget>
    80005f46:	84aa                	mv	s1,a0
    if (b == 0)
    80005f48:	cd21                	beqz	a0,80005fa0 <sys_raw_read+0xa0>
    {
        return -1;
    }

    virtio_disk_rw(b, 0);
    80005f4a:	4581                	li	a1,0
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	4c0080e7          	jalr	1216(ra) # 8000640c <virtio_disk_rw>

    struct proc *p = myproc();
    80005f54:	ffffc097          	auipc	ra,0xffffc
    80005f58:	a76080e7          	jalr	-1418(ra) # 800019ca <myproc>
    if (copyout(p->pagetable, user_buf_addr, (char *)b->data, BSIZE) < 0)
    80005f5c:	40000693          	li	a3,1024
    80005f60:	05848613          	addi	a2,s1,88
    80005f64:	fd043583          	ld	a1,-48(s0)
    80005f68:	6928                	ld	a0,80(a0)
    80005f6a:	ffffb097          	auipc	ra,0xffffb
    80005f6e:	752080e7          	jalr	1874(ra) # 800016bc <copyout>
    80005f72:	00054e63          	bltz	a0,80005f8e <sys_raw_read+0x8e>
    {
        brelse(b);
        return -1;
    }

    brelse(b);
    80005f76:	8526                	mv	a0,s1
    80005f78:	ffffd097          	auipc	ra,0xffffd
    80005f7c:	086080e7          	jalr	134(ra) # 80002ffe <brelse>
    return 0;
    80005f80:	4781                	li	a5,0
}
    80005f82:	853e                	mv	a0,a5
    80005f84:	70a2                	ld	ra,40(sp)
    80005f86:	7402                	ld	s0,32(sp)
    80005f88:	64e2                	ld	s1,24(sp)
    80005f8a:	6145                	addi	sp,sp,48
    80005f8c:	8082                	ret
        brelse(b);
    80005f8e:	8526                	mv	a0,s1
    80005f90:	ffffd097          	auipc	ra,0xffffd
    80005f94:	06e080e7          	jalr	110(ra) # 80002ffe <brelse>
        return -1;
    80005f98:	57fd                	li	a5,-1
    80005f9a:	b7e5                	j	80005f82 <sys_raw_read+0x82>
        return -1;
    80005f9c:	57fd                	li	a5,-1
    80005f9e:	b7d5                	j	80005f82 <sys_raw_read+0x82>
        return -1;
    80005fa0:	57fd                	li	a5,-1
    80005fa2:	b7c5                	j	80005f82 <sys_raw_read+0x82>

0000000080005fa4 <sys_get_disk_lbn>:

uint64 sys_get_disk_lbn(void)
{
    80005fa4:	7179                	addi	sp,sp,-48
    80005fa6:	f406                	sd	ra,40(sp)
    80005fa8:	f022                	sd	s0,32(sp)
    80005faa:	ec26                	sd	s1,24(sp)
    80005fac:	e84a                	sd	s2,16(sp)
    80005fae:	1800                	addi	s0,sp,48
    struct file *f;
    int fd;
    int file_lbn;
    uint disk_lbn;

    if (argfd(0, &fd, &f) < 0 || argint(1, &file_lbn) < 0)
    80005fb0:	fd840613          	addi	a2,s0,-40
    80005fb4:	fd440593          	addi	a1,s0,-44
    80005fb8:	4501                	li	a0,0
    80005fba:	fffff097          	auipc	ra,0xfffff
    80005fbe:	1cc080e7          	jalr	460(ra) # 80005186 <argfd>
    80005fc2:	87aa                	mv	a5,a0
    {
        return -1;
    80005fc4:	557d                	li	a0,-1
    if (argfd(0, &fd, &f) < 0 || argint(1, &file_lbn) < 0)
    80005fc6:	0407c963          	bltz	a5,80006018 <sys_get_disk_lbn+0x74>
    80005fca:	fd040593          	addi	a1,s0,-48
    80005fce:	4505                	li	a0,1
    80005fd0:	ffffd097          	auipc	ra,0xffffd
    80005fd4:	ab0080e7          	jalr	-1360(ra) # 80002a80 <argint>
    80005fd8:	04054663          	bltz	a0,80006024 <sys_get_disk_lbn+0x80>
    }

    if (!f->readable)
    80005fdc:	fd843783          	ld	a5,-40(s0)
    80005fe0:	0087c703          	lbu	a4,8(a5)
    {
        return -1;
    80005fe4:	557d                	li	a0,-1
    if (!f->readable)
    80005fe6:	cb0d                	beqz	a4,80006018 <sys_get_disk_lbn+0x74>
    }

    struct inode *ip = f->ip;
    80005fe8:	0187b903          	ld	s2,24(a5)

    ilock(ip);
    80005fec:	854a                	mv	a0,s2
    80005fee:	ffffd097          	auipc	ra,0xffffd
    80005ff2:	606080e7          	jalr	1542(ra) # 800035f4 <ilock>

    disk_lbn = bmap(ip, file_lbn);
    80005ff6:	fd042583          	lw	a1,-48(s0)
    80005ffa:	854a                	mv	a0,s2
    80005ffc:	ffffd097          	auipc	ra,0xffffd
    80006000:	6fe080e7          	jalr	1790(ra) # 800036fa <bmap>
    80006004:	0005049b          	sext.w	s1,a0

    iunlock(ip);
    80006008:	854a                	mv	a0,s2
    8000600a:	ffffd097          	auipc	ra,0xffffd
    8000600e:	6a4080e7          	jalr	1700(ra) # 800036ae <iunlock>

    return (uint64)disk_lbn;
    80006012:	02049513          	slli	a0,s1,0x20
    80006016:	9101                	srli	a0,a0,0x20
}
    80006018:	70a2                	ld	ra,40(sp)
    8000601a:	7402                	ld	s0,32(sp)
    8000601c:	64e2                	ld	s1,24(sp)
    8000601e:	6942                	ld	s2,16(sp)
    80006020:	6145                	addi	sp,sp,48
    80006022:	8082                	ret
        return -1;
    80006024:	557d                	li	a0,-1
    80006026:	bfcd                	j	80006018 <sys_get_disk_lbn+0x74>

0000000080006028 <sys_raw_write>:

uint64 sys_raw_write(void)
{
    80006028:	7179                	addi	sp,sp,-48
    8000602a:	f406                	sd	ra,40(sp)
    8000602c:	f022                	sd	s0,32(sp)
    8000602e:	ec26                	sd	s1,24(sp)
    80006030:	1800                	addi	s0,sp,48
    int pbn;
    uint64 user_buf_addr;
    struct buf *b;

    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    80006032:	fdc40593          	addi	a1,s0,-36
    80006036:	4501                	li	a0,0
    80006038:	ffffd097          	auipc	ra,0xffffd
    8000603c:	a48080e7          	jalr	-1464(ra) # 80002a80 <argint>
    {
        return -1;
    80006040:	57fd                	li	a5,-1
    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    80006042:	06054763          	bltz	a0,800060b0 <sys_raw_write+0x88>
    80006046:	fd040593          	addi	a1,s0,-48
    8000604a:	4505                	li	a0,1
    8000604c:	ffffd097          	auipc	ra,0xffffd
    80006050:	a56080e7          	jalr	-1450(ra) # 80002aa2 <argaddr>
    80006054:	08054763          	bltz	a0,800060e2 <sys_raw_write+0xba>
    }

    if (pbn < 0 || pbn >= FSSIZE)
    80006058:	fdc42583          	lw	a1,-36(s0)
    8000605c:	6705                	lui	a4,0x1
    {
        return -1;
    8000605e:	57fd                	li	a5,-1
    if (pbn < 0 || pbn >= FSSIZE)
    80006060:	04e5f863          	bgeu	a1,a4,800060b0 <sys_raw_write+0x88>
    }

    b = bget(ROOTDEV, pbn);
    80006064:	4505                	li	a0,1
    80006066:	ffffd097          	auipc	ra,0xffffd
    8000606a:	e20080e7          	jalr	-480(ra) # 80002e86 <bget>
    8000606e:	84aa                	mv	s1,a0
    if (b == 0)
    80006070:	c531                	beqz	a0,800060bc <sys_raw_write+0x94>
    {
        printf("sys_raw_write: bget failed for PBN %d\n", pbn);
        return -1;
    }
    struct proc *p = myproc();
    80006072:	ffffc097          	auipc	ra,0xffffc
    80006076:	958080e7          	jalr	-1704(ra) # 800019ca <myproc>
    if (copyin(p->pagetable, (char *)b->data, user_buf_addr, BSIZE) < 0)
    8000607a:	40000693          	li	a3,1024
    8000607e:	fd043603          	ld	a2,-48(s0)
    80006082:	05848593          	addi	a1,s1,88
    80006086:	6928                	ld	a0,80(a0)
    80006088:	ffffb097          	auipc	ra,0xffffb
    8000608c:	6c0080e7          	jalr	1728(ra) # 80001748 <copyin>
    80006090:	04054263          	bltz	a0,800060d4 <sys_raw_write+0xac>
    {
        brelse(b);
        return -1;
    }

    b->valid = 1;
    80006094:	4785                	li	a5,1
    80006096:	c09c                	sw	a5,0(s1)
    virtio_disk_rw(b, 1);
    80006098:	4585                	li	a1,1
    8000609a:	8526                	mv	a0,s1
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	370080e7          	jalr	880(ra) # 8000640c <virtio_disk_rw>
    brelse(b);
    800060a4:	8526                	mv	a0,s1
    800060a6:	ffffd097          	auipc	ra,0xffffd
    800060aa:	f58080e7          	jalr	-168(ra) # 80002ffe <brelse>

    return 0;
    800060ae:	4781                	li	a5,0
}
    800060b0:	853e                	mv	a0,a5
    800060b2:	70a2                	ld	ra,40(sp)
    800060b4:	7402                	ld	s0,32(sp)
    800060b6:	64e2                	ld	s1,24(sp)
    800060b8:	6145                	addi	sp,sp,48
    800060ba:	8082                	ret
        printf("sys_raw_write: bget failed for PBN %d\n", pbn);
    800060bc:	fdc42583          	lw	a1,-36(s0)
    800060c0:	00002517          	auipc	a0,0x2
    800060c4:	78050513          	addi	a0,a0,1920 # 80008840 <syscalls+0x418>
    800060c8:	ffffa097          	auipc	ra,0xffffa
    800060cc:	4c4080e7          	jalr	1220(ra) # 8000058c <printf>
        return -1;
    800060d0:	57fd                	li	a5,-1
    800060d2:	bff9                	j	800060b0 <sys_raw_write+0x88>
        brelse(b);
    800060d4:	8526                	mv	a0,s1
    800060d6:	ffffd097          	auipc	ra,0xffffd
    800060da:	f28080e7          	jalr	-216(ra) # 80002ffe <brelse>
        return -1;
    800060de:	57fd                	li	a5,-1
    800060e0:	bfc1                	j	800060b0 <sys_raw_write+0x88>
        return -1;
    800060e2:	57fd                	li	a5,-1
    800060e4:	b7f1                	j	800060b0 <sys_raw_write+0x88>
	...

00000000800060f0 <kernelvec>:
    800060f0:	7111                	addi	sp,sp,-256
    800060f2:	e006                	sd	ra,0(sp)
    800060f4:	e40a                	sd	sp,8(sp)
    800060f6:	e80e                	sd	gp,16(sp)
    800060f8:	ec12                	sd	tp,24(sp)
    800060fa:	f016                	sd	t0,32(sp)
    800060fc:	f41a                	sd	t1,40(sp)
    800060fe:	f81e                	sd	t2,48(sp)
    80006100:	fc22                	sd	s0,56(sp)
    80006102:	e0a6                	sd	s1,64(sp)
    80006104:	e4aa                	sd	a0,72(sp)
    80006106:	e8ae                	sd	a1,80(sp)
    80006108:	ecb2                	sd	a2,88(sp)
    8000610a:	f0b6                	sd	a3,96(sp)
    8000610c:	f4ba                	sd	a4,104(sp)
    8000610e:	f8be                	sd	a5,112(sp)
    80006110:	fcc2                	sd	a6,120(sp)
    80006112:	e146                	sd	a7,128(sp)
    80006114:	e54a                	sd	s2,136(sp)
    80006116:	e94e                	sd	s3,144(sp)
    80006118:	ed52                	sd	s4,152(sp)
    8000611a:	f156                	sd	s5,160(sp)
    8000611c:	f55a                	sd	s6,168(sp)
    8000611e:	f95e                	sd	s7,176(sp)
    80006120:	fd62                	sd	s8,184(sp)
    80006122:	e1e6                	sd	s9,192(sp)
    80006124:	e5ea                	sd	s10,200(sp)
    80006126:	e9ee                	sd	s11,208(sp)
    80006128:	edf2                	sd	t3,216(sp)
    8000612a:	f1f6                	sd	t4,224(sp)
    8000612c:	f5fa                	sd	t5,232(sp)
    8000612e:	f9fe                	sd	t6,240(sp)
    80006130:	f82fc0ef          	jal	ra,800028b2 <kerneltrap>
    80006134:	6082                	ld	ra,0(sp)
    80006136:	6122                	ld	sp,8(sp)
    80006138:	61c2                	ld	gp,16(sp)
    8000613a:	7282                	ld	t0,32(sp)
    8000613c:	7322                	ld	t1,40(sp)
    8000613e:	73c2                	ld	t2,48(sp)
    80006140:	7462                	ld	s0,56(sp)
    80006142:	6486                	ld	s1,64(sp)
    80006144:	6526                	ld	a0,72(sp)
    80006146:	65c6                	ld	a1,80(sp)
    80006148:	6666                	ld	a2,88(sp)
    8000614a:	7686                	ld	a3,96(sp)
    8000614c:	7726                	ld	a4,104(sp)
    8000614e:	77c6                	ld	a5,112(sp)
    80006150:	7866                	ld	a6,120(sp)
    80006152:	688a                	ld	a7,128(sp)
    80006154:	692a                	ld	s2,136(sp)
    80006156:	69ca                	ld	s3,144(sp)
    80006158:	6a6a                	ld	s4,152(sp)
    8000615a:	7a8a                	ld	s5,160(sp)
    8000615c:	7b2a                	ld	s6,168(sp)
    8000615e:	7bca                	ld	s7,176(sp)
    80006160:	7c6a                	ld	s8,184(sp)
    80006162:	6c8e                	ld	s9,192(sp)
    80006164:	6d2e                	ld	s10,200(sp)
    80006166:	6dce                	ld	s11,208(sp)
    80006168:	6e6e                	ld	t3,216(sp)
    8000616a:	7e8e                	ld	t4,224(sp)
    8000616c:	7f2e                	ld	t5,232(sp)
    8000616e:	7fce                	ld	t6,240(sp)
    80006170:	6111                	addi	sp,sp,256
    80006172:	10200073          	sret
    80006176:	00000013          	nop
    8000617a:	00000013          	nop
    8000617e:	0001                	nop

0000000080006180 <timervec>:
    80006180:	34051573          	csrrw	a0,mscratch,a0
    80006184:	e10c                	sd	a1,0(a0)
    80006186:	e510                	sd	a2,8(a0)
    80006188:	e914                	sd	a3,16(a0)
    8000618a:	710c                	ld	a1,32(a0)
    8000618c:	7510                	ld	a2,40(a0)
    8000618e:	6194                	ld	a3,0(a1)
    80006190:	96b2                	add	a3,a3,a2
    80006192:	e194                	sd	a3,0(a1)
    80006194:	4589                	li	a1,2
    80006196:	14459073          	csrw	sip,a1
    8000619a:	6914                	ld	a3,16(a0)
    8000619c:	6510                	ld	a2,8(a0)
    8000619e:	610c                	ld	a1,0(a0)
    800061a0:	34051573          	csrrw	a0,mscratch,a0
    800061a4:	30200073          	mret
	...

00000000800061aa <plicinit>:
//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void)
{
    800061aa:	1141                	addi	sp,sp,-16
    800061ac:	e422                	sd	s0,8(sp)
    800061ae:	0800                	addi	s0,sp,16
    // set desired IRQ priorities non-zero (otherwise disabled).
    *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    800061b0:	0c0007b7          	lui	a5,0xc000
    800061b4:	4705                	li	a4,1
    800061b6:	d798                	sw	a4,40(a5)
    *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800061b8:	c3d8                	sw	a4,4(a5)
}
    800061ba:	6422                	ld	s0,8(sp)
    800061bc:	0141                	addi	sp,sp,16
    800061be:	8082                	ret

00000000800061c0 <plicinithart>:

void plicinithart(void)
{
    800061c0:	1141                	addi	sp,sp,-16
    800061c2:	e406                	sd	ra,8(sp)
    800061c4:	e022                	sd	s0,0(sp)
    800061c6:	0800                	addi	s0,sp,16
    int hart = cpuid();
    800061c8:	ffffb097          	auipc	ra,0xffffb
    800061cc:	7d6080e7          	jalr	2006(ra) # 8000199e <cpuid>

    // set uart's enable bit for this hart's S-mode.
    *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800061d0:	0085171b          	slliw	a4,a0,0x8
    800061d4:	0c0027b7          	lui	a5,0xc002
    800061d8:	97ba                	add	a5,a5,a4
    800061da:	40200713          	li	a4,1026
    800061de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

    // set this hart's S-mode priority threshold to 0.
    *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    800061e2:	00d5151b          	slliw	a0,a0,0xd
    800061e6:	0c2017b7          	lui	a5,0xc201
    800061ea:	953e                	add	a0,a0,a5
    800061ec:	00052023          	sw	zero,0(a0)
}
    800061f0:	60a2                	ld	ra,8(sp)
    800061f2:	6402                	ld	s0,0(sp)
    800061f4:	0141                	addi	sp,sp,16
    800061f6:	8082                	ret

00000000800061f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void)
{
    800061f8:	1141                	addi	sp,sp,-16
    800061fa:	e406                	sd	ra,8(sp)
    800061fc:	e022                	sd	s0,0(sp)
    800061fe:	0800                	addi	s0,sp,16
    int hart = cpuid();
    80006200:	ffffb097          	auipc	ra,0xffffb
    80006204:	79e080e7          	jalr	1950(ra) # 8000199e <cpuid>
    int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80006208:	00d5179b          	slliw	a5,a0,0xd
    8000620c:	0c201537          	lui	a0,0xc201
    80006210:	953e                	add	a0,a0,a5
    return irq;
}
    80006212:	4148                	lw	a0,4(a0)
    80006214:	60a2                	ld	ra,8(sp)
    80006216:	6402                	ld	s0,0(sp)
    80006218:	0141                	addi	sp,sp,16
    8000621a:	8082                	ret

000000008000621c <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq)
{
    8000621c:	1101                	addi	sp,sp,-32
    8000621e:	ec06                	sd	ra,24(sp)
    80006220:	e822                	sd	s0,16(sp)
    80006222:	e426                	sd	s1,8(sp)
    80006224:	1000                	addi	s0,sp,32
    80006226:	84aa                	mv	s1,a0
    int hart = cpuid();
    80006228:	ffffb097          	auipc	ra,0xffffb
    8000622c:	776080e7          	jalr	1910(ra) # 8000199e <cpuid>
    *(uint32 *)PLIC_SCLAIM(hart) = irq;
    80006230:	00d5151b          	slliw	a0,a0,0xd
    80006234:	0c2017b7          	lui	a5,0xc201
    80006238:	97aa                	add	a5,a5,a0
    8000623a:	c3c4                	sw	s1,4(a5)
}
    8000623c:	60e2                	ld	ra,24(sp)
    8000623e:	6442                	ld	s0,16(sp)
    80006240:	64a2                	ld	s1,8(sp)
    80006242:	6105                	addi	sp,sp,32
    80006244:	8082                	ret

0000000080006246 <free_desc>:
    return -1;
}

// mark a descriptor as free.
static void free_desc(int i)
{
    80006246:	1141                	addi	sp,sp,-16
    80006248:	e406                	sd	ra,8(sp)
    8000624a:	e022                	sd	s0,0(sp)
    8000624c:	0800                	addi	s0,sp,16
    if (i >= NUM)
    8000624e:	479d                	li	a5,7
    80006250:	04a7cc63          	blt	a5,a0,800062a8 <free_desc+0x62>
        panic("virtio_disk_intr 1");
    if (disk.free[i])
    80006254:	0001d797          	auipc	a5,0x1d
    80006258:	dac78793          	addi	a5,a5,-596 # 80023000 <disk>
    8000625c:	00a78733          	add	a4,a5,a0
    80006260:	6789                	lui	a5,0x2
    80006262:	97ba                	add	a5,a5,a4
    80006264:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006268:	eba1                	bnez	a5,800062b8 <free_desc+0x72>
        panic("virtio_disk_intr 2");
    disk.desc[i].addr = 0;
    8000626a:	00451713          	slli	a4,a0,0x4
    8000626e:	0001f797          	auipc	a5,0x1f
    80006272:	d927b783          	ld	a5,-622(a5) # 80025000 <disk+0x2000>
    80006276:	97ba                	add	a5,a5,a4
    80006278:	0007b023          	sd	zero,0(a5)
    disk.free[i] = 1;
    8000627c:	0001d797          	auipc	a5,0x1d
    80006280:	d8478793          	addi	a5,a5,-636 # 80023000 <disk>
    80006284:	97aa                	add	a5,a5,a0
    80006286:	6509                	lui	a0,0x2
    80006288:	953e                	add	a0,a0,a5
    8000628a:	4785                	li	a5,1
    8000628c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    80006290:	0001f517          	auipc	a0,0x1f
    80006294:	d8850513          	addi	a0,a0,-632 # 80025018 <disk+0x2018>
    80006298:	ffffc097          	auipc	ra,0xffffc
    8000629c:	0c2080e7          	jalr	194(ra) # 8000235a <wakeup>
}
    800062a0:	60a2                	ld	ra,8(sp)
    800062a2:	6402                	ld	s0,0(sp)
    800062a4:	0141                	addi	sp,sp,16
    800062a6:	8082                	ret
        panic("virtio_disk_intr 1");
    800062a8:	00002517          	auipc	a0,0x2
    800062ac:	5c050513          	addi	a0,a0,1472 # 80008868 <syscalls+0x440>
    800062b0:	ffffa097          	auipc	ra,0xffffa
    800062b4:	292080e7          	jalr	658(ra) # 80000542 <panic>
        panic("virtio_disk_intr 2");
    800062b8:	00002517          	auipc	a0,0x2
    800062bc:	5c850513          	addi	a0,a0,1480 # 80008880 <syscalls+0x458>
    800062c0:	ffffa097          	auipc	ra,0xffffa
    800062c4:	282080e7          	jalr	642(ra) # 80000542 <panic>

00000000800062c8 <virtio_disk_init>:
{
    800062c8:	1101                	addi	sp,sp,-32
    800062ca:	ec06                	sd	ra,24(sp)
    800062cc:	e822                	sd	s0,16(sp)
    800062ce:	e426                	sd	s1,8(sp)
    800062d0:	1000                	addi	s0,sp,32
    initlock(&disk.vdisk_lock, "virtio_disk");
    800062d2:	00002597          	auipc	a1,0x2
    800062d6:	5c658593          	addi	a1,a1,1478 # 80008898 <syscalls+0x470>
    800062da:	0001f517          	auipc	a0,0x1f
    800062de:	dce50513          	addi	a0,a0,-562 # 800250a8 <disk+0x20a8>
    800062e2:	ffffb097          	auipc	ra,0xffffb
    800062e6:	88c080e7          	jalr	-1908(ra) # 80000b6e <initlock>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062ea:	100017b7          	lui	a5,0x10001
    800062ee:	4398                	lw	a4,0(a5)
    800062f0:	2701                	sext.w	a4,a4
    800062f2:	747277b7          	lui	a5,0x74727
    800062f6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800062fa:	0ef71163          	bne	a4,a5,800063dc <virtio_disk_init+0x114>
        *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062fe:	100017b7          	lui	a5,0x10001
    80006302:	43dc                	lw	a5,4(a5)
    80006304:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006306:	4705                	li	a4,1
    80006308:	0ce79a63          	bne	a5,a4,800063dc <virtio_disk_init+0x114>
        *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000630c:	100017b7          	lui	a5,0x10001
    80006310:	479c                	lw	a5,8(a5)
    80006312:	2781                	sext.w	a5,a5
    80006314:	4709                	li	a4,2
    80006316:	0ce79363          	bne	a5,a4,800063dc <virtio_disk_init+0x114>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551)
    8000631a:	100017b7          	lui	a5,0x10001
    8000631e:	47d8                	lw	a4,12(a5)
    80006320:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006322:	554d47b7          	lui	a5,0x554d4
    80006326:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000632a:	0af71963          	bne	a4,a5,800063dc <virtio_disk_init+0x114>
    *R(VIRTIO_MMIO_STATUS) = status;
    8000632e:	100017b7          	lui	a5,0x10001
    80006332:	4705                	li	a4,1
    80006334:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80006336:	470d                	li	a4,3
    80006338:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000633a:	4b94                	lw	a3,16(a5)
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000633c:	c7ffe737          	lui	a4,0xc7ffe
    80006340:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80006344:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006346:	2701                	sext.w	a4,a4
    80006348:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    8000634a:	472d                	li	a4,11
    8000634c:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    8000634e:	473d                	li	a4,15
    80006350:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006352:	6705                	lui	a4,0x1
    80006354:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006356:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000635a:	5bdc                	lw	a5,52(a5)
    8000635c:	2781                	sext.w	a5,a5
    if (max == 0)
    8000635e:	c7d9                	beqz	a5,800063ec <virtio_disk_init+0x124>
    if (max < NUM)
    80006360:	471d                	li	a4,7
    80006362:	08f77d63          	bgeu	a4,a5,800063fc <virtio_disk_init+0x134>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006366:	100014b7          	lui	s1,0x10001
    8000636a:	47a1                	li	a5,8
    8000636c:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    8000636e:	6609                	lui	a2,0x2
    80006370:	4581                	li	a1,0
    80006372:	0001d517          	auipc	a0,0x1d
    80006376:	c8e50513          	addi	a0,a0,-882 # 80023000 <disk>
    8000637a:	ffffb097          	auipc	ra,0xffffb
    8000637e:	980080e7          	jalr	-1664(ra) # 80000cfa <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006382:	0001d717          	auipc	a4,0x1d
    80006386:	c7e70713          	addi	a4,a4,-898 # 80023000 <disk>
    8000638a:	00c75793          	srli	a5,a4,0xc
    8000638e:	2781                	sext.w	a5,a5
    80006390:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct VRingDesc *)disk.pages;
    80006392:	0001f797          	auipc	a5,0x1f
    80006396:	c6e78793          	addi	a5,a5,-914 # 80025000 <disk+0x2000>
    8000639a:	e398                	sd	a4,0(a5)
    disk.avail =
    8000639c:	0001d717          	auipc	a4,0x1d
    800063a0:	ce470713          	addi	a4,a4,-796 # 80023080 <disk+0x80>
    800063a4:	e798                	sd	a4,8(a5)
    disk.used = (struct UsedArea *)(disk.pages + PGSIZE);
    800063a6:	0001e717          	auipc	a4,0x1e
    800063aa:	c5a70713          	addi	a4,a4,-934 # 80024000 <disk+0x1000>
    800063ae:	eb98                	sd	a4,16(a5)
        disk.free[i] = 1;
    800063b0:	4705                	li	a4,1
    800063b2:	00e78c23          	sb	a4,24(a5)
    800063b6:	00e78ca3          	sb	a4,25(a5)
    800063ba:	00e78d23          	sb	a4,26(a5)
    800063be:	00e78da3          	sb	a4,27(a5)
    800063c2:	00e78e23          	sb	a4,28(a5)
    800063c6:	00e78ea3          	sb	a4,29(a5)
    800063ca:	00e78f23          	sb	a4,30(a5)
    800063ce:	00e78fa3          	sb	a4,31(a5)
}
    800063d2:	60e2                	ld	ra,24(sp)
    800063d4:	6442                	ld	s0,16(sp)
    800063d6:	64a2                	ld	s1,8(sp)
    800063d8:	6105                	addi	sp,sp,32
    800063da:	8082                	ret
        panic("could not find virtio disk");
    800063dc:	00002517          	auipc	a0,0x2
    800063e0:	4cc50513          	addi	a0,a0,1228 # 800088a8 <syscalls+0x480>
    800063e4:	ffffa097          	auipc	ra,0xffffa
    800063e8:	15e080e7          	jalr	350(ra) # 80000542 <panic>
        panic("virtio disk has no queue 0");
    800063ec:	00002517          	auipc	a0,0x2
    800063f0:	4dc50513          	addi	a0,a0,1244 # 800088c8 <syscalls+0x4a0>
    800063f4:	ffffa097          	auipc	ra,0xffffa
    800063f8:	14e080e7          	jalr	334(ra) # 80000542 <panic>
        panic("virtio disk max queue too short");
    800063fc:	00002517          	auipc	a0,0x2
    80006400:	4ec50513          	addi	a0,a0,1260 # 800088e8 <syscalls+0x4c0>
    80006404:	ffffa097          	auipc	ra,0xffffa
    80006408:	13e080e7          	jalr	318(ra) # 80000542 <panic>

000000008000640c <virtio_disk_rw>:
    }
    return 0;
}

void virtio_disk_rw(struct buf *b, int write)
{
    8000640c:	7175                	addi	sp,sp,-144
    8000640e:	e506                	sd	ra,136(sp)
    80006410:	e122                	sd	s0,128(sp)
    80006412:	fca6                	sd	s1,120(sp)
    80006414:	f8ca                	sd	s2,112(sp)
    80006416:	f4ce                	sd	s3,104(sp)
    80006418:	f0d2                	sd	s4,96(sp)
    8000641a:	ecd6                	sd	s5,88(sp)
    8000641c:	e8da                	sd	s6,80(sp)
    8000641e:	e4de                	sd	s7,72(sp)
    80006420:	e0e2                	sd	s8,64(sp)
    80006422:	fc66                	sd	s9,56(sp)
    80006424:	f86a                	sd	s10,48(sp)
    80006426:	f46e                	sd	s11,40(sp)
    80006428:	0900                	addi	s0,sp,144
    8000642a:	8aaa                	mv	s5,a0
    8000642c:	8d2e                	mv	s10,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    8000642e:	00c52c83          	lw	s9,12(a0)
    80006432:	001c9c9b          	slliw	s9,s9,0x1
    80006436:	1c82                	slli	s9,s9,0x20
    80006438:	020cdc93          	srli	s9,s9,0x20

    acquire(&disk.vdisk_lock);
    8000643c:	0001f517          	auipc	a0,0x1f
    80006440:	c6c50513          	addi	a0,a0,-916 # 800250a8 <disk+0x20a8>
    80006444:	ffffa097          	auipc	ra,0xffffa
    80006448:	7ba080e7          	jalr	1978(ra) # 80000bfe <acquire>
    for (int i = 0; i < 3; i++)
    8000644c:	4981                	li	s3,0
    for (int i = 0; i < NUM; i++)
    8000644e:	44a1                	li	s1,8
            disk.free[i] = 0;
    80006450:	0001dc17          	auipc	s8,0x1d
    80006454:	bb0c0c13          	addi	s8,s8,-1104 # 80023000 <disk>
    80006458:	6b89                	lui	s7,0x2
    for (int i = 0; i < 3; i++)
    8000645a:	4b0d                	li	s6,3
    8000645c:	a0ad                	j	800064c6 <virtio_disk_rw+0xba>
            disk.free[i] = 0;
    8000645e:	00fc0733          	add	a4,s8,a5
    80006462:	975e                	add	a4,a4,s7
    80006464:	00070c23          	sb	zero,24(a4)
        idx[i] = alloc_desc();
    80006468:	c19c                	sw	a5,0(a1)
        if (idx[i] < 0)
    8000646a:	0207c563          	bltz	a5,80006494 <virtio_disk_rw+0x88>
    for (int i = 0; i < 3; i++)
    8000646e:	2905                	addiw	s2,s2,1
    80006470:	0611                	addi	a2,a2,4
    80006472:	19690d63          	beq	s2,s6,8000660c <virtio_disk_rw+0x200>
        idx[i] = alloc_desc();
    80006476:	85b2                	mv	a1,a2
    for (int i = 0; i < NUM; i++)
    80006478:	0001f717          	auipc	a4,0x1f
    8000647c:	ba070713          	addi	a4,a4,-1120 # 80025018 <disk+0x2018>
    80006480:	87ce                	mv	a5,s3
        if (disk.free[i])
    80006482:	00074683          	lbu	a3,0(a4)
    80006486:	fee1                	bnez	a3,8000645e <virtio_disk_rw+0x52>
    for (int i = 0; i < NUM; i++)
    80006488:	2785                	addiw	a5,a5,1
    8000648a:	0705                	addi	a4,a4,1
    8000648c:	fe979be3          	bne	a5,s1,80006482 <virtio_disk_rw+0x76>
        idx[i] = alloc_desc();
    80006490:	57fd                	li	a5,-1
    80006492:	c19c                	sw	a5,0(a1)
            for (int j = 0; j < i; j++)
    80006494:	01205d63          	blez	s2,800064ae <virtio_disk_rw+0xa2>
    80006498:	8dce                	mv	s11,s3
                free_desc(idx[j]);
    8000649a:	000a2503          	lw	a0,0(s4)
    8000649e:	00000097          	auipc	ra,0x0
    800064a2:	da8080e7          	jalr	-600(ra) # 80006246 <free_desc>
            for (int j = 0; j < i; j++)
    800064a6:	2d85                	addiw	s11,s11,1
    800064a8:	0a11                	addi	s4,s4,4
    800064aa:	ffb918e3          	bne	s2,s11,8000649a <virtio_disk_rw+0x8e>
    {
        if (alloc3_desc(idx) == 0)
        {
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    800064ae:	0001f597          	auipc	a1,0x1f
    800064b2:	bfa58593          	addi	a1,a1,-1030 # 800250a8 <disk+0x20a8>
    800064b6:	0001f517          	auipc	a0,0x1f
    800064ba:	b6250513          	addi	a0,a0,-1182 # 80025018 <disk+0x2018>
    800064be:	ffffc097          	auipc	ra,0xffffc
    800064c2:	d1c080e7          	jalr	-740(ra) # 800021da <sleep>
    for (int i = 0; i < 3; i++)
    800064c6:	f8040a13          	addi	s4,s0,-128
{
    800064ca:	8652                	mv	a2,s4
    for (int i = 0; i < 3; i++)
    800064cc:	894e                	mv	s2,s3
    800064ce:	b765                	j	80006476 <virtio_disk_rw+0x6a>
    disk.desc[idx[0]].next = idx[1];

    disk.desc[idx[1]].addr = (uint64)b->data;
    disk.desc[idx[1]].len = BSIZE;
    if (write)
        disk.desc[idx[1]].flags = 0; // device reads b->data
    800064d0:	0001f717          	auipc	a4,0x1f
    800064d4:	b3073703          	ld	a4,-1232(a4) # 80025000 <disk+0x2000>
    800064d8:	973e                	add	a4,a4,a5
    800064da:	00071623          	sh	zero,12(a4)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800064de:	0001d517          	auipc	a0,0x1d
    800064e2:	b2250513          	addi	a0,a0,-1246 # 80023000 <disk>
    800064e6:	0001f717          	auipc	a4,0x1f
    800064ea:	b1a70713          	addi	a4,a4,-1254 # 80025000 <disk+0x2000>
    800064ee:	6314                	ld	a3,0(a4)
    800064f0:	96be                	add	a3,a3,a5
    800064f2:	00c6d603          	lhu	a2,12(a3)
    800064f6:	00166613          	ori	a2,a2,1
    800064fa:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[1]].next = idx[2];
    800064fe:	f8842683          	lw	a3,-120(s0)
    80006502:	6310                	ld	a2,0(a4)
    80006504:	97b2                	add	a5,a5,a2
    80006506:	00d79723          	sh	a3,14(a5)

    disk.info[idx[0]].status = 0;
    8000650a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000650e:	0612                	slli	a2,a2,0x4
    80006510:	962a                	add	a2,a2,a0
    80006512:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
    disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80006516:	00469793          	slli	a5,a3,0x4
    8000651a:	630c                	ld	a1,0(a4)
    8000651c:	95be                	add	a1,a1,a5
    8000651e:	6689                	lui	a3,0x2
    80006520:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006524:	96ca                	add	a3,a3,s2
    80006526:	96aa                	add	a3,a3,a0
    80006528:	e194                	sd	a3,0(a1)
    disk.desc[idx[2]].len = 1;
    8000652a:	6314                	ld	a3,0(a4)
    8000652c:	96be                	add	a3,a3,a5
    8000652e:	4585                	li	a1,1
    80006530:	c68c                	sw	a1,8(a3)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006532:	6314                	ld	a3,0(a4)
    80006534:	96be                	add	a3,a3,a5
    80006536:	4509                	li	a0,2
    80006538:	00a69623          	sh	a0,12(a3)
    disk.desc[idx[2]].next = 0;
    8000653c:	6314                	ld	a3,0(a4)
    8000653e:	97b6                	add	a5,a5,a3
    80006540:	00079723          	sh	zero,14(a5)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    80006544:	00baa223          	sw	a1,4(s5)
    disk.info[idx[0]].b = b;
    80006548:	03563423          	sd	s5,40(a2)

    // avail[0] is flags
    // avail[1] tells the device how far to look in avail[2...].
    // avail[2...] are desc[] indices the device should process.
    // we only tell device the first index in our chain of descriptors.
    disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000654c:	6714                	ld	a3,8(a4)
    8000654e:	0026d783          	lhu	a5,2(a3)
    80006552:	8b9d                	andi	a5,a5,7
    80006554:	0789                	addi	a5,a5,2
    80006556:	0786                	slli	a5,a5,0x1
    80006558:	97b6                	add	a5,a5,a3
    8000655a:	00979023          	sh	s1,0(a5)
    __sync_synchronize();
    8000655e:	0ff0000f          	fence
    disk.avail[1] = disk.avail[1] + 1;
    80006562:	6718                	ld	a4,8(a4)
    80006564:	00275783          	lhu	a5,2(a4)
    80006568:	2785                	addiw	a5,a5,1
    8000656a:	00f71123          	sh	a5,2(a4)

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000656e:	100017b7          	lui	a5,0x10001
    80006572:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1)
    80006576:	004aa783          	lw	a5,4(s5)
    8000657a:	02b79163          	bne	a5,a1,8000659c <virtio_disk_rw+0x190>
    {
        sleep(b, &disk.vdisk_lock);
    8000657e:	0001f917          	auipc	s2,0x1f
    80006582:	b2a90913          	addi	s2,s2,-1238 # 800250a8 <disk+0x20a8>
    while (b->disk == 1)
    80006586:	4485                	li	s1,1
        sleep(b, &disk.vdisk_lock);
    80006588:	85ca                	mv	a1,s2
    8000658a:	8556                	mv	a0,s5
    8000658c:	ffffc097          	auipc	ra,0xffffc
    80006590:	c4e080e7          	jalr	-946(ra) # 800021da <sleep>
    while (b->disk == 1)
    80006594:	004aa783          	lw	a5,4(s5)
    80006598:	fe9788e3          	beq	a5,s1,80006588 <virtio_disk_rw+0x17c>
    }

    disk.info[idx[0]].b = 0;
    8000659c:	f8042483          	lw	s1,-128(s0)
    800065a0:	20048793          	addi	a5,s1,512
    800065a4:	00479713          	slli	a4,a5,0x4
    800065a8:	0001d797          	auipc	a5,0x1d
    800065ac:	a5878793          	addi	a5,a5,-1448 # 80023000 <disk>
    800065b0:	97ba                	add	a5,a5,a4
    800065b2:	0207b423          	sd	zero,40(a5)
        if (disk.desc[i].flags & VRING_DESC_F_NEXT)
    800065b6:	0001f917          	auipc	s2,0x1f
    800065ba:	a4a90913          	addi	s2,s2,-1462 # 80025000 <disk+0x2000>
    800065be:	a019                	j	800065c4 <virtio_disk_rw+0x1b8>
            i = disk.desc[i].next;
    800065c0:	00e4d483          	lhu	s1,14(s1)
        free_desc(i);
    800065c4:	8526                	mv	a0,s1
    800065c6:	00000097          	auipc	ra,0x0
    800065ca:	c80080e7          	jalr	-896(ra) # 80006246 <free_desc>
        if (disk.desc[i].flags & VRING_DESC_F_NEXT)
    800065ce:	0492                	slli	s1,s1,0x4
    800065d0:	00093783          	ld	a5,0(s2)
    800065d4:	94be                	add	s1,s1,a5
    800065d6:	00c4d783          	lhu	a5,12(s1)
    800065da:	8b85                	andi	a5,a5,1
    800065dc:	f3f5                	bnez	a5,800065c0 <virtio_disk_rw+0x1b4>
    free_chain(idx[0]);

    release(&disk.vdisk_lock);
    800065de:	0001f517          	auipc	a0,0x1f
    800065e2:	aca50513          	addi	a0,a0,-1334 # 800250a8 <disk+0x20a8>
    800065e6:	ffffa097          	auipc	ra,0xffffa
    800065ea:	6cc080e7          	jalr	1740(ra) # 80000cb2 <release>
}
    800065ee:	60aa                	ld	ra,136(sp)
    800065f0:	640a                	ld	s0,128(sp)
    800065f2:	74e6                	ld	s1,120(sp)
    800065f4:	7946                	ld	s2,112(sp)
    800065f6:	79a6                	ld	s3,104(sp)
    800065f8:	7a06                	ld	s4,96(sp)
    800065fa:	6ae6                	ld	s5,88(sp)
    800065fc:	6b46                	ld	s6,80(sp)
    800065fe:	6ba6                	ld	s7,72(sp)
    80006600:	6c06                	ld	s8,64(sp)
    80006602:	7ce2                	ld	s9,56(sp)
    80006604:	7d42                	ld	s10,48(sp)
    80006606:	7da2                	ld	s11,40(sp)
    80006608:	6149                	addi	sp,sp,144
    8000660a:	8082                	ret
    if (write)
    8000660c:	01a037b3          	snez	a5,s10
    80006610:	f6f42823          	sw	a5,-144(s0)
    buf0.reserved = 0;
    80006614:	f6042a23          	sw	zero,-140(s0)
    buf0.sector = sector;
    80006618:	f7943c23          	sd	s9,-136(s0)
    disk.desc[idx[0]].addr = (uint64)kvmpa((uint64)&buf0);
    8000661c:	f8042483          	lw	s1,-128(s0)
    80006620:	00449913          	slli	s2,s1,0x4
    80006624:	0001f997          	auipc	s3,0x1f
    80006628:	9dc98993          	addi	s3,s3,-1572 # 80025000 <disk+0x2000>
    8000662c:	0009ba03          	ld	s4,0(s3)
    80006630:	9a4a                	add	s4,s4,s2
    80006632:	f7040513          	addi	a0,s0,-144
    80006636:	ffffb097          	auipc	ra,0xffffb
    8000663a:	a94080e7          	jalr	-1388(ra) # 800010ca <kvmpa>
    8000663e:	00aa3023          	sd	a0,0(s4)
    disk.desc[idx[0]].len = sizeof(buf0);
    80006642:	0009b783          	ld	a5,0(s3)
    80006646:	97ca                	add	a5,a5,s2
    80006648:	4741                	li	a4,16
    8000664a:	c798                	sw	a4,8(a5)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000664c:	0009b783          	ld	a5,0(s3)
    80006650:	97ca                	add	a5,a5,s2
    80006652:	4705                	li	a4,1
    80006654:	00e79623          	sh	a4,12(a5)
    disk.desc[idx[0]].next = idx[1];
    80006658:	f8442783          	lw	a5,-124(s0)
    8000665c:	0009b703          	ld	a4,0(s3)
    80006660:	974a                	add	a4,a4,s2
    80006662:	00f71723          	sh	a5,14(a4)
    disk.desc[idx[1]].addr = (uint64)b->data;
    80006666:	0792                	slli	a5,a5,0x4
    80006668:	0009b703          	ld	a4,0(s3)
    8000666c:	973e                	add	a4,a4,a5
    8000666e:	058a8693          	addi	a3,s5,88
    80006672:	e314                	sd	a3,0(a4)
    disk.desc[idx[1]].len = BSIZE;
    80006674:	0009b703          	ld	a4,0(s3)
    80006678:	973e                	add	a4,a4,a5
    8000667a:	40000693          	li	a3,1024
    8000667e:	c714                	sw	a3,8(a4)
    if (write)
    80006680:	e40d18e3          	bnez	s10,800064d0 <virtio_disk_rw+0xc4>
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006684:	0001f717          	auipc	a4,0x1f
    80006688:	97c73703          	ld	a4,-1668(a4) # 80025000 <disk+0x2000>
    8000668c:	973e                	add	a4,a4,a5
    8000668e:	4689                	li	a3,2
    80006690:	00d71623          	sh	a3,12(a4)
    80006694:	b5a9                	j	800064de <virtio_disk_rw+0xd2>

0000000080006696 <virtio_disk_intr>:

void virtio_disk_intr()
{
    80006696:	1101                	addi	sp,sp,-32
    80006698:	ec06                	sd	ra,24(sp)
    8000669a:	e822                	sd	s0,16(sp)
    8000669c:	e426                	sd	s1,8(sp)
    8000669e:	e04a                	sd	s2,0(sp)
    800066a0:	1000                	addi	s0,sp,32
    acquire(&disk.vdisk_lock);
    800066a2:	0001f517          	auipc	a0,0x1f
    800066a6:	a0650513          	addi	a0,a0,-1530 # 800250a8 <disk+0x20a8>
    800066aa:	ffffa097          	auipc	ra,0xffffa
    800066ae:	554080e7          	jalr	1364(ra) # 80000bfe <acquire>

    while ((disk.used_idx % NUM) != (disk.used->id % NUM))
    800066b2:	0001f717          	auipc	a4,0x1f
    800066b6:	94e70713          	addi	a4,a4,-1714 # 80025000 <disk+0x2000>
    800066ba:	02075783          	lhu	a5,32(a4)
    800066be:	6b18                	ld	a4,16(a4)
    800066c0:	00275683          	lhu	a3,2(a4)
    800066c4:	8ebd                	xor	a3,a3,a5
    800066c6:	8a9d                	andi	a3,a3,7
    800066c8:	cab9                	beqz	a3,8000671e <virtio_disk_intr+0x88>
    {
        int id = disk.used->elems[disk.used_idx].id;

        if (disk.info[id].status != 0)
    800066ca:	0001d917          	auipc	s2,0x1d
    800066ce:	93690913          	addi	s2,s2,-1738 # 80023000 <disk>
            panic("virtio_disk_intr status");

        disk.info[id].b->disk = 0; // disk is done with buf
        wakeup(disk.info[id].b);

        disk.used_idx = (disk.used_idx + 1) % NUM;
    800066d2:	0001f497          	auipc	s1,0x1f
    800066d6:	92e48493          	addi	s1,s1,-1746 # 80025000 <disk+0x2000>
        int id = disk.used->elems[disk.used_idx].id;
    800066da:	078e                	slli	a5,a5,0x3
    800066dc:	97ba                	add	a5,a5,a4
    800066de:	43dc                	lw	a5,4(a5)
        if (disk.info[id].status != 0)
    800066e0:	20078713          	addi	a4,a5,512
    800066e4:	0712                	slli	a4,a4,0x4
    800066e6:	974a                	add	a4,a4,s2
    800066e8:	03074703          	lbu	a4,48(a4)
    800066ec:	ef21                	bnez	a4,80006744 <virtio_disk_intr+0xae>
        disk.info[id].b->disk = 0; // disk is done with buf
    800066ee:	20078793          	addi	a5,a5,512
    800066f2:	0792                	slli	a5,a5,0x4
    800066f4:	97ca                	add	a5,a5,s2
    800066f6:	7798                	ld	a4,40(a5)
    800066f8:	00072223          	sw	zero,4(a4)
        wakeup(disk.info[id].b);
    800066fc:	7788                	ld	a0,40(a5)
    800066fe:	ffffc097          	auipc	ra,0xffffc
    80006702:	c5c080e7          	jalr	-932(ra) # 8000235a <wakeup>
        disk.used_idx = (disk.used_idx + 1) % NUM;
    80006706:	0204d783          	lhu	a5,32(s1)
    8000670a:	2785                	addiw	a5,a5,1
    8000670c:	8b9d                	andi	a5,a5,7
    8000670e:	02f49023          	sh	a5,32(s1)
    while ((disk.used_idx % NUM) != (disk.used->id % NUM))
    80006712:	6898                	ld	a4,16(s1)
    80006714:	00275683          	lhu	a3,2(a4)
    80006718:	8a9d                	andi	a3,a3,7
    8000671a:	fcf690e3          	bne	a3,a5,800066da <virtio_disk_intr+0x44>
    }
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000671e:	10001737          	lui	a4,0x10001
    80006722:	533c                	lw	a5,96(a4)
    80006724:	8b8d                	andi	a5,a5,3
    80006726:	d37c                	sw	a5,100(a4)

    release(&disk.vdisk_lock);
    80006728:	0001f517          	auipc	a0,0x1f
    8000672c:	98050513          	addi	a0,a0,-1664 # 800250a8 <disk+0x20a8>
    80006730:	ffffa097          	auipc	ra,0xffffa
    80006734:	582080e7          	jalr	1410(ra) # 80000cb2 <release>
}
    80006738:	60e2                	ld	ra,24(sp)
    8000673a:	6442                	ld	s0,16(sp)
    8000673c:	64a2                	ld	s1,8(sp)
    8000673e:	6902                	ld	s2,0(sp)
    80006740:	6105                	addi	sp,sp,32
    80006742:	8082                	ret
            panic("virtio_disk_intr status");
    80006744:	00002517          	auipc	a0,0x2
    80006748:	1c450513          	addi	a0,a0,452 # 80008908 <syscalls+0x4e0>
    8000674c:	ffffa097          	auipc	ra,0xffffa
    80006750:	df6080e7          	jalr	-522(ra) # 80000542 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
