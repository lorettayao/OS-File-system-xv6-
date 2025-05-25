
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <perm_str>:
#include "kernel/fs.h"

//Loretta: add a perm_str

char* perm_str(short mode)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    static char str[3];
    str[0] = (mode & M_READ)  ? 'r' : '-';
   6:	03051793          	slli	a5,a0,0x30
   a:	93c1                	srli	a5,a5,0x30
   c:	8905                	andi	a0,a0,1
   e:	07200713          	li	a4,114
  12:	e119                	bnez	a0,18 <perm_str+0x18>
  14:	02d00713          	li	a4,45
  18:	00001697          	auipc	a3,0x1
  1c:	bce68823          	sb	a4,-1072(a3) # be8 <str.1>
    str[1] = (mode & M_WRITE) ? 'w' : '-';
  20:	8b89                	andi	a5,a5,2
  22:	07700713          	li	a4,119
  26:	e399                	bnez	a5,2c <perm_str+0x2c>
  28:	02d00713          	li	a4,45
  2c:	00001517          	auipc	a0,0x1
  30:	bbc50513          	addi	a0,a0,-1092 # be8 <str.1>
  34:	00e500a3          	sb	a4,1(a0)
    str[2] = '\0';
  38:	00050123          	sb	zero,2(a0)
    return str;
}
  3c:	6422                	ld	s0,8(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <fmtname>:


char *fmtname(char *path)
{
  42:	7179                	addi	sp,sp,-48
  44:	f406                	sd	ra,40(sp)
  46:	f022                	sd	s0,32(sp)
  48:	ec26                	sd	s1,24(sp)
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  4e:	1800                	addi	s0,sp,48
  50:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
  52:	00000097          	auipc	ra,0x0
  56:	380080e7          	jalr	896(ra) # 3d2 <strlen>
  5a:	02051793          	slli	a5,a0,0x20
  5e:	9381                	srli	a5,a5,0x20
  60:	97a6                	add	a5,a5,s1
  62:	02f00693          	li	a3,47
  66:	0097e963          	bltu	a5,s1,78 <fmtname+0x36>
  6a:	0007c703          	lbu	a4,0(a5)
  6e:	00d70563          	beq	a4,a3,78 <fmtname+0x36>
  72:	17fd                	addi	a5,a5,-1
  74:	fe97fbe3          	bgeu	a5,s1,6a <fmtname+0x28>
        ;
    p++;
  78:	00178493          	addi	s1,a5,1

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
  7c:	8526                	mv	a0,s1
  7e:	00000097          	auipc	ra,0x0
  82:	354080e7          	jalr	852(ra) # 3d2 <strlen>
  86:	2501                	sext.w	a0,a0
  88:	47b5                	li	a5,13
  8a:	00a7fa63          	bgeu	a5,a0,9e <fmtname+0x5c>
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
    return buf;
}
  8e:	8526                	mv	a0,s1
  90:	70a2                	ld	ra,40(sp)
  92:	7402                	ld	s0,32(sp)
  94:	64e2                	ld	s1,24(sp)
  96:	6942                	ld	s2,16(sp)
  98:	69a2                	ld	s3,8(sp)
  9a:	6145                	addi	sp,sp,48
  9c:	8082                	ret
    memmove(buf, p, strlen(p));
  9e:	8526                	mv	a0,s1
  a0:	00000097          	auipc	ra,0x0
  a4:	332080e7          	jalr	818(ra) # 3d2 <strlen>
  a8:	00001997          	auipc	s3,0x1
  ac:	b5098993          	addi	s3,s3,-1200 # bf8 <buf.0>
  b0:	0005061b          	sext.w	a2,a0
  b4:	85a6                	mv	a1,s1
  b6:	854e                	mv	a0,s3
  b8:	00000097          	auipc	ra,0x0
  bc:	48e080e7          	jalr	1166(ra) # 546 <memmove>
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  c0:	8526                	mv	a0,s1
  c2:	00000097          	auipc	ra,0x0
  c6:	310080e7          	jalr	784(ra) # 3d2 <strlen>
  ca:	0005091b          	sext.w	s2,a0
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	302080e7          	jalr	770(ra) # 3d2 <strlen>
  d8:	1902                	slli	s2,s2,0x20
  da:	02095913          	srli	s2,s2,0x20
  de:	4639                	li	a2,14
  e0:	9e09                	subw	a2,a2,a0
  e2:	02000593          	li	a1,32
  e6:	01298533          	add	a0,s3,s2
  ea:	00000097          	auipc	ra,0x0
  ee:	312080e7          	jalr	786(ra) # 3fc <memset>
    return buf;
  f2:	84ce                	mv	s1,s3
  f4:	bf69                	j	8e <fmtname+0x4c>

00000000000000f6 <ls>:

/* TODO: Access Control & Symbolic Link */
void ls(char *path)
{
  f6:	d7010113          	addi	sp,sp,-656
  fa:	28113423          	sd	ra,648(sp)
  fe:	28813023          	sd	s0,640(sp)
 102:	26913c23          	sd	s1,632(sp)
 106:	27213823          	sd	s2,624(sp)
 10a:	27313423          	sd	s3,616(sp)
 10e:	27413023          	sd	s4,608(sp)
 112:	25513c23          	sd	s5,600(sp)
 116:	25613823          	sd	s6,592(sp)
 11a:	25713423          	sd	s7,584(sp)
 11e:	25813023          	sd	s8,576(sp)
 122:	23913c23          	sd	s9,568(sp)
 126:	0d00                	addi	s0,sp,656
 128:	892a                	mv	s2,a0
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
 12a:	4581                	li	a1,0
 12c:	00000097          	auipc	ra,0x0
 130:	50c080e7          	jalr	1292(ra) # 638 <open>
 134:	0a054663          	bltz	a0,1e0 <ls+0xea>
 138:	84aa                	mv	s1,a0
    {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
 13a:	d7040593          	addi	a1,s0,-656
 13e:	00000097          	auipc	ra,0x0
 142:	512080e7          	jalr	1298(ra) # 650 <fstat>
 146:	0a054863          	bltz	a0,1f6 <ls+0x100>
        close(fd);
        return;
    }

    //Loretta
    if ((st.mode & M_READ) == 0) {
 14a:	d8845783          	lhu	a5,-632(s0)
 14e:	8b85                	andi	a5,a5,1
 150:	c3f9                	beqz	a5,216 <ls+0x120>
        fprintf(2, "ls: cannot open %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
 152:	d7841783          	lh	a5,-648(s0)
 156:	0007869b          	sext.w	a3,a5
 15a:	4705                	li	a4,1
 15c:	0ce68d63          	beq	a3,a4,236 <ls+0x140>
 160:	4709                	li	a4,2
 162:	04e69163          	bne	a3,a4,1a4 <ls+0xae>
    {
    case T_FILE:
        //Loretta 
        // printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
        printf("%s %d %d %l %s\n", fmtname(path), st.type, st.ino, st.size, perm_str(st.mode));
 166:	854a                	mv	a0,s2
 168:	00000097          	auipc	ra,0x0
 16c:	eda080e7          	jalr	-294(ra) # 42 <fmtname>
 170:	892a                	mv	s2,a0
 172:	d7841983          	lh	s3,-648(s0)
 176:	d7442a03          	lw	s4,-652(s0)
 17a:	d8043a83          	ld	s5,-640(s0)
 17e:	d8841503          	lh	a0,-632(s0)
 182:	00000097          	auipc	ra,0x0
 186:	e7e080e7          	jalr	-386(ra) # 0 <perm_str>
 18a:	87aa                	mv	a5,a0
 18c:	8756                	mv	a4,s5
 18e:	86d2                	mv	a3,s4
 190:	864e                	mv	a2,s3
 192:	85ca                	mv	a1,s2
 194:	00001517          	auipc	a0,0x1
 198:	9f450513          	addi	a0,a0,-1548 # b88 <malloc+0x11a>
 19c:	00001097          	auipc	ra,0x1
 1a0:	814080e7          	jalr	-2028(ra) # 9b0 <printf>

        }
        break;
    }

    close(fd);
 1a4:	8526                	mv	a0,s1
 1a6:	00000097          	auipc	ra,0x0
 1aa:	47a080e7          	jalr	1146(ra) # 620 <close>
}
 1ae:	28813083          	ld	ra,648(sp)
 1b2:	28013403          	ld	s0,640(sp)
 1b6:	27813483          	ld	s1,632(sp)
 1ba:	27013903          	ld	s2,624(sp)
 1be:	26813983          	ld	s3,616(sp)
 1c2:	26013a03          	ld	s4,608(sp)
 1c6:	25813a83          	ld	s5,600(sp)
 1ca:	25013b03          	ld	s6,592(sp)
 1ce:	24813b83          	ld	s7,584(sp)
 1d2:	24013c03          	ld	s8,576(sp)
 1d6:	23813c83          	ld	s9,568(sp)
 1da:	29010113          	addi	sp,sp,656
 1de:	8082                	ret
        fprintf(2, "ls: cannot open %s\n", path);
 1e0:	864a                	mv	a2,s2
 1e2:	00001597          	auipc	a1,0x1
 1e6:	97658593          	addi	a1,a1,-1674 # b58 <malloc+0xea>
 1ea:	4509                	li	a0,2
 1ec:	00000097          	auipc	ra,0x0
 1f0:	796080e7          	jalr	1942(ra) # 982 <fprintf>
        return;
 1f4:	bf6d                	j	1ae <ls+0xb8>
        fprintf(2, "ls: cannot stat %s\n", path);
 1f6:	864a                	mv	a2,s2
 1f8:	00001597          	auipc	a1,0x1
 1fc:	97858593          	addi	a1,a1,-1672 # b70 <malloc+0x102>
 200:	4509                	li	a0,2
 202:	00000097          	auipc	ra,0x0
 206:	780080e7          	jalr	1920(ra) # 982 <fprintf>
        close(fd);
 20a:	8526                	mv	a0,s1
 20c:	00000097          	auipc	ra,0x0
 210:	414080e7          	jalr	1044(ra) # 620 <close>
        return;
 214:	bf69                	j	1ae <ls+0xb8>
        fprintf(2, "ls: cannot open %s\n", path);
 216:	864a                	mv	a2,s2
 218:	00001597          	auipc	a1,0x1
 21c:	94058593          	addi	a1,a1,-1728 # b58 <malloc+0xea>
 220:	4509                	li	a0,2
 222:	00000097          	auipc	ra,0x0
 226:	760080e7          	jalr	1888(ra) # 982 <fprintf>
        close(fd);
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	3f4080e7          	jalr	1012(ra) # 620 <close>
        return;
 234:	bfad                	j	1ae <ls+0xb8>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 236:	854a                	mv	a0,s2
 238:	00000097          	auipc	ra,0x0
 23c:	19a080e7          	jalr	410(ra) # 3d2 <strlen>
 240:	2541                	addiw	a0,a0,16
 242:	20000793          	li	a5,512
 246:	00a7fb63          	bgeu	a5,a0,25c <ls+0x166>
            printf("ls: path too long\n");
 24a:	00001517          	auipc	a0,0x1
 24e:	94e50513          	addi	a0,a0,-1714 # b98 <malloc+0x12a>
 252:	00000097          	auipc	ra,0x0
 256:	75e080e7          	jalr	1886(ra) # 9b0 <printf>
            break;
 25a:	b7a9                	j	1a4 <ls+0xae>
        strcpy(buf, path);
 25c:	85ca                	mv	a1,s2
 25e:	da040513          	addi	a0,s0,-608
 262:	00000097          	auipc	ra,0x0
 266:	128080e7          	jalr	296(ra) # 38a <strcpy>
        p = buf + strlen(buf);
 26a:	da040513          	addi	a0,s0,-608
 26e:	00000097          	auipc	ra,0x0
 272:	164080e7          	jalr	356(ra) # 3d2 <strlen>
 276:	02051993          	slli	s3,a0,0x20
 27a:	0209d993          	srli	s3,s3,0x20
 27e:	da040793          	addi	a5,s0,-608
 282:	99be                	add	s3,s3,a5
        *p++ = '/';
 284:	00198a13          	addi	s4,s3,1
 288:	02f00793          	li	a5,47
 28c:	00f98023          	sb	a5,0(s3)
            printf("%s %d %d %d %s\n", fmtname(buf), st.type, st.ino, st.size, perm_str(st.mode));
 290:	00001a97          	auipc	s5,0x1
 294:	920a8a93          	addi	s5,s5,-1760 # bb0 <malloc+0x142>
                printf("ls: cannot stat %s\n", buf);
 298:	00001b17          	auipc	s6,0x1
 29c:	8d8b0b13          	addi	s6,s6,-1832 # b70 <malloc+0x102>
        while (read(fd, &de, sizeof(de)) == sizeof(de))
 2a0:	a801                	j	2b0 <ls+0x1ba>
                printf("ls: cannot stat %s\n", buf);
 2a2:	da040593          	addi	a1,s0,-608
 2a6:	855a                	mv	a0,s6
 2a8:	00000097          	auipc	ra,0x0
 2ac:	708080e7          	jalr	1800(ra) # 9b0 <printf>
        while (read(fd, &de, sizeof(de)) == sizeof(de))
 2b0:	4641                	li	a2,16
 2b2:	d9040593          	addi	a1,s0,-624
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	358080e7          	jalr	856(ra) # 610 <read>
 2c0:	47c1                	li	a5,16
 2c2:	eef511e3          	bne	a0,a5,1a4 <ls+0xae>
            if (de.inum == 0)
 2c6:	d9045783          	lhu	a5,-624(s0)
 2ca:	d3fd                	beqz	a5,2b0 <ls+0x1ba>
            memmove(p, de.name, DIRSIZ);
 2cc:	4639                	li	a2,14
 2ce:	d9240593          	addi	a1,s0,-622
 2d2:	8552                	mv	a0,s4
 2d4:	00000097          	auipc	ra,0x0
 2d8:	272080e7          	jalr	626(ra) # 546 <memmove>
            p[DIRSIZ] = 0;
 2dc:	000987a3          	sb	zero,15(s3)
            if (stat(buf, &st) < 0)
 2e0:	d7040593          	addi	a1,s0,-656
 2e4:	da040513          	addi	a0,s0,-608
 2e8:	00000097          	auipc	ra,0x0
 2ec:	1ce080e7          	jalr	462(ra) # 4b6 <stat>
 2f0:	fa0549e3          	bltz	a0,2a2 <ls+0x1ac>
            printf("%s %d %d %d %s\n", fmtname(buf), st.type, st.ino, st.size, perm_str(st.mode));
 2f4:	da040513          	addi	a0,s0,-608
 2f8:	00000097          	auipc	ra,0x0
 2fc:	d4a080e7          	jalr	-694(ra) # 42 <fmtname>
 300:	892a                	mv	s2,a0
 302:	d7841b83          	lh	s7,-648(s0)
 306:	d7442c03          	lw	s8,-652(s0)
 30a:	d8043c83          	ld	s9,-640(s0)
 30e:	d8841503          	lh	a0,-632(s0)
 312:	00000097          	auipc	ra,0x0
 316:	cee080e7          	jalr	-786(ra) # 0 <perm_str>
 31a:	87aa                	mv	a5,a0
 31c:	8766                	mv	a4,s9
 31e:	86e2                	mv	a3,s8
 320:	865e                	mv	a2,s7
 322:	85ca                	mv	a1,s2
 324:	8556                	mv	a0,s5
 326:	00000097          	auipc	ra,0x0
 32a:	68a080e7          	jalr	1674(ra) # 9b0 <printf>
 32e:	b749                	j	2b0 <ls+0x1ba>

0000000000000330 <main>:

int main(int argc, char *argv[])
{
 330:	1101                	addi	sp,sp,-32
 332:	ec06                	sd	ra,24(sp)
 334:	e822                	sd	s0,16(sp)
 336:	e426                	sd	s1,8(sp)
 338:	e04a                	sd	s2,0(sp)
 33a:	1000                	addi	s0,sp,32
    int i;

    if (argc < 2)
 33c:	4785                	li	a5,1
 33e:	02a7d963          	bge	a5,a0,370 <main+0x40>
 342:	00858493          	addi	s1,a1,8
 346:	ffe5091b          	addiw	s2,a0,-2
 34a:	1902                	slli	s2,s2,0x20
 34c:	02095913          	srli	s2,s2,0x20
 350:	090e                	slli	s2,s2,0x3
 352:	05c1                	addi	a1,a1,16
 354:	992e                	add	s2,s2,a1
    {
        ls(".");
        exit(0);
    }
    for (i = 1; i < argc; i++)
        ls(argv[i]);
 356:	6088                	ld	a0,0(s1)
 358:	00000097          	auipc	ra,0x0
 35c:	d9e080e7          	jalr	-610(ra) # f6 <ls>
    for (i = 1; i < argc; i++)
 360:	04a1                	addi	s1,s1,8
 362:	ff249ae3          	bne	s1,s2,356 <main+0x26>
    exit(0);
 366:	4501                	li	a0,0
 368:	00000097          	auipc	ra,0x0
 36c:	290080e7          	jalr	656(ra) # 5f8 <exit>
        ls(".");
 370:	00001517          	auipc	a0,0x1
 374:	85050513          	addi	a0,a0,-1968 # bc0 <malloc+0x152>
 378:	00000097          	auipc	ra,0x0
 37c:	d7e080e7          	jalr	-642(ra) # f6 <ls>
        exit(0);
 380:	4501                	li	a0,0
 382:	00000097          	auipc	ra,0x0
 386:	276080e7          	jalr	630(ra) # 5f8 <exit>

000000000000038a <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 390:	87aa                	mv	a5,a0
 392:	0585                	addi	a1,a1,1
 394:	0785                	addi	a5,a5,1
 396:	fff5c703          	lbu	a4,-1(a1)
 39a:	fee78fa3          	sb	a4,-1(a5)
 39e:	fb75                	bnez	a4,392 <strcpy+0x8>
        ;
    return os;
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <strcmp>:

int strcmp(const char *p, const char *q)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	cb91                	beqz	a5,3c4 <strcmp+0x1e>
 3b2:	0005c703          	lbu	a4,0(a1)
 3b6:	00f71763          	bne	a4,a5,3c4 <strcmp+0x1e>
        p++, q++;
 3ba:	0505                	addi	a0,a0,1
 3bc:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 3be:	00054783          	lbu	a5,0(a0)
 3c2:	fbe5                	bnez	a5,3b2 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 3c4:	0005c503          	lbu	a0,0(a1)
}
 3c8:	40a7853b          	subw	a0,a5,a0
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <strlen>:

uint strlen(const char *s)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 3d8:	00054783          	lbu	a5,0(a0)
 3dc:	cf91                	beqz	a5,3f8 <strlen+0x26>
 3de:	0505                	addi	a0,a0,1
 3e0:	87aa                	mv	a5,a0
 3e2:	4685                	li	a3,1
 3e4:	9e89                	subw	a3,a3,a0
 3e6:	00f6853b          	addw	a0,a3,a5
 3ea:	0785                	addi	a5,a5,1
 3ec:	fff7c703          	lbu	a4,-1(a5)
 3f0:	fb7d                	bnez	a4,3e6 <strlen+0x14>
        ;
    return n;
}
 3f2:	6422                	ld	s0,8(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret
    for (n = 0; s[n]; n++)
 3f8:	4501                	li	a0,0
 3fa:	bfe5                	j	3f2 <strlen+0x20>

00000000000003fc <memset>:

void *memset(void *dst, int c, uint n)
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e422                	sd	s0,8(sp)
 400:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 402:	ca19                	beqz	a2,418 <memset+0x1c>
 404:	87aa                	mv	a5,a0
 406:	1602                	slli	a2,a2,0x20
 408:	9201                	srli	a2,a2,0x20
 40a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 40e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 412:	0785                	addi	a5,a5,1
 414:	fee79de3          	bne	a5,a4,40e <memset+0x12>
    }
    return dst;
}
 418:	6422                	ld	s0,8(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret

000000000000041e <strchr>:

char *strchr(const char *s, char c)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
    for (; *s; s++)
 424:	00054783          	lbu	a5,0(a0)
 428:	cb99                	beqz	a5,43e <strchr+0x20>
        if (*s == c)
 42a:	00f58763          	beq	a1,a5,438 <strchr+0x1a>
    for (; *s; s++)
 42e:	0505                	addi	a0,a0,1
 430:	00054783          	lbu	a5,0(a0)
 434:	fbfd                	bnez	a5,42a <strchr+0xc>
            return (char *)s;
    return 0;
 436:	4501                	li	a0,0
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret
    return 0;
 43e:	4501                	li	a0,0
 440:	bfe5                	j	438 <strchr+0x1a>

0000000000000442 <gets>:

char *gets(char *buf, int max)
{
 442:	711d                	addi	sp,sp,-96
 444:	ec86                	sd	ra,88(sp)
 446:	e8a2                	sd	s0,80(sp)
 448:	e4a6                	sd	s1,72(sp)
 44a:	e0ca                	sd	s2,64(sp)
 44c:	fc4e                	sd	s3,56(sp)
 44e:	f852                	sd	s4,48(sp)
 450:	f456                	sd	s5,40(sp)
 452:	f05a                	sd	s6,32(sp)
 454:	ec5e                	sd	s7,24(sp)
 456:	1080                	addi	s0,sp,96
 458:	8baa                	mv	s7,a0
 45a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 45c:	892a                	mv	s2,a0
 45e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 460:	4aa9                	li	s5,10
 462:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 464:	89a6                	mv	s3,s1
 466:	2485                	addiw	s1,s1,1
 468:	0344d863          	bge	s1,s4,498 <gets+0x56>
        cc = read(0, &c, 1);
 46c:	4605                	li	a2,1
 46e:	faf40593          	addi	a1,s0,-81
 472:	4501                	li	a0,0
 474:	00000097          	auipc	ra,0x0
 478:	19c080e7          	jalr	412(ra) # 610 <read>
        if (cc < 1)
 47c:	00a05e63          	blez	a0,498 <gets+0x56>
        buf[i++] = c;
 480:	faf44783          	lbu	a5,-81(s0)
 484:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 488:	01578763          	beq	a5,s5,496 <gets+0x54>
 48c:	0905                	addi	s2,s2,1
 48e:	fd679be3          	bne	a5,s6,464 <gets+0x22>
    for (i = 0; i + 1 < max;)
 492:	89a6                	mv	s3,s1
 494:	a011                	j	498 <gets+0x56>
 496:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 498:	99de                	add	s3,s3,s7
 49a:	00098023          	sb	zero,0(s3)
    return buf;
}
 49e:	855e                	mv	a0,s7
 4a0:	60e6                	ld	ra,88(sp)
 4a2:	6446                	ld	s0,80(sp)
 4a4:	64a6                	ld	s1,72(sp)
 4a6:	6906                	ld	s2,64(sp)
 4a8:	79e2                	ld	s3,56(sp)
 4aa:	7a42                	ld	s4,48(sp)
 4ac:	7aa2                	ld	s5,40(sp)
 4ae:	7b02                	ld	s6,32(sp)
 4b0:	6be2                	ld	s7,24(sp)
 4b2:	6125                	addi	sp,sp,96
 4b4:	8082                	ret

00000000000004b6 <stat>:

int stat(const char *n, struct stat *st)
{
 4b6:	1101                	addi	sp,sp,-32
 4b8:	ec06                	sd	ra,24(sp)
 4ba:	e822                	sd	s0,16(sp)
 4bc:	e426                	sd	s1,8(sp)
 4be:	e04a                	sd	s2,0(sp)
 4c0:	1000                	addi	s0,sp,32
 4c2:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 4c4:	4581                	li	a1,0
 4c6:	00000097          	auipc	ra,0x0
 4ca:	172080e7          	jalr	370(ra) # 638 <open>
    if (fd < 0)
 4ce:	02054563          	bltz	a0,4f8 <stat+0x42>
 4d2:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 4d4:	85ca                	mv	a1,s2
 4d6:	00000097          	auipc	ra,0x0
 4da:	17a080e7          	jalr	378(ra) # 650 <fstat>
 4de:	892a                	mv	s2,a0
    close(fd);
 4e0:	8526                	mv	a0,s1
 4e2:	00000097          	auipc	ra,0x0
 4e6:	13e080e7          	jalr	318(ra) # 620 <close>
    return r;
}
 4ea:	854a                	mv	a0,s2
 4ec:	60e2                	ld	ra,24(sp)
 4ee:	6442                	ld	s0,16(sp)
 4f0:	64a2                	ld	s1,8(sp)
 4f2:	6902                	ld	s2,0(sp)
 4f4:	6105                	addi	sp,sp,32
 4f6:	8082                	ret
        return -1;
 4f8:	597d                	li	s2,-1
 4fa:	bfc5                	j	4ea <stat+0x34>

00000000000004fc <atoi>:

int atoi(const char *s)
{
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e422                	sd	s0,8(sp)
 500:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 502:	00054603          	lbu	a2,0(a0)
 506:	fd06079b          	addiw	a5,a2,-48
 50a:	0ff7f793          	andi	a5,a5,255
 50e:	4725                	li	a4,9
 510:	02f76963          	bltu	a4,a5,542 <atoi+0x46>
 514:	86aa                	mv	a3,a0
    n = 0;
 516:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 518:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 51a:	0685                	addi	a3,a3,1
 51c:	0025179b          	slliw	a5,a0,0x2
 520:	9fa9                	addw	a5,a5,a0
 522:	0017979b          	slliw	a5,a5,0x1
 526:	9fb1                	addw	a5,a5,a2
 528:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 52c:	0006c603          	lbu	a2,0(a3)
 530:	fd06071b          	addiw	a4,a2,-48
 534:	0ff77713          	andi	a4,a4,255
 538:	fee5f1e3          	bgeu	a1,a4,51a <atoi+0x1e>
    return n;
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
    n = 0;
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <atoi+0x40>

0000000000000546 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 546:	1141                	addi	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 54c:	02b57463          	bgeu	a0,a1,574 <memmove+0x2e>
    {
        while (n-- > 0)
 550:	00c05f63          	blez	a2,56e <memmove+0x28>
 554:	1602                	slli	a2,a2,0x20
 556:	9201                	srli	a2,a2,0x20
 558:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 55c:	872a                	mv	a4,a0
            *dst++ = *src++;
 55e:	0585                	addi	a1,a1,1
 560:	0705                	addi	a4,a4,1
 562:	fff5c683          	lbu	a3,-1(a1)
 566:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 56a:	fee79ae3          	bne	a5,a4,55e <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 56e:	6422                	ld	s0,8(sp)
 570:	0141                	addi	sp,sp,16
 572:	8082                	ret
        dst += n;
 574:	00c50733          	add	a4,a0,a2
        src += n;
 578:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 57a:	fec05ae3          	blez	a2,56e <memmove+0x28>
 57e:	fff6079b          	addiw	a5,a2,-1
 582:	1782                	slli	a5,a5,0x20
 584:	9381                	srli	a5,a5,0x20
 586:	fff7c793          	not	a5,a5
 58a:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 58c:	15fd                	addi	a1,a1,-1
 58e:	177d                	addi	a4,a4,-1
 590:	0005c683          	lbu	a3,0(a1)
 594:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 598:	fee79ae3          	bne	a5,a4,58c <memmove+0x46>
 59c:	bfc9                	j	56e <memmove+0x28>

000000000000059e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 59e:	1141                	addi	sp,sp,-16
 5a0:	e422                	sd	s0,8(sp)
 5a2:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 5a4:	ca05                	beqz	a2,5d4 <memcmp+0x36>
 5a6:	fff6069b          	addiw	a3,a2,-1
 5aa:	1682                	slli	a3,a3,0x20
 5ac:	9281                	srli	a3,a3,0x20
 5ae:	0685                	addi	a3,a3,1
 5b0:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 5b2:	00054783          	lbu	a5,0(a0)
 5b6:	0005c703          	lbu	a4,0(a1)
 5ba:	00e79863          	bne	a5,a4,5ca <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 5be:	0505                	addi	a0,a0,1
        p2++;
 5c0:	0585                	addi	a1,a1,1
    while (n-- > 0)
 5c2:	fed518e3          	bne	a0,a3,5b2 <memcmp+0x14>
    }
    return 0;
 5c6:	4501                	li	a0,0
 5c8:	a019                	j	5ce <memcmp+0x30>
            return *p1 - *p2;
 5ca:	40e7853b          	subw	a0,a5,a4
}
 5ce:	6422                	ld	s0,8(sp)
 5d0:	0141                	addi	sp,sp,16
 5d2:	8082                	ret
    return 0;
 5d4:	4501                	li	a0,0
 5d6:	bfe5                	j	5ce <memcmp+0x30>

00000000000005d8 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 5d8:	1141                	addi	sp,sp,-16
 5da:	e406                	sd	ra,8(sp)
 5dc:	e022                	sd	s0,0(sp)
 5de:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 5e0:	00000097          	auipc	ra,0x0
 5e4:	f66080e7          	jalr	-154(ra) # 546 <memmove>
}
 5e8:	60a2                	ld	ra,8(sp)
 5ea:	6402                	ld	s0,0(sp)
 5ec:	0141                	addi	sp,sp,16
 5ee:	8082                	ret

