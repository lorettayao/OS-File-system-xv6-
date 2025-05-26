
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a3013103          	ld	sp,-1488(sp) # 80008a30 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000060:	1b478793          	addi	a5,a5,436 # 80006210 <timervec>
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
    80000574:	34050513          	addi	a0,a0,832 # 800088b0 <syscalls+0x488>
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
    80000efa:	35a080e7          	jalr	858(ra) # 80006250 <plicinithart>
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
    80000f16:	00008517          	auipc	a0,0x8
    80000f1a:	99a50513          	addi	a0,a0,-1638 # 800088b0 <syscalls+0x488>
    80000f1e:	fffff097          	auipc	ra,0xfffff
    80000f22:	66e080e7          	jalr	1646(ra) # 8000058c <printf>
        printf("xv6 kernel is booting\n");
    80000f26:	00007517          	auipc	a0,0x7
    80000f2a:	17a50513          	addi	a0,a0,378 # 800080a0 <digits+0x60>
    80000f2e:	fffff097          	auipc	ra,0xfffff
    80000f32:	65e080e7          	jalr	1630(ra) # 8000058c <printf>
        printf("\n");
    80000f36:	00008517          	auipc	a0,0x8
    80000f3a:	97a50513          	addi	a0,a0,-1670 # 800088b0 <syscalls+0x488>
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
    80000f7a:	2c4080e7          	jalr	708(ra) # 8000623a <plicinit>
        plicinithart();     // ask PLIC for device interrupts
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	2d2080e7          	jalr	722(ra) # 80006250 <plicinithart>
        binit();            // buffer cache
    80000f86:	00002097          	auipc	ra,0x2
    80000f8a:	e72080e7          	jalr	-398(ra) # 80002df8 <binit>
        iinit();            // inode cache
    80000f8e:	00002097          	auipc	ra,0x2
    80000f92:	470080e7          	jalr	1136(ra) # 800033fe <iinit>
        fileinit();         // file table
    80000f96:	00003097          	auipc	ra,0x3
    80000f9a:	72a080e7          	jalr	1834(ra) # 800046c0 <fileinit>
        virtio_disk_init(); // emulated hard disk
    80000f9e:	00005097          	auipc	ra,0x5
    80000fa2:	3ba080e7          	jalr	954(ra) # 80006358 <virtio_disk_init>
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
    80001a1e:	fc67a783          	lw	a5,-58(a5) # 800089e0 <first.1>
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
    80001a38:	fa07a623          	sw	zero,-84(a5) # 800089e0 <first.1>
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
    80001a6a:	f7e78793          	addi	a5,a5,-130 # 800089e4 <nextpid>
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
    80001cb8:	d3c58593          	addi	a1,a1,-708 # 800089f0 <initcode>
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
    80001cf6:	1e2080e7          	jalr	482(ra) # 80003ed4 <namei>
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
    80001e40:	916080e7          	jalr	-1770(ra) # 80004752 <filedup>
    80001e44:	00a93023          	sd	a0,0(s2)
    80001e48:	b7e5                	j	80001e30 <fork+0xa6>
    np->cwd = idup(p->cwd);
    80001e4a:	150ab503          	ld	a0,336(s5)
    80001e4e:	00001097          	auipc	ra,0x1
    80001e52:	774080e7          	jalr	1908(ra) # 800035c2 <idup>
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
    800020d8:	6d0080e7          	jalr	1744(ra) # 800047a4 <fileclose>
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
    800020f0:	1e6080e7          	jalr	486(ra) # 800042d2 <begin_op>
    iput(p->cwd);
    800020f4:	1509b503          	ld	a0,336(s3)
    800020f8:	00001097          	auipc	ra,0x1
    800020fc:	7e0080e7          	jalr	2016(ra) # 800038d8 <iput>
    end_op();
    80002100:	00002097          	auipc	ra,0x2
    80002104:	252080e7          	jalr	594(ra) # 80004352 <end_op>
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
    800024fa:	3ba50513          	addi	a0,a0,954 # 800088b0 <syscalls+0x488>
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
    8000252c:	388a0a13          	addi	s4,s4,904 # 800088b0 <syscalls+0x488>
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
    8000262a:	b5a78793          	addi	a5,a5,-1190 # 80006180 <kernelvec>
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
    80002752:	b3a080e7          	jalr	-1222(ra) # 80006288 <plic_claim>
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
    80002780:	b30080e7          	jalr	-1232(ra) # 800062ac <plic_complete>
        return 1;
    80002784:	4505                	li	a0,1
    80002786:	bf55                	j	8000273a <devintr+0x1e>
            uartintr();
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	23a080e7          	jalr	570(ra) # 800009c2 <uartintr>
    80002790:	b7ed                	j	8000277a <devintr+0x5e>
            virtio_disk_intr();
    80002792:	00004097          	auipc	ra,0x4
    80002796:	f94080e7          	jalr	-108(ra) # 80006726 <virtio_disk_intr>
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
    800027d8:	9ac78793          	addi	a5,a5,-1620 # 80006180 <kernelvec>
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
    80002d92:	c4e7af23          	sw	a4,-930(a5) # 800089ec <force_read_error_pbn>
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
    80002dae:	c4252503          	lw	a0,-958(a0) # 800089ec <force_read_error_pbn>
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
    80002de6:	c0f72323          	sw	a5,-1018(a4) # 800089e8 <force_disk_fail_id>
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
    80002e60:	73a080e7          	jalr	1850(ra) # 80004596 <initsleeplock>
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
    80002ef0:	6e4080e7          	jalr	1764(ra) # 800045d0 <acquiresleep>
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
    80002f4e:	686080e7          	jalr	1670(ra) # 800045d0 <acquiresleep>
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
    80002f72:	a7a92903          	lw	s2,-1414(s2) # 800089e8 <force_disk_fail_id>
    b = bget(dev, blockno);
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	f10080e7          	jalr	-240(ra) # 80002e86 <bget>
    80002f7e:	84aa                	mv	s1,a0

    // Force cache miss if simulation error
    if ((b->blockno == force_read_error_pbn && force_read_error_pbn != -1) ||
    80002f80:	00006797          	auipc	a5,0x6
    80002f84:	a6c7a783          	lw	a5,-1428(a5) # 800089ec <force_read_error_pbn>
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
    80002f9c:	504080e7          	jalr	1284(ra) # 8000649c <virtio_disk_rw>
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
    80002fd2:	69c080e7          	jalr	1692(ra) # 8000466a <holdingsleep>
    80002fd6:	cd01                	beqz	a0,80002fee <bwrite+0x2e>
        panic("bwrite");
    virtio_disk_rw(b, 1);
    80002fd8:	4585                	li	a1,1
    80002fda:	8526                	mv	a0,s1
    80002fdc:	00003097          	auipc	ra,0x3
    80002fe0:	4c0080e7          	jalr	1216(ra) # 8000649c <virtio_disk_rw>
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
    80003016:	658080e7          	jalr	1624(ra) # 8000466a <holdingsleep>
    8000301a:	c92d                	beqz	a0,8000308c <brelse+0x8e>
        panic("brelse");

    releasesleep(&b->lock);
    8000301c:	854a                	mv	a0,s2
    8000301e:	00001097          	auipc	ra,0x1
    80003022:	608080e7          	jalr	1544(ra) # 80004626 <releasesleep>

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
    800031e8:	2c4080e7          	jalr	708(ra) # 800044a8 <log_write>
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
    8000321c:	290080e7          	jalr	656(ra) # 800044a8 <log_write>
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
    80003298:	214080e7          	jalr	532(ra) # 800044a8 <log_write>
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
    800033dc:	e58080e7          	jalr	-424(ra) # 80004230 <initlog>
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
    80003444:	156080e7          	jalr	342(ra) # 80004596 <initsleeplock>
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
            dip->perm = M_READ | M_WRITE; // default permission
    800034fc:	02f99f23          	sh	a5,62(s3)
            log_write(bp); // mark it allocated on the disk
    80003500:	854a                	mv	a0,s2
    80003502:	00001097          	auipc	ra,0x1
    80003506:	fa6080e7          	jalr	-90(ra) # 800044a8 <log_write>
            brelse(bp);
    8000350a:	854a                	mv	a0,s2
    8000350c:	00000097          	auipc	ra,0x0
    80003510:	af2080e7          	jalr	-1294(ra) # 80002ffe <brelse>
            return iget(dev, inum);
    80003514:	85da                	mv	a1,s6
    80003516:	8556                	mv	a0,s5
    80003518:	00000097          	auipc	ra,0x0
    8000351c:	daa080e7          	jalr	-598(ra) # 800032c2 <iget>
}
    80003520:	60a6                	ld	ra,72(sp)
    80003522:	6406                	ld	s0,64(sp)
    80003524:	74e2                	ld	s1,56(sp)
    80003526:	7942                	ld	s2,48(sp)
    80003528:	79a2                	ld	s3,40(sp)
    8000352a:	7a02                	ld	s4,32(sp)
    8000352c:	6ae2                	ld	s5,24(sp)
    8000352e:	6b42                	ld	s6,16(sp)
    80003530:	6ba2                	ld	s7,8(sp)
    80003532:	6161                	addi	sp,sp,80
    80003534:	8082                	ret

0000000080003536 <iupdate>:
{
    80003536:	1101                	addi	sp,sp,-32
    80003538:	ec06                	sd	ra,24(sp)
    8000353a:	e822                	sd	s0,16(sp)
    8000353c:	e426                	sd	s1,8(sp)
    8000353e:	e04a                	sd	s2,0(sp)
    80003540:	1000                	addi	s0,sp,32
    80003542:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003544:	415c                	lw	a5,4(a0)
    80003546:	0047d79b          	srliw	a5,a5,0x4
    8000354a:	0001d597          	auipc	a1,0x1d
    8000354e:	90e5a583          	lw	a1,-1778(a1) # 8001fe58 <sb+0x18>
    80003552:	9dbd                	addw	a1,a1,a5
    80003554:	4108                	lw	a0,0(a0)
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	a0c080e7          	jalr	-1524(ra) # 80002f62 <bread>
    8000355e:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003560:	05850793          	addi	a5,a0,88
    80003564:	40c8                	lw	a0,4(s1)
    80003566:	893d                	andi	a0,a0,15
    80003568:	051a                	slli	a0,a0,0x6
    8000356a:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    8000356c:	04449703          	lh	a4,68(s1)
    80003570:	02e51c23          	sh	a4,56(a0)
    dip->nlink = ip->nlink;
    80003574:	04a49703          	lh	a4,74(s1)
    80003578:	02e51d23          	sh	a4,58(a0)
    dip->size = ip->size;
    8000357c:	44f8                	lw	a4,76(s1)
    8000357e:	c118                	sw	a4,0(a0)
    dip->mode = ip->mode;
    80003580:	08449703          	lh	a4,132(s1)
    80003584:	02e51e23          	sh	a4,60(a0)
    dip->perm = ip->perm;
    80003588:	08649703          	lh	a4,134(s1)
    8000358c:	02e51f23          	sh	a4,62(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003590:	03400613          	li	a2,52
    80003594:	05048593          	addi	a1,s1,80
    80003598:	0511                	addi	a0,a0,4
    8000359a:	ffffd097          	auipc	ra,0xffffd
    8000359e:	7bc080e7          	jalr	1980(ra) # 80000d56 <memmove>
    log_write(bp);
    800035a2:	854a                	mv	a0,s2
    800035a4:	00001097          	auipc	ra,0x1
    800035a8:	f04080e7          	jalr	-252(ra) # 800044a8 <log_write>
    brelse(bp);
    800035ac:	854a                	mv	a0,s2
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	a50080e7          	jalr	-1456(ra) # 80002ffe <brelse>
}
    800035b6:	60e2                	ld	ra,24(sp)
    800035b8:	6442                	ld	s0,16(sp)
    800035ba:	64a2                	ld	s1,8(sp)
    800035bc:	6902                	ld	s2,0(sp)
    800035be:	6105                	addi	sp,sp,32
    800035c0:	8082                	ret

00000000800035c2 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode *idup(struct inode *ip)
{
    800035c2:	1101                	addi	sp,sp,-32
    800035c4:	ec06                	sd	ra,24(sp)
    800035c6:	e822                	sd	s0,16(sp)
    800035c8:	e426                	sd	s1,8(sp)
    800035ca:	1000                	addi	s0,sp,32
    800035cc:	84aa                	mv	s1,a0
    acquire(&icache.lock);
    800035ce:	0001d517          	auipc	a0,0x1d
    800035d2:	89250513          	addi	a0,a0,-1902 # 8001fe60 <icache>
    800035d6:	ffffd097          	auipc	ra,0xffffd
    800035da:	628080e7          	jalr	1576(ra) # 80000bfe <acquire>
    ip->ref++;
    800035de:	449c                	lw	a5,8(s1)
    800035e0:	2785                	addiw	a5,a5,1
    800035e2:	c49c                	sw	a5,8(s1)
    release(&icache.lock);
    800035e4:	0001d517          	auipc	a0,0x1d
    800035e8:	87c50513          	addi	a0,a0,-1924 # 8001fe60 <icache>
    800035ec:	ffffd097          	auipc	ra,0xffffd
    800035f0:	6c6080e7          	jalr	1734(ra) # 80000cb2 <release>
    return ip;
}
    800035f4:	8526                	mv	a0,s1
    800035f6:	60e2                	ld	ra,24(sp)
    800035f8:	6442                	ld	s0,16(sp)
    800035fa:	64a2                	ld	s1,8(sp)
    800035fc:	6105                	addi	sp,sp,32
    800035fe:	8082                	ret

0000000080003600 <ilock>:

/* TODO: Access Control & Symbolic Link */
// Lock the given inode.
// Reads the inode from disk if necessary.
void ilock(struct inode *ip)
{
    80003600:	1101                	addi	sp,sp,-32
    80003602:	ec06                	sd	ra,24(sp)
    80003604:	e822                	sd	s0,16(sp)
    80003606:	e426                	sd	s1,8(sp)
    80003608:	e04a                	sd	s2,0(sp)
    8000360a:	1000                	addi	s0,sp,32
    struct buf *bp;
    struct dinode *dip;

    if (ip == 0 || ip->ref < 1)
    8000360c:	c115                	beqz	a0,80003630 <ilock+0x30>
    8000360e:	84aa                	mv	s1,a0
    80003610:	451c                	lw	a5,8(a0)
    80003612:	00f05f63          	blez	a5,80003630 <ilock+0x30>
        panic("ilock");

    acquiresleep(&ip->lock);
    80003616:	0541                	addi	a0,a0,16
    80003618:	00001097          	auipc	ra,0x1
    8000361c:	fb8080e7          	jalr	-72(ra) # 800045d0 <acquiresleep>

    if (ip->valid == 0)
    80003620:	40bc                	lw	a5,64(s1)
    80003622:	cf99                	beqz	a5,80003640 <ilock+0x40>
        brelse(bp);
        ip->valid = 1;
        if (ip->type == 0)
            panic("ilock: no type");
    }
}
    80003624:	60e2                	ld	ra,24(sp)
    80003626:	6442                	ld	s0,16(sp)
    80003628:	64a2                	ld	s1,8(sp)
    8000362a:	6902                	ld	s2,0(sp)
    8000362c:	6105                	addi	sp,sp,32
    8000362e:	8082                	ret
        panic("ilock");
    80003630:	00005517          	auipc	a0,0x5
    80003634:	fa050513          	addi	a0,a0,-96 # 800085d0 <syscalls+0x1a8>
    80003638:	ffffd097          	auipc	ra,0xffffd
    8000363c:	f0a080e7          	jalr	-246(ra) # 80000542 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003640:	40dc                	lw	a5,4(s1)
    80003642:	0047d79b          	srliw	a5,a5,0x4
    80003646:	0001d597          	auipc	a1,0x1d
    8000364a:	8125a583          	lw	a1,-2030(a1) # 8001fe58 <sb+0x18>
    8000364e:	9dbd                	addw	a1,a1,a5
    80003650:	4088                	lw	a0,0(s1)
    80003652:	00000097          	auipc	ra,0x0
    80003656:	910080e7          	jalr	-1776(ra) # 80002f62 <bread>
    8000365a:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000365c:	05850593          	addi	a1,a0,88
    80003660:	40dc                	lw	a5,4(s1)
    80003662:	8bbd                	andi	a5,a5,15
    80003664:	079a                	slli	a5,a5,0x6
    80003666:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80003668:	03859783          	lh	a5,56(a1)
    8000366c:	04f49223          	sh	a5,68(s1)
        ip->nlink = dip->nlink;
    80003670:	03a59783          	lh	a5,58(a1)
    80003674:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80003678:	419c                	lw	a5,0(a1)
    8000367a:	c4fc                	sw	a5,76(s1)
        ip->mode = dip->mode;
    8000367c:	03c59783          	lh	a5,60(a1)
    80003680:	08f49223          	sh	a5,132(s1)
        ip->perm = dip->perm;
    80003684:	03e59783          	lh	a5,62(a1)
    80003688:	08f49323          	sh	a5,134(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000368c:	03400613          	li	a2,52
    80003690:	0591                	addi	a1,a1,4
    80003692:	05048513          	addi	a0,s1,80
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	6c0080e7          	jalr	1728(ra) # 80000d56 <memmove>
        brelse(bp);
    8000369e:	854a                	mv	a0,s2
    800036a0:	00000097          	auipc	ra,0x0
    800036a4:	95e080e7          	jalr	-1698(ra) # 80002ffe <brelse>
        ip->valid = 1;
    800036a8:	4785                	li	a5,1
    800036aa:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    800036ac:	04449783          	lh	a5,68(s1)
    800036b0:	fbb5                	bnez	a5,80003624 <ilock+0x24>
            panic("ilock: no type");
    800036b2:	00005517          	auipc	a0,0x5
    800036b6:	f2650513          	addi	a0,a0,-218 # 800085d8 <syscalls+0x1b0>
    800036ba:	ffffd097          	auipc	ra,0xffffd
    800036be:	e88080e7          	jalr	-376(ra) # 80000542 <panic>

00000000800036c2 <iunlock>:

// Unlock the given inode.
void iunlock(struct inode *ip)
{
    800036c2:	1101                	addi	sp,sp,-32
    800036c4:	ec06                	sd	ra,24(sp)
    800036c6:	e822                	sd	s0,16(sp)
    800036c8:	e426                	sd	s1,8(sp)
    800036ca:	e04a                	sd	s2,0(sp)
    800036cc:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036ce:	c905                	beqz	a0,800036fe <iunlock+0x3c>
    800036d0:	84aa                	mv	s1,a0
    800036d2:	01050913          	addi	s2,a0,16
    800036d6:	854a                	mv	a0,s2
    800036d8:	00001097          	auipc	ra,0x1
    800036dc:	f92080e7          	jalr	-110(ra) # 8000466a <holdingsleep>
    800036e0:	cd19                	beqz	a0,800036fe <iunlock+0x3c>
    800036e2:	449c                	lw	a5,8(s1)
    800036e4:	00f05d63          	blez	a5,800036fe <iunlock+0x3c>
        panic("iunlock");

    releasesleep(&ip->lock);
    800036e8:	854a                	mv	a0,s2
    800036ea:	00001097          	auipc	ra,0x1
    800036ee:	f3c080e7          	jalr	-196(ra) # 80004626 <releasesleep>
}
    800036f2:	60e2                	ld	ra,24(sp)
    800036f4:	6442                	ld	s0,16(sp)
    800036f6:	64a2                	ld	s1,8(sp)
    800036f8:	6902                	ld	s2,0(sp)
    800036fa:	6105                	addi	sp,sp,32
    800036fc:	8082                	ret
        panic("iunlock");
    800036fe:	00005517          	auipc	a0,0x5
    80003702:	eea50513          	addi	a0,a0,-278 # 800085e8 <syscalls+0x1c0>
    80003706:	ffffd097          	auipc	ra,0xffffd
    8000370a:	e3c080e7          	jalr	-452(ra) # 80000542 <panic>

000000008000370e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.

uint bmap(struct inode *ip, uint bn)
{
    8000370e:	7179                	addi	sp,sp,-48
    80003710:	f406                	sd	ra,40(sp)
    80003712:	f022                	sd	s0,32(sp)
    80003714:	ec26                	sd	s1,24(sp)
    80003716:	e84a                	sd	s2,16(sp)
    80003718:	e44e                	sd	s3,8(sp)
    8000371a:	e052                	sd	s4,0(sp)
    8000371c:	1800                	addi	s0,sp,48
    8000371e:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) //
    80003720:	47ad                	li	a5,11
    80003722:	02b7ef63          	bltu	a5,a1,80003760 <bmap+0x52>
    {
        if ((addr = ip->addrs[bn]) == 0)
    80003726:	02059493          	slli	s1,a1,0x20
    8000372a:	9081                	srli	s1,s1,0x20
    8000372c:	048a                	slli	s1,s1,0x2
    8000372e:	94aa                	add	s1,s1,a0
    80003730:	0504a903          	lw	s2,80(s1)
    80003734:	0a091263          	bnez	s2,800037d8 <bmap+0xca>
        {
            addr = balloc(ip->dev);
    80003738:	4108                	lw	a0,0(a0)
    8000373a:	00000097          	auipc	ra,0x0
    8000373e:	9da080e7          	jalr	-1574(ra) # 80003114 <balloc>
    80003742:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80003746:	00090563          	beqz	s2,80003750 <bmap+0x42>
                panic("bmap: balloc failed");
            ip->addrs[bn] = addr;
    8000374a:	0524a823          	sw	s2,80(s1)
    8000374e:	a069                	j	800037d8 <bmap+0xca>
                panic("bmap: balloc failed");
    80003750:	00005517          	auipc	a0,0x5
    80003754:	ea050513          	addi	a0,a0,-352 # 800085f0 <syscalls+0x1c8>
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	dea080e7          	jalr	-534(ra) # 80000542 <panic>
        }
        return addr;
    }
    bn -= NDIRECT;
    80003760:	ff45849b          	addiw	s1,a1,-12
    80003764:	0004871b          	sext.w	a4,s1
    if (bn < NINDIRECT)
    80003768:	0ff00793          	li	a5,255
    8000376c:	08e7ef63          	bltu	a5,a4,8000380a <bmap+0xfc>
    {
        if ((addr = ip->addrs[NDIRECT]) == 0)
    80003770:	08052583          	lw	a1,128(a0)
    80003774:	e999                	bnez	a1,8000378a <bmap+0x7c>
        {
            addr = balloc(ip->dev);
    80003776:	4108                	lw	a0,0(a0)
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	99c080e7          	jalr	-1636(ra) # 80003114 <balloc>
    80003780:	0005059b          	sext.w	a1,a0
            if (addr == 0)
    80003784:	c1bd                	beqz	a1,800037ea <bmap+0xdc>
                panic("bmap: balloc failed for indirect block");
            ip->addrs[NDIRECT] = addr;
    80003786:	08b9a023          	sw	a1,128(s3)
        }

        bp = bread(ip->dev, addr);
    8000378a:	0009a503          	lw	a0,0(s3)
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	7d4080e7          	jalr	2004(ra) # 80002f62 <bread>
    80003796:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    80003798:	05850793          	addi	a5,a0,88

        uint target_addr = a[bn];
    8000379c:	1482                	slli	s1,s1,0x20
    8000379e:	9081                	srli	s1,s1,0x20
    800037a0:	048a                	slli	s1,s1,0x2
    800037a2:	94be                	add	s1,s1,a5
    800037a4:	0004a903          	lw	s2,0(s1)

        if (target_addr == 0)
    800037a8:	02091363          	bnez	s2,800037ce <bmap+0xc0>
        {
            target_addr = balloc(ip->dev);
    800037ac:	0009a503          	lw	a0,0(s3)
    800037b0:	00000097          	auipc	ra,0x0
    800037b4:	964080e7          	jalr	-1692(ra) # 80003114 <balloc>
    800037b8:	0005091b          	sext.w	s2,a0
            if (target_addr == 0)
    800037bc:	02090f63          	beqz	s2,800037fa <bmap+0xec>
                panic("bmap: balloc failed for data block via indirect");
            a[bn] = target_addr;
    800037c0:	0124a023          	sw	s2,0(s1)
            log_write(bp);
    800037c4:	8552                	mv	a0,s4
    800037c6:	00001097          	auipc	ra,0x1
    800037ca:	ce2080e7          	jalr	-798(ra) # 800044a8 <log_write>
        }
        brelse(bp);
    800037ce:	8552                	mv	a0,s4
    800037d0:	00000097          	auipc	ra,0x0
    800037d4:	82e080e7          	jalr	-2002(ra) # 80002ffe <brelse>
    }

    printf("bmap: ERROR! file_bn %d is out of range for inode %d\n",
           bn + NDIRECT, ip->inum);
    panic("bmap: out of range");
}
    800037d8:	854a                	mv	a0,s2
    800037da:	70a2                	ld	ra,40(sp)
    800037dc:	7402                	ld	s0,32(sp)
    800037de:	64e2                	ld	s1,24(sp)
    800037e0:	6942                	ld	s2,16(sp)
    800037e2:	69a2                	ld	s3,8(sp)
    800037e4:	6a02                	ld	s4,0(sp)
    800037e6:	6145                	addi	sp,sp,48
    800037e8:	8082                	ret
                panic("bmap: balloc failed for indirect block");
    800037ea:	00005517          	auipc	a0,0x5
    800037ee:	e1e50513          	addi	a0,a0,-482 # 80008608 <syscalls+0x1e0>
    800037f2:	ffffd097          	auipc	ra,0xffffd
    800037f6:	d50080e7          	jalr	-688(ra) # 80000542 <panic>
                panic("bmap: balloc failed for data block via indirect");
    800037fa:	00005517          	auipc	a0,0x5
    800037fe:	e3650513          	addi	a0,a0,-458 # 80008630 <syscalls+0x208>
    80003802:	ffffd097          	auipc	ra,0xffffd
    80003806:	d40080e7          	jalr	-704(ra) # 80000542 <panic>
    printf("bmap: ERROR! file_bn %d is out of range for inode %d\n",
    8000380a:	4150                	lw	a2,4(a0)
    8000380c:	00005517          	auipc	a0,0x5
    80003810:	e5450513          	addi	a0,a0,-428 # 80008660 <syscalls+0x238>
    80003814:	ffffd097          	auipc	ra,0xffffd
    80003818:	d78080e7          	jalr	-648(ra) # 8000058c <printf>
    panic("bmap: out of range");
    8000381c:	00005517          	auipc	a0,0x5
    80003820:	e7c50513          	addi	a0,a0,-388 # 80008698 <syscalls+0x270>
    80003824:	ffffd097          	auipc	ra,0xffffd
    80003828:	d1e080e7          	jalr	-738(ra) # 80000542 <panic>

000000008000382c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    8000382c:	7179                	addi	sp,sp,-48
    8000382e:	f406                	sd	ra,40(sp)
    80003830:	f022                	sd	s0,32(sp)
    80003832:	ec26                	sd	s1,24(sp)
    80003834:	e84a                	sd	s2,16(sp)
    80003836:	e44e                	sd	s3,8(sp)
    80003838:	e052                	sd	s4,0(sp)
    8000383a:	1800                	addi	s0,sp,48
    8000383c:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    8000383e:	05050493          	addi	s1,a0,80
    80003842:	08050913          	addi	s2,a0,128
    80003846:	a021                	j	8000384e <itrunc+0x22>
    80003848:	0491                	addi	s1,s1,4
    8000384a:	01248d63          	beq	s1,s2,80003864 <itrunc+0x38>
    {
        if (ip->addrs[i])
    8000384e:	408c                	lw	a1,0(s1)
    80003850:	dde5                	beqz	a1,80003848 <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    80003852:	0009a503          	lw	a0,0(s3)
    80003856:	00000097          	auipc	ra,0x0
    8000385a:	9f0080e7          	jalr	-1552(ra) # 80003246 <bfree>
            ip->addrs[i] = 0;
    8000385e:	0004a023          	sw	zero,0(s1)
    80003862:	b7dd                	j	80003848 <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80003864:	0809a583          	lw	a1,128(s3)
    80003868:	e185                	bnez	a1,80003888 <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    8000386a:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    8000386e:	854e                	mv	a0,s3
    80003870:	00000097          	auipc	ra,0x0
    80003874:	cc6080e7          	jalr	-826(ra) # 80003536 <iupdate>
}
    80003878:	70a2                	ld	ra,40(sp)
    8000387a:	7402                	ld	s0,32(sp)
    8000387c:	64e2                	ld	s1,24(sp)
    8000387e:	6942                	ld	s2,16(sp)
    80003880:	69a2                	ld	s3,8(sp)
    80003882:	6a02                	ld	s4,0(sp)
    80003884:	6145                	addi	sp,sp,48
    80003886:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003888:	0009a503          	lw	a0,0(s3)
    8000388c:	fffff097          	auipc	ra,0xfffff
    80003890:	6d6080e7          	jalr	1750(ra) # 80002f62 <bread>
    80003894:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80003896:	05850493          	addi	s1,a0,88
    8000389a:	45850913          	addi	s2,a0,1112
    8000389e:	a021                	j	800038a6 <itrunc+0x7a>
    800038a0:	0491                	addi	s1,s1,4
    800038a2:	01248b63          	beq	s1,s2,800038b8 <itrunc+0x8c>
            if (a[j])
    800038a6:	408c                	lw	a1,0(s1)
    800038a8:	dde5                	beqz	a1,800038a0 <itrunc+0x74>
                bfree(ip->dev, a[j]);
    800038aa:	0009a503          	lw	a0,0(s3)
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	998080e7          	jalr	-1640(ra) # 80003246 <bfree>
    800038b6:	b7ed                	j	800038a0 <itrunc+0x74>
        brelse(bp);
    800038b8:	8552                	mv	a0,s4
    800038ba:	fffff097          	auipc	ra,0xfffff
    800038be:	744080e7          	jalr	1860(ra) # 80002ffe <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    800038c2:	0809a583          	lw	a1,128(s3)
    800038c6:	0009a503          	lw	a0,0(s3)
    800038ca:	00000097          	auipc	ra,0x0
    800038ce:	97c080e7          	jalr	-1668(ra) # 80003246 <bfree>
        ip->addrs[NDIRECT] = 0;
    800038d2:	0809a023          	sw	zero,128(s3)
    800038d6:	bf51                	j	8000386a <itrunc+0x3e>

00000000800038d8 <iput>:
{
    800038d8:	1101                	addi	sp,sp,-32
    800038da:	ec06                	sd	ra,24(sp)
    800038dc:	e822                	sd	s0,16(sp)
    800038de:	e426                	sd	s1,8(sp)
    800038e0:	e04a                	sd	s2,0(sp)
    800038e2:	1000                	addi	s0,sp,32
    800038e4:	84aa                	mv	s1,a0
    acquire(&icache.lock);
    800038e6:	0001c517          	auipc	a0,0x1c
    800038ea:	57a50513          	addi	a0,a0,1402 # 8001fe60 <icache>
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	310080e7          	jalr	784(ra) # 80000bfe <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    800038f6:	4498                	lw	a4,8(s1)
    800038f8:	4785                	li	a5,1
    800038fa:	02f70363          	beq	a4,a5,80003920 <iput+0x48>
    ip->ref--;
    800038fe:	449c                	lw	a5,8(s1)
    80003900:	37fd                	addiw	a5,a5,-1
    80003902:	c49c                	sw	a5,8(s1)
    release(&icache.lock);
    80003904:	0001c517          	auipc	a0,0x1c
    80003908:	55c50513          	addi	a0,a0,1372 # 8001fe60 <icache>
    8000390c:	ffffd097          	auipc	ra,0xffffd
    80003910:	3a6080e7          	jalr	934(ra) # 80000cb2 <release>
}
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6902                	ld	s2,0(sp)
    8000391c:	6105                	addi	sp,sp,32
    8000391e:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80003920:	40bc                	lw	a5,64(s1)
    80003922:	dff1                	beqz	a5,800038fe <iput+0x26>
    80003924:	04a49783          	lh	a5,74(s1)
    80003928:	fbf9                	bnez	a5,800038fe <iput+0x26>
        acquiresleep(&ip->lock);
    8000392a:	01048913          	addi	s2,s1,16
    8000392e:	854a                	mv	a0,s2
    80003930:	00001097          	auipc	ra,0x1
    80003934:	ca0080e7          	jalr	-864(ra) # 800045d0 <acquiresleep>
        release(&icache.lock);
    80003938:	0001c517          	auipc	a0,0x1c
    8000393c:	52850513          	addi	a0,a0,1320 # 8001fe60 <icache>
    80003940:	ffffd097          	auipc	ra,0xffffd
    80003944:	372080e7          	jalr	882(ra) # 80000cb2 <release>
        itrunc(ip);
    80003948:	8526                	mv	a0,s1
    8000394a:	00000097          	auipc	ra,0x0
    8000394e:	ee2080e7          	jalr	-286(ra) # 8000382c <itrunc>
        ip->type = 0;
    80003952:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80003956:	8526                	mv	a0,s1
    80003958:	00000097          	auipc	ra,0x0
    8000395c:	bde080e7          	jalr	-1058(ra) # 80003536 <iupdate>
        ip->valid = 0;
    80003960:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80003964:	854a                	mv	a0,s2
    80003966:	00001097          	auipc	ra,0x1
    8000396a:	cc0080e7          	jalr	-832(ra) # 80004626 <releasesleep>
        acquire(&icache.lock);
    8000396e:	0001c517          	auipc	a0,0x1c
    80003972:	4f250513          	addi	a0,a0,1266 # 8001fe60 <icache>
    80003976:	ffffd097          	auipc	ra,0xffffd
    8000397a:	288080e7          	jalr	648(ra) # 80000bfe <acquire>
    8000397e:	b741                	j	800038fe <iput+0x26>

0000000080003980 <iunlockput>:
{
    80003980:	1101                	addi	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	1000                	addi	s0,sp,32
    8000398a:	84aa                	mv	s1,a0
    iunlock(ip);
    8000398c:	00000097          	auipc	ra,0x0
    80003990:	d36080e7          	jalr	-714(ra) # 800036c2 <iunlock>
    iput(ip);
    80003994:	8526                	mv	a0,s1
    80003996:	00000097          	auipc	ra,0x0
    8000399a:	f42080e7          	jalr	-190(ra) # 800038d8 <iput>
}
    8000399e:	60e2                	ld	ra,24(sp)
    800039a0:	6442                	ld	s0,16(sp)
    800039a2:	64a2                	ld	s1,8(sp)
    800039a4:	6105                	addi	sp,sp,32
    800039a6:	8082                	ret

00000000800039a8 <stati>:

/* TODO: Access Control & Symbolic Link */
// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    800039a8:	1141                	addi	sp,sp,-16
    800039aa:	e422                	sd	s0,8(sp)
    800039ac:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    800039ae:	411c                	lw	a5,0(a0)
    800039b0:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    800039b2:	415c                	lw	a5,4(a0)
    800039b4:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    800039b6:	04451783          	lh	a5,68(a0)
    800039ba:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    800039be:	04a51783          	lh	a5,74(a0)
    800039c2:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    800039c6:	04c56783          	lwu	a5,76(a0)
    800039ca:	e99c                	sd	a5,16(a1)
    //Loretta
    st->mode = ip->mode;
    800039cc:	08451783          	lh	a5,132(a0)
    800039d0:	00f59c23          	sh	a5,24(a1)
}
    800039d4:	6422                	ld	s0,8(sp)
    800039d6:	0141                	addi	sp,sp,16
    800039d8:	8082                	ret

