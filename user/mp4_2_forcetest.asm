
user/_mp4_2_forcetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
    int pbn_to_fail;
    int ret;

    if (argc != 2)
   c:	4789                	li	a5,2
   e:	08f51763          	bne	a0,a5,9c <main+0x9c>
    {
        fprintf(2, "Usage: mp4_2_forcetest <pbn_or_-1>\n");
        exit(1);
    }

    if (argv[1][0] == '-' && argv[1][1] == '1')
  12:	6588                	ld	a0,8(a1)
  14:	00054703          	lbu	a4,0(a0)
  18:	02d00793          	li	a5,45
  1c:	00f71863          	bne	a4,a5,2c <main+0x2c>
  20:	00154703          	lbu	a4,1(a0)
  24:	03100793          	li	a5,49
  28:	08f70863          	beq	a4,a5,b8 <main+0xb8>
        pbn_to_fail = -1;
    else
        pbn_to_fail = atoi(argv[1]);
  2c:	00000097          	auipc	ra,0x0
  30:	232080e7          	jalr	562(ra) # 25e <atoi>
  34:	84aa                	mv	s1,a0

    printf("Calling force_fail(%d)...\n", pbn_to_fail);
  36:	85a6                	mv	a1,s1
  38:	00001517          	auipc	a0,0x1
  3c:	8a850513          	addi	a0,a0,-1880 # 8e0 <malloc+0x110>
  40:	00000097          	auipc	ra,0x0
  44:	6d2080e7          	jalr	1746(ra) # 712 <printf>

    ret = force_fail(pbn_to_fail);
  48:	8526                	mv	a0,s1
  4a:	00000097          	auipc	ra,0x0
  4e:	3b0080e7          	jalr	944(ra) # 3fa <force_fail>

    if (ret == 0)
  52:	ed35                	bnez	a0,ce <main+0xce>
    {
        printf("force_fail(%d) succeeded.\n", pbn_to_fail);
  54:	85a6                	mv	a1,s1
  56:	00001517          	auipc	a0,0x1
  5a:	8aa50513          	addi	a0,a0,-1878 # 900 <malloc+0x130>
  5e:	00000097          	auipc	ra,0x0
  62:	6b4080e7          	jalr	1716(ra) # 712 <printf>

        int current_val = get_force_fail();
  66:	00000097          	auipc	ra,0x0
  6a:	39c080e7          	jalr	924(ra) # 402 <get_force_fail>
  6e:	892a                	mv	s2,a0
        printf("Current force_read_error_pbn = %d\n", current_val);
  70:	85aa                	mv	a1,a0
  72:	00001517          	auipc	a0,0x1
  76:	8ae50513          	addi	a0,a0,-1874 # 920 <malloc+0x150>
  7a:	00000097          	auipc	ra,0x0
  7e:	698080e7          	jalr	1688(ra) # 712 <printf>

        if (current_val == pbn_to_fail)
  82:	03248d63          	beq	s1,s2,bc <main+0xbc>
        {
            printf("Verification PASSED: Kernel variable matches set value.\n");
        }
        else
        {
            printf("Verification FAILED: Kernel variable (%d) does NOT match "
  86:	8626                	mv	a2,s1
  88:	85ca                	mv	a1,s2
  8a:	00001517          	auipc	a0,0x1
  8e:	8fe50513          	addi	a0,a0,-1794 # 988 <malloc+0x1b8>
  92:	00000097          	auipc	ra,0x0
  96:	680080e7          	jalr	1664(ra) # 712 <printf>
  9a:	a0a1                	j	e2 <main+0xe2>
        fprintf(2, "Usage: mp4_2_forcetest <pbn_or_-1>\n");
  9c:	00001597          	auipc	a1,0x1
  a0:	81c58593          	addi	a1,a1,-2020 # 8b8 <malloc+0xe8>
  a4:	4509                	li	a0,2
  a6:	00000097          	auipc	ra,0x0
  aa:	63e080e7          	jalr	1598(ra) # 6e4 <fprintf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	2aa080e7          	jalr	682(ra) # 35a <exit>
        pbn_to_fail = -1;
  b8:	54fd                	li	s1,-1
  ba:	bfb5                	j	36 <main+0x36>
            printf("Verification PASSED: Kernel variable matches set value.\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	88c50513          	addi	a0,a0,-1908 # 948 <malloc+0x178>
  c4:	00000097          	auipc	ra,0x0
  c8:	64e080e7          	jalr	1614(ra) # 712 <printf>
  cc:	a819                	j	e2 <main+0xe2>
                   current_val, pbn_to_fail);
        }
    }
    else
    {
        printf("force_fail(%d) failed! (returned %d)\n", pbn_to_fail, ret);
  ce:	862a                	mv	a2,a0
  d0:	85a6                	mv	a1,s1
  d2:	00001517          	auipc	a0,0x1
  d6:	90650513          	addi	a0,a0,-1786 # 9d8 <malloc+0x208>
  da:	00000097          	auipc	ra,0x0
  de:	638080e7          	jalr	1592(ra) # 712 <printf>
    }

    exit(0);
  e2:	4501                	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	276080e7          	jalr	630(ra) # 35a <exit>

00000000000000ec <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e422                	sd	s0,8(sp)
  f0:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
  f2:	87aa                	mv	a5,a0
  f4:	0585                	addi	a1,a1,1
  f6:	0785                	addi	a5,a5,1
  f8:	fff5c703          	lbu	a4,-1(a1)
  fc:	fee78fa3          	sb	a4,-1(a5)
 100:	fb75                	bnez	a4,f4 <strcpy+0x8>
        ;
    return os;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strcmp>:

int strcmp(const char *p, const char *q)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cb91                	beqz	a5,126 <strcmp+0x1e>
 114:	0005c703          	lbu	a4,0(a1)
 118:	00f71763          	bne	a4,a5,126 <strcmp+0x1e>
        p++, q++;
 11c:	0505                	addi	a0,a0,1
 11e:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	fbe5                	bnez	a5,114 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 126:	0005c503          	lbu	a0,0(a1)
}
 12a:	40a7853b          	subw	a0,a5,a0
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strlen>:

