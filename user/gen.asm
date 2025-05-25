
user/_gen:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <mkfile>:
#include "user/user.h"

typedef void (*test_func_t)();

void mkfile(char *filename)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    int fd = open(filename, O_CREATE | O_RDWR);
   a:	20200593          	li	a1,514
   e:	00000097          	auipc	ra,0x0
  12:	56a080e7          	jalr	1386(ra) # 578 <open>
  16:	84aa                	mv	s1,a0
    write(fd, "hi", 3);
  18:	460d                	li	a2,3
  1a:	00001597          	auipc	a1,0x1
  1e:	a7e58593          	addi	a1,a1,-1410 # a98 <malloc+0xea>
  22:	00000097          	auipc	ra,0x0
  26:	536080e7          	jalr	1334(ra) # 558 <write>
    close(fd);
  2a:	8526                	mv	a0,s1
  2c:	00000097          	auipc	ra,0x0
  30:	534080e7          	jalr	1332(ra) # 560 <close>
}
  34:	60e2                	ld	ra,24(sp)
  36:	6442                	ld	s0,16(sp)
  38:	64a2                	ld	s1,8(sp)
  3a:	6105                	addi	sp,sp,32
  3c:	8082                	ret

000000000000003e <mkd>:

void mkd(char *dirname)
{
  3e:	1101                	addi	sp,sp,-32
  40:	ec06                	sd	ra,24(sp)
  42:	e822                	sd	s0,16(sp)
  44:	e426                	sd	s1,8(sp)
  46:	1000                	addi	s0,sp,32
  48:	84aa                	mv	s1,a0
    if (mkdir(dirname) < 0)
  4a:	00000097          	auipc	ra,0x0
  4e:	556080e7          	jalr	1366(ra) # 5a0 <mkdir>
  52:	00054763          	bltz	a0,60 <mkd+0x22>
    {
        fprintf(2, "mkdir %s failed.", dirname);
        exit(1);
    }
}
  56:	60e2                	ld	ra,24(sp)
  58:	6442                	ld	s0,16(sp)
  5a:	64a2                	ld	s1,8(sp)
  5c:	6105                	addi	sp,sp,32
  5e:	8082                	ret
        fprintf(2, "mkdir %s failed.", dirname);
  60:	8626                	mv	a2,s1
  62:	00001597          	auipc	a1,0x1
  66:	a3e58593          	addi	a1,a1,-1474 # aa0 <malloc+0xf2>
  6a:	4509                	li	a0,2
  6c:	00001097          	auipc	ra,0x1
  70:	856080e7          	jalr	-1962(ra) # 8c2 <fprintf>
        exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	4c2080e7          	jalr	1218(ra) # 538 <exit>

000000000000007e <gentest1>:

void gentest1()
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
    mkd("test1");
  86:	00001517          	auipc	a0,0x1
  8a:	a3250513          	addi	a0,a0,-1486 # ab8 <malloc+0x10a>
  8e:	00000097          	auipc	ra,0x0
  92:	fb0080e7          	jalr	-80(ra) # 3e <mkd>
    mkfile("test1/a");
  96:	00001517          	auipc	a0,0x1
  9a:	a2a50513          	addi	a0,a0,-1494 # ac0 <malloc+0x112>
  9e:	00000097          	auipc	ra,0x0
  a2:	f62080e7          	jalr	-158(ra) # 0 <mkfile>
    mkfile("test1/b");
  a6:	00001517          	auipc	a0,0x1
  aa:	a2250513          	addi	a0,a0,-1502 # ac8 <malloc+0x11a>
  ae:	00000097          	auipc	ra,0x0
  b2:	f52080e7          	jalr	-174(ra) # 0 <mkfile>
    mkfile("test1/c");
  b6:	00001517          	auipc	a0,0x1
  ba:	a1a50513          	addi	a0,a0,-1510 # ad0 <malloc+0x122>
  be:	00000097          	auipc	ra,0x0
  c2:	f42080e7          	jalr	-190(ra) # 0 <mkfile>
    mkd("test1/d");
  c6:	00001517          	auipc	a0,0x1
  ca:	a1250513          	addi	a0,a0,-1518 # ad8 <malloc+0x12a>
  ce:	00000097          	auipc	ra,0x0
  d2:	f70080e7          	jalr	-144(ra) # 3e <mkd>
    mkfile("test1/d/a");
  d6:	00001517          	auipc	a0,0x1
  da:	a0a50513          	addi	a0,a0,-1526 # ae0 <malloc+0x132>
  de:	00000097          	auipc	ra,0x0
  e2:	f22080e7          	jalr	-222(ra) # 0 <mkfile>
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <gentest2>:

void gentest2()
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
    mkd("test2");
  f6:	00001517          	auipc	a0,0x1
  fa:	9fa50513          	addi	a0,a0,-1542 # af0 <malloc+0x142>
  fe:	00000097          	auipc	ra,0x0
 102:	f40080e7          	jalr	-192(ra) # 3e <mkd>
    mkd("test2/d1");
 106:	00001517          	auipc	a0,0x1
 10a:	9f250513          	addi	a0,a0,-1550 # af8 <malloc+0x14a>
 10e:	00000097          	auipc	ra,0x0
 112:	f30080e7          	jalr	-208(ra) # 3e <mkd>
    mkd("test2/d2");
 116:	00001517          	auipc	a0,0x1
 11a:	9f250513          	addi	a0,a0,-1550 # b08 <malloc+0x15a>
 11e:	00000097          	auipc	ra,0x0
 122:	f20080e7          	jalr	-224(ra) # 3e <mkd>
    mkd("test2/d3");
 126:	00001517          	auipc	a0,0x1
 12a:	9f250513          	addi	a0,a0,-1550 # b18 <malloc+0x16a>
 12e:	00000097          	auipc	ra,0x0
 132:	f10080e7          	jalr	-240(ra) # 3e <mkd>
    mkfile("test2/d1/f1");
 136:	00001517          	auipc	a0,0x1
 13a:	9f250513          	addi	a0,a0,-1550 # b28 <malloc+0x17a>
 13e:	00000097          	auipc	ra,0x0
 142:	ec2080e7          	jalr	-318(ra) # 0 <mkfile>
    mkfile("test2/d2/f2");
 146:	00001517          	auipc	a0,0x1
 14a:	9f250513          	addi	a0,a0,-1550 # b38 <malloc+0x18a>
 14e:	00000097          	auipc	ra,0x0
 152:	eb2080e7          	jalr	-334(ra) # 0 <mkfile>
    mkfile("test2/d3/f3");
 156:	00001517          	auipc	a0,0x1
 15a:	9f250513          	addi	a0,a0,-1550 # b48 <malloc+0x19a>
 15e:	00000097          	auipc	ra,0x0
 162:	ea2080e7          	jalr	-350(ra) # 0 <mkfile>
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <gentest3>:

void gentest3()
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
    mkd("test3");
 176:	00001517          	auipc	a0,0x1
 17a:	9e250513          	addi	a0,a0,-1566 # b58 <malloc+0x1aa>
 17e:	00000097          	auipc	ra,0x0
 182:	ec0080e7          	jalr	-320(ra) # 3e <mkd>
    mkd("test3/d1");
 186:	00001517          	auipc	a0,0x1
 18a:	9da50513          	addi	a0,a0,-1574 # b60 <malloc+0x1b2>
 18e:	00000097          	auipc	ra,0x0
 192:	eb0080e7          	jalr	-336(ra) # 3e <mkd>
    mkd("test3/d1/D");
 196:	00001517          	auipc	a0,0x1
 19a:	9da50513          	addi	a0,a0,-1574 # b70 <malloc+0x1c2>
 19e:	00000097          	auipc	ra,0x0
 1a2:	ea0080e7          	jalr	-352(ra) # 3e <mkd>
    mkfile("test3/d1/f1");
 1a6:	00001517          	auipc	a0,0x1
 1aa:	9da50513          	addi	a0,a0,-1574 # b80 <malloc+0x1d2>
 1ae:	00000097          	auipc	ra,0x0
 1b2:	e52080e7          	jalr	-430(ra) # 0 <mkfile>
    mkfile("test3/d1/f2");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	9da50513          	addi	a0,a0,-1574 # b90 <malloc+0x1e2>
 1be:	00000097          	auipc	ra,0x0
 1c2:	e42080e7          	jalr	-446(ra) # 0 <mkfile>
    mkfile("test3/d1/f3");
 1c6:	00001517          	auipc	a0,0x1
 1ca:	9da50513          	addi	a0,a0,-1574 # ba0 <malloc+0x1f2>
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e32080e7          	jalr	-462(ra) # 0 <mkfile>
    mkfile("test3/d1/D/F");
 1d6:	00001517          	auipc	a0,0x1
 1da:	9da50513          	addi	a0,a0,-1574 # bb0 <malloc+0x202>
 1de:	00000097          	auipc	ra,0x0
 1e2:	e22080e7          	jalr	-478(ra) # 0 <mkfile>
}
 1e6:	60a2                	ld	ra,8(sp)
 1e8:	6402                	ld	s0,0(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret

00000000000001ee <gentest4>:

void gentest4()
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
    mkd("test4");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	9ca50513          	addi	a0,a0,-1590 # bc0 <malloc+0x212>
 1fe:	00000097          	auipc	ra,0x0
 202:	e40080e7          	jalr	-448(ra) # 3e <mkd>
    mkd("test4/dirX");
 206:	00001517          	auipc	a0,0x1
 20a:	9c250513          	addi	a0,a0,-1598 # bc8 <malloc+0x21a>
 20e:	00000097          	auipc	ra,0x0
 212:	e30080e7          	jalr	-464(ra) # 3e <mkd>
    mkfile("test4/dirX/a");
 216:	00001517          	auipc	a0,0x1
 21a:	9c250513          	addi	a0,a0,-1598 # bd8 <malloc+0x22a>
 21e:	00000097          	auipc	ra,0x0
 222:	de2080e7          	jalr	-542(ra) # 0 <mkfile>
    mkfile("test4/dirX/b");
 226:	00001517          	auipc	a0,0x1
 22a:	9c250513          	addi	a0,a0,-1598 # be8 <malloc+0x23a>
 22e:	00000097          	auipc	ra,0x0
 232:	dd2080e7          	jalr	-558(ra) # 0 <mkfile>
    mkfile("test4/dirX/c");
 236:	00001517          	auipc	a0,0x1
 23a:	9c250513          	addi	a0,a0,-1598 # bf8 <malloc+0x24a>
 23e:	00000097          	auipc	ra,0x0
 242:	dc2080e7          	jalr	-574(ra) # 0 <mkfile>
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret

000000000000024e <main>:

int main(int argc, char *argv[])
{
 24e:	7179                	addi	sp,sp,-48
 250:	f406                	sd	ra,40(sp)
 252:	f022                	sd	s0,32(sp)
 254:	1800                	addi	s0,sp,48
    if (argc != 2)
 256:	4789                	li	a5,2
 258:	02f50063          	beq	a0,a5,278 <main+0x2a>
    {
        fprintf(2, "Usage: gen [n]\n");
 25c:	00001597          	auipc	a1,0x1
 260:	9ac58593          	addi	a1,a1,-1620 # c08 <malloc+0x25a>
 264:	4509                	li	a0,2
 266:	00000097          	auipc	ra,0x0
 26a:	65c080e7          	jalr	1628(ra) # 8c2 <fprintf>
        exit(1);
 26e:	4505                	li	a0,1
 270:	00000097          	auipc	ra,0x0
 274:	2c8080e7          	jalr	712(ra) # 538 <exit>
    }
    int n;

    n = atoi(argv[1]);
 278:	6588                	ld	a0,8(a1)
 27a:	00000097          	auipc	ra,0x0
 27e:	1c2080e7          	jalr	450(ra) # 43c <atoi>
    test_func_t tests[] = {gentest1, gentest2, gentest3, gentest4};
 282:	00000797          	auipc	a5,0x0
 286:	dfc78793          	addi	a5,a5,-516 # 7e <gentest1>
 28a:	fcf43823          	sd	a5,-48(s0)
 28e:	00000797          	auipc	a5,0x0
 292:	e6078793          	addi	a5,a5,-416 # ee <gentest2>
 296:	fcf43c23          	sd	a5,-40(s0)
 29a:	00000797          	auipc	a5,0x0
 29e:	ed478793          	addi	a5,a5,-300 # 16e <gentest3>
 2a2:	fef43023          	sd	a5,-32(s0)
 2a6:	00000797          	auipc	a5,0x0
 2aa:	f4878793          	addi	a5,a5,-184 # 1ee <gentest4>
 2ae:	fef43423          	sd	a5,-24(s0)
    tests[n]();
 2b2:	050e                	slli	a0,a0,0x3
 2b4:	ff040793          	addi	a5,s0,-16
 2b8:	953e                	add	a0,a0,a5
 2ba:	fe053783          	ld	a5,-32(a0)
 2be:	9782                	jalr	a5

    exit(0);
 2c0:	4501                	li	a0,0
 2c2:	00000097          	auipc	ra,0x0
 2c6:	276080e7          	jalr	630(ra) # 538 <exit>

00000000000002ca <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 2d0:	87aa                	mv	a5,a0
 2d2:	0585                	addi	a1,a1,1
 2d4:	0785                	addi	a5,a5,1
 2d6:	fff5c703          	lbu	a4,-1(a1)
 2da:	fee78fa3          	sb	a4,-1(a5)
 2de:	fb75                	bnez	a4,2d2 <strcpy+0x8>
        ;
    return os;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strcmp>:

int strcmp(const char *p, const char *q)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	cb91                	beqz	a5,304 <strcmp+0x1e>
 2f2:	0005c703          	lbu	a4,0(a1)
 2f6:	00f71763          	bne	a4,a5,304 <strcmp+0x1e>
        p++, q++;
 2fa:	0505                	addi	a0,a0,1
 2fc:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 2fe:	00054783          	lbu	a5,0(a0)
 302:	fbe5                	bnez	a5,2f2 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 304:	0005c503          	lbu	a0,0(a1)
}
 308:	40a7853b          	subw	a0,a5,a0
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <strlen>:

uint strlen(const char *s)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cf91                	beqz	a5,338 <strlen+0x26>
 31e:	0505                	addi	a0,a0,1
 320:	87aa                	mv	a5,a0
 322:	4685                	li	a3,1
 324:	9e89                	subw	a3,a3,a0
 326:	00f6853b          	addw	a0,a3,a5
 32a:	0785                	addi	a5,a5,1
 32c:	fff7c703          	lbu	a4,-1(a5)
 330:	fb7d                	bnez	a4,326 <strlen+0x14>
        ;
    return n;
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
    for (n = 0; s[n]; n++)
 338:	4501                	li	a0,0
 33a:	bfe5                	j	332 <strlen+0x20>

000000000000033c <memset>:

void *memset(void *dst, int c, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 342:	ca19                	beqz	a2,358 <memset+0x1c>
 344:	87aa                	mv	a5,a0
 346:	1602                	slli	a2,a2,0x20
 348:	9201                	srli	a2,a2,0x20
 34a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 34e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 352:	0785                	addi	a5,a5,1
 354:	fee79de3          	bne	a5,a4,34e <memset+0x12>
    }
    return dst;
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <strchr>:

char *strchr(const char *s, char c)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
    for (; *s; s++)
 364:	00054783          	lbu	a5,0(a0)
 368:	cb99                	beqz	a5,37e <strchr+0x20>
        if (*s == c)
 36a:	00f58763          	beq	a1,a5,378 <strchr+0x1a>
    for (; *s; s++)
 36e:	0505                	addi	a0,a0,1
 370:	00054783          	lbu	a5,0(a0)
 374:	fbfd                	bnez	a5,36a <strchr+0xc>
            return (char *)s;
    return 0;
 376:	4501                	li	a0,0
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
    return 0;
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <strchr+0x1a>

0000000000000382 <gets>:

char *gets(char *buf, int max)
{
 382:	711d                	addi	sp,sp,-96
 384:	ec86                	sd	ra,88(sp)
 386:	e8a2                	sd	s0,80(sp)
 388:	e4a6                	sd	s1,72(sp)
 38a:	e0ca                	sd	s2,64(sp)
 38c:	fc4e                	sd	s3,56(sp)
 38e:	f852                	sd	s4,48(sp)
 390:	f456                	sd	s5,40(sp)
 392:	f05a                	sd	s6,32(sp)
 394:	ec5e                	sd	s7,24(sp)
 396:	1080                	addi	s0,sp,96
 398:	8baa                	mv	s7,a0
 39a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 39c:	892a                	mv	s2,a0
 39e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 3a0:	4aa9                	li	s5,10
 3a2:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 3a4:	89a6                	mv	s3,s1
 3a6:	2485                	addiw	s1,s1,1
 3a8:	0344d863          	bge	s1,s4,3d8 <gets+0x56>
        cc = read(0, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	faf40593          	addi	a1,s0,-81
 3b2:	4501                	li	a0,0
 3b4:	00000097          	auipc	ra,0x0
 3b8:	19c080e7          	jalr	412(ra) # 550 <read>
        if (cc < 1)
 3bc:	00a05e63          	blez	a0,3d8 <gets+0x56>
        buf[i++] = c;
 3c0:	faf44783          	lbu	a5,-81(s0)
 3c4:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 3c8:	01578763          	beq	a5,s5,3d6 <gets+0x54>
 3cc:	0905                	addi	s2,s2,1
 3ce:	fd679be3          	bne	a5,s6,3a4 <gets+0x22>
    for (i = 0; i + 1 < max;)
 3d2:	89a6                	mv	s3,s1
 3d4:	a011                	j	3d8 <gets+0x56>
 3d6:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 3d8:	99de                	add	s3,s3,s7
 3da:	00098023          	sb	zero,0(s3)
    return buf;
}
 3de:	855e                	mv	a0,s7
 3e0:	60e6                	ld	ra,88(sp)
 3e2:	6446                	ld	s0,80(sp)
 3e4:	64a6                	ld	s1,72(sp)
 3e6:	6906                	ld	s2,64(sp)
 3e8:	79e2                	ld	s3,56(sp)
 3ea:	7a42                	ld	s4,48(sp)
 3ec:	7aa2                	ld	s5,40(sp)
 3ee:	7b02                	ld	s6,32(sp)
 3f0:	6be2                	ld	s7,24(sp)
 3f2:	6125                	addi	sp,sp,96
 3f4:	8082                	ret

00000000000003f6 <stat>:

int stat(const char *n, struct stat *st)
{
 3f6:	1101                	addi	sp,sp,-32
 3f8:	ec06                	sd	ra,24(sp)
 3fa:	e822                	sd	s0,16(sp)
 3fc:	e426                	sd	s1,8(sp)
 3fe:	e04a                	sd	s2,0(sp)
 400:	1000                	addi	s0,sp,32
 402:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 404:	4581                	li	a1,0
 406:	00000097          	auipc	ra,0x0
 40a:	172080e7          	jalr	370(ra) # 578 <open>
    if (fd < 0)
 40e:	02054563          	bltz	a0,438 <stat+0x42>
 412:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 414:	85ca                	mv	a1,s2
 416:	00000097          	auipc	ra,0x0
 41a:	17a080e7          	jalr	378(ra) # 590 <fstat>
 41e:	892a                	mv	s2,a0
    close(fd);
 420:	8526                	mv	a0,s1
 422:	00000097          	auipc	ra,0x0
 426:	13e080e7          	jalr	318(ra) # 560 <close>
    return r;
}
 42a:	854a                	mv	a0,s2
 42c:	60e2                	ld	ra,24(sp)
 42e:	6442                	ld	s0,16(sp)
 430:	64a2                	ld	s1,8(sp)
 432:	6902                	ld	s2,0(sp)
 434:	6105                	addi	sp,sp,32
 436:	8082                	ret
        return -1;
 438:	597d                	li	s2,-1
 43a:	bfc5                	j	42a <stat+0x34>

000000000000043c <atoi>:

int atoi(const char *s)
{
 43c:	1141                	addi	sp,sp,-16
 43e:	e422                	sd	s0,8(sp)
 440:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 442:	00054603          	lbu	a2,0(a0)
 446:	fd06079b          	addiw	a5,a2,-48
 44a:	0ff7f793          	andi	a5,a5,255
 44e:	4725                	li	a4,9
 450:	02f76963          	bltu	a4,a5,482 <atoi+0x46>
 454:	86aa                	mv	a3,a0
    n = 0;
 456:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 458:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 45a:	0685                	addi	a3,a3,1
 45c:	0025179b          	slliw	a5,a0,0x2
 460:	9fa9                	addw	a5,a5,a0
 462:	0017979b          	slliw	a5,a5,0x1
 466:	9fb1                	addw	a5,a5,a2
 468:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 46c:	0006c603          	lbu	a2,0(a3)
 470:	fd06071b          	addiw	a4,a2,-48
 474:	0ff77713          	andi	a4,a4,255
 478:	fee5f1e3          	bgeu	a1,a4,45a <atoi+0x1e>
    return n;
}
 47c:	6422                	ld	s0,8(sp)
 47e:	0141                	addi	sp,sp,16
 480:	8082                	ret
    n = 0;
 482:	4501                	li	a0,0
 484:	bfe5                	j	47c <atoi+0x40>

0000000000000486 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 486:	1141                	addi	sp,sp,-16
 488:	e422                	sd	s0,8(sp)
 48a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 48c:	02b57463          	bgeu	a0,a1,4b4 <memmove+0x2e>
    {
        while (n-- > 0)
 490:	00c05f63          	blez	a2,4ae <memmove+0x28>
 494:	1602                	slli	a2,a2,0x20
 496:	9201                	srli	a2,a2,0x20
 498:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 49c:	872a                	mv	a4,a0
            *dst++ = *src++;
 49e:	0585                	addi	a1,a1,1
 4a0:	0705                	addi	a4,a4,1
 4a2:	fff5c683          	lbu	a3,-1(a1)
 4a6:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 4aa:	fee79ae3          	bne	a5,a4,49e <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 4ae:	6422                	ld	s0,8(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret
        dst += n;
 4b4:	00c50733          	add	a4,a0,a2
        src += n;
 4b8:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 4ba:	fec05ae3          	blez	a2,4ae <memmove+0x28>
 4be:	fff6079b          	addiw	a5,a2,-1
 4c2:	1782                	slli	a5,a5,0x20
 4c4:	9381                	srli	a5,a5,0x20
 4c6:	fff7c793          	not	a5,a5
 4ca:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 4cc:	15fd                	addi	a1,a1,-1
 4ce:	177d                	addi	a4,a4,-1
 4d0:	0005c683          	lbu	a3,0(a1)
 4d4:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 4d8:	fee79ae3          	bne	a5,a4,4cc <memmove+0x46>
 4dc:	bfc9                	j	4ae <memmove+0x28>

00000000000004de <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e422                	sd	s0,8(sp)
 4e2:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 4e4:	ca05                	beqz	a2,514 <memcmp+0x36>
 4e6:	fff6069b          	addiw	a3,a2,-1
 4ea:	1682                	slli	a3,a3,0x20
 4ec:	9281                	srli	a3,a3,0x20
 4ee:	0685                	addi	a3,a3,1
 4f0:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 4f2:	00054783          	lbu	a5,0(a0)
 4f6:	0005c703          	lbu	a4,0(a1)
 4fa:	00e79863          	bne	a5,a4,50a <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 4fe:	0505                	addi	a0,a0,1
        p2++;
 500:	0585                	addi	a1,a1,1
    while (n-- > 0)
 502:	fed518e3          	bne	a0,a3,4f2 <memcmp+0x14>
    }
    return 0;
 506:	4501                	li	a0,0
 508:	a019                	j	50e <memcmp+0x30>
            return *p1 - *p2;
 50a:	40e7853b          	subw	a0,a5,a4
}
 50e:	6422                	ld	s0,8(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret
    return 0;
 514:	4501                	li	a0,0
 516:	bfe5                	j	50e <memcmp+0x30>

0000000000000518 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 518:	1141                	addi	sp,sp,-16
 51a:	e406                	sd	ra,8(sp)
 51c:	e022                	sd	s0,0(sp)
 51e:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 520:	00000097          	auipc	ra,0x0
 524:	f66080e7          	jalr	-154(ra) # 486 <memmove>
}
 528:	60a2                	ld	ra,8(sp)
 52a:	6402                	ld	s0,0(sp)
 52c:	0141                	addi	sp,sp,16
 52e:	8082                	ret

0000000000000530 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 530:	4885                	li	a7,1
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <exit>:
.global exit
exit:
 li a7, SYS_exit
 538:	4889                	li	a7,2
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <wait>:
.global wait
wait:
 li a7, SYS_wait
 540:	488d                	li	a7,3
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 548:	4891                	li	a7,4
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <read>:
.global read
read:
 li a7, SYS_read
 550:	4895                	li	a7,5
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <write>:
.global write
write:
 li a7, SYS_write
 558:	48c1                	li	a7,16
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <close>:
.global close
close:
 li a7, SYS_close
 560:	48d5                	li	a7,21
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <kill>:
.global kill
kill:
 li a7, SYS_kill
 568:	4899                	li	a7,6
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <exec>:
.global exec
exec:
 li a7, SYS_exec
 570:	489d                	li	a7,7
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <open>:
.global open
open:
 li a7, SYS_open
 578:	48bd                	li	a7,15
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 580:	48c5                	li	a7,17
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 588:	48c9                	li	a7,18
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 590:	48a1                	li	a7,8
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <link>:
.global link
link:
 li a7, SYS_link
 598:	48cd                	li	a7,19
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a0:	48d1                	li	a7,20
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a8:	48a5                	li	a7,9
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b0:	48a9                	li	a7,10
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b8:	48ad                	li	a7,11
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c0:	48b1                	li	a7,12
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c8:	48b5                	li	a7,13
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d0:	48b9                	li	a7,14
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 5d8:	48d9                	li	a7,22
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 5e0:	48dd                	li	a7,23
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 5e8:	48e1                	li	a7,24
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 5f0:	48e5                	li	a7,25
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 5f8:	48e9                	li	a7,26
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 600:	48ed                	li	a7,27
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 608:	48f5                	li	a7,29
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 610:	48f1                	li	a7,28
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 618:	1101                	addi	sp,sp,-32
 61a:	ec06                	sd	ra,24(sp)
 61c:	e822                	sd	s0,16(sp)
 61e:	1000                	addi	s0,sp,32
 620:	feb407a3          	sb	a1,-17(s0)
 624:	4605                	li	a2,1
 626:	fef40593          	addi	a1,s0,-17
 62a:	00000097          	auipc	ra,0x0
 62e:	f2e080e7          	jalr	-210(ra) # 558 <write>
 632:	60e2                	ld	ra,24(sp)
 634:	6442                	ld	s0,16(sp)
 636:	6105                	addi	sp,sp,32
 638:	8082                	ret

000000000000063a <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 63a:	7139                	addi	sp,sp,-64
 63c:	fc06                	sd	ra,56(sp)
 63e:	f822                	sd	s0,48(sp)
 640:	f426                	sd	s1,40(sp)
 642:	f04a                	sd	s2,32(sp)
 644:	ec4e                	sd	s3,24(sp)
 646:	0080                	addi	s0,sp,64
 648:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 64a:	c299                	beqz	a3,650 <printint+0x16>
 64c:	0805c863          	bltz	a1,6dc <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 650:	2581                	sext.w	a1,a1
    neg = 0;
 652:	4881                	li	a7,0
 654:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 658:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 65a:	2601                	sext.w	a2,a2
 65c:	00000517          	auipc	a0,0x0
 660:	5c450513          	addi	a0,a0,1476 # c20 <digits>
 664:	883a                	mv	a6,a4
 666:	2705                	addiw	a4,a4,1
 668:	02c5f7bb          	remuw	a5,a1,a2
 66c:	1782                	slli	a5,a5,0x20
 66e:	9381                	srli	a5,a5,0x20
 670:	97aa                	add	a5,a5,a0
 672:	0007c783          	lbu	a5,0(a5)
 676:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 67a:	0005879b          	sext.w	a5,a1
 67e:	02c5d5bb          	divuw	a1,a1,a2
 682:	0685                	addi	a3,a3,1
 684:	fec7f0e3          	bgeu	a5,a2,664 <printint+0x2a>
    if (neg)
 688:	00088b63          	beqz	a7,69e <printint+0x64>
        buf[i++] = '-';
 68c:	fd040793          	addi	a5,s0,-48
 690:	973e                	add	a4,a4,a5
 692:	02d00793          	li	a5,45
 696:	fef70823          	sb	a5,-16(a4)
 69a:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 69e:	02e05863          	blez	a4,6ce <printint+0x94>
 6a2:	fc040793          	addi	a5,s0,-64
 6a6:	00e78933          	add	s2,a5,a4
 6aa:	fff78993          	addi	s3,a5,-1
 6ae:	99ba                	add	s3,s3,a4
 6b0:	377d                	addiw	a4,a4,-1
 6b2:	1702                	slli	a4,a4,0x20
 6b4:	9301                	srli	a4,a4,0x20
 6b6:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 6ba:	fff94583          	lbu	a1,-1(s2)
 6be:	8526                	mv	a0,s1
 6c0:	00000097          	auipc	ra,0x0
 6c4:	f58080e7          	jalr	-168(ra) # 618 <putc>
    while (--i >= 0)
 6c8:	197d                	addi	s2,s2,-1
 6ca:	ff3918e3          	bne	s2,s3,6ba <printint+0x80>
}
 6ce:	70e2                	ld	ra,56(sp)
 6d0:	7442                	ld	s0,48(sp)
 6d2:	74a2                	ld	s1,40(sp)
 6d4:	7902                	ld	s2,32(sp)
 6d6:	69e2                	ld	s3,24(sp)
 6d8:	6121                	addi	sp,sp,64
 6da:	8082                	ret
        x = -xx;
 6dc:	40b005bb          	negw	a1,a1
        neg = 1;
 6e0:	4885                	li	a7,1
        x = -xx;
 6e2:	bf8d                	j	654 <printint+0x1a>

00000000000006e4 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 6e4:	7119                	addi	sp,sp,-128
 6e6:	fc86                	sd	ra,120(sp)
 6e8:	f8a2                	sd	s0,112(sp)
 6ea:	f4a6                	sd	s1,104(sp)
 6ec:	f0ca                	sd	s2,96(sp)
 6ee:	ecce                	sd	s3,88(sp)
 6f0:	e8d2                	sd	s4,80(sp)
 6f2:	e4d6                	sd	s5,72(sp)
 6f4:	e0da                	sd	s6,64(sp)
 6f6:	fc5e                	sd	s7,56(sp)
 6f8:	f862                	sd	s8,48(sp)
 6fa:	f466                	sd	s9,40(sp)
 6fc:	f06a                	sd	s10,32(sp)
 6fe:	ec6e                	sd	s11,24(sp)
 700:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 702:	0005c903          	lbu	s2,0(a1)
 706:	18090f63          	beqz	s2,8a4 <vprintf+0x1c0>
 70a:	8aaa                	mv	s5,a0
 70c:	8b32                	mv	s6,a2
 70e:	00158493          	addi	s1,a1,1
    state = 0;
 712:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 714:	02500a13          	li	s4,37
        {
            if (c == 'd')
 718:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 71c:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 720:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 724:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 728:	00000b97          	auipc	s7,0x0
 72c:	4f8b8b93          	addi	s7,s7,1272 # c20 <digits>
 730:	a839                	j	74e <vprintf+0x6a>
                putc(fd, c);
 732:	85ca                	mv	a1,s2
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	ee2080e7          	jalr	-286(ra) # 618 <putc>
 73e:	a019                	j	744 <vprintf+0x60>
        else if (state == '%')
 740:	01498f63          	beq	s3,s4,75e <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 744:	0485                	addi	s1,s1,1
 746:	fff4c903          	lbu	s2,-1(s1)
 74a:	14090d63          	beqz	s2,8a4 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 74e:	0009079b          	sext.w	a5,s2
        if (state == 0)
 752:	fe0997e3          	bnez	s3,740 <vprintf+0x5c>
            if (c == '%')
 756:	fd479ee3          	bne	a5,s4,732 <vprintf+0x4e>
                state = '%';
 75a:	89be                	mv	s3,a5
 75c:	b7e5                	j	744 <vprintf+0x60>
            if (c == 'd')
 75e:	05878063          	beq	a5,s8,79e <vprintf+0xba>
            else if (c == 'l')
 762:	05978c63          	beq	a5,s9,7ba <vprintf+0xd6>
            else if (c == 'x')
 766:	07a78863          	beq	a5,s10,7d6 <vprintf+0xf2>
            else if (c == 'p')
 76a:	09b78463          	beq	a5,s11,7f2 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 76e:	07300713          	li	a4,115
 772:	0ce78663          	beq	a5,a4,83e <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 776:	06300713          	li	a4,99
 77a:	0ee78e63          	beq	a5,a4,876 <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 77e:	11478863          	beq	a5,s4,88e <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 782:	85d2                	mv	a1,s4
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	e92080e7          	jalr	-366(ra) # 618 <putc>
                putc(fd, c);
 78e:	85ca                	mv	a1,s2
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e86080e7          	jalr	-378(ra) # 618 <putc>
            }
            state = 0;
 79a:	4981                	li	s3,0
 79c:	b765                	j	744 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 79e:	008b0913          	addi	s2,s6,8
 7a2:	4685                	li	a3,1
 7a4:	4629                	li	a2,10
 7a6:	000b2583          	lw	a1,0(s6)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e8e080e7          	jalr	-370(ra) # 63a <printint>
 7b4:	8b4a                	mv	s6,s2
            state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b771                	j	744 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 7ba:	008b0913          	addi	s2,s6,8
 7be:	4681                	li	a3,0
 7c0:	4629                	li	a2,10
 7c2:	000b2583          	lw	a1,0(s6)
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	e72080e7          	jalr	-398(ra) # 63a <printint>
 7d0:	8b4a                	mv	s6,s2
            state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bf85                	j	744 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 7d6:	008b0913          	addi	s2,s6,8
 7da:	4681                	li	a3,0
 7dc:	4641                	li	a2,16
 7de:	000b2583          	lw	a1,0(s6)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e56080e7          	jalr	-426(ra) # 63a <printint>
 7ec:	8b4a                	mv	s6,s2
            state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bf91                	j	744 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 7f2:	008b0793          	addi	a5,s6,8
 7f6:	f8f43423          	sd	a5,-120(s0)
 7fa:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 7fe:	03000593          	li	a1,48
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e14080e7          	jalr	-492(ra) # 618 <putc>
    putc(fd, 'x');
 80c:	85ea                	mv	a1,s10
 80e:	8556                	mv	a0,s5
 810:	00000097          	auipc	ra,0x0
 814:	e08080e7          	jalr	-504(ra) # 618 <putc>
 818:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 81a:	03c9d793          	srli	a5,s3,0x3c
 81e:	97de                	add	a5,a5,s7
 820:	0007c583          	lbu	a1,0(a5)
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	df2080e7          	jalr	-526(ra) # 618 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 82e:	0992                	slli	s3,s3,0x4
 830:	397d                	addiw	s2,s2,-1
 832:	fe0914e3          	bnez	s2,81a <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 836:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 83a:	4981                	li	s3,0
 83c:	b721                	j	744 <vprintf+0x60>
                s = va_arg(ap, char *);
 83e:	008b0993          	addi	s3,s6,8
 842:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 846:	02090163          	beqz	s2,868 <vprintf+0x184>
                while (*s != 0)
 84a:	00094583          	lbu	a1,0(s2)
 84e:	c9a1                	beqz	a1,89e <vprintf+0x1ba>
                    putc(fd, *s);
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	dc6080e7          	jalr	-570(ra) # 618 <putc>
                    s++;
 85a:	0905                	addi	s2,s2,1
                while (*s != 0)
 85c:	00094583          	lbu	a1,0(s2)
 860:	f9e5                	bnez	a1,850 <vprintf+0x16c>
                s = va_arg(ap, char *);
 862:	8b4e                	mv	s6,s3
            state = 0;
 864:	4981                	li	s3,0
 866:	bdf9                	j	744 <vprintf+0x60>
                    s = "(null)";
 868:	00000917          	auipc	s2,0x0
 86c:	3b090913          	addi	s2,s2,944 # c18 <malloc+0x26a>
                while (*s != 0)
 870:	02800593          	li	a1,40
 874:	bff1                	j	850 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 876:	008b0913          	addi	s2,s6,8
 87a:	000b4583          	lbu	a1,0(s6)
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	d98080e7          	jalr	-616(ra) # 618 <putc>
 888:	8b4a                	mv	s6,s2
            state = 0;
 88a:	4981                	li	s3,0
 88c:	bd65                	j	744 <vprintf+0x60>
                putc(fd, c);
 88e:	85d2                	mv	a1,s4
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	d86080e7          	jalr	-634(ra) # 618 <putc>
            state = 0;
 89a:	4981                	li	s3,0
 89c:	b565                	j	744 <vprintf+0x60>
                s = va_arg(ap, char *);
 89e:	8b4e                	mv	s6,s3
            state = 0;
 8a0:	4981                	li	s3,0
 8a2:	b54d                	j	744 <vprintf+0x60>
        }
    }
}
 8a4:	70e6                	ld	ra,120(sp)
 8a6:	7446                	ld	s0,112(sp)
 8a8:	74a6                	ld	s1,104(sp)
 8aa:	7906                	ld	s2,96(sp)
 8ac:	69e6                	ld	s3,88(sp)
 8ae:	6a46                	ld	s4,80(sp)
 8b0:	6aa6                	ld	s5,72(sp)
 8b2:	6b06                	ld	s6,64(sp)
 8b4:	7be2                	ld	s7,56(sp)
 8b6:	7c42                	ld	s8,48(sp)
 8b8:	7ca2                	ld	s9,40(sp)
 8ba:	7d02                	ld	s10,32(sp)
 8bc:	6de2                	ld	s11,24(sp)
 8be:	6109                	addi	sp,sp,128
 8c0:	8082                	ret