00000000800039da <readi>:
{
    uint tot, m;
    struct buf *bp;


    if (off > ip->size || off + n < off)
    800039da:	457c                	lw	a5,76(a0)
    800039dc:	0ed7e863          	bltu	a5,a3,80003acc <readi+0xf2>
{
    800039e0:	7159                	addi	sp,sp,-112
    800039e2:	f486                	sd	ra,104(sp)
    800039e4:	f0a2                	sd	s0,96(sp)
    800039e6:	eca6                	sd	s1,88(sp)
    800039e8:	e8ca                	sd	s2,80(sp)
    800039ea:	e4ce                	sd	s3,72(sp)
    800039ec:	e0d2                	sd	s4,64(sp)
    800039ee:	fc56                	sd	s5,56(sp)
    800039f0:	f85a                	sd	s6,48(sp)
    800039f2:	f45e                	sd	s7,40(sp)
    800039f4:	f062                	sd	s8,32(sp)
    800039f6:	ec66                	sd	s9,24(sp)
    800039f8:	e86a                	sd	s10,16(sp)
    800039fa:	e46e                	sd	s11,8(sp)
    800039fc:	1880                	addi	s0,sp,112
    800039fe:	8baa                	mv	s7,a0
    80003a00:	8c2e                	mv	s8,a1
    80003a02:	8ab2                	mv	s5,a2
    80003a04:	84b6                	mv	s1,a3
    80003a06:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80003a08:	9f35                	addw	a4,a4,a3
        return 0;
    80003a0a:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80003a0c:	08d76f63          	bltu	a4,a3,80003aaa <readi+0xd0>
    if (off + n > ip->size)
    80003a10:	00e7f463          	bgeu	a5,a4,80003a18 <readi+0x3e>
        n = ip->size - off;
    80003a14:	40d78b3b          	subw	s6,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003a18:	0a0b0863          	beqz	s6,80003ac8 <readi+0xee>
    80003a1c:	4981                	li	s3,0
    {
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
        m = min(n - tot, BSIZE - off % BSIZE);
    80003a1e:	40000d13          	li	s10,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80003a22:	5cfd                	li	s9,-1
    80003a24:	a82d                	j	80003a5e <readi+0x84>
    80003a26:	020a1d93          	slli	s11,s4,0x20
    80003a2a:	020ddd93          	srli	s11,s11,0x20
    80003a2e:	05890793          	addi	a5,s2,88
    80003a32:	86ee                	mv	a3,s11
    80003a34:	963e                	add	a2,a2,a5
    80003a36:	85d6                	mv	a1,s5
    80003a38:	8562                	mv	a0,s8
    80003a3a:	fffff097          	auipc	ra,0xfffff
    80003a3e:	9fa080e7          	jalr	-1542(ra) # 80002434 <either_copyout>
    80003a42:	05950d63          	beq	a0,s9,80003a9c <readi+0xc2>
        {
            brelse(bp);
            break;
        }
        brelse(bp);
    80003a46:	854a                	mv	a0,s2
    80003a48:	fffff097          	auipc	ra,0xfffff
    80003a4c:	5b6080e7          	jalr	1462(ra) # 80002ffe <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003a50:	013a09bb          	addw	s3,s4,s3
    80003a54:	009a04bb          	addw	s1,s4,s1
    80003a58:	9aee                	add	s5,s5,s11
    80003a5a:	0569f663          	bgeu	s3,s6,80003aa6 <readi+0xcc>
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80003a5e:	000ba903          	lw	s2,0(s7)
    80003a62:	00a4d59b          	srliw	a1,s1,0xa
    80003a66:	855e                	mv	a0,s7
    80003a68:	00000097          	auipc	ra,0x0
    80003a6c:	ca6080e7          	jalr	-858(ra) # 8000370e <bmap>
    80003a70:	0005059b          	sext.w	a1,a0
    80003a74:	854a                	mv	a0,s2
    80003a76:	fffff097          	auipc	ra,0xfffff
    80003a7a:	4ec080e7          	jalr	1260(ra) # 80002f62 <bread>
    80003a7e:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003a80:	3ff4f613          	andi	a2,s1,1023
    80003a84:	40cd07bb          	subw	a5,s10,a2
    80003a88:	413b073b          	subw	a4,s6,s3
    80003a8c:	8a3e                	mv	s4,a5
    80003a8e:	2781                	sext.w	a5,a5
    80003a90:	0007069b          	sext.w	a3,a4
    80003a94:	f8f6f9e3          	bgeu	a3,a5,80003a26 <readi+0x4c>
    80003a98:	8a3a                	mv	s4,a4
    80003a9a:	b771                	j	80003a26 <readi+0x4c>
            brelse(bp);
    80003a9c:	854a                	mv	a0,s2
    80003a9e:	fffff097          	auipc	ra,0xfffff
    80003aa2:	560080e7          	jalr	1376(ra) # 80002ffe <brelse>
    }
    return tot;
    80003aa6:	0009851b          	sext.w	a0,s3
}
    80003aaa:	70a6                	ld	ra,104(sp)
    80003aac:	7406                	ld	s0,96(sp)
    80003aae:	64e6                	ld	s1,88(sp)
    80003ab0:	6946                	ld	s2,80(sp)
    80003ab2:	69a6                	ld	s3,72(sp)
    80003ab4:	6a06                	ld	s4,64(sp)
    80003ab6:	7ae2                	ld	s5,56(sp)
    80003ab8:	7b42                	ld	s6,48(sp)
    80003aba:	7ba2                	ld	s7,40(sp)
    80003abc:	7c02                	ld	s8,32(sp)
    80003abe:	6ce2                	ld	s9,24(sp)
    80003ac0:	6d42                	ld	s10,16(sp)
    80003ac2:	6da2                	ld	s11,8(sp)
    80003ac4:	6165                	addi	sp,sp,112
    80003ac6:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003ac8:	89da                	mv	s3,s6
    80003aca:	bff1                	j	80003aa6 <readi+0xcc>
        return 0;
    80003acc:	4501                	li	a0,0
}
    80003ace:	8082                	ret

0000000080003ad0 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80003ad0:	457c                	lw	a5,76(a0)
    80003ad2:	10d7e563          	bltu	a5,a3,80003bdc <writei+0x10c>
{
    80003ad6:	7159                	addi	sp,sp,-112
    80003ad8:	f486                	sd	ra,104(sp)
    80003ada:	f0a2                	sd	s0,96(sp)
    80003adc:	eca6                	sd	s1,88(sp)
    80003ade:	e8ca                	sd	s2,80(sp)
    80003ae0:	e4ce                	sd	s3,72(sp)
    80003ae2:	e0d2                	sd	s4,64(sp)
    80003ae4:	fc56                	sd	s5,56(sp)
    80003ae6:	f85a                	sd	s6,48(sp)
    80003ae8:	f45e                	sd	s7,40(sp)
    80003aea:	f062                	sd	s8,32(sp)
    80003aec:	ec66                	sd	s9,24(sp)
    80003aee:	e86a                	sd	s10,16(sp)
    80003af0:	e46e                	sd	s11,8(sp)
    80003af2:	1880                	addi	s0,sp,112
    80003af4:	8baa                	mv	s7,a0
    80003af6:	8c2e                	mv	s8,a1
    80003af8:	8ab2                	mv	s5,a2
    80003afa:	8936                	mv	s2,a3
    80003afc:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80003afe:	00e687bb          	addw	a5,a3,a4
    80003b02:	0cd7ef63          	bltu	a5,a3,80003be0 <writei+0x110>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80003b06:	00043737          	lui	a4,0x43
    80003b0a:	0cf76d63          	bltu	a4,a5,80003be4 <writei+0x114>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003b0e:	0a0b0663          	beqz	s6,80003bba <writei+0xea>
    80003b12:	4a01                	li	s4,0
    {
        uint bn = off / BSIZE;
        uint disk_lbn = bmap(ip, bn);
        bp = bread(ip->dev, disk_lbn);
        m = min(n - tot, BSIZE - off % BSIZE);
    80003b14:	40000d13          	li	s10,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80003b18:	5cfd                	li	s9,-1
    80003b1a:	a091                	j	80003b5e <writei+0x8e>
    80003b1c:	02099d93          	slli	s11,s3,0x20
    80003b20:	020ddd93          	srli	s11,s11,0x20
    80003b24:	05848793          	addi	a5,s1,88
    80003b28:	86ee                	mv	a3,s11
    80003b2a:	8656                	mv	a2,s5
    80003b2c:	85e2                	mv	a1,s8
    80003b2e:	953e                	add	a0,a0,a5
    80003b30:	fffff097          	auipc	ra,0xfffff
    80003b34:	95a080e7          	jalr	-1702(ra) # 8000248a <either_copyin>
    80003b38:	07950163          	beq	a0,s9,80003b9a <writei+0xca>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    80003b3c:	8526                	mv	a0,s1
    80003b3e:	00001097          	auipc	ra,0x1
    80003b42:	96a080e7          	jalr	-1686(ra) # 800044a8 <log_write>
        brelse(bp);
    80003b46:	8526                	mv	a0,s1
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	4b6080e7          	jalr	1206(ra) # 80002ffe <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003b50:	01498a3b          	addw	s4,s3,s4
    80003b54:	0129893b          	addw	s2,s3,s2
    80003b58:	9aee                	add	s5,s5,s11
    80003b5a:	056a7563          	bgeu	s4,s6,80003ba4 <writei+0xd4>
        uint disk_lbn = bmap(ip, bn);
    80003b5e:	00a9559b          	srliw	a1,s2,0xa
    80003b62:	855e                	mv	a0,s7
    80003b64:	00000097          	auipc	ra,0x0
    80003b68:	baa080e7          	jalr	-1110(ra) # 8000370e <bmap>
        bp = bread(ip->dev, disk_lbn);
    80003b6c:	0005059b          	sext.w	a1,a0
    80003b70:	000ba503          	lw	a0,0(s7)
    80003b74:	fffff097          	auipc	ra,0xfffff
    80003b78:	3ee080e7          	jalr	1006(ra) # 80002f62 <bread>
    80003b7c:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003b7e:	3ff97513          	andi	a0,s2,1023
    80003b82:	40ad07bb          	subw	a5,s10,a0
    80003b86:	414b073b          	subw	a4,s6,s4
    80003b8a:	89be                	mv	s3,a5
    80003b8c:	2781                	sext.w	a5,a5
    80003b8e:	0007069b          	sext.w	a3,a4
    80003b92:	f8f6f5e3          	bgeu	a3,a5,80003b1c <writei+0x4c>
    80003b96:	89ba                	mv	s3,a4
    80003b98:	b751                	j	80003b1c <writei+0x4c>
            brelse(bp);
    80003b9a:	8526                	mv	a0,s1
    80003b9c:	fffff097          	auipc	ra,0xfffff
    80003ba0:	462080e7          	jalr	1122(ra) # 80002ffe <brelse>
    }

    if (n > 0)
    {
        if (off > ip->size)
    80003ba4:	04cba783          	lw	a5,76(s7)
    80003ba8:	0127f463          	bgeu	a5,s2,80003bb0 <writei+0xe0>
            ip->size = off;
    80003bac:	052ba623          	sw	s2,76(s7)
        // write the i-node back to disk even if the size didn't change
        // because the loop above might have called bmap() and added a new
        // block to ip->addrs[].
        iupdate(ip);
    80003bb0:	855e                	mv	a0,s7
    80003bb2:	00000097          	auipc	ra,0x0
    80003bb6:	984080e7          	jalr	-1660(ra) # 80003536 <iupdate>
    }

    return n;
    80003bba:	000b051b          	sext.w	a0,s6
}
    80003bbe:	70a6                	ld	ra,104(sp)
    80003bc0:	7406                	ld	s0,96(sp)
    80003bc2:	64e6                	ld	s1,88(sp)
    80003bc4:	6946                	ld	s2,80(sp)
    80003bc6:	69a6                	ld	s3,72(sp)
    80003bc8:	6a06                	ld	s4,64(sp)
    80003bca:	7ae2                	ld	s5,56(sp)
    80003bcc:	7b42                	ld	s6,48(sp)
    80003bce:	7ba2                	ld	s7,40(sp)
    80003bd0:	7c02                	ld	s8,32(sp)
    80003bd2:	6ce2                	ld	s9,24(sp)
    80003bd4:	6d42                	ld	s10,16(sp)
    80003bd6:	6da2                	ld	s11,8(sp)
    80003bd8:	6165                	addi	sp,sp,112
    80003bda:	8082                	ret
        return -1;
    80003bdc:	557d                	li	a0,-1
}
    80003bde:	8082                	ret
        return -1;
    80003be0:	557d                	li	a0,-1
    80003be2:	bff1                	j	80003bbe <writei+0xee>
        return -1;
    80003be4:	557d                	li	a0,-1
    80003be6:	bfe1                	j	80003bbe <writei+0xee>

0000000080003be8 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    80003be8:	1141                	addi	sp,sp,-16
    80003bea:	e406                	sd	ra,8(sp)
    80003bec:	e022                	sd	s0,0(sp)
    80003bee:	0800                	addi	s0,sp,16
    80003bf0:	4639                	li	a2,14
    80003bf2:	ffffd097          	auipc	ra,0xffffd
    80003bf6:	1e0080e7          	jalr	480(ra) # 80000dd2 <strncmp>
    80003bfa:	60a2                	ld	ra,8(sp)
    80003bfc:	6402                	ld	s0,0(sp)
    80003bfe:	0141                	addi	sp,sp,16
    80003c00:	8082                	ret

0000000080003c02 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c02:	7139                	addi	sp,sp,-64
    80003c04:	fc06                	sd	ra,56(sp)
    80003c06:	f822                	sd	s0,48(sp)
    80003c08:	f426                	sd	s1,40(sp)
    80003c0a:	f04a                	sd	s2,32(sp)
    80003c0c:	ec4e                	sd	s3,24(sp)
    80003c0e:	e852                	sd	s4,16(sp)
    80003c10:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    80003c12:	04451703          	lh	a4,68(a0)
    80003c16:	4785                	li	a5,1
    80003c18:	00f71a63          	bne	a4,a5,80003c2c <dirlookup+0x2a>
    80003c1c:	892a                	mv	s2,a0
    80003c1e:	89ae                	mv	s3,a1
    80003c20:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    80003c22:	457c                	lw	a5,76(a0)
    80003c24:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    80003c26:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    80003c28:	e79d                	bnez	a5,80003c56 <dirlookup+0x54>
    80003c2a:	a8a5                	j	80003ca2 <dirlookup+0xa0>
        panic("dirlookup not DIR");
    80003c2c:	00005517          	auipc	a0,0x5
    80003c30:	a8450513          	addi	a0,a0,-1404 # 800086b0 <syscalls+0x288>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	90e080e7          	jalr	-1778(ra) # 80000542 <panic>
            panic("dirlookup read");
    80003c3c:	00005517          	auipc	a0,0x5
    80003c40:	a8c50513          	addi	a0,a0,-1396 # 800086c8 <syscalls+0x2a0>
    80003c44:	ffffd097          	auipc	ra,0xffffd
    80003c48:	8fe080e7          	jalr	-1794(ra) # 80000542 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003c4c:	24c1                	addiw	s1,s1,16
    80003c4e:	04c92783          	lw	a5,76(s2)
    80003c52:	04f4f763          	bgeu	s1,a5,80003ca0 <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c56:	4741                	li	a4,16
    80003c58:	86a6                	mv	a3,s1
    80003c5a:	fc040613          	addi	a2,s0,-64
    80003c5e:	4581                	li	a1,0
    80003c60:	854a                	mv	a0,s2
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	d78080e7          	jalr	-648(ra) # 800039da <readi>
    80003c6a:	47c1                	li	a5,16
    80003c6c:	fcf518e3          	bne	a0,a5,80003c3c <dirlookup+0x3a>
        if (de.inum == 0)
    80003c70:	fc045783          	lhu	a5,-64(s0)
    80003c74:	dfe1                	beqz	a5,80003c4c <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    80003c76:	fc240593          	addi	a1,s0,-62
    80003c7a:	854e                	mv	a0,s3
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	f6c080e7          	jalr	-148(ra) # 80003be8 <namecmp>
    80003c84:	f561                	bnez	a0,80003c4c <dirlookup+0x4a>
            if (poff)
    80003c86:	000a0463          	beqz	s4,80003c8e <dirlookup+0x8c>
                *poff = off;
    80003c8a:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    80003c8e:	fc045583          	lhu	a1,-64(s0)
    80003c92:	00092503          	lw	a0,0(s2)
    80003c96:	fffff097          	auipc	ra,0xfffff
    80003c9a:	62c080e7          	jalr	1580(ra) # 800032c2 <iget>
    80003c9e:	a011                	j	80003ca2 <dirlookup+0xa0>
    return 0;
    80003ca0:	4501                	li	a0,0
}
    80003ca2:	70e2                	ld	ra,56(sp)
    80003ca4:	7442                	ld	s0,48(sp)
    80003ca6:	74a2                	ld	s1,40(sp)
    80003ca8:	7902                	ld	s2,32(sp)
    80003caa:	69e2                	ld	s3,24(sp)
    80003cac:	6a42                	ld	s4,16(sp)
    80003cae:	6121                	addi	sp,sp,64
    80003cb0:	8082                	ret