uint strlen(const char *s)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf91                	beqz	a5,15a <strlen+0x26>
 140:	0505                	addi	a0,a0,1
 142:	87aa                	mv	a5,a0
 144:	4685                	li	a3,1
 146:	9e89                	subw	a3,a3,a0
 148:	00f6853b          	addw	a0,a3,a5
 14c:	0785                	addi	a5,a5,1
 14e:	fff7c703          	lbu	a4,-1(a5)
 152:	fb7d                	bnez	a4,148 <strlen+0x14>
        ;
    return n;
}
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret
    for (n = 0; s[n]; n++)
 15a:	4501                	li	a0,0
 15c:	bfe5                	j	154 <strlen+0x20>

000000000000015e <memset>:

void *memset(void *dst, int c, uint n)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 164:	ca19                	beqz	a2,17a <memset+0x1c>
 166:	87aa                	mv	a5,a0
 168:	1602                	slli	a2,a2,0x20
 16a:	9201                	srli	a2,a2,0x20
 16c:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 170:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 174:	0785                	addi	a5,a5,1
 176:	fee79de3          	bne	a5,a4,170 <memset+0x12>
    }
    return dst;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strchr>:

char *strchr(const char *s, char c)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
    for (; *s; s++)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cb99                	beqz	a5,1a0 <strchr+0x20>
        if (*s == c)
 18c:	00f58763          	beq	a1,a5,19a <strchr+0x1a>
    for (; *s; s++)
 190:	0505                	addi	a0,a0,1
 192:	00054783          	lbu	a5,0(a0)
 196:	fbfd                	bnez	a5,18c <strchr+0xc>
            return (char *)s;
    return 0;
 198:	4501                	li	a0,0
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
    return 0;
 1a0:	4501                	li	a0,0
 1a2:	bfe5                	j	19a <strchr+0x1a>

00000000000001a4 <gets>:

