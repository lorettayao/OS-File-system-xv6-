
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:
#include "user/user.h"

char buf[512];

void cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
    int n;

    while ((n = read(fd, buf, sizeof(buf))) > 0)
  10:	00001917          	auipc	s2,0x1
  14:	94890913          	addi	s2,s2,-1720 # 958 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	384080e7          	jalr	900(ra) # 3a4 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    {
        if (write(1, buf, n) != n)
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	378080e7          	jalr	888(ra) # 3ac <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
        {
            fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	8a858593          	addi	a1,a1,-1880 # 8e8 <malloc+0xe6>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6cc080e7          	jalr	1740(ra) # 716 <fprintf>
            exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	338080e7          	jalr	824(ra) # 38c <exit>
        }
    }
    if (n < 0)
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    {
        fprintf(2, "cat: read error\n");
        exit(1);
    }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
        fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	89258593          	addi	a1,a1,-1902 # 900 <malloc+0xfe>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	69e080e7          	jalr	1694(ra) # 716 <fprintf>
        exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	30a080e7          	jalr	778(ra) # 38c <exit>

000000000000008a <main>:

int main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
    int fd, i;

    if (argc <= 1)
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	1982                	slli	s3,s3,0x20
  aa:	0209d993          	srli	s3,s3,0x20
  ae:	098e                	slli	s3,s3,0x3
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
        exit(0);
    }

    for (i = 1; i < argc; i++)
    {
        if ((fd = open(argv[i], 0)) < 0)
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	312080e7          	jalr	786(ra) # 3cc <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
        {
            fprintf(2, "cat: cannot open %s\n", argv[i]);
            exit(1);
        }
        cat(fd);
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
        close(fd);
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	2e2080e7          	jalr	738(ra) # 3b4 <close>
    for (i = 1; i < argc; i++)
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
    }
    exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2aa080e7          	jalr	682(ra) # 38c <exit>
        cat(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
        exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	296080e7          	jalr	662(ra) # 38c <exit>
            fprintf(2, "cat: cannot open %s\n", argv[i]);
  fe:	00093603          	ld	a2,0(s2)
 102:	00001597          	auipc	a1,0x1
 106:	81658593          	addi	a1,a1,-2026 # 918 <malloc+0x116>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	60a080e7          	jalr	1546(ra) # 716 <fprintf>
            exit(1);
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	276080e7          	jalr	630(ra) # 38c <exit>

000000000000011e <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
        ;
    return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
        p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
        ;
    return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
    for (n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void *memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
    }
    return dst;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:

char *strchr(const char *s, char c)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
    for (; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
        if (*s == c)
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
    for (; *s; s++)
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
            return (char *)s;
    return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
    return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:

char *gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d863          	bge	s1,s4,22c <gets+0x56>
        cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	19c080e7          	jalr	412(ra) # 3a4 <read>
        if (cc < 1)
 210:	00a05e63          	blez	a0,22c <gets+0x56>
        buf[i++] = c;
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 21c:	01578763          	beq	a5,s5,22a <gets+0x54>
 220:	0905                	addi	s2,s2,1
 222:	fd679be3          	bne	a5,s6,1f8 <gets+0x22>
    for (i = 0; i + 1 < max;)
 226:	89a6                	mv	s3,s1
 228:	a011                	j	22c <gets+0x56>
 22a:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
    return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	172080e7          	jalr	370(ra) # 3cc <open>
    if (fd < 0)
 262:	02054563          	bltz	a0,28c <stat+0x42>
 266:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 268:	85ca                	mv	a1,s2
 26a:	00000097          	auipc	ra,0x0
 26e:	17a080e7          	jalr	378(ra) # 3e4 <fstat>
 272:	892a                	mv	s2,a0
    close(fd);
 274:	8526                	mv	a0,s1
 276:	00000097          	auipc	ra,0x0
 27a:	13e080e7          	jalr	318(ra) # 3b4 <close>
    return r;
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	64a2                	ld	s1,8(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
        return -1;
 28c:	597d                	li	s2,-1
 28e:	bfc5                	j	27e <stat+0x34>

0000000000000290 <atoi>:

int atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 296:	00054603          	lbu	a2,0(a0)
 29a:	fd06079b          	addiw	a5,a2,-48
 29e:	0ff7f793          	andi	a5,a5,255
 2a2:	4725                	li	a4,9
 2a4:	02f76963          	bltu	a4,a5,2d6 <atoi+0x46>
 2a8:	86aa                	mv	a3,a0
    n = 0;
 2aa:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 2ac:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 2ae:	0685                	addi	a3,a3,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb1                	addw	a5,a5,a2
 2bc:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 2c0:	0006c603          	lbu	a2,0(a3)
 2c4:	fd06071b          	addiw	a4,a2,-48
 2c8:	0ff77713          	andi	a4,a4,255
 2cc:	fee5f1e3          	bgeu	a1,a4,2ae <atoi+0x1e>
    return n;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
    n = 0;
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <atoi+0x40>

00000000000002da <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 2e0:	02b57463          	bgeu	a0,a1,308 <memmove+0x2e>
    {
        while (n-- > 0)
 2e4:	00c05f63          	blez	a2,302 <memmove+0x28>
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 2f0:	872a                	mv	a4,a0
            *dst++ = *src++;
 2f2:	0585                	addi	a1,a1,1
 2f4:	0705                	addi	a4,a4,1
 2f6:	fff5c683          	lbu	a3,-1(a1)
 2fa:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 2fe:	fee79ae3          	bne	a5,a4,2f2 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
        dst += n;
 308:	00c50733          	add	a4,a0,a2
        src += n;
 30c:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 30e:	fec05ae3          	blez	a2,302 <memmove+0x28>
 312:	fff6079b          	addiw	a5,a2,-1
 316:	1782                	slli	a5,a5,0x20
 318:	9381                	srli	a5,a5,0x20
 31a:	fff7c793          	not	a5,a5
 31e:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 320:	15fd                	addi	a1,a1,-1
 322:	177d                	addi	a4,a4,-1
 324:	0005c683          	lbu	a3,0(a1)
 328:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 32c:	fee79ae3          	bne	a5,a4,320 <memmove+0x46>
 330:	bfc9                	j	302 <memmove+0x28>

0000000000000332 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 338:	ca05                	beqz	a2,368 <memcmp+0x36>
 33a:	fff6069b          	addiw	a3,a2,-1
 33e:	1682                	slli	a3,a3,0x20
 340:	9281                	srli	a3,a3,0x20
 342:	0685                	addi	a3,a3,1
 344:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 346:	00054783          	lbu	a5,0(a0)
 34a:	0005c703          	lbu	a4,0(a1)
 34e:	00e79863          	bne	a5,a4,35e <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 352:	0505                	addi	a0,a0,1
        p2++;
 354:	0585                	addi	a1,a1,1
    while (n-- > 0)
 356:	fed518e3          	bne	a0,a3,346 <memcmp+0x14>
    }
    return 0;
 35a:	4501                	li	a0,0
 35c:	a019                	j	362 <memcmp+0x30>
            return *p1 - *p2;
 35e:	40e7853b          	subw	a0,a5,a4
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
    return 0;
 368:	4501                	li	a0,0
 36a:	bfe5                	j	362 <memcmp+0x30>

000000000000036c <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 374:	00000097          	auipc	ra,0x0
 378:	f66080e7          	jalr	-154(ra) # 2da <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 384:	4885                	li	a7,1
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exit>:
.global exit
exit:
 li a7, SYS_exit
 38c:	4889                	li	a7,2
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <wait>:
.global wait
wait:
 li a7, SYS_wait
 394:	488d                	li	a7,3
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39c:	4891                	li	a7,4
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <read>:
.global read
read:
 li a7, SYS_read
 3a4:	4895                	li	a7,5
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <write>:
.global write
write:
 li a7, SYS_write
 3ac:	48c1                	li	a7,16
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <close>:
.global close
close:
 li a7, SYS_close
 3b4:	48d5                	li	a7,21
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3bc:	4899                	li	a7,6
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c4:	489d                	li	a7,7
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <open>:
.global open
open:
 li a7, SYS_open
 3cc:	48bd                	li	a7,15
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d4:	48c5                	li	a7,17
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3dc:	48c9                	li	a7,18
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e4:	48a1                	li	a7,8
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <link>:
.global link
link:
 li a7, SYS_link
 3ec:	48cd                	li	a7,19
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f4:	48d1                	li	a7,20
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fc:	48a5                	li	a7,9
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <dup>:
.global dup
dup:
 li a7, SYS_dup
 404:	48a9                	li	a7,10
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40c:	48ad                	li	a7,11
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 414:	48b1                	li	a7,12
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41c:	48b5                	li	a7,13
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 424:	48b9                	li	a7,14
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 42c:	48d9                	li	a7,22
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 434:	48dd                	li	a7,23
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 43c:	48e1                	li	a7,24
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 444:	48e5                	li	a7,25
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 44c:	48e9                	li	a7,26
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 454:	48ed                	li	a7,27
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 45c:	48f5                	li	a7,29
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 464:	48f1                	li	a7,28
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	1000                	addi	s0,sp,32
 474:	feb407a3          	sb	a1,-17(s0)
 478:	4605                	li	a2,1
 47a:	fef40593          	addi	a1,s0,-17
 47e:	00000097          	auipc	ra,0x0
 482:	f2e080e7          	jalr	-210(ra) # 3ac <write>
 486:	60e2                	ld	ra,24(sp)
 488:	6442                	ld	s0,16(sp)
 48a:	6105                	addi	sp,sp,32
 48c:	8082                	ret

000000000000048e <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 48e:	7139                	addi	sp,sp,-64
 490:	fc06                	sd	ra,56(sp)
 492:	f822                	sd	s0,48(sp)
 494:	f426                	sd	s1,40(sp)
 496:	f04a                	sd	s2,32(sp)
 498:	ec4e                	sd	s3,24(sp)
 49a:	0080                	addi	s0,sp,64
 49c:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 49e:	c299                	beqz	a3,4a4 <printint+0x16>
 4a0:	0805c863          	bltz	a1,530 <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 4a4:	2581                	sext.w	a1,a1
    neg = 0;
 4a6:	4881                	li	a7,0
 4a8:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 4ac:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 4ae:	2601                	sext.w	a2,a2
 4b0:	00000517          	auipc	a0,0x0
 4b4:	48850513          	addi	a0,a0,1160 # 938 <digits>
 4b8:	883a                	mv	a6,a4
 4ba:	2705                	addiw	a4,a4,1
 4bc:	02c5f7bb          	remuw	a5,a1,a2
 4c0:	1782                	slli	a5,a5,0x20
 4c2:	9381                	srli	a5,a5,0x20
 4c4:	97aa                	add	a5,a5,a0
 4c6:	0007c783          	lbu	a5,0(a5)
 4ca:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 4ce:	0005879b          	sext.w	a5,a1
 4d2:	02c5d5bb          	divuw	a1,a1,a2
 4d6:	0685                	addi	a3,a3,1
 4d8:	fec7f0e3          	bgeu	a5,a2,4b8 <printint+0x2a>
    if (neg)
 4dc:	00088b63          	beqz	a7,4f2 <printint+0x64>
        buf[i++] = '-';
 4e0:	fd040793          	addi	a5,s0,-48
 4e4:	973e                	add	a4,a4,a5
 4e6:	02d00793          	li	a5,45
 4ea:	fef70823          	sb	a5,-16(a4)
 4ee:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 4f2:	02e05863          	blez	a4,522 <printint+0x94>
 4f6:	fc040793          	addi	a5,s0,-64
 4fa:	00e78933          	add	s2,a5,a4
 4fe:	fff78993          	addi	s3,a5,-1
 502:	99ba                	add	s3,s3,a4
 504:	377d                	addiw	a4,a4,-1
 506:	1702                	slli	a4,a4,0x20
 508:	9301                	srli	a4,a4,0x20
 50a:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 50e:	fff94583          	lbu	a1,-1(s2)
 512:	8526                	mv	a0,s1
 514:	00000097          	auipc	ra,0x0
 518:	f58080e7          	jalr	-168(ra) # 46c <putc>
    while (--i >= 0)
 51c:	197d                	addi	s2,s2,-1
 51e:	ff3918e3          	bne	s2,s3,50e <printint+0x80>
}
 522:	70e2                	ld	ra,56(sp)
 524:	7442                	ld	s0,48(sp)
 526:	74a2                	ld	s1,40(sp)
 528:	7902                	ld	s2,32(sp)
 52a:	69e2                	ld	s3,24(sp)
 52c:	6121                	addi	sp,sp,64
 52e:	8082                	ret
        x = -xx;
 530:	40b005bb          	negw	a1,a1
        neg = 1;
 534:	4885                	li	a7,1
        x = -xx;
 536:	bf8d                	j	4a8 <printint+0x1a>

0000000000000538 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 538:	7119                	addi	sp,sp,-128
 53a:	fc86                	sd	ra,120(sp)
 53c:	f8a2                	sd	s0,112(sp)
 53e:	f4a6                	sd	s1,104(sp)
 540:	f0ca                	sd	s2,96(sp)
 542:	ecce                	sd	s3,88(sp)
 544:	e8d2                	sd	s4,80(sp)
 546:	e4d6                	sd	s5,72(sp)
 548:	e0da                	sd	s6,64(sp)
 54a:	fc5e                	sd	s7,56(sp)
 54c:	f862                	sd	s8,48(sp)
 54e:	f466                	sd	s9,40(sp)
 550:	f06a                	sd	s10,32(sp)
 552:	ec6e                	sd	s11,24(sp)
 554:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 556:	0005c903          	lbu	s2,0(a1)
 55a:	18090f63          	beqz	s2,6f8 <vprintf+0x1c0>
 55e:	8aaa                	mv	s5,a0
 560:	8b32                	mv	s6,a2
 562:	00158493          	addi	s1,a1,1
    state = 0;
 566:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 568:	02500a13          	li	s4,37
        {
            if (c == 'd')
 56c:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 570:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 574:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 578:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57c:	00000b97          	auipc	s7,0x0
 580:	3bcb8b93          	addi	s7,s7,956 # 938 <digits>
 584:	a839                	j	5a2 <vprintf+0x6a>
                putc(fd, c);
 586:	85ca                	mv	a1,s2
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	ee2080e7          	jalr	-286(ra) # 46c <putc>
 592:	a019                	j	598 <vprintf+0x60>
        else if (state == '%')
 594:	01498f63          	beq	s3,s4,5b2 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 598:	0485                	addi	s1,s1,1
 59a:	fff4c903          	lbu	s2,-1(s1)
 59e:	14090d63          	beqz	s2,6f8 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 5a2:	0009079b          	sext.w	a5,s2
        if (state == 0)
 5a6:	fe0997e3          	bnez	s3,594 <vprintf+0x5c>
            if (c == '%')
 5aa:	fd479ee3          	bne	a5,s4,586 <vprintf+0x4e>
                state = '%';
 5ae:	89be                	mv	s3,a5
 5b0:	b7e5                	j	598 <vprintf+0x60>
            if (c == 'd')
 5b2:	05878063          	beq	a5,s8,5f2 <vprintf+0xba>
            else if (c == 'l')
 5b6:	05978c63          	beq	a5,s9,60e <vprintf+0xd6>
            else if (c == 'x')
 5ba:	07a78863          	beq	a5,s10,62a <vprintf+0xf2>
            else if (c == 'p')
 5be:	09b78463          	beq	a5,s11,646 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 5c2:	07300713          	li	a4,115
 5c6:	0ce78663          	beq	a5,a4,692 <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 5ca:	06300713          	li	a4,99
 5ce:	0ee78e63          	beq	a5,a4,6ca <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 5d2:	11478863          	beq	a5,s4,6e2 <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 5d6:	85d2                	mv	a1,s4
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e92080e7          	jalr	-366(ra) # 46c <putc>
                putc(fd, c);
 5e2:	85ca                	mv	a1,s2
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e86080e7          	jalr	-378(ra) # 46c <putc>
            }
            state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b765                	j	598 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 5f2:	008b0913          	addi	s2,s6,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000b2583          	lw	a1,0(s6)
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	e8e080e7          	jalr	-370(ra) # 48e <printint>
 608:	8b4a                	mv	s6,s2
            state = 0;
 60a:	4981                	li	s3,0
 60c:	b771                	j	598 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	008b0913          	addi	s2,s6,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000b2583          	lw	a1,0(s6)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e72080e7          	jalr	-398(ra) # 48e <printint>
 624:	8b4a                	mv	s6,s2
            state = 0;
 626:	4981                	li	s3,0
 628:	bf85                	j	598 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 62a:	008b0913          	addi	s2,s6,8
 62e:	4681                	li	a3,0
 630:	4641                	li	a2,16
 632:	000b2583          	lw	a1,0(s6)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e56080e7          	jalr	-426(ra) # 48e <printint>
 640:	8b4a                	mv	s6,s2
            state = 0;
 642:	4981                	li	s3,0
 644:	bf91                	j	598 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 646:	008b0793          	addi	a5,s6,8
 64a:	f8f43423          	sd	a5,-120(s0)
 64e:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 652:	03000593          	li	a1,48
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e14080e7          	jalr	-492(ra) # 46c <putc>
    putc(fd, 'x');
 660:	85ea                	mv	a1,s10
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	e08080e7          	jalr	-504(ra) # 46c <putc>
 66c:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66e:	03c9d793          	srli	a5,s3,0x3c
 672:	97de                	add	a5,a5,s7
 674:	0007c583          	lbu	a1,0(a5)
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	df2080e7          	jalr	-526(ra) # 46c <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 682:	0992                	slli	s3,s3,0x4
 684:	397d                	addiw	s2,s2,-1
 686:	fe0914e3          	bnez	s2,66e <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 68a:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 68e:	4981                	li	s3,0
 690:	b721                	j	598 <vprintf+0x60>
                s = va_arg(ap, char *);
 692:	008b0993          	addi	s3,s6,8
 696:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 69a:	02090163          	beqz	s2,6bc <vprintf+0x184>
                while (*s != 0)
 69e:	00094583          	lbu	a1,0(s2)
 6a2:	c9a1                	beqz	a1,6f2 <vprintf+0x1ba>
                    putc(fd, *s);
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	dc6080e7          	jalr	-570(ra) # 46c <putc>
                    s++;
 6ae:	0905                	addi	s2,s2,1
                while (*s != 0)
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	f9e5                	bnez	a1,6a4 <vprintf+0x16c>
                s = va_arg(ap, char *);
 6b6:	8b4e                	mv	s6,s3
            state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bdf9                	j	598 <vprintf+0x60>
                    s = "(null)";
 6bc:	00000917          	auipc	s2,0x0
 6c0:	27490913          	addi	s2,s2,628 # 930 <malloc+0x12e>
                while (*s != 0)
 6c4:	02800593          	li	a1,40
 6c8:	bff1                	j	6a4 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 6ca:	008b0913          	addi	s2,s6,8
 6ce:	000b4583          	lbu	a1,0(s6)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	d98080e7          	jalr	-616(ra) # 46c <putc>
 6dc:	8b4a                	mv	s6,s2
            state = 0;
 6de:	4981                	li	s3,0
 6e0:	bd65                	j	598 <vprintf+0x60>
                putc(fd, c);
 6e2:	85d2                	mv	a1,s4
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	d86080e7          	jalr	-634(ra) # 46c <putc>
            state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b565                	j	598 <vprintf+0x60>
                s = va_arg(ap, char *);
 6f2:	8b4e                	mv	s6,s3
            state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b54d                	j	598 <vprintf+0x60>
        }
    }
}
 6f8:	70e6                	ld	ra,120(sp)
 6fa:	7446                	ld	s0,112(sp)
 6fc:	74a6                	ld	s1,104(sp)
 6fe:	7906                	ld	s2,96(sp)
 700:	69e6                	ld	s3,88(sp)
 702:	6a46                	ld	s4,80(sp)
 704:	6aa6                	ld	s5,72(sp)
 706:	6b06                	ld	s6,64(sp)
 708:	7be2                	ld	s7,56(sp)
 70a:	7c42                	ld	s8,48(sp)
 70c:	7ca2                	ld	s9,40(sp)
 70e:	7d02                	ld	s10,32(sp)
 710:	6de2                	ld	s11,24(sp)
 712:	6109                	addi	sp,sp,128
 714:	8082                	ret