00000000000008c2 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 8c2:	715d                	addi	sp,sp,-80
 8c4:	ec06                	sd	ra,24(sp)
 8c6:	e822                	sd	s0,16(sp)
 8c8:	1000                	addi	s0,sp,32
 8ca:	e010                	sd	a2,0(s0)
 8cc:	e414                	sd	a3,8(s0)
 8ce:	e818                	sd	a4,16(s0)
 8d0:	ec1c                	sd	a5,24(s0)
 8d2:	03043023          	sd	a6,32(s0)
 8d6:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 8da:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 8de:	8622                	mv	a2,s0
 8e0:	00000097          	auipc	ra,0x0
 8e4:	e04080e7          	jalr	-508(ra) # 6e4 <vprintf>
}
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	6161                	addi	sp,sp,80
 8ee:	8082                	ret

00000000000008f0 <printf>:

void printf(const char *fmt, ...)
{
 8f0:	711d                	addi	sp,sp,-96
 8f2:	ec06                	sd	ra,24(sp)
 8f4:	e822                	sd	s0,16(sp)
 8f6:	1000                	addi	s0,sp,32
 8f8:	e40c                	sd	a1,8(s0)
 8fa:	e810                	sd	a2,16(s0)
 8fc:	ec14                	sd	a3,24(s0)
 8fe:	f018                	sd	a4,32(s0)
 900:	f41c                	sd	a5,40(s0)
 902:	03043823          	sd	a6,48(s0)
 906:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 90a:	00840613          	addi	a2,s0,8
 90e:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 912:	85aa                	mv	a1,a0
 914:	4505                	li	a0,1
 916:	00000097          	auipc	ra,0x0
 91a:	dce080e7          	jalr	-562(ra) # 6e4 <vprintf>
}
 91e:	60e2                	ld	ra,24(sp)
 920:	6442                	ld	s0,16(sp)
 922:	6125                	addi	sp,sp,96
 924:	8082                	ret

