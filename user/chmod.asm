
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
   c:	91858593          	addi	a1,a1,-1768 # 920 <malloc+0xe4>
  10:	4509                	li	a0,2
  12:	00000097          	auipc	ra,0x0
  16:	73e080e7          	jalr	1854(ra) # 750 <fprintf>
    exit(1);
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	3aa080e7          	jalr	938(ra) # 3c6 <exit>

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
  b2:	8aa58593          	addi	a1,a1,-1878 # 958 <malloc+0x11c>
  b6:	00893503          	ld	a0,8(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	0ba080e7          	jalr	186(ra) # 174 <strcmp>
  c2:	e919                	bnez	a0,d8 <main+0x4a>
        recursive = 1;
        arg_idx++;
  c4:	4589                	li	a1,2
        recursive = 1;
  c6:	4985                	li	s3,1
    }

    if (argc - arg_idx != 2)
  c8:	9c8d                	subw	s1,s1,a1
  ca:	4789                	li	a5,2
  cc:	00f48963          	beq	s1,a5,de <main+0x50>
        usage();
  d0:	00000097          	auipc	ra,0x0
  d4:	f30080e7          	jalr	-208(ra) # 0 <usage>
    int arg_idx = 1;
  d8:	4585                	li	a1,1
    int recursive = 0;
  da:	4981                	li	s3,0
  dc:	b7f5                	j	c8 <main+0x3a>

    char *mode_str = argv[arg_idx];
  de:	058e                	slli	a1,a1,0x3
  e0:	95ca                	add	a1,a1,s2
  e2:	0005b903          	ld	s2,0(a1)
    char *path = argv[arg_idx + 1];
  e6:	6584                	ld	s1,8(a1)
    printf("Calling chmod on path = %s\n", path);
  e8:	85a6                	mv	a1,s1
  ea:	00001517          	auipc	a0,0x1
  ee:	87650513          	addi	a0,a0,-1930 # 960 <malloc+0x124>
  f2:	00000097          	auipc	ra,0x0
  f6:	68c080e7          	jalr	1676(ra) # 77e <printf>


    int mode, is_add;
    if (parse_mode(mode_str, &mode, &is_add) < 0)
  fa:	fc840613          	addi	a2,s0,-56
  fe:	fcc40593          	addi	a1,s0,-52
 102:	854a                	mv	a0,s2
 104:	00000097          	auipc	ra,0x0
 108:	f20080e7          	jalr	-224(ra) # 24 <parse_mode>
 10c:	02054363          	bltz	a0,132 <main+0xa4>
        usage();

    if (chmod(path, mode, is_add, recursive) < 0) {
 110:	86ce                	mv	a3,s3
 112:	fc842603          	lw	a2,-56(s0)
 116:	fcc42583          	lw	a1,-52(s0)
 11a:	8526                	mv	a0,s1
 11c:	00000097          	auipc	ra,0x0
 120:	382080e7          	jalr	898(ra) # 49e <chmod>
 124:	00054b63          	bltz	a0,13a <main+0xac>
        fprintf(2, "chmod: cannot chmod %s\n", path);
        exit(1);
    }

    exit(0);
 128:	4501                	li	a0,0
 12a:	00000097          	auipc	ra,0x0
 12e:	29c080e7          	jalr	668(ra) # 3c6 <exit>
        usage();
 132:	00000097          	auipc	ra,0x0
 136:	ece080e7          	jalr	-306(ra) # 0 <usage>
        fprintf(2, "chmod: cannot chmod %s\n", path);
 13a:	8626                	mv	a2,s1
 13c:	00001597          	auipc	a1,0x1
 140:	84458593          	addi	a1,a1,-1980 # 980 <malloc+0x144>
 144:	4509                	li	a0,2
 146:	00000097          	auipc	ra,0x0
 14a:	60a080e7          	jalr	1546(ra) # 750 <fprintf>
        exit(1);
 14e:	4505                	li	a0,1
 150:	00000097          	auipc	ra,0x0
 154:	276080e7          	jalr	630(ra) # 3c6 <exit>