00000000000005f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5f0:	4885                	li	a7,1
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5f8:	4889                	li	a7,2
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <wait>:
.global wait
wait:
 li a7, SYS_wait
 600:	488d                	li	a7,3
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 608:	4891                	li	a7,4
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <read>:
.global read
read:
 li a7, SYS_read
 610:	4895                	li	a7,5
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <write>:
.global write
write:
 li a7, SYS_write
 618:	48c1                	li	a7,16
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <close>:
.global close
close:
 li a7, SYS_close
 620:	48d5                	li	a7,21
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <kill>:
.global kill
kill:
 li a7, SYS_kill
 628:	4899                	li	a7,6
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <exec>:
.global exec
exec:
 li a7, SYS_exec
 630:	489d                	li	a7,7
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <open>:
.global open
open:
 li a7, SYS_open
 638:	48bd                	li	a7,15
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 640:	48c5                	li	a7,17
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 648:	48c9                	li	a7,18
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 650:	48a1                	li	a7,8
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <link>:
.global link
link:
 li a7, SYS_link
 658:	48cd                	li	a7,19
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 660:	48d1                	li	a7,20
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 668:	48a5                	li	a7,9
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <dup>:
.global dup
dup:
 li a7, SYS_dup
 670:	48a9                	li	a7,10
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 678:	48ad                	li	a7,11
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 680:	48b1                	li	a7,12
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 688:	48b5                	li	a7,13
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 690:	48b9                	li	a7,14
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 698:	48d9                	li	a7,22
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 6a0:	48dd                	li	a7,23
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 6a8:	48e1                	li	a7,24
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 6b0:	48e5                	li	a7,25
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 6b8:	48e9                	li	a7,26
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 6c0:	48ed                	li	a7,27
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 6c8:	48f5                	li	a7,29
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 6d0:	48f1                	li	a7,28
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 6d8:	1101                	addi	sp,sp,-32
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	feb407a3          	sb	a1,-17(s0)
 6e4:	4605                	li	a2,1
 6e6:	fef40593          	addi	a1,s0,-17
 6ea:	00000097          	auipc	ra,0x0
 6ee:	f2e080e7          	jalr	-210(ra) # 618 <write>
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6105                	addi	sp,sp,32
 6f8:	8082                	ret

