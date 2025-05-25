
user/_chmod:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <usage>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void usage() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    fprintf(2, "Usage: chmod [-R] (+|-)(r|w|rw|wr) file_name|dir_name\n");
   8:	00001597          	auipc	a1,0x1
   c:	90858593          	addi	a1,a1,-1784 # 910 <malloc+0xe6>
  10:	4509                	li	a0,2
  12:	00000097          	auipc	ra,0x0
  16:	72c080e7          	jalr	1836(ra) # 73e <fprintf>
    exit(1);
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	398080e7          	jalr	920(ra) # 3b4 <exit>

0000000000000024 <parse_mode>:
}

int parse_mode(char *s, int *mode, int *is_add) {
  24:	1141                	addi	sp,sp,-16
  26:	e422                	sd	s0,8(sp)
  28:	0800                	addi	s0,sp,16
    if (s[0] != '+' && s[0] != '-')
  2a:	00054783          	lbu	a5,0(a0)
  2e:	fd57871b          	addiw	a4,a5,-43
  32:	0fd77713          	andi	a4,a4,253
  36:	c709                	beqz	a4,40 <parse_mode+0x1c>
        return -1;
  38:	557d                	li	a0,-1
        if (s[i] == 'r') *mode |= 1; // M_READ
        else if (s[i] == 'w') *mode |= 2; // M_WRITE
        else return -1;
    }
    return 0;
}
  3a:	6422                	ld	s0,8(sp)
  3c:	0141                	addi	sp,sp,16
  3e:	8082                	ret
    *is_add = (s[0] == '+');
  40:	fd578793          	addi	a5,a5,-43
  44:	0017b793          	seqz	a5,a5
  48:	c21c                	sw	a5,0(a2)
    *mode = 0;
  4a:	0005a023          	sw	zero,0(a1)
    for (int i = 1; s[i]; i++) {
  4e:	00154783          	lbu	a5,1(a0)
  52:	cb95                	beqz	a5,86 <parse_mode+0x62>
  54:	0509                	addi	a0,a0,2
        if (s[i] == 'r') *mode |= 1; // M_READ
  56:	07200713          	li	a4,114
        else if (s[i] == 'w') *mode |= 2; // M_WRITE
  5a:	07700693          	li	a3,119
  5e:	a809                	j	70 <parse_mode+0x4c>
        if (s[i] == 'r') *mode |= 1; // M_READ
  60:	419c                	lw	a5,0(a1)
  62:	0017e793          	ori	a5,a5,1
  66:	c19c                	sw	a5,0(a1)
    for (int i = 1; s[i]; i++) {
  68:	0505                	addi	a0,a0,1
  6a:	fff54783          	lbu	a5,-1(a0)
  6e:	cb91                	beqz	a5,82 <parse_mode+0x5e>
        if (s[i] == 'r') *mode |= 1; // M_READ
  70:	fee788e3          	beq	a5,a4,60 <parse_mode+0x3c>
        else if (s[i] == 'w') *mode |= 2; // M_WRITE
  74:	00d79b63          	bne	a5,a3,8a <parse_mode+0x66>
  78:	419c                	lw	a5,0(a1)
  7a:	0027e793          	ori	a5,a5,2
  7e:	c19c                	sw	a5,0(a1)
  80:	b7e5                	j	68 <parse_mode+0x44>
    return 0;
  82:	4501                	li	a0,0
  84:	bf5d                	j	3a <parse_mode+0x16>
  86:	4501                	li	a0,0
  88:	bf4d                	j	3a <parse_mode+0x16>
        else return -1;
  8a:	557d                	li	a0,-1
  8c:	b77d                	j	3a <parse_mode+0x16>

000000000000008e <main>:

int main(int argc, char *argv[]) {
  8e:	7139                	addi	sp,sp,-64
  90:	fc06                	sd	ra,56(sp)
  92:	f822                	sd	s0,48(sp)
  94:	f426                	sd	s1,40(sp)
  96:	f04a                	sd	s2,32(sp)
  98:	ec4e                	sd	s3,24(sp)
  9a:	0080                	addi	s0,sp,64
    int recursive = 0;
    int arg_idx = 1;

    if (argc < 3)
  9c:	4789                	li	a5,2
  9e:	00a7c663          	blt	a5,a0,aa <main+0x1c>
        usage();
  a2:	00000097          	auipc	ra,0x0
  a6:	f5e080e7          	jalr	-162(ra) # 0 <usage>
  aa:	84aa                	mv	s1,a0
  ac:	892e                	mv	s2,a1

    if (strcmp(argv[1], "-R") == 0) {
  ae:	00001597          	auipc	a1,0x1
  b2:	89a58593          	addi	a1,a1,-1894 # 948 <malloc+0x11e>
  b6:	00893503          	ld	a0,8(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	0a8080e7          	jalr	168(ra) # 162 <strcmp>
  c2:	e919                	bnez	a0,d8 <main+0x4a>
        recursive = 1;
        arg_idx++;
  c4:	4789                	li	a5,2
        recursive = 1;
  c6:	4985                	li	s3,1
    }

    if (argc - arg_idx != 2)
  c8:	9c9d                	subw	s1,s1,a5
  ca:	4709                	li	a4,2
  cc:	00e48963          	beq	s1,a4,de <main+0x50>
        usage();
  d0:	00000097          	auipc	ra,0x0
  d4:	f30080e7          	jalr	-208(ra) # 0 <usage>
    int arg_idx = 1;
  d8:	4785                	li	a5,1
    int recursive = 0;
  da:	4981                	li	s3,0
  dc:	b7f5                	j	c8 <main+0x3a>

    char *mode_str = argv[arg_idx];
  de:	078e                	slli	a5,a5,0x3
    char *path = argv[arg_idx + 1];
  e0:	993e                	add	s2,s2,a5
  e2:	00893483          	ld	s1,8(s2)

    int mode, is_add;
    if (parse_mode(mode_str, &mode, &is_add) < 0)
  e6:	fc840613          	addi	a2,s0,-56
  ea:	fcc40593          	addi	a1,s0,-52
  ee:	00093503          	ld	a0,0(s2)
  f2:	00000097          	auipc	ra,0x0
  f6:	f32080e7          	jalr	-206(ra) # 24 <parse_mode>
  fa:	02054363          	bltz	a0,120 <main+0x92>
        usage();

    if (chmod(path, mode, is_add, recursive) < 0) {
  fe:	86ce                	mv	a3,s3
 100:	fc842603          	lw	a2,-56(s0)
 104:	fcc42583          	lw	a1,-52(s0)
 108:	8526                	mv	a0,s1
 10a:	00000097          	auipc	ra,0x0
 10e:	382080e7          	jalr	898(ra) # 48c <chmod>
 112:	00054b63          	bltz	a0,128 <main+0x9a>
        fprintf(2, "chmod: cannot chmod %s\n", path);
        exit(1);
    }

    exit(0);
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	29c080e7          	jalr	668(ra) # 3b4 <exit>
        usage();
 120:	00000097          	auipc	ra,0x0
 124:	ee0080e7          	jalr	-288(ra) # 0 <usage>
        fprintf(2, "chmod: cannot chmod %s\n", path);
 128:	8626                	mv	a2,s1
 12a:	00001597          	auipc	a1,0x1
 12e:	82658593          	addi	a1,a1,-2010 # 950 <malloc+0x126>
 132:	4509                	li	a0,2
 134:	00000097          	auipc	ra,0x0
 138:	60a080e7          	jalr	1546(ra) # 73e <fprintf>
        exit(1);
 13c:	4505                	li	a0,1
 13e:	00000097          	auipc	ra,0x0
 142:	276080e7          	jalr	630(ra) # 3b4 <exit>

0000000000000146 <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 146:	1141                	addi	sp,sp,-16
 148:	e422                	sd	s0,8(sp)
 14a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 14c:	87aa                	mv	a5,a0
 14e:	0585                	addi	a1,a1,1
 150:	0785                	addi	a5,a5,1
 152:	fff5c703          	lbu	a4,-1(a1)
 156:	fee78fa3          	sb	a4,-1(a5)
 15a:	fb75                	bnez	a4,14e <strcpy+0x8>
        ;
    return os;
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strcmp>:

int strcmp(const char *p, const char *q)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	cb91                	beqz	a5,180 <strcmp+0x1e>
 16e:	0005c703          	lbu	a4,0(a1)
 172:	00f71763          	bne	a4,a5,180 <strcmp+0x1e>
        p++, q++;
 176:	0505                	addi	a0,a0,1
 178:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	fbe5                	bnez	a5,16e <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 180:	0005c503          	lbu	a0,0(a1)
}
 184:	40a7853b          	subw	a0,a5,a0
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strlen>:

uint strlen(const char *s)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 194:	00054783          	lbu	a5,0(a0)
 198:	cf91                	beqz	a5,1b4 <strlen+0x26>
 19a:	0505                	addi	a0,a0,1
 19c:	87aa                	mv	a5,a0
 19e:	4685                	li	a3,1
 1a0:	9e89                	subw	a3,a3,a0
 1a2:	00f6853b          	addw	a0,a3,a5
 1a6:	0785                	addi	a5,a5,1
 1a8:	fff7c703          	lbu	a4,-1(a5)
 1ac:	fb7d                	bnez	a4,1a2 <strlen+0x14>
        ;
    return n;
}
 1ae:	6422                	ld	s0,8(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret
    for (n = 0; s[n]; n++)
 1b4:	4501                	li	a0,0
 1b6:	bfe5                	j	1ae <strlen+0x20>

00000000000001b8 <memset>:

void *memset(void *dst, int c, uint n)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 1be:	ca19                	beqz	a2,1d4 <memset+0x1c>
 1c0:	87aa                	mv	a5,a0
 1c2:	1602                	slli	a2,a2,0x20
 1c4:	9201                	srli	a2,a2,0x20
 1c6:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 1ca:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 1ce:	0785                	addi	a5,a5,1
 1d0:	fee79de3          	bne	a5,a4,1ca <memset+0x12>
    }
    return dst;
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strchr>:

char *strchr(const char *s, char c)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
    for (; *s; s++)
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	cb99                	beqz	a5,1fa <strchr+0x20>
        if (*s == c)
 1e6:	00f58763          	beq	a1,a5,1f4 <strchr+0x1a>
    for (; *s; s++)
 1ea:	0505                	addi	a0,a0,1
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	fbfd                	bnez	a5,1e6 <strchr+0xc>
            return (char *)s;
    return 0;
 1f2:	4501                	li	a0,0
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
    return 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <strchr+0x1a>

00000000000001fe <gets>:

char *gets(char *buf, int max)
{
 1fe:	711d                	addi	sp,sp,-96
 200:	ec86                	sd	ra,88(sp)
 202:	e8a2                	sd	s0,80(sp)
 204:	e4a6                	sd	s1,72(sp)
 206:	e0ca                	sd	s2,64(sp)
 208:	fc4e                	sd	s3,56(sp)
 20a:	f852                	sd	s4,48(sp)
 20c:	f456                	sd	s5,40(sp)
 20e:	f05a                	sd	s6,32(sp)
 210:	ec5e                	sd	s7,24(sp)
 212:	1080                	addi	s0,sp,96
 214:	8baa                	mv	s7,a0
 216:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 218:	892a                	mv	s2,a0
 21a:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 21c:	4aa9                	li	s5,10
 21e:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 220:	89a6                	mv	s3,s1
 222:	2485                	addiw	s1,s1,1
 224:	0344d863          	bge	s1,s4,254 <gets+0x56>
        cc = read(0, &c, 1);
 228:	4605                	li	a2,1
 22a:	faf40593          	addi	a1,s0,-81
 22e:	4501                	li	a0,0
 230:	00000097          	auipc	ra,0x0
 234:	19c080e7          	jalr	412(ra) # 3cc <read>
        if (cc < 1)
 238:	00a05e63          	blez	a0,254 <gets+0x56>
        buf[i++] = c;
 23c:	faf44783          	lbu	a5,-81(s0)
 240:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 244:	01578763          	beq	a5,s5,252 <gets+0x54>
 248:	0905                	addi	s2,s2,1
 24a:	fd679be3          	bne	a5,s6,220 <gets+0x22>
    for (i = 0; i + 1 < max;)
 24e:	89a6                	mv	s3,s1
 250:	a011                	j	254 <gets+0x56>
 252:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 254:	99de                	add	s3,s3,s7
 256:	00098023          	sb	zero,0(s3)
    return buf;
}
 25a:	855e                	mv	a0,s7
 25c:	60e6                	ld	ra,88(sp)
 25e:	6446                	ld	s0,80(sp)
 260:	64a6                	ld	s1,72(sp)
 262:	6906                	ld	s2,64(sp)
 264:	79e2                	ld	s3,56(sp)
 266:	7a42                	ld	s4,48(sp)
 268:	7aa2                	ld	s5,40(sp)
 26a:	7b02                	ld	s6,32(sp)
 26c:	6be2                	ld	s7,24(sp)
 26e:	6125                	addi	sp,sp,96
 270:	8082                	ret

0000000000000272 <stat>:

int stat(const char *n, struct stat *st)
{
 272:	1101                	addi	sp,sp,-32
 274:	ec06                	sd	ra,24(sp)
 276:	e822                	sd	s0,16(sp)
 278:	e426                	sd	s1,8(sp)
 27a:	e04a                	sd	s2,0(sp)
 27c:	1000                	addi	s0,sp,32
 27e:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 280:	4581                	li	a1,0
 282:	00000097          	auipc	ra,0x0
 286:	172080e7          	jalr	370(ra) # 3f4 <open>
    if (fd < 0)
 28a:	02054563          	bltz	a0,2b4 <stat+0x42>
 28e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 290:	85ca                	mv	a1,s2
 292:	00000097          	auipc	ra,0x0
 296:	17a080e7          	jalr	378(ra) # 40c <fstat>
 29a:	892a                	mv	s2,a0
    close(fd);
 29c:	8526                	mv	a0,s1
 29e:	00000097          	auipc	ra,0x0
 2a2:	13e080e7          	jalr	318(ra) # 3dc <close>
    return r;
}
 2a6:	854a                	mv	a0,s2
 2a8:	60e2                	ld	ra,24(sp)
 2aa:	6442                	ld	s0,16(sp)
 2ac:	64a2                	ld	s1,8(sp)
 2ae:	6902                	ld	s2,0(sp)
 2b0:	6105                	addi	sp,sp,32
 2b2:	8082                	ret
        return -1;
 2b4:	597d                	li	s2,-1
 2b6:	bfc5                	j	2a6 <stat+0x34>

00000000000002b8 <atoi>:

int atoi(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 2be:	00054603          	lbu	a2,0(a0)
 2c2:	fd06079b          	addiw	a5,a2,-48
 2c6:	0ff7f793          	andi	a5,a5,255
 2ca:	4725                	li	a4,9
 2cc:	02f76963          	bltu	a4,a5,2fe <atoi+0x46>
 2d0:	86aa                	mv	a3,a0
    n = 0;
 2d2:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 2d4:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 2d6:	0685                	addi	a3,a3,1
 2d8:	0025179b          	slliw	a5,a0,0x2
 2dc:	9fa9                	addw	a5,a5,a0
 2de:	0017979b          	slliw	a5,a5,0x1
 2e2:	9fb1                	addw	a5,a5,a2
 2e4:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 2e8:	0006c603          	lbu	a2,0(a3)
 2ec:	fd06071b          	addiw	a4,a2,-48
 2f0:	0ff77713          	andi	a4,a4,255
 2f4:	fee5f1e3          	bgeu	a1,a4,2d6 <atoi+0x1e>
    return n;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
    n = 0;
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <atoi+0x40>

0000000000000302 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 308:	02b57463          	bgeu	a0,a1,330 <memmove+0x2e>
    {
        while (n-- > 0)
 30c:	00c05f63          	blez	a2,32a <memmove+0x28>
 310:	1602                	slli	a2,a2,0x20
 312:	9201                	srli	a2,a2,0x20
 314:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 318:	872a                	mv	a4,a0
            *dst++ = *src++;
 31a:	0585                	addi	a1,a1,1
 31c:	0705                	addi	a4,a4,1
 31e:	fff5c683          	lbu	a3,-1(a1)
 322:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 326:	fee79ae3          	bne	a5,a4,31a <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
        dst += n;
 330:	00c50733          	add	a4,a0,a2
        src += n;
 334:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 336:	fec05ae3          	blez	a2,32a <memmove+0x28>
 33a:	fff6079b          	addiw	a5,a2,-1
 33e:	1782                	slli	a5,a5,0x20
 340:	9381                	srli	a5,a5,0x20
 342:	fff7c793          	not	a5,a5
 346:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 348:	15fd                	addi	a1,a1,-1
 34a:	177d                	addi	a4,a4,-1
 34c:	0005c683          	lbu	a3,0(a1)
 350:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 354:	fee79ae3          	bne	a5,a4,348 <memmove+0x46>
 358:	bfc9                	j	32a <memmove+0x28>

000000000000035a <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 360:	ca05                	beqz	a2,390 <memcmp+0x36>
 362:	fff6069b          	addiw	a3,a2,-1
 366:	1682                	slli	a3,a3,0x20
 368:	9281                	srli	a3,a3,0x20
 36a:	0685                	addi	a3,a3,1
 36c:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 36e:	00054783          	lbu	a5,0(a0)
 372:	0005c703          	lbu	a4,0(a1)
 376:	00e79863          	bne	a5,a4,386 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 37a:	0505                	addi	a0,a0,1
        p2++;
 37c:	0585                	addi	a1,a1,1
    while (n-- > 0)
 37e:	fed518e3          	bne	a0,a3,36e <memcmp+0x14>
    }
    return 0;
 382:	4501                	li	a0,0
 384:	a019                	j	38a <memcmp+0x30>
            return *p1 - *p2;
 386:	40e7853b          	subw	a0,a5,a4
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
    return 0;
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <memcmp+0x30>

0000000000000394 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 39c:	00000097          	auipc	ra,0x0
 3a0:	f66080e7          	jalr	-154(ra) # 302 <memmove>
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ac:	4885                	li	a7,1
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b4:	4889                	li	a7,2
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3bc:	488d                	li	a7,3
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c4:	4891                	li	a7,4
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <read>:
.global read
read:
 li a7, SYS_read
 3cc:	4895                	li	a7,5
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <write>:
.global write
write:
 li a7, SYS_write
 3d4:	48c1                	li	a7,16
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <close>:
.global close
close:
 li a7, SYS_close
 3dc:	48d5                	li	a7,21
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e4:	4899                	li	a7,6
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ec:	489d                	li	a7,7
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <open>:
.global open
open:
 li a7, SYS_open
 3f4:	48bd                	li	a7,15
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fc:	48c5                	li	a7,17
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 404:	48c9                	li	a7,18
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40c:	48a1                	li	a7,8
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <link>:
.global link
link:
 li a7, SYS_link
 414:	48cd                	li	a7,19
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41c:	48d1                	li	a7,20
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 424:	48a5                	li	a7,9
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <dup>:
.global dup
dup:
 li a7, SYS_dup
 42c:	48a9                	li	a7,10
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 434:	48ad                	li	a7,11
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43c:	48b1                	li	a7,12
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 444:	48b5                	li	a7,13
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44c:	48b9                	li	a7,14
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 454:	48d9                	li	a7,22
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 45c:	48dd                	li	a7,23
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 464:	48e1                	li	a7,24
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 46c:	48e5                	li	a7,25
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 474:	48e9                	li	a7,26
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 47c:	48ed                	li	a7,27
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 484:	48f5                	li	a7,29
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 48c:	48f1                	li	a7,28
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 494:	1101                	addi	sp,sp,-32
 496:	ec06                	sd	ra,24(sp)
 498:	e822                	sd	s0,16(sp)
 49a:	1000                	addi	s0,sp,32
 49c:	feb407a3          	sb	a1,-17(s0)
 4a0:	4605                	li	a2,1
 4a2:	fef40593          	addi	a1,s0,-17
 4a6:	00000097          	auipc	ra,0x0
 4aa:	f2e080e7          	jalr	-210(ra) # 3d4 <write>
 4ae:	60e2                	ld	ra,24(sp)
 4b0:	6442                	ld	s0,16(sp)
 4b2:	6105                	addi	sp,sp,32
 4b4:	8082                	ret

00000000000004b6 <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 4b6:	7139                	addi	sp,sp,-64
 4b8:	fc06                	sd	ra,56(sp)
 4ba:	f822                	sd	s0,48(sp)
 4bc:	f426                	sd	s1,40(sp)
 4be:	f04a                	sd	s2,32(sp)
 4c0:	ec4e                	sd	s3,24(sp)
 4c2:	0080                	addi	s0,sp,64
 4c4:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 4c6:	c299                	beqz	a3,4cc <printint+0x16>
 4c8:	0805c863          	bltz	a1,558 <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 4cc:	2581                	sext.w	a1,a1
    neg = 0;
 4ce:	4881                	li	a7,0
 4d0:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 4d4:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 4d6:	2601                	sext.w	a2,a2
 4d8:	00000517          	auipc	a0,0x0
 4dc:	49850513          	addi	a0,a0,1176 # 970 <digits>
 4e0:	883a                	mv	a6,a4
 4e2:	2705                	addiw	a4,a4,1
 4e4:	02c5f7bb          	remuw	a5,a1,a2
 4e8:	1782                	slli	a5,a5,0x20
 4ea:	9381                	srli	a5,a5,0x20
 4ec:	97aa                	add	a5,a5,a0
 4ee:	0007c783          	lbu	a5,0(a5)
 4f2:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 4f6:	0005879b          	sext.w	a5,a1
 4fa:	02c5d5bb          	divuw	a1,a1,a2
 4fe:	0685                	addi	a3,a3,1
 500:	fec7f0e3          	bgeu	a5,a2,4e0 <printint+0x2a>
    if (neg)
 504:	00088b63          	beqz	a7,51a <printint+0x64>
        buf[i++] = '-';
 508:	fd040793          	addi	a5,s0,-48
 50c:	973e                	add	a4,a4,a5
 50e:	02d00793          	li	a5,45
 512:	fef70823          	sb	a5,-16(a4)
 516:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 51a:	02e05863          	blez	a4,54a <printint+0x94>
 51e:	fc040793          	addi	a5,s0,-64
 522:	00e78933          	add	s2,a5,a4
 526:	fff78993          	addi	s3,a5,-1
 52a:	99ba                	add	s3,s3,a4
 52c:	377d                	addiw	a4,a4,-1
 52e:	1702                	slli	a4,a4,0x20
 530:	9301                	srli	a4,a4,0x20
 532:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 536:	fff94583          	lbu	a1,-1(s2)
 53a:	8526                	mv	a0,s1
 53c:	00000097          	auipc	ra,0x0
 540:	f58080e7          	jalr	-168(ra) # 494 <putc>
    while (--i >= 0)
 544:	197d                	addi	s2,s2,-1
 546:	ff3918e3          	bne	s2,s3,536 <printint+0x80>
}
 54a:	70e2                	ld	ra,56(sp)
 54c:	7442                	ld	s0,48(sp)
 54e:	74a2                	ld	s1,40(sp)
 550:	7902                	ld	s2,32(sp)
 552:	69e2                	ld	s3,24(sp)
 554:	6121                	addi	sp,sp,64
 556:	8082                	ret
        x = -xx;
 558:	40b005bb          	negw	a1,a1
        neg = 1;
 55c:	4885                	li	a7,1
        x = -xx;
 55e:	bf8d                	j	4d0 <printint+0x1a>

0000000000000560 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 560:	7119                	addi	sp,sp,-128
 562:	fc86                	sd	ra,120(sp)
 564:	f8a2                	sd	s0,112(sp)
 566:	f4a6                	sd	s1,104(sp)
 568:	f0ca                	sd	s2,96(sp)
 56a:	ecce                	sd	s3,88(sp)
 56c:	e8d2                	sd	s4,80(sp)
 56e:	e4d6                	sd	s5,72(sp)
 570:	e0da                	sd	s6,64(sp)
 572:	fc5e                	sd	s7,56(sp)
 574:	f862                	sd	s8,48(sp)
 576:	f466                	sd	s9,40(sp)
 578:	f06a                	sd	s10,32(sp)
 57a:	ec6e                	sd	s11,24(sp)
 57c:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 57e:	0005c903          	lbu	s2,0(a1)
 582:	18090f63          	beqz	s2,720 <vprintf+0x1c0>
 586:	8aaa                	mv	s5,a0
 588:	8b32                	mv	s6,a2
 58a:	00158493          	addi	s1,a1,1
    state = 0;
 58e:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 590:	02500a13          	li	s4,37
        {
            if (c == 'd')
 594:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 598:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 59c:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 5a0:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a4:	00000b97          	auipc	s7,0x0
 5a8:	3ccb8b93          	addi	s7,s7,972 # 970 <digits>
 5ac:	a839                	j	5ca <vprintf+0x6a>
                putc(fd, c);
 5ae:	85ca                	mv	a1,s2
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	ee2080e7          	jalr	-286(ra) # 494 <putc>
 5ba:	a019                	j	5c0 <vprintf+0x60>
        else if (state == '%')
 5bc:	01498f63          	beq	s3,s4,5da <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 5c0:	0485                	addi	s1,s1,1
 5c2:	fff4c903          	lbu	s2,-1(s1)
 5c6:	14090d63          	beqz	s2,720 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 5ca:	0009079b          	sext.w	a5,s2
        if (state == 0)
 5ce:	fe0997e3          	bnez	s3,5bc <vprintf+0x5c>
            if (c == '%')
 5d2:	fd479ee3          	bne	a5,s4,5ae <vprintf+0x4e>
                state = '%';
 5d6:	89be                	mv	s3,a5
 5d8:	b7e5                	j	5c0 <vprintf+0x60>
            if (c == 'd')
 5da:	05878063          	beq	a5,s8,61a <vprintf+0xba>
            else if (c == 'l')
 5de:	05978c63          	beq	a5,s9,636 <vprintf+0xd6>
            else if (c == 'x')
 5e2:	07a78863          	beq	a5,s10,652 <vprintf+0xf2>
            else if (c == 'p')
 5e6:	09b78463          	beq	a5,s11,66e <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 5ea:	07300713          	li	a4,115
 5ee:	0ce78663          	beq	a5,a4,6ba <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 5f2:	06300713          	li	a4,99
 5f6:	0ee78e63          	beq	a5,a4,6f2 <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 5fa:	11478863          	beq	a5,s4,70a <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 5fe:	85d2                	mv	a1,s4
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e92080e7          	jalr	-366(ra) # 494 <putc>
                putc(fd, c);
 60a:	85ca                	mv	a1,s2
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e86080e7          	jalr	-378(ra) # 494 <putc>
            }
            state = 0;
 616:	4981                	li	s3,0
 618:	b765                	j	5c0 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 61a:	008b0913          	addi	s2,s6,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000b2583          	lw	a1,0(s6)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e8e080e7          	jalr	-370(ra) # 4b6 <printint>
 630:	8b4a                	mv	s6,s2
            state = 0;
 632:	4981                	li	s3,0
 634:	b771                	j	5c0 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 636:	008b0913          	addi	s2,s6,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000b2583          	lw	a1,0(s6)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e72080e7          	jalr	-398(ra) # 4b6 <printint>
 64c:	8b4a                	mv	s6,s2
            state = 0;
 64e:	4981                	li	s3,0
 650:	bf85                	j	5c0 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 652:	008b0913          	addi	s2,s6,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000b2583          	lw	a1,0(s6)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	e56080e7          	jalr	-426(ra) # 4b6 <printint>
 668:	8b4a                	mv	s6,s2
            state = 0;
 66a:	4981                	li	s3,0
 66c:	bf91                	j	5c0 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 66e:	008b0793          	addi	a5,s6,8
 672:	f8f43423          	sd	a5,-120(s0)
 676:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 67a:	03000593          	li	a1,48
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e14080e7          	jalr	-492(ra) # 494 <putc>
    putc(fd, 'x');
 688:	85ea                	mv	a1,s10
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e08080e7          	jalr	-504(ra) # 494 <putc>
 694:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	03c9d793          	srli	a5,s3,0x3c
 69a:	97de                	add	a5,a5,s7
 69c:	0007c583          	lbu	a1,0(a5)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	df2080e7          	jalr	-526(ra) # 494 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6aa:	0992                	slli	s3,s3,0x4
 6ac:	397d                	addiw	s2,s2,-1
 6ae:	fe0914e3          	bnez	s2,696 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 6b2:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b721                	j	5c0 <vprintf+0x60>
                s = va_arg(ap, char *);
 6ba:	008b0993          	addi	s3,s6,8
 6be:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 6c2:	02090163          	beqz	s2,6e4 <vprintf+0x184>
                while (*s != 0)
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	c9a1                	beqz	a1,71a <vprintf+0x1ba>
                    putc(fd, *s);
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	dc6080e7          	jalr	-570(ra) # 494 <putc>
                    s++;
 6d6:	0905                	addi	s2,s2,1
                while (*s != 0)
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	f9e5                	bnez	a1,6cc <vprintf+0x16c>
                s = va_arg(ap, char *);
 6de:	8b4e                	mv	s6,s3
            state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bdf9                	j	5c0 <vprintf+0x60>
                    s = "(null)";
 6e4:	00000917          	auipc	s2,0x0
 6e8:	28490913          	addi	s2,s2,644 # 968 <malloc+0x13e>
                while (*s != 0)
 6ec:	02800593          	li	a1,40
 6f0:	bff1                	j	6cc <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 6f2:	008b0913          	addi	s2,s6,8
 6f6:	000b4583          	lbu	a1,0(s6)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	d98080e7          	jalr	-616(ra) # 494 <putc>
 704:	8b4a                	mv	s6,s2
            state = 0;
 706:	4981                	li	s3,0
 708:	bd65                	j	5c0 <vprintf+0x60>
                putc(fd, c);
 70a:	85d2                	mv	a1,s4
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	d86080e7          	jalr	-634(ra) # 494 <putc>
            state = 0;
 716:	4981                	li	s3,0
 718:	b565                	j	5c0 <vprintf+0x60>
                s = va_arg(ap, char *);
 71a:	8b4e                	mv	s6,s3
            state = 0;
 71c:	4981                	li	s3,0
 71e:	b54d                	j	5c0 <vprintf+0x60>
        }
    }
}
 720:	70e6                	ld	ra,120(sp)
 722:	7446                	ld	s0,112(sp)
 724:	74a6                	ld	s1,104(sp)
 726:	7906                	ld	s2,96(sp)
 728:	69e6                	ld	s3,88(sp)
 72a:	6a46                	ld	s4,80(sp)
 72c:	6aa6                	ld	s5,72(sp)
 72e:	6b06                	ld	s6,64(sp)
 730:	7be2                	ld	s7,56(sp)
 732:	7c42                	ld	s8,48(sp)
 734:	7ca2                	ld	s9,40(sp)
 736:	7d02                	ld	s10,32(sp)
 738:	6de2                	ld	s11,24(sp)
 73a:	6109                	addi	sp,sp,128
 73c:	8082                	ret