char *gets(char *buf, int max)
{
 1a4:	711d                	addi	sp,sp,-96
 1a6:	ec86                	sd	ra,88(sp)
 1a8:	e8a2                	sd	s0,80(sp)
 1aa:	e4a6                	sd	s1,72(sp)
 1ac:	e0ca                	sd	s2,64(sp)
 1ae:	fc4e                	sd	s3,56(sp)
 1b0:	f852                	sd	s4,48(sp)
 1b2:	f456                	sd	s5,40(sp)
 1b4:	f05a                	sd	s6,32(sp)
 1b6:	ec5e                	sd	s7,24(sp)
 1b8:	1080                	addi	s0,sp,96
 1ba:	8baa                	mv	s7,a0
 1bc:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 1c2:	4aa9                	li	s5,10
 1c4:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 1c6:	89a6                	mv	s3,s1
 1c8:	2485                	addiw	s1,s1,1
 1ca:	0344d863          	bge	s1,s4,1fa <gets+0x56>
        cc = read(0, &c, 1);
 1ce:	4605                	li	a2,1
 1d0:	faf40593          	addi	a1,s0,-81
 1d4:	4501                	li	a0,0
 1d6:	00000097          	auipc	ra,0x0
 1da:	19c080e7          	jalr	412(ra) # 372 <read>
        if (cc < 1)
 1de:	00a05e63          	blez	a0,1fa <gets+0x56>
        buf[i++] = c;
 1e2:	faf44783          	lbu	a5,-81(s0)
 1e6:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 1ea:	01578763          	beq	a5,s5,1f8 <gets+0x54>
 1ee:	0905                	addi	s2,s2,1
 1f0:	fd679be3          	bne	a5,s6,1c6 <gets+0x22>
    for (i = 0; i + 1 < max;)
 1f4:	89a6                	mv	s3,s1
 1f6:	a011                	j	1fa <gets+0x56>
 1f8:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 1fa:	99de                	add	s3,s3,s7
 1fc:	00098023          	sb	zero,0(s3)
    return buf;
}
 200:	855e                	mv	a0,s7
 202:	60e6                	ld	ra,88(sp)
 204:	6446                	ld	s0,80(sp)
 206:	64a6                	ld	s1,72(sp)
 208:	6906                	ld	s2,64(sp)
 20a:	79e2                	ld	s3,56(sp)
 20c:	7a42                	ld	s4,48(sp)
 20e:	7aa2                	ld	s5,40(sp)
 210:	7b02                	ld	s6,32(sp)
 212:	6be2                	ld	s7,24(sp)
 214:	6125                	addi	sp,sp,96
 216:	8082                	ret

0000000000000218 <stat>:

int stat(const char *n, struct stat *st)
{
 218:	1101                	addi	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e426                	sd	s1,8(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
 224:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 226:	4581                	li	a1,0
 228:	00000097          	auipc	ra,0x0
 22c:	172080e7          	jalr	370(ra) # 39a <open>
    if (fd < 0)
 230:	02054563          	bltz	a0,25a <stat+0x42>
 234:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 236:	85ca                	mv	a1,s2
 238:	00000097          	auipc	ra,0x0
 23c:	17a080e7          	jalr	378(ra) # 3b2 <fstat>
 240:	892a                	mv	s2,a0
    close(fd);
 242:	8526                	mv	a0,s1
 244:	00000097          	auipc	ra,0x0
 248:	13e080e7          	jalr	318(ra) # 382 <close>
    return r;
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	64a2                	ld	s1,8(sp)
 254:	6902                	ld	s2,0(sp)
 256:	6105                	addi	sp,sp,32
 258:	8082                	ret
        return -1;
 25a:	597d                	li	s2,-1
 25c:	bfc5                	j	24c <stat+0x34>

000000000000025e <atoi>:

int atoi(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 264:	00054603          	lbu	a2,0(a0)
 268:	fd06079b          	addiw	a5,a2,-48
 26c:	0ff7f793          	andi	a5,a5,255
 270:	4725                	li	a4,9
 272:	02f76963          	bltu	a4,a5,2a4 <atoi+0x46>
 276:	86aa                	mv	a3,a0
    n = 0;
 278:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 27a:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 27c:	0685                	addi	a3,a3,1
 27e:	0025179b          	slliw	a5,a0,0x2
 282:	9fa9                	addw	a5,a5,a0
 284:	0017979b          	slliw	a5,a5,0x1
 288:	9fb1                	addw	a5,a5,a2
 28a:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 28e:	0006c603          	lbu	a2,0(a3)
 292:	fd06071b          	addiw	a4,a2,-48
 296:	0ff77713          	andi	a4,a4,255
 29a:	fee5f1e3          	bgeu	a1,a4,27c <atoi+0x1e>
    return n;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
    n = 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <atoi+0x40>

00000000000002a8 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 2ae:	02b57463          	bgeu	a0,a1,2d6 <memmove+0x2e>
    {
        while (n-- > 0)
 2b2:	00c05f63          	blez	a2,2d0 <memmove+0x28>
 2b6:	1602                	slli	a2,a2,0x20
 2b8:	9201                	srli	a2,a2,0x20
 2ba:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 2be:	872a                	mv	a4,a0
            *dst++ = *src++;
 2c0:	0585                	addi	a1,a1,1
 2c2:	0705                	addi	a4,a4,1
 2c4:	fff5c683          	lbu	a3,-1(a1)
 2c8:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 2cc:	fee79ae3          	bne	a5,a4,2c0 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
        dst += n;
 2d6:	00c50733          	add	a4,a0,a2
        src += n;
 2da:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 2dc:	fec05ae3          	blez	a2,2d0 <memmove+0x28>
 2e0:	fff6079b          	addiw	a5,a2,-1
 2e4:	1782                	slli	a5,a5,0x20
 2e6:	9381                	srli	a5,a5,0x20
 2e8:	fff7c793          	not	a5,a5
 2ec:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 2ee:	15fd                	addi	a1,a1,-1
 2f0:	177d                	addi	a4,a4,-1
 2f2:	0005c683          	lbu	a3,0(a1)
 2f6:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 2fa:	fee79ae3          	bne	a5,a4,2ee <memmove+0x46>
 2fe:	bfc9                	j	2d0 <memmove+0x28>

0000000000000300 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 306:	ca05                	beqz	a2,336 <memcmp+0x36>
 308:	fff6069b          	addiw	a3,a2,-1
 30c:	1682                	slli	a3,a3,0x20
 30e:	9281                	srli	a3,a3,0x20
 310:	0685                	addi	a3,a3,1
 312:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 314:	00054783          	lbu	a5,0(a0)
 318:	0005c703          	lbu	a4,0(a1)
 31c:	00e79863          	bne	a5,a4,32c <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 320:	0505                	addi	a0,a0,1
        p2++;
 322:	0585                	addi	a1,a1,1
    while (n-- > 0)
 324:	fed518e3          	bne	a0,a3,314 <memcmp+0x14>
    }
    return 0;
 328:	4501                	li	a0,0
 32a:	a019                	j	330 <memcmp+0x30>
            return *p1 - *p2;
 32c:	40e7853b          	subw	a0,a5,a4
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
    return 0;
 336:	4501                	li	a0,0
 338:	bfe5                	j	330 <memcmp+0x30>

000000000000033a <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 342:	00000097          	auipc	ra,0x0
 346:	f66080e7          	jalr	-154(ra) # 2a8 <memmove>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 352:	4885                	li	a7,1
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exit>:
.global exit
exit:
 li a7, SYS_exit
 35a:	4889                	li	a7,2
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <wait>:
.global wait
wait:
 li a7, SYS_wait
 362:	488d                	li	a7,3
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36a:	4891                	li	a7,4
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <read>:
.global read
read:
 li a7, SYS_read
 372:	4895                	li	a7,5
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <write>:
.global write
write:
 li a7, SYS_write
 37a:	48c1                	li	a7,16
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <close>:
.global close
close:
 li a7, SYS_close
 382:	48d5                	li	a7,21
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <kill>:
.global kill
kill:
 li a7, SYS_kill
 38a:	4899                	li	a7,6
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exec>:
.global exec
exec:
 li a7, SYS_exec
 392:	489d                	li	a7,7
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <open>:
.global open
open:
 li a7, SYS_open
 39a:	48bd                	li	a7,15
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a2:	48c5                	li	a7,17
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3aa:	48c9                	li	a7,18
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b2:	48a1                	li	a7,8
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <link>:
.global link
link:
 li a7, SYS_link
 3ba:	48cd                	li	a7,19
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c2:	48d1                	li	a7,20
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ca:	48a5                	li	a7,9
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d2:	48a9                	li	a7,10
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3da:	48ad                	li	a7,11
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e2:	48b1                	li	a7,12
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ea:	48b5                	li	a7,13
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f2:	48b9                	li	a7,14
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 3fa:	48d9                	li	a7,22
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 402:	48dd                	li	a7,23
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 40a:	48e1                	li	a7,24
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 412:	48e5                	li	a7,25
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 41a:	48e9                	li	a7,26
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 422:	48ed                	li	a7,27
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 42a:	48f5                	li	a7,29
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 432:	48f1                	li	a7,28
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	1000                	addi	s0,sp,32
 442:	feb407a3          	sb	a1,-17(s0)
 446:	4605                	li	a2,1
 448:	fef40593          	addi	a1,s0,-17
 44c:	00000097          	auipc	ra,0x0
 450:	f2e080e7          	jalr	-210(ra) # 37a <write>
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret

000000000000045c <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 45c:	7139                	addi	sp,sp,-64
 45e:	fc06                	sd	ra,56(sp)
 460:	f822                	sd	s0,48(sp)
 462:	f426                	sd	s1,40(sp)
 464:	f04a                	sd	s2,32(sp)
 466:	ec4e                	sd	s3,24(sp)
 468:	0080                	addi	s0,sp,64
 46a:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 46c:	c299                	beqz	a3,472 <printint+0x16>
 46e:	0805c863          	bltz	a1,4fe <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 472:	2581                	sext.w	a1,a1
    neg = 0;
 474:	4881                	li	a7,0
 476:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 47a:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 47c:	2601                	sext.w	a2,a2
 47e:	00000517          	auipc	a0,0x0
 482:	58a50513          	addi	a0,a0,1418 # a08 <digits>
 486:	883a                	mv	a6,a4
 488:	2705                	addiw	a4,a4,1
 48a:	02c5f7bb          	remuw	a5,a1,a2
 48e:	1782                	slli	a5,a5,0x20
 490:	9381                	srli	a5,a5,0x20
 492:	97aa                	add	a5,a5,a0
 494:	0007c783          	lbu	a5,0(a5)
 498:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 49c:	0005879b          	sext.w	a5,a1
 4a0:	02c5d5bb          	divuw	a1,a1,a2
 4a4:	0685                	addi	a3,a3,1
 4a6:	fec7f0e3          	bgeu	a5,a2,486 <printint+0x2a>
    if (neg)
 4aa:	00088b63          	beqz	a7,4c0 <printint+0x64>
        buf[i++] = '-';
 4ae:	fd040793          	addi	a5,s0,-48
 4b2:	973e                	add	a4,a4,a5
 4b4:	02d00793          	li	a5,45
 4b8:	fef70823          	sb	a5,-16(a4)
 4bc:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 4c0:	02e05863          	blez	a4,4f0 <printint+0x94>
 4c4:	fc040793          	addi	a5,s0,-64
 4c8:	00e78933          	add	s2,a5,a4
 4cc:	fff78993          	addi	s3,a5,-1
 4d0:	99ba                	add	s3,s3,a4
 4d2:	377d                	addiw	a4,a4,-1
 4d4:	1702                	slli	a4,a4,0x20
 4d6:	9301                	srli	a4,a4,0x20
 4d8:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 4dc:	fff94583          	lbu	a1,-1(s2)
 4e0:	8526                	mv	a0,s1
 4e2:	00000097          	auipc	ra,0x0
 4e6:	f58080e7          	jalr	-168(ra) # 43a <putc>
    while (--i >= 0)
 4ea:	197d                	addi	s2,s2,-1
 4ec:	ff3918e3          	bne	s2,s3,4dc <printint+0x80>
}
 4f0:	70e2                	ld	ra,56(sp)
 4f2:	7442                	ld	s0,48(sp)
 4f4:	74a2                	ld	s1,40(sp)
 4f6:	7902                	ld	s2,32(sp)
 4f8:	69e2                	ld	s3,24(sp)
 4fa:	6121                	addi	sp,sp,64
 4fc:	8082                	ret
        x = -xx;
 4fe:	40b005bb          	negw	a1,a1
        neg = 1;
 502:	4885                	li	a7,1
        x = -xx;
 504:	bf8d                	j	476 <printint+0x1a>

0000000000000506 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 506:	7119                	addi	sp,sp,-128
 508:	fc86                	sd	ra,120(sp)
 50a:	f8a2                	sd	s0,112(sp)
 50c:	f4a6                	sd	s1,104(sp)
 50e:	f0ca                	sd	s2,96(sp)
 510:	ecce                	sd	s3,88(sp)
 512:	e8d2                	sd	s4,80(sp)
 514:	e4d6                	sd	s5,72(sp)
 516:	e0da                	sd	s6,64(sp)
 518:	fc5e                	sd	s7,56(sp)
 51a:	f862                	sd	s8,48(sp)
 51c:	f466                	sd	s9,40(sp)
 51e:	f06a                	sd	s10,32(sp)
 520:	ec6e                	sd	s11,24(sp)
 522:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 524:	0005c903          	lbu	s2,0(a1)
 528:	18090f63          	beqz	s2,6c6 <vprintf+0x1c0>
 52c:	8aaa                	mv	s5,a0
 52e:	8b32                	mv	s6,a2
 530:	00158493          	addi	s1,a1,1
    state = 0;
 534:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 536:	02500a13          	li	s4,37
        {
            if (c == 'd')
 53a:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 53e:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 542:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 546:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 54a:	00000b97          	auipc	s7,0x0
 54e:	4beb8b93          	addi	s7,s7,1214 # a08 <digits>
 552:	a839                	j	570 <vprintf+0x6a>
                putc(fd, c);
 554:	85ca                	mv	a1,s2
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	ee2080e7          	jalr	-286(ra) # 43a <putc>
 560:	a019                	j	566 <vprintf+0x60>
        else if (state == '%')
 562:	01498f63          	beq	s3,s4,580 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 566:	0485                	addi	s1,s1,1
 568:	fff4c903          	lbu	s2,-1(s1)
 56c:	14090d63          	beqz	s2,6c6 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 570:	0009079b          	sext.w	a5,s2
        if (state == 0)
 574:	fe0997e3          	bnez	s3,562 <vprintf+0x5c>
            if (c == '%')
 578:	fd479ee3          	bne	a5,s4,554 <vprintf+0x4e>
                state = '%';
 57c:	89be                	mv	s3,a5
 57e:	b7e5                	j	566 <vprintf+0x60>
            if (c == 'd')
 580:	05878063          	beq	a5,s8,5c0 <vprintf+0xba>
            else if (c == 'l')
 584:	05978c63          	beq	a5,s9,5dc <vprintf+0xd6>
            else if (c == 'x')
 588:	07a78863          	beq	a5,s10,5f8 <vprintf+0xf2>
            else if (c == 'p')
 58c:	09b78463          	beq	a5,s11,614 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 590:	07300713          	li	a4,115
 594:	0ce78663          	beq	a5,a4,660 <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 598:	06300713          	li	a4,99
 59c:	0ee78e63          	beq	a5,a4,698 <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 5a0:	11478863          	beq	a5,s4,6b0 <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 5a4:	85d2                	mv	a1,s4
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	e92080e7          	jalr	-366(ra) # 43a <putc>
                putc(fd, c);
 5b0:	85ca                	mv	a1,s2
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e86080e7          	jalr	-378(ra) # 43a <putc>
            }
            state = 0;
 5bc:	4981                	li	s3,0
 5be:	b765                	j	566 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 5c0:	008b0913          	addi	s2,s6,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000b2583          	lw	a1,0(s6)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e8e080e7          	jalr	-370(ra) # 45c <printint>
 5d6:	8b4a                	mv	s6,s2
            state = 0;
 5d8:	4981                	li	s3,0
 5da:	b771                	j	566 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b0913          	addi	s2,s6,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000b2583          	lw	a1,0(s6)
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e72080e7          	jalr	-398(ra) # 45c <printint>
 5f2:	8b4a                	mv	s6,s2
            state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bf85                	j	566 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000b2583          	lw	a1,0(s6)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e56080e7          	jalr	-426(ra) # 45c <printint>
 60e:	8b4a                	mv	s6,s2
            state = 0;
 610:	4981                	li	s3,0
 612:	bf91                	j	566 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 614:	008b0793          	addi	a5,s6,8
 618:	f8f43423          	sd	a5,-120(s0)
 61c:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 620:	03000593          	li	a1,48
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e14080e7          	jalr	-492(ra) # 43a <putc>
    putc(fd, 'x');
 62e:	85ea                	mv	a1,s10
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e08080e7          	jalr	-504(ra) # 43a <putc>
 63a:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63c:	03c9d793          	srli	a5,s3,0x3c
 640:	97de                	add	a5,a5,s7
 642:	0007c583          	lbu	a1,0(a5)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	df2080e7          	jalr	-526(ra) # 43a <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 650:	0992                	slli	s3,s3,0x4
 652:	397d                	addiw	s2,s2,-1
 654:	fe0914e3          	bnez	s2,63c <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 658:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 65c:	4981                	li	s3,0
 65e:	b721                	j	566 <vprintf+0x60>
                s = va_arg(ap, char *);
 660:	008b0993          	addi	s3,s6,8
 664:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 668:	02090163          	beqz	s2,68a <vprintf+0x184>
                while (*s != 0)
 66c:	00094583          	lbu	a1,0(s2)
 670:	c9a1                	beqz	a1,6c0 <vprintf+0x1ba>
                    putc(fd, *s);
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	dc6080e7          	jalr	-570(ra) # 43a <putc>
                    s++;
 67c:	0905                	addi	s2,s2,1
                while (*s != 0)
 67e:	00094583          	lbu	a1,0(s2)
 682:	f9e5                	bnez	a1,672 <vprintf+0x16c>
                s = va_arg(ap, char *);
 684:	8b4e                	mv	s6,s3
            state = 0;
 686:	4981                	li	s3,0
 688:	bdf9                	j	566 <vprintf+0x60>
                    s = "(null)";
 68a:	00000917          	auipc	s2,0x0
 68e:	37690913          	addi	s2,s2,886 # a00 <malloc+0x230>
                while (*s != 0)
 692:	02800593          	li	a1,40
 696:	bff1                	j	672 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 698:	008b0913          	addi	s2,s6,8
 69c:	000b4583          	lbu	a1,0(s6)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	d98080e7          	jalr	-616(ra) # 43a <putc>
 6aa:	8b4a                	mv	s6,s2
            state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bd65                	j	566 <vprintf+0x60>
                putc(fd, c);
 6b0:	85d2                	mv	a1,s4
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	d86080e7          	jalr	-634(ra) # 43a <putc>
            state = 0;
 6bc:	4981                	li	s3,0
 6be:	b565                	j	566 <vprintf+0x60>
                s = va_arg(ap, char *);
 6c0:	8b4e                	mv	s6,s3
            state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b54d                	j	566 <vprintf+0x60>
        }
    }
}
 6c6:	70e6                	ld	ra,120(sp)
 6c8:	7446                	ld	s0,112(sp)
 6ca:	74a6                	ld	s1,104(sp)
 6cc:	7906                	ld	s2,96(sp)
 6ce:	69e6                	ld	s3,88(sp)
 6d0:	6a46                	ld	s4,80(sp)
 6d2:	6aa6                	ld	s5,72(sp)
 6d4:	6b06                	ld	s6,64(sp)
 6d6:	7be2                	ld	s7,56(sp)
 6d8:	7c42                	ld	s8,48(sp)
 6da:	7ca2                	ld	s9,40(sp)
 6dc:	7d02                	ld	s10,32(sp)
 6de:	6de2                	ld	s11,24(sp)
 6e0:	6109                	addi	sp,sp,128
 6e2:	8082                	ret