00000000000006fa <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 6fa:	7139                	addi	sp,sp,-64
 6fc:	fc06                	sd	ra,56(sp)
 6fe:	f822                	sd	s0,48(sp)
 700:	f426                	sd	s1,40(sp)
 702:	f04a                	sd	s2,32(sp)
 704:	ec4e                	sd	s3,24(sp)
 706:	0080                	addi	s0,sp,64
 708:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 70a:	c299                	beqz	a3,710 <printint+0x16>
 70c:	0805c863          	bltz	a1,79c <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 710:	2581                	sext.w	a1,a1
    neg = 0;
 712:	4881                	li	a7,0
 714:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 718:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 71a:	2601                	sext.w	a2,a2
 71c:	00000517          	auipc	a0,0x0
 720:	4b450513          	addi	a0,a0,1204 # bd0 <digits>
 724:	883a                	mv	a6,a4
 726:	2705                	addiw	a4,a4,1
 728:	02c5f7bb          	remuw	a5,a1,a2
 72c:	1782                	slli	a5,a5,0x20
 72e:	9381                	srli	a5,a5,0x20
 730:	97aa                	add	a5,a5,a0
 732:	0007c783          	lbu	a5,0(a5)
 736:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 73a:	0005879b          	sext.w	a5,a1
 73e:	02c5d5bb          	divuw	a1,a1,a2
 742:	0685                	addi	a3,a3,1
 744:	fec7f0e3          	bgeu	a5,a2,724 <printint+0x2a>
    if (neg)
 748:	00088b63          	beqz	a7,75e <printint+0x64>
        buf[i++] = '-';
 74c:	fd040793          	addi	a5,s0,-48
 750:	973e                	add	a4,a4,a5
 752:	02d00793          	li	a5,45
 756:	fef70823          	sb	a5,-16(a4)
 75a:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 75e:	02e05863          	blez	a4,78e <printint+0x94>
 762:	fc040793          	addi	a5,s0,-64
 766:	00e78933          	add	s2,a5,a4
 76a:	fff78993          	addi	s3,a5,-1
 76e:	99ba                	add	s3,s3,a4
 770:	377d                	addiw	a4,a4,-1
 772:	1702                	slli	a4,a4,0x20
 774:	9301                	srli	a4,a4,0x20
 776:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 77a:	fff94583          	lbu	a1,-1(s2)
 77e:	8526                	mv	a0,s1
 780:	00000097          	auipc	ra,0x0
 784:	f58080e7          	jalr	-168(ra) # 6d8 <putc>
    while (--i >= 0)
 788:	197d                	addi	s2,s2,-1
 78a:	ff3918e3          	bne	s2,s3,77a <printint+0x80>
}
 78e:	70e2                	ld	ra,56(sp)
 790:	7442                	ld	s0,48(sp)
 792:	74a2                	ld	s1,40(sp)
 794:	7902                	ld	s2,32(sp)
 796:	69e2                	ld	s3,24(sp)
 798:	6121                	addi	sp,sp,64
 79a:	8082                	ret
        x = -xx;
 79c:	40b005bb          	negw	a1,a1
        neg = 1;
 7a0:	4885                	li	a7,1
        x = -xx;
 7a2:	bf8d                	j	714 <printint+0x1a>