0000000000000158 <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 15e:	87aa                	mv	a5,a0
 160:	0585                	addi	a1,a1,1
 162:	0785                	addi	a5,a5,1
 164:	fff5c703          	lbu	a4,-1(a1)
 168:	fee78fa3          	sb	a4,-1(a5)
 16c:	fb75                	bnez	a4,160 <strcpy+0x8>
        ;
    return os;
}
 16e:	6422                	ld	s0,8(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret

0000000000000174 <strcmp>:

int strcmp(const char *p, const char *q)
{
 174:	1141                	addi	sp,sp,-16
 176:	e422                	sd	s0,8(sp)
 178:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	cb91                	beqz	a5,192 <strcmp+0x1e>
 180:	0005c703          	lbu	a4,0(a1)
 184:	00f71763          	bne	a4,a5,192 <strcmp+0x1e>
        p++, q++;
 188:	0505                	addi	a0,a0,1
 18a:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 18c:	00054783          	lbu	a5,0(a0)
 190:	fbe5                	bnez	a5,180 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 192:	0005c503          	lbu	a0,0(a1)
}
 196:	40a7853b          	subw	a0,a5,a0
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strlen>:

uint strlen(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cf91                	beqz	a5,1c6 <strlen+0x26>
 1ac:	0505                	addi	a0,a0,1
 1ae:	87aa                	mv	a5,a0
 1b0:	4685                	li	a3,1
 1b2:	9e89                	subw	a3,a3,a0
 1b4:	00f6853b          	addw	a0,a3,a5
 1b8:	0785                	addi	a5,a5,1
 1ba:	fff7c703          	lbu	a4,-1(a5)
 1be:	fb7d                	bnez	a4,1b4 <strlen+0x14>
        ;
    return n;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
    for (n = 0; s[n]; n++)
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strlen+0x20>

00000000000001ca <memset>:

void *memset(void *dst, int c, uint n)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 1d0:	ca19                	beqz	a2,1e6 <memset+0x1c>
 1d2:	87aa                	mv	a5,a0
 1d4:	1602                	slli	a2,a2,0x20
 1d6:	9201                	srli	a2,a2,0x20
 1d8:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 1dc:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 1e0:	0785                	addi	a5,a5,1
 1e2:	fee79de3          	bne	a5,a4,1dc <memset+0x12>
    }
    return dst;
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strchr>:

char *strchr(const char *s, char c)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
    for (; *s; s++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cb99                	beqz	a5,20c <strchr+0x20>
        if (*s == c)
 1f8:	00f58763          	beq	a1,a5,206 <strchr+0x1a>
    for (; *s; s++)
 1fc:	0505                	addi	a0,a0,1
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbfd                	bnez	a5,1f8 <strchr+0xc>
            return (char *)s;
    return 0;
 204:	4501                	li	a0,0
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
    return 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <strchr+0x1a>

0000000000000210 <gets>:

char *gets(char *buf, int max)
{
 210:	711d                	addi	sp,sp,-96
 212:	ec86                	sd	ra,88(sp)
 214:	e8a2                	sd	s0,80(sp)
 216:	e4a6                	sd	s1,72(sp)
 218:	e0ca                	sd	s2,64(sp)
 21a:	fc4e                	sd	s3,56(sp)
 21c:	f852                	sd	s4,48(sp)
 21e:	f456                	sd	s5,40(sp)
 220:	f05a                	sd	s6,32(sp)
 222:	ec5e                	sd	s7,24(sp)
 224:	1080                	addi	s0,sp,96
 226:	8baa                	mv	s7,a0
 228:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 22a:	892a                	mv	s2,a0
 22c:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 22e:	4aa9                	li	s5,10
 230:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 232:	89a6                	mv	s3,s1
 234:	2485                	addiw	s1,s1,1
 236:	0344d863          	bge	s1,s4,266 <gets+0x56>
        cc = read(0, &c, 1);
 23a:	4605                	li	a2,1
 23c:	faf40593          	addi	a1,s0,-81
 240:	4501                	li	a0,0
 242:	00000097          	auipc	ra,0x0
 246:	19c080e7          	jalr	412(ra) # 3de <read>
        if (cc < 1)
 24a:	00a05e63          	blez	a0,266 <gets+0x56>
        buf[i++] = c;
 24e:	faf44783          	lbu	a5,-81(s0)
 252:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 256:	01578763          	beq	a5,s5,264 <gets+0x54>
 25a:	0905                	addi	s2,s2,1
 25c:	fd679be3          	bne	a5,s6,232 <gets+0x22>
    for (i = 0; i + 1 < max;)
 260:	89a6                	mv	s3,s1
 262:	a011                	j	266 <gets+0x56>
 264:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 266:	99de                	add	s3,s3,s7
 268:	00098023          	sb	zero,0(s3)
    return buf;
}
 26c:	855e                	mv	a0,s7
 26e:	60e6                	ld	ra,88(sp)
 270:	6446                	ld	s0,80(sp)
 272:	64a6                	ld	s1,72(sp)
 274:	6906                	ld	s2,64(sp)
 276:	79e2                	ld	s3,56(sp)
 278:	7a42                	ld	s4,48(sp)
 27a:	7aa2                	ld	s5,40(sp)
 27c:	7b02                	ld	s6,32(sp)
 27e:	6be2                	ld	s7,24(sp)
 280:	6125                	addi	sp,sp,96
 282:	8082                	ret

0000000000000284 <stat>:

int stat(const char *n, struct stat *st)
{
 284:	1101                	addi	sp,sp,-32
 286:	ec06                	sd	ra,24(sp)
 288:	e822                	sd	s0,16(sp)
 28a:	e426                	sd	s1,8(sp)
 28c:	e04a                	sd	s2,0(sp)
 28e:	1000                	addi	s0,sp,32
 290:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 292:	4581                	li	a1,0
 294:	00000097          	auipc	ra,0x0
 298:	172080e7          	jalr	370(ra) # 406 <open>
    if (fd < 0)
 29c:	02054563          	bltz	a0,2c6 <stat+0x42>
 2a0:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 2a2:	85ca                	mv	a1,s2
 2a4:	00000097          	auipc	ra,0x0
 2a8:	17a080e7          	jalr	378(ra) # 41e <fstat>
 2ac:	892a                	mv	s2,a0
    close(fd);
 2ae:	8526                	mv	a0,s1
 2b0:	00000097          	auipc	ra,0x0
 2b4:	13e080e7          	jalr	318(ra) # 3ee <close>
    return r;
}
 2b8:	854a                	mv	a0,s2
 2ba:	60e2                	ld	ra,24(sp)
 2bc:	6442                	ld	s0,16(sp)
 2be:	64a2                	ld	s1,8(sp)
 2c0:	6902                	ld	s2,0(sp)
 2c2:	6105                	addi	sp,sp,32
 2c4:	8082                	ret
        return -1;
 2c6:	597d                	li	s2,-1
 2c8:	bfc5                	j	2b8 <stat+0x34>

00000000000002ca <atoi>:

int atoi(const char *s)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 2d0:	00054603          	lbu	a2,0(a0)
 2d4:	fd06079b          	addiw	a5,a2,-48
 2d8:	0ff7f793          	andi	a5,a5,255
 2dc:	4725                	li	a4,9
 2de:	02f76963          	bltu	a4,a5,310 <atoi+0x46>
 2e2:	86aa                	mv	a3,a0
    n = 0;
 2e4:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 2e6:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 2e8:	0685                	addi	a3,a3,1
 2ea:	0025179b          	slliw	a5,a0,0x2
 2ee:	9fa9                	addw	a5,a5,a0
 2f0:	0017979b          	slliw	a5,a5,0x1
 2f4:	9fb1                	addw	a5,a5,a2
 2f6:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 2fa:	0006c603          	lbu	a2,0(a3)
 2fe:	fd06071b          	addiw	a4,a2,-48
 302:	0ff77713          	andi	a4,a4,255
 306:	fee5f1e3          	bgeu	a1,a4,2e8 <atoi+0x1e>
    return n;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    n = 0;
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <atoi+0x40>

0000000000000314 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 31a:	02b57463          	bgeu	a0,a1,342 <memmove+0x2e>
    {
        while (n-- > 0)
 31e:	00c05f63          	blez	a2,33c <memmove+0x28>
 322:	1602                	slli	a2,a2,0x20
 324:	9201                	srli	a2,a2,0x20
 326:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 32a:	872a                	mv	a4,a0
            *dst++ = *src++;
 32c:	0585                	addi	a1,a1,1
 32e:	0705                	addi	a4,a4,1
 330:	fff5c683          	lbu	a3,-1(a1)
 334:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 338:	fee79ae3          	bne	a5,a4,32c <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
        dst += n;
 342:	00c50733          	add	a4,a0,a2
        src += n;
 346:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 348:	fec05ae3          	blez	a2,33c <memmove+0x28>
 34c:	fff6079b          	addiw	a5,a2,-1
 350:	1782                	slli	a5,a5,0x20
 352:	9381                	srli	a5,a5,0x20
 354:	fff7c793          	not	a5,a5
 358:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 35a:	15fd                	addi	a1,a1,-1
 35c:	177d                	addi	a4,a4,-1
 35e:	0005c683          	lbu	a3,0(a1)
 362:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 366:	fee79ae3          	bne	a5,a4,35a <memmove+0x46>
 36a:	bfc9                	j	33c <memmove+0x28>

000000000000036c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 372:	ca05                	beqz	a2,3a2 <memcmp+0x36>
 374:	fff6069b          	addiw	a3,a2,-1
 378:	1682                	slli	a3,a3,0x20
 37a:	9281                	srli	a3,a3,0x20
 37c:	0685                	addi	a3,a3,1
 37e:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 380:	00054783          	lbu	a5,0(a0)
 384:	0005c703          	lbu	a4,0(a1)
 388:	00e79863          	bne	a5,a4,398 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 38c:	0505                	addi	a0,a0,1
        p2++;
 38e:	0585                	addi	a1,a1,1
    while (n-- > 0)
 390:	fed518e3          	bne	a0,a3,380 <memcmp+0x14>
    }
    return 0;
 394:	4501                	li	a0,0
 396:	a019                	j	39c <memcmp+0x30>
            return *p1 - *p2;
 398:	40e7853b          	subw	a0,a5,a4
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
    return 0;
 3a2:	4501                	li	a0,0
 3a4:	bfe5                	j	39c <memcmp+0x30>

00000000000003a6 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 3ae:	00000097          	auipc	ra,0x0
 3b2:	f66080e7          	jalr	-154(ra) # 314 <memmove>
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3be:	4885                	li	a7,1
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c6:	4889                	li	a7,2
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ce:	488d                	li	a7,3
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d6:	4891                	li	a7,4
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <read>:
.global read
read:
 li a7, SYS_read
 3de:	4895                	li	a7,5
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <write>:
.global write
write:
 li a7, SYS_write
 3e6:	48c1                	li	a7,16
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <close>:
.global close
close:
 li a7, SYS_close
 3ee:	48d5                	li	a7,21
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f6:	4899                	li	a7,6
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fe:	489d                	li	a7,7
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <open>:
.global open
open:
 li a7, SYS_open
 406:	48bd                	li	a7,15
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40e:	48c5                	li	a7,17
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 416:	48c9                	li	a7,18
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41e:	48a1                	li	a7,8
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <link>:
.global link
link:
 li a7, SYS_link
 426:	48cd                	li	a7,19
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42e:	48d1                	li	a7,20
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 436:	48a5                	li	a7,9
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <dup>:
.global dup
dup:
 li a7, SYS_dup
 43e:	48a9                	li	a7,10
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 446:	48ad                	li	a7,11
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 44e:	48b1                	li	a7,12
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 456:	48b5                	li	a7,13
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45e:	48b9                	li	a7,14
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 466:	48d9                	li	a7,22
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 46e:	48dd                	li	a7,23
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 476:	48e1                	li	a7,24
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 47e:	48e5                	li	a7,25
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 486:	48e9                	li	a7,26
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 48e:	48ed                	li	a7,27
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 496:	48f5                	li	a7,29
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 49e:	48f1                	li	a7,28
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 4a6:	1101                	addi	sp,sp,-32
 4a8:	ec06                	sd	ra,24(sp)
 4aa:	e822                	sd	s0,16(sp)
 4ac:	1000                	addi	s0,sp,32
 4ae:	feb407a3          	sb	a1,-17(s0)
 4b2:	4605                	li	a2,1
 4b4:	fef40593          	addi	a1,s0,-17
 4b8:	00000097          	auipc	ra,0x0
 4bc:	f2e080e7          	jalr	-210(ra) # 3e6 <write>
 4c0:	60e2                	ld	ra,24(sp)
 4c2:	6442                	ld	s0,16(sp)
 4c4:	6105                	addi	sp,sp,32
 4c6:	8082                	ret

00000000000004c8 <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 4c8:	7139                	addi	sp,sp,-64
 4ca:	fc06                	sd	ra,56(sp)
 4cc:	f822                	sd	s0,48(sp)
 4ce:	f426                	sd	s1,40(sp)
 4d0:	f04a                	sd	s2,32(sp)
 4d2:	ec4e                	sd	s3,24(sp)
 4d4:	0080                	addi	s0,sp,64
 4d6:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 4d8:	c299                	beqz	a3,4de <printint+0x16>
 4da:	0805c863          	bltz	a1,56a <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 4de:	2581                	sext.w	a1,a1
    neg = 0;
 4e0:	4881                	li	a7,0
 4e2:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 4e6:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 4e8:	2601                	sext.w	a2,a2
 4ea:	00000517          	auipc	a0,0x0
 4ee:	4b650513          	addi	a0,a0,1206 # 9a0 <digits>
 4f2:	883a                	mv	a6,a4
 4f4:	2705                	addiw	a4,a4,1
 4f6:	02c5f7bb          	remuw	a5,a1,a2
 4fa:	1782                	slli	a5,a5,0x20
 4fc:	9381                	srli	a5,a5,0x20
 4fe:	97aa                	add	a5,a5,a0
 500:	0007c783          	lbu	a5,0(a5)
 504:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 508:	0005879b          	sext.w	a5,a1
 50c:	02c5d5bb          	divuw	a1,a1,a2
 510:	0685                	addi	a3,a3,1
 512:	fec7f0e3          	bgeu	a5,a2,4f2 <printint+0x2a>
    if (neg)
 516:	00088b63          	beqz	a7,52c <printint+0x64>
        buf[i++] = '-';
 51a:	fd040793          	addi	a5,s0,-48
 51e:	973e                	add	a4,a4,a5
 520:	02d00793          	li	a5,45
 524:	fef70823          	sb	a5,-16(a4)
 528:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 52c:	02e05863          	blez	a4,55c <printint+0x94>
 530:	fc040793          	addi	a5,s0,-64
 534:	00e78933          	add	s2,a5,a4
 538:	fff78993          	addi	s3,a5,-1
 53c:	99ba                	add	s3,s3,a4
 53e:	377d                	addiw	a4,a4,-1
 540:	1702                	slli	a4,a4,0x20
 542:	9301                	srli	a4,a4,0x20
 544:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 548:	fff94583          	lbu	a1,-1(s2)
 54c:	8526                	mv	a0,s1
 54e:	00000097          	auipc	ra,0x0
 552:	f58080e7          	jalr	-168(ra) # 4a6 <putc>
    while (--i >= 0)
 556:	197d                	addi	s2,s2,-1
 558:	ff3918e3          	bne	s2,s3,548 <printint+0x80>
}
 55c:	70e2                	ld	ra,56(sp)
 55e:	7442                	ld	s0,48(sp)
 560:	74a2                	ld	s1,40(sp)
 562:	7902                	ld	s2,32(sp)
 564:	69e2                	ld	s3,24(sp)
 566:	6121                	addi	sp,sp,64
 568:	8082                	ret
        x = -xx;
 56a:	40b005bb          	negw	a1,a1
        neg = 1;
 56e:	4885                	li	a7,1
        x = -xx;
 570:	bf8d                	j	4e2 <printint+0x1a>

0000000000000572 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 572:	7119                	addi	sp,sp,-128
 574:	fc86                	sd	ra,120(sp)
 576:	f8a2                	sd	s0,112(sp)
 578:	f4a6                	sd	s1,104(sp)
 57a:	f0ca                	sd	s2,96(sp)
 57c:	ecce                	sd	s3,88(sp)
 57e:	e8d2                	sd	s4,80(sp)
 580:	e4d6                	sd	s5,72(sp)
 582:	e0da                	sd	s6,64(sp)
 584:	fc5e                	sd	s7,56(sp)
 586:	f862                	sd	s8,48(sp)
 588:	f466                	sd	s9,40(sp)
 58a:	f06a                	sd	s10,32(sp)
 58c:	ec6e                	sd	s11,24(sp)
 58e:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 590:	0005c903          	lbu	s2,0(a1)
 594:	18090f63          	beqz	s2,732 <vprintf+0x1c0>
 598:	8aaa                	mv	s5,a0
 59a:	8b32                	mv	s6,a2
 59c:	00158493          	addi	s1,a1,1
    state = 0;
 5a0:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 5a2:	02500a13          	li	s4,37
        {
            if (c == 'd')
 5a6:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 5aa:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 5ae:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 5b2:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b6:	00000b97          	auipc	s7,0x0
 5ba:	3eab8b93          	addi	s7,s7,1002 # 9a0 <digits>
 5be:	a839                	j	5dc <vprintf+0x6a>
                putc(fd, c);
 5c0:	85ca                	mv	a1,s2
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	ee2080e7          	jalr	-286(ra) # 4a6 <putc>
 5cc:	a019                	j	5d2 <vprintf+0x60>
        else if (state == '%')
 5ce:	01498f63          	beq	s3,s4,5ec <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 5d2:	0485                	addi	s1,s1,1
 5d4:	fff4c903          	lbu	s2,-1(s1)
 5d8:	14090d63          	beqz	s2,732 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 5dc:	0009079b          	sext.w	a5,s2
        if (state == 0)
 5e0:	fe0997e3          	bnez	s3,5ce <vprintf+0x5c>
            if (c == '%')
 5e4:	fd479ee3          	bne	a5,s4,5c0 <vprintf+0x4e>
                state = '%';
 5e8:	89be                	mv	s3,a5
 5ea:	b7e5                	j	5d2 <vprintf+0x60>
            if (c == 'd')
 5ec:	05878063          	beq	a5,s8,62c <vprintf+0xba>
            else if (c == 'l')
 5f0:	05978c63          	beq	a5,s9,648 <vprintf+0xd6>
            else if (c == 'x')
 5f4:	07a78863          	beq	a5,s10,664 <vprintf+0xf2>
            else if (c == 'p')
 5f8:	09b78463          	beq	a5,s11,680 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 5fc:	07300713          	li	a4,115
 600:	0ce78663          	beq	a5,a4,6cc <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 604:	06300713          	li	a4,99
 608:	0ee78e63          	beq	a5,a4,704 <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 60c:	11478863          	beq	a5,s4,71c <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 610:	85d2                	mv	a1,s4
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e92080e7          	jalr	-366(ra) # 4a6 <putc>
                putc(fd, c);
 61c:	85ca                	mv	a1,s2
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e86080e7          	jalr	-378(ra) # 4a6 <putc>
            }
            state = 0;
 628:	4981                	li	s3,0
 62a:	b765                	j	5d2 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 62c:	008b0913          	addi	s2,s6,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000b2583          	lw	a1,0(s6)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e8e080e7          	jalr	-370(ra) # 4c8 <printint>
 642:	8b4a                	mv	s6,s2
            state = 0;
 644:	4981                	li	s3,0
 646:	b771                	j	5d2 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 648:	008b0913          	addi	s2,s6,8
 64c:	4681                	li	a3,0
 64e:	4629                	li	a2,10
 650:	000b2583          	lw	a1,0(s6)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e72080e7          	jalr	-398(ra) # 4c8 <printint>
 65e:	8b4a                	mv	s6,s2
            state = 0;
 660:	4981                	li	s3,0
 662:	bf85                	j	5d2 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 664:	008b0913          	addi	s2,s6,8
 668:	4681                	li	a3,0
 66a:	4641                	li	a2,16
 66c:	000b2583          	lw	a1,0(s6)
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e56080e7          	jalr	-426(ra) # 4c8 <printint>
 67a:	8b4a                	mv	s6,s2
            state = 0;
 67c:	4981                	li	s3,0
 67e:	bf91                	j	5d2 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 680:	008b0793          	addi	a5,s6,8
 684:	f8f43423          	sd	a5,-120(s0)
 688:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 68c:	03000593          	li	a1,48
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e14080e7          	jalr	-492(ra) # 4a6 <putc>
    putc(fd, 'x');
 69a:	85ea                	mv	a1,s10
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e08080e7          	jalr	-504(ra) # 4a6 <putc>
 6a6:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a8:	03c9d793          	srli	a5,s3,0x3c
 6ac:	97de                	add	a5,a5,s7
 6ae:	0007c583          	lbu	a1,0(a5)
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	df2080e7          	jalr	-526(ra) # 4a6 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6bc:	0992                	slli	s3,s3,0x4
 6be:	397d                	addiw	s2,s2,-1
 6c0:	fe0914e3          	bnez	s2,6a8 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 6c4:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b721                	j	5d2 <vprintf+0x60>
                s = va_arg(ap, char *);
 6cc:	008b0993          	addi	s3,s6,8
 6d0:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 6d4:	02090163          	beqz	s2,6f6 <vprintf+0x184>
                while (*s != 0)
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	c9a1                	beqz	a1,72c <vprintf+0x1ba>
                    putc(fd, *s);
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	dc6080e7          	jalr	-570(ra) # 4a6 <putc>
                    s++;
 6e8:	0905                	addi	s2,s2,1
                while (*s != 0)
 6ea:	00094583          	lbu	a1,0(s2)
 6ee:	f9e5                	bnez	a1,6de <vprintf+0x16c>
                s = va_arg(ap, char *);
 6f0:	8b4e                	mv	s6,s3
            state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bdf9                	j	5d2 <vprintf+0x60>
                    s = "(null)";
 6f6:	00000917          	auipc	s2,0x0
 6fa:	2a290913          	addi	s2,s2,674 # 998 <malloc+0x15c>
                while (*s != 0)
 6fe:	02800593          	li	a1,40
 702:	bff1                	j	6de <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 704:	008b0913          	addi	s2,s6,8
 708:	000b4583          	lbu	a1,0(s6)
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	d98080e7          	jalr	-616(ra) # 4a6 <putc>
 716:	8b4a                	mv	s6,s2
            state = 0;
 718:	4981                	li	s3,0
 71a:	bd65                	j	5d2 <vprintf+0x60>
                putc(fd, c);
 71c:	85d2                	mv	a1,s4
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	d86080e7          	jalr	-634(ra) # 4a6 <putc>
            state = 0;
 728:	4981                	li	s3,0
 72a:	b565                	j	5d2 <vprintf+0x60>
                s = va_arg(ap, char *);
 72c:	8b4e                	mv	s6,s3
            state = 0;
 72e:	4981                	li	s3,0
 730:	b54d                	j	5d2 <vprintf+0x60>
        }
    }
}
 732:	70e6                	ld	ra,120(sp)
 734:	7446                	ld	s0,112(sp)
 736:	74a6                	ld	s1,104(sp)
 738:	7906                	ld	s2,96(sp)
 73a:	69e6                	ld	s3,88(sp)
 73c:	6a46                	ld	s4,80(sp)
 73e:	6aa6                	ld	s5,72(sp)
 740:	6b06                	ld	s6,64(sp)
 742:	7be2                	ld	s7,56(sp)
 744:	7c42                	ld	s8,48(sp)
 746:	7ca2                	ld	s9,40(sp)
 748:	7d02                	ld	s10,32(sp)
 74a:	6de2                	ld	s11,24(sp)
 74c:	6109                	addi	sp,sp,128
 74e:	8082                	ret