00000000000006e4 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 6e4:	715d                	addi	sp,sp,-80
 6e6:	ec06                	sd	ra,24(sp)
 6e8:	e822                	sd	s0,16(sp)
 6ea:	1000                	addi	s0,sp,32
 6ec:	e010                	sd	a2,0(s0)
 6ee:	e414                	sd	a3,8(s0)
 6f0:	e818                	sd	a4,16(s0)
 6f2:	ec1c                	sd	a5,24(s0)
 6f4:	03043023          	sd	a6,32(s0)
 6f8:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 6fc:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 700:	8622                	mv	a2,s0
 702:	00000097          	auipc	ra,0x0
 706:	e04080e7          	jalr	-508(ra) # 506 <vprintf>
}
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6161                	addi	sp,sp,80
 710:	8082                	ret

0000000000000712 <printf>:

void printf(const char *fmt, ...)
{
 712:	711d                	addi	sp,sp,-96
 714:	ec06                	sd	ra,24(sp)
 716:	e822                	sd	s0,16(sp)
 718:	1000                	addi	s0,sp,32
 71a:	e40c                	sd	a1,8(s0)
 71c:	e810                	sd	a2,16(s0)
 71e:	ec14                	sd	a3,24(s0)
 720:	f018                	sd	a4,32(s0)
 722:	f41c                	sd	a5,40(s0)
 724:	03043823          	sd	a6,48(s0)
 728:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 72c:	00840613          	addi	a2,s0,8
 730:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 734:	85aa                	mv	a1,a0
 736:	4505                	li	a0,1
 738:	00000097          	auipc	ra,0x0
 73c:	dce080e7          	jalr	-562(ra) # 506 <vprintf>
}
 740:	60e2                	ld	ra,24(sp)
 742:	6442                	ld	s0,16(sp)
 744:	6125                	addi	sp,sp,96
 746:	8082                	ret