00000000000007a4 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 7a4:	7119                	addi	sp,sp,-128
 7a6:	fc86                	sd	ra,120(sp)
 7a8:	f8a2                	sd	s0,112(sp)
 7aa:	f4a6                	sd	s1,104(sp)
 7ac:	f0ca                	sd	s2,96(sp)
 7ae:	ecce                	sd	s3,88(sp)
 7b0:	e8d2                	sd	s4,80(sp)
 7b2:	e4d6                	sd	s5,72(sp)
 7b4:	e0da                	sd	s6,64(sp)
 7b6:	fc5e                	sd	s7,56(sp)
 7b8:	f862                	sd	s8,48(sp)
 7ba:	f466                	sd	s9,40(sp)
 7bc:	f06a                	sd	s10,32(sp)
 7be:	ec6e                	sd	s11,24(sp)
 7c0:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 7c2:	0005c903          	lbu	s2,0(a1)
 7c6:	18090f63          	beqz	s2,964 <vprintf+0x1c0>
 7ca:	8aaa                	mv	s5,a0
 7cc:	8b32                	mv	s6,a2
 7ce:	00158493          	addi	s1,a1,1
    state = 0;
 7d2:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 7d4:	02500a13          	li	s4,37
        {
            if (c == 'd')
 7d8:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 7dc:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 7e0:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 7e4:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e8:	00000b97          	auipc	s7,0x0
 7ec:	3e8b8b93          	addi	s7,s7,1000 # bd0 <digits>
 7f0:	a839                	j	80e <vprintf+0x6a>
                putc(fd, c);
 7f2:	85ca                	mv	a1,s2
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	ee2080e7          	jalr	-286(ra) # 6d8 <putc>
 7fe:	a019                	j	804 <vprintf+0x60>
        else if (state == '%')
 800:	01498f63          	beq	s3,s4,81e <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 804:	0485                	addi	s1,s1,1
 806:	fff4c903          	lbu	s2,-1(s1)
 80a:	14090d63          	beqz	s2,964 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 80e:	0009079b          	sext.w	a5,s2
        if (state == 0)
 812:	fe0997e3          	bnez	s3,800 <vprintf+0x5c>
            if (c == '%')
 816:	fd479ee3          	bne	a5,s4,7f2 <vprintf+0x4e>
                state = '%';
 81a:	89be                	mv	s3,a5
 81c:	b7e5                	j	804 <vprintf+0x60>
            if (c == 'd')
 81e:	05878063          	beq	a5,s8,85e <vprintf+0xba>
            else if (c == 'l')
 822:	05978c63          	beq	a5,s9,87a <vprintf+0xd6>
            else if (c == 'x')
 826:	07a78863          	beq	a5,s10,896 <vprintf+0xf2>
            else if (c == 'p')
 82a:	09b78463          	beq	a5,s11,8b2 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 82e:	07300713          	li	a4,115
 832:	0ce78663          	beq	a5,a4,8fe <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 836:	06300713          	li	a4,99
 83a:	0ee78e63          	beq	a5,a4,936 <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 83e:	11478863          	beq	a5,s4,94e <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 842:	85d2                	mv	a1,s4
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	e92080e7          	jalr	-366(ra) # 6d8 <putc>
                putc(fd, c);
 84e:	85ca                	mv	a1,s2
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	e86080e7          	jalr	-378(ra) # 6d8 <putc>
            }
            state = 0;
 85a:	4981                	li	s3,0
 85c:	b765                	j	804 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 85e:	008b0913          	addi	s2,s6,8
 862:	4685                	li	a3,1
 864:	4629                	li	a2,10
 866:	000b2583          	lw	a1,0(s6)
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	e8e080e7          	jalr	-370(ra) # 6fa <printint>
 874:	8b4a                	mv	s6,s2
            state = 0;
 876:	4981                	li	s3,0
 878:	b771                	j	804 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 87a:	008b0913          	addi	s2,s6,8
 87e:	4681                	li	a3,0
 880:	4629                	li	a2,10
 882:	000b2583          	lw	a1,0(s6)
 886:	8556                	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	e72080e7          	jalr	-398(ra) # 6fa <printint>
 890:	8b4a                	mv	s6,s2
            state = 0;
 892:	4981                	li	s3,0
 894:	bf85                	j	804 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 896:	008b0913          	addi	s2,s6,8
 89a:	4681                	li	a3,0
 89c:	4641                	li	a2,16
 89e:	000b2583          	lw	a1,0(s6)
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	e56080e7          	jalr	-426(ra) # 6fa <printint>
 8ac:	8b4a                	mv	s6,s2
            state = 0;
 8ae:	4981                	li	s3,0
 8b0:	bf91                	j	804 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 8b2:	008b0793          	addi	a5,s6,8
 8b6:	f8f43423          	sd	a5,-120(s0)
 8ba:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 8be:	03000593          	li	a1,48
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	e14080e7          	jalr	-492(ra) # 6d8 <putc>
    putc(fd, 'x');
 8cc:	85ea                	mv	a1,s10
 8ce:	8556                	mv	a0,s5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	e08080e7          	jalr	-504(ra) # 6d8 <putc>
 8d8:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8da:	03c9d793          	srli	a5,s3,0x3c
 8de:	97de                	add	a5,a5,s7
 8e0:	0007c583          	lbu	a1,0(a5)
 8e4:	8556                	mv	a0,s5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	df2080e7          	jalr	-526(ra) # 6d8 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ee:	0992                	slli	s3,s3,0x4
 8f0:	397d                	addiw	s2,s2,-1
 8f2:	fe0914e3          	bnez	s2,8da <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 8f6:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 8fa:	4981                	li	s3,0
 8fc:	b721                	j	804 <vprintf+0x60>
                s = va_arg(ap, char *);
 8fe:	008b0993          	addi	s3,s6,8
 902:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 906:	02090163          	beqz	s2,928 <vprintf+0x184>
                while (*s != 0)
 90a:	00094583          	lbu	a1,0(s2)
 90e:	c9a1                	beqz	a1,95e <vprintf+0x1ba>
                    putc(fd, *s);
 910:	8556                	mv	a0,s5
 912:	00000097          	auipc	ra,0x0
 916:	dc6080e7          	jalr	-570(ra) # 6d8 <putc>
                    s++;
 91a:	0905                	addi	s2,s2,1
                while (*s != 0)
 91c:	00094583          	lbu	a1,0(s2)
 920:	f9e5                	bnez	a1,910 <vprintf+0x16c>
                s = va_arg(ap, char *);
 922:	8b4e                	mv	s6,s3
            state = 0;
 924:	4981                	li	s3,0
 926:	bdf9                	j	804 <vprintf+0x60>
                    s = "(null)";
 928:	00000917          	auipc	s2,0x0
 92c:	2a090913          	addi	s2,s2,672 # bc8 <malloc+0x15a>
                while (*s != 0)
 930:	02800593          	li	a1,40
 934:	bff1                	j	910 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 936:	008b0913          	addi	s2,s6,8
 93a:	000b4583          	lbu	a1,0(s6)
 93e:	8556                	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	d98080e7          	jalr	-616(ra) # 6d8 <putc>
 948:	8b4a                	mv	s6,s2
            state = 0;
 94a:	4981                	li	s3,0
 94c:	bd65                	j	804 <vprintf+0x60>
                putc(fd, c);
 94e:	85d2                	mv	a1,s4
 950:	8556                	mv	a0,s5
 952:	00000097          	auipc	ra,0x0
 956:	d86080e7          	jalr	-634(ra) # 6d8 <putc>
            state = 0;
 95a:	4981                	li	s3,0
 95c:	b565                	j	804 <vprintf+0x60>
                s = va_arg(ap, char *);
 95e:	8b4e                	mv	s6,s3
            state = 0;
 960:	4981                	li	s3,0
 962:	b54d                	j	804 <vprintf+0x60>
        }
    }
}
 964:	70e6                	ld	ra,120(sp)
 966:	7446                	ld	s0,112(sp)
 968:	74a6                	ld	s1,104(sp)
 96a:	7906                	ld	s2,96(sp)
 96c:	69e6                	ld	s3,88(sp)
 96e:	6a46                	ld	s4,80(sp)
 970:	6aa6                	ld	s5,72(sp)
 972:	6b06                	ld	s6,64(sp)
 974:	7be2                	ld	s7,56(sp)
 976:	7c42                	ld	s8,48(sp)
 978:	7ca2                	ld	s9,40(sp)
 97a:	7d02                	ld	s10,32(sp)
 97c:	6de2                	ld	s11,24(sp)
 97e:	6109                	addi	sp,sp,128
 980:	8082                	ret