0000000000000716 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 716:	715d                	addi	sp,sp,-80
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e010                	sd	a2,0(s0)
 720:	e414                	sd	a3,8(s0)
 722:	e818                	sd	a4,16(s0)
 724:	ec1c                	sd	a5,24(s0)
 726:	03043023          	sd	a6,32(s0)
 72a:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 72e:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 732:	8622                	mv	a2,s0
 734:	00000097          	auipc	ra,0x0
 738:	e04080e7          	jalr	-508(ra) # 538 <vprintf>
}
 73c:	60e2                	ld	ra,24(sp)
 73e:	6442                	ld	s0,16(sp)
 740:	6161                	addi	sp,sp,80
 742:	8082                	ret

0000000000000744 <printf>:

void printf(const char *fmt, ...)
{
 744:	711d                	addi	sp,sp,-96
 746:	ec06                	sd	ra,24(sp)
 748:	e822                	sd	s0,16(sp)
 74a:	1000                	addi	s0,sp,32
 74c:	e40c                	sd	a1,8(s0)
 74e:	e810                	sd	a2,16(s0)
 750:	ec14                	sd	a3,24(s0)
 752:	f018                	sd	a4,32(s0)
 754:	f41c                	sd	a5,40(s0)
 756:	03043823          	sd	a6,48(s0)
 75a:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 75e:	00840613          	addi	a2,s0,8
 762:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 766:	85aa                	mv	a1,a0
 768:	4505                	li	a0,1
 76a:	00000097          	auipc	ra,0x0
 76e:	dce080e7          	jalr	-562(ra) # 538 <vprintf>
}
 772:	60e2                	ld	ra,24(sp)
 774:	6442                	ld	s0,16(sp)
 776:	6125                	addi	sp,sp,96
 778:	8082                	ret