0000000000000748 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 748:	1141                	addi	sp,sp,-16
 74a:	e422                	sd	s0,8(sp)
 74c:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 74e:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 752:	00000797          	auipc	a5,0x0
 756:	2ce7b783          	ld	a5,718(a5) # a20 <freep>
 75a:	a805                	j	78a <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 75c:	4618                	lw	a4,8(a2)
 75e:	9db9                	addw	a1,a1,a4
 760:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 764:	6398                	ld	a4,0(a5)
 766:	6318                	ld	a4,0(a4)
 768:	fee53823          	sd	a4,-16(a0)
 76c:	a091                	j	7b0 <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 76e:	ff852703          	lw	a4,-8(a0)
 772:	9e39                	addw	a2,a2,a4
 774:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 776:	ff053703          	ld	a4,-16(a0)
 77a:	e398                	sd	a4,0(a5)
 77c:	a099                	j	7c2 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	6398                	ld	a4,0(a5)
 780:	00e7e463          	bltu	a5,a4,788 <free+0x40>
 784:	00e6ea63          	bltu	a3,a4,798 <free+0x50>
{
 788:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	fed7fae3          	bgeu	a5,a3,77e <free+0x36>
 78e:	6398                	ld	a4,0(a5)
 790:	00e6e463          	bltu	a3,a4,798 <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	fee7eae3          	bltu	a5,a4,788 <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 798:	ff852583          	lw	a1,-8(a0)
 79c:	6390                	ld	a2,0(a5)
 79e:	02059713          	slli	a4,a1,0x20
 7a2:	9301                	srli	a4,a4,0x20
 7a4:	0712                	slli	a4,a4,0x4
 7a6:	9736                	add	a4,a4,a3
 7a8:	fae60ae3          	beq	a2,a4,75c <free+0x14>
        bp->s.ptr = p->s.ptr;
 7ac:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 7b0:	4790                	lw	a2,8(a5)
 7b2:	02061713          	slli	a4,a2,0x20
 7b6:	9301                	srli	a4,a4,0x20
 7b8:	0712                	slli	a4,a4,0x4
 7ba:	973e                	add	a4,a4,a5
 7bc:	fae689e3          	beq	a3,a4,76e <free+0x26>
    }
    else
        p->s.ptr = bp;
 7c0:	e394                	sd	a3,0(a5)
    freep = p;
 7c2:	00000717          	auipc	a4,0x0
 7c6:	24f73f23          	sd	a5,606(a4) # a20 <freep>
}
 7ca:	6422                	ld	s0,8(sp)
 7cc:	0141                	addi	sp,sp,16
 7ce:	8082                	ret