000000000000073e <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 73e:	715d                	addi	sp,sp,-80
 740:	ec06                	sd	ra,24(sp)
 742:	e822                	sd	s0,16(sp)
 744:	1000                	addi	s0,sp,32
 746:	e010                	sd	a2,0(s0)
 748:	e414                	sd	a3,8(s0)
 74a:	e818                	sd	a4,16(s0)
 74c:	ec1c                	sd	a5,24(s0)
 74e:	03043023          	sd	a6,32(s0)
 752:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 756:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 75a:	8622                	mv	a2,s0
 75c:	00000097          	auipc	ra,0x0
 760:	e04080e7          	jalr	-508(ra) # 560 <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6161                	addi	sp,sp,80
 76a:	8082                	ret

000000000000076c <printf>:

void printf(const char *fmt, ...)
{
 76c:	711d                	addi	sp,sp,-96
 76e:	ec06                	sd	ra,24(sp)
 770:	e822                	sd	s0,16(sp)
 772:	1000                	addi	s0,sp,32
 774:	e40c                	sd	a1,8(s0)
 776:	e810                	sd	a2,16(s0)
 778:	ec14                	sd	a3,24(s0)
 77a:	f018                	sd	a4,32(s0)
 77c:	f41c                	sd	a5,40(s0)
 77e:	03043823          	sd	a6,48(s0)
 782:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 786:	00840613          	addi	a2,s0,8
 78a:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 78e:	85aa                	mv	a1,a0
 790:	4505                	li	a0,1
 792:	00000097          	auipc	ra,0x0
 796:	dce080e7          	jalr	-562(ra) # 560 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 7a2:	1141                	addi	sp,sp,-16
 7a4:	e422                	sd	s0,8(sp)
 7a6:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 7a8:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ac:	00000797          	auipc	a5,0x0
 7b0:	1dc7b783          	ld	a5,476(a5) # 988 <freep>
 7b4:	a805                	j	7e4 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 7b6:	4618                	lw	a4,8(a2)
 7b8:	9db9                	addw	a1,a1,a4
 7ba:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 7be:	6398                	ld	a4,0(a5)
 7c0:	6318                	ld	a4,0(a4)
 7c2:	fee53823          	sd	a4,-16(a0)
 7c6:	a091                	j	80a <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 7c8:	ff852703          	lw	a4,-8(a0)
 7cc:	9e39                	addw	a2,a2,a4
 7ce:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 7d0:	ff053703          	ld	a4,-16(a0)
 7d4:	e398                	sd	a4,0(a5)
 7d6:	a099                	j	81c <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e7e463          	bltu	a5,a4,7e2 <free+0x40>
 7de:	00e6ea63          	bltu	a3,a4,7f2 <free+0x50>
{
 7e2:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	fed7fae3          	bgeu	a5,a3,7d8 <free+0x36>
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e6e463          	bltu	a3,a4,7f2 <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	fee7eae3          	bltu	a5,a4,7e2 <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 7f2:	ff852583          	lw	a1,-8(a0)
 7f6:	6390                	ld	a2,0(a5)
 7f8:	02059713          	slli	a4,a1,0x20
 7fc:	9301                	srli	a4,a4,0x20
 7fe:	0712                	slli	a4,a4,0x4
 800:	9736                	add	a4,a4,a3
 802:	fae60ae3          	beq	a2,a4,7b6 <free+0x14>
        bp->s.ptr = p->s.ptr;
 806:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 80a:	4790                	lw	a2,8(a5)
 80c:	02061713          	slli	a4,a2,0x20
 810:	9301                	srli	a4,a4,0x20
 812:	0712                	slli	a4,a4,0x4
 814:	973e                	add	a4,a4,a5
 816:	fae689e3          	beq	a3,a4,7c8 <free+0x26>
    }
    else
        p->s.ptr = bp;
 81a:	e394                	sd	a3,0(a5)
    freep = p;
 81c:	00000717          	auipc	a4,0x0
 820:	16f73623          	sd	a5,364(a4) # 988 <freep>
}
 824:	6422                	ld	s0,8(sp)
 826:	0141                	addi	sp,sp,16
 828:	8082                	ret