0000000080003cb2 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name)
{
    80003cb2:	711d                	addi	sp,sp,-96
    80003cb4:	ec86                	sd	ra,88(sp)
    80003cb6:	e8a2                	sd	s0,80(sp)
    80003cb8:	e4a6                	sd	s1,72(sp)
    80003cba:	e0ca                	sd	s2,64(sp)
    80003cbc:	fc4e                	sd	s3,56(sp)
    80003cbe:	f852                	sd	s4,48(sp)
    80003cc0:	f456                	sd	s5,40(sp)
    80003cc2:	f05a                	sd	s6,32(sp)
    80003cc4:	ec5e                	sd	s7,24(sp)
    80003cc6:	e862                	sd	s8,16(sp)
    80003cc8:	e466                	sd	s9,8(sp)
    80003cca:	1080                	addi	s0,sp,96
    80003ccc:	84aa                	mv	s1,a0
    80003cce:	8aae                	mv	s5,a1
    80003cd0:	8a32                	mv	s4,a2
    struct inode *ip, *next;

    if (*path == '/')
    80003cd2:	00054703          	lbu	a4,0(a0)
    80003cd6:	02f00793          	li	a5,47
    80003cda:	02f70363          	beq	a4,a5,80003d00 <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    80003cde:	ffffe097          	auipc	ra,0xffffe
    80003ce2:	cec080e7          	jalr	-788(ra) # 800019ca <myproc>
    80003ce6:	15053503          	ld	a0,336(a0)
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	8d8080e7          	jalr	-1832(ra) # 800035c2 <idup>
    80003cf2:	89aa                	mv	s3,a0
    while (*path == '/')
    80003cf4:	02f00913          	li	s2,47
    len = path - s;
    80003cf8:	4b01                	li	s6,0
    if (len >= DIRSIZ)
    80003cfa:	4c35                	li	s8,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    80003cfc:	4b85                	li	s7,1
    80003cfe:	a865                	j	80003db6 <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    80003d00:	4585                	li	a1,1
    80003d02:	4505                	li	a0,1
    80003d04:	fffff097          	auipc	ra,0xfffff
    80003d08:	5be080e7          	jalr	1470(ra) # 800032c2 <iget>
    80003d0c:	89aa                	mv	s3,a0
    80003d0e:	b7dd                	j	80003cf4 <namex+0x42>
        {
            iunlockput(ip);
    80003d10:	854e                	mv	a0,s3
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	c6e080e7          	jalr	-914(ra) # 80003980 <iunlockput>
            return 0;
    80003d1a:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    80003d1c:	854e                	mv	a0,s3
    80003d1e:	60e6                	ld	ra,88(sp)
    80003d20:	6446                	ld	s0,80(sp)
    80003d22:	64a6                	ld	s1,72(sp)
    80003d24:	6906                	ld	s2,64(sp)
    80003d26:	79e2                	ld	s3,56(sp)
    80003d28:	7a42                	ld	s4,48(sp)
    80003d2a:	7aa2                	ld	s5,40(sp)
    80003d2c:	7b02                	ld	s6,32(sp)
    80003d2e:	6be2                	ld	s7,24(sp)
    80003d30:	6c42                	ld	s8,16(sp)
    80003d32:	6ca2                	ld	s9,8(sp)
    80003d34:	6125                	addi	sp,sp,96
    80003d36:	8082                	ret
            iunlock(ip);
    80003d38:	854e                	mv	a0,s3
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	988080e7          	jalr	-1656(ra) # 800036c2 <iunlock>
            return ip;
    80003d42:	bfe9                	j	80003d1c <namex+0x6a>
            iunlockput(ip);
    80003d44:	854e                	mv	a0,s3
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	c3a080e7          	jalr	-966(ra) # 80003980 <iunlockput>
            return 0;
    80003d4e:	89e6                	mv	s3,s9
    80003d50:	b7f1                	j	80003d1c <namex+0x6a>
    len = path - s;
    80003d52:	40b48633          	sub	a2,s1,a1
    80003d56:	00060c9b          	sext.w	s9,a2
    if (len >= DIRSIZ)
    80003d5a:	099c5463          	bge	s8,s9,80003de2 <namex+0x130>
        memmove(name, s, DIRSIZ);
    80003d5e:	4639                	li	a2,14
    80003d60:	8552                	mv	a0,s4
    80003d62:	ffffd097          	auipc	ra,0xffffd
    80003d66:	ff4080e7          	jalr	-12(ra) # 80000d56 <memmove>
    while (*path == '/')
    80003d6a:	0004c783          	lbu	a5,0(s1)
    80003d6e:	01279763          	bne	a5,s2,80003d7c <namex+0xca>
        path++;
    80003d72:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003d74:	0004c783          	lbu	a5,0(s1)
    80003d78:	ff278de3          	beq	a5,s2,80003d72 <namex+0xc0>
        ilock(ip);
    80003d7c:	854e                	mv	a0,s3
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	882080e7          	jalr	-1918(ra) # 80003600 <ilock>
        if (ip->type != T_DIR)
    80003d86:	04499783          	lh	a5,68(s3)
    80003d8a:	f97793e3          	bne	a5,s7,80003d10 <namex+0x5e>
        if (nameiparent && *path == '\0')
    80003d8e:	000a8563          	beqz	s5,80003d98 <namex+0xe6>
    80003d92:	0004c783          	lbu	a5,0(s1)
    80003d96:	d3cd                	beqz	a5,80003d38 <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    80003d98:	865a                	mv	a2,s6
    80003d9a:	85d2                	mv	a1,s4
    80003d9c:	854e                	mv	a0,s3
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	e64080e7          	jalr	-412(ra) # 80003c02 <dirlookup>
    80003da6:	8caa                	mv	s9,a0
    80003da8:	dd51                	beqz	a0,80003d44 <namex+0x92>
        iunlockput(ip);
    80003daa:	854e                	mv	a0,s3
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	bd4080e7          	jalr	-1068(ra) # 80003980 <iunlockput>
        ip = next;
    80003db4:	89e6                	mv	s3,s9
    while (*path == '/')
    80003db6:	0004c783          	lbu	a5,0(s1)
    80003dba:	05279763          	bne	a5,s2,80003e08 <namex+0x156>
        path++;
    80003dbe:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003dc0:	0004c783          	lbu	a5,0(s1)
    80003dc4:	ff278de3          	beq	a5,s2,80003dbe <namex+0x10c>
    if (*path == 0)
    80003dc8:	c79d                	beqz	a5,80003df6 <namex+0x144>
        path++;
    80003dca:	85a6                	mv	a1,s1
    len = path - s;
    80003dcc:	8cda                	mv	s9,s6
    80003dce:	865a                	mv	a2,s6
    while (*path != '/' && *path != 0)
    80003dd0:	01278963          	beq	a5,s2,80003de2 <namex+0x130>
    80003dd4:	dfbd                	beqz	a5,80003d52 <namex+0xa0>
        path++;
    80003dd6:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    80003dd8:	0004c783          	lbu	a5,0(s1)
    80003ddc:	ff279ce3          	bne	a5,s2,80003dd4 <namex+0x122>
    80003de0:	bf8d                	j	80003d52 <namex+0xa0>
        memmove(name, s, len);
    80003de2:	2601                	sext.w	a2,a2
    80003de4:	8552                	mv	a0,s4
    80003de6:	ffffd097          	auipc	ra,0xffffd
    80003dea:	f70080e7          	jalr	-144(ra) # 80000d56 <memmove>
        name[len] = 0;
    80003dee:	9cd2                	add	s9,s9,s4
    80003df0:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003df4:	bf9d                	j	80003d6a <namex+0xb8>
    if (nameiparent)
    80003df6:	f20a83e3          	beqz	s5,80003d1c <namex+0x6a>
        iput(ip);
    80003dfa:	854e                	mv	a0,s3
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	adc080e7          	jalr	-1316(ra) # 800038d8 <iput>
        return 0;
    80003e04:	4981                	li	s3,0
    80003e06:	bf19                	j	80003d1c <namex+0x6a>
    if (*path == 0)
    80003e08:	d7fd                	beqz	a5,80003df6 <namex+0x144>
    while (*path != '/' && *path != 0)
    80003e0a:	0004c783          	lbu	a5,0(s1)
    80003e0e:	85a6                	mv	a1,s1
    80003e10:	b7d1                	j	80003dd4 <namex+0x122>

0000000080003e12 <dirlink>:
{
    80003e12:	7139                	addi	sp,sp,-64
    80003e14:	fc06                	sd	ra,56(sp)
    80003e16:	f822                	sd	s0,48(sp)
    80003e18:	f426                	sd	s1,40(sp)
    80003e1a:	f04a                	sd	s2,32(sp)
    80003e1c:	ec4e                	sd	s3,24(sp)
    80003e1e:	e852                	sd	s4,16(sp)
    80003e20:	0080                	addi	s0,sp,64
    80003e22:	892a                	mv	s2,a0
    80003e24:	8a2e                	mv	s4,a1
    80003e26:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    80003e28:	4601                	li	a2,0
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	dd8080e7          	jalr	-552(ra) # 80003c02 <dirlookup>
    80003e32:	e93d                	bnez	a0,80003ea8 <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003e34:	04c92483          	lw	s1,76(s2)
    80003e38:	c49d                	beqz	s1,80003e66 <dirlink+0x54>
    80003e3a:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e3c:	4741                	li	a4,16
    80003e3e:	86a6                	mv	a3,s1
    80003e40:	fc040613          	addi	a2,s0,-64
    80003e44:	4581                	li	a1,0
    80003e46:	854a                	mv	a0,s2
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	b92080e7          	jalr	-1134(ra) # 800039da <readi>
    80003e50:	47c1                	li	a5,16
    80003e52:	06f51163          	bne	a0,a5,80003eb4 <dirlink+0xa2>
        if (de.inum == 0)
    80003e56:	fc045783          	lhu	a5,-64(s0)
    80003e5a:	c791                	beqz	a5,80003e66 <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003e5c:	24c1                	addiw	s1,s1,16
    80003e5e:	04c92783          	lw	a5,76(s2)
    80003e62:	fcf4ede3          	bltu	s1,a5,80003e3c <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    80003e66:	4639                	li	a2,14
    80003e68:	85d2                	mv	a1,s4
    80003e6a:	fc240513          	addi	a0,s0,-62
    80003e6e:	ffffd097          	auipc	ra,0xffffd
    80003e72:	fa0080e7          	jalr	-96(ra) # 80000e0e <strncpy>
    de.inum = inum;
    80003e76:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e7a:	4741                	li	a4,16
    80003e7c:	86a6                	mv	a3,s1
    80003e7e:	fc040613          	addi	a2,s0,-64
    80003e82:	4581                	li	a1,0
    80003e84:	854a                	mv	a0,s2
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	c4a080e7          	jalr	-950(ra) # 80003ad0 <writei>
    80003e8e:	872a                	mv	a4,a0
    80003e90:	47c1                	li	a5,16
    return 0;
    80003e92:	4501                	li	a0,0
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e94:	02f71863          	bne	a4,a5,80003ec4 <dirlink+0xb2>
}
    80003e98:	70e2                	ld	ra,56(sp)
    80003e9a:	7442                	ld	s0,48(sp)
    80003e9c:	74a2                	ld	s1,40(sp)
    80003e9e:	7902                	ld	s2,32(sp)
    80003ea0:	69e2                	ld	s3,24(sp)
    80003ea2:	6a42                	ld	s4,16(sp)
    80003ea4:	6121                	addi	sp,sp,64
    80003ea6:	8082                	ret
        iput(ip);
    80003ea8:	00000097          	auipc	ra,0x0
    80003eac:	a30080e7          	jalr	-1488(ra) # 800038d8 <iput>
        return -1;
    80003eb0:	557d                	li	a0,-1
    80003eb2:	b7dd                	j	80003e98 <dirlink+0x86>
            panic("dirlink read");
    80003eb4:	00005517          	auipc	a0,0x5
    80003eb8:	82450513          	addi	a0,a0,-2012 # 800086d8 <syscalls+0x2b0>
    80003ebc:	ffffc097          	auipc	ra,0xffffc
    80003ec0:	686080e7          	jalr	1670(ra) # 80000542 <panic>
        panic("dirlink");
    80003ec4:	00005517          	auipc	a0,0x5
    80003ec8:	9ac50513          	addi	a0,a0,-1620 # 80008870 <syscalls+0x448>
    80003ecc:	ffffc097          	auipc	ra,0xffffc
    80003ed0:	676080e7          	jalr	1654(ra) # 80000542 <panic>

0000000080003ed4 <namei>:

struct inode *namei(char *path)
{
    80003ed4:	1101                	addi	sp,sp,-32
    80003ed6:	ec06                	sd	ra,24(sp)
    80003ed8:	e822                	sd	s0,16(sp)
    80003eda:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    80003edc:	fe040613          	addi	a2,s0,-32
    80003ee0:	4581                	li	a1,0
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	dd0080e7          	jalr	-560(ra) # 80003cb2 <namex>
}
    80003eea:	60e2                	ld	ra,24(sp)
    80003eec:	6442                	ld	s0,16(sp)
    80003eee:	6105                	addi	sp,sp,32
    80003ef0:	8082                	ret

0000000080003ef2 <chperm>:
{
    80003ef2:	7151                	addi	sp,sp,-240
    80003ef4:	f586                	sd	ra,232(sp)
    80003ef6:	f1a2                	sd	s0,224(sp)
    80003ef8:	eda6                	sd	s1,216(sp)
    80003efa:	e9ca                	sd	s2,208(sp)
    80003efc:	e5ce                	sd	s3,200(sp)
    80003efe:	e1d2                	sd	s4,192(sp)
    80003f00:	fd56                	sd	s5,184(sp)
    80003f02:	f95a                	sd	s6,176(sp)
    80003f04:	f55e                	sd	s7,168(sp)
    80003f06:	f162                	sd	s8,160(sp)
    80003f08:	ed66                	sd	s9,152(sp)
    80003f0a:	e96a                	sd	s10,144(sp)
    80003f0c:	1980                	addi	s0,sp,240
    80003f0e:	892a                	mv	s2,a0
    80003f10:	8aae                	mv	s5,a1
    80003f12:	89b2                	mv	s3,a2
    80003f14:	8a36                	mv	s4,a3
    printf("Loretta:");
    80003f16:	00004517          	auipc	a0,0x4
    80003f1a:	7d250513          	addi	a0,a0,2002 # 800086e8 <syscalls+0x2c0>
    80003f1e:	ffffc097          	auipc	ra,0xffffc
    80003f22:	66e080e7          	jalr	1646(ra) # 8000058c <printf>
    printf("chperm: path = %s, mode = %d, is_add = %d, recursive = %d\n", path, mode, is_add, recursive);
    80003f26:	8752                	mv	a4,s4
    80003f28:	86ce                	mv	a3,s3
    80003f2a:	8656                	mv	a2,s5
    80003f2c:	85ca                	mv	a1,s2
    80003f2e:	00004517          	auipc	a0,0x4
    80003f32:	7ca50513          	addi	a0,a0,1994 # 800086f8 <syscalls+0x2d0>
    80003f36:	ffffc097          	auipc	ra,0xffffc
    80003f3a:	656080e7          	jalr	1622(ra) # 8000058c <printf>
    begin_op();
    80003f3e:	00000097          	auipc	ra,0x0
    80003f42:	394080e7          	jalr	916(ra) # 800042d2 <begin_op>
    if ((ip = namei(path)) == 0) {
    80003f46:	854a                	mv	a0,s2
    80003f48:	00000097          	auipc	ra,0x0
    80003f4c:	f8c080e7          	jalr	-116(ra) # 80003ed4 <namei>
    80003f50:	c535                	beqz	a0,80003fbc <chperm+0xca>
    80003f52:	84aa                	mv	s1,a0
    ilock(ip);
    80003f54:	fffff097          	auipc	ra,0xfffff
    80003f58:	6ac080e7          	jalr	1708(ra) # 80003600 <ilock>
    if (is_add)
    80003f5c:	06098f63          	beqz	s3,80003fda <chperm+0xe8>
        ip->perm |= mode;
    80003f60:	0864d783          	lhu	a5,134(s1)
    80003f64:	00fae7b3          	or	a5,s5,a5
    80003f68:	0107979b          	slliw	a5,a5,0x10
    80003f6c:	4107d79b          	sraiw	a5,a5,0x10
    80003f70:	08f49323          	sh	a5,134(s1)
    iupdate(ip);
    80003f74:	8526                	mv	a0,s1
    80003f76:	fffff097          	auipc	ra,0xfffff
    80003f7a:	5c0080e7          	jalr	1472(ra) # 80003536 <iupdate>
    if (recursive && ip->type == T_DIR) {
    80003f7e:	000a0763          	beqz	s4,80003f8c <chperm+0x9a>
    80003f82:	04449703          	lh	a4,68(s1)
    80003f86:	4785                	li	a5,1
    80003f88:	06f70363          	beq	a4,a5,80003fee <chperm+0xfc>
    iunlockput(ip);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	00000097          	auipc	ra,0x0
    80003f92:	9f2080e7          	jalr	-1550(ra) # 80003980 <iunlockput>
    end_op();
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	3bc080e7          	jalr	956(ra) # 80004352 <end_op>
    return 0;
    80003f9e:	4501                	li	a0,0
}
    80003fa0:	70ae                	ld	ra,232(sp)
    80003fa2:	740e                	ld	s0,224(sp)
    80003fa4:	64ee                	ld	s1,216(sp)
    80003fa6:	694e                	ld	s2,208(sp)
    80003fa8:	69ae                	ld	s3,200(sp)
    80003faa:	6a0e                	ld	s4,192(sp)
    80003fac:	7aea                	ld	s5,184(sp)
    80003fae:	7b4a                	ld	s6,176(sp)
    80003fb0:	7baa                	ld	s7,168(sp)
    80003fb2:	7c0a                	ld	s8,160(sp)
    80003fb4:	6cea                	ld	s9,152(sp)
    80003fb6:	6d4a                	ld	s10,144(sp)
    80003fb8:	616d                	addi	sp,sp,240
    80003fba:	8082                	ret
        printf("chperm: namei failed for path = %s\n", path);
    80003fbc:	85ca                	mv	a1,s2
    80003fbe:	00004517          	auipc	a0,0x4
    80003fc2:	77a50513          	addi	a0,a0,1914 # 80008738 <syscalls+0x310>
    80003fc6:	ffffc097          	auipc	ra,0xffffc
    80003fca:	5c6080e7          	jalr	1478(ra) # 8000058c <printf>
        end_op();
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	384080e7          	jalr	900(ra) # 80004352 <end_op>
        return -1;
    80003fd6:	557d                	li	a0,-1
    80003fd8:	b7e1                	j	80003fa0 <chperm+0xae>
        ip->perm &= ~mode;
    80003fda:	fffac793          	not	a5,s5
    80003fde:	0864d703          	lhu	a4,134(s1)
    80003fe2:	8ff9                	and	a5,a5,a4
    80003fe4:	0107979b          	slliw	a5,a5,0x10
    80003fe8:	4107d79b          	sraiw	a5,a5,0x10
    80003fec:	b751                	j	80003f70 <chperm+0x7e>
        for (int off = 0; off < ip->size; off += sizeof(de)) {
    80003fee:	44fc                	lw	a5,76(s1)
    80003ff0:	dfd1                	beqz	a5,80003f8c <chperm+0x9a>
    80003ff2:	4b01                	li	s6,0
            if (de.inum == 0 || strncmp(de.name, ".", DIRSIZ) == 0 || strncmp(de.name, "..", DIRSIZ) == 0
    80003ff4:	00004b97          	auipc	s7,0x4
    80003ff8:	76cb8b93          	addi	s7,s7,1900 # 80008760 <syscalls+0x338>
    80003ffc:	00004c17          	auipc	s8,0x4
    80004000:	76cc0c13          	addi	s8,s8,1900 # 80008768 <syscalls+0x340>
            if (child_path[len - 1] != '/')
    80004004:	02f00c93          	li	s9,47
            safestrcpy(child_path + len, de.name, sizeof(child_path) - len);
    80004008:	08000d13          	li	s10,128
    8000400c:	a099                	j	80004052 <chperm+0x160>
    8000400e:	40ad063b          	subw	a2,s10,a0
    80004012:	f1240593          	addi	a1,s0,-238
    80004016:	f2040793          	addi	a5,s0,-224
    8000401a:	953e                	add	a0,a0,a5
    8000401c:	ffffd097          	auipc	ra,0xffffd
    80004020:	e30080e7          	jalr	-464(ra) # 80000e4c <safestrcpy>
            iunlock(ip);
    80004024:	8526                	mv	a0,s1
    80004026:	fffff097          	auipc	ra,0xfffff
    8000402a:	69c080e7          	jalr	1692(ra) # 800036c2 <iunlock>
            chperm(child_path, mode, is_add, recursive);
    8000402e:	86d2                	mv	a3,s4
    80004030:	864e                	mv	a2,s3
    80004032:	85d6                	mv	a1,s5
    80004034:	f2040513          	addi	a0,s0,-224
    80004038:	00000097          	auipc	ra,0x0
    8000403c:	eba080e7          	jalr	-326(ra) # 80003ef2 <chperm>
            ilock(ip);
    80004040:	8526                	mv	a0,s1
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	5be080e7          	jalr	1470(ra) # 80003600 <ilock>
        for (int off = 0; off < ip->size; off += sizeof(de)) {
    8000404a:	2b41                	addiw	s6,s6,16
    8000404c:	44fc                	lw	a5,76(s1)
    8000404e:	f2fb7fe3          	bgeu	s6,a5,80003f8c <chperm+0x9a>
            if (readi(ip, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004052:	4741                	li	a4,16
    80004054:	86da                	mv	a3,s6
    80004056:	f1040613          	addi	a2,s0,-240
    8000405a:	4581                	li	a1,0
    8000405c:	8526                	mv	a0,s1
    8000405e:	00000097          	auipc	ra,0x0
    80004062:	97c080e7          	jalr	-1668(ra) # 800039da <readi>
    80004066:	47c1                	li	a5,16
    80004068:	fef511e3          	bne	a0,a5,8000404a <chperm+0x158>
            if (de.inum == 0 || strncmp(de.name, ".", DIRSIZ) == 0 || strncmp(de.name, "..", DIRSIZ) == 0
    8000406c:	f1045783          	lhu	a5,-240(s0)
    80004070:	dfe9                	beqz	a5,8000404a <chperm+0x158>
    80004072:	4639                	li	a2,14
    80004074:	85de                	mv	a1,s7
    80004076:	f1240513          	addi	a0,s0,-238
    8000407a:	ffffd097          	auipc	ra,0xffffd
    8000407e:	d58080e7          	jalr	-680(ra) # 80000dd2 <strncmp>
    80004082:	d561                	beqz	a0,8000404a <chperm+0x158>
    80004084:	4639                	li	a2,14
    80004086:	85e2                	mv	a1,s8
    80004088:	f1240513          	addi	a0,s0,-238
    8000408c:	ffffd097          	auipc	ra,0xffffd
    80004090:	d46080e7          	jalr	-698(ra) # 80000dd2 <strncmp>
    80004094:	d95d                	beqz	a0,8000404a <chperm+0x158>
            memset(child_path, 0, sizeof(child_path));
    80004096:	08000613          	li	a2,128
    8000409a:	4581                	li	a1,0
    8000409c:	f2040513          	addi	a0,s0,-224
    800040a0:	ffffd097          	auipc	ra,0xffffd
    800040a4:	c5a080e7          	jalr	-934(ra) # 80000cfa <memset>
            safestrcpy(child_path, path, sizeof(child_path));
    800040a8:	08000613          	li	a2,128
    800040ac:	85ca                	mv	a1,s2
    800040ae:	f2040513          	addi	a0,s0,-224
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	d9a080e7          	jalr	-614(ra) # 80000e4c <safestrcpy>
            int len = strlen(child_path);
    800040ba:	f2040513          	addi	a0,s0,-224
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	dc0080e7          	jalr	-576(ra) # 80000e7e <strlen>
            if (child_path[len - 1] != '/')
    800040c6:	fff5079b          	addiw	a5,a0,-1
    800040ca:	fa040713          	addi	a4,s0,-96
    800040ce:	97ba                	add	a5,a5,a4
    800040d0:	f807c783          	lbu	a5,-128(a5)
    800040d4:	f3978de3          	beq	a5,s9,8000400e <chperm+0x11c>
                child_path[len++] = '/';
    800040d8:	00a707b3          	add	a5,a4,a0
    800040dc:	f9978023          	sb	s9,-128(a5)
    800040e0:	2505                	addiw	a0,a0,1
    800040e2:	b735                	j	8000400e <chperm+0x11c>

00000000800040e4 <nameiparent>:

struct inode *nameiparent(char *path, char *name)
{
    800040e4:	1141                	addi	sp,sp,-16
    800040e6:	e406                	sd	ra,8(sp)
    800040e8:	e022                	sd	s0,0(sp)
    800040ea:	0800                	addi	s0,sp,16
    800040ec:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800040ee:	4585                	li	a1,1
    800040f0:	00000097          	auipc	ra,0x0
    800040f4:	bc2080e7          	jalr	-1086(ra) # 80003cb2 <namex>
}
    800040f8:	60a2                	ld	ra,8(sp)
    800040fa:	6402                	ld	s0,0(sp)
    800040fc:	0141                	addi	sp,sp,16
    800040fe:	8082                	ret

0000000080004100 <write_head>:

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void)
{
    80004100:	1101                	addi	sp,sp,-32
    80004102:	ec06                	sd	ra,24(sp)
    80004104:	e822                	sd	s0,16(sp)
    80004106:	e426                	sd	s1,8(sp)
    80004108:	e04a                	sd	s2,0(sp)
    8000410a:	1000                	addi	s0,sp,32
    struct buf *buf = bread(log.dev, log.start);
    8000410c:	0001d917          	auipc	s2,0x1d
    80004110:	7fc90913          	addi	s2,s2,2044 # 80021908 <log>
    80004114:	01892583          	lw	a1,24(s2)
    80004118:	02892503          	lw	a0,40(s2)
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	e46080e7          	jalr	-442(ra) # 80002f62 <bread>
    80004124:	84aa                	mv	s1,a0
    struct logheader *hb = (struct logheader *)(buf->data);
    int i;
    hb->n = log.lh.n;
    80004126:	02c92683          	lw	a3,44(s2)
    8000412a:	cd34                	sw	a3,88(a0)
    for (i = 0; i < log.lh.n; i++)
    8000412c:	02d05763          	blez	a3,8000415a <write_head+0x5a>
    80004130:	0001e797          	auipc	a5,0x1e
    80004134:	80878793          	addi	a5,a5,-2040 # 80021938 <log+0x30>
    80004138:	05c50713          	addi	a4,a0,92
    8000413c:	36fd                	addiw	a3,a3,-1
    8000413e:	1682                	slli	a3,a3,0x20
    80004140:	9281                	srli	a3,a3,0x20
    80004142:	068a                	slli	a3,a3,0x2
    80004144:	0001d617          	auipc	a2,0x1d
    80004148:	7f860613          	addi	a2,a2,2040 # 8002193c <log+0x34>
    8000414c:	96b2                	add	a3,a3,a2
    {
        hb->block[i] = log.lh.block[i];
    8000414e:	4390                	lw	a2,0(a5)
    80004150:	c310                	sw	a2,0(a4)
    for (i = 0; i < log.lh.n; i++)
    80004152:	0791                	addi	a5,a5,4
    80004154:	0711                	addi	a4,a4,4
    80004156:	fed79ce3          	bne	a5,a3,8000414e <write_head+0x4e>
    }
    bwrite(buf);
    8000415a:	8526                	mv	a0,s1
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	e64080e7          	jalr	-412(ra) # 80002fc0 <bwrite>
    brelse(buf);
    80004164:	8526                	mv	a0,s1
    80004166:	fffff097          	auipc	ra,0xfffff
    8000416a:	e98080e7          	jalr	-360(ra) # 80002ffe <brelse>
}
    8000416e:	60e2                	ld	ra,24(sp)
    80004170:	6442                	ld	s0,16(sp)
    80004172:	64a2                	ld	s1,8(sp)
    80004174:	6902                	ld	s2,0(sp)
    80004176:	6105                	addi	sp,sp,32
    80004178:	8082                	ret

000000008000417a <install_trans>:
    for (tail = 0; tail < log.lh.n; tail++)
    8000417a:	0001d797          	auipc	a5,0x1d
    8000417e:	7ba7a783          	lw	a5,1978(a5) # 80021934 <log+0x2c>
    80004182:	0af05663          	blez	a5,8000422e <install_trans+0xb4>
{
    80004186:	7139                	addi	sp,sp,-64
    80004188:	fc06                	sd	ra,56(sp)
    8000418a:	f822                	sd	s0,48(sp)
    8000418c:	f426                	sd	s1,40(sp)
    8000418e:	f04a                	sd	s2,32(sp)
    80004190:	ec4e                	sd	s3,24(sp)
    80004192:	e852                	sd	s4,16(sp)
    80004194:	e456                	sd	s5,8(sp)
    80004196:	0080                	addi	s0,sp,64
    80004198:	0001da97          	auipc	s5,0x1d
    8000419c:	7a0a8a93          	addi	s5,s5,1952 # 80021938 <log+0x30>
    for (tail = 0; tail < log.lh.n; tail++)
    800041a0:	4a01                	li	s4,0
            bread(log.dev, log.start + tail + 1);              // read log block
    800041a2:	0001d997          	auipc	s3,0x1d
    800041a6:	76698993          	addi	s3,s3,1894 # 80021908 <log>
    800041aa:	0189a583          	lw	a1,24(s3)
    800041ae:	014585bb          	addw	a1,a1,s4
    800041b2:	2585                	addiw	a1,a1,1
    800041b4:	0289a503          	lw	a0,40(s3)
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	daa080e7          	jalr	-598(ra) # 80002f62 <bread>
    800041c0:	892a                	mv	s2,a0
        struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800041c2:	000aa583          	lw	a1,0(s5)
    800041c6:	0289a503          	lw	a0,40(s3)
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	d98080e7          	jalr	-616(ra) # 80002f62 <bread>
    800041d2:	84aa                	mv	s1,a0
        memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    800041d4:	40000613          	li	a2,1024
    800041d8:	05890593          	addi	a1,s2,88
    800041dc:	05850513          	addi	a0,a0,88
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	b76080e7          	jalr	-1162(ra) # 80000d56 <memmove>
        bwrite(dbuf);                           // write dst to disk
    800041e8:	8526                	mv	a0,s1
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	dd6080e7          	jalr	-554(ra) # 80002fc0 <bwrite>
        bunpin(dbuf);
    800041f2:	8526                	mv	a0,s1
    800041f4:	fffff097          	auipc	ra,0xfffff
    800041f8:	ee4080e7          	jalr	-284(ra) # 800030d8 <bunpin>
        brelse(lbuf);
    800041fc:	854a                	mv	a0,s2
    800041fe:	fffff097          	auipc	ra,0xfffff
    80004202:	e00080e7          	jalr	-512(ra) # 80002ffe <brelse>
        brelse(dbuf);
    80004206:	8526                	mv	a0,s1
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	df6080e7          	jalr	-522(ra) # 80002ffe <brelse>
    for (tail = 0; tail < log.lh.n; tail++)
    80004210:	2a05                	addiw	s4,s4,1
    80004212:	0a91                	addi	s5,s5,4
    80004214:	02c9a783          	lw	a5,44(s3)
    80004218:	f8fa49e3          	blt	s4,a5,800041aa <install_trans+0x30>
}
    8000421c:	70e2                	ld	ra,56(sp)
    8000421e:	7442                	ld	s0,48(sp)
    80004220:	74a2                	ld	s1,40(sp)
    80004222:	7902                	ld	s2,32(sp)
    80004224:	69e2                	ld	s3,24(sp)
    80004226:	6a42                	ld	s4,16(sp)
    80004228:	6aa2                	ld	s5,8(sp)
    8000422a:	6121                	addi	sp,sp,64
    8000422c:	8082                	ret
    8000422e:	8082                	ret

0000000080004230 <initlog>:
{
    80004230:	7179                	addi	sp,sp,-48
    80004232:	f406                	sd	ra,40(sp)
    80004234:	f022                	sd	s0,32(sp)
    80004236:	ec26                	sd	s1,24(sp)
    80004238:	e84a                	sd	s2,16(sp)
    8000423a:	e44e                	sd	s3,8(sp)
    8000423c:	1800                	addi	s0,sp,48
    8000423e:	892a                	mv	s2,a0
    80004240:	89ae                	mv	s3,a1
    initlock(&log.lock, "log");
    80004242:	0001d497          	auipc	s1,0x1d
    80004246:	6c648493          	addi	s1,s1,1734 # 80021908 <log>
    8000424a:	00004597          	auipc	a1,0x4
    8000424e:	52658593          	addi	a1,a1,1318 # 80008770 <syscalls+0x348>
    80004252:	8526                	mv	a0,s1
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	91a080e7          	jalr	-1766(ra) # 80000b6e <initlock>
    log.start = sb->logstart;
    8000425c:	0149a583          	lw	a1,20(s3)
    80004260:	cc8c                	sw	a1,24(s1)
    log.size = sb->nlog;
    80004262:	0109a783          	lw	a5,16(s3)
    80004266:	ccdc                	sw	a5,28(s1)
    log.dev = dev;
    80004268:	0324a423          	sw	s2,40(s1)
    struct buf *buf = bread(log.dev, log.start);
    8000426c:	854a                	mv	a0,s2
    8000426e:	fffff097          	auipc	ra,0xfffff
    80004272:	cf4080e7          	jalr	-780(ra) # 80002f62 <bread>
    log.lh.n = lh->n;
    80004276:	4d34                	lw	a3,88(a0)
    80004278:	d4d4                	sw	a3,44(s1)
    for (i = 0; i < log.lh.n; i++)
    8000427a:	02d05563          	blez	a3,800042a4 <initlog+0x74>
    8000427e:	05c50793          	addi	a5,a0,92
    80004282:	0001d717          	auipc	a4,0x1d
    80004286:	6b670713          	addi	a4,a4,1718 # 80021938 <log+0x30>
    8000428a:	36fd                	addiw	a3,a3,-1
    8000428c:	1682                	slli	a3,a3,0x20
    8000428e:	9281                	srli	a3,a3,0x20
    80004290:	068a                	slli	a3,a3,0x2
    80004292:	06050613          	addi	a2,a0,96
    80004296:	96b2                	add	a3,a3,a2
        log.lh.block[i] = lh->block[i];
    80004298:	4390                	lw	a2,0(a5)
    8000429a:	c310                	sw	a2,0(a4)
    for (i = 0; i < log.lh.n; i++)
    8000429c:	0791                	addi	a5,a5,4
    8000429e:	0711                	addi	a4,a4,4
    800042a0:	fed79ce3          	bne	a5,a3,80004298 <initlog+0x68>
    brelse(buf);
    800042a4:	fffff097          	auipc	ra,0xfffff
    800042a8:	d5a080e7          	jalr	-678(ra) # 80002ffe <brelse>

static void recover_from_log(void)
{
    read_head();
    install_trans(); // if committed, copy from log to disk
    800042ac:	00000097          	auipc	ra,0x0
    800042b0:	ece080e7          	jalr	-306(ra) # 8000417a <install_trans>
    log.lh.n = 0;
    800042b4:	0001d797          	auipc	a5,0x1d
    800042b8:	6807a023          	sw	zero,1664(a5) # 80021934 <log+0x2c>
    write_head(); // clear the log
    800042bc:	00000097          	auipc	ra,0x0
    800042c0:	e44080e7          	jalr	-444(ra) # 80004100 <write_head>
}
    800042c4:	70a2                	ld	ra,40(sp)
    800042c6:	7402                	ld	s0,32(sp)
    800042c8:	64e2                	ld	s1,24(sp)
    800042ca:	6942                	ld	s2,16(sp)
    800042cc:	69a2                	ld	s3,8(sp)
    800042ce:	6145                	addi	sp,sp,48
    800042d0:	8082                	ret

00000000800042d2 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void)
{
    800042d2:	1101                	addi	sp,sp,-32
    800042d4:	ec06                	sd	ra,24(sp)
    800042d6:	e822                	sd	s0,16(sp)
    800042d8:	e426                	sd	s1,8(sp)
    800042da:	e04a                	sd	s2,0(sp)
    800042dc:	1000                	addi	s0,sp,32
    acquire(&log.lock);
    800042de:	0001d517          	auipc	a0,0x1d
    800042e2:	62a50513          	addi	a0,a0,1578 # 80021908 <log>
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	918080e7          	jalr	-1768(ra) # 80000bfe <acquire>
    while (1)
    {
        if (log.committing)
    800042ee:	0001d497          	auipc	s1,0x1d
    800042f2:	61a48493          	addi	s1,s1,1562 # 80021908 <log>
        {
            sleep(&log, &log.lock);
        }
        else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE)
    800042f6:	4979                	li	s2,30
    800042f8:	a039                	j	80004306 <begin_op+0x34>
            sleep(&log, &log.lock);
    800042fa:	85a6                	mv	a1,s1
    800042fc:	8526                	mv	a0,s1
    800042fe:	ffffe097          	auipc	ra,0xffffe
    80004302:	edc080e7          	jalr	-292(ra) # 800021da <sleep>
        if (log.committing)
    80004306:	50dc                	lw	a5,36(s1)
    80004308:	fbed                	bnez	a5,800042fa <begin_op+0x28>
        else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE)
    8000430a:	509c                	lw	a5,32(s1)
    8000430c:	0017871b          	addiw	a4,a5,1
    80004310:	0007069b          	sext.w	a3,a4
    80004314:	0027179b          	slliw	a5,a4,0x2
    80004318:	9fb9                	addw	a5,a5,a4
    8000431a:	0017979b          	slliw	a5,a5,0x1
    8000431e:	54d8                	lw	a4,44(s1)
    80004320:	9fb9                	addw	a5,a5,a4
    80004322:	00f95963          	bge	s2,a5,80004334 <begin_op+0x62>
        {
            // this op might exhaust log space; wait for commit.
            sleep(&log, &log.lock);
    80004326:	85a6                	mv	a1,s1
    80004328:	8526                	mv	a0,s1
    8000432a:	ffffe097          	auipc	ra,0xffffe
    8000432e:	eb0080e7          	jalr	-336(ra) # 800021da <sleep>
    80004332:	bfd1                	j	80004306 <begin_op+0x34>
        }
        else
        {
            log.outstanding += 1;
    80004334:	0001d517          	auipc	a0,0x1d
    80004338:	5d450513          	addi	a0,a0,1492 # 80021908 <log>
    8000433c:	d114                	sw	a3,32(a0)
            release(&log.lock);
    8000433e:	ffffd097          	auipc	ra,0xffffd
    80004342:	974080e7          	jalr	-1676(ra) # 80000cb2 <release>
            break;
        }
    }
}
    80004346:	60e2                	ld	ra,24(sp)
    80004348:	6442                	ld	s0,16(sp)
    8000434a:	64a2                	ld	s1,8(sp)
    8000434c:	6902                	ld	s2,0(sp)
    8000434e:	6105                	addi	sp,sp,32
    80004350:	8082                	ret

0000000080004352 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void)
{
    80004352:	7139                	addi	sp,sp,-64
    80004354:	fc06                	sd	ra,56(sp)
    80004356:	f822                	sd	s0,48(sp)
    80004358:	f426                	sd	s1,40(sp)
    8000435a:	f04a                	sd	s2,32(sp)
    8000435c:	ec4e                	sd	s3,24(sp)
    8000435e:	e852                	sd	s4,16(sp)
    80004360:	e456                	sd	s5,8(sp)
    80004362:	0080                	addi	s0,sp,64
    int do_commit = 0;

    acquire(&log.lock);
    80004364:	0001d497          	auipc	s1,0x1d
    80004368:	5a448493          	addi	s1,s1,1444 # 80021908 <log>
    8000436c:	8526                	mv	a0,s1
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	890080e7          	jalr	-1904(ra) # 80000bfe <acquire>
    log.outstanding -= 1;
    80004376:	509c                	lw	a5,32(s1)
    80004378:	37fd                	addiw	a5,a5,-1
    8000437a:	0007891b          	sext.w	s2,a5
    8000437e:	d09c                	sw	a5,32(s1)
    if (log.committing)
    80004380:	50dc                	lw	a5,36(s1)
    80004382:	e7b9                	bnez	a5,800043d0 <end_op+0x7e>
        panic("log.committing");
    if (log.outstanding == 0)
    80004384:	04091e63          	bnez	s2,800043e0 <end_op+0x8e>
    {
        do_commit = 1;
        log.committing = 1;
    80004388:	0001d497          	auipc	s1,0x1d
    8000438c:	58048493          	addi	s1,s1,1408 # 80021908 <log>
    80004390:	4785                	li	a5,1
    80004392:	d0dc                	sw	a5,36(s1)
        // begin_op() may be waiting for log space,
        // and decrementing log.outstanding has decreased
        // the amount of reserved space.
        wakeup(&log);
    }
    release(&log.lock);
    80004394:	8526                	mv	a0,s1
    80004396:	ffffd097          	auipc	ra,0xffffd
    8000439a:	91c080e7          	jalr	-1764(ra) # 80000cb2 <release>
    }
}

static void commit()
{
    if (log.lh.n > 0)
    8000439e:	54dc                	lw	a5,44(s1)
    800043a0:	06f04763          	bgtz	a5,8000440e <end_op+0xbc>
        acquire(&log.lock);
    800043a4:	0001d497          	auipc	s1,0x1d
    800043a8:	56448493          	addi	s1,s1,1380 # 80021908 <log>
    800043ac:	8526                	mv	a0,s1
    800043ae:	ffffd097          	auipc	ra,0xffffd
    800043b2:	850080e7          	jalr	-1968(ra) # 80000bfe <acquire>
        log.committing = 0;
    800043b6:	0204a223          	sw	zero,36(s1)
        wakeup(&log);
    800043ba:	8526                	mv	a0,s1
    800043bc:	ffffe097          	auipc	ra,0xffffe
    800043c0:	f9e080e7          	jalr	-98(ra) # 8000235a <wakeup>
        release(&log.lock);
    800043c4:	8526                	mv	a0,s1
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	8ec080e7          	jalr	-1812(ra) # 80000cb2 <release>
}
    800043ce:	a03d                	j	800043fc <end_op+0xaa>
        panic("log.committing");
    800043d0:	00004517          	auipc	a0,0x4
    800043d4:	3a850513          	addi	a0,a0,936 # 80008778 <syscalls+0x350>
    800043d8:	ffffc097          	auipc	ra,0xffffc
    800043dc:	16a080e7          	jalr	362(ra) # 80000542 <panic>
        wakeup(&log);
    800043e0:	0001d497          	auipc	s1,0x1d
    800043e4:	52848493          	addi	s1,s1,1320 # 80021908 <log>
    800043e8:	8526                	mv	a0,s1
    800043ea:	ffffe097          	auipc	ra,0xffffe
    800043ee:	f70080e7          	jalr	-144(ra) # 8000235a <wakeup>
    release(&log.lock);
    800043f2:	8526                	mv	a0,s1
    800043f4:	ffffd097          	auipc	ra,0xffffd
    800043f8:	8be080e7          	jalr	-1858(ra) # 80000cb2 <release>
}
    800043fc:	70e2                	ld	ra,56(sp)
    800043fe:	7442                	ld	s0,48(sp)
    80004400:	74a2                	ld	s1,40(sp)
    80004402:	7902                	ld	s2,32(sp)
    80004404:	69e2                	ld	s3,24(sp)
    80004406:	6a42                	ld	s4,16(sp)
    80004408:	6aa2                	ld	s5,8(sp)
    8000440a:	6121                	addi	sp,sp,64
    8000440c:	8082                	ret
    for (tail = 0; tail < log.lh.n; tail++)
    8000440e:	0001da97          	auipc	s5,0x1d
    80004412:	52aa8a93          	addi	s5,s5,1322 # 80021938 <log+0x30>
        struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80004416:	0001da17          	auipc	s4,0x1d
    8000441a:	4f2a0a13          	addi	s4,s4,1266 # 80021908 <log>
    8000441e:	018a2583          	lw	a1,24(s4)
    80004422:	012585bb          	addw	a1,a1,s2
    80004426:	2585                	addiw	a1,a1,1
    80004428:	028a2503          	lw	a0,40(s4)
    8000442c:	fffff097          	auipc	ra,0xfffff
    80004430:	b36080e7          	jalr	-1226(ra) # 80002f62 <bread>
    80004434:	84aa                	mv	s1,a0
        struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004436:	000aa583          	lw	a1,0(s5)
    8000443a:	028a2503          	lw	a0,40(s4)
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	b24080e7          	jalr	-1244(ra) # 80002f62 <bread>
    80004446:	89aa                	mv	s3,a0
        memmove(to->data, from->data, BSIZE);
    80004448:	40000613          	li	a2,1024
    8000444c:	05850593          	addi	a1,a0,88
    80004450:	05848513          	addi	a0,s1,88
    80004454:	ffffd097          	auipc	ra,0xffffd
    80004458:	902080e7          	jalr	-1790(ra) # 80000d56 <memmove>
        bwrite(to); // write the log
    8000445c:	8526                	mv	a0,s1
    8000445e:	fffff097          	auipc	ra,0xfffff
    80004462:	b62080e7          	jalr	-1182(ra) # 80002fc0 <bwrite>
        brelse(from);
    80004466:	854e                	mv	a0,s3
    80004468:	fffff097          	auipc	ra,0xfffff
    8000446c:	b96080e7          	jalr	-1130(ra) # 80002ffe <brelse>
        brelse(to);
    80004470:	8526                	mv	a0,s1
    80004472:	fffff097          	auipc	ra,0xfffff
    80004476:	b8c080e7          	jalr	-1140(ra) # 80002ffe <brelse>
    for (tail = 0; tail < log.lh.n; tail++)
    8000447a:	2905                	addiw	s2,s2,1
    8000447c:	0a91                	addi	s5,s5,4
    8000447e:	02ca2783          	lw	a5,44(s4)
    80004482:	f8f94ee3          	blt	s2,a5,8000441e <end_op+0xcc>
    {
        write_log();     // Write modified blocks from cache to log
        write_head();    // Write header to disk -- the real commit
    80004486:	00000097          	auipc	ra,0x0
    8000448a:	c7a080e7          	jalr	-902(ra) # 80004100 <write_head>
        install_trans(); // Now install writes to home locations
    8000448e:	00000097          	auipc	ra,0x0
    80004492:	cec080e7          	jalr	-788(ra) # 8000417a <install_trans>
        log.lh.n = 0;
    80004496:	0001d797          	auipc	a5,0x1d
    8000449a:	4807af23          	sw	zero,1182(a5) # 80021934 <log+0x2c>
        write_head(); // Erase the transaction from the log
    8000449e:	00000097          	auipc	ra,0x0
    800044a2:	c62080e7          	jalr	-926(ra) # 80004100 <write_head>
    800044a6:	bdfd                	j	800043a4 <end_op+0x52>

00000000800044a8 <log_write>:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b)
{
    800044a8:	1101                	addi	sp,sp,-32
    800044aa:	ec06                	sd	ra,24(sp)
    800044ac:	e822                	sd	s0,16(sp)
    800044ae:	e426                	sd	s1,8(sp)
    800044b0:	e04a                	sd	s2,0(sp)
    800044b2:	1000                	addi	s0,sp,32
    int i;

    if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800044b4:	0001d717          	auipc	a4,0x1d
    800044b8:	48072703          	lw	a4,1152(a4) # 80021934 <log+0x2c>
    800044bc:	47f5                	li	a5,29
    800044be:	08e7c063          	blt	a5,a4,8000453e <log_write+0x96>
    800044c2:	84aa                	mv	s1,a0
    800044c4:	0001d797          	auipc	a5,0x1d
    800044c8:	4607a783          	lw	a5,1120(a5) # 80021924 <log+0x1c>
    800044cc:	37fd                	addiw	a5,a5,-1
    800044ce:	06f75863          	bge	a4,a5,8000453e <log_write+0x96>
        panic("too big a transaction");
    if (log.outstanding < 1)
    800044d2:	0001d797          	auipc	a5,0x1d
    800044d6:	4567a783          	lw	a5,1110(a5) # 80021928 <log+0x20>
    800044da:	06f05a63          	blez	a5,8000454e <log_write+0xa6>
        panic("log_write outside of trans");

    acquire(&log.lock);
    800044de:	0001d917          	auipc	s2,0x1d
    800044e2:	42a90913          	addi	s2,s2,1066 # 80021908 <log>
    800044e6:	854a                	mv	a0,s2
    800044e8:	ffffc097          	auipc	ra,0xffffc
    800044ec:	716080e7          	jalr	1814(ra) # 80000bfe <acquire>
    for (i = 0; i < log.lh.n; i++)
    800044f0:	02c92603          	lw	a2,44(s2)
    800044f4:	06c05563          	blez	a2,8000455e <log_write+0xb6>
    {
        if (log.lh.block[i] == b->blockno) // log absorbtion
    800044f8:	44cc                	lw	a1,12(s1)
    800044fa:	0001d717          	auipc	a4,0x1d
    800044fe:	43e70713          	addi	a4,a4,1086 # 80021938 <log+0x30>
    for (i = 0; i < log.lh.n; i++)
    80004502:	4781                	li	a5,0
        if (log.lh.block[i] == b->blockno) // log absorbtion
    80004504:	4314                	lw	a3,0(a4)
    80004506:	04b68d63          	beq	a3,a1,80004560 <log_write+0xb8>
    for (i = 0; i < log.lh.n; i++)
    8000450a:	2785                	addiw	a5,a5,1
    8000450c:	0711                	addi	a4,a4,4
    8000450e:	fec79be3          	bne	a5,a2,80004504 <log_write+0x5c>
            break;
    }
    log.lh.block[i] = b->blockno;
    80004512:	0621                	addi	a2,a2,8
    80004514:	060a                	slli	a2,a2,0x2
    80004516:	0001d797          	auipc	a5,0x1d
    8000451a:	3f278793          	addi	a5,a5,1010 # 80021908 <log>
    8000451e:	963e                	add	a2,a2,a5
    80004520:	44dc                	lw	a5,12(s1)
    80004522:	ca1c                	sw	a5,16(a2)
    if (i == log.lh.n)
    { // Add new block to log?
        bpin(b);
    80004524:	8526                	mv	a0,s1
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	b76080e7          	jalr	-1162(ra) # 8000309c <bpin>
        log.lh.n++;
    8000452e:	0001d717          	auipc	a4,0x1d
    80004532:	3da70713          	addi	a4,a4,986 # 80021908 <log>
    80004536:	575c                	lw	a5,44(a4)
    80004538:	2785                	addiw	a5,a5,1
    8000453a:	d75c                	sw	a5,44(a4)
    8000453c:	a83d                	j	8000457a <log_write+0xd2>
        panic("too big a transaction");
    8000453e:	00004517          	auipc	a0,0x4
    80004542:	24a50513          	addi	a0,a0,586 # 80008788 <syscalls+0x360>
    80004546:	ffffc097          	auipc	ra,0xffffc
    8000454a:	ffc080e7          	jalr	-4(ra) # 80000542 <panic>
        panic("log_write outside of trans");
    8000454e:	00004517          	auipc	a0,0x4
    80004552:	25250513          	addi	a0,a0,594 # 800087a0 <syscalls+0x378>
    80004556:	ffffc097          	auipc	ra,0xffffc
    8000455a:	fec080e7          	jalr	-20(ra) # 80000542 <panic>
    for (i = 0; i < log.lh.n; i++)
    8000455e:	4781                	li	a5,0
    log.lh.block[i] = b->blockno;
    80004560:	00878713          	addi	a4,a5,8
    80004564:	00271693          	slli	a3,a4,0x2
    80004568:	0001d717          	auipc	a4,0x1d
    8000456c:	3a070713          	addi	a4,a4,928 # 80021908 <log>
    80004570:	9736                	add	a4,a4,a3
    80004572:	44d4                	lw	a3,12(s1)
    80004574:	cb14                	sw	a3,16(a4)
    if (i == log.lh.n)
    80004576:	faf607e3          	beq	a2,a5,80004524 <log_write+0x7c>
    }
    release(&log.lock);
    8000457a:	0001d517          	auipc	a0,0x1d
    8000457e:	38e50513          	addi	a0,a0,910 # 80021908 <log>
    80004582:	ffffc097          	auipc	ra,0xffffc
    80004586:	730080e7          	jalr	1840(ra) # 80000cb2 <release>
}
    8000458a:	60e2                	ld	ra,24(sp)
    8000458c:	6442                	ld	s0,16(sp)
    8000458e:	64a2                	ld	s1,8(sp)
    80004590:	6902                	ld	s2,0(sp)
    80004592:	6105                	addi	sp,sp,32
    80004594:	8082                	ret

0000000080004596 <initsleeplock>:
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name)
{
    80004596:	1101                	addi	sp,sp,-32
    80004598:	ec06                	sd	ra,24(sp)
    8000459a:	e822                	sd	s0,16(sp)
    8000459c:	e426                	sd	s1,8(sp)
    8000459e:	e04a                	sd	s2,0(sp)
    800045a0:	1000                	addi	s0,sp,32
    800045a2:	84aa                	mv	s1,a0
    800045a4:	892e                	mv	s2,a1
    initlock(&lk->lk, "sleep lock");
    800045a6:	00004597          	auipc	a1,0x4
    800045aa:	21a58593          	addi	a1,a1,538 # 800087c0 <syscalls+0x398>
    800045ae:	0521                	addi	a0,a0,8
    800045b0:	ffffc097          	auipc	ra,0xffffc
    800045b4:	5be080e7          	jalr	1470(ra) # 80000b6e <initlock>
    lk->name = name;
    800045b8:	0324b023          	sd	s2,32(s1)
    lk->locked = 0;
    800045bc:	0004a023          	sw	zero,0(s1)
    lk->pid = 0;
    800045c0:	0204a423          	sw	zero,40(s1)
}
    800045c4:	60e2                	ld	ra,24(sp)
    800045c6:	6442                	ld	s0,16(sp)
    800045c8:	64a2                	ld	s1,8(sp)
    800045ca:	6902                	ld	s2,0(sp)
    800045cc:	6105                	addi	sp,sp,32
    800045ce:	8082                	ret

00000000800045d0 <acquiresleep>:

void acquiresleep(struct sleeplock *lk)
{
    800045d0:	1101                	addi	sp,sp,-32
    800045d2:	ec06                	sd	ra,24(sp)
    800045d4:	e822                	sd	s0,16(sp)
    800045d6:	e426                	sd	s1,8(sp)
    800045d8:	e04a                	sd	s2,0(sp)
    800045da:	1000                	addi	s0,sp,32
    800045dc:	84aa                	mv	s1,a0
    acquire(&lk->lk);
    800045de:	00850913          	addi	s2,a0,8
    800045e2:	854a                	mv	a0,s2
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	61a080e7          	jalr	1562(ra) # 80000bfe <acquire>
    while (lk->locked)
    800045ec:	409c                	lw	a5,0(s1)
    800045ee:	cb89                	beqz	a5,80004600 <acquiresleep+0x30>
    {
        sleep(lk, &lk->lk);
    800045f0:	85ca                	mv	a1,s2
    800045f2:	8526                	mv	a0,s1
    800045f4:	ffffe097          	auipc	ra,0xffffe
    800045f8:	be6080e7          	jalr	-1050(ra) # 800021da <sleep>
    while (lk->locked)
    800045fc:	409c                	lw	a5,0(s1)
    800045fe:	fbed                	bnez	a5,800045f0 <acquiresleep+0x20>
    }
    lk->locked = 1;
    80004600:	4785                	li	a5,1
    80004602:	c09c                	sw	a5,0(s1)
    lk->pid = myproc()->pid;
    80004604:	ffffd097          	auipc	ra,0xffffd
    80004608:	3c6080e7          	jalr	966(ra) # 800019ca <myproc>
    8000460c:	5d1c                	lw	a5,56(a0)
    8000460e:	d49c                	sw	a5,40(s1)
    release(&lk->lk);
    80004610:	854a                	mv	a0,s2
    80004612:	ffffc097          	auipc	ra,0xffffc
    80004616:	6a0080e7          	jalr	1696(ra) # 80000cb2 <release>
}
    8000461a:	60e2                	ld	ra,24(sp)
    8000461c:	6442                	ld	s0,16(sp)
    8000461e:	64a2                	ld	s1,8(sp)
    80004620:	6902                	ld	s2,0(sp)
    80004622:	6105                	addi	sp,sp,32
    80004624:	8082                	ret

0000000080004626 <releasesleep>:

void releasesleep(struct sleeplock *lk)
{
    80004626:	1101                	addi	sp,sp,-32
    80004628:	ec06                	sd	ra,24(sp)
    8000462a:	e822                	sd	s0,16(sp)
    8000462c:	e426                	sd	s1,8(sp)
    8000462e:	e04a                	sd	s2,0(sp)
    80004630:	1000                	addi	s0,sp,32
    80004632:	84aa                	mv	s1,a0
    acquire(&lk->lk);
    80004634:	00850913          	addi	s2,a0,8
    80004638:	854a                	mv	a0,s2
    8000463a:	ffffc097          	auipc	ra,0xffffc
    8000463e:	5c4080e7          	jalr	1476(ra) # 80000bfe <acquire>
    lk->locked = 0;
    80004642:	0004a023          	sw	zero,0(s1)
    lk->pid = 0;
    80004646:	0204a423          	sw	zero,40(s1)
    wakeup(lk);
    8000464a:	8526                	mv	a0,s1
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	d0e080e7          	jalr	-754(ra) # 8000235a <wakeup>
    release(&lk->lk);
    80004654:	854a                	mv	a0,s2
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	65c080e7          	jalr	1628(ra) # 80000cb2 <release>
}
    8000465e:	60e2                	ld	ra,24(sp)
    80004660:	6442                	ld	s0,16(sp)
    80004662:	64a2                	ld	s1,8(sp)
    80004664:	6902                	ld	s2,0(sp)
    80004666:	6105                	addi	sp,sp,32
    80004668:	8082                	ret

000000008000466a <holdingsleep>:

int holdingsleep(struct sleeplock *lk)
{
    8000466a:	7179                	addi	sp,sp,-48
    8000466c:	f406                	sd	ra,40(sp)
    8000466e:	f022                	sd	s0,32(sp)
    80004670:	ec26                	sd	s1,24(sp)
    80004672:	e84a                	sd	s2,16(sp)
    80004674:	e44e                	sd	s3,8(sp)
    80004676:	1800                	addi	s0,sp,48
    80004678:	84aa                	mv	s1,a0
    int r;

    acquire(&lk->lk);
    8000467a:	00850913          	addi	s2,a0,8
    8000467e:	854a                	mv	a0,s2
    80004680:	ffffc097          	auipc	ra,0xffffc
    80004684:	57e080e7          	jalr	1406(ra) # 80000bfe <acquire>
    r = lk->locked && (lk->pid == myproc()->pid);
    80004688:	409c                	lw	a5,0(s1)
    8000468a:	ef99                	bnez	a5,800046a8 <holdingsleep+0x3e>
    8000468c:	4481                	li	s1,0
    release(&lk->lk);
    8000468e:	854a                	mv	a0,s2
    80004690:	ffffc097          	auipc	ra,0xffffc
    80004694:	622080e7          	jalr	1570(ra) # 80000cb2 <release>
    return r;
}
    80004698:	8526                	mv	a0,s1
    8000469a:	70a2                	ld	ra,40(sp)
    8000469c:	7402                	ld	s0,32(sp)
    8000469e:	64e2                	ld	s1,24(sp)
    800046a0:	6942                	ld	s2,16(sp)
    800046a2:	69a2                	ld	s3,8(sp)
    800046a4:	6145                	addi	sp,sp,48
    800046a6:	8082                	ret
    r = lk->locked && (lk->pid == myproc()->pid);
    800046a8:	0284a983          	lw	s3,40(s1)
    800046ac:	ffffd097          	auipc	ra,0xffffd
    800046b0:	31e080e7          	jalr	798(ra) # 800019ca <myproc>
    800046b4:	5d04                	lw	s1,56(a0)
    800046b6:	413484b3          	sub	s1,s1,s3
    800046ba:	0014b493          	seqz	s1,s1
    800046be:	bfc1                	j	8000468e <holdingsleep+0x24>

00000000800046c0 <fileinit>:
{
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    800046c0:	1141                	addi	sp,sp,-16
    800046c2:	e406                	sd	ra,8(sp)
    800046c4:	e022                	sd	s0,0(sp)
    800046c6:	0800                	addi	s0,sp,16
    800046c8:	00004597          	auipc	a1,0x4
    800046cc:	10858593          	addi	a1,a1,264 # 800087d0 <syscalls+0x3a8>
    800046d0:	0001d517          	auipc	a0,0x1d
    800046d4:	38050513          	addi	a0,a0,896 # 80021a50 <ftable>
    800046d8:	ffffc097          	auipc	ra,0xffffc
    800046dc:	496080e7          	jalr	1174(ra) # 80000b6e <initlock>
    800046e0:	60a2                	ld	ra,8(sp)
    800046e2:	6402                	ld	s0,0(sp)
    800046e4:	0141                	addi	sp,sp,16
    800046e6:	8082                	ret

00000000800046e8 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void)
{
    800046e8:	1101                	addi	sp,sp,-32
    800046ea:	ec06                	sd	ra,24(sp)
    800046ec:	e822                	sd	s0,16(sp)
    800046ee:	e426                	sd	s1,8(sp)
    800046f0:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    800046f2:	0001d517          	auipc	a0,0x1d
    800046f6:	35e50513          	addi	a0,a0,862 # 80021a50 <ftable>
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	504080e7          	jalr	1284(ra) # 80000bfe <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80004702:	0001d497          	auipc	s1,0x1d
    80004706:	36648493          	addi	s1,s1,870 # 80021a68 <ftable+0x18>
    8000470a:	0001e717          	auipc	a4,0x1e
    8000470e:	2fe70713          	addi	a4,a4,766 # 80022a08 <ftable+0xfb8>
    {
        if (f->ref == 0)
    80004712:	40dc                	lw	a5,4(s1)
    80004714:	cf99                	beqz	a5,80004732 <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80004716:	02848493          	addi	s1,s1,40
    8000471a:	fee49ce3          	bne	s1,a4,80004712 <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    8000471e:	0001d517          	auipc	a0,0x1d
    80004722:	33250513          	addi	a0,a0,818 # 80021a50 <ftable>
    80004726:	ffffc097          	auipc	ra,0xffffc
    8000472a:	58c080e7          	jalr	1420(ra) # 80000cb2 <release>
    return 0;
    8000472e:	4481                	li	s1,0
    80004730:	a819                	j	80004746 <filealloc+0x5e>
            f->ref = 1;
    80004732:	4785                	li	a5,1
    80004734:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    80004736:	0001d517          	auipc	a0,0x1d
    8000473a:	31a50513          	addi	a0,a0,794 # 80021a50 <ftable>
    8000473e:	ffffc097          	auipc	ra,0xffffc
    80004742:	574080e7          	jalr	1396(ra) # 80000cb2 <release>
}
    80004746:	8526                	mv	a0,s1
    80004748:	60e2                	ld	ra,24(sp)
    8000474a:	6442                	ld	s0,16(sp)
    8000474c:	64a2                	ld	s1,8(sp)
    8000474e:	6105                	addi	sp,sp,32
    80004750:	8082                	ret

0000000080004752 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f)
{
    80004752:	1101                	addi	sp,sp,-32
    80004754:	ec06                	sd	ra,24(sp)
    80004756:	e822                	sd	s0,16(sp)
    80004758:	e426                	sd	s1,8(sp)
    8000475a:	1000                	addi	s0,sp,32
    8000475c:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    8000475e:	0001d517          	auipc	a0,0x1d
    80004762:	2f250513          	addi	a0,a0,754 # 80021a50 <ftable>
    80004766:	ffffc097          	auipc	ra,0xffffc
    8000476a:	498080e7          	jalr	1176(ra) # 80000bfe <acquire>
    if (f->ref < 1)
    8000476e:	40dc                	lw	a5,4(s1)
    80004770:	02f05263          	blez	a5,80004794 <filedup+0x42>
        panic("filedup");
    f->ref++;
    80004774:	2785                	addiw	a5,a5,1
    80004776:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80004778:	0001d517          	auipc	a0,0x1d
    8000477c:	2d850513          	addi	a0,a0,728 # 80021a50 <ftable>
    80004780:	ffffc097          	auipc	ra,0xffffc
    80004784:	532080e7          	jalr	1330(ra) # 80000cb2 <release>
    return f;
}
    80004788:	8526                	mv	a0,s1
    8000478a:	60e2                	ld	ra,24(sp)
    8000478c:	6442                	ld	s0,16(sp)
    8000478e:	64a2                	ld	s1,8(sp)
    80004790:	6105                	addi	sp,sp,32
    80004792:	8082                	ret
        panic("filedup");
    80004794:	00004517          	auipc	a0,0x4
    80004798:	04450513          	addi	a0,a0,68 # 800087d8 <syscalls+0x3b0>
    8000479c:	ffffc097          	auipc	ra,0xffffc
    800047a0:	da6080e7          	jalr	-602(ra) # 80000542 <panic>

00000000800047a4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    800047a4:	7139                	addi	sp,sp,-64
    800047a6:	fc06                	sd	ra,56(sp)
    800047a8:	f822                	sd	s0,48(sp)
    800047aa:	f426                	sd	s1,40(sp)
    800047ac:	f04a                	sd	s2,32(sp)
    800047ae:	ec4e                	sd	s3,24(sp)
    800047b0:	e852                	sd	s4,16(sp)
    800047b2:	e456                	sd	s5,8(sp)
    800047b4:	0080                	addi	s0,sp,64
    800047b6:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    800047b8:	0001d517          	auipc	a0,0x1d
    800047bc:	29850513          	addi	a0,a0,664 # 80021a50 <ftable>
    800047c0:	ffffc097          	auipc	ra,0xffffc
    800047c4:	43e080e7          	jalr	1086(ra) # 80000bfe <acquire>
    if (f->ref < 1)
    800047c8:	40dc                	lw	a5,4(s1)
    800047ca:	06f05163          	blez	a5,8000482c <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    800047ce:	37fd                	addiw	a5,a5,-1
    800047d0:	0007871b          	sext.w	a4,a5
    800047d4:	c0dc                	sw	a5,4(s1)
    800047d6:	06e04363          	bgtz	a4,8000483c <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    800047da:	0004a903          	lw	s2,0(s1)
    800047de:	0094ca83          	lbu	s5,9(s1)
    800047e2:	0104ba03          	ld	s4,16(s1)
    800047e6:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    800047ea:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    800047ee:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    800047f2:	0001d517          	auipc	a0,0x1d
    800047f6:	25e50513          	addi	a0,a0,606 # 80021a50 <ftable>
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	4b8080e7          	jalr	1208(ra) # 80000cb2 <release>

    if (ff.type == FD_PIPE)
    80004802:	4785                	li	a5,1
    80004804:	04f90d63          	beq	s2,a5,8000485e <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80004808:	3979                	addiw	s2,s2,-2
    8000480a:	4785                	li	a5,1
    8000480c:	0527e063          	bltu	a5,s2,8000484c <fileclose+0xa8>
    {
        begin_op();
    80004810:	00000097          	auipc	ra,0x0
    80004814:	ac2080e7          	jalr	-1342(ra) # 800042d2 <begin_op>
        iput(ff.ip);
    80004818:	854e                	mv	a0,s3
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	0be080e7          	jalr	190(ra) # 800038d8 <iput>
        end_op();
    80004822:	00000097          	auipc	ra,0x0
    80004826:	b30080e7          	jalr	-1232(ra) # 80004352 <end_op>
    8000482a:	a00d                	j	8000484c <fileclose+0xa8>
        panic("fileclose");
    8000482c:	00004517          	auipc	a0,0x4
    80004830:	fb450513          	addi	a0,a0,-76 # 800087e0 <syscalls+0x3b8>
    80004834:	ffffc097          	auipc	ra,0xffffc
    80004838:	d0e080e7          	jalr	-754(ra) # 80000542 <panic>
        release(&ftable.lock);
    8000483c:	0001d517          	auipc	a0,0x1d
    80004840:	21450513          	addi	a0,a0,532 # 80021a50 <ftable>
    80004844:	ffffc097          	auipc	ra,0xffffc
    80004848:	46e080e7          	jalr	1134(ra) # 80000cb2 <release>
    }
}
    8000484c:	70e2                	ld	ra,56(sp)
    8000484e:	7442                	ld	s0,48(sp)
    80004850:	74a2                	ld	s1,40(sp)
    80004852:	7902                	ld	s2,32(sp)
    80004854:	69e2                	ld	s3,24(sp)
    80004856:	6a42                	ld	s4,16(sp)
    80004858:	6aa2                	ld	s5,8(sp)
    8000485a:	6121                	addi	sp,sp,64
    8000485c:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    8000485e:	85d6                	mv	a1,s5
    80004860:	8552                	mv	a0,s4
    80004862:	00000097          	auipc	ra,0x0
    80004866:	374080e7          	jalr	884(ra) # 80004bd6 <pipeclose>
    8000486a:	b7cd                	j	8000484c <fileclose+0xa8>

000000008000486c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    8000486c:	715d                	addi	sp,sp,-80
    8000486e:	e486                	sd	ra,72(sp)
    80004870:	e0a2                	sd	s0,64(sp)
    80004872:	fc26                	sd	s1,56(sp)
    80004874:	f84a                	sd	s2,48(sp)
    80004876:	f44e                	sd	s3,40(sp)
    80004878:	0880                	addi	s0,sp,80
    8000487a:	84aa                	mv	s1,a0
    8000487c:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    8000487e:	ffffd097          	auipc	ra,0xffffd
    80004882:	14c080e7          	jalr	332(ra) # 800019ca <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80004886:	409c                	lw	a5,0(s1)
    80004888:	37f9                	addiw	a5,a5,-2
    8000488a:	4705                	li	a4,1
    8000488c:	04f76863          	bltu	a4,a5,800048dc <filestat+0x70>
    80004890:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80004892:	6c88                	ld	a0,24(s1)
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	d6c080e7          	jalr	-660(ra) # 80003600 <ilock>
        stati(f->ip, &st);
    8000489c:	fb040593          	addi	a1,s0,-80
    800048a0:	6c88                	ld	a0,24(s1)
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	106080e7          	jalr	262(ra) # 800039a8 <stati>
        iunlock(f->ip);
    800048aa:	6c88                	ld	a0,24(s1)
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	e16080e7          	jalr	-490(ra) # 800036c2 <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800048b4:	02000693          	li	a3,32
    800048b8:	fb040613          	addi	a2,s0,-80
    800048bc:	85ce                	mv	a1,s3
    800048be:	05093503          	ld	a0,80(s2)
    800048c2:	ffffd097          	auipc	ra,0xffffd
    800048c6:	dfa080e7          	jalr	-518(ra) # 800016bc <copyout>
    800048ca:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    800048ce:	60a6                	ld	ra,72(sp)
    800048d0:	6406                	ld	s0,64(sp)
    800048d2:	74e2                	ld	s1,56(sp)
    800048d4:	7942                	ld	s2,48(sp)
    800048d6:	79a2                	ld	s3,40(sp)
    800048d8:	6161                	addi	sp,sp,80
    800048da:	8082                	ret
    return -1;
    800048dc:	557d                	li	a0,-1
    800048de:	bfc5                	j	800048ce <filestat+0x62>

00000000800048e0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    800048e0:	7179                	addi	sp,sp,-48
    800048e2:	f406                	sd	ra,40(sp)
    800048e4:	f022                	sd	s0,32(sp)
    800048e6:	ec26                	sd	s1,24(sp)
    800048e8:	e84a                	sd	s2,16(sp)
    800048ea:	e44e                	sd	s3,8(sp)
    800048ec:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    800048ee:	00854783          	lbu	a5,8(a0)
    800048f2:	c3d5                	beqz	a5,80004996 <fileread+0xb6>
    800048f4:	84aa                	mv	s1,a0
    800048f6:	89ae                	mv	s3,a1
    800048f8:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    800048fa:	411c                	lw	a5,0(a0)
    800048fc:	4705                	li	a4,1
    800048fe:	04e78963          	beq	a5,a4,80004950 <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80004902:	470d                	li	a4,3
    80004904:	04e78d63          	beq	a5,a4,8000495e <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80004908:	4709                	li	a4,2
    8000490a:	06e79e63          	bne	a5,a4,80004986 <fileread+0xa6>
    {
        ilock(f->ip);
    8000490e:	6d08                	ld	a0,24(a0)
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	cf0080e7          	jalr	-784(ra) # 80003600 <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004918:	874a                	mv	a4,s2
    8000491a:	5094                	lw	a3,32(s1)
    8000491c:	864e                	mv	a2,s3
    8000491e:	4585                	li	a1,1
    80004920:	6c88                	ld	a0,24(s1)
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	0b8080e7          	jalr	184(ra) # 800039da <readi>
    8000492a:	892a                	mv	s2,a0
    8000492c:	00a05563          	blez	a0,80004936 <fileread+0x56>
            f->off += r;
    80004930:	509c                	lw	a5,32(s1)
    80004932:	9fa9                	addw	a5,a5,a0
    80004934:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80004936:	6c88                	ld	a0,24(s1)
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	d8a080e7          	jalr	-630(ra) # 800036c2 <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    80004940:	854a                	mv	a0,s2
    80004942:	70a2                	ld	ra,40(sp)
    80004944:	7402                	ld	s0,32(sp)
    80004946:	64e2                	ld	s1,24(sp)
    80004948:	6942                	ld	s2,16(sp)
    8000494a:	69a2                	ld	s3,8(sp)
    8000494c:	6145                	addi	sp,sp,48
    8000494e:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80004950:	6908                	ld	a0,16(a0)
    80004952:	00000097          	auipc	ra,0x0
    80004956:	3f4080e7          	jalr	1012(ra) # 80004d46 <piperead>
    8000495a:	892a                	mv	s2,a0
    8000495c:	b7d5                	j	80004940 <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000495e:	02451783          	lh	a5,36(a0)
    80004962:	03079693          	slli	a3,a5,0x30
    80004966:	92c1                	srli	a3,a3,0x30
    80004968:	4725                	li	a4,9
    8000496a:	02d76863          	bltu	a4,a3,8000499a <fileread+0xba>
    8000496e:	0792                	slli	a5,a5,0x4
    80004970:	0001d717          	auipc	a4,0x1d
    80004974:	04070713          	addi	a4,a4,64 # 800219b0 <devsw>
    80004978:	97ba                	add	a5,a5,a4
    8000497a:	639c                	ld	a5,0(a5)
    8000497c:	c38d                	beqz	a5,8000499e <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    8000497e:	4505                	li	a0,1
    80004980:	9782                	jalr	a5
    80004982:	892a                	mv	s2,a0
    80004984:	bf75                	j	80004940 <fileread+0x60>
        panic("fileread");
    80004986:	00004517          	auipc	a0,0x4
    8000498a:	e6a50513          	addi	a0,a0,-406 # 800087f0 <syscalls+0x3c8>
    8000498e:	ffffc097          	auipc	ra,0xffffc
    80004992:	bb4080e7          	jalr	-1100(ra) # 80000542 <panic>
        return -1;
    80004996:	597d                	li	s2,-1
    80004998:	b765                	j	80004940 <fileread+0x60>
            return -1;
    8000499a:	597d                	li	s2,-1
    8000499c:	b755                	j	80004940 <fileread+0x60>
    8000499e:	597d                	li	s2,-1
    800049a0:	b745                	j	80004940 <fileread+0x60>

00000000800049a2 <filewrite>:
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    int r, ret = 0;

    if (f->writable == 0)
    800049a2:	00954783          	lbu	a5,9(a0)
    800049a6:	14078563          	beqz	a5,80004af0 <filewrite+0x14e>
{
    800049aa:	715d                	addi	sp,sp,-80
    800049ac:	e486                	sd	ra,72(sp)
    800049ae:	e0a2                	sd	s0,64(sp)
    800049b0:	fc26                	sd	s1,56(sp)
    800049b2:	f84a                	sd	s2,48(sp)
    800049b4:	f44e                	sd	s3,40(sp)
    800049b6:	f052                	sd	s4,32(sp)
    800049b8:	ec56                	sd	s5,24(sp)
    800049ba:	e85a                	sd	s6,16(sp)
    800049bc:	e45e                	sd	s7,8(sp)
    800049be:	e062                	sd	s8,0(sp)
    800049c0:	0880                	addi	s0,sp,80
    800049c2:	892a                	mv	s2,a0
    800049c4:	8aae                	mv	s5,a1
    800049c6:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    800049c8:	411c                	lw	a5,0(a0)
    800049ca:	4705                	li	a4,1
    800049cc:	02e78263          	beq	a5,a4,800049f0 <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    800049d0:	470d                	li	a4,3
    800049d2:	02e78563          	beq	a5,a4,800049fc <filewrite+0x5a>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    800049d6:	4709                	li	a4,2
    800049d8:	10e79463          	bne	a5,a4,80004ae0 <filewrite+0x13e>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    800049dc:	0ec05e63          	blez	a2,80004ad8 <filewrite+0x136>
        int i = 0;
    800049e0:	4981                	li	s3,0
    800049e2:	6b05                	lui	s6,0x1
    800049e4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800049e8:	6b85                	lui	s7,0x1
    800049ea:	c00b8b9b          	addiw	s7,s7,-1024
    800049ee:	a851                	j	80004a82 <filewrite+0xe0>
        ret = pipewrite(f->pipe, addr, n);
    800049f0:	6908                	ld	a0,16(a0)
    800049f2:	00000097          	auipc	ra,0x0
    800049f6:	254080e7          	jalr	596(ra) # 80004c46 <pipewrite>
    800049fa:	a85d                	j	80004ab0 <filewrite+0x10e>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800049fc:	02451783          	lh	a5,36(a0)
    80004a00:	03079693          	slli	a3,a5,0x30
    80004a04:	92c1                	srli	a3,a3,0x30
    80004a06:	4725                	li	a4,9
    80004a08:	0ed76663          	bltu	a4,a3,80004af4 <filewrite+0x152>
    80004a0c:	0792                	slli	a5,a5,0x4
    80004a0e:	0001d717          	auipc	a4,0x1d
    80004a12:	fa270713          	addi	a4,a4,-94 # 800219b0 <devsw>
    80004a16:	97ba                	add	a5,a5,a4
    80004a18:	679c                	ld	a5,8(a5)
    80004a1a:	cff9                	beqz	a5,80004af8 <filewrite+0x156>
        ret = devsw[f->major].write(1, addr, n);
    80004a1c:	4505                	li	a0,1
    80004a1e:	9782                	jalr	a5
    80004a20:	a841                	j	80004ab0 <filewrite+0x10e>
    80004a22:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80004a26:	00000097          	auipc	ra,0x0
    80004a2a:	8ac080e7          	jalr	-1876(ra) # 800042d2 <begin_op>
            ilock(f->ip);
    80004a2e:	01893503          	ld	a0,24(s2)
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	bce080e7          	jalr	-1074(ra) # 80003600 <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004a3a:	8762                	mv	a4,s8
    80004a3c:	02092683          	lw	a3,32(s2)
    80004a40:	01598633          	add	a2,s3,s5
    80004a44:	4585                	li	a1,1
    80004a46:	01893503          	ld	a0,24(s2)
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	086080e7          	jalr	134(ra) # 80003ad0 <writei>
    80004a52:	84aa                	mv	s1,a0
    80004a54:	02a05f63          	blez	a0,80004a92 <filewrite+0xf0>
                f->off += r;
    80004a58:	02092783          	lw	a5,32(s2)
    80004a5c:	9fa9                	addw	a5,a5,a0
    80004a5e:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80004a62:	01893503          	ld	a0,24(s2)
    80004a66:	fffff097          	auipc	ra,0xfffff
    80004a6a:	c5c080e7          	jalr	-932(ra) # 800036c2 <iunlock>
            end_op();
    80004a6e:	00000097          	auipc	ra,0x0
    80004a72:	8e4080e7          	jalr	-1820(ra) # 80004352 <end_op>

            if (r < 0)
                break;
            if (r != n1)
    80004a76:	049c1963          	bne	s8,s1,80004ac8 <filewrite+0x126>
                panic("short filewrite");
            i += r;
    80004a7a:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80004a7e:	0349d663          	bge	s3,s4,80004aaa <filewrite+0x108>
            int n1 = n - i;
    80004a82:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80004a86:	84be                	mv	s1,a5
    80004a88:	2781                	sext.w	a5,a5
    80004a8a:	f8fb5ce3          	bge	s6,a5,80004a22 <filewrite+0x80>
    80004a8e:	84de                	mv	s1,s7
    80004a90:	bf49                	j	80004a22 <filewrite+0x80>
            iunlock(f->ip);
    80004a92:	01893503          	ld	a0,24(s2)
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	c2c080e7          	jalr	-980(ra) # 800036c2 <iunlock>
            end_op();
    80004a9e:	00000097          	auipc	ra,0x0
    80004aa2:	8b4080e7          	jalr	-1868(ra) # 80004352 <end_op>
            if (r < 0)
    80004aa6:	fc04d8e3          	bgez	s1,80004a76 <filewrite+0xd4>
        }
        ret = (i == n ? n : -1);
    80004aaa:	8552                	mv	a0,s4
    80004aac:	033a1863          	bne	s4,s3,80004adc <filewrite+0x13a>
    {
        panic("filewrite");
    }

    return ret;
}
    80004ab0:	60a6                	ld	ra,72(sp)
    80004ab2:	6406                	ld	s0,64(sp)
    80004ab4:	74e2                	ld	s1,56(sp)
    80004ab6:	7942                	ld	s2,48(sp)
    80004ab8:	79a2                	ld	s3,40(sp)
    80004aba:	7a02                	ld	s4,32(sp)
    80004abc:	6ae2                	ld	s5,24(sp)
    80004abe:	6b42                	ld	s6,16(sp)
    80004ac0:	6ba2                	ld	s7,8(sp)
    80004ac2:	6c02                	ld	s8,0(sp)
    80004ac4:	6161                	addi	sp,sp,80
    80004ac6:	8082                	ret
                panic("short filewrite");
    80004ac8:	00004517          	auipc	a0,0x4
    80004acc:	d3850513          	addi	a0,a0,-712 # 80008800 <syscalls+0x3d8>
    80004ad0:	ffffc097          	auipc	ra,0xffffc
    80004ad4:	a72080e7          	jalr	-1422(ra) # 80000542 <panic>
        int i = 0;
    80004ad8:	4981                	li	s3,0
    80004ada:	bfc1                	j	80004aaa <filewrite+0x108>
        ret = (i == n ? n : -1);
    80004adc:	557d                	li	a0,-1
    80004ade:	bfc9                	j	80004ab0 <filewrite+0x10e>
        panic("filewrite");
    80004ae0:	00004517          	auipc	a0,0x4
    80004ae4:	d3050513          	addi	a0,a0,-720 # 80008810 <syscalls+0x3e8>
    80004ae8:	ffffc097          	auipc	ra,0xffffc
    80004aec:	a5a080e7          	jalr	-1446(ra) # 80000542 <panic>
        return -1;
    80004af0:	557d                	li	a0,-1
}
    80004af2:	8082                	ret
            return -1;
    80004af4:	557d                	li	a0,-1
    80004af6:	bf6d                	j	80004ab0 <filewrite+0x10e>
    80004af8:	557d                	li	a0,-1
    80004afa:	bf5d                	j	80004ab0 <filewrite+0x10e>

0000000080004afc <pipealloc>:
    int readopen;  // read fd is still open
    int writeopen; // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1)
{
    80004afc:	7179                	addi	sp,sp,-48
    80004afe:	f406                	sd	ra,40(sp)
    80004b00:	f022                	sd	s0,32(sp)
    80004b02:	ec26                	sd	s1,24(sp)
    80004b04:	e84a                	sd	s2,16(sp)
    80004b06:	e44e                	sd	s3,8(sp)
    80004b08:	e052                	sd	s4,0(sp)
    80004b0a:	1800                	addi	s0,sp,48
    80004b0c:	84aa                	mv	s1,a0
    80004b0e:	8a2e                	mv	s4,a1
    struct pipe *pi;

    pi = 0;
    *f0 = *f1 = 0;
    80004b10:	0005b023          	sd	zero,0(a1)
    80004b14:	00053023          	sd	zero,0(a0)
    if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004b18:	00000097          	auipc	ra,0x0
    80004b1c:	bd0080e7          	jalr	-1072(ra) # 800046e8 <filealloc>
    80004b20:	e088                	sd	a0,0(s1)
    80004b22:	c551                	beqz	a0,80004bae <pipealloc+0xb2>
    80004b24:	00000097          	auipc	ra,0x0
    80004b28:	bc4080e7          	jalr	-1084(ra) # 800046e8 <filealloc>
    80004b2c:	00aa3023          	sd	a0,0(s4)
    80004b30:	c92d                	beqz	a0,80004ba2 <pipealloc+0xa6>
        goto bad;
    if ((pi = (struct pipe *)kalloc()) == 0)
    80004b32:	ffffc097          	auipc	ra,0xffffc
    80004b36:	fdc080e7          	jalr	-36(ra) # 80000b0e <kalloc>
    80004b3a:	892a                	mv	s2,a0
    80004b3c:	c125                	beqz	a0,80004b9c <pipealloc+0xa0>
        goto bad;
    pi->readopen = 1;
    80004b3e:	4985                	li	s3,1
    80004b40:	23352023          	sw	s3,544(a0)
    pi->writeopen = 1;
    80004b44:	23352223          	sw	s3,548(a0)
    pi->nwrite = 0;
    80004b48:	20052e23          	sw	zero,540(a0)
    pi->nread = 0;
    80004b4c:	20052c23          	sw	zero,536(a0)
    initlock(&pi->lock, "pipe");
    80004b50:	00004597          	auipc	a1,0x4
    80004b54:	cd058593          	addi	a1,a1,-816 # 80008820 <syscalls+0x3f8>
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	016080e7          	jalr	22(ra) # 80000b6e <initlock>
    (*f0)->type = FD_PIPE;
    80004b60:	609c                	ld	a5,0(s1)
    80004b62:	0137a023          	sw	s3,0(a5)
    (*f0)->readable = 1;
    80004b66:	609c                	ld	a5,0(s1)
    80004b68:	01378423          	sb	s3,8(a5)
    (*f0)->writable = 0;
    80004b6c:	609c                	ld	a5,0(s1)
    80004b6e:	000784a3          	sb	zero,9(a5)
    (*f0)->pipe = pi;
    80004b72:	609c                	ld	a5,0(s1)
    80004b74:	0127b823          	sd	s2,16(a5)
    (*f1)->type = FD_PIPE;
    80004b78:	000a3783          	ld	a5,0(s4)
    80004b7c:	0137a023          	sw	s3,0(a5)
    (*f1)->readable = 0;
    80004b80:	000a3783          	ld	a5,0(s4)
    80004b84:	00078423          	sb	zero,8(a5)
    (*f1)->writable = 1;
    80004b88:	000a3783          	ld	a5,0(s4)
    80004b8c:	013784a3          	sb	s3,9(a5)
    (*f1)->pipe = pi;
    80004b90:	000a3783          	ld	a5,0(s4)
    80004b94:	0127b823          	sd	s2,16(a5)
    return 0;
    80004b98:	4501                	li	a0,0
    80004b9a:	a025                	j	80004bc2 <pipealloc+0xc6>

bad:
    if (pi)
        kfree((char *)pi);
    if (*f0)
    80004b9c:	6088                	ld	a0,0(s1)
    80004b9e:	e501                	bnez	a0,80004ba6 <pipealloc+0xaa>
    80004ba0:	a039                	j	80004bae <pipealloc+0xb2>
    80004ba2:	6088                	ld	a0,0(s1)
    80004ba4:	c51d                	beqz	a0,80004bd2 <pipealloc+0xd6>
        fileclose(*f0);
    80004ba6:	00000097          	auipc	ra,0x0
    80004baa:	bfe080e7          	jalr	-1026(ra) # 800047a4 <fileclose>
    if (*f1)
    80004bae:	000a3783          	ld	a5,0(s4)
        fileclose(*f1);
    return -1;
    80004bb2:	557d                	li	a0,-1
    if (*f1)
    80004bb4:	c799                	beqz	a5,80004bc2 <pipealloc+0xc6>
        fileclose(*f1);
    80004bb6:	853e                	mv	a0,a5
    80004bb8:	00000097          	auipc	ra,0x0
    80004bbc:	bec080e7          	jalr	-1044(ra) # 800047a4 <fileclose>
    return -1;
    80004bc0:	557d                	li	a0,-1
}
    80004bc2:	70a2                	ld	ra,40(sp)
    80004bc4:	7402                	ld	s0,32(sp)
    80004bc6:	64e2                	ld	s1,24(sp)
    80004bc8:	6942                	ld	s2,16(sp)
    80004bca:	69a2                	ld	s3,8(sp)
    80004bcc:	6a02                	ld	s4,0(sp)
    80004bce:	6145                	addi	sp,sp,48
    80004bd0:	8082                	ret
    return -1;
    80004bd2:	557d                	li	a0,-1
    80004bd4:	b7fd                	j	80004bc2 <pipealloc+0xc6>

0000000080004bd6 <pipeclose>:

void pipeclose(struct pipe *pi, int writable)
{
    80004bd6:	1101                	addi	sp,sp,-32
    80004bd8:	ec06                	sd	ra,24(sp)
    80004bda:	e822                	sd	s0,16(sp)
    80004bdc:	e426                	sd	s1,8(sp)
    80004bde:	e04a                	sd	s2,0(sp)
    80004be0:	1000                	addi	s0,sp,32
    80004be2:	84aa                	mv	s1,a0
    80004be4:	892e                	mv	s2,a1
    acquire(&pi->lock);
    80004be6:	ffffc097          	auipc	ra,0xffffc
    80004bea:	018080e7          	jalr	24(ra) # 80000bfe <acquire>
    if (writable)
    80004bee:	02090d63          	beqz	s2,80004c28 <pipeclose+0x52>
    {
        pi->writeopen = 0;
    80004bf2:	2204a223          	sw	zero,548(s1)
        wakeup(&pi->nread);
    80004bf6:	21848513          	addi	a0,s1,536
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	760080e7          	jalr	1888(ra) # 8000235a <wakeup>
    else
    {
        pi->readopen = 0;
        wakeup(&pi->nwrite);
    }
    if (pi->readopen == 0 && pi->writeopen == 0)
    80004c02:	2204b783          	ld	a5,544(s1)
    80004c06:	eb95                	bnez	a5,80004c3a <pipeclose+0x64>
    {
        release(&pi->lock);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	ffffc097          	auipc	ra,0xffffc
    80004c0e:	0a8080e7          	jalr	168(ra) # 80000cb2 <release>
        kfree((char *)pi);
    80004c12:	8526                	mv	a0,s1
    80004c14:	ffffc097          	auipc	ra,0xffffc
    80004c18:	dfe080e7          	jalr	-514(ra) # 80000a12 <kfree>
    }
    else
        release(&pi->lock);
}
    80004c1c:	60e2                	ld	ra,24(sp)
    80004c1e:	6442                	ld	s0,16(sp)
    80004c20:	64a2                	ld	s1,8(sp)
    80004c22:	6902                	ld	s2,0(sp)
    80004c24:	6105                	addi	sp,sp,32
    80004c26:	8082                	ret
        pi->readopen = 0;
    80004c28:	2204a023          	sw	zero,544(s1)
        wakeup(&pi->nwrite);
    80004c2c:	21c48513          	addi	a0,s1,540
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	72a080e7          	jalr	1834(ra) # 8000235a <wakeup>
    80004c38:	b7e9                	j	80004c02 <pipeclose+0x2c>
        release(&pi->lock);
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	ffffc097          	auipc	ra,0xffffc
    80004c40:	076080e7          	jalr	118(ra) # 80000cb2 <release>
}
    80004c44:	bfe1                	j	80004c1c <pipeclose+0x46>

0000000080004c46 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004c46:	711d                	addi	sp,sp,-96
    80004c48:	ec86                	sd	ra,88(sp)
    80004c4a:	e8a2                	sd	s0,80(sp)
    80004c4c:	e4a6                	sd	s1,72(sp)
    80004c4e:	e0ca                	sd	s2,64(sp)
    80004c50:	fc4e                	sd	s3,56(sp)
    80004c52:	f852                	sd	s4,48(sp)
    80004c54:	f456                	sd	s5,40(sp)
    80004c56:	f05a                	sd	s6,32(sp)
    80004c58:	ec5e                	sd	s7,24(sp)
    80004c5a:	e862                	sd	s8,16(sp)
    80004c5c:	1080                	addi	s0,sp,96
    80004c5e:	84aa                	mv	s1,a0
    80004c60:	8b2e                	mv	s6,a1
    80004c62:	8ab2                	mv	s5,a2
    int i;
    char ch;
    struct proc *pr = myproc();
    80004c64:	ffffd097          	auipc	ra,0xffffd
    80004c68:	d66080e7          	jalr	-666(ra) # 800019ca <myproc>
    80004c6c:	892a                	mv	s2,a0

    acquire(&pi->lock);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ffffc097          	auipc	ra,0xffffc
    80004c74:	f8e080e7          	jalr	-114(ra) # 80000bfe <acquire>
    for (i = 0; i < n; i++)
    80004c78:	09505763          	blez	s5,80004d06 <pipewrite+0xc0>
    80004c7c:	4b81                	li	s7,0
            if (pi->readopen == 0 || pr->killed)
            {
                release(&pi->lock);
                return -1;
            }
            wakeup(&pi->nread);
    80004c7e:	21848a13          	addi	s4,s1,536
            sleep(&pi->nwrite, &pi->lock);
    80004c82:	21c48993          	addi	s3,s1,540
        }
        if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c86:	5c7d                	li	s8,-1
        while (pi->nwrite == pi->nread + PIPESIZE)
    80004c88:	2184a783          	lw	a5,536(s1)
    80004c8c:	21c4a703          	lw	a4,540(s1)
    80004c90:	2007879b          	addiw	a5,a5,512
    80004c94:	02f71b63          	bne	a4,a5,80004cca <pipewrite+0x84>
            if (pi->readopen == 0 || pr->killed)
    80004c98:	2204a783          	lw	a5,544(s1)
    80004c9c:	c3d1                	beqz	a5,80004d20 <pipewrite+0xda>
    80004c9e:	03092783          	lw	a5,48(s2)
    80004ca2:	efbd                	bnez	a5,80004d20 <pipewrite+0xda>
            wakeup(&pi->nread);
    80004ca4:	8552                	mv	a0,s4
    80004ca6:	ffffd097          	auipc	ra,0xffffd
    80004caa:	6b4080e7          	jalr	1716(ra) # 8000235a <wakeup>
            sleep(&pi->nwrite, &pi->lock);
    80004cae:	85a6                	mv	a1,s1
    80004cb0:	854e                	mv	a0,s3
    80004cb2:	ffffd097          	auipc	ra,0xffffd
    80004cb6:	528080e7          	jalr	1320(ra) # 800021da <sleep>
        while (pi->nwrite == pi->nread + PIPESIZE)
    80004cba:	2184a783          	lw	a5,536(s1)
    80004cbe:	21c4a703          	lw	a4,540(s1)
    80004cc2:	2007879b          	addiw	a5,a5,512
    80004cc6:	fcf709e3          	beq	a4,a5,80004c98 <pipewrite+0x52>
        if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004cca:	4685                	li	a3,1
    80004ccc:	865a                	mv	a2,s6
    80004cce:	faf40593          	addi	a1,s0,-81
    80004cd2:	05093503          	ld	a0,80(s2)
    80004cd6:	ffffd097          	auipc	ra,0xffffd
    80004cda:	a72080e7          	jalr	-1422(ra) # 80001748 <copyin>
    80004cde:	03850563          	beq	a0,s8,80004d08 <pipewrite+0xc2>
            break;
        pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ce2:	21c4a783          	lw	a5,540(s1)
    80004ce6:	0017871b          	addiw	a4,a5,1
    80004cea:	20e4ae23          	sw	a4,540(s1)
    80004cee:	1ff7f793          	andi	a5,a5,511
    80004cf2:	97a6                	add	a5,a5,s1
    80004cf4:	faf44703          	lbu	a4,-81(s0)
    80004cf8:	00e78c23          	sb	a4,24(a5)
    for (i = 0; i < n; i++)
    80004cfc:	2b85                	addiw	s7,s7,1
    80004cfe:	0b05                	addi	s6,s6,1
    80004d00:	f97a94e3          	bne	s5,s7,80004c88 <pipewrite+0x42>
    80004d04:	a011                	j	80004d08 <pipewrite+0xc2>
    80004d06:	4b81                	li	s7,0
    }
    wakeup(&pi->nread);
    80004d08:	21848513          	addi	a0,s1,536
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	64e080e7          	jalr	1614(ra) # 8000235a <wakeup>
    release(&pi->lock);
    80004d14:	8526                	mv	a0,s1
    80004d16:	ffffc097          	auipc	ra,0xffffc
    80004d1a:	f9c080e7          	jalr	-100(ra) # 80000cb2 <release>
    return i;
    80004d1e:	a039                	j	80004d2c <pipewrite+0xe6>
                release(&pi->lock);
    80004d20:	8526                	mv	a0,s1
    80004d22:	ffffc097          	auipc	ra,0xffffc
    80004d26:	f90080e7          	jalr	-112(ra) # 80000cb2 <release>
                return -1;
    80004d2a:	5bfd                	li	s7,-1
}
    80004d2c:	855e                	mv	a0,s7
    80004d2e:	60e6                	ld	ra,88(sp)
    80004d30:	6446                	ld	s0,80(sp)
    80004d32:	64a6                	ld	s1,72(sp)
    80004d34:	6906                	ld	s2,64(sp)
    80004d36:	79e2                	ld	s3,56(sp)
    80004d38:	7a42                	ld	s4,48(sp)
    80004d3a:	7aa2                	ld	s5,40(sp)
    80004d3c:	7b02                	ld	s6,32(sp)
    80004d3e:	6be2                	ld	s7,24(sp)
    80004d40:	6c42                	ld	s8,16(sp)
    80004d42:	6125                	addi	sp,sp,96
    80004d44:	8082                	ret