00000000000007d0 <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 7d0:	7139                	addi	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f426                	sd	s1,40(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
 7e2:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7e4:	02051493          	slli	s1,a0,0x20
 7e8:	9081                	srli	s1,s1,0x20
 7ea:	04bd                	addi	s1,s1,15
 7ec:	8091                	srli	s1,s1,0x4
 7ee:	0014899b          	addiw	s3,s1,1
 7f2:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 7f4:	00000517          	auipc	a0,0x0
 7f8:	22c53503          	ld	a0,556(a0) # a20 <freep>
 7fc:	c515                	beqz	a0,828 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 7fe:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 800:	4798                	lw	a4,8(a5)
 802:	02977f63          	bgeu	a4,s1,840 <malloc+0x70>
 806:	8a4e                	mv	s4,s3
 808:	0009871b          	sext.w	a4,s3
 80c:	6685                	lui	a3,0x1
 80e:	00d77363          	bgeu	a4,a3,814 <malloc+0x44>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 81c:	00000917          	auipc	s2,0x0
 820:	20490913          	addi	s2,s2,516 # a20 <freep>
    if (p == (char *)-1)
 824:	5afd                	li	s5,-1
 826:	a88d                	j	898 <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 828:	00000797          	auipc	a5,0x0
 82c:	20078793          	addi	a5,a5,512 # a28 <base>
 830:	00000717          	auipc	a4,0x0
 834:	1ef73823          	sd	a5,496(a4) # a20 <freep>
 838:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 83a:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 83e:	b7e1                	j	806 <malloc+0x36>
            if (p->s.size == nunits)
 840:	02e48b63          	beq	s1,a4,876 <malloc+0xa6>
                p->s.size -= nunits;
 844:	4137073b          	subw	a4,a4,s3
 848:	c798                	sw	a4,8(a5)
                p += p->s.size;
 84a:	1702                	slli	a4,a4,0x20
 84c:	9301                	srli	a4,a4,0x20
 84e:	0712                	slli	a4,a4,0x4
 850:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 852:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 856:	00000717          	auipc	a4,0x0
 85a:	1ca73523          	sd	a0,458(a4) # a20 <freep>
            return (void *)(p + 1);
 85e:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 862:	70e2                	ld	ra,56(sp)
 864:	7442                	ld	s0,48(sp)
 866:	74a2                	ld	s1,40(sp)
 868:	7902                	ld	s2,32(sp)
 86a:	69e2                	ld	s3,24(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
 872:	6121                	addi	sp,sp,64
 874:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	e118                	sd	a4,0(a0)
 87a:	bff1                	j	856 <malloc+0x86>
    hp->s.size = nu;
 87c:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 880:	0541                	addi	a0,a0,16
 882:	00000097          	auipc	ra,0x0
 886:	ec6080e7          	jalr	-314(ra) # 748 <free>
    return freep;
 88a:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 88e:	d971                	beqz	a0,862 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 890:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 892:	4798                	lw	a4,8(a5)
 894:	fa9776e3          	bgeu	a4,s1,840 <malloc+0x70>
        if (p == freep)
 898:	00093703          	ld	a4,0(s2)
 89c:	853e                	mv	a0,a5
 89e:	fef719e3          	bne	a4,a5,890 <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 8a2:	8552                	mv	a0,s4
 8a4:	00000097          	auipc	ra,0x0
 8a8:	b3e080e7          	jalr	-1218(ra) # 3e2 <sbrk>
    if (p == (char *)-1)
 8ac:	fd5518e3          	bne	a0,s5,87c <malloc+0xac>
                return 0;
 8b0:	4501                	li	a0,0
 8b2:	bf45                	j	862 <malloc+0x92>