0000000000000750 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 750:	715d                	addi	sp,sp,-80
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e010                	sd	a2,0(s0)
 75a:	e414                	sd	a3,8(s0)
 75c:	e818                	sd	a4,16(s0)
 75e:	ec1c                	sd	a5,24(s0)
 760:	03043023          	sd	a6,32(s0)
 764:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 768:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 76c:	8622                	mv	a2,s0
 76e:	00000097          	auipc	ra,0x0
 772:	e04080e7          	jalr	-508(ra) # 572 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	00000097          	auipc	ra,0x0
 7a8:	dce080e7          	jalr	-562(ra) # 572 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e422                	sd	s0,8(sp)
 7b8:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 7ba:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	00000797          	auipc	a5,0x0
 7c2:	1fa7b783          	ld	a5,506(a5) # 9b8 <freep>
 7c6:	a805                	j	7f6 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 7c8:	4618                	lw	a4,8(a2)
 7ca:	9db9                	addw	a1,a1,a4
 7cc:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	6318                	ld	a4,0(a4)
 7d4:	fee53823          	sd	a4,-16(a0)
 7d8:	a091                	j	81c <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 7da:	ff852703          	lw	a4,-8(a0)
 7de:	9e39                	addw	a2,a2,a4
 7e0:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 7e2:	ff053703          	ld	a4,-16(a0)
 7e6:	e398                	sd	a4,0(a5)
 7e8:	a099                	j	82e <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e7e463          	bltu	a5,a4,7f4 <free+0x40>
 7f0:	00e6ea63          	bltu	a3,a4,804 <free+0x50>
{
 7f4:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	fed7fae3          	bgeu	a5,a3,7ea <free+0x36>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e6e463          	bltu	a3,a4,804 <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	fee7eae3          	bltu	a5,a4,7f4 <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 804:	ff852583          	lw	a1,-8(a0)
 808:	6390                	ld	a2,0(a5)
 80a:	02059713          	slli	a4,a1,0x20
 80e:	9301                	srli	a4,a4,0x20
 810:	0712                	slli	a4,a4,0x4
 812:	9736                	add	a4,a4,a3
 814:	fae60ae3          	beq	a2,a4,7c8 <free+0x14>
        bp->s.ptr = p->s.ptr;
 818:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 81c:	4790                	lw	a2,8(a5)
 81e:	02061713          	slli	a4,a2,0x20
 822:	9301                	srli	a4,a4,0x20
 824:	0712                	slli	a4,a4,0x4
 826:	973e                	add	a4,a4,a5
 828:	fae689e3          	beq	a3,a4,7da <free+0x26>
    }
    else
        p->s.ptr = bp;
 82c:	e394                	sd	a3,0(a5)
    freep = p;
 82e:	00000717          	auipc	a4,0x0
 832:	18f73523          	sd	a5,394(a4) # 9b8 <freep>
}
 836:	6422                	ld	s0,8(sp)
 838:	0141                	addi	sp,sp,16
 83a:	8082                	ret