0000000080004d46 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n)
{
    80004d46:	715d                	addi	sp,sp,-80
    80004d48:	e486                	sd	ra,72(sp)
    80004d4a:	e0a2                	sd	s0,64(sp)
    80004d4c:	fc26                	sd	s1,56(sp)
    80004d4e:	f84a                	sd	s2,48(sp)
    80004d50:	f44e                	sd	s3,40(sp)
    80004d52:	f052                	sd	s4,32(sp)
    80004d54:	ec56                	sd	s5,24(sp)
    80004d56:	e85a                	sd	s6,16(sp)
    80004d58:	0880                	addi	s0,sp,80
    80004d5a:	84aa                	mv	s1,a0
    80004d5c:	892e                	mv	s2,a1
    80004d5e:	8ab2                	mv	s5,a2
    int i;
    struct proc *pr = myproc();
    80004d60:	ffffd097          	auipc	ra,0xffffd
    80004d64:	c6a080e7          	jalr	-918(ra) # 800019ca <myproc>
    80004d68:	8a2a                	mv	s4,a0
    char ch;

    acquire(&pi->lock);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	ffffc097          	auipc	ra,0xffffc
    80004d70:	e92080e7          	jalr	-366(ra) # 80000bfe <acquire>
    while (pi->nread == pi->nwrite && pi->writeopen)
    80004d74:	2184a703          	lw	a4,536(s1)
    80004d78:	21c4a783          	lw	a5,540(s1)
        if (pr->killed)
        {
            release(&pi->lock);
            return -1;
        }
        sleep(&pi->nread, &pi->lock); // DOC: piperead-sleep
    80004d7c:	21848993          	addi	s3,s1,536
    while (pi->nread == pi->nwrite && pi->writeopen)
    80004d80:	02f71463          	bne	a4,a5,80004da8 <piperead+0x62>
    80004d84:	2244a783          	lw	a5,548(s1)
    80004d88:	c385                	beqz	a5,80004da8 <piperead+0x62>
        if (pr->killed)
    80004d8a:	030a2783          	lw	a5,48(s4)
    80004d8e:	ebc1                	bnez	a5,80004e1e <piperead+0xd8>
        sleep(&pi->nread, &pi->lock); // DOC: piperead-sleep
    80004d90:	85a6                	mv	a1,s1
    80004d92:	854e                	mv	a0,s3
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	446080e7          	jalr	1094(ra) # 800021da <sleep>
    while (pi->nread == pi->nwrite && pi->writeopen)
    80004d9c:	2184a703          	lw	a4,536(s1)
    80004da0:	21c4a783          	lw	a5,540(s1)
    80004da4:	fef700e3          	beq	a4,a5,80004d84 <piperead+0x3e>
    }
    for (i = 0; i < n; i++)
    80004da8:	4981                	li	s3,0
    { // DOC: piperead-copy
        if (pi->nread == pi->nwrite)
            break;
        ch = pi->data[pi->nread++ % PIPESIZE];
        if (copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004daa:	5b7d                	li	s6,-1
    for (i = 0; i < n; i++)
    80004dac:	05505363          	blez	s5,80004df2 <piperead+0xac>
        if (pi->nread == pi->nwrite)
    80004db0:	2184a783          	lw	a5,536(s1)
    80004db4:	21c4a703          	lw	a4,540(s1)
    80004db8:	02f70d63          	beq	a4,a5,80004df2 <piperead+0xac>
        ch = pi->data[pi->nread++ % PIPESIZE];
    80004dbc:	0017871b          	addiw	a4,a5,1
    80004dc0:	20e4ac23          	sw	a4,536(s1)
    80004dc4:	1ff7f793          	andi	a5,a5,511
    80004dc8:	97a6                	add	a5,a5,s1
    80004dca:	0187c783          	lbu	a5,24(a5)
    80004dce:	faf40fa3          	sb	a5,-65(s0)
        if (copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004dd2:	4685                	li	a3,1
    80004dd4:	fbf40613          	addi	a2,s0,-65
    80004dd8:	85ca                	mv	a1,s2
    80004dda:	050a3503          	ld	a0,80(s4)
    80004dde:	ffffd097          	auipc	ra,0xffffd
    80004de2:	8de080e7          	jalr	-1826(ra) # 800016bc <copyout>
    80004de6:	01650663          	beq	a0,s6,80004df2 <piperead+0xac>
    for (i = 0; i < n; i++)
    80004dea:	2985                	addiw	s3,s3,1
    80004dec:	0905                	addi	s2,s2,1
    80004dee:	fd3a91e3          	bne	s5,s3,80004db0 <piperead+0x6a>
            break;
    }
    wakeup(&pi->nwrite); // DOC: piperead-wakeup
    80004df2:	21c48513          	addi	a0,s1,540
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	564080e7          	jalr	1380(ra) # 8000235a <wakeup>
    release(&pi->lock);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	ffffc097          	auipc	ra,0xffffc
    80004e04:	eb2080e7          	jalr	-334(ra) # 80000cb2 <release>
    return i;
}
    80004e08:	854e                	mv	a0,s3
    80004e0a:	60a6                	ld	ra,72(sp)
    80004e0c:	6406                	ld	s0,64(sp)
    80004e0e:	74e2                	ld	s1,56(sp)
    80004e10:	7942                	ld	s2,48(sp)
    80004e12:	79a2                	ld	s3,40(sp)
    80004e14:	7a02                	ld	s4,32(sp)
    80004e16:	6ae2                	ld	s5,24(sp)
    80004e18:	6b42                	ld	s6,16(sp)
    80004e1a:	6161                	addi	sp,sp,80
    80004e1c:	8082                	ret
            release(&pi->lock);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffc097          	auipc	ra,0xffffc
    80004e24:	e92080e7          	jalr	-366(ra) # 80000cb2 <release>
            return -1;
    80004e28:	59fd                	li	s3,-1
    80004e2a:	bff9                	j	80004e08 <piperead+0xc2>

0000000080004e2c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv)
{
    80004e2c:	de010113          	addi	sp,sp,-544
    80004e30:	20113c23          	sd	ra,536(sp)
    80004e34:	20813823          	sd	s0,528(sp)
    80004e38:	20913423          	sd	s1,520(sp)
    80004e3c:	21213023          	sd	s2,512(sp)
    80004e40:	ffce                	sd	s3,504(sp)
    80004e42:	fbd2                	sd	s4,496(sp)
    80004e44:	f7d6                	sd	s5,488(sp)
    80004e46:	f3da                	sd	s6,480(sp)
    80004e48:	efde                	sd	s7,472(sp)
    80004e4a:	ebe2                	sd	s8,464(sp)
    80004e4c:	e7e6                	sd	s9,456(sp)
    80004e4e:	e3ea                	sd	s10,448(sp)
    80004e50:	ff6e                	sd	s11,440(sp)
    80004e52:	1400                	addi	s0,sp,544
    80004e54:	892a                	mv	s2,a0
    80004e56:	dea43423          	sd	a0,-536(s0)
    80004e5a:	deb43823          	sd	a1,-528(s0)
    uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0, oldpagetable;
    struct proc *p = myproc();
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	b6c080e7          	jalr	-1172(ra) # 800019ca <myproc>
    80004e66:	84aa                	mv	s1,a0

    begin_op();
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	46a080e7          	jalr	1130(ra) # 800042d2 <begin_op>

    if ((ip = namei(path)) == 0)
    80004e70:	854a                	mv	a0,s2
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	062080e7          	jalr	98(ra) # 80003ed4 <namei>
    80004e7a:	c93d                	beqz	a0,80004ef0 <exec+0xc4>
    80004e7c:	8aaa                	mv	s5,a0
    {
        end_op();
        return -1;
    }
    ilock(ip);
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	782080e7          	jalr	1922(ra) # 80003600 <ilock>

    // Check ELF header
    if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e86:	04000713          	li	a4,64
    80004e8a:	4681                	li	a3,0
    80004e8c:	e4840613          	addi	a2,s0,-440
    80004e90:	4581                	li	a1,0
    80004e92:	8556                	mv	a0,s5
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	b46080e7          	jalr	-1210(ra) # 800039da <readi>
    80004e9c:	04000793          	li	a5,64
    80004ea0:	00f51a63          	bne	a0,a5,80004eb4 <exec+0x88>
        goto bad;
    if (elf.magic != ELF_MAGIC)
    80004ea4:	e4842703          	lw	a4,-440(s0)
    80004ea8:	464c47b7          	lui	a5,0x464c4
    80004eac:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004eb0:	04f70663          	beq	a4,a5,80004efc <exec+0xd0>
bad:
    if (pagetable)
        proc_freepagetable(pagetable, sz);
    if (ip)
    {
        iunlockput(ip);
    80004eb4:	8556                	mv	a0,s5
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	aca080e7          	jalr	-1334(ra) # 80003980 <iunlockput>
        end_op();
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	494080e7          	jalr	1172(ra) # 80004352 <end_op>
    }
    return -1;
    80004ec6:	557d                	li	a0,-1
}
    80004ec8:	21813083          	ld	ra,536(sp)
    80004ecc:	21013403          	ld	s0,528(sp)
    80004ed0:	20813483          	ld	s1,520(sp)
    80004ed4:	20013903          	ld	s2,512(sp)
    80004ed8:	79fe                	ld	s3,504(sp)
    80004eda:	7a5e                	ld	s4,496(sp)
    80004edc:	7abe                	ld	s5,488(sp)
    80004ede:	7b1e                	ld	s6,480(sp)
    80004ee0:	6bfe                	ld	s7,472(sp)
    80004ee2:	6c5e                	ld	s8,464(sp)
    80004ee4:	6cbe                	ld	s9,456(sp)
    80004ee6:	6d1e                	ld	s10,448(sp)
    80004ee8:	7dfa                	ld	s11,440(sp)
    80004eea:	22010113          	addi	sp,sp,544
    80004eee:	8082                	ret
        end_op();
    80004ef0:	fffff097          	auipc	ra,0xfffff
    80004ef4:	462080e7          	jalr	1122(ra) # 80004352 <end_op>
        return -1;
    80004ef8:	557d                	li	a0,-1
    80004efa:	b7f9                	j	80004ec8 <exec+0x9c>
    if ((pagetable = proc_pagetable(p)) == 0)
    80004efc:	8526                	mv	a0,s1
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	b90080e7          	jalr	-1136(ra) # 80001a8e <proc_pagetable>
    80004f06:	8b2a                	mv	s6,a0
    80004f08:	d555                	beqz	a0,80004eb4 <exec+0x88>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004f0a:	e6842783          	lw	a5,-408(s0)
    80004f0e:	e8045703          	lhu	a4,-384(s0)
    80004f12:	c735                	beqz	a4,80004f7e <exec+0x152>
    uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80004f14:	4481                	li	s1,0
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004f16:	e0043423          	sd	zero,-504(s0)
        if (ph.vaddr % PGSIZE != 0)
    80004f1a:	6a05                	lui	s4,0x1
    80004f1c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004f20:	dee43023          	sd	a4,-544(s0)
    uint64 pa;

    if ((va % PGSIZE) != 0)
        panic("loadseg: va must be page aligned");

    for (i = 0; i < sz; i += PGSIZE)
    80004f24:	6d85                	lui	s11,0x1
    80004f26:	7d7d                	lui	s10,0xfffff
    80004f28:	ac1d                	j	8000515e <exec+0x332>
    {
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
    80004f2a:	00004517          	auipc	a0,0x4
    80004f2e:	8fe50513          	addi	a0,a0,-1794 # 80008828 <syscalls+0x400>
    80004f32:	ffffb097          	auipc	ra,0xffffb
    80004f36:	610080e7          	jalr	1552(ra) # 80000542 <panic>
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004f3a:	874a                	mv	a4,s2
    80004f3c:	009c86bb          	addw	a3,s9,s1
    80004f40:	4581                	li	a1,0
    80004f42:	8556                	mv	a0,s5
    80004f44:	fffff097          	auipc	ra,0xfffff
    80004f48:	a96080e7          	jalr	-1386(ra) # 800039da <readi>
    80004f4c:	2501                	sext.w	a0,a0
    80004f4e:	1aa91863          	bne	s2,a0,800050fe <exec+0x2d2>
    for (i = 0; i < sz; i += PGSIZE)
    80004f52:	009d84bb          	addw	s1,s11,s1
    80004f56:	013d09bb          	addw	s3,s10,s3
    80004f5a:	1f74f263          	bgeu	s1,s7,8000513e <exec+0x312>
        pa = walkaddr(pagetable, va + i);
    80004f5e:	02049593          	slli	a1,s1,0x20
    80004f62:	9181                	srli	a1,a1,0x20
    80004f64:	95e2                	add	a1,a1,s8
    80004f66:	855a                	mv	a0,s6
    80004f68:	ffffc097          	auipc	ra,0xffffc
    80004f6c:	120080e7          	jalr	288(ra) # 80001088 <walkaddr>
    80004f70:	862a                	mv	a2,a0
        if (pa == 0)
    80004f72:	dd45                	beqz	a0,80004f2a <exec+0xfe>
            n = PGSIZE;
    80004f74:	8952                	mv	s2,s4
        if (sz - i < PGSIZE)
    80004f76:	fd49f2e3          	bgeu	s3,s4,80004f3a <exec+0x10e>
            n = sz - i;
    80004f7a:	894e                	mv	s2,s3
    80004f7c:	bf7d                	j	80004f3a <exec+0x10e>
    uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80004f7e:	4481                	li	s1,0
    iunlockput(ip);
    80004f80:	8556                	mv	a0,s5
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	9fe080e7          	jalr	-1538(ra) # 80003980 <iunlockput>
    end_op();
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	3c8080e7          	jalr	968(ra) # 80004352 <end_op>
    p = myproc();
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	a38080e7          	jalr	-1480(ra) # 800019ca <myproc>
    80004f9a:	8baa                	mv	s7,a0
    uint64 oldsz = p->sz;
    80004f9c:	04853d03          	ld	s10,72(a0)
    sz = PGROUNDUP(sz);
    80004fa0:	6785                	lui	a5,0x1
    80004fa2:	17fd                	addi	a5,a5,-1
    80004fa4:	94be                	add	s1,s1,a5
    80004fa6:	77fd                	lui	a5,0xfffff
    80004fa8:	8fe5                	and	a5,a5,s1
    80004faa:	def43c23          	sd	a5,-520(s0)
    if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80004fae:	6609                	lui	a2,0x2
    80004fb0:	963e                	add	a2,a2,a5
    80004fb2:	85be                	mv	a1,a5
    80004fb4:	855a                	mv	a0,s6
    80004fb6:	ffffc097          	auipc	ra,0xffffc
    80004fba:	4b6080e7          	jalr	1206(ra) # 8000146c <uvmalloc>
    80004fbe:	8c2a                	mv	s8,a0
    ip = 0;
    80004fc0:	4a81                	li	s5,0
    if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80004fc2:	12050e63          	beqz	a0,800050fe <exec+0x2d2>
    uvmclear(pagetable, sz - 2 * PGSIZE);
    80004fc6:	75f9                	lui	a1,0xffffe
    80004fc8:	95aa                	add	a1,a1,a0
    80004fca:	855a                	mv	a0,s6
    80004fcc:	ffffc097          	auipc	ra,0xffffc
    80004fd0:	6be080e7          	jalr	1726(ra) # 8000168a <uvmclear>
    stackbase = sp - PGSIZE;
    80004fd4:	7afd                	lui	s5,0xfffff
    80004fd6:	9ae2                	add	s5,s5,s8
    for (argc = 0; argv[argc]; argc++)
    80004fd8:	df043783          	ld	a5,-528(s0)
    80004fdc:	6388                	ld	a0,0(a5)
    80004fde:	c925                	beqz	a0,8000504e <exec+0x222>
    80004fe0:	e8840993          	addi	s3,s0,-376
    80004fe4:	f8840c93          	addi	s9,s0,-120
    sp = sz;
    80004fe8:	8962                	mv	s2,s8
    for (argc = 0; argv[argc]; argc++)
    80004fea:	4481                	li	s1,0
        sp -= strlen(argv[argc]) + 1;
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	e92080e7          	jalr	-366(ra) # 80000e7e <strlen>
    80004ff4:	0015079b          	addiw	a5,a0,1
    80004ff8:	40f90933          	sub	s2,s2,a5
        sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ffc:	ff097913          	andi	s2,s2,-16
        if (sp < stackbase)
    80005000:	13596363          	bltu	s2,s5,80005126 <exec+0x2fa>
        if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005004:	df043d83          	ld	s11,-528(s0)
    80005008:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000500c:	8552                	mv	a0,s4
    8000500e:	ffffc097          	auipc	ra,0xffffc
    80005012:	e70080e7          	jalr	-400(ra) # 80000e7e <strlen>
    80005016:	0015069b          	addiw	a3,a0,1
    8000501a:	8652                	mv	a2,s4
    8000501c:	85ca                	mv	a1,s2
    8000501e:	855a                	mv	a0,s6
    80005020:	ffffc097          	auipc	ra,0xffffc
    80005024:	69c080e7          	jalr	1692(ra) # 800016bc <copyout>
    80005028:	10054363          	bltz	a0,8000512e <exec+0x302>
        ustack[argc] = sp;
    8000502c:	0129b023          	sd	s2,0(s3)
    for (argc = 0; argv[argc]; argc++)
    80005030:	0485                	addi	s1,s1,1
    80005032:	008d8793          	addi	a5,s11,8
    80005036:	def43823          	sd	a5,-528(s0)
    8000503a:	008db503          	ld	a0,8(s11)
    8000503e:	c911                	beqz	a0,80005052 <exec+0x226>
        if (argc >= MAXARG)
    80005040:	09a1                	addi	s3,s3,8
    80005042:	fb3c95e3          	bne	s9,s3,80004fec <exec+0x1c0>
    sz = sz1;
    80005046:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    8000504a:	4a81                	li	s5,0
    8000504c:	a84d                	j	800050fe <exec+0x2d2>
    sp = sz;
    8000504e:	8962                	mv	s2,s8
    for (argc = 0; argv[argc]; argc++)
    80005050:	4481                	li	s1,0
    ustack[argc] = 0;
    80005052:	00349793          	slli	a5,s1,0x3
    80005056:	f9040713          	addi	a4,s0,-112
    8000505a:	97ba                	add	a5,a5,a4
    8000505c:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
    sp -= (argc + 1) * sizeof(uint64);
    80005060:	00148693          	addi	a3,s1,1
    80005064:	068e                	slli	a3,a3,0x3
    80005066:	40d90933          	sub	s2,s2,a3
    sp -= sp % 16;
    8000506a:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    8000506e:	01597663          	bgeu	s2,s5,8000507a <exec+0x24e>
    sz = sz1;
    80005072:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    80005076:	4a81                	li	s5,0
    80005078:	a059                	j	800050fe <exec+0x2d2>
    if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000507a:	e8840613          	addi	a2,s0,-376
    8000507e:	85ca                	mv	a1,s2
    80005080:	855a                	mv	a0,s6
    80005082:	ffffc097          	auipc	ra,0xffffc
    80005086:	63a080e7          	jalr	1594(ra) # 800016bc <copyout>
    8000508a:	0a054663          	bltz	a0,80005136 <exec+0x30a>
    p->trapframe->a1 = sp;
    8000508e:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80005092:	0727bc23          	sd	s2,120(a5)
    for (last = s = path; *s; s++)
    80005096:	de843783          	ld	a5,-536(s0)
    8000509a:	0007c703          	lbu	a4,0(a5)
    8000509e:	cf11                	beqz	a4,800050ba <exec+0x28e>
    800050a0:	0785                	addi	a5,a5,1
        if (*s == '/')
    800050a2:	02f00693          	li	a3,47
    800050a6:	a039                	j	800050b4 <exec+0x288>
            last = s + 1;
    800050a8:	def43423          	sd	a5,-536(s0)
    for (last = s = path; *s; s++)
    800050ac:	0785                	addi	a5,a5,1
    800050ae:	fff7c703          	lbu	a4,-1(a5)
    800050b2:	c701                	beqz	a4,800050ba <exec+0x28e>
        if (*s == '/')
    800050b4:	fed71ce3          	bne	a4,a3,800050ac <exec+0x280>
    800050b8:	bfc5                	j	800050a8 <exec+0x27c>
    safestrcpy(p->name, last, sizeof(p->name));
    800050ba:	4641                	li	a2,16
    800050bc:	de843583          	ld	a1,-536(s0)
    800050c0:	158b8513          	addi	a0,s7,344
    800050c4:	ffffc097          	auipc	ra,0xffffc
    800050c8:	d88080e7          	jalr	-632(ra) # 80000e4c <safestrcpy>
    oldpagetable = p->pagetable;
    800050cc:	050bb503          	ld	a0,80(s7)
    p->pagetable = pagetable;
    800050d0:	056bb823          	sd	s6,80(s7)
    p->sz = sz;
    800050d4:	058bb423          	sd	s8,72(s7)
    p->trapframe->epc = elf.entry; // initial program counter = main
    800050d8:	058bb783          	ld	a5,88(s7)
    800050dc:	e6043703          	ld	a4,-416(s0)
    800050e0:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sp;         // initial stack pointer
    800050e2:	058bb783          	ld	a5,88(s7)
    800050e6:	0327b823          	sd	s2,48(a5)
    proc_freepagetable(oldpagetable, oldsz);
    800050ea:	85ea                	mv	a1,s10
    800050ec:	ffffd097          	auipc	ra,0xffffd
    800050f0:	a3e080e7          	jalr	-1474(ra) # 80001b2a <proc_freepagetable>
    return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050f4:	0004851b          	sext.w	a0,s1
    800050f8:	bbc1                	j	80004ec8 <exec+0x9c>
    800050fa:	de943c23          	sd	s1,-520(s0)
        proc_freepagetable(pagetable, sz);
    800050fe:	df843583          	ld	a1,-520(s0)
    80005102:	855a                	mv	a0,s6
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	a26080e7          	jalr	-1498(ra) # 80001b2a <proc_freepagetable>
    if (ip)
    8000510c:	da0a94e3          	bnez	s5,80004eb4 <exec+0x88>
    return -1;
    80005110:	557d                	li	a0,-1
    80005112:	bb5d                	j	80004ec8 <exec+0x9c>
    80005114:	de943c23          	sd	s1,-520(s0)
    80005118:	b7dd                	j	800050fe <exec+0x2d2>
    8000511a:	de943c23          	sd	s1,-520(s0)
    8000511e:	b7c5                	j	800050fe <exec+0x2d2>
    80005120:	de943c23          	sd	s1,-520(s0)
    80005124:	bfe9                	j	800050fe <exec+0x2d2>
    sz = sz1;
    80005126:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    8000512a:	4a81                	li	s5,0
    8000512c:	bfc9                	j	800050fe <exec+0x2d2>
    sz = sz1;
    8000512e:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    80005132:	4a81                	li	s5,0
    80005134:	b7e9                	j	800050fe <exec+0x2d2>
    sz = sz1;
    80005136:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    8000513a:	4a81                	li	s5,0
    8000513c:	b7c9                	j	800050fe <exec+0x2d2>
        if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000513e:	df843483          	ld	s1,-520(s0)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80005142:	e0843783          	ld	a5,-504(s0)
    80005146:	0017869b          	addiw	a3,a5,1
    8000514a:	e0d43423          	sd	a3,-504(s0)
    8000514e:	e0043783          	ld	a5,-512(s0)
    80005152:	0387879b          	addiw	a5,a5,56
    80005156:	e8045703          	lhu	a4,-384(s0)
    8000515a:	e2e6d3e3          	bge	a3,a4,80004f80 <exec+0x154>
        if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000515e:	2781                	sext.w	a5,a5
    80005160:	e0f43023          	sd	a5,-512(s0)
    80005164:	03800713          	li	a4,56
    80005168:	86be                	mv	a3,a5
    8000516a:	e1040613          	addi	a2,s0,-496
    8000516e:	4581                	li	a1,0
    80005170:	8556                	mv	a0,s5
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	868080e7          	jalr	-1944(ra) # 800039da <readi>
    8000517a:	03800793          	li	a5,56
    8000517e:	f6f51ee3          	bne	a0,a5,800050fa <exec+0x2ce>
        if (ph.type != ELF_PROG_LOAD)
    80005182:	e1042783          	lw	a5,-496(s0)
    80005186:	4705                	li	a4,1
    80005188:	fae79de3          	bne	a5,a4,80005142 <exec+0x316>
        if (ph.memsz < ph.filesz)
    8000518c:	e3843603          	ld	a2,-456(s0)
    80005190:	e3043783          	ld	a5,-464(s0)
    80005194:	f8f660e3          	bltu	a2,a5,80005114 <exec+0x2e8>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    80005198:	e2043783          	ld	a5,-480(s0)
    8000519c:	963e                	add	a2,a2,a5
    8000519e:	f6f66ee3          	bltu	a2,a5,8000511a <exec+0x2ee>
        if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800051a2:	85a6                	mv	a1,s1
    800051a4:	855a                	mv	a0,s6
    800051a6:	ffffc097          	auipc	ra,0xffffc
    800051aa:	2c6080e7          	jalr	710(ra) # 8000146c <uvmalloc>
    800051ae:	dea43c23          	sd	a0,-520(s0)
    800051b2:	d53d                	beqz	a0,80005120 <exec+0x2f4>
        if (ph.vaddr % PGSIZE != 0)
    800051b4:	e2043c03          	ld	s8,-480(s0)
    800051b8:	de043783          	ld	a5,-544(s0)
    800051bc:	00fc77b3          	and	a5,s8,a5
    800051c0:	ff9d                	bnez	a5,800050fe <exec+0x2d2>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800051c2:	e1842c83          	lw	s9,-488(s0)
    800051c6:	e3042b83          	lw	s7,-464(s0)
    for (i = 0; i < sz; i += PGSIZE)
    800051ca:	f60b8ae3          	beqz	s7,8000513e <exec+0x312>
    800051ce:	89de                	mv	s3,s7
    800051d0:	4481                	li	s1,0
    800051d2:	b371                	j	80004f5e <exec+0x132>

00000000800051d4 <argfd>:
#include "buf.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf)
{
    800051d4:	7179                	addi	sp,sp,-48
    800051d6:	f406                	sd	ra,40(sp)
    800051d8:	f022                	sd	s0,32(sp)
    800051da:	ec26                	sd	s1,24(sp)
    800051dc:	e84a                	sd	s2,16(sp)
    800051de:	1800                	addi	s0,sp,48
    800051e0:	892e                	mv	s2,a1
    800051e2:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    if (argint(n, &fd) < 0)
    800051e4:	fdc40593          	addi	a1,s0,-36
    800051e8:	ffffe097          	auipc	ra,0xffffe
    800051ec:	898080e7          	jalr	-1896(ra) # 80002a80 <argint>
    800051f0:	04054063          	bltz	a0,80005230 <argfd+0x5c>
        return -1;
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    800051f4:	fdc42703          	lw	a4,-36(s0)
    800051f8:	47bd                	li	a5,15
    800051fa:	02e7ed63          	bltu	a5,a4,80005234 <argfd+0x60>
    800051fe:	ffffc097          	auipc	ra,0xffffc
    80005202:	7cc080e7          	jalr	1996(ra) # 800019ca <myproc>
    80005206:	fdc42703          	lw	a4,-36(s0)
    8000520a:	01a70793          	addi	a5,a4,26
    8000520e:	078e                	slli	a5,a5,0x3
    80005210:	953e                	add	a0,a0,a5
    80005212:	611c                	ld	a5,0(a0)
    80005214:	c395                	beqz	a5,80005238 <argfd+0x64>
        return -1;
    if (pfd)
    80005216:	00090463          	beqz	s2,8000521e <argfd+0x4a>
        *pfd = fd;
    8000521a:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    8000521e:	4501                	li	a0,0
    if (pf)
    80005220:	c091                	beqz	s1,80005224 <argfd+0x50>
        *pf = f;
    80005222:	e09c                	sd	a5,0(s1)
}
    80005224:	70a2                	ld	ra,40(sp)
    80005226:	7402                	ld	s0,32(sp)
    80005228:	64e2                	ld	s1,24(sp)
    8000522a:	6942                	ld	s2,16(sp)
    8000522c:	6145                	addi	sp,sp,48
    8000522e:	8082                	ret
        return -1;
    80005230:	557d                	li	a0,-1
    80005232:	bfcd                	j	80005224 <argfd+0x50>
        return -1;
    80005234:	557d                	li	a0,-1
    80005236:	b7fd                	j	80005224 <argfd+0x50>
    80005238:	557d                	li	a0,-1
    8000523a:	b7ed                	j	80005224 <argfd+0x50>

000000008000523c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f)
{
    8000523c:	1101                	addi	sp,sp,-32
    8000523e:	ec06                	sd	ra,24(sp)
    80005240:	e822                	sd	s0,16(sp)
    80005242:	e426                	sd	s1,8(sp)
    80005244:	1000                	addi	s0,sp,32
    80005246:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	782080e7          	jalr	1922(ra) # 800019ca <myproc>
    80005250:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    80005252:	0d050793          	addi	a5,a0,208
    80005256:	4501                	li	a0,0
    80005258:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    8000525a:	6398                	ld	a4,0(a5)
    8000525c:	cb19                	beqz	a4,80005272 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    8000525e:	2505                	addiw	a0,a0,1
    80005260:	07a1                	addi	a5,a5,8
    80005262:	fed51ce3          	bne	a0,a3,8000525a <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    80005266:	557d                	li	a0,-1
}
    80005268:	60e2                	ld	ra,24(sp)
    8000526a:	6442                	ld	s0,16(sp)
    8000526c:	64a2                	ld	s1,8(sp)
    8000526e:	6105                	addi	sp,sp,32
    80005270:	8082                	ret
            p->ofile[fd] = f;
    80005272:	01a50793          	addi	a5,a0,26
    80005276:	078e                	slli	a5,a5,0x3
    80005278:	963e                	add	a2,a2,a5
    8000527a:	e204                	sd	s1,0(a2)
            return fd;
    8000527c:	b7f5                	j	80005268 <fdalloc+0x2c>