0000000000000982 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 982:	715d                	addi	sp,sp,-80
 984:	ec06                	sd	ra,24(sp)
 986:	e822                	sd	s0,16(sp)
 988:	1000                	addi	s0,sp,32
 98a:	e010                	sd	a2,0(s0)
 98c:	e414                	sd	a3,8(s0)
 98e:	e818                	sd	a4,16(s0)
 990:	ec1c                	sd	a5,24(s0)
 992:	03043023          	sd	a6,32(s0)
 996:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 99a:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 99e:	8622                	mv	a2,s0
 9a0:	00000097          	auipc	ra,0x0
 9a4:	e04080e7          	jalr	-508(ra) # 7a4 <vprintf>
}
 9a8:	60e2                	ld	ra,24(sp)
 9aa:	6442                	ld	s0,16(sp)
 9ac:	6161                	addi	sp,sp,80
 9ae:	8082                	ret

00000000000009b0 <printf>:

void printf(const char *fmt, ...)
{
 9b0:	711d                	addi	sp,sp,-96
 9b2:	ec06                	sd	ra,24(sp)
 9b4:	e822                	sd	s0,16(sp)
 9b6:	1000                	addi	s0,sp,32
 9b8:	e40c                	sd	a1,8(s0)
 9ba:	e810                	sd	a2,16(s0)
 9bc:	ec14                	sd	a3,24(s0)
 9be:	f018                	sd	a4,32(s0)
 9c0:	f41c                	sd	a5,40(s0)
 9c2:	03043823          	sd	a6,48(s0)
 9c6:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 9ca:	00840613          	addi	a2,s0,8
 9ce:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 9d2:	85aa                	mv	a1,a0
 9d4:	4505                	li	a0,1
 9d6:	00000097          	auipc	ra,0x0
 9da:	dce080e7          	jalr	-562(ra) # 7a4 <vprintf>
}
 9de:	60e2                	ld	ra,24(sp)
 9e0:	6442                	ld	s0,16(sp)
 9e2:	6125                	addi	sp,sp,96
 9e4:	8082                	ret