000000000000077a <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 77a:	1141                	addi	sp,sp,-16
 77c:	e422                	sd	s0,8(sp)
 77e:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 780:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	00000797          	auipc	a5,0x0
 788:	1cc7b783          	ld	a5,460(a5) # 950 <freep>
 78c:	a805                	j	7bc <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 78e:	4618                	lw	a4,8(a2)
 790:	9db9                	addw	a1,a1,a4
 792:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 796:	6398                	ld	a4,0(a5)
 798:	6318                	ld	a4,0(a4)
 79a:	fee53823          	sd	a4,-16(a0)
 79e:	a091                	j	7e2 <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 7a0:	ff852703          	lw	a4,-8(a0)
 7a4:	9e39                	addw	a2,a2,a4
 7a6:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 7a8:	ff053703          	ld	a4,-16(a0)
 7ac:	e398                	sd	a4,0(a5)
 7ae:	a099                	j	7f4 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	6398                	ld	a4,0(a5)
 7b2:	00e7e463          	bltu	a5,a4,7ba <free+0x40>
 7b6:	00e6ea63          	bltu	a3,a4,7ca <free+0x50>
{
 7ba:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	fed7fae3          	bgeu	a5,a3,7b0 <free+0x36>
 7c0:	6398                	ld	a4,0(a5)
 7c2:	00e6e463          	bltu	a3,a4,7ca <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	fee7eae3          	bltu	a5,a4,7ba <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 7ca:	ff852583          	lw	a1,-8(a0)
 7ce:	6390                	ld	a2,0(a5)
 7d0:	02059713          	slli	a4,a1,0x20
 7d4:	9301                	srli	a4,a4,0x20
 7d6:	0712                	slli	a4,a4,0x4
 7d8:	9736                	add	a4,a4,a3
 7da:	fae60ae3          	beq	a2,a4,78e <free+0x14>
        bp->s.ptr = p->s.ptr;
 7de:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 7e2:	4790                	lw	a2,8(a5)
 7e4:	02061713          	slli	a4,a2,0x20
 7e8:	9301                	srli	a4,a4,0x20
 7ea:	0712                	slli	a4,a4,0x4
 7ec:	973e                	add	a4,a4,a5
 7ee:	fae689e3          	beq	a3,a4,7a0 <free+0x26>
    }
    else
        p->s.ptr = bp;
 7f2:	e394                	sd	a3,0(a5)
    freep = p;
 7f4:	00000717          	auipc	a4,0x0
 7f8:	14f73e23          	sd	a5,348(a4) # 950 <freep>
}
 7fc:	6422                	ld	s0,8(sp)
 7fe:	0141                	addi	sp,sp,16
 800:	8082                	ret