000000008000527e <create>:
    end_op();
    return -1;
}

static struct inode *create(char *path, short type, short major, short minor)
{
    8000527e:	715d                	addi	sp,sp,-80
    80005280:	e486                	sd	ra,72(sp)
    80005282:	e0a2                	sd	s0,64(sp)
    80005284:	fc26                	sd	s1,56(sp)
    80005286:	f84a                	sd	s2,48(sp)
    80005288:	f44e                	sd	s3,40(sp)
    8000528a:	f052                	sd	s4,32(sp)
    8000528c:	ec56                	sd	s5,24(sp)
    8000528e:	0880                	addi	s0,sp,80
    80005290:	89ae                	mv	s3,a1
    80005292:	8ab2                	mv	s5,a2
    80005294:	8a36                	mv	s4,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    80005296:	fb040593          	addi	a1,s0,-80
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	e4a080e7          	jalr	-438(ra) # 800040e4 <nameiparent>
    800052a2:	892a                	mv	s2,a0
    800052a4:	12050e63          	beqz	a0,800053e0 <create+0x162>
        return 0;

    ilock(dp);
    800052a8:	ffffe097          	auipc	ra,0xffffe
    800052ac:	358080e7          	jalr	856(ra) # 80003600 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    800052b0:	4601                	li	a2,0
    800052b2:	fb040593          	addi	a1,s0,-80
    800052b6:	854a                	mv	a0,s2
    800052b8:	fffff097          	auipc	ra,0xfffff
    800052bc:	94a080e7          	jalr	-1718(ra) # 80003c02 <dirlookup>
    800052c0:	84aa                	mv	s1,a0
    800052c2:	c921                	beqz	a0,80005312 <create+0x94>
    {
        iunlockput(dp);
    800052c4:	854a                	mv	a0,s2
    800052c6:	ffffe097          	auipc	ra,0xffffe
    800052ca:	6ba080e7          	jalr	1722(ra) # 80003980 <iunlockput>
        ilock(ip);
    800052ce:	8526                	mv	a0,s1
    800052d0:	ffffe097          	auipc	ra,0xffffe
    800052d4:	330080e7          	jalr	816(ra) # 80003600 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800052d8:	2981                	sext.w	s3,s3
    800052da:	4789                	li	a5,2
    800052dc:	02f99463          	bne	s3,a5,80005304 <create+0x86>
    800052e0:	0444d783          	lhu	a5,68(s1)
    800052e4:	37f9                	addiw	a5,a5,-2
    800052e6:	17c2                	slli	a5,a5,0x30
    800052e8:	93c1                	srli	a5,a5,0x30
    800052ea:	4705                	li	a4,1
    800052ec:	00f76c63          	bltu	a4,a5,80005304 <create+0x86>
        panic("create: dirlink");

    iunlockput(dp);

    return ip;
}
    800052f0:	8526                	mv	a0,s1
    800052f2:	60a6                	ld	ra,72(sp)
    800052f4:	6406                	ld	s0,64(sp)
    800052f6:	74e2                	ld	s1,56(sp)
    800052f8:	7942                	ld	s2,48(sp)
    800052fa:	79a2                	ld	s3,40(sp)
    800052fc:	7a02                	ld	s4,32(sp)
    800052fe:	6ae2                	ld	s5,24(sp)
    80005300:	6161                	addi	sp,sp,80
    80005302:	8082                	ret
        iunlockput(ip);
    80005304:	8526                	mv	a0,s1
    80005306:	ffffe097          	auipc	ra,0xffffe
    8000530a:	67a080e7          	jalr	1658(ra) # 80003980 <iunlockput>
        return 0;
    8000530e:	4481                	li	s1,0
    80005310:	b7c5                	j	800052f0 <create+0x72>
    if ((ip = ialloc(dp->dev, type)) == 0)
    80005312:	85ce                	mv	a1,s3
    80005314:	00092503          	lw	a0,0(s2)
    80005318:	ffffe097          	auipc	ra,0xffffe
    8000531c:	146080e7          	jalr	326(ra) # 8000345e <ialloc>
    80005320:	84aa                	mv	s1,a0
    80005322:	c521                	beqz	a0,8000536a <create+0xec>
    ilock(ip);
    80005324:	ffffe097          	auipc	ra,0xffffe
    80005328:	2dc080e7          	jalr	732(ra) # 80003600 <ilock>
    ip->major = major;
    8000532c:	05549323          	sh	s5,70(s1)
    ip->minor = minor;
    80005330:	05449423          	sh	s4,72(s1)
    ip->nlink = 1;
    80005334:	4a05                	li	s4,1
    80005336:	05449523          	sh	s4,74(s1)
    iupdate(ip);
    8000533a:	8526                	mv	a0,s1
    8000533c:	ffffe097          	auipc	ra,0xffffe
    80005340:	1fa080e7          	jalr	506(ra) # 80003536 <iupdate>
    if (type == T_DIR)
    80005344:	2981                	sext.w	s3,s3
    80005346:	03498a63          	beq	s3,s4,8000537a <create+0xfc>
    if (dirlink(dp, name, ip->inum) < 0)
    8000534a:	40d0                	lw	a2,4(s1)
    8000534c:	fb040593          	addi	a1,s0,-80
    80005350:	854a                	mv	a0,s2
    80005352:	fffff097          	auipc	ra,0xfffff
    80005356:	ac0080e7          	jalr	-1344(ra) # 80003e12 <dirlink>
    8000535a:	06054b63          	bltz	a0,800053d0 <create+0x152>
    iunlockput(dp);
    8000535e:	854a                	mv	a0,s2
    80005360:	ffffe097          	auipc	ra,0xffffe
    80005364:	620080e7          	jalr	1568(ra) # 80003980 <iunlockput>
    return ip;
    80005368:	b761                	j	800052f0 <create+0x72>
        panic("create: ialloc");
    8000536a:	00003517          	auipc	a0,0x3
    8000536e:	4de50513          	addi	a0,a0,1246 # 80008848 <syscalls+0x420>
    80005372:	ffffb097          	auipc	ra,0xffffb
    80005376:	1d0080e7          	jalr	464(ra) # 80000542 <panic>
        dp->nlink++; // for ".."
    8000537a:	04a95783          	lhu	a5,74(s2)
    8000537e:	2785                	addiw	a5,a5,1
    80005380:	04f91523          	sh	a5,74(s2)
        iupdate(dp);
    80005384:	854a                	mv	a0,s2
    80005386:	ffffe097          	auipc	ra,0xffffe
    8000538a:	1b0080e7          	jalr	432(ra) # 80003536 <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000538e:	40d0                	lw	a2,4(s1)
    80005390:	00003597          	auipc	a1,0x3
    80005394:	3d058593          	addi	a1,a1,976 # 80008760 <syscalls+0x338>
    80005398:	8526                	mv	a0,s1
    8000539a:	fffff097          	auipc	ra,0xfffff
    8000539e:	a78080e7          	jalr	-1416(ra) # 80003e12 <dirlink>
    800053a2:	00054f63          	bltz	a0,800053c0 <create+0x142>
    800053a6:	00492603          	lw	a2,4(s2)
    800053aa:	00003597          	auipc	a1,0x3
    800053ae:	3be58593          	addi	a1,a1,958 # 80008768 <syscalls+0x340>
    800053b2:	8526                	mv	a0,s1
    800053b4:	fffff097          	auipc	ra,0xfffff
    800053b8:	a5e080e7          	jalr	-1442(ra) # 80003e12 <dirlink>
    800053bc:	f80557e3          	bgez	a0,8000534a <create+0xcc>
            panic("create dots");
    800053c0:	00003517          	auipc	a0,0x3
    800053c4:	49850513          	addi	a0,a0,1176 # 80008858 <syscalls+0x430>
    800053c8:	ffffb097          	auipc	ra,0xffffb
    800053cc:	17a080e7          	jalr	378(ra) # 80000542 <panic>
        panic("create: dirlink");
    800053d0:	00003517          	auipc	a0,0x3
    800053d4:	49850513          	addi	a0,a0,1176 # 80008868 <syscalls+0x440>
    800053d8:	ffffb097          	auipc	ra,0xffffb
    800053dc:	16a080e7          	jalr	362(ra) # 80000542 <panic>
        return 0;
    800053e0:	84aa                	mv	s1,a0
    800053e2:	b739                	j	800052f0 <create+0x72>

00000000800053e4 <sys_dup>:
{
    800053e4:	7179                	addi	sp,sp,-48
    800053e6:	f406                	sd	ra,40(sp)
    800053e8:	f022                	sd	s0,32(sp)
    800053ea:	ec26                	sd	s1,24(sp)
    800053ec:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    800053ee:	fd840613          	addi	a2,s0,-40
    800053f2:	4581                	li	a1,0
    800053f4:	4501                	li	a0,0
    800053f6:	00000097          	auipc	ra,0x0
    800053fa:	dde080e7          	jalr	-546(ra) # 800051d4 <argfd>
        return -1;
    800053fe:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    80005400:	02054363          	bltz	a0,80005426 <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    80005404:	fd843503          	ld	a0,-40(s0)
    80005408:	00000097          	auipc	ra,0x0
    8000540c:	e34080e7          	jalr	-460(ra) # 8000523c <fdalloc>
    80005410:	84aa                	mv	s1,a0
        return -1;
    80005412:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    80005414:	00054963          	bltz	a0,80005426 <sys_dup+0x42>
    filedup(f);
    80005418:	fd843503          	ld	a0,-40(s0)
    8000541c:	fffff097          	auipc	ra,0xfffff
    80005420:	336080e7          	jalr	822(ra) # 80004752 <filedup>
    return fd;
    80005424:	87a6                	mv	a5,s1
}
    80005426:	853e                	mv	a0,a5
    80005428:	70a2                	ld	ra,40(sp)
    8000542a:	7402                	ld	s0,32(sp)
    8000542c:	64e2                	ld	s1,24(sp)
    8000542e:	6145                	addi	sp,sp,48
    80005430:	8082                	ret

0000000080005432 <sys_read>:
{
    80005432:	7179                	addi	sp,sp,-48
    80005434:	f406                	sd	ra,40(sp)
    80005436:	f022                	sd	s0,32(sp)
    80005438:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000543a:	fe840613          	addi	a2,s0,-24
    8000543e:	4581                	li	a1,0
    80005440:	4501                	li	a0,0
    80005442:	00000097          	auipc	ra,0x0
    80005446:	d92080e7          	jalr	-622(ra) # 800051d4 <argfd>
        return -1;
    8000544a:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000544c:	04054563          	bltz	a0,80005496 <sys_read+0x64>
    80005450:	fe440593          	addi	a1,s0,-28
    80005454:	4509                	li	a0,2
    80005456:	ffffd097          	auipc	ra,0xffffd
    8000545a:	62a080e7          	jalr	1578(ra) # 80002a80 <argint>
        return -1;
    8000545e:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005460:	02054b63          	bltz	a0,80005496 <sys_read+0x64>
    80005464:	fd840593          	addi	a1,s0,-40
    80005468:	4505                	li	a0,1
    8000546a:	ffffd097          	auipc	ra,0xffffd
    8000546e:	638080e7          	jalr	1592(ra) # 80002aa2 <argaddr>
    80005472:	04054163          	bltz	a0,800054b4 <sys_read+0x82>
    if (!(f->ip->perm & M_READ)) {
    80005476:	fe843503          	ld	a0,-24(s0)
    8000547a:	6d1c                	ld	a5,24(a0)
    8000547c:	0867d783          	lhu	a5,134(a5)
    80005480:	8b85                	andi	a5,a5,1
    80005482:	cf99                	beqz	a5,800054a0 <sys_read+0x6e>
    return fileread(f, p, n);
    80005484:	fe442603          	lw	a2,-28(s0)
    80005488:	fd843583          	ld	a1,-40(s0)
    8000548c:	fffff097          	auipc	ra,0xfffff
    80005490:	454080e7          	jalr	1108(ra) # 800048e0 <fileread>
    80005494:	87aa                	mv	a5,a0
}
    80005496:	853e                	mv	a0,a5
    80005498:	70a2                	ld	ra,40(sp)
    8000549a:	7402                	ld	s0,32(sp)
    8000549c:	6145                	addi	sp,sp,48
    8000549e:	8082                	ret
        printf("read: permission denied\n");
    800054a0:	00003517          	auipc	a0,0x3
    800054a4:	3d850513          	addi	a0,a0,984 # 80008878 <syscalls+0x450>
    800054a8:	ffffb097          	auipc	ra,0xffffb
    800054ac:	0e4080e7          	jalr	228(ra) # 8000058c <printf>
        return -1;
    800054b0:	57fd                	li	a5,-1
    800054b2:	b7d5                	j	80005496 <sys_read+0x64>
        return -1;
    800054b4:	57fd                	li	a5,-1
    800054b6:	b7c5                	j	80005496 <sys_read+0x64>

00000000800054b8 <sys_write>:
{
    800054b8:	7179                	addi	sp,sp,-48
    800054ba:	f406                	sd	ra,40(sp)
    800054bc:	f022                	sd	s0,32(sp)
    800054be:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054c0:	fe840613          	addi	a2,s0,-24
    800054c4:	4581                	li	a1,0
    800054c6:	4501                	li	a0,0
    800054c8:	00000097          	auipc	ra,0x0
    800054cc:	d0c080e7          	jalr	-756(ra) # 800051d4 <argfd>
        return -1;
    800054d0:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054d2:	04054563          	bltz	a0,8000551c <sys_write+0x64>
    800054d6:	fe440593          	addi	a1,s0,-28
    800054da:	4509                	li	a0,2
    800054dc:	ffffd097          	auipc	ra,0xffffd
    800054e0:	5a4080e7          	jalr	1444(ra) # 80002a80 <argint>
        return -1;
    800054e4:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054e6:	02054b63          	bltz	a0,8000551c <sys_write+0x64>
    800054ea:	fd840593          	addi	a1,s0,-40
    800054ee:	4505                	li	a0,1
    800054f0:	ffffd097          	auipc	ra,0xffffd
    800054f4:	5b2080e7          	jalr	1458(ra) # 80002aa2 <argaddr>
    800054f8:	04054163          	bltz	a0,8000553a <sys_write+0x82>
    if (!(f->ip->perm & M_WRITE)) {
    800054fc:	fe843503          	ld	a0,-24(s0)
    80005500:	6d1c                	ld	a5,24(a0)
    80005502:	0867d783          	lhu	a5,134(a5)
    80005506:	8b89                	andi	a5,a5,2
    80005508:	cf99                	beqz	a5,80005526 <sys_write+0x6e>
    return filewrite(f, p, n);
    8000550a:	fe442603          	lw	a2,-28(s0)
    8000550e:	fd843583          	ld	a1,-40(s0)
    80005512:	fffff097          	auipc	ra,0xfffff
    80005516:	490080e7          	jalr	1168(ra) # 800049a2 <filewrite>
    8000551a:	87aa                	mv	a5,a0
}
    8000551c:	853e                	mv	a0,a5
    8000551e:	70a2                	ld	ra,40(sp)
    80005520:	7402                	ld	s0,32(sp)
    80005522:	6145                	addi	sp,sp,48
    80005524:	8082                	ret
        printf("write: permission denied\n");
    80005526:	00003517          	auipc	a0,0x3
    8000552a:	37250513          	addi	a0,a0,882 # 80008898 <syscalls+0x470>
    8000552e:	ffffb097          	auipc	ra,0xffffb
    80005532:	05e080e7          	jalr	94(ra) # 8000058c <printf>
        return -1;
    80005536:	57fd                	li	a5,-1
    80005538:	b7d5                	j	8000551c <sys_write+0x64>
        return -1;
    8000553a:	57fd                	li	a5,-1
    8000553c:	b7c5                	j	8000551c <sys_write+0x64>

000000008000553e <sys_close>:
{
    8000553e:	1101                	addi	sp,sp,-32
    80005540:	ec06                	sd	ra,24(sp)
    80005542:	e822                	sd	s0,16(sp)
    80005544:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    80005546:	fe040613          	addi	a2,s0,-32
    8000554a:	fec40593          	addi	a1,s0,-20
    8000554e:	4501                	li	a0,0
    80005550:	00000097          	auipc	ra,0x0
    80005554:	c84080e7          	jalr	-892(ra) # 800051d4 <argfd>
        return -1;
    80005558:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    8000555a:	02054463          	bltz	a0,80005582 <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    8000555e:	ffffc097          	auipc	ra,0xffffc
    80005562:	46c080e7          	jalr	1132(ra) # 800019ca <myproc>
    80005566:	fec42783          	lw	a5,-20(s0)
    8000556a:	07e9                	addi	a5,a5,26
    8000556c:	078e                	slli	a5,a5,0x3
    8000556e:	97aa                	add	a5,a5,a0
    80005570:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    80005574:	fe043503          	ld	a0,-32(s0)
    80005578:	fffff097          	auipc	ra,0xfffff
    8000557c:	22c080e7          	jalr	556(ra) # 800047a4 <fileclose>
    return 0;
    80005580:	4781                	li	a5,0
}
    80005582:	853e                	mv	a0,a5
    80005584:	60e2                	ld	ra,24(sp)
    80005586:	6442                	ld	s0,16(sp)
    80005588:	6105                	addi	sp,sp,32
    8000558a:	8082                	ret

000000008000558c <sys_fstat>:
{
    8000558c:	1101                	addi	sp,sp,-32
    8000558e:	ec06                	sd	ra,24(sp)
    80005590:	e822                	sd	s0,16(sp)
    80005592:	1000                	addi	s0,sp,32
    if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005594:	fe840613          	addi	a2,s0,-24
    80005598:	4581                	li	a1,0
    8000559a:	4501                	li	a0,0
    8000559c:	00000097          	auipc	ra,0x0
    800055a0:	c38080e7          	jalr	-968(ra) # 800051d4 <argfd>
        return -1;
    800055a4:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055a6:	02054563          	bltz	a0,800055d0 <sys_fstat+0x44>
    800055aa:	fe040593          	addi	a1,s0,-32
    800055ae:	4505                	li	a0,1
    800055b0:	ffffd097          	auipc	ra,0xffffd
    800055b4:	4f2080e7          	jalr	1266(ra) # 80002aa2 <argaddr>
        return -1;
    800055b8:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055ba:	00054b63          	bltz	a0,800055d0 <sys_fstat+0x44>
    return filestat(f, st);
    800055be:	fe043583          	ld	a1,-32(s0)
    800055c2:	fe843503          	ld	a0,-24(s0)
    800055c6:	fffff097          	auipc	ra,0xfffff
    800055ca:	2a6080e7          	jalr	678(ra) # 8000486c <filestat>
    800055ce:	87aa                	mv	a5,a0
}
    800055d0:	853e                	mv	a0,a5
    800055d2:	60e2                	ld	ra,24(sp)
    800055d4:	6442                	ld	s0,16(sp)
    800055d6:	6105                	addi	sp,sp,32
    800055d8:	8082                	ret

00000000800055da <sys_link>:
{
    800055da:	7169                	addi	sp,sp,-304
    800055dc:	f606                	sd	ra,296(sp)
    800055de:	f222                	sd	s0,288(sp)
    800055e0:	ee26                	sd	s1,280(sp)
    800055e2:	ea4a                	sd	s2,272(sp)
    800055e4:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055e6:	08000613          	li	a2,128
    800055ea:	ed040593          	addi	a1,s0,-304
    800055ee:	4501                	li	a0,0
    800055f0:	ffffd097          	auipc	ra,0xffffd
    800055f4:	4d4080e7          	jalr	1236(ra) # 80002ac4 <argstr>
        return -1;
    800055f8:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055fa:	10054e63          	bltz	a0,80005716 <sys_link+0x13c>
    800055fe:	08000613          	li	a2,128
    80005602:	f5040593          	addi	a1,s0,-176
    80005606:	4505                	li	a0,1
    80005608:	ffffd097          	auipc	ra,0xffffd
    8000560c:	4bc080e7          	jalr	1212(ra) # 80002ac4 <argstr>
        return -1;
    80005610:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005612:	10054263          	bltz	a0,80005716 <sys_link+0x13c>
    begin_op();
    80005616:	fffff097          	auipc	ra,0xfffff
    8000561a:	cbc080e7          	jalr	-836(ra) # 800042d2 <begin_op>
    if ((ip = namei(old)) == 0)
    8000561e:	ed040513          	addi	a0,s0,-304
    80005622:	fffff097          	auipc	ra,0xfffff
    80005626:	8b2080e7          	jalr	-1870(ra) # 80003ed4 <namei>
    8000562a:	84aa                	mv	s1,a0
    8000562c:	c551                	beqz	a0,800056b8 <sys_link+0xde>
    ilock(ip);
    8000562e:	ffffe097          	auipc	ra,0xffffe
    80005632:	fd2080e7          	jalr	-46(ra) # 80003600 <ilock>
    if (ip->type == T_DIR)
    80005636:	04449703          	lh	a4,68(s1)
    8000563a:	4785                	li	a5,1
    8000563c:	08f70463          	beq	a4,a5,800056c4 <sys_link+0xea>
    ip->nlink++;
    80005640:	04a4d783          	lhu	a5,74(s1)
    80005644:	2785                	addiw	a5,a5,1
    80005646:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    8000564a:	8526                	mv	a0,s1
    8000564c:	ffffe097          	auipc	ra,0xffffe
    80005650:	eea080e7          	jalr	-278(ra) # 80003536 <iupdate>
    iunlock(ip);
    80005654:	8526                	mv	a0,s1
    80005656:	ffffe097          	auipc	ra,0xffffe
    8000565a:	06c080e7          	jalr	108(ra) # 800036c2 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    8000565e:	fd040593          	addi	a1,s0,-48
    80005662:	f5040513          	addi	a0,s0,-176
    80005666:	fffff097          	auipc	ra,0xfffff
    8000566a:	a7e080e7          	jalr	-1410(ra) # 800040e4 <nameiparent>
    8000566e:	892a                	mv	s2,a0
    80005670:	c935                	beqz	a0,800056e4 <sys_link+0x10a>
    ilock(dp);
    80005672:	ffffe097          	auipc	ra,0xffffe
    80005676:	f8e080e7          	jalr	-114(ra) # 80003600 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    8000567a:	00092703          	lw	a4,0(s2)
    8000567e:	409c                	lw	a5,0(s1)
    80005680:	04f71d63          	bne	a4,a5,800056da <sys_link+0x100>
    80005684:	40d0                	lw	a2,4(s1)
    80005686:	fd040593          	addi	a1,s0,-48
    8000568a:	854a                	mv	a0,s2
    8000568c:	ffffe097          	auipc	ra,0xffffe
    80005690:	786080e7          	jalr	1926(ra) # 80003e12 <dirlink>
    80005694:	04054363          	bltz	a0,800056da <sys_link+0x100>
    iunlockput(dp);
    80005698:	854a                	mv	a0,s2
    8000569a:	ffffe097          	auipc	ra,0xffffe
    8000569e:	2e6080e7          	jalr	742(ra) # 80003980 <iunlockput>
    iput(ip);
    800056a2:	8526                	mv	a0,s1
    800056a4:	ffffe097          	auipc	ra,0xffffe
    800056a8:	234080e7          	jalr	564(ra) # 800038d8 <iput>
    end_op();
    800056ac:	fffff097          	auipc	ra,0xfffff
    800056b0:	ca6080e7          	jalr	-858(ra) # 80004352 <end_op>
    return 0;
    800056b4:	4781                	li	a5,0
    800056b6:	a085                	j	80005716 <sys_link+0x13c>
        end_op();
    800056b8:	fffff097          	auipc	ra,0xfffff
    800056bc:	c9a080e7          	jalr	-870(ra) # 80004352 <end_op>
        return -1;
    800056c0:	57fd                	li	a5,-1
    800056c2:	a891                	j	80005716 <sys_link+0x13c>
        iunlockput(ip);
    800056c4:	8526                	mv	a0,s1
    800056c6:	ffffe097          	auipc	ra,0xffffe
    800056ca:	2ba080e7          	jalr	698(ra) # 80003980 <iunlockput>
        end_op();
    800056ce:	fffff097          	auipc	ra,0xfffff
    800056d2:	c84080e7          	jalr	-892(ra) # 80004352 <end_op>
        return -1;
    800056d6:	57fd                	li	a5,-1
    800056d8:	a83d                	j	80005716 <sys_link+0x13c>
        iunlockput(dp);
    800056da:	854a                	mv	a0,s2
    800056dc:	ffffe097          	auipc	ra,0xffffe
    800056e0:	2a4080e7          	jalr	676(ra) # 80003980 <iunlockput>
    ilock(ip);
    800056e4:	8526                	mv	a0,s1
    800056e6:	ffffe097          	auipc	ra,0xffffe
    800056ea:	f1a080e7          	jalr	-230(ra) # 80003600 <ilock>
    ip->nlink--;
    800056ee:	04a4d783          	lhu	a5,74(s1)
    800056f2:	37fd                	addiw	a5,a5,-1
    800056f4:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800056f8:	8526                	mv	a0,s1
    800056fa:	ffffe097          	auipc	ra,0xffffe
    800056fe:	e3c080e7          	jalr	-452(ra) # 80003536 <iupdate>
    iunlockput(ip);
    80005702:	8526                	mv	a0,s1
    80005704:	ffffe097          	auipc	ra,0xffffe
    80005708:	27c080e7          	jalr	636(ra) # 80003980 <iunlockput>
    end_op();
    8000570c:	fffff097          	auipc	ra,0xfffff
    80005710:	c46080e7          	jalr	-954(ra) # 80004352 <end_op>
    return -1;
    80005714:	57fd                	li	a5,-1
}
    80005716:	853e                	mv	a0,a5
    80005718:	70b2                	ld	ra,296(sp)
    8000571a:	7412                	ld	s0,288(sp)
    8000571c:	64f2                	ld	s1,280(sp)
    8000571e:	6952                	ld	s2,272(sp)
    80005720:	6155                	addi	sp,sp,304
    80005722:	8082                	ret

0000000080005724 <sys_unlink>:
{
    80005724:	7151                	addi	sp,sp,-240
    80005726:	f586                	sd	ra,232(sp)
    80005728:	f1a2                	sd	s0,224(sp)
    8000572a:	eda6                	sd	s1,216(sp)
    8000572c:	e9ca                	sd	s2,208(sp)
    8000572e:	e5ce                	sd	s3,200(sp)
    80005730:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80005732:	08000613          	li	a2,128
    80005736:	f3040593          	addi	a1,s0,-208
    8000573a:	4501                	li	a0,0
    8000573c:	ffffd097          	auipc	ra,0xffffd
    80005740:	388080e7          	jalr	904(ra) # 80002ac4 <argstr>
    80005744:	18054163          	bltz	a0,800058c6 <sys_unlink+0x1a2>
    begin_op();
    80005748:	fffff097          	auipc	ra,0xfffff
    8000574c:	b8a080e7          	jalr	-1142(ra) # 800042d2 <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80005750:	fb040593          	addi	a1,s0,-80
    80005754:	f3040513          	addi	a0,s0,-208
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	98c080e7          	jalr	-1652(ra) # 800040e4 <nameiparent>
    80005760:	84aa                	mv	s1,a0
    80005762:	c979                	beqz	a0,80005838 <sys_unlink+0x114>
    ilock(dp);
    80005764:	ffffe097          	auipc	ra,0xffffe
    80005768:	e9c080e7          	jalr	-356(ra) # 80003600 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000576c:	00003597          	auipc	a1,0x3
    80005770:	ff458593          	addi	a1,a1,-12 # 80008760 <syscalls+0x338>
    80005774:	fb040513          	addi	a0,s0,-80
    80005778:	ffffe097          	auipc	ra,0xffffe
    8000577c:	470080e7          	jalr	1136(ra) # 80003be8 <namecmp>
    80005780:	14050a63          	beqz	a0,800058d4 <sys_unlink+0x1b0>
    80005784:	00003597          	auipc	a1,0x3
    80005788:	fe458593          	addi	a1,a1,-28 # 80008768 <syscalls+0x340>
    8000578c:	fb040513          	addi	a0,s0,-80
    80005790:	ffffe097          	auipc	ra,0xffffe
    80005794:	458080e7          	jalr	1112(ra) # 80003be8 <namecmp>
    80005798:	12050e63          	beqz	a0,800058d4 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    8000579c:	f2c40613          	addi	a2,s0,-212
    800057a0:	fb040593          	addi	a1,s0,-80
    800057a4:	8526                	mv	a0,s1
    800057a6:	ffffe097          	auipc	ra,0xffffe
    800057aa:	45c080e7          	jalr	1116(ra) # 80003c02 <dirlookup>
    800057ae:	892a                	mv	s2,a0
    800057b0:	12050263          	beqz	a0,800058d4 <sys_unlink+0x1b0>
    ilock(ip);
    800057b4:	ffffe097          	auipc	ra,0xffffe
    800057b8:	e4c080e7          	jalr	-436(ra) # 80003600 <ilock>
    if (ip->nlink < 1)
    800057bc:	04a91783          	lh	a5,74(s2)
    800057c0:	08f05263          	blez	a5,80005844 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    800057c4:	04491703          	lh	a4,68(s2)
    800057c8:	4785                	li	a5,1
    800057ca:	08f70563          	beq	a4,a5,80005854 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    800057ce:	4641                	li	a2,16
    800057d0:	4581                	li	a1,0
    800057d2:	fc040513          	addi	a0,s0,-64
    800057d6:	ffffb097          	auipc	ra,0xffffb
    800057da:	524080e7          	jalr	1316(ra) # 80000cfa <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057de:	4741                	li	a4,16
    800057e0:	f2c42683          	lw	a3,-212(s0)
    800057e4:	fc040613          	addi	a2,s0,-64
    800057e8:	4581                	li	a1,0
    800057ea:	8526                	mv	a0,s1
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	2e4080e7          	jalr	740(ra) # 80003ad0 <writei>
    800057f4:	47c1                	li	a5,16
    800057f6:	0af51563          	bne	a0,a5,800058a0 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    800057fa:	04491703          	lh	a4,68(s2)
    800057fe:	4785                	li	a5,1
    80005800:	0af70863          	beq	a4,a5,800058b0 <sys_unlink+0x18c>
    iunlockput(dp);
    80005804:	8526                	mv	a0,s1
    80005806:	ffffe097          	auipc	ra,0xffffe
    8000580a:	17a080e7          	jalr	378(ra) # 80003980 <iunlockput>
    ip->nlink--;
    8000580e:	04a95783          	lhu	a5,74(s2)
    80005812:	37fd                	addiw	a5,a5,-1
    80005814:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80005818:	854a                	mv	a0,s2
    8000581a:	ffffe097          	auipc	ra,0xffffe
    8000581e:	d1c080e7          	jalr	-740(ra) # 80003536 <iupdate>
    iunlockput(ip);
    80005822:	854a                	mv	a0,s2
    80005824:	ffffe097          	auipc	ra,0xffffe
    80005828:	15c080e7          	jalr	348(ra) # 80003980 <iunlockput>
    end_op();
    8000582c:	fffff097          	auipc	ra,0xfffff
    80005830:	b26080e7          	jalr	-1242(ra) # 80004352 <end_op>
    return 0;
    80005834:	4501                	li	a0,0
    80005836:	a84d                	j	800058e8 <sys_unlink+0x1c4>
        end_op();
    80005838:	fffff097          	auipc	ra,0xfffff
    8000583c:	b1a080e7          	jalr	-1254(ra) # 80004352 <end_op>
        return -1;
    80005840:	557d                	li	a0,-1
    80005842:	a05d                	j	800058e8 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80005844:	00003517          	auipc	a0,0x3
    80005848:	07450513          	addi	a0,a0,116 # 800088b8 <syscalls+0x490>
    8000584c:	ffffb097          	auipc	ra,0xffffb
    80005850:	cf6080e7          	jalr	-778(ra) # 80000542 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80005854:	04c92703          	lw	a4,76(s2)
    80005858:	02000793          	li	a5,32
    8000585c:	f6e7f9e3          	bgeu	a5,a4,800057ce <sys_unlink+0xaa>
    80005860:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005864:	4741                	li	a4,16
    80005866:	86ce                	mv	a3,s3
    80005868:	f1840613          	addi	a2,s0,-232
    8000586c:	4581                	li	a1,0
    8000586e:	854a                	mv	a0,s2
    80005870:	ffffe097          	auipc	ra,0xffffe
    80005874:	16a080e7          	jalr	362(ra) # 800039da <readi>
    80005878:	47c1                	li	a5,16
    8000587a:	00f51b63          	bne	a0,a5,80005890 <sys_unlink+0x16c>
        if (de.inum != 0)
    8000587e:	f1845783          	lhu	a5,-232(s0)
    80005882:	e7a1                	bnez	a5,800058ca <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80005884:	29c1                	addiw	s3,s3,16
    80005886:	04c92783          	lw	a5,76(s2)
    8000588a:	fcf9ede3          	bltu	s3,a5,80005864 <sys_unlink+0x140>
    8000588e:	b781                	j	800057ce <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80005890:	00003517          	auipc	a0,0x3
    80005894:	04050513          	addi	a0,a0,64 # 800088d0 <syscalls+0x4a8>
    80005898:	ffffb097          	auipc	ra,0xffffb
    8000589c:	caa080e7          	jalr	-854(ra) # 80000542 <panic>
        panic("unlink: writei");
    800058a0:	00003517          	auipc	a0,0x3
    800058a4:	04850513          	addi	a0,a0,72 # 800088e8 <syscalls+0x4c0>
    800058a8:	ffffb097          	auipc	ra,0xffffb
    800058ac:	c9a080e7          	jalr	-870(ra) # 80000542 <panic>
        dp->nlink--;
    800058b0:	04a4d783          	lhu	a5,74(s1)
    800058b4:	37fd                	addiw	a5,a5,-1
    800058b6:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    800058ba:	8526                	mv	a0,s1
    800058bc:	ffffe097          	auipc	ra,0xffffe
    800058c0:	c7a080e7          	jalr	-902(ra) # 80003536 <iupdate>
    800058c4:	b781                	j	80005804 <sys_unlink+0xe0>
        return -1;
    800058c6:	557d                	li	a0,-1
    800058c8:	a005                	j	800058e8 <sys_unlink+0x1c4>
        iunlockput(ip);
    800058ca:	854a                	mv	a0,s2
    800058cc:	ffffe097          	auipc	ra,0xffffe
    800058d0:	0b4080e7          	jalr	180(ra) # 80003980 <iunlockput>
    iunlockput(dp);
    800058d4:	8526                	mv	a0,s1
    800058d6:	ffffe097          	auipc	ra,0xffffe
    800058da:	0aa080e7          	jalr	170(ra) # 80003980 <iunlockput>
    end_op();
    800058de:	fffff097          	auipc	ra,0xfffff
    800058e2:	a74080e7          	jalr	-1420(ra) # 80004352 <end_op>
    return -1;
    800058e6:	557d                	li	a0,-1
}
    800058e8:	70ae                	ld	ra,232(sp)
    800058ea:	740e                	ld	s0,224(sp)
    800058ec:	64ee                	ld	s1,216(sp)
    800058ee:	694e                	ld	s2,208(sp)
    800058f0:	69ae                	ld	s3,200(sp)
    800058f2:	616d                	addi	sp,sp,240
    800058f4:	8082                	ret

00000000800058f6 <sys_open>:

/* TODO: Access Control & Symbolic Link */
uint64 sys_open(void)
{
    800058f6:	7131                	addi	sp,sp,-192
    800058f8:	fd06                	sd	ra,184(sp)
    800058fa:	f922                	sd	s0,176(sp)
    800058fc:	f526                	sd	s1,168(sp)
    800058fe:	f14a                	sd	s2,160(sp)
    80005900:	ed4e                	sd	s3,152(sp)
    80005902:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005904:	08000613          	li	a2,128
    80005908:	f5040593          	addi	a1,s0,-176
    8000590c:	4501                	li	a0,0
    8000590e:	ffffd097          	auipc	ra,0xffffd
    80005912:	1b6080e7          	jalr	438(ra) # 80002ac4 <argstr>
        return -1;
    80005916:	54fd                	li	s1,-1
    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005918:	0c054163          	bltz	a0,800059da <sys_open+0xe4>
    8000591c:	f4c40593          	addi	a1,s0,-180
    80005920:	4505                	li	a0,1
    80005922:	ffffd097          	auipc	ra,0xffffd
    80005926:	15e080e7          	jalr	350(ra) # 80002a80 <argint>
    8000592a:	0a054863          	bltz	a0,800059da <sys_open+0xe4>

    begin_op();
    8000592e:	fffff097          	auipc	ra,0xfffff
    80005932:	9a4080e7          	jalr	-1628(ra) # 800042d2 <begin_op>

    if (omode & O_CREATE)
    80005936:	f4c42783          	lw	a5,-180(s0)
    8000593a:	2007f793          	andi	a5,a5,512
    8000593e:	cbdd                	beqz	a5,800059f4 <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80005940:	4681                	li	a3,0
    80005942:	4601                	li	a2,0
    80005944:	4589                	li	a1,2
    80005946:	f5040513          	addi	a0,s0,-176
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	934080e7          	jalr	-1740(ra) # 8000527e <create>
    80005952:	892a                	mv	s2,a0
        if (ip == 0)
    80005954:	c959                	beqz	a0,800059ea <sys_open+0xf4>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80005956:	04491703          	lh	a4,68(s2)
    8000595a:	478d                	li	a5,3
    8000595c:	00f71763          	bne	a4,a5,8000596a <sys_open+0x74>
    80005960:	04695703          	lhu	a4,70(s2)
    80005964:	47a5                	li	a5,9
    80005966:	0ce7ec63          	bltu	a5,a4,80005a3e <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    8000596a:	fffff097          	auipc	ra,0xfffff
    8000596e:	d7e080e7          	jalr	-642(ra) # 800046e8 <filealloc>
    80005972:	89aa                	mv	s3,a0
    80005974:	10050263          	beqz	a0,80005a78 <sys_open+0x182>
    80005978:	00000097          	auipc	ra,0x0
    8000597c:	8c4080e7          	jalr	-1852(ra) # 8000523c <fdalloc>
    80005980:	84aa                	mv	s1,a0
    80005982:	0e054663          	bltz	a0,80005a6e <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80005986:	04491703          	lh	a4,68(s2)
    8000598a:	478d                	li	a5,3
    8000598c:	0cf70463          	beq	a4,a5,80005a54 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80005990:	4789                	li	a5,2
    80005992:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80005996:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    8000599a:	0129bc23          	sd	s2,24(s3)
    f->readable = !(omode & O_WRONLY);
    8000599e:	f4c42783          	lw	a5,-180(s0)
    800059a2:	0017c713          	xori	a4,a5,1
    800059a6:	8b05                	andi	a4,a4,1
    800059a8:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059ac:	0037f713          	andi	a4,a5,3
    800059b0:	00e03733          	snez	a4,a4
    800059b4:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    800059b8:	4007f793          	andi	a5,a5,1024
    800059bc:	c791                	beqz	a5,800059c8 <sys_open+0xd2>
    800059be:	04491703          	lh	a4,68(s2)
    800059c2:	4789                	li	a5,2
    800059c4:	08f70f63          	beq	a4,a5,80005a62 <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    800059c8:	854a                	mv	a0,s2
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	cf8080e7          	jalr	-776(ra) # 800036c2 <iunlock>
    end_op();
    800059d2:	fffff097          	auipc	ra,0xfffff
    800059d6:	980080e7          	jalr	-1664(ra) # 80004352 <end_op>

    return fd;
}
    800059da:	8526                	mv	a0,s1
    800059dc:	70ea                	ld	ra,184(sp)
    800059de:	744a                	ld	s0,176(sp)
    800059e0:	74aa                	ld	s1,168(sp)
    800059e2:	790a                	ld	s2,160(sp)
    800059e4:	69ea                	ld	s3,152(sp)
    800059e6:	6129                	addi	sp,sp,192
    800059e8:	8082                	ret
            end_op();
    800059ea:	fffff097          	auipc	ra,0xfffff
    800059ee:	968080e7          	jalr	-1688(ra) # 80004352 <end_op>
            return -1;
    800059f2:	b7e5                	j	800059da <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    800059f4:	f5040513          	addi	a0,s0,-176
    800059f8:	ffffe097          	auipc	ra,0xffffe
    800059fc:	4dc080e7          	jalr	1244(ra) # 80003ed4 <namei>
    80005a00:	892a                	mv	s2,a0
    80005a02:	c905                	beqz	a0,80005a32 <sys_open+0x13c>
        ilock(ip);
    80005a04:	ffffe097          	auipc	ra,0xffffe
    80005a08:	bfc080e7          	jalr	-1028(ra) # 80003600 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80005a0c:	04491703          	lh	a4,68(s2)
    80005a10:	4785                	li	a5,1
    80005a12:	f4f712e3          	bne	a4,a5,80005956 <sys_open+0x60>
    80005a16:	f4c42783          	lw	a5,-180(s0)
    80005a1a:	dba1                	beqz	a5,8000596a <sys_open+0x74>
            iunlockput(ip);
    80005a1c:	854a                	mv	a0,s2
    80005a1e:	ffffe097          	auipc	ra,0xffffe
    80005a22:	f62080e7          	jalr	-158(ra) # 80003980 <iunlockput>
            end_op();
    80005a26:	fffff097          	auipc	ra,0xfffff
    80005a2a:	92c080e7          	jalr	-1748(ra) # 80004352 <end_op>
            return -1;
    80005a2e:	54fd                	li	s1,-1
    80005a30:	b76d                	j	800059da <sys_open+0xe4>
            end_op();
    80005a32:	fffff097          	auipc	ra,0xfffff
    80005a36:	920080e7          	jalr	-1760(ra) # 80004352 <end_op>
            return -1;
    80005a3a:	54fd                	li	s1,-1
    80005a3c:	bf79                	j	800059da <sys_open+0xe4>
        iunlockput(ip);
    80005a3e:	854a                	mv	a0,s2
    80005a40:	ffffe097          	auipc	ra,0xffffe
    80005a44:	f40080e7          	jalr	-192(ra) # 80003980 <iunlockput>
        end_op();
    80005a48:	fffff097          	auipc	ra,0xfffff
    80005a4c:	90a080e7          	jalr	-1782(ra) # 80004352 <end_op>
        return -1;
    80005a50:	54fd                	li	s1,-1
    80005a52:	b761                	j	800059da <sys_open+0xe4>
        f->type = FD_DEVICE;
    80005a54:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80005a58:	04691783          	lh	a5,70(s2)
    80005a5c:	02f99223          	sh	a5,36(s3)
    80005a60:	bf2d                	j	8000599a <sys_open+0xa4>
        itrunc(ip);
    80005a62:	854a                	mv	a0,s2
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	dc8080e7          	jalr	-568(ra) # 8000382c <itrunc>
    80005a6c:	bfb1                	j	800059c8 <sys_open+0xd2>
            fileclose(f);
    80005a6e:	854e                	mv	a0,s3
    80005a70:	fffff097          	auipc	ra,0xfffff
    80005a74:	d34080e7          	jalr	-716(ra) # 800047a4 <fileclose>
        iunlockput(ip);
    80005a78:	854a                	mv	a0,s2
    80005a7a:	ffffe097          	auipc	ra,0xffffe
    80005a7e:	f06080e7          	jalr	-250(ra) # 80003980 <iunlockput>
        end_op();
    80005a82:	fffff097          	auipc	ra,0xfffff
    80005a86:	8d0080e7          	jalr	-1840(ra) # 80004352 <end_op>
        return -1;
    80005a8a:	54fd                	li	s1,-1
    80005a8c:	b7b9                	j	800059da <sys_open+0xe4>

0000000080005a8e <sys_mkdir>:

uint64 sys_mkdir(void)
{
    80005a8e:	7175                	addi	sp,sp,-144
    80005a90:	e506                	sd	ra,136(sp)
    80005a92:	e122                	sd	s0,128(sp)
    80005a94:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80005a96:	fffff097          	auipc	ra,0xfffff
    80005a9a:	83c080e7          	jalr	-1988(ra) # 800042d2 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80005a9e:	08000613          	li	a2,128
    80005aa2:	f7040593          	addi	a1,s0,-144
    80005aa6:	4501                	li	a0,0
    80005aa8:	ffffd097          	auipc	ra,0xffffd
    80005aac:	01c080e7          	jalr	28(ra) # 80002ac4 <argstr>
    80005ab0:	02054963          	bltz	a0,80005ae2 <sys_mkdir+0x54>
    80005ab4:	4681                	li	a3,0
    80005ab6:	4601                	li	a2,0
    80005ab8:	4585                	li	a1,1
    80005aba:	f7040513          	addi	a0,s0,-144
    80005abe:	fffff097          	auipc	ra,0xfffff
    80005ac2:	7c0080e7          	jalr	1984(ra) # 8000527e <create>
    80005ac6:	cd11                	beqz	a0,80005ae2 <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005ac8:	ffffe097          	auipc	ra,0xffffe
    80005acc:	eb8080e7          	jalr	-328(ra) # 80003980 <iunlockput>
    end_op();
    80005ad0:	fffff097          	auipc	ra,0xfffff
    80005ad4:	882080e7          	jalr	-1918(ra) # 80004352 <end_op>
    return 0;
    80005ad8:	4501                	li	a0,0
}
    80005ada:	60aa                	ld	ra,136(sp)
    80005adc:	640a                	ld	s0,128(sp)
    80005ade:	6149                	addi	sp,sp,144
    80005ae0:	8082                	ret
        end_op();
    80005ae2:	fffff097          	auipc	ra,0xfffff
    80005ae6:	870080e7          	jalr	-1936(ra) # 80004352 <end_op>
        return -1;
    80005aea:	557d                	li	a0,-1
    80005aec:	b7fd                	j	80005ada <sys_mkdir+0x4c>

0000000080005aee <sys_mknod>:

uint64 sys_mknod(void)
{
    80005aee:	7135                	addi	sp,sp,-160
    80005af0:	ed06                	sd	ra,152(sp)
    80005af2:	e922                	sd	s0,144(sp)
    80005af4:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80005af6:	ffffe097          	auipc	ra,0xffffe
    80005afa:	7dc080e7          	jalr	2012(ra) # 800042d2 <begin_op>
    if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005afe:	08000613          	li	a2,128
    80005b02:	f7040593          	addi	a1,s0,-144
    80005b06:	4501                	li	a0,0
    80005b08:	ffffd097          	auipc	ra,0xffffd
    80005b0c:	fbc080e7          	jalr	-68(ra) # 80002ac4 <argstr>
    80005b10:	04054a63          	bltz	a0,80005b64 <sys_mknod+0x76>
    80005b14:	f6c40593          	addi	a1,s0,-148
    80005b18:	4505                	li	a0,1
    80005b1a:	ffffd097          	auipc	ra,0xffffd
    80005b1e:	f66080e7          	jalr	-154(ra) # 80002a80 <argint>
    80005b22:	04054163          	bltz	a0,80005b64 <sys_mknod+0x76>
        argint(2, &minor) < 0 ||
    80005b26:	f6840593          	addi	a1,s0,-152
    80005b2a:	4509                	li	a0,2
    80005b2c:	ffffd097          	auipc	ra,0xffffd
    80005b30:	f54080e7          	jalr	-172(ra) # 80002a80 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 || argint(1, &major) < 0 ||
    80005b34:	02054863          	bltz	a0,80005b64 <sys_mknod+0x76>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    80005b38:	f6841683          	lh	a3,-152(s0)
    80005b3c:	f6c41603          	lh	a2,-148(s0)
    80005b40:	458d                	li	a1,3
    80005b42:	f7040513          	addi	a0,s0,-144
    80005b46:	fffff097          	auipc	ra,0xfffff
    80005b4a:	738080e7          	jalr	1848(ra) # 8000527e <create>
        argint(2, &minor) < 0 ||
    80005b4e:	c919                	beqz	a0,80005b64 <sys_mknod+0x76>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005b50:	ffffe097          	auipc	ra,0xffffe
    80005b54:	e30080e7          	jalr	-464(ra) # 80003980 <iunlockput>
    end_op();
    80005b58:	ffffe097          	auipc	ra,0xffffe
    80005b5c:	7fa080e7          	jalr	2042(ra) # 80004352 <end_op>
    return 0;
    80005b60:	4501                	li	a0,0
    80005b62:	a031                	j	80005b6e <sys_mknod+0x80>
        end_op();
    80005b64:	ffffe097          	auipc	ra,0xffffe
    80005b68:	7ee080e7          	jalr	2030(ra) # 80004352 <end_op>
        return -1;
    80005b6c:	557d                	li	a0,-1
}
    80005b6e:	60ea                	ld	ra,152(sp)
    80005b70:	644a                	ld	s0,144(sp)
    80005b72:	610d                	addi	sp,sp,160
    80005b74:	8082                	ret

0000000080005b76 <sys_chdir>:

uint64 sys_chdir(void)
{
    80005b76:	7135                	addi	sp,sp,-160
    80005b78:	ed06                	sd	ra,152(sp)
    80005b7a:	e922                	sd	s0,144(sp)
    80005b7c:	e526                	sd	s1,136(sp)
    80005b7e:	e14a                	sd	s2,128(sp)
    80005b80:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80005b82:	ffffc097          	auipc	ra,0xffffc
    80005b86:	e48080e7          	jalr	-440(ra) # 800019ca <myproc>
    80005b8a:	892a                	mv	s2,a0

    begin_op();
    80005b8c:	ffffe097          	auipc	ra,0xffffe
    80005b90:	746080e7          	jalr	1862(ra) # 800042d2 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80005b94:	08000613          	li	a2,128
    80005b98:	f6040593          	addi	a1,s0,-160
    80005b9c:	4501                	li	a0,0
    80005b9e:	ffffd097          	auipc	ra,0xffffd
    80005ba2:	f26080e7          	jalr	-218(ra) # 80002ac4 <argstr>
    80005ba6:	04054b63          	bltz	a0,80005bfc <sys_chdir+0x86>
    80005baa:	f6040513          	addi	a0,s0,-160
    80005bae:	ffffe097          	auipc	ra,0xffffe
    80005bb2:	326080e7          	jalr	806(ra) # 80003ed4 <namei>
    80005bb6:	84aa                	mv	s1,a0
    80005bb8:	c131                	beqz	a0,80005bfc <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    80005bba:	ffffe097          	auipc	ra,0xffffe
    80005bbe:	a46080e7          	jalr	-1466(ra) # 80003600 <ilock>
    if (ip->type != T_DIR)
    80005bc2:	04449703          	lh	a4,68(s1)
    80005bc6:	4785                	li	a5,1
    80005bc8:	04f71063          	bne	a4,a5,80005c08 <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80005bcc:	8526                	mv	a0,s1
    80005bce:	ffffe097          	auipc	ra,0xffffe
    80005bd2:	af4080e7          	jalr	-1292(ra) # 800036c2 <iunlock>
    iput(p->cwd);
    80005bd6:	15093503          	ld	a0,336(s2)
    80005bda:	ffffe097          	auipc	ra,0xffffe
    80005bde:	cfe080e7          	jalr	-770(ra) # 800038d8 <iput>
    end_op();
    80005be2:	ffffe097          	auipc	ra,0xffffe
    80005be6:	770080e7          	jalr	1904(ra) # 80004352 <end_op>
    p->cwd = ip;
    80005bea:	14993823          	sd	s1,336(s2)
    return 0;
    80005bee:	4501                	li	a0,0
}
    80005bf0:	60ea                	ld	ra,152(sp)
    80005bf2:	644a                	ld	s0,144(sp)
    80005bf4:	64aa                	ld	s1,136(sp)
    80005bf6:	690a                	ld	s2,128(sp)
    80005bf8:	610d                	addi	sp,sp,160
    80005bfa:	8082                	ret
        end_op();
    80005bfc:	ffffe097          	auipc	ra,0xffffe
    80005c00:	756080e7          	jalr	1878(ra) # 80004352 <end_op>
        return -1;
    80005c04:	557d                	li	a0,-1
    80005c06:	b7ed                	j	80005bf0 <sys_chdir+0x7a>
        iunlockput(ip);
    80005c08:	8526                	mv	a0,s1
    80005c0a:	ffffe097          	auipc	ra,0xffffe
    80005c0e:	d76080e7          	jalr	-650(ra) # 80003980 <iunlockput>
        end_op();
    80005c12:	ffffe097          	auipc	ra,0xffffe
    80005c16:	740080e7          	jalr	1856(ra) # 80004352 <end_op>
        return -1;
    80005c1a:	557d                	li	a0,-1
    80005c1c:	bfd1                	j	80005bf0 <sys_chdir+0x7a>

0000000080005c1e <sys_exec>:

uint64 sys_exec(void)
{
    80005c1e:	7145                	addi	sp,sp,-464
    80005c20:	e786                	sd	ra,456(sp)
    80005c22:	e3a2                	sd	s0,448(sp)
    80005c24:	ff26                	sd	s1,440(sp)
    80005c26:	fb4a                	sd	s2,432(sp)
    80005c28:	f74e                	sd	s3,424(sp)
    80005c2a:	f352                	sd	s4,416(sp)
    80005c2c:	ef56                	sd	s5,408(sp)
    80005c2e:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80005c30:	08000613          	li	a2,128
    80005c34:	f4040593          	addi	a1,s0,-192
    80005c38:	4501                	li	a0,0
    80005c3a:	ffffd097          	auipc	ra,0xffffd
    80005c3e:	e8a080e7          	jalr	-374(ra) # 80002ac4 <argstr>
    {
        return -1;
    80005c42:	597d                	li	s2,-1
    if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80005c44:	0c054a63          	bltz	a0,80005d18 <sys_exec+0xfa>
    80005c48:	e3840593          	addi	a1,s0,-456
    80005c4c:	4505                	li	a0,1
    80005c4e:	ffffd097          	auipc	ra,0xffffd
    80005c52:	e54080e7          	jalr	-428(ra) # 80002aa2 <argaddr>
    80005c56:	0c054163          	bltz	a0,80005d18 <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    80005c5a:	10000613          	li	a2,256
    80005c5e:	4581                	li	a1,0
    80005c60:	e4040513          	addi	a0,s0,-448
    80005c64:	ffffb097          	auipc	ra,0xffffb
    80005c68:	096080e7          	jalr	150(ra) # 80000cfa <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    80005c6c:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    80005c70:	89a6                	mv	s3,s1
    80005c72:	4901                	li	s2,0
        if (i >= NELEM(argv))
    80005c74:	02000a13          	li	s4,32
    80005c78:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80005c7c:	00391793          	slli	a5,s2,0x3
    80005c80:	e3040593          	addi	a1,s0,-464
    80005c84:	e3843503          	ld	a0,-456(s0)
    80005c88:	953e                	add	a0,a0,a5
    80005c8a:	ffffd097          	auipc	ra,0xffffd
    80005c8e:	d5c080e7          	jalr	-676(ra) # 800029e6 <fetchaddr>
    80005c92:	02054a63          	bltz	a0,80005cc6 <sys_exec+0xa8>
        {
            goto bad;
        }
        if (uarg == 0)
    80005c96:	e3043783          	ld	a5,-464(s0)
    80005c9a:	c3b9                	beqz	a5,80005ce0 <sys_exec+0xc2>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    80005c9c:	ffffb097          	auipc	ra,0xffffb
    80005ca0:	e72080e7          	jalr	-398(ra) # 80000b0e <kalloc>
    80005ca4:	85aa                	mv	a1,a0
    80005ca6:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    80005caa:	cd11                	beqz	a0,80005cc6 <sys_exec+0xa8>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005cac:	6605                	lui	a2,0x1
    80005cae:	e3043503          	ld	a0,-464(s0)
    80005cb2:	ffffd097          	auipc	ra,0xffffd
    80005cb6:	d86080e7          	jalr	-634(ra) # 80002a38 <fetchstr>
    80005cba:	00054663          	bltz	a0,80005cc6 <sys_exec+0xa8>
        if (i >= NELEM(argv))
    80005cbe:	0905                	addi	s2,s2,1
    80005cc0:	09a1                	addi	s3,s3,8
    80005cc2:	fb491be3          	bne	s2,s4,80005c78 <sys_exec+0x5a>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005cc6:	10048913          	addi	s2,s1,256
    80005cca:	6088                	ld	a0,0(s1)
    80005ccc:	c529                	beqz	a0,80005d16 <sys_exec+0xf8>
        kfree(argv[i]);
    80005cce:	ffffb097          	auipc	ra,0xffffb
    80005cd2:	d44080e7          	jalr	-700(ra) # 80000a12 <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005cd6:	04a1                	addi	s1,s1,8
    80005cd8:	ff2499e3          	bne	s1,s2,80005cca <sys_exec+0xac>
    return -1;
    80005cdc:	597d                	li	s2,-1
    80005cde:	a82d                	j	80005d18 <sys_exec+0xfa>
            argv[i] = 0;
    80005ce0:	0a8e                	slli	s5,s5,0x3
    80005ce2:	fc040793          	addi	a5,s0,-64
    80005ce6:	9abe                	add	s5,s5,a5
    80005ce8:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
    int ret = exec(path, argv);
    80005cec:	e4040593          	addi	a1,s0,-448
    80005cf0:	f4040513          	addi	a0,s0,-192
    80005cf4:	fffff097          	auipc	ra,0xfffff
    80005cf8:	138080e7          	jalr	312(ra) # 80004e2c <exec>
    80005cfc:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005cfe:	10048993          	addi	s3,s1,256
    80005d02:	6088                	ld	a0,0(s1)
    80005d04:	c911                	beqz	a0,80005d18 <sys_exec+0xfa>
        kfree(argv[i]);
    80005d06:	ffffb097          	auipc	ra,0xffffb
    80005d0a:	d0c080e7          	jalr	-756(ra) # 80000a12 <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d0e:	04a1                	addi	s1,s1,8
    80005d10:	ff3499e3          	bne	s1,s3,80005d02 <sys_exec+0xe4>
    80005d14:	a011                	j	80005d18 <sys_exec+0xfa>
    return -1;
    80005d16:	597d                	li	s2,-1
}
    80005d18:	854a                	mv	a0,s2
    80005d1a:	60be                	ld	ra,456(sp)
    80005d1c:	641e                	ld	s0,448(sp)
    80005d1e:	74fa                	ld	s1,440(sp)
    80005d20:	795a                	ld	s2,432(sp)
    80005d22:	79ba                	ld	s3,424(sp)
    80005d24:	7a1a                	ld	s4,416(sp)
    80005d26:	6afa                	ld	s5,408(sp)
    80005d28:	6179                	addi	sp,sp,464
    80005d2a:	8082                	ret

0000000080005d2c <sys_pipe>:

uint64 sys_pipe(void)
{
    80005d2c:	7139                	addi	sp,sp,-64
    80005d2e:	fc06                	sd	ra,56(sp)
    80005d30:	f822                	sd	s0,48(sp)
    80005d32:	f426                	sd	s1,40(sp)
    80005d34:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80005d36:	ffffc097          	auipc	ra,0xffffc
    80005d3a:	c94080e7          	jalr	-876(ra) # 800019ca <myproc>
    80005d3e:	84aa                	mv	s1,a0

    if (argaddr(0, &fdarray) < 0)
    80005d40:	fd840593          	addi	a1,s0,-40
    80005d44:	4501                	li	a0,0
    80005d46:	ffffd097          	auipc	ra,0xffffd
    80005d4a:	d5c080e7          	jalr	-676(ra) # 80002aa2 <argaddr>
        return -1;
    80005d4e:	57fd                	li	a5,-1
    if (argaddr(0, &fdarray) < 0)
    80005d50:	0e054063          	bltz	a0,80005e30 <sys_pipe+0x104>
    if (pipealloc(&rf, &wf) < 0)
    80005d54:	fc840593          	addi	a1,s0,-56
    80005d58:	fd040513          	addi	a0,s0,-48
    80005d5c:	fffff097          	auipc	ra,0xfffff
    80005d60:	da0080e7          	jalr	-608(ra) # 80004afc <pipealloc>
        return -1;
    80005d64:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    80005d66:	0c054563          	bltz	a0,80005e30 <sys_pipe+0x104>
    fd0 = -1;
    80005d6a:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005d6e:	fd043503          	ld	a0,-48(s0)
    80005d72:	fffff097          	auipc	ra,0xfffff
    80005d76:	4ca080e7          	jalr	1226(ra) # 8000523c <fdalloc>
    80005d7a:	fca42223          	sw	a0,-60(s0)
    80005d7e:	08054c63          	bltz	a0,80005e16 <sys_pipe+0xea>
    80005d82:	fc843503          	ld	a0,-56(s0)
    80005d86:	fffff097          	auipc	ra,0xfffff
    80005d8a:	4b6080e7          	jalr	1206(ra) # 8000523c <fdalloc>
    80005d8e:	fca42023          	sw	a0,-64(s0)
    80005d92:	06054863          	bltz	a0,80005e02 <sys_pipe+0xd6>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005d96:	4691                	li	a3,4
    80005d98:	fc440613          	addi	a2,s0,-60
    80005d9c:	fd843583          	ld	a1,-40(s0)
    80005da0:	68a8                	ld	a0,80(s1)
    80005da2:	ffffc097          	auipc	ra,0xffffc
    80005da6:	91a080e7          	jalr	-1766(ra) # 800016bc <copyout>
    80005daa:	02054063          	bltz	a0,80005dca <sys_pipe+0x9e>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1,
    80005dae:	4691                	li	a3,4
    80005db0:	fc040613          	addi	a2,s0,-64
    80005db4:	fd843583          	ld	a1,-40(s0)
    80005db8:	0591                	addi	a1,a1,4
    80005dba:	68a8                	ld	a0,80(s1)
    80005dbc:	ffffc097          	auipc	ra,0xffffc
    80005dc0:	900080e7          	jalr	-1792(ra) # 800016bc <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005dc4:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005dc6:	06055563          	bgez	a0,80005e30 <sys_pipe+0x104>
        p->ofile[fd0] = 0;
    80005dca:	fc442783          	lw	a5,-60(s0)
    80005dce:	07e9                	addi	a5,a5,26
    80005dd0:	078e                	slli	a5,a5,0x3
    80005dd2:	97a6                	add	a5,a5,s1
    80005dd4:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005dd8:	fc042503          	lw	a0,-64(s0)
    80005ddc:	0569                	addi	a0,a0,26
    80005dde:	050e                	slli	a0,a0,0x3
    80005de0:	9526                	add	a0,a0,s1
    80005de2:	00053023          	sd	zero,0(a0)
        fileclose(rf);
    80005de6:	fd043503          	ld	a0,-48(s0)
    80005dea:	fffff097          	auipc	ra,0xfffff
    80005dee:	9ba080e7          	jalr	-1606(ra) # 800047a4 <fileclose>
        fileclose(wf);
    80005df2:	fc843503          	ld	a0,-56(s0)
    80005df6:	fffff097          	auipc	ra,0xfffff
    80005dfa:	9ae080e7          	jalr	-1618(ra) # 800047a4 <fileclose>
        return -1;
    80005dfe:	57fd                	li	a5,-1
    80005e00:	a805                	j	80005e30 <sys_pipe+0x104>
        if (fd0 >= 0)
    80005e02:	fc442783          	lw	a5,-60(s0)
    80005e06:	0007c863          	bltz	a5,80005e16 <sys_pipe+0xea>
            p->ofile[fd0] = 0;
    80005e0a:	01a78513          	addi	a0,a5,26
    80005e0e:	050e                	slli	a0,a0,0x3
    80005e10:	9526                	add	a0,a0,s1
    80005e12:	00053023          	sd	zero,0(a0)
        fileclose(rf);
    80005e16:	fd043503          	ld	a0,-48(s0)
    80005e1a:	fffff097          	auipc	ra,0xfffff
    80005e1e:	98a080e7          	jalr	-1654(ra) # 800047a4 <fileclose>
        fileclose(wf);
    80005e22:	fc843503          	ld	a0,-56(s0)
    80005e26:	fffff097          	auipc	ra,0xfffff
    80005e2a:	97e080e7          	jalr	-1666(ra) # 800047a4 <fileclose>
        return -1;
    80005e2e:	57fd                	li	a5,-1
}
    80005e30:	853e                	mv	a0,a5
    80005e32:	70e2                	ld	ra,56(sp)
    80005e34:	7442                	ld	s0,48(sp)
    80005e36:	74a2                	ld	s1,40(sp)
    80005e38:	6121                	addi	sp,sp,64
    80005e3a:	8082                	ret

0000000080005e3c <sys_chmod>:
// e

// sysfile.c
extern int chperm(char *path, int mode, int is_add, int recursive);

int sys_chmod(void) {
    80005e3c:	7135                	addi	sp,sp,-160
    80005e3e:	ed06                	sd	ra,152(sp)
    80005e40:	e922                	sd	s0,144(sp)
    80005e42:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    int mode, is_add, recursive;

    if (argstr(0, path, MAXPATH) < 0 ||
    80005e44:	08000613          	li	a2,128
    80005e48:	f7040593          	addi	a1,s0,-144
    80005e4c:	4501                	li	a0,0
    80005e4e:	ffffd097          	auipc	ra,0xffffd
    80005e52:	c76080e7          	jalr	-906(ra) # 80002ac4 <argstr>
    80005e56:	04054d63          	bltz	a0,80005eb0 <sys_chmod+0x74>
        argint(1, &mode) < 0 ||
    80005e5a:	f6c40593          	addi	a1,s0,-148
    80005e5e:	4505                	li	a0,1
    80005e60:	ffffd097          	auipc	ra,0xffffd
    80005e64:	c20080e7          	jalr	-992(ra) # 80002a80 <argint>
    if (argstr(0, path, MAXPATH) < 0 ||
    80005e68:	04054663          	bltz	a0,80005eb4 <sys_chmod+0x78>
        argint(2, &is_add) < 0 ||
    80005e6c:	f6840593          	addi	a1,s0,-152
    80005e70:	4509                	li	a0,2
    80005e72:	ffffd097          	auipc	ra,0xffffd
    80005e76:	c0e080e7          	jalr	-1010(ra) # 80002a80 <argint>
        argint(1, &mode) < 0 ||
    80005e7a:	02054f63          	bltz	a0,80005eb8 <sys_chmod+0x7c>
        argint(3, &recursive) < 0)
    80005e7e:	f6440593          	addi	a1,s0,-156
    80005e82:	450d                	li	a0,3
    80005e84:	ffffd097          	auipc	ra,0xffffd
    80005e88:	bfc080e7          	jalr	-1028(ra) # 80002a80 <argint>
        argint(2, &is_add) < 0 ||
    80005e8c:	02054863          	bltz	a0,80005ebc <sys_chmod+0x80>
        return -1;

    return chperm(path, mode, is_add, recursive);
    80005e90:	f6442683          	lw	a3,-156(s0)
    80005e94:	f6842603          	lw	a2,-152(s0)
    80005e98:	f6c42583          	lw	a1,-148(s0)
    80005e9c:	f7040513          	addi	a0,s0,-144
    80005ea0:	ffffe097          	auipc	ra,0xffffe
    80005ea4:	052080e7          	jalr	82(ra) # 80003ef2 <chperm>
}
    80005ea8:	60ea                	ld	ra,152(sp)
    80005eaa:	644a                	ld	s0,144(sp)
    80005eac:	610d                	addi	sp,sp,160
    80005eae:	8082                	ret
        return -1;
    80005eb0:	557d                	li	a0,-1
    80005eb2:	bfdd                	j	80005ea8 <sys_chmod+0x6c>
    80005eb4:	557d                	li	a0,-1
    80005eb6:	bfcd                	j	80005ea8 <sys_chmod+0x6c>
    80005eb8:	557d                	li	a0,-1
    80005eba:	b7fd                	j	80005ea8 <sys_chmod+0x6c>
    80005ebc:	557d                	li	a0,-1
    80005ebe:	b7ed                	j	80005ea8 <sys_chmod+0x6c>

0000000080005ec0 <sys_symlink>:


/* TODO: Access Control & Symbolic Link */
// Loretta
uint64 sys_symlink(void)
{
    80005ec0:	712d                	addi	sp,sp,-288
    80005ec2:	ee06                	sd	ra,280(sp)
    80005ec4:	ea22                	sd	s0,272(sp)
    80005ec6:	e626                	sd	s1,264(sp)
    80005ec8:	e24a                	sd	s2,256(sp)
    80005eca:	1200                	addi	s0,sp,288
    /* just for your reference, change it if you want to */

    char target[MAXPATH], path[MAXPATH];

    if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005ecc:	08000613          	li	a2,128
    80005ed0:	f6040593          	addi	a1,s0,-160
    80005ed4:	4501                	li	a0,0
    80005ed6:	ffffd097          	auipc	ra,0xffffd
    80005eda:	bee080e7          	jalr	-1042(ra) # 80002ac4 <argstr>
        return -1;
    80005ede:	57fd                	li	a5,-1
    if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005ee0:	08054163          	bltz	a0,80005f62 <sys_symlink+0xa2>
    80005ee4:	08000613          	li	a2,128
    80005ee8:	ee040593          	addi	a1,s0,-288
    80005eec:	4505                	li	a0,1
    80005eee:	ffffd097          	auipc	ra,0xffffd
    80005ef2:	bd6080e7          	jalr	-1066(ra) # 80002ac4 <argstr>
        return -1;
    80005ef6:	57fd                	li	a5,-1
    if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005ef8:	06054563          	bltz	a0,80005f62 <sys_symlink+0xa2>

    struct inode *ip;
    begin_op();
    80005efc:	ffffe097          	auipc	ra,0xffffe
    80005f00:	3d6080e7          	jalr	982(ra) # 800042d2 <begin_op>

    ip = create(path, T_SYMLINK, 0, 0);
    80005f04:	4681                	li	a3,0
    80005f06:	4601                	li	a2,0
    80005f08:	4591                	li	a1,4
    80005f0a:	ee040513          	addi	a0,s0,-288
    80005f0e:	fffff097          	auipc	ra,0xfffff
    80005f12:	370080e7          	jalr	880(ra) # 8000527e <create>
    80005f16:	84aa                	mv	s1,a0
    if (ip == 0)
    80005f18:	cd21                	beqz	a0,80005f70 <sys_symlink+0xb0>
    {
        end_op();
        return -1;
    }

    if(writei(ip, 0, (uint64)target, 0, strlen(target)) != strlen(target))
    80005f1a:	f6040513          	addi	a0,s0,-160
    80005f1e:	ffffb097          	auipc	ra,0xffffb
    80005f22:	f60080e7          	jalr	-160(ra) # 80000e7e <strlen>
    80005f26:	0005071b          	sext.w	a4,a0
    80005f2a:	4681                	li	a3,0
    80005f2c:	f6040613          	addi	a2,s0,-160
    80005f30:	4581                	li	a1,0
    80005f32:	8526                	mv	a0,s1
    80005f34:	ffffe097          	auipc	ra,0xffffe
    80005f38:	b9c080e7          	jalr	-1124(ra) # 80003ad0 <writei>
    80005f3c:	892a                	mv	s2,a0
    80005f3e:	f6040513          	addi	a0,s0,-160
    80005f42:	ffffb097          	auipc	ra,0xffffb
    80005f46:	f3c080e7          	jalr	-196(ra) # 80000e7e <strlen>
    80005f4a:	02a91963          	bne	s2,a0,80005f7c <sys_symlink+0xbc>
        iunlockput(ip);
        end_op();
        return -1;
    }

    iunlockput(ip);
    80005f4e:	8526                	mv	a0,s1
    80005f50:	ffffe097          	auipc	ra,0xffffe
    80005f54:	a30080e7          	jalr	-1488(ra) # 80003980 <iunlockput>
    end_op();
    80005f58:	ffffe097          	auipc	ra,0xffffe
    80005f5c:	3fa080e7          	jalr	1018(ra) # 80004352 <end_op>

    return 0;
    80005f60:	4781                	li	a5,0
}
    80005f62:	853e                	mv	a0,a5
    80005f64:	60f2                	ld	ra,280(sp)
    80005f66:	6452                	ld	s0,272(sp)
    80005f68:	64b2                	ld	s1,264(sp)
    80005f6a:	6912                	ld	s2,256(sp)
    80005f6c:	6115                	addi	sp,sp,288
    80005f6e:	8082                	ret
        end_op();
    80005f70:	ffffe097          	auipc	ra,0xffffe
    80005f74:	3e2080e7          	jalr	994(ra) # 80004352 <end_op>
        return -1;
    80005f78:	57fd                	li	a5,-1
    80005f7a:	b7e5                	j	80005f62 <sys_symlink+0xa2>
        iunlockput(ip);
    80005f7c:	8526                	mv	a0,s1
    80005f7e:	ffffe097          	auipc	ra,0xffffe
    80005f82:	a02080e7          	jalr	-1534(ra) # 80003980 <iunlockput>
        end_op();
    80005f86:	ffffe097          	auipc	ra,0xffffe
    80005f8a:	3cc080e7          	jalr	972(ra) # 80004352 <end_op>
        return -1;
    80005f8e:	57fd                	li	a5,-1
    80005f90:	bfc9                	j	80005f62 <sys_symlink+0xa2>

0000000080005f92 <sys_raw_read>:

uint64 sys_raw_read(void)
{
    80005f92:	7179                	addi	sp,sp,-48
    80005f94:	f406                	sd	ra,40(sp)
    80005f96:	f022                	sd	s0,32(sp)
    80005f98:	ec26                	sd	s1,24(sp)
    80005f9a:	1800                	addi	s0,sp,48
    int pbn;
    uint64 user_buf_addr;
    struct buf *b;

    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    80005f9c:	fdc40593          	addi	a1,s0,-36
    80005fa0:	4501                	li	a0,0
    80005fa2:	ffffd097          	auipc	ra,0xffffd
    80005fa6:	ade080e7          	jalr	-1314(ra) # 80002a80 <argint>
    {
        return -1;
    80005faa:	57fd                	li	a5,-1
    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    80005fac:	06054463          	bltz	a0,80006014 <sys_raw_read+0x82>
    80005fb0:	fd040593          	addi	a1,s0,-48
    80005fb4:	4505                	li	a0,1
    80005fb6:	ffffd097          	auipc	ra,0xffffd
    80005fba:	aec080e7          	jalr	-1300(ra) # 80002aa2 <argaddr>
    80005fbe:	06054863          	bltz	a0,8000602e <sys_raw_read+0x9c>
    }

    if (pbn < 0 || pbn >= FSSIZE)
    80005fc2:	fdc42583          	lw	a1,-36(s0)
    80005fc6:	6705                	lui	a4,0x1
    {
        return -1;
    80005fc8:	57fd                	li	a5,-1
    if (pbn < 0 || pbn >= FSSIZE)
    80005fca:	04e5f563          	bgeu	a1,a4,80006014 <sys_raw_read+0x82>
    }

    b = bget(ROOTDEV, pbn);
    80005fce:	4505                	li	a0,1
    80005fd0:	ffffd097          	auipc	ra,0xffffd
    80005fd4:	eb6080e7          	jalr	-330(ra) # 80002e86 <bget>
    80005fd8:	84aa                	mv	s1,a0
    if (b == 0)
    80005fda:	cd21                	beqz	a0,80006032 <sys_raw_read+0xa0>
    {
        return -1;
    }

    virtio_disk_rw(b, 0);
    80005fdc:	4581                	li	a1,0
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	4be080e7          	jalr	1214(ra) # 8000649c <virtio_disk_rw>

    struct proc *p = myproc();
    80005fe6:	ffffc097          	auipc	ra,0xffffc
    80005fea:	9e4080e7          	jalr	-1564(ra) # 800019ca <myproc>
    if (copyout(p->pagetable, user_buf_addr, (char *)b->data, BSIZE) < 0)
    80005fee:	40000693          	li	a3,1024
    80005ff2:	05848613          	addi	a2,s1,88
    80005ff6:	fd043583          	ld	a1,-48(s0)
    80005ffa:	6928                	ld	a0,80(a0)
    80005ffc:	ffffb097          	auipc	ra,0xffffb
    80006000:	6c0080e7          	jalr	1728(ra) # 800016bc <copyout>
    80006004:	00054e63          	bltz	a0,80006020 <sys_raw_read+0x8e>
    {
        brelse(b);
        return -1;
    }

    brelse(b);
    80006008:	8526                	mv	a0,s1
    8000600a:	ffffd097          	auipc	ra,0xffffd
    8000600e:	ff4080e7          	jalr	-12(ra) # 80002ffe <brelse>
    return 0;
    80006012:	4781                	li	a5,0
}
    80006014:	853e                	mv	a0,a5
    80006016:	70a2                	ld	ra,40(sp)
    80006018:	7402                	ld	s0,32(sp)
    8000601a:	64e2                	ld	s1,24(sp)
    8000601c:	6145                	addi	sp,sp,48
    8000601e:	8082                	ret
        brelse(b);
    80006020:	8526                	mv	a0,s1
    80006022:	ffffd097          	auipc	ra,0xffffd
    80006026:	fdc080e7          	jalr	-36(ra) # 80002ffe <brelse>
        return -1;
    8000602a:	57fd                	li	a5,-1
    8000602c:	b7e5                	j	80006014 <sys_raw_read+0x82>
        return -1;
    8000602e:	57fd                	li	a5,-1
    80006030:	b7d5                	j	80006014 <sys_raw_read+0x82>
        return -1;
    80006032:	57fd                	li	a5,-1
    80006034:	b7c5                	j	80006014 <sys_raw_read+0x82>

0000000080006036 <sys_get_disk_lbn>:

uint64 sys_get_disk_lbn(void)
{
    80006036:	7179                	addi	sp,sp,-48
    80006038:	f406                	sd	ra,40(sp)
    8000603a:	f022                	sd	s0,32(sp)
    8000603c:	ec26                	sd	s1,24(sp)
    8000603e:	e84a                	sd	s2,16(sp)
    80006040:	1800                	addi	s0,sp,48
    struct file *f;
    int fd;
    int file_lbn;
    uint disk_lbn;

    if (argfd(0, &fd, &f) < 0 || argint(1, &file_lbn) < 0)
    80006042:	fd840613          	addi	a2,s0,-40
    80006046:	fd440593          	addi	a1,s0,-44
    8000604a:	4501                	li	a0,0
    8000604c:	fffff097          	auipc	ra,0xfffff
    80006050:	188080e7          	jalr	392(ra) # 800051d4 <argfd>
    80006054:	87aa                	mv	a5,a0
    {
        return -1;
    80006056:	557d                	li	a0,-1
    if (argfd(0, &fd, &f) < 0 || argint(1, &file_lbn) < 0)
    80006058:	0407c963          	bltz	a5,800060aa <sys_get_disk_lbn+0x74>
    8000605c:	fd040593          	addi	a1,s0,-48
    80006060:	4505                	li	a0,1
    80006062:	ffffd097          	auipc	ra,0xffffd
    80006066:	a1e080e7          	jalr	-1506(ra) # 80002a80 <argint>
    8000606a:	04054663          	bltz	a0,800060b6 <sys_get_disk_lbn+0x80>
    }

    if (!f->readable)
    8000606e:	fd843783          	ld	a5,-40(s0)
    80006072:	0087c703          	lbu	a4,8(a5)
    {
        return -1;
    80006076:	557d                	li	a0,-1
    if (!f->readable)
    80006078:	cb0d                	beqz	a4,800060aa <sys_get_disk_lbn+0x74>
    }

    struct inode *ip = f->ip;
    8000607a:	0187b903          	ld	s2,24(a5)

    ilock(ip);
    8000607e:	854a                	mv	a0,s2
    80006080:	ffffd097          	auipc	ra,0xffffd
    80006084:	580080e7          	jalr	1408(ra) # 80003600 <ilock>

    disk_lbn = bmap(ip, file_lbn);
    80006088:	fd042583          	lw	a1,-48(s0)
    8000608c:	854a                	mv	a0,s2
    8000608e:	ffffd097          	auipc	ra,0xffffd
    80006092:	680080e7          	jalr	1664(ra) # 8000370e <bmap>
    80006096:	0005049b          	sext.w	s1,a0

    iunlock(ip);
    8000609a:	854a                	mv	a0,s2
    8000609c:	ffffd097          	auipc	ra,0xffffd
    800060a0:	626080e7          	jalr	1574(ra) # 800036c2 <iunlock>

    return (uint64)disk_lbn;
    800060a4:	02049513          	slli	a0,s1,0x20
    800060a8:	9101                	srli	a0,a0,0x20
}
    800060aa:	70a2                	ld	ra,40(sp)
    800060ac:	7402                	ld	s0,32(sp)
    800060ae:	64e2                	ld	s1,24(sp)
    800060b0:	6942                	ld	s2,16(sp)
    800060b2:	6145                	addi	sp,sp,48
    800060b4:	8082                	ret
        return -1;
    800060b6:	557d                	li	a0,-1
    800060b8:	bfcd                	j	800060aa <sys_get_disk_lbn+0x74>

00000000800060ba <sys_raw_write>:

uint64 sys_raw_write(void)
{
    800060ba:	7179                	addi	sp,sp,-48
    800060bc:	f406                	sd	ra,40(sp)
    800060be:	f022                	sd	s0,32(sp)
    800060c0:	ec26                	sd	s1,24(sp)
    800060c2:	1800                	addi	s0,sp,48
    int pbn;
    uint64 user_buf_addr;
    struct buf *b;

    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    800060c4:	fdc40593          	addi	a1,s0,-36
    800060c8:	4501                	li	a0,0
    800060ca:	ffffd097          	auipc	ra,0xffffd
    800060ce:	9b6080e7          	jalr	-1610(ra) # 80002a80 <argint>
    {
        return -1;
    800060d2:	57fd                	li	a5,-1
    if (argint(0, &pbn) < 0 || argaddr(1, &user_buf_addr) < 0)
    800060d4:	06054763          	bltz	a0,80006142 <sys_raw_write+0x88>
    800060d8:	fd040593          	addi	a1,s0,-48
    800060dc:	4505                	li	a0,1
    800060de:	ffffd097          	auipc	ra,0xffffd
    800060e2:	9c4080e7          	jalr	-1596(ra) # 80002aa2 <argaddr>
    800060e6:	08054763          	bltz	a0,80006174 <sys_raw_write+0xba>
    }

    if (pbn < 0 || pbn >= FSSIZE)
    800060ea:	fdc42583          	lw	a1,-36(s0)
    800060ee:	6705                	lui	a4,0x1
    {
        return -1;
    800060f0:	57fd                	li	a5,-1
    if (pbn < 0 || pbn >= FSSIZE)
    800060f2:	04e5f863          	bgeu	a1,a4,80006142 <sys_raw_write+0x88>
    }

    b = bget(ROOTDEV, pbn);
    800060f6:	4505                	li	a0,1
    800060f8:	ffffd097          	auipc	ra,0xffffd
    800060fc:	d8e080e7          	jalr	-626(ra) # 80002e86 <bget>
    80006100:	84aa                	mv	s1,a0
    if (b == 0)
    80006102:	c531                	beqz	a0,8000614e <sys_raw_write+0x94>
    {
        printf("sys_raw_write: bget failed for PBN %d\n", pbn);
        return -1;
    }
    struct proc *p = myproc();
    80006104:	ffffc097          	auipc	ra,0xffffc
    80006108:	8c6080e7          	jalr	-1850(ra) # 800019ca <myproc>
    if (copyin(p->pagetable, (char *)b->data, user_buf_addr, BSIZE) < 0)
    8000610c:	40000693          	li	a3,1024
    80006110:	fd043603          	ld	a2,-48(s0)
    80006114:	05848593          	addi	a1,s1,88
    80006118:	6928                	ld	a0,80(a0)
    8000611a:	ffffb097          	auipc	ra,0xffffb
    8000611e:	62e080e7          	jalr	1582(ra) # 80001748 <copyin>
    80006122:	04054263          	bltz	a0,80006166 <sys_raw_write+0xac>
    {
        brelse(b);
        return -1;
    }

    b->valid = 1;
    80006126:	4785                	li	a5,1
    80006128:	c09c                	sw	a5,0(s1)
    virtio_disk_rw(b, 1);
    8000612a:	4585                	li	a1,1
    8000612c:	8526                	mv	a0,s1
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	36e080e7          	jalr	878(ra) # 8000649c <virtio_disk_rw>
    brelse(b);
    80006136:	8526                	mv	a0,s1
    80006138:	ffffd097          	auipc	ra,0xffffd
    8000613c:	ec6080e7          	jalr	-314(ra) # 80002ffe <brelse>

    return 0;
    80006140:	4781                	li	a5,0
}
    80006142:	853e                	mv	a0,a5
    80006144:	70a2                	ld	ra,40(sp)
    80006146:	7402                	ld	s0,32(sp)
    80006148:	64e2                	ld	s1,24(sp)
    8000614a:	6145                	addi	sp,sp,48
    8000614c:	8082                	ret
        printf("sys_raw_write: bget failed for PBN %d\n", pbn);
    8000614e:	fdc42583          	lw	a1,-36(s0)
    80006152:	00002517          	auipc	a0,0x2
    80006156:	7a650513          	addi	a0,a0,1958 # 800088f8 <syscalls+0x4d0>
    8000615a:	ffffa097          	auipc	ra,0xffffa
    8000615e:	432080e7          	jalr	1074(ra) # 8000058c <printf>
        return -1;
    80006162:	57fd                	li	a5,-1
    80006164:	bff9                	j	80006142 <sys_raw_write+0x88>
        brelse(b);
    80006166:	8526                	mv	a0,s1
    80006168:	ffffd097          	auipc	ra,0xffffd
    8000616c:	e96080e7          	jalr	-362(ra) # 80002ffe <brelse>
        return -1;
    80006170:	57fd                	li	a5,-1
    80006172:	bfc1                	j	80006142 <sys_raw_write+0x88>
        return -1;
    80006174:	57fd                	li	a5,-1
    80006176:	b7f1                	j	80006142 <sys_raw_write+0x88>
	...

0000000080006180 <kernelvec>:
    80006180:	7111                	addi	sp,sp,-256
    80006182:	e006                	sd	ra,0(sp)
    80006184:	e40a                	sd	sp,8(sp)
    80006186:	e80e                	sd	gp,16(sp)
    80006188:	ec12                	sd	tp,24(sp)
    8000618a:	f016                	sd	t0,32(sp)
    8000618c:	f41a                	sd	t1,40(sp)
    8000618e:	f81e                	sd	t2,48(sp)
    80006190:	fc22                	sd	s0,56(sp)
    80006192:	e0a6                	sd	s1,64(sp)
    80006194:	e4aa                	sd	a0,72(sp)
    80006196:	e8ae                	sd	a1,80(sp)
    80006198:	ecb2                	sd	a2,88(sp)
    8000619a:	f0b6                	sd	a3,96(sp)
    8000619c:	f4ba                	sd	a4,104(sp)
    8000619e:	f8be                	sd	a5,112(sp)
    800061a0:	fcc2                	sd	a6,120(sp)
    800061a2:	e146                	sd	a7,128(sp)
    800061a4:	e54a                	sd	s2,136(sp)
    800061a6:	e94e                	sd	s3,144(sp)
    800061a8:	ed52                	sd	s4,152(sp)
    800061aa:	f156                	sd	s5,160(sp)
    800061ac:	f55a                	sd	s6,168(sp)
    800061ae:	f95e                	sd	s7,176(sp)
    800061b0:	fd62                	sd	s8,184(sp)
    800061b2:	e1e6                	sd	s9,192(sp)
    800061b4:	e5ea                	sd	s10,200(sp)
    800061b6:	e9ee                	sd	s11,208(sp)
    800061b8:	edf2                	sd	t3,216(sp)
    800061ba:	f1f6                	sd	t4,224(sp)
    800061bc:	f5fa                	sd	t5,232(sp)
    800061be:	f9fe                	sd	t6,240(sp)
    800061c0:	ef2fc0ef          	jal	ra,800028b2 <kerneltrap>
    800061c4:	6082                	ld	ra,0(sp)
    800061c6:	6122                	ld	sp,8(sp)
    800061c8:	61c2                	ld	gp,16(sp)
    800061ca:	7282                	ld	t0,32(sp)
    800061cc:	7322                	ld	t1,40(sp)
    800061ce:	73c2                	ld	t2,48(sp)
    800061d0:	7462                	ld	s0,56(sp)
    800061d2:	6486                	ld	s1,64(sp)
    800061d4:	6526                	ld	a0,72(sp)
    800061d6:	65c6                	ld	a1,80(sp)
    800061d8:	6666                	ld	a2,88(sp)
    800061da:	7686                	ld	a3,96(sp)
    800061dc:	7726                	ld	a4,104(sp)
    800061de:	77c6                	ld	a5,112(sp)
    800061e0:	7866                	ld	a6,120(sp)
    800061e2:	688a                	ld	a7,128(sp)
    800061e4:	692a                	ld	s2,136(sp)
    800061e6:	69ca                	ld	s3,144(sp)
    800061e8:	6a6a                	ld	s4,152(sp)
    800061ea:	7a8a                	ld	s5,160(sp)
    800061ec:	7b2a                	ld	s6,168(sp)
    800061ee:	7bca                	ld	s7,176(sp)
    800061f0:	7c6a                	ld	s8,184(sp)
    800061f2:	6c8e                	ld	s9,192(sp)
    800061f4:	6d2e                	ld	s10,200(sp)
    800061f6:	6dce                	ld	s11,208(sp)
    800061f8:	6e6e                	ld	t3,216(sp)
    800061fa:	7e8e                	ld	t4,224(sp)
    800061fc:	7f2e                	ld	t5,232(sp)
    800061fe:	7fce                	ld	t6,240(sp)
    80006200:	6111                	addi	sp,sp,256
    80006202:	10200073          	sret
    80006206:	00000013          	nop
    8000620a:	00000013          	nop
    8000620e:	0001                	nop

0000000080006210 <timervec>:
    80006210:	34051573          	csrrw	a0,mscratch,a0
    80006214:	e10c                	sd	a1,0(a0)
    80006216:	e510                	sd	a2,8(a0)
    80006218:	e914                	sd	a3,16(a0)
    8000621a:	710c                	ld	a1,32(a0)
    8000621c:	7510                	ld	a2,40(a0)
    8000621e:	6194                	ld	a3,0(a1)
    80006220:	96b2                	add	a3,a3,a2
    80006222:	e194                	sd	a3,0(a1)
    80006224:	4589                	li	a1,2
    80006226:	14459073          	csrw	sip,a1
    8000622a:	6914                	ld	a3,16(a0)
    8000622c:	6510                	ld	a2,8(a0)
    8000622e:	610c                	ld	a1,0(a0)
    80006230:	34051573          	csrrw	a0,mscratch,a0
    80006234:	30200073          	mret
	...

000000008000623a <plicinit>:
//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void)
{
    8000623a:	1141                	addi	sp,sp,-16
    8000623c:	e422                	sd	s0,8(sp)
    8000623e:	0800                	addi	s0,sp,16
    // set desired IRQ priorities non-zero (otherwise disabled).
    *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80006240:	0c0007b7          	lui	a5,0xc000
    80006244:	4705                	li	a4,1
    80006246:	d798                	sw	a4,40(a5)
    *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80006248:	c3d8                	sw	a4,4(a5)
}
    8000624a:	6422                	ld	s0,8(sp)
    8000624c:	0141                	addi	sp,sp,16
    8000624e:	8082                	ret

0000000080006250 <plicinithart>:

void plicinithart(void)
{
    80006250:	1141                	addi	sp,sp,-16
    80006252:	e406                	sd	ra,8(sp)
    80006254:	e022                	sd	s0,0(sp)
    80006256:	0800                	addi	s0,sp,16
    int hart = cpuid();
    80006258:	ffffb097          	auipc	ra,0xffffb
    8000625c:	746080e7          	jalr	1862(ra) # 8000199e <cpuid>

    // set uart's enable bit for this hart's S-mode.
    *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006260:	0085171b          	slliw	a4,a0,0x8
    80006264:	0c0027b7          	lui	a5,0xc002
    80006268:	97ba                	add	a5,a5,a4
    8000626a:	40200713          	li	a4,1026
    8000626e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

    // set this hart's S-mode priority threshold to 0.
    *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80006272:	00d5151b          	slliw	a0,a0,0xd
    80006276:	0c2017b7          	lui	a5,0xc201
    8000627a:	953e                	add	a0,a0,a5
    8000627c:	00052023          	sw	zero,0(a0)
}
    80006280:	60a2                	ld	ra,8(sp)
    80006282:	6402                	ld	s0,0(sp)
    80006284:	0141                	addi	sp,sp,16
    80006286:	8082                	ret

0000000080006288 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void)
{
    80006288:	1141                	addi	sp,sp,-16
    8000628a:	e406                	sd	ra,8(sp)
    8000628c:	e022                	sd	s0,0(sp)
    8000628e:	0800                	addi	s0,sp,16
    int hart = cpuid();
    80006290:	ffffb097          	auipc	ra,0xffffb
    80006294:	70e080e7          	jalr	1806(ra) # 8000199e <cpuid>
    int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80006298:	00d5179b          	slliw	a5,a0,0xd
    8000629c:	0c201537          	lui	a0,0xc201
    800062a0:	953e                	add	a0,a0,a5
    return irq;
}
    800062a2:	4148                	lw	a0,4(a0)
    800062a4:	60a2                	ld	ra,8(sp)
    800062a6:	6402                	ld	s0,0(sp)
    800062a8:	0141                	addi	sp,sp,16
    800062aa:	8082                	ret

00000000800062ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq)
{
    800062ac:	1101                	addi	sp,sp,-32
    800062ae:	ec06                	sd	ra,24(sp)
    800062b0:	e822                	sd	s0,16(sp)
    800062b2:	e426                	sd	s1,8(sp)
    800062b4:	1000                	addi	s0,sp,32
    800062b6:	84aa                	mv	s1,a0
    int hart = cpuid();
    800062b8:	ffffb097          	auipc	ra,0xffffb
    800062bc:	6e6080e7          	jalr	1766(ra) # 8000199e <cpuid>
    *(uint32 *)PLIC_SCLAIM(hart) = irq;
    800062c0:	00d5151b          	slliw	a0,a0,0xd
    800062c4:	0c2017b7          	lui	a5,0xc201
    800062c8:	97aa                	add	a5,a5,a0
    800062ca:	c3c4                	sw	s1,4(a5)
}
    800062cc:	60e2                	ld	ra,24(sp)
    800062ce:	6442                	ld	s0,16(sp)
    800062d0:	64a2                	ld	s1,8(sp)
    800062d2:	6105                	addi	sp,sp,32
    800062d4:	8082                	ret

00000000800062d6 <free_desc>:
    return -1;
}

// mark a descriptor as free.
static void free_desc(int i)
{
    800062d6:	1141                	addi	sp,sp,-16
    800062d8:	e406                	sd	ra,8(sp)
    800062da:	e022                	sd	s0,0(sp)
    800062dc:	0800                	addi	s0,sp,16
    if (i >= NUM)
    800062de:	479d                	li	a5,7
    800062e0:	04a7cc63          	blt	a5,a0,80006338 <free_desc+0x62>
        panic("virtio_disk_intr 1");
    if (disk.free[i])
    800062e4:	0001d797          	auipc	a5,0x1d
    800062e8:	d1c78793          	addi	a5,a5,-740 # 80023000 <disk>
    800062ec:	00a78733          	add	a4,a5,a0
    800062f0:	6789                	lui	a5,0x2
    800062f2:	97ba                	add	a5,a5,a4
    800062f4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800062f8:	eba1                	bnez	a5,80006348 <free_desc+0x72>
        panic("virtio_disk_intr 2");
    disk.desc[i].addr = 0;
    800062fa:	00451713          	slli	a4,a0,0x4
    800062fe:	0001f797          	auipc	a5,0x1f
    80006302:	d027b783          	ld	a5,-766(a5) # 80025000 <disk+0x2000>
    80006306:	97ba                	add	a5,a5,a4
    80006308:	0007b023          	sd	zero,0(a5)
    disk.free[i] = 1;
    8000630c:	0001d797          	auipc	a5,0x1d
    80006310:	cf478793          	addi	a5,a5,-780 # 80023000 <disk>
    80006314:	97aa                	add	a5,a5,a0
    80006316:	6509                	lui	a0,0x2
    80006318:	953e                	add	a0,a0,a5
    8000631a:	4785                	li	a5,1
    8000631c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    80006320:	0001f517          	auipc	a0,0x1f
    80006324:	cf850513          	addi	a0,a0,-776 # 80025018 <disk+0x2018>
    80006328:	ffffc097          	auipc	ra,0xffffc
    8000632c:	032080e7          	jalr	50(ra) # 8000235a <wakeup>
}
    80006330:	60a2                	ld	ra,8(sp)
    80006332:	6402                	ld	s0,0(sp)
    80006334:	0141                	addi	sp,sp,16
    80006336:	8082                	ret
        panic("virtio_disk_intr 1");
    80006338:	00002517          	auipc	a0,0x2
    8000633c:	5e850513          	addi	a0,a0,1512 # 80008920 <syscalls+0x4f8>
    80006340:	ffffa097          	auipc	ra,0xffffa
    80006344:	202080e7          	jalr	514(ra) # 80000542 <panic>
        panic("virtio_disk_intr 2");
    80006348:	00002517          	auipc	a0,0x2
    8000634c:	5f050513          	addi	a0,a0,1520 # 80008938 <syscalls+0x510>
    80006350:	ffffa097          	auipc	ra,0xffffa
    80006354:	1f2080e7          	jalr	498(ra) # 80000542 <panic>

0000000080006358 <virtio_disk_init>:
{
    80006358:	1101                	addi	sp,sp,-32
    8000635a:	ec06                	sd	ra,24(sp)
    8000635c:	e822                	sd	s0,16(sp)
    8000635e:	e426                	sd	s1,8(sp)
    80006360:	1000                	addi	s0,sp,32
    initlock(&disk.vdisk_lock, "virtio_disk");
    80006362:	00002597          	auipc	a1,0x2
    80006366:	5ee58593          	addi	a1,a1,1518 # 80008950 <syscalls+0x528>
    8000636a:	0001f517          	auipc	a0,0x1f
    8000636e:	d3e50513          	addi	a0,a0,-706 # 800250a8 <disk+0x20a8>
    80006372:	ffffa097          	auipc	ra,0xffffa
    80006376:	7fc080e7          	jalr	2044(ra) # 80000b6e <initlock>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000637a:	100017b7          	lui	a5,0x10001
    8000637e:	4398                	lw	a4,0(a5)
    80006380:	2701                	sext.w	a4,a4
    80006382:	747277b7          	lui	a5,0x74727
    80006386:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000638a:	0ef71163          	bne	a4,a5,8000646c <virtio_disk_init+0x114>
        *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000638e:	100017b7          	lui	a5,0x10001
    80006392:	43dc                	lw	a5,4(a5)
    80006394:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006396:	4705                	li	a4,1
    80006398:	0ce79a63          	bne	a5,a4,8000646c <virtio_disk_init+0x114>
        *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000639c:	100017b7          	lui	a5,0x10001
    800063a0:	479c                	lw	a5,8(a5)
    800063a2:	2781                	sext.w	a5,a5
    800063a4:	4709                	li	a4,2
    800063a6:	0ce79363          	bne	a5,a4,8000646c <virtio_disk_init+0x114>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551)
    800063aa:	100017b7          	lui	a5,0x10001
    800063ae:	47d8                	lw	a4,12(a5)
    800063b0:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063b2:	554d47b7          	lui	a5,0x554d4
    800063b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800063ba:	0af71963          	bne	a4,a5,8000646c <virtio_disk_init+0x114>
    *R(VIRTIO_MMIO_STATUS) = status;
    800063be:	100017b7          	lui	a5,0x10001
    800063c2:	4705                	li	a4,1
    800063c4:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    800063c6:	470d                	li	a4,3
    800063c8:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063ca:	4b94                	lw	a3,16(a5)
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800063cc:	c7ffe737          	lui	a4,0xc7ffe
    800063d0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    800063d4:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800063d6:	2701                	sext.w	a4,a4
    800063d8:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    800063da:	472d                	li	a4,11
    800063dc:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    800063de:	473d                	li	a4,15
    800063e0:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800063e2:	6705                	lui	a4,0x1
    800063e4:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800063e6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800063ea:	5bdc                	lw	a5,52(a5)
    800063ec:	2781                	sext.w	a5,a5
    if (max == 0)
    800063ee:	c7d9                	beqz	a5,8000647c <virtio_disk_init+0x124>
    if (max < NUM)
    800063f0:	471d                	li	a4,7
    800063f2:	08f77d63          	bgeu	a4,a5,8000648c <virtio_disk_init+0x134>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800063f6:	100014b7          	lui	s1,0x10001
    800063fa:	47a1                	li	a5,8
    800063fc:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    800063fe:	6609                	lui	a2,0x2
    80006400:	4581                	li	a1,0
    80006402:	0001d517          	auipc	a0,0x1d
    80006406:	bfe50513          	addi	a0,a0,-1026 # 80023000 <disk>
    8000640a:	ffffb097          	auipc	ra,0xffffb
    8000640e:	8f0080e7          	jalr	-1808(ra) # 80000cfa <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006412:	0001d717          	auipc	a4,0x1d
    80006416:	bee70713          	addi	a4,a4,-1042 # 80023000 <disk>
    8000641a:	00c75793          	srli	a5,a4,0xc
    8000641e:	2781                	sext.w	a5,a5
    80006420:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct VRingDesc *)disk.pages;
    80006422:	0001f797          	auipc	a5,0x1f
    80006426:	bde78793          	addi	a5,a5,-1058 # 80025000 <disk+0x2000>
    8000642a:	e398                	sd	a4,0(a5)
    disk.avail =
    8000642c:	0001d717          	auipc	a4,0x1d
    80006430:	c5470713          	addi	a4,a4,-940 # 80023080 <disk+0x80>
    80006434:	e798                	sd	a4,8(a5)
    disk.used = (struct UsedArea *)(disk.pages + PGSIZE);
    80006436:	0001e717          	auipc	a4,0x1e
    8000643a:	bca70713          	addi	a4,a4,-1078 # 80024000 <disk+0x1000>
    8000643e:	eb98                	sd	a4,16(a5)
        disk.free[i] = 1;
    80006440:	4705                	li	a4,1
    80006442:	00e78c23          	sb	a4,24(a5)
    80006446:	00e78ca3          	sb	a4,25(a5)
    8000644a:	00e78d23          	sb	a4,26(a5)
    8000644e:	00e78da3          	sb	a4,27(a5)
    80006452:	00e78e23          	sb	a4,28(a5)
    80006456:	00e78ea3          	sb	a4,29(a5)
    8000645a:	00e78f23          	sb	a4,30(a5)
    8000645e:	00e78fa3          	sb	a4,31(a5)
}
    80006462:	60e2                	ld	ra,24(sp)
    80006464:	6442                	ld	s0,16(sp)
    80006466:	64a2                	ld	s1,8(sp)
    80006468:	6105                	addi	sp,sp,32
    8000646a:	8082                	ret
        panic("could not find virtio disk");
    8000646c:	00002517          	auipc	a0,0x2
    80006470:	4f450513          	addi	a0,a0,1268 # 80008960 <syscalls+0x538>
    80006474:	ffffa097          	auipc	ra,0xffffa
    80006478:	0ce080e7          	jalr	206(ra) # 80000542 <panic>
        panic("virtio disk has no queue 0");
    8000647c:	00002517          	auipc	a0,0x2
    80006480:	50450513          	addi	a0,a0,1284 # 80008980 <syscalls+0x558>
    80006484:	ffffa097          	auipc	ra,0xffffa
    80006488:	0be080e7          	jalr	190(ra) # 80000542 <panic>
        panic("virtio disk max queue too short");
    8000648c:	00002517          	auipc	a0,0x2
    80006490:	51450513          	addi	a0,a0,1300 # 800089a0 <syscalls+0x578>
    80006494:	ffffa097          	auipc	ra,0xffffa
    80006498:	0ae080e7          	jalr	174(ra) # 80000542 <panic>