00000000000009e6 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 9e6:	1141                	addi	sp,sp,-16
 9e8:	e422                	sd	s0,8(sp)
 9ea:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 9ec:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f0:	00000797          	auipc	a5,0x0
 9f4:	2007b783          	ld	a5,512(a5) # bf0 <freep>
 9f8:	a805                	j	a28 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 9fa:	4618                	lw	a4,8(a2)
 9fc:	9db9                	addw	a1,a1,a4
 9fe:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 a02:	6398                	ld	a4,0(a5)
 a04:	6318                	ld	a4,0(a4)
 a06:	fee53823          	sd	a4,-16(a0)
 a0a:	a091                	j	a4e <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 a0c:	ff852703          	lw	a4,-8(a0)
 a10:	9e39                	addw	a2,a2,a4
 a12:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 a14:	ff053703          	ld	a4,-16(a0)
 a18:	e398                	sd	a4,0(a5)
 a1a:	a099                	j	a60 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a1c:	6398                	ld	a4,0(a5)
 a1e:	00e7e463          	bltu	a5,a4,a26 <free+0x40>
 a22:	00e6ea63          	bltu	a3,a4,a36 <free+0x50>
{
 a26:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a28:	fed7fae3          	bgeu	a5,a3,a1c <free+0x36>
 a2c:	6398                	ld	a4,0(a5)
 a2e:	00e6e463          	bltu	a3,a4,a36 <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a32:	fee7eae3          	bltu	a5,a4,a26 <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 a36:	ff852583          	lw	a1,-8(a0)
 a3a:	6390                	ld	a2,0(a5)
 a3c:	02059713          	slli	a4,a1,0x20
 a40:	9301                	srli	a4,a4,0x20
 a42:	0712                	slli	a4,a4,0x4
 a44:	9736                	add	a4,a4,a3
 a46:	fae60ae3          	beq	a2,a4,9fa <free+0x14>
        bp->s.ptr = p->s.ptr;
 a4a:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 a4e:	4790                	lw	a2,8(a5)
 a50:	02061713          	slli	a4,a2,0x20
 a54:	9301                	srli	a4,a4,0x20
 a56:	0712                	slli	a4,a4,0x4
 a58:	973e                	add	a4,a4,a5
 a5a:	fae689e3          	beq	a3,a4,a0c <free+0x26>
    }
    else
        p->s.ptr = bp;
 a5e:	e394                	sd	a3,0(a5)
    freep = p;
 a60:	00000717          	auipc	a4,0x0
 a64:	18f73823          	sd	a5,400(a4) # bf0 <freep>
}
 a68:	6422                	ld	s0,8(sp)
 a6a:	0141                	addi	sp,sp,16
 a6c:	8082                	ret