0000000000000802 <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 802:	7139                	addi	sp,sp,-64
 804:	fc06                	sd	ra,56(sp)
 806:	f822                	sd	s0,48(sp)
 808:	f426                	sd	s1,40(sp)
 80a:	f04a                	sd	s2,32(sp)
 80c:	ec4e                	sd	s3,24(sp)
 80e:	e852                	sd	s4,16(sp)
 810:	e456                	sd	s5,8(sp)
 812:	e05a                	sd	s6,0(sp)
 814:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 816:	02051493          	slli	s1,a0,0x20
 81a:	9081                	srli	s1,s1,0x20
 81c:	04bd                	addi	s1,s1,15
 81e:	8091                	srli	s1,s1,0x4
 820:	0014899b          	addiw	s3,s1,1
 824:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 826:	00000517          	auipc	a0,0x0
 82a:	12a53503          	ld	a0,298(a0) # 950 <freep>
 82e:	c515                	beqz	a0,85a <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 830:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 832:	4798                	lw	a4,8(a5)
 834:	02977f63          	bgeu	a4,s1,872 <malloc+0x70>
 838:	8a4e                	mv	s4,s3
 83a:	0009871b          	sext.w	a4,s3
 83e:	6685                	lui	a3,0x1
 840:	00d77363          	bgeu	a4,a3,846 <malloc+0x44>
 844:	6a05                	lui	s4,0x1
 846:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 84a:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 84e:	00000917          	auipc	s2,0x0
 852:	10290913          	addi	s2,s2,258 # 950 <freep>
    if (p == (char *)-1)
 856:	5afd                	li	s5,-1
 858:	a88d                	j	8ca <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 85a:	00000797          	auipc	a5,0x0
 85e:	2fe78793          	addi	a5,a5,766 # b58 <base>
 862:	00000717          	auipc	a4,0x0
 866:	0ef73723          	sd	a5,238(a4) # 950 <freep>
 86a:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 86c:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 870:	b7e1                	j	838 <malloc+0x36>
            if (p->s.size == nunits)
 872:	02e48b63          	beq	s1,a4,8a8 <malloc+0xa6>
                p->s.size -= nunits;
 876:	4137073b          	subw	a4,a4,s3
 87a:	c798                	sw	a4,8(a5)
                p += p->s.size;
 87c:	1702                	slli	a4,a4,0x20
 87e:	9301                	srli	a4,a4,0x20
 880:	0712                	slli	a4,a4,0x4
 882:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 884:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 888:	00000717          	auipc	a4,0x0
 88c:	0ca73423          	sd	a0,200(a4) # 950 <freep>
            return (void *)(p + 1);
 890:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 894:	70e2                	ld	ra,56(sp)
 896:	7442                	ld	s0,48(sp)
 898:	74a2                	ld	s1,40(sp)
 89a:	7902                	ld	s2,32(sp)
 89c:	69e2                	ld	s3,24(sp)
 89e:	6a42                	ld	s4,16(sp)
 8a0:	6aa2                	ld	s5,8(sp)
 8a2:	6b02                	ld	s6,0(sp)
 8a4:	6121                	addi	sp,sp,64
 8a6:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 8a8:	6398                	ld	a4,0(a5)
 8aa:	e118                	sd	a4,0(a0)
 8ac:	bff1                	j	888 <malloc+0x86>
    hp->s.size = nu;
 8ae:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 8b2:	0541                	addi	a0,a0,16
 8b4:	00000097          	auipc	ra,0x0
 8b8:	ec6080e7          	jalr	-314(ra) # 77a <free>
    return freep;
 8bc:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 8c0:	d971                	beqz	a0,894 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 8c2:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 8c4:	4798                	lw	a4,8(a5)
 8c6:	fa9776e3          	bgeu	a4,s1,872 <malloc+0x70>
        if (p == freep)
 8ca:	00093703          	ld	a4,0(s2)
 8ce:	853e                	mv	a0,a5
 8d0:	fef719e3          	bne	a4,a5,8c2 <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 8d4:	8552                	mv	a0,s4
 8d6:	00000097          	auipc	ra,0x0
 8da:	b3e080e7          	jalr	-1218(ra) # 414 <sbrk>
    if (p == (char *)-1)
 8de:	fd5518e3          	bne	a0,s5,8ae <malloc+0xac>
                return 0;
 8e2:	4501                	li	a0,0
 8e4:	bf45                	j	894 <malloc+0x92>