000000000000083c <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 83c:	7139                	addi	sp,sp,-64
 83e:	fc06                	sd	ra,56(sp)
 840:	f822                	sd	s0,48(sp)
 842:	f426                	sd	s1,40(sp)
 844:	f04a                	sd	s2,32(sp)
 846:	ec4e                	sd	s3,24(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
 84e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 850:	02051493          	slli	s1,a0,0x20
 854:	9081                	srli	s1,s1,0x20
 856:	04bd                	addi	s1,s1,15
 858:	8091                	srli	s1,s1,0x4
 85a:	0014899b          	addiw	s3,s1,1
 85e:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 860:	00000517          	auipc	a0,0x0
 864:	15853503          	ld	a0,344(a0) # 9b8 <freep>
 868:	c515                	beqz	a0,894 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 86a:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 86c:	4798                	lw	a4,8(a5)
 86e:	02977f63          	bgeu	a4,s1,8ac <malloc+0x70>
 872:	8a4e                	mv	s4,s3
 874:	0009871b          	sext.w	a4,s3
 878:	6685                	lui	a3,0x1
 87a:	00d77363          	bgeu	a4,a3,880 <malloc+0x44>
 87e:	6a05                	lui	s4,0x1
 880:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 884:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 888:	00000917          	auipc	s2,0x0
 88c:	13090913          	addi	s2,s2,304 # 9b8 <freep>
    if (p == (char *)-1)
 890:	5afd                	li	s5,-1
 892:	a88d                	j	904 <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	12c78793          	addi	a5,a5,300 # 9c0 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	10f73e23          	sd	a5,284(a4) # 9b8 <freep>
 8a4:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 8aa:	b7e1                	j	872 <malloc+0x36>
            if (p->s.size == nunits)
 8ac:	02e48b63          	beq	s1,a4,8e2 <malloc+0xa6>
                p->s.size -= nunits;
 8b0:	4137073b          	subw	a4,a4,s3
 8b4:	c798                	sw	a4,8(a5)
                p += p->s.size;
 8b6:	1702                	slli	a4,a4,0x20
 8b8:	9301                	srli	a4,a4,0x20
 8ba:	0712                	slli	a4,a4,0x4
 8bc:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 8be:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 8c2:	00000717          	auipc	a4,0x0
 8c6:	0ea73b23          	sd	a0,246(a4) # 9b8 <freep>
            return (void *)(p + 1);
 8ca:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 8ce:	70e2                	ld	ra,56(sp)
 8d0:	7442                	ld	s0,48(sp)
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	7902                	ld	s2,32(sp)
 8d6:	69e2                	ld	s3,24(sp)
 8d8:	6a42                	ld	s4,16(sp)
 8da:	6aa2                	ld	s5,8(sp)
 8dc:	6b02                	ld	s6,0(sp)
 8de:	6121                	addi	sp,sp,64
 8e0:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 8e2:	6398                	ld	a4,0(a5)
 8e4:	e118                	sd	a4,0(a0)
 8e6:	bff1                	j	8c2 <malloc+0x86>
    hp->s.size = nu;
 8e8:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 8ec:	0541                	addi	a0,a0,16
 8ee:	00000097          	auipc	ra,0x0
 8f2:	ec6080e7          	jalr	-314(ra) # 7b4 <free>
    return freep;
 8f6:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 8fa:	d971                	beqz	a0,8ce <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 8fc:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 8fe:	4798                	lw	a4,8(a5)
 900:	fa9776e3          	bgeu	a4,s1,8ac <malloc+0x70>
        if (p == freep)
 904:	00093703          	ld	a4,0(s2)
 908:	853e                	mv	a0,a5
 90a:	fef719e3          	bne	a4,a5,8fc <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 90e:	8552                	mv	a0,s4
 910:	00000097          	auipc	ra,0x0
 914:	b3e080e7          	jalr	-1218(ra) # 44e <sbrk>
    if (p == (char *)-1)
 918:	fd5518e3          	bne	a0,s5,8e8 <malloc+0xac>
                return 0;
 91c:	4501                	li	a0,0
 91e:	bf45                	j	8ce <malloc+0x92>