000000000000082a <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 82a:	7139                	addi	sp,sp,-64
 82c:	fc06                	sd	ra,56(sp)
 82e:	f822                	sd	s0,48(sp)
 830:	f426                	sd	s1,40(sp)
 832:	f04a                	sd	s2,32(sp)
 834:	ec4e                	sd	s3,24(sp)
 836:	e852                	sd	s4,16(sp)
 838:	e456                	sd	s5,8(sp)
 83a:	e05a                	sd	s6,0(sp)
 83c:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 83e:	02051493          	slli	s1,a0,0x20
 842:	9081                	srli	s1,s1,0x20
 844:	04bd                	addi	s1,s1,15
 846:	8091                	srli	s1,s1,0x4
 848:	0014899b          	addiw	s3,s1,1
 84c:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 84e:	00000517          	auipc	a0,0x0
 852:	13a53503          	ld	a0,314(a0) # 988 <freep>
 856:	c515                	beqz	a0,882 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 858:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 85a:	4798                	lw	a4,8(a5)
 85c:	02977f63          	bgeu	a4,s1,89a <malloc+0x70>
 860:	8a4e                	mv	s4,s3
 862:	0009871b          	sext.w	a4,s3
 866:	6685                	lui	a3,0x1
 868:	00d77363          	bgeu	a4,a3,86e <malloc+0x44>
 86c:	6a05                	lui	s4,0x1
 86e:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 872:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 876:	00000917          	auipc	s2,0x0
 87a:	11290913          	addi	s2,s2,274 # 988 <freep>
    if (p == (char *)-1)
 87e:	5afd                	li	s5,-1
 880:	a88d                	j	8f2 <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 882:	00000797          	auipc	a5,0x0
 886:	10e78793          	addi	a5,a5,270 # 990 <base>
 88a:	00000717          	auipc	a4,0x0
 88e:	0ef73f23          	sd	a5,254(a4) # 988 <freep>
 892:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 894:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 898:	b7e1                	j	860 <malloc+0x36>
            if (p->s.size == nunits)
 89a:	02e48b63          	beq	s1,a4,8d0 <malloc+0xa6>
                p->s.size -= nunits;
 89e:	4137073b          	subw	a4,a4,s3
 8a2:	c798                	sw	a4,8(a5)
                p += p->s.size;
 8a4:	1702                	slli	a4,a4,0x20
 8a6:	9301                	srli	a4,a4,0x20
 8a8:	0712                	slli	a4,a4,0x4
 8aa:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 8ac:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	0ca73c23          	sd	a0,216(a4) # 988 <freep>
            return (void *)(p + 1);
 8b8:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 8bc:	70e2                	ld	ra,56(sp)
 8be:	7442                	ld	s0,48(sp)
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	7902                	ld	s2,32(sp)
 8c4:	69e2                	ld	s3,24(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	6121                	addi	sp,sp,64
 8ce:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	e118                	sd	a4,0(a0)
 8d4:	bff1                	j	8b0 <malloc+0x86>
    hp->s.size = nu;
 8d6:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 8da:	0541                	addi	a0,a0,16
 8dc:	00000097          	auipc	ra,0x0
 8e0:	ec6080e7          	jalr	-314(ra) # 7a2 <free>
    return freep;
 8e4:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 8e8:	d971                	beqz	a0,8bc <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 8ea:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 8ec:	4798                	lw	a4,8(a5)
 8ee:	fa9776e3          	bgeu	a4,s1,89a <malloc+0x70>
        if (p == freep)
 8f2:	00093703          	ld	a4,0(s2)
 8f6:	853e                	mv	a0,a5
 8f8:	fef719e3          	bne	a4,a5,8ea <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 8fc:	8552                	mv	a0,s4
 8fe:	00000097          	auipc	ra,0x0
 902:	b3e080e7          	jalr	-1218(ra) # 43c <sbrk>
    if (p == (char *)-1)
 906:	fd5518e3          	bne	a0,s5,8d6 <malloc+0xac>
                return 0;
 90a:	4501                	li	a0,0
 90c:	bf45                	j	8bc <malloc+0x92>