000000008000649c <virtio_disk_rw>:
    }
    return 0;
}

void virtio_disk_rw(struct buf *b, int write)
{
    8000649c:	7175                	addi	sp,sp,-144
    8000649e:	e506                	sd	ra,136(sp)
    800064a0:	e122                	sd	s0,128(sp)
    800064a2:	fca6                	sd	s1,120(sp)
    800064a4:	f8ca                	sd	s2,112(sp)
    800064a6:	f4ce                	sd	s3,104(sp)
    800064a8:	f0d2                	sd	s4,96(sp)
    800064aa:	ecd6                	sd	s5,88(sp)
    800064ac:	e8da                	sd	s6,80(sp)
    800064ae:	e4de                	sd	s7,72(sp)
    800064b0:	e0e2                	sd	s8,64(sp)
    800064b2:	fc66                	sd	s9,56(sp)
    800064b4:	f86a                	sd	s10,48(sp)
    800064b6:	f46e                	sd	s11,40(sp)
    800064b8:	0900                	addi	s0,sp,144
    800064ba:	8aaa                	mv	s5,a0
    800064bc:	8d2e                	mv	s10,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    800064be:	00c52c83          	lw	s9,12(a0)
    800064c2:	001c9c9b          	slliw	s9,s9,0x1
    800064c6:	1c82                	slli	s9,s9,0x20
    800064c8:	020cdc93          	srli	s9,s9,0x20

    acquire(&disk.vdisk_lock);
    800064cc:	0001f517          	auipc	a0,0x1f
    800064d0:	bdc50513          	addi	a0,a0,-1060 # 800250a8 <disk+0x20a8>
    800064d4:	ffffa097          	auipc	ra,0xffffa
    800064d8:	72a080e7          	jalr	1834(ra) # 80000bfe <acquire>
    for (int i = 0; i < 3; i++)
    800064dc:	4981                	li	s3,0
    for (int i = 0; i < NUM; i++)
    800064de:	44a1                	li	s1,8
            disk.free[i] = 0;
    800064e0:	0001dc17          	auipc	s8,0x1d
    800064e4:	b20c0c13          	addi	s8,s8,-1248 # 80023000 <disk>
    800064e8:	6b89                	lui	s7,0x2
    for (int i = 0; i < 3; i++)
    800064ea:	4b0d                	li	s6,3
    800064ec:	a0ad                	j	80006556 <virtio_disk_rw+0xba>
            disk.free[i] = 0;
    800064ee:	00fc0733          	add	a4,s8,a5
    800064f2:	975e                	add	a4,a4,s7
    800064f4:	00070c23          	sb	zero,24(a4)
        idx[i] = alloc_desc();
    800064f8:	c19c                	sw	a5,0(a1)
        if (idx[i] < 0)
    800064fa:	0207c563          	bltz	a5,80006524 <virtio_disk_rw+0x88>
    for (int i = 0; i < 3; i++)
    800064fe:	2905                	addiw	s2,s2,1
    80006500:	0611                	addi	a2,a2,4
    80006502:	19690d63          	beq	s2,s6,8000669c <virtio_disk_rw+0x200>
        idx[i] = alloc_desc();
    80006506:	85b2                	mv	a1,a2
    for (int i = 0; i < NUM; i++)
    80006508:	0001f717          	auipc	a4,0x1f
    8000650c:	b1070713          	addi	a4,a4,-1264 # 80025018 <disk+0x2018>
    80006510:	87ce                	mv	a5,s3
        if (disk.free[i])
    80006512:	00074683          	lbu	a3,0(a4)
    80006516:	fee1                	bnez	a3,800064ee <virtio_disk_rw+0x52>
    for (int i = 0; i < NUM; i++)
    80006518:	2785                	addiw	a5,a5,1
    8000651a:	0705                	addi	a4,a4,1
    8000651c:	fe979be3          	bne	a5,s1,80006512 <virtio_disk_rw+0x76>
        idx[i] = alloc_desc();
    80006520:	57fd                	li	a5,-1
    80006522:	c19c                	sw	a5,0(a1)
            for (int j = 0; j < i; j++)
    80006524:	01205d63          	blez	s2,8000653e <virtio_disk_rw+0xa2>
    80006528:	8dce                	mv	s11,s3
                free_desc(idx[j]);
    8000652a:	000a2503          	lw	a0,0(s4)
    8000652e:	00000097          	auipc	ra,0x0
    80006532:	da8080e7          	jalr	-600(ra) # 800062d6 <free_desc>
            for (int j = 0; j < i; j++)
    80006536:	2d85                	addiw	s11,s11,1
    80006538:	0a11                	addi	s4,s4,4
    8000653a:	ffb918e3          	bne	s2,s11,8000652a <virtio_disk_rw+0x8e>
    {
        if (alloc3_desc(idx) == 0)
        {
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    8000653e:	0001f597          	auipc	a1,0x1f
    80006542:	b6a58593          	addi	a1,a1,-1174 # 800250a8 <disk+0x20a8>
    80006546:	0001f517          	auipc	a0,0x1f
    8000654a:	ad250513          	addi	a0,a0,-1326 # 80025018 <disk+0x2018>
    8000654e:	ffffc097          	auipc	ra,0xffffc
    80006552:	c8c080e7          	jalr	-884(ra) # 800021da <sleep>
    for (int i = 0; i < 3; i++)
    80006556:	f8040a13          	addi	s4,s0,-128
{
    8000655a:	8652                	mv	a2,s4
    for (int i = 0; i < 3; i++)
    8000655c:	894e                	mv	s2,s3
    8000655e:	b765                	j	80006506 <virtio_disk_rw+0x6a>
    disk.desc[idx[0]].next = idx[1];

    disk.desc[idx[1]].addr = (uint64)b->data;
    disk.desc[idx[1]].len = BSIZE;
    if (write)
        disk.desc[idx[1]].flags = 0; // device reads b->data
    80006560:	0001f717          	auipc	a4,0x1f
    80006564:	aa073703          	ld	a4,-1376(a4) # 80025000 <disk+0x2000>
    80006568:	973e                	add	a4,a4,a5
    8000656a:	00071623          	sh	zero,12(a4)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000656e:	0001d517          	auipc	a0,0x1d
    80006572:	a9250513          	addi	a0,a0,-1390 # 80023000 <disk>
    80006576:	0001f717          	auipc	a4,0x1f
    8000657a:	a8a70713          	addi	a4,a4,-1398 # 80025000 <disk+0x2000>
    8000657e:	6314                	ld	a3,0(a4)
    80006580:	96be                	add	a3,a3,a5
    80006582:	00c6d603          	lhu	a2,12(a3)
    80006586:	00166613          	ori	a2,a2,1
    8000658a:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[1]].next = idx[2];
    8000658e:	f8842683          	lw	a3,-120(s0)
    80006592:	6310                	ld	a2,0(a4)
    80006594:	97b2                	add	a5,a5,a2
    80006596:	00d79723          	sh	a3,14(a5)

    disk.info[idx[0]].status = 0;
    8000659a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000659e:	0612                	slli	a2,a2,0x4
    800065a0:	962a                	add	a2,a2,a0
    800065a2:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
    disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800065a6:	00469793          	slli	a5,a3,0x4
    800065aa:	630c                	ld	a1,0(a4)
    800065ac:	95be                	add	a1,a1,a5
    800065ae:	6689                	lui	a3,0x2
    800065b0:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800065b4:	96ca                	add	a3,a3,s2
    800065b6:	96aa                	add	a3,a3,a0
    800065b8:	e194                	sd	a3,0(a1)
    disk.desc[idx[2]].len = 1;
    800065ba:	6314                	ld	a3,0(a4)
    800065bc:	96be                	add	a3,a3,a5
    800065be:	4585                	li	a1,1
    800065c0:	c68c                	sw	a1,8(a3)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800065c2:	6314                	ld	a3,0(a4)
    800065c4:	96be                	add	a3,a3,a5
    800065c6:	4509                	li	a0,2
    800065c8:	00a69623          	sh	a0,12(a3)
    disk.desc[idx[2]].next = 0;
    800065cc:	6314                	ld	a3,0(a4)
    800065ce:	97b6                	add	a5,a5,a3
    800065d0:	00079723          	sh	zero,14(a5)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    800065d4:	00baa223          	sw	a1,4(s5)
    disk.info[idx[0]].b = b;
    800065d8:	03563423          	sd	s5,40(a2)

    // avail[0] is flags
    // avail[1] tells the device how far to look in avail[2...].
    // avail[2...] are desc[] indices the device should process.
    // we only tell device the first index in our chain of descriptors.
    disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    800065dc:	6714                	ld	a3,8(a4)
    800065de:	0026d783          	lhu	a5,2(a3)
    800065e2:	8b9d                	andi	a5,a5,7
    800065e4:	0789                	addi	a5,a5,2
    800065e6:	0786                	slli	a5,a5,0x1
    800065e8:	97b6                	add	a5,a5,a3
    800065ea:	00979023          	sh	s1,0(a5)
    __sync_synchronize();
    800065ee:	0ff0000f          	fence
    disk.avail[1] = disk.avail[1] + 1;
    800065f2:	6718                	ld	a4,8(a4)
    800065f4:	00275783          	lhu	a5,2(a4)
    800065f8:	2785                	addiw	a5,a5,1
    800065fa:	00f71123          	sh	a5,2(a4)

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800065fe:	100017b7          	lui	a5,0x10001
    80006602:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1)
    80006606:	004aa783          	lw	a5,4(s5)
    8000660a:	02b79163          	bne	a5,a1,8000662c <virtio_disk_rw+0x190>
    {
        sleep(b, &disk.vdisk_lock);
    8000660e:	0001f917          	auipc	s2,0x1f
    80006612:	a9a90913          	addi	s2,s2,-1382 # 800250a8 <disk+0x20a8>
    while (b->disk == 1)
    80006616:	4485                	li	s1,1
        sleep(b, &disk.vdisk_lock);
    80006618:	85ca                	mv	a1,s2
    8000661a:	8556                	mv	a0,s5
    8000661c:	ffffc097          	auipc	ra,0xffffc
    80006620:	bbe080e7          	jalr	-1090(ra) # 800021da <sleep>
    while (b->disk == 1)
    80006624:	004aa783          	lw	a5,4(s5)
    80006628:	fe9788e3          	beq	a5,s1,80006618 <virtio_disk_rw+0x17c>
    }

    disk.info[idx[0]].b = 0;
    8000662c:	f8042483          	lw	s1,-128(s0)
    80006630:	20048793          	addi	a5,s1,512
    80006634:	00479713          	slli	a4,a5,0x4
    80006638:	0001d797          	auipc	a5,0x1d
    8000663c:	9c878793          	addi	a5,a5,-1592 # 80023000 <disk>
    80006640:	97ba                	add	a5,a5,a4
    80006642:	0207b423          	sd	zero,40(a5)
        if (disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006646:	0001f917          	auipc	s2,0x1f
    8000664a:	9ba90913          	addi	s2,s2,-1606 # 80025000 <disk+0x2000>
    8000664e:	a019                	j	80006654 <virtio_disk_rw+0x1b8>
            i = disk.desc[i].next;
    80006650:	00e4d483          	lhu	s1,14(s1)
        free_desc(i);
    80006654:	8526                	mv	a0,s1
    80006656:	00000097          	auipc	ra,0x0
    8000665a:	c80080e7          	jalr	-896(ra) # 800062d6 <free_desc>
        if (disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000665e:	0492                	slli	s1,s1,0x4
    80006660:	00093783          	ld	a5,0(s2)
    80006664:	94be                	add	s1,s1,a5
    80006666:	00c4d783          	lhu	a5,12(s1)
    8000666a:	8b85                	andi	a5,a5,1
    8000666c:	f3f5                	bnez	a5,80006650 <virtio_disk_rw+0x1b4>
    free_chain(idx[0]);

    release(&disk.vdisk_lock);
    8000666e:	0001f517          	auipc	a0,0x1f
    80006672:	a3a50513          	addi	a0,a0,-1478 # 800250a8 <disk+0x20a8>
    80006676:	ffffa097          	auipc	ra,0xffffa
    8000667a:	63c080e7          	jalr	1596(ra) # 80000cb2 <release>
}
    8000667e:	60aa                	ld	ra,136(sp)
    80006680:	640a                	ld	s0,128(sp)
    80006682:	74e6                	ld	s1,120(sp)
    80006684:	7946                	ld	s2,112(sp)
    80006686:	79a6                	ld	s3,104(sp)
    80006688:	7a06                	ld	s4,96(sp)
    8000668a:	6ae6                	ld	s5,88(sp)
    8000668c:	6b46                	ld	s6,80(sp)
    8000668e:	6ba6                	ld	s7,72(sp)
    80006690:	6c06                	ld	s8,64(sp)
    80006692:	7ce2                	ld	s9,56(sp)
    80006694:	7d42                	ld	s10,48(sp)
    80006696:	7da2                	ld	s11,40(sp)
    80006698:	6149                	addi	sp,sp,144
    8000669a:	8082                	ret
    if (write)
    8000669c:	01a037b3          	snez	a5,s10
    800066a0:	f6f42823          	sw	a5,-144(s0)
    buf0.reserved = 0;
    800066a4:	f6042a23          	sw	zero,-140(s0)
    buf0.sector = sector;
    800066a8:	f7943c23          	sd	s9,-136(s0)
    disk.desc[idx[0]].addr = (uint64)kvmpa((uint64)&buf0);
    800066ac:	f8042483          	lw	s1,-128(s0)
    800066b0:	00449913          	slli	s2,s1,0x4
    800066b4:	0001f997          	auipc	s3,0x1f
    800066b8:	94c98993          	addi	s3,s3,-1716 # 80025000 <disk+0x2000>
    800066bc:	0009ba03          	ld	s4,0(s3)
    800066c0:	9a4a                	add	s4,s4,s2
    800066c2:	f7040513          	addi	a0,s0,-144
    800066c6:	ffffb097          	auipc	ra,0xffffb
    800066ca:	a04080e7          	jalr	-1532(ra) # 800010ca <kvmpa>
    800066ce:	00aa3023          	sd	a0,0(s4)
    disk.desc[idx[0]].len = sizeof(buf0);
    800066d2:	0009b783          	ld	a5,0(s3)
    800066d6:	97ca                	add	a5,a5,s2
    800066d8:	4741                	li	a4,16
    800066da:	c798                	sw	a4,8(a5)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800066dc:	0009b783          	ld	a5,0(s3)
    800066e0:	97ca                	add	a5,a5,s2
    800066e2:	4705                	li	a4,1
    800066e4:	00e79623          	sh	a4,12(a5)
    disk.desc[idx[0]].next = idx[1];
    800066e8:	f8442783          	lw	a5,-124(s0)
    800066ec:	0009b703          	ld	a4,0(s3)
    800066f0:	974a                	add	a4,a4,s2
    800066f2:	00f71723          	sh	a5,14(a4)
    disk.desc[idx[1]].addr = (uint64)b->data;
    800066f6:	0792                	slli	a5,a5,0x4
    800066f8:	0009b703          	ld	a4,0(s3)
    800066fc:	973e                	add	a4,a4,a5
    800066fe:	058a8693          	addi	a3,s5,88
    80006702:	e314                	sd	a3,0(a4)
    disk.desc[idx[1]].len = BSIZE;
    80006704:	0009b703          	ld	a4,0(s3)
    80006708:	973e                	add	a4,a4,a5
    8000670a:	40000693          	li	a3,1024
    8000670e:	c714                	sw	a3,8(a4)
    if (write)
    80006710:	e40d18e3          	bnez	s10,80006560 <virtio_disk_rw+0xc4>
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006714:	0001f717          	auipc	a4,0x1f
    80006718:	8ec73703          	ld	a4,-1812(a4) # 80025000 <disk+0x2000>
    8000671c:	973e                	add	a4,a4,a5
    8000671e:	4689                	li	a3,2
    80006720:	00d71623          	sh	a3,12(a4)
    80006724:	b5a9                	j	8000656e <virtio_disk_rw+0xd2>

0000000080006726 <virtio_disk_intr>:

void virtio_disk_intr()
{
    80006726:	1101                	addi	sp,sp,-32
    80006728:	ec06                	sd	ra,24(sp)
    8000672a:	e822                	sd	s0,16(sp)
    8000672c:	e426                	sd	s1,8(sp)
    8000672e:	e04a                	sd	s2,0(sp)
    80006730:	1000                	addi	s0,sp,32
    acquire(&disk.vdisk_lock);
    80006732:	0001f517          	auipc	a0,0x1f
    80006736:	97650513          	addi	a0,a0,-1674 # 800250a8 <disk+0x20a8>
    8000673a:	ffffa097          	auipc	ra,0xffffa
    8000673e:	4c4080e7          	jalr	1220(ra) # 80000bfe <acquire>

    while ((disk.used_idx % NUM) != (disk.used->id % NUM))
    80006742:	0001f717          	auipc	a4,0x1f
    80006746:	8be70713          	addi	a4,a4,-1858 # 80025000 <disk+0x2000>
    8000674a:	02075783          	lhu	a5,32(a4)
    8000674e:	6b18                	ld	a4,16(a4)
    80006750:	00275683          	lhu	a3,2(a4)
    80006754:	8ebd                	xor	a3,a3,a5
    80006756:	8a9d                	andi	a3,a3,7
    80006758:	cab9                	beqz	a3,800067ae <virtio_disk_intr+0x88>
    {
        int id = disk.used->elems[disk.used_idx].id;

        if (disk.info[id].status != 0)
    8000675a:	0001d917          	auipc	s2,0x1d
    8000675e:	8a690913          	addi	s2,s2,-1882 # 80023000 <disk>
            panic("virtio_disk_intr status");

        disk.info[id].b->disk = 0; // disk is done with buf
        wakeup(disk.info[id].b);

        disk.used_idx = (disk.used_idx + 1) % NUM;
    80006762:	0001f497          	auipc	s1,0x1f
    80006766:	89e48493          	addi	s1,s1,-1890 # 80025000 <disk+0x2000>
        int id = disk.used->elems[disk.used_idx].id;
    8000676a:	078e                	slli	a5,a5,0x3
    8000676c:	97ba                	add	a5,a5,a4
    8000676e:	43dc                	lw	a5,4(a5)
        if (disk.info[id].status != 0)
    80006770:	20078713          	addi	a4,a5,512
    80006774:	0712                	slli	a4,a4,0x4
    80006776:	974a                	add	a4,a4,s2
    80006778:	03074703          	lbu	a4,48(a4)
    8000677c:	ef21                	bnez	a4,800067d4 <virtio_disk_intr+0xae>
        disk.info[id].b->disk = 0; // disk is done with buf
    8000677e:	20078793          	addi	a5,a5,512
    80006782:	0792                	slli	a5,a5,0x4
    80006784:	97ca                	add	a5,a5,s2
    80006786:	7798                	ld	a4,40(a5)
    80006788:	00072223          	sw	zero,4(a4)
        wakeup(disk.info[id].b);
    8000678c:	7788                	ld	a0,40(a5)
    8000678e:	ffffc097          	auipc	ra,0xffffc
    80006792:	bcc080e7          	jalr	-1076(ra) # 8000235a <wakeup>
        disk.used_idx = (disk.used_idx + 1) % NUM;
    80006796:	0204d783          	lhu	a5,32(s1)
    8000679a:	2785                	addiw	a5,a5,1
    8000679c:	8b9d                	andi	a5,a5,7
    8000679e:	02f49023          	sh	a5,32(s1)
    while ((disk.used_idx % NUM) != (disk.used->id % NUM))
    800067a2:	6898                	ld	a4,16(s1)
    800067a4:	00275683          	lhu	a3,2(a4)
    800067a8:	8a9d                	andi	a3,a3,7
    800067aa:	fcf690e3          	bne	a3,a5,8000676a <virtio_disk_intr+0x44>
    }
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800067ae:	10001737          	lui	a4,0x10001
    800067b2:	533c                	lw	a5,96(a4)
    800067b4:	8b8d                	andi	a5,a5,3
    800067b6:	d37c                	sw	a5,100(a4)

    release(&disk.vdisk_lock);
    800067b8:	0001f517          	auipc	a0,0x1f
    800067bc:	8f050513          	addi	a0,a0,-1808 # 800250a8 <disk+0x20a8>
    800067c0:	ffffa097          	auipc	ra,0xffffa
    800067c4:	4f2080e7          	jalr	1266(ra) # 80000cb2 <release>
}
    800067c8:	60e2                	ld	ra,24(sp)
    800067ca:	6442                	ld	s0,16(sp)
    800067cc:	64a2                	ld	s1,8(sp)
    800067ce:	6902                	ld	s2,0(sp)
    800067d0:	6105                	addi	sp,sp,32
    800067d2:	8082                	ret
            panic("virtio_disk_intr status");
    800067d4:	00002517          	auipc	a0,0x2
    800067d8:	1ec50513          	addi	a0,a0,492 # 800089c0 <syscalls+0x598>
    800067dc:	ffffa097          	auipc	ra,0xffffa
    800067e0:	d66080e7          	jalr	-666(ra) # 80000542 <panic>
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