0000000000000926 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 926:	1141                	addi	sp,sp,-16
 928:	e422                	sd	s0,8(sp)
 92a:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 92c:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 930:	00000797          	auipc	a5,0x0
 934:	3087b783          	ld	a5,776(a5) # c38 <freep>
 938:	a805                	j	968 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 93a:	4618                	lw	a4,8(a2)
 93c:	9db9                	addw	a1,a1,a4
 93e:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 942:	6398                	ld	a4,0(a5)
 944:	6318                	ld	a4,0(a4)
 946:	fee53823          	sd	a4,-16(a0)
 94a:	a091                	j	98e <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 94c:	ff852703          	lw	a4,-8(a0)
 950:	9e39                	addw	a2,a2,a4
 952:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 954:	ff053703          	ld	a4,-16(a0)
 958:	e398                	sd	a4,0(a5)
 95a:	a099                	j	9a0 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95c:	6398                	ld	a4,0(a5)
 95e:	00e7e463          	bltu	a5,a4,966 <free+0x40>
 962:	00e6ea63          	bltu	a3,a4,976 <free+0x50>
{
 966:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	fed7fae3          	bgeu	a5,a3,95c <free+0x36>
 96c:	6398                	ld	a4,0(a5)
 96e:	00e6e463          	bltu	a3,a4,976 <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	fee7eae3          	bltu	a5,a4,966 <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 976:	ff852583          	lw	a1,-8(a0)
 97a:	6390                	ld	a2,0(a5)
 97c:	02059713          	slli	a4,a1,0x20
 980:	9301                	srli	a4,a4,0x20
 982:	0712                	slli	a4,a4,0x4
 984:	9736                	add	a4,a4,a3
 986:	fae60ae3          	beq	a2,a4,93a <free+0x14>
        bp->s.ptr = p->s.ptr;
 98a:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 98e:	4790                	lw	a2,8(a5)
 990:	02061713          	slli	a4,a2,0x20
 994:	9301                	srli	a4,a4,0x20
 996:	0712                	slli	a4,a4,0x4
 998:	973e                	add	a4,a4,a5
 99a:	fae689e3          	beq	a3,a4,94c <free+0x26>
    }
    else
        p->s.ptr = bp;
 99e:	e394                	sd	a3,0(a5)
    freep = p;
 9a0:	00000717          	auipc	a4,0x0
 9a4:	28f73c23          	sd	a5,664(a4) # c38 <freep>
}
 9a8:	6422                	ld	s0,8(sp)
 9aa:	0141                	addi	sp,sp,16
 9ac:	8082                	ret