0000000000000a6e <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 a6e:	7139                	addi	sp,sp,-64
 a70:	fc06                	sd	ra,56(sp)
 a72:	f822                	sd	s0,48(sp)
 a74:	f426                	sd	s1,40(sp)
 a76:	f04a                	sd	s2,32(sp)
 a78:	ec4e                	sd	s3,24(sp)
 a7a:	e852                	sd	s4,16(sp)
 a7c:	e456                	sd	s5,8(sp)
 a7e:	e05a                	sd	s6,0(sp)
 a80:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a82:	02051493          	slli	s1,a0,0x20
 a86:	9081                	srli	s1,s1,0x20
 a88:	04bd                	addi	s1,s1,15
 a8a:	8091                	srli	s1,s1,0x4
 a8c:	0014899b          	addiw	s3,s1,1
 a90:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 a92:	00000517          	auipc	a0,0x0
 a96:	15e53503          	ld	a0,350(a0) # bf0 <freep>
 a9a:	c515                	beqz	a0,ac6 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a9c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 a9e:	4798                	lw	a4,8(a5)
 aa0:	02977f63          	bgeu	a4,s1,ade <malloc+0x70>
 aa4:	8a4e                	mv	s4,s3
 aa6:	0009871b          	sext.w	a4,s3
 aaa:	6685                	lui	a3,0x1
 aac:	00d77363          	bgeu	a4,a3,ab2 <malloc+0x44>
 ab0:	6a05                	lui	s4,0x1
 ab2:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 ab6:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 aba:	00000917          	auipc	s2,0x0
 abe:	13690913          	addi	s2,s2,310 # bf0 <freep>
    if (p == (char *)-1)
 ac2:	5afd                	li	s5,-1
 ac4:	a88d                	j	b36 <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 ac6:	00000797          	auipc	a5,0x0
 aca:	14278793          	addi	a5,a5,322 # c08 <base>
 ace:	00000717          	auipc	a4,0x0
 ad2:	12f73123          	sd	a5,290(a4) # bf0 <freep>
 ad6:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 ad8:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 adc:	b7e1                	j	aa4 <malloc+0x36>
            if (p->s.size == nunits)
 ade:	02e48b63          	beq	s1,a4,b14 <malloc+0xa6>
                p->s.size -= nunits;
 ae2:	4137073b          	subw	a4,a4,s3
 ae6:	c798                	sw	a4,8(a5)
                p += p->s.size;
 ae8:	1702                	slli	a4,a4,0x20
 aea:	9301                	srli	a4,a4,0x20
 aec:	0712                	slli	a4,a4,0x4
 aee:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 af0:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 af4:	00000717          	auipc	a4,0x0
 af8:	0ea73e23          	sd	a0,252(a4) # bf0 <freep>
            return (void *)(p + 1);
 afc:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 b00:	70e2                	ld	ra,56(sp)
 b02:	7442                	ld	s0,48(sp)
 b04:	74a2                	ld	s1,40(sp)
 b06:	7902                	ld	s2,32(sp)
 b08:	69e2                	ld	s3,24(sp)
 b0a:	6a42                	ld	s4,16(sp)
 b0c:	6aa2                	ld	s5,8(sp)
 b0e:	6b02                	ld	s6,0(sp)
 b10:	6121                	addi	sp,sp,64
 b12:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 b14:	6398                	ld	a4,0(a5)
 b16:	e118                	sd	a4,0(a0)
 b18:	bff1                	j	af4 <malloc+0x86>
    hp->s.size = nu;
 b1a:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 b1e:	0541                	addi	a0,a0,16
 b20:	00000097          	auipc	ra,0x0
 b24:	ec6080e7          	jalr	-314(ra) # 9e6 <free>
    return freep;
 b28:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 b2c:	d971                	beqz	a0,b00 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 b2e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 b30:	4798                	lw	a4,8(a5)
 b32:	fa9776e3          	bgeu	a4,s1,ade <malloc+0x70>
        if (p == freep)
 b36:	00093703          	ld	a4,0(s2)
 b3a:	853e                	mv	a0,a5
 b3c:	fef719e3          	bne	a4,a5,b2e <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 b40:	8552                	mv	a0,s4
 b42:	00000097          	auipc	ra,0x0
 b46:	b3e080e7          	jalr	-1218(ra) # 680 <sbrk>
    if (p == (char *)-1)
 b4a:	fd5518e3          	bne	a0,s5,b1a <malloc+0xac>
                return 0;
 b4e:	4501                	li	a0,0
 b50:	bf45                	j	b00 <malloc+0x92>