00000000000009ae <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 9ae:	7139                	addi	sp,sp,-64
 9b0:	fc06                	sd	ra,56(sp)
 9b2:	f822                	sd	s0,48(sp)
 9b4:	f426                	sd	s1,40(sp)
 9b6:	f04a                	sd	s2,32(sp)
 9b8:	ec4e                	sd	s3,24(sp)
 9ba:	e852                	sd	s4,16(sp)
 9bc:	e456                	sd	s5,8(sp)
 9be:	e05a                	sd	s6,0(sp)
 9c0:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9c2:	02051493          	slli	s1,a0,0x20
 9c6:	9081                	srli	s1,s1,0x20
 9c8:	04bd                	addi	s1,s1,15
 9ca:	8091                	srli	s1,s1,0x4
 9cc:	0014899b          	addiw	s3,s1,1
 9d0:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 9d2:	00000517          	auipc	a0,0x0
 9d6:	26653503          	ld	a0,614(a0) # c38 <freep>
 9da:	c515                	beqz	a0,a06 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9dc:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 9de:	4798                	lw	a4,8(a5)
 9e0:	02977f63          	bgeu	a4,s1,a1e <malloc+0x70>
 9e4:	8a4e                	mv	s4,s3
 9e6:	0009871b          	sext.w	a4,s3
 9ea:	6685                	lui	a3,0x1
 9ec:	00d77363          	bgeu	a4,a3,9f2 <malloc+0x44>
 9f0:	6a05                	lui	s4,0x1
 9f2:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 9f6:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 9fa:	00000917          	auipc	s2,0x0
 9fe:	23e90913          	addi	s2,s2,574 # c38 <freep>
    if (p == (char *)-1)
 a02:	5afd                	li	s5,-1
 a04:	a88d                	j	a76 <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 a06:	00000797          	auipc	a5,0x0
 a0a:	23a78793          	addi	a5,a5,570 # c40 <base>
 a0e:	00000717          	auipc	a4,0x0
 a12:	22f73523          	sd	a5,554(a4) # c38 <freep>
 a16:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 a18:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 a1c:	b7e1                	j	9e4 <malloc+0x36>
            if (p->s.size == nunits)
 a1e:	02e48b63          	beq	s1,a4,a54 <malloc+0xa6>
                p->s.size -= nunits;
 a22:	4137073b          	subw	a4,a4,s3
 a26:	c798                	sw	a4,8(a5)
                p += p->s.size;
 a28:	1702                	slli	a4,a4,0x20
 a2a:	9301                	srli	a4,a4,0x20
 a2c:	0712                	slli	a4,a4,0x4
 a2e:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 a30:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 a34:	00000717          	auipc	a4,0x0
 a38:	20a73223          	sd	a0,516(a4) # c38 <freep>
            return (void *)(p + 1);
 a3c:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 a40:	70e2                	ld	ra,56(sp)
 a42:	7442                	ld	s0,48(sp)
 a44:	74a2                	ld	s1,40(sp)
 a46:	7902                	ld	s2,32(sp)
 a48:	69e2                	ld	s3,24(sp)
 a4a:	6a42                	ld	s4,16(sp)
 a4c:	6aa2                	ld	s5,8(sp)
 a4e:	6b02                	ld	s6,0(sp)
 a50:	6121                	addi	sp,sp,64
 a52:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 a54:	6398                	ld	a4,0(a5)
 a56:	e118                	sd	a4,0(a0)
 a58:	bff1                	j	a34 <malloc+0x86>
    hp->s.size = nu;
 a5a:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 a5e:	0541                	addi	a0,a0,16
 a60:	00000097          	auipc	ra,0x0
 a64:	ec6080e7          	jalr	-314(ra) # 926 <free>
    return freep;
 a68:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 a6c:	d971                	beqz	a0,a40 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a6e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 a70:	4798                	lw	a4,8(a5)
 a72:	fa9776e3          	bgeu	a4,s1,a1e <malloc+0x70>
        if (p == freep)
 a76:	00093703          	ld	a4,0(s2)
 a7a:	853e                	mv	a0,a5
 a7c:	fef719e3          	bne	a4,a5,a6e <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 a80:	8552                	mv	a0,s4
 a82:	00000097          	auipc	ra,0x0
 a86:	b3e080e7          	jalr	-1218(ra) # 5c0 <sbrk>
    if (p == (char *)-1)
 a8a:	fd5518e3          	bne	a0,s5,a5a <malloc+0xac>
                return 0;
 a8e:	4501                	li	a0,0
 a90:	bf45                	j	a40 <malloc+0x92>
