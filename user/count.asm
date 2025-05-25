
user/_count:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
#include "user/user.h"

#define MAX_DEPTH 20

void print(char *basename, int level, int is_last[])
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	e062                	sd	s8,0(sp)
  16:	0880                	addi	s0,sp,80
  18:	8aaa                	mv	s5,a0
  1a:	8a2e                	mv	s4,a1
    if (level > 0)
  1c:	08b05463          	blez	a1,a4 <print+0xa4>
  20:	84b2                	mv	s1,a2
    {
        for (int i = 0; i < level - 1; i++)
  22:	fff5899b          	addiw	s3,a1,-1
  26:	0b305663          	blez	s3,d2 <print+0xd2>
  2a:	8932                	mv	s2,a2
  2c:	ffe58b1b          	addiw	s6,a1,-2
  30:	1b02                	slli	s6,s6,0x20
  32:	020b5b13          	srli	s6,s6,0x20
  36:	0b0a                	slli	s6,s6,0x2
  38:	00460793          	addi	a5,a2,4
  3c:	9b3e                	add	s6,s6,a5
        {
            printf("%c   ", "| "[is_last[i]]);
  3e:	00001c17          	auipc	s8,0x1
  42:	d1ac0c13          	addi	s8,s8,-742 # d58 <malloc+0x10a>
  46:	00001b97          	auipc	s7,0x1
  4a:	cf2b8b93          	addi	s7,s7,-782 # d38 <malloc+0xea>
  4e:	00092783          	lw	a5,0(s2)
  52:	97e2                	add	a5,a5,s8
  54:	0007c583          	lbu	a1,0(a5)
  58:	855e                	mv	a0,s7
  5a:	00001097          	auipc	ra,0x1
  5e:	b36080e7          	jalr	-1226(ra) # b90 <printf>
        for (int i = 0; i < level - 1; i++)
  62:	0911                	addi	s2,s2,4
  64:	ff6915e3          	bne	s2,s6,4e <print+0x4e>
        }
        printf("|\n");
  68:	00001517          	auipc	a0,0x1
  6c:	ce850513          	addi	a0,a0,-792 # d50 <malloc+0x102>
  70:	00001097          	auipc	ra,0x1
  74:	b20080e7          	jalr	-1248(ra) # b90 <printf>
  78:	4901                	li	s2,0
    }
    for (int i = 0; i < level - 1; i++)
    {
        printf("%c   ", "| "[is_last[i]]);
  7a:	00001b97          	auipc	s7,0x1
  7e:	cdeb8b93          	addi	s7,s7,-802 # d58 <malloc+0x10a>
  82:	00001b17          	auipc	s6,0x1
  86:	cb6b0b13          	addi	s6,s6,-842 # d38 <malloc+0xea>
  8a:	409c                	lw	a5,0(s1)
  8c:	97de                	add	a5,a5,s7
  8e:	0007c583          	lbu	a1,0(a5)
  92:	855a                	mv	a0,s6
  94:	00001097          	auipc	ra,0x1
  98:	afc080e7          	jalr	-1284(ra) # b90 <printf>
    for (int i = 0; i < level - 1; i++)
  9c:	2905                	addiw	s2,s2,1
  9e:	0491                	addi	s1,s1,4
  a0:	ff3945e3          	blt	s2,s3,8a <print+0x8a>
    }
    if (level == 0)
  a4:	020a1f63          	bnez	s4,e2 <print+0xe2>
    {
        printf("%s\n", basename);
  a8:	85d6                	mv	a1,s5
  aa:	00001517          	auipc	a0,0x1
  ae:	c9650513          	addi	a0,a0,-874 # d40 <malloc+0xf2>
  b2:	00001097          	auipc	ra,0x1
  b6:	ade080e7          	jalr	-1314(ra) # b90 <printf>
    }
    else
    {
        printf("+-- %s\n", basename);
    }
}
  ba:	60a6                	ld	ra,72(sp)
  bc:	6406                	ld	s0,64(sp)
  be:	74e2                	ld	s1,56(sp)
  c0:	7942                	ld	s2,48(sp)
  c2:	79a2                	ld	s3,40(sp)
  c4:	7a02                	ld	s4,32(sp)
  c6:	6ae2                	ld	s5,24(sp)
  c8:	6b42                	ld	s6,16(sp)
  ca:	6ba2                	ld	s7,8(sp)
  cc:	6c02                	ld	s8,0(sp)
  ce:	6161                	addi	sp,sp,80
  d0:	8082                	ret
        printf("|\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	c7e50513          	addi	a0,a0,-898 # d50 <malloc+0x102>
  da:	00001097          	auipc	ra,0x1
  de:	ab6080e7          	jalr	-1354(ra) # b90 <printf>
        printf("+-- %s\n", basename);
  e2:	85d6                	mv	a1,s5
  e4:	00001517          	auipc	a0,0x1
  e8:	c6450513          	addi	a0,a0,-924 # d48 <malloc+0xfa>
  ec:	00001097          	auipc	ra,0x1
  f0:	aa4080e7          	jalr	-1372(ra) # b90 <printf>
}
  f4:	b7d9                	j	ba <print+0xba>

00000000000000f6 <traverse>:
void traverse(char *path, char *basename, int level, int is_last[],
              int *file_num, int *dir_num)
{
  f6:	d6010113          	addi	sp,sp,-672
  fa:	28113c23          	sd	ra,664(sp)
  fe:	28813823          	sd	s0,656(sp)
 102:	28913423          	sd	s1,648(sp)
 106:	29213023          	sd	s2,640(sp)
 10a:	27313c23          	sd	s3,632(sp)
 10e:	27413823          	sd	s4,624(sp)
 112:	27513423          	sd	s5,616(sp)
 116:	27613023          	sd	s6,608(sp)
 11a:	25713c23          	sd	s7,600(sp)
 11e:	25813823          	sd	s8,592(sp)
 122:	25913423          	sd	s9,584(sp)
 126:	25a13023          	sd	s10,576(sp)
 12a:	23b13c23          	sd	s11,568(sp)
 12e:	1500                	addi	s0,sp,672
 130:	892a                	mv	s2,a0
 132:	8aae                	mv	s5,a1
 134:	89b2                	mv	s3,a2
 136:	8a36                	mv	s4,a3
 138:	8bba                	mv	s7,a4
 13a:	8b3e                	mv	s6,a5
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
 13c:	4581                	li	a1,0
 13e:	00000097          	auipc	ra,0x0
 142:	6da080e7          	jalr	1754(ra) # 818 <open>
 146:	10054963          	bltz	a0,258 <traverse+0x162>
 14a:	84aa                	mv	s1,a0
    {
        printf("%s [error opening dir]\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
 14c:	d6040593          	addi	a1,s0,-672
 150:	00000097          	auipc	ra,0x0
 154:	6e0080e7          	jalr	1760(ra) # 830 <fstat>
 158:	14054663          	bltz	a0,2a4 <traverse+0x1ae>
        fprintf(2, "tree: cannot stat (new recursion) %s\n", path);
        return;
    }
    else
    {
        close(fd);
 15c:	8526                	mv	a0,s1
 15e:	00000097          	auipc	ra,0x0
 162:	6a2080e7          	jalr	1698(ra) # 800 <close>
    }

    if (st.type == T_FILE)
 166:	d6841803          	lh	a6,-664(s0)
 16a:	0008071b          	sext.w	a4,a6
 16e:	4789                	li	a5,2
 170:	14f70563          	beq	a4,a5,2ba <traverse+0x1c4>
        }
        (*file_num)++;
        print(basename, level, is_last);
        return;
    }
    else if (st.type == T_DIR)
 174:	2801                	sext.w	a6,a6
 176:	4785                	li	a5,1
 178:	0ef81963          	bne	a6,a5,26a <traverse+0x174>
    {
        if (level > 0)
 17c:	01305763          	blez	s3,18a <traverse+0x94>
        {
            (*dir_num)++;
 180:	000b2783          	lw	a5,0(s6)
 184:	2785                	addiw	a5,a5,1
 186:	00fb2023          	sw	a5,0(s6)
        }
        print(basename, level, is_last);
 18a:	8652                	mv	a2,s4
 18c:	85ce                	mv	a1,s3
 18e:	8556                	mv	a0,s5
 190:	00000097          	auipc	ra,0x0
 194:	e70080e7          	jalr	-400(ra) # 0 <print>
    {
        // printf("tree: path %s is a device\n", path);
        return;
    }

    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 198:	854a                	mv	a0,s2
 19a:	00000097          	auipc	ra,0x0
 19e:	418080e7          	jalr	1048(ra) # 5b2 <strlen>
 1a2:	2541                	addiw	a0,a0,16
 1a4:	20000793          	li	a5,512
 1a8:	14a7e263          	bltu	a5,a0,2ec <traverse+0x1f6>
    {
        printf("tree: path too long\n");
        close(fd);
        return;
    }
    strcpy(buf, path);
 1ac:	85ca                	mv	a1,s2
 1ae:	d9040513          	addi	a0,s0,-624
 1b2:	00000097          	auipc	ra,0x0
 1b6:	3b8080e7          	jalr	952(ra) # 56a <strcpy>
    p = buf + strlen(buf);
 1ba:	d9040513          	addi	a0,s0,-624
 1be:	00000097          	auipc	ra,0x0
 1c2:	3f4080e7          	jalr	1012(ra) # 5b2 <strlen>
 1c6:	02051a93          	slli	s5,a0,0x20
 1ca:	020ada93          	srli	s5,s5,0x20
 1ce:	d9040793          	addi	a5,s0,-624
 1d2:	9abe                	add	s5,s5,a5
    *p++ = '/';
 1d4:	001a8c13          	addi	s8,s5,1
 1d8:	02f00793          	li	a5,47
 1dc:	00fa8023          	sb	a5,0(s5)

    int count = 0;
    if ((fd = open(path, 0)) < 0)
 1e0:	4581                	li	a1,0
 1e2:	854a                	mv	a0,s2
 1e4:	00000097          	auipc	ra,0x0
 1e8:	634080e7          	jalr	1588(ra) # 818 <open>
 1ec:	84aa                	mv	s1,a0
    int count = 0;
 1ee:	4d01                	li	s10,0
    if ((fd = open(path, 0)) < 0)
 1f0:	10054c63          	bltz	a0,308 <traverse+0x212>
    {
        if (de.inum == 0)
            continue;
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;
        if (strcmp(de.name, ".") && strcmp(de.name, ".."))
 1f4:	00001c97          	auipc	s9,0x1
 1f8:	bc4c8c93          	addi	s9,s9,-1084 # db8 <malloc+0x16a>
 1fc:	00001d97          	auipc	s11,0x1
 200:	bc4d8d93          	addi	s11,s11,-1084 # dc0 <malloc+0x172>
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 204:	4641                	li	a2,16
 206:	d8040593          	addi	a1,s0,-640
 20a:	8526                	mv	a0,s1
 20c:	00000097          	auipc	ra,0x0
 210:	5e4080e7          	jalr	1508(ra) # 7f0 <read>
 214:	47c1                	li	a5,16
 216:	10f51363          	bne	a0,a5,31c <traverse+0x226>
        if (de.inum == 0)
 21a:	d8045783          	lhu	a5,-640(s0)
 21e:	d3fd                	beqz	a5,204 <traverse+0x10e>
        memmove(p, de.name, DIRSIZ);
 220:	4639                	li	a2,14
 222:	d8240593          	addi	a1,s0,-638
 226:	8562                	mv	a0,s8
 228:	00000097          	auipc	ra,0x0
 22c:	4fe080e7          	jalr	1278(ra) # 726 <memmove>
        p[DIRSIZ] = 0;
 230:	000a87a3          	sb	zero,15(s5)
        if (strcmp(de.name, ".") && strcmp(de.name, ".."))
 234:	85e6                	mv	a1,s9
 236:	d8240513          	addi	a0,s0,-638
 23a:	00000097          	auipc	ra,0x0
 23e:	34c080e7          	jalr	844(ra) # 586 <strcmp>
 242:	d169                	beqz	a0,204 <traverse+0x10e>
 244:	85ee                	mv	a1,s11
 246:	d8240513          	addi	a0,s0,-638
 24a:	00000097          	auipc	ra,0x0
 24e:	33c080e7          	jalr	828(ra) # 586 <strcmp>
 252:	d94d                	beqz	a0,204 <traverse+0x10e>
        {
            count++;
 254:	2d05                	addiw	s10,s10,1
 256:	b77d                	j	204 <traverse+0x10e>
        printf("%s [error opening dir]\n", path);
 258:	85ca                	mv	a1,s2
 25a:	00001517          	auipc	a0,0x1
 25e:	b0650513          	addi	a0,a0,-1274 # d60 <malloc+0x112>
 262:	00001097          	auipc	ra,0x1
 266:	92e080e7          	jalr	-1746(ra) # b90 <printf>
        }
    }

    close(fd);
    return;
}
 26a:	29813083          	ld	ra,664(sp)
 26e:	29013403          	ld	s0,656(sp)
 272:	28813483          	ld	s1,648(sp)
 276:	28013903          	ld	s2,640(sp)
 27a:	27813983          	ld	s3,632(sp)
 27e:	27013a03          	ld	s4,624(sp)
 282:	26813a83          	ld	s5,616(sp)
 286:	26013b03          	ld	s6,608(sp)
 28a:	25813b83          	ld	s7,600(sp)
 28e:	25013c03          	ld	s8,592(sp)
 292:	24813c83          	ld	s9,584(sp)
 296:	24013d03          	ld	s10,576(sp)
 29a:	23813d83          	ld	s11,568(sp)
 29e:	2a010113          	addi	sp,sp,672
 2a2:	8082                	ret
        fprintf(2, "tree: cannot stat (new recursion) %s\n", path);
 2a4:	864a                	mv	a2,s2
 2a6:	00001597          	auipc	a1,0x1
 2aa:	ad258593          	addi	a1,a1,-1326 # d78 <malloc+0x12a>
 2ae:	4509                	li	a0,2
 2b0:	00001097          	auipc	ra,0x1
 2b4:	8b2080e7          	jalr	-1870(ra) # b62 <fprintf>
        return;
 2b8:	bf4d                	j	26a <traverse+0x174>
        if (level == 0)
 2ba:	00099c63          	bnez	s3,2d2 <traverse+0x1dc>
            printf("%s [error opening dir]\n", path);
 2be:	85ca                	mv	a1,s2
 2c0:	00001517          	auipc	a0,0x1
 2c4:	aa050513          	addi	a0,a0,-1376 # d60 <malloc+0x112>
 2c8:	00001097          	auipc	ra,0x1
 2cc:	8c8080e7          	jalr	-1848(ra) # b90 <printf>
            return;
 2d0:	bf69                	j	26a <traverse+0x174>
        (*file_num)++;
 2d2:	000ba783          	lw	a5,0(s7)
 2d6:	2785                	addiw	a5,a5,1
 2d8:	00fba023          	sw	a5,0(s7)
        print(basename, level, is_last);
 2dc:	8652                	mv	a2,s4
 2de:	85ce                	mv	a1,s3
 2e0:	8556                	mv	a0,s5
 2e2:	00000097          	auipc	ra,0x0
 2e6:	d1e080e7          	jalr	-738(ra) # 0 <print>
        return;
 2ea:	b741                	j	26a <traverse+0x174>
        printf("tree: path too long\n");
 2ec:	00001517          	auipc	a0,0x1
 2f0:	ab450513          	addi	a0,a0,-1356 # da0 <malloc+0x152>
 2f4:	00001097          	auipc	ra,0x1
 2f8:	89c080e7          	jalr	-1892(ra) # b90 <printf>
        close(fd);
 2fc:	8526                	mv	a0,s1
 2fe:	00000097          	auipc	ra,0x0
 302:	502080e7          	jalr	1282(ra) # 800 <close>
        return;
 306:	b795                	j	26a <traverse+0x174>
        printf("%s [error opening dir]\n", path);
 308:	85ca                	mv	a1,s2
 30a:	00001517          	auipc	a0,0x1
 30e:	a5650513          	addi	a0,a0,-1450 # d60 <malloc+0x112>
 312:	00001097          	auipc	ra,0x1
 316:	87e080e7          	jalr	-1922(ra) # b90 <printf>
        return;
 31a:	bf81                	j	26a <traverse+0x174>
    close(fd);
 31c:	8526                	mv	a0,s1
 31e:	00000097          	auipc	ra,0x0
 322:	4e2080e7          	jalr	1250(ra) # 800 <close>
    if ((fd = open(path, 0)) < 0)
 326:	4581                	li	a1,0
 328:	854a                	mv	a0,s2
 32a:	00000097          	auipc	ra,0x0
 32e:	4ee080e7          	jalr	1262(ra) # 818 <open>
 332:	84aa                	mv	s1,a0
 334:	08054963          	bltz	a0,3c6 <traverse+0x2d0>
                is_last[level] = 1;
 338:	00299913          	slli	s2,s3,0x2
 33c:	9952                	add	s2,s2,s4
    int cnt = 0;
 33e:	4d81                	li	s11,0
        if (strcmp(de.name, ".") && strcmp(de.name, ".."))
 340:	00001c97          	auipc	s9,0x1
 344:	a78c8c93          	addi	s9,s9,-1416 # db8 <malloc+0x16a>
            if (cnt == count - 1)
 348:	3d7d                	addiw	s10,s10,-1
            traverse(buf, de.name, level + 1, is_last, file_num, dir_num);
 34a:	2985                	addiw	s3,s3,1
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 34c:	4641                	li	a2,16
 34e:	d8040593          	addi	a1,s0,-640
 352:	8526                	mv	a0,s1
 354:	00000097          	auipc	ra,0x0
 358:	49c080e7          	jalr	1180(ra) # 7f0 <read>
 35c:	47c1                	li	a5,16
 35e:	08f51363          	bne	a0,a5,3e4 <traverse+0x2ee>
        if (de.inum == 0)
 362:	d8045783          	lhu	a5,-640(s0)
 366:	d3fd                	beqz	a5,34c <traverse+0x256>
        memmove(p, de.name, DIRSIZ);
 368:	4639                	li	a2,14
 36a:	d8240593          	addi	a1,s0,-638
 36e:	8562                	mv	a0,s8
 370:	00000097          	auipc	ra,0x0
 374:	3b6080e7          	jalr	950(ra) # 726 <memmove>
        p[DIRSIZ] = 0;
 378:	000a87a3          	sb	zero,15(s5)
        if (strcmp(de.name, ".") && strcmp(de.name, ".."))
 37c:	85e6                	mv	a1,s9
 37e:	d8240513          	addi	a0,s0,-638
 382:	00000097          	auipc	ra,0x0
 386:	204080e7          	jalr	516(ra) # 586 <strcmp>
 38a:	d169                	beqz	a0,34c <traverse+0x256>
 38c:	00001597          	auipc	a1,0x1
 390:	a3458593          	addi	a1,a1,-1484 # dc0 <malloc+0x172>
 394:	d8240513          	addi	a0,s0,-638
 398:	00000097          	auipc	ra,0x0
 39c:	1ee080e7          	jalr	494(ra) # 586 <strcmp>
 3a0:	d555                	beqz	a0,34c <traverse+0x256>
            if (cnt == count - 1)
 3a2:	03bd0d63          	beq	s10,s11,3dc <traverse+0x2e6>
            cnt++;
 3a6:	2d85                	addiw	s11,s11,1
            traverse(buf, de.name, level + 1, is_last, file_num, dir_num);
 3a8:	87da                	mv	a5,s6
 3aa:	875e                	mv	a4,s7
 3ac:	86d2                	mv	a3,s4
 3ae:	864e                	mv	a2,s3
 3b0:	d8240593          	addi	a1,s0,-638
 3b4:	d9040513          	addi	a0,s0,-624
 3b8:	00000097          	auipc	ra,0x0
 3bc:	d3e080e7          	jalr	-706(ra) # f6 <traverse>
            is_last[level] = 0;
 3c0:	00092023          	sw	zero,0(s2)
 3c4:	b761                	j	34c <traverse+0x256>
        fprintf(2, "tree: cannot open %s after counting files\n", path);
 3c6:	864a                	mv	a2,s2
 3c8:	00001597          	auipc	a1,0x1
 3cc:	a0058593          	addi	a1,a1,-1536 # dc8 <malloc+0x17a>
 3d0:	4509                	li	a0,2
 3d2:	00000097          	auipc	ra,0x0
 3d6:	790080e7          	jalr	1936(ra) # b62 <fprintf>
        return;
 3da:	bd41                	j	26a <traverse+0x174>
                is_last[level] = 1;
 3dc:	4785                	li	a5,1
 3de:	00f92023          	sw	a5,0(s2)
 3e2:	b7d1                	j	3a6 <traverse+0x2b0>
    close(fd);
 3e4:	8526                	mv	a0,s1
 3e6:	00000097          	auipc	ra,0x0
 3ea:	41a080e7          	jalr	1050(ra) # 800 <close>
    return;
 3ee:	bdb5                	j	26a <traverse+0x174>

00000000000003f0 <main>:

int main(int argc, char *argv[])
{
 3f0:	7119                	addi	sp,sp,-128
 3f2:	fc86                	sd	ra,120(sp)
 3f4:	f8a2                	sd	s0,112(sp)
 3f6:	f4a6                	sd	s1,104(sp)
 3f8:	0100                	addi	s0,sp,128
    // fprintf(2, "stderr\n");
    // int ret = 0;
    int pid, ret = 0;
    int fds[2];

    if (argc < 2)
 3fa:	4785                	li	a5,1
 3fc:	08a7d863          	bge	a5,a0,48c <main+0x9c>
 400:	84ae                	mv	s1,a1
        printf("tree: missing argv[1]\n");
        exit(-1);
    }

    // Create pipes
    if (pipe(fds) < 0)
 402:	fd840513          	addi	a0,s0,-40
 406:	00000097          	auipc	ra,0x0
 40a:	3e2080e7          	jalr	994(ra) # 7e8 <pipe>
 40e:	08054c63          	bltz	a0,4a6 <main+0xb6>
        printf("tree: pipe failed\n");
        exit(-1);
    }

    // Create child process
    pid = fork();
 412:	00000097          	auipc	ra,0x0
 416:	3be080e7          	jalr	958(ra) # 7d0 <fork>
    if (pid == 0)
 41a:	c15d                	beqz	a0,4c0 <main+0xd0>
        write(fds[1], &dir_num, sizeof(int));
        printf("\n");

        exit(0);
    }
    else if (pid > 0)
 41c:	12a05d63          	blez	a0,556 <main+0x166>
    { // Parent
        // wait for child to exit
        // wait(0);
        int file_num, dir_num;
        if (read(fds[0], &file_num, sizeof(int)) != sizeof(int))
 420:	4611                	li	a2,4
 422:	f8440593          	addi	a1,s0,-124
 426:	fd842503          	lw	a0,-40(s0)
 42a:	00000097          	auipc	ra,0x0
 42e:	3c6080e7          	jalr	966(ra) # 7f0 <read>
 432:	4791                	li	a5,4
 434:	0ef51f63          	bne	a0,a5,532 <main+0x142>
        {
            printf("tree: pipe read failed (file_num)\n");
        }
        if (read(fds[0], &dir_num, sizeof(int)) != sizeof(int))
 438:	4611                	li	a2,4
 43a:	f8840593          	addi	a1,s0,-120
 43e:	fd842503          	lw	a0,-40(s0)
 442:	00000097          	auipc	ra,0x0
 446:	3ae080e7          	jalr	942(ra) # 7f0 <read>
 44a:	4791                	li	a5,4
 44c:	0ef51c63          	bne	a0,a5,544 <main+0x154>
        {
            printf("tree: pipe read failed (dir_num)\n");
        }
        printf("%d directories, %d files\n", dir_num, file_num);
 450:	f8442603          	lw	a2,-124(s0)
 454:	f8842583          	lw	a1,-120(s0)
 458:	00001517          	auipc	a0,0x1
 45c:	a2050513          	addi	a0,a0,-1504 # e78 <malloc+0x22a>
 460:	00000097          	auipc	ra,0x0
 464:	730080e7          	jalr	1840(ra) # b90 <printf>
    int pid, ret = 0;
 468:	4481                	li	s1,0
    {
        printf("tree: fork failed\n");
        ret = -1;
    }

    close(fds[0]);
 46a:	fd842503          	lw	a0,-40(s0)
 46e:	00000097          	auipc	ra,0x0
 472:	392080e7          	jalr	914(ra) # 800 <close>
    close(fds[1]);
 476:	fdc42503          	lw	a0,-36(s0)
 47a:	00000097          	auipc	ra,0x0
 47e:	386080e7          	jalr	902(ra) # 800 <close>
    exit(ret);
 482:	8526                	mv	a0,s1
 484:	00000097          	auipc	ra,0x0
 488:	354080e7          	jalr	852(ra) # 7d8 <exit>
        printf("tree: missing argv[1]\n");
 48c:	00001517          	auipc	a0,0x1
 490:	96c50513          	addi	a0,a0,-1684 # df8 <malloc+0x1aa>
 494:	00000097          	auipc	ra,0x0
 498:	6fc080e7          	jalr	1788(ra) # b90 <printf>
        exit(-1);
 49c:	557d                	li	a0,-1
 49e:	00000097          	auipc	ra,0x0
 4a2:	33a080e7          	jalr	826(ra) # 7d8 <exit>
        printf("tree: pipe failed\n");
 4a6:	00001517          	auipc	a0,0x1
 4aa:	96a50513          	addi	a0,a0,-1686 # e10 <malloc+0x1c2>
 4ae:	00000097          	auipc	ra,0x0
 4b2:	6e2080e7          	jalr	1762(ra) # b90 <printf>
        exit(-1);
 4b6:	557d                	li	a0,-1
 4b8:	00000097          	auipc	ra,0x0
 4bc:	320080e7          	jalr	800(ra) # 7d8 <exit>
        int file_num = 0, dir_num = 0;
 4c0:	f8042023          	sw	zero,-128(s0)
 4c4:	f8042223          	sw	zero,-124(s0)
        int is_last[MAX_DEPTH] = {};
 4c8:	05000613          	li	a2,80
 4cc:	4581                	li	a1,0
 4ce:	f8840513          	addi	a0,s0,-120
 4d2:	00000097          	auipc	ra,0x0
 4d6:	10a080e7          	jalr	266(ra) # 5dc <memset>
        traverse(argv[1], argv[1], 0, is_last, &file_num, &dir_num);
 4da:	6488                	ld	a0,8(s1)
 4dc:	f8440793          	addi	a5,s0,-124
 4e0:	f8040713          	addi	a4,s0,-128
 4e4:	f8840693          	addi	a3,s0,-120
 4e8:	4601                	li	a2,0
 4ea:	85aa                	mv	a1,a0
 4ec:	00000097          	auipc	ra,0x0
 4f0:	c0a080e7          	jalr	-1014(ra) # f6 <traverse>
        write(fds[1], &file_num, sizeof(int));
 4f4:	4611                	li	a2,4
 4f6:	f8040593          	addi	a1,s0,-128
 4fa:	fdc42503          	lw	a0,-36(s0)
 4fe:	00000097          	auipc	ra,0x0
 502:	2fa080e7          	jalr	762(ra) # 7f8 <write>
        write(fds[1], &dir_num, sizeof(int));
 506:	4611                	li	a2,4
 508:	f8440593          	addi	a1,s0,-124
 50c:	fdc42503          	lw	a0,-36(s0)
 510:	00000097          	auipc	ra,0x0
 514:	2e8080e7          	jalr	744(ra) # 7f8 <write>
        printf("\n");
 518:	00001517          	auipc	a0,0x1
 51c:	95850513          	addi	a0,a0,-1704 # e70 <malloc+0x222>
 520:	00000097          	auipc	ra,0x0
 524:	670080e7          	jalr	1648(ra) # b90 <printf>
        exit(0);
 528:	4501                	li	a0,0
 52a:	00000097          	auipc	ra,0x0
 52e:	2ae080e7          	jalr	686(ra) # 7d8 <exit>
            printf("tree: pipe read failed (file_num)\n");
 532:	00001517          	auipc	a0,0x1
 536:	8f650513          	addi	a0,a0,-1802 # e28 <malloc+0x1da>
 53a:	00000097          	auipc	ra,0x0
 53e:	656080e7          	jalr	1622(ra) # b90 <printf>
 542:	bddd                	j	438 <main+0x48>
            printf("tree: pipe read failed (dir_num)\n");
 544:	00001517          	auipc	a0,0x1
 548:	90c50513          	addi	a0,a0,-1780 # e50 <malloc+0x202>
 54c:	00000097          	auipc	ra,0x0
 550:	644080e7          	jalr	1604(ra) # b90 <printf>
 554:	bdf5                	j	450 <main+0x60>
        printf("tree: fork failed\n");
 556:	00001517          	auipc	a0,0x1
 55a:	94250513          	addi	a0,a0,-1726 # e98 <malloc+0x24a>
 55e:	00000097          	auipc	ra,0x0
 562:	632080e7          	jalr	1586(ra) # b90 <printf>
        ret = -1;
 566:	54fd                	li	s1,-1
 568:	b709                	j	46a <main+0x7a>

000000000000056a <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 56a:	1141                	addi	sp,sp,-16
 56c:	e422                	sd	s0,8(sp)
 56e:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 570:	87aa                	mv	a5,a0
 572:	0585                	addi	a1,a1,1
 574:	0785                	addi	a5,a5,1
 576:	fff5c703          	lbu	a4,-1(a1)
 57a:	fee78fa3          	sb	a4,-1(a5)
 57e:	fb75                	bnez	a4,572 <strcpy+0x8>
        ;
    return os;
}
 580:	6422                	ld	s0,8(sp)
 582:	0141                	addi	sp,sp,16
 584:	8082                	ret

0000000000000586 <strcmp>:

int strcmp(const char *p, const char *q)
{
 586:	1141                	addi	sp,sp,-16
 588:	e422                	sd	s0,8(sp)
 58a:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 58c:	00054783          	lbu	a5,0(a0)
 590:	cb91                	beqz	a5,5a4 <strcmp+0x1e>
 592:	0005c703          	lbu	a4,0(a1)
 596:	00f71763          	bne	a4,a5,5a4 <strcmp+0x1e>
        p++, q++;
 59a:	0505                	addi	a0,a0,1
 59c:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 59e:	00054783          	lbu	a5,0(a0)
 5a2:	fbe5                	bnez	a5,592 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 5a4:	0005c503          	lbu	a0,0(a1)
}
 5a8:	40a7853b          	subw	a0,a5,a0
 5ac:	6422                	ld	s0,8(sp)
 5ae:	0141                	addi	sp,sp,16
 5b0:	8082                	ret

00000000000005b2 <strlen>:

uint strlen(const char *s)
{
 5b2:	1141                	addi	sp,sp,-16
 5b4:	e422                	sd	s0,8(sp)
 5b6:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 5b8:	00054783          	lbu	a5,0(a0)
 5bc:	cf91                	beqz	a5,5d8 <strlen+0x26>
 5be:	0505                	addi	a0,a0,1
 5c0:	87aa                	mv	a5,a0
 5c2:	4685                	li	a3,1
 5c4:	9e89                	subw	a3,a3,a0
 5c6:	00f6853b          	addw	a0,a3,a5
 5ca:	0785                	addi	a5,a5,1
 5cc:	fff7c703          	lbu	a4,-1(a5)
 5d0:	fb7d                	bnez	a4,5c6 <strlen+0x14>
        ;
    return n;
}
 5d2:	6422                	ld	s0,8(sp)
 5d4:	0141                	addi	sp,sp,16
 5d6:	8082                	ret
    for (n = 0; s[n]; n++)
 5d8:	4501                	li	a0,0
 5da:	bfe5                	j	5d2 <strlen+0x20>

00000000000005dc <memset>:

void *memset(void *dst, int c, uint n)
{
 5dc:	1141                	addi	sp,sp,-16
 5de:	e422                	sd	s0,8(sp)
 5e0:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 5e2:	ca19                	beqz	a2,5f8 <memset+0x1c>
 5e4:	87aa                	mv	a5,a0
 5e6:	1602                	slli	a2,a2,0x20
 5e8:	9201                	srli	a2,a2,0x20
 5ea:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 5ee:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 5f2:	0785                	addi	a5,a5,1
 5f4:	fee79de3          	bne	a5,a4,5ee <memset+0x12>
    }
    return dst;
}
 5f8:	6422                	ld	s0,8(sp)
 5fa:	0141                	addi	sp,sp,16
 5fc:	8082                	ret

00000000000005fe <strchr>:

char *strchr(const char *s, char c)
{
 5fe:	1141                	addi	sp,sp,-16
 600:	e422                	sd	s0,8(sp)
 602:	0800                	addi	s0,sp,16
    for (; *s; s++)
 604:	00054783          	lbu	a5,0(a0)
 608:	cb99                	beqz	a5,61e <strchr+0x20>
        if (*s == c)
 60a:	00f58763          	beq	a1,a5,618 <strchr+0x1a>
    for (; *s; s++)
 60e:	0505                	addi	a0,a0,1
 610:	00054783          	lbu	a5,0(a0)
 614:	fbfd                	bnez	a5,60a <strchr+0xc>
            return (char *)s;
    return 0;
 616:	4501                	li	a0,0
}
 618:	6422                	ld	s0,8(sp)
 61a:	0141                	addi	sp,sp,16
 61c:	8082                	ret
    return 0;
 61e:	4501                	li	a0,0
 620:	bfe5                	j	618 <strchr+0x1a>

0000000000000622 <gets>:

char *gets(char *buf, int max)
{
 622:	711d                	addi	sp,sp,-96
 624:	ec86                	sd	ra,88(sp)
 626:	e8a2                	sd	s0,80(sp)
 628:	e4a6                	sd	s1,72(sp)
 62a:	e0ca                	sd	s2,64(sp)
 62c:	fc4e                	sd	s3,56(sp)
 62e:	f852                	sd	s4,48(sp)
 630:	f456                	sd	s5,40(sp)
 632:	f05a                	sd	s6,32(sp)
 634:	ec5e                	sd	s7,24(sp)
 636:	1080                	addi	s0,sp,96
 638:	8baa                	mv	s7,a0
 63a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 63c:	892a                	mv	s2,a0
 63e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 640:	4aa9                	li	s5,10
 642:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 644:	89a6                	mv	s3,s1
 646:	2485                	addiw	s1,s1,1
 648:	0344d863          	bge	s1,s4,678 <gets+0x56>
        cc = read(0, &c, 1);
 64c:	4605                	li	a2,1
 64e:	faf40593          	addi	a1,s0,-81
 652:	4501                	li	a0,0
 654:	00000097          	auipc	ra,0x0
 658:	19c080e7          	jalr	412(ra) # 7f0 <read>
        if (cc < 1)
 65c:	00a05e63          	blez	a0,678 <gets+0x56>
        buf[i++] = c;
 660:	faf44783          	lbu	a5,-81(s0)
 664:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 668:	01578763          	beq	a5,s5,676 <gets+0x54>
 66c:	0905                	addi	s2,s2,1
 66e:	fd679be3          	bne	a5,s6,644 <gets+0x22>
    for (i = 0; i + 1 < max;)
 672:	89a6                	mv	s3,s1
 674:	a011                	j	678 <gets+0x56>
 676:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 678:	99de                	add	s3,s3,s7
 67a:	00098023          	sb	zero,0(s3)
    return buf;
}
 67e:	855e                	mv	a0,s7
 680:	60e6                	ld	ra,88(sp)
 682:	6446                	ld	s0,80(sp)
 684:	64a6                	ld	s1,72(sp)
 686:	6906                	ld	s2,64(sp)
 688:	79e2                	ld	s3,56(sp)
 68a:	7a42                	ld	s4,48(sp)
 68c:	7aa2                	ld	s5,40(sp)
 68e:	7b02                	ld	s6,32(sp)
 690:	6be2                	ld	s7,24(sp)
 692:	6125                	addi	sp,sp,96
 694:	8082                	ret

0000000000000696 <stat>:

int stat(const char *n, struct stat *st)
{
 696:	1101                	addi	sp,sp,-32
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	e426                	sd	s1,8(sp)
 69e:	e04a                	sd	s2,0(sp)
 6a0:	1000                	addi	s0,sp,32
 6a2:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 6a4:	4581                	li	a1,0
 6a6:	00000097          	auipc	ra,0x0
 6aa:	172080e7          	jalr	370(ra) # 818 <open>
    if (fd < 0)
 6ae:	02054563          	bltz	a0,6d8 <stat+0x42>
 6b2:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 6b4:	85ca                	mv	a1,s2
 6b6:	00000097          	auipc	ra,0x0
 6ba:	17a080e7          	jalr	378(ra) # 830 <fstat>
 6be:	892a                	mv	s2,a0
    close(fd);
 6c0:	8526                	mv	a0,s1
 6c2:	00000097          	auipc	ra,0x0
 6c6:	13e080e7          	jalr	318(ra) # 800 <close>
    return r;
}
 6ca:	854a                	mv	a0,s2
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	64a2                	ld	s1,8(sp)
 6d2:	6902                	ld	s2,0(sp)
 6d4:	6105                	addi	sp,sp,32
 6d6:	8082                	ret
        return -1;
 6d8:	597d                	li	s2,-1
 6da:	bfc5                	j	6ca <stat+0x34>

00000000000006dc <atoi>:

int atoi(const char *s)
{
 6dc:	1141                	addi	sp,sp,-16
 6de:	e422                	sd	s0,8(sp)
 6e0:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 6e2:	00054603          	lbu	a2,0(a0)
 6e6:	fd06079b          	addiw	a5,a2,-48
 6ea:	0ff7f793          	andi	a5,a5,255
 6ee:	4725                	li	a4,9
 6f0:	02f76963          	bltu	a4,a5,722 <atoi+0x46>
 6f4:	86aa                	mv	a3,a0
    n = 0;
 6f6:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 6f8:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 6fa:	0685                	addi	a3,a3,1
 6fc:	0025179b          	slliw	a5,a0,0x2
 700:	9fa9                	addw	a5,a5,a0
 702:	0017979b          	slliw	a5,a5,0x1
 706:	9fb1                	addw	a5,a5,a2
 708:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 70c:	0006c603          	lbu	a2,0(a3)
 710:	fd06071b          	addiw	a4,a2,-48
 714:	0ff77713          	andi	a4,a4,255
 718:	fee5f1e3          	bgeu	a1,a4,6fa <atoi+0x1e>
    return n;
}
 71c:	6422                	ld	s0,8(sp)
 71e:	0141                	addi	sp,sp,16
 720:	8082                	ret
    n = 0;
 722:	4501                	li	a0,0
 724:	bfe5                	j	71c <atoi+0x40>

0000000000000726 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 726:	1141                	addi	sp,sp,-16
 728:	e422                	sd	s0,8(sp)
 72a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 72c:	02b57463          	bgeu	a0,a1,754 <memmove+0x2e>
    {
        while (n-- > 0)
 730:	00c05f63          	blez	a2,74e <memmove+0x28>
 734:	1602                	slli	a2,a2,0x20
 736:	9201                	srli	a2,a2,0x20
 738:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 73c:	872a                	mv	a4,a0
            *dst++ = *src++;
 73e:	0585                	addi	a1,a1,1
 740:	0705                	addi	a4,a4,1
 742:	fff5c683          	lbu	a3,-1(a1)
 746:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 74a:	fee79ae3          	bne	a5,a4,73e <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 74e:	6422                	ld	s0,8(sp)
 750:	0141                	addi	sp,sp,16
 752:	8082                	ret
        dst += n;
 754:	00c50733          	add	a4,a0,a2
        src += n;
 758:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 75a:	fec05ae3          	blez	a2,74e <memmove+0x28>
 75e:	fff6079b          	addiw	a5,a2,-1
 762:	1782                	slli	a5,a5,0x20
 764:	9381                	srli	a5,a5,0x20
 766:	fff7c793          	not	a5,a5
 76a:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 76c:	15fd                	addi	a1,a1,-1
 76e:	177d                	addi	a4,a4,-1
 770:	0005c683          	lbu	a3,0(a1)
 774:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 778:	fee79ae3          	bne	a5,a4,76c <memmove+0x46>
 77c:	bfc9                	j	74e <memmove+0x28>

000000000000077e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 77e:	1141                	addi	sp,sp,-16
 780:	e422                	sd	s0,8(sp)
 782:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 784:	ca05                	beqz	a2,7b4 <memcmp+0x36>
 786:	fff6069b          	addiw	a3,a2,-1
 78a:	1682                	slli	a3,a3,0x20
 78c:	9281                	srli	a3,a3,0x20
 78e:	0685                	addi	a3,a3,1
 790:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 792:	00054783          	lbu	a5,0(a0)
 796:	0005c703          	lbu	a4,0(a1)
 79a:	00e79863          	bne	a5,a4,7aa <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 79e:	0505                	addi	a0,a0,1
        p2++;
 7a0:	0585                	addi	a1,a1,1
    while (n-- > 0)
 7a2:	fed518e3          	bne	a0,a3,792 <memcmp+0x14>
    }
    return 0;
 7a6:	4501                	li	a0,0
 7a8:	a019                	j	7ae <memcmp+0x30>
            return *p1 - *p2;
 7aa:	40e7853b          	subw	a0,a5,a4
}
 7ae:	6422                	ld	s0,8(sp)
 7b0:	0141                	addi	sp,sp,16
 7b2:	8082                	ret
    return 0;
 7b4:	4501                	li	a0,0
 7b6:	bfe5                	j	7ae <memcmp+0x30>

00000000000007b8 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 7b8:	1141                	addi	sp,sp,-16
 7ba:	e406                	sd	ra,8(sp)
 7bc:	e022                	sd	s0,0(sp)
 7be:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 7c0:	00000097          	auipc	ra,0x0
 7c4:	f66080e7          	jalr	-154(ra) # 726 <memmove>
}
 7c8:	60a2                	ld	ra,8(sp)
 7ca:	6402                	ld	s0,0(sp)
 7cc:	0141                	addi	sp,sp,16
 7ce:	8082                	ret

00000000000007d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7d0:	4885                	li	a7,1
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7d8:	4889                	li	a7,2
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7e0:	488d                	li	a7,3
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7e8:	4891                	li	a7,4
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <read>:
.global read
read:
 li a7, SYS_read
 7f0:	4895                	li	a7,5
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <write>:
.global write
write:
 li a7, SYS_write
 7f8:	48c1                	li	a7,16
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <close>:
.global close
close:
 li a7, SYS_close
 800:	48d5                	li	a7,21
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <kill>:
.global kill
kill:
 li a7, SYS_kill
 808:	4899                	li	a7,6
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <exec>:
.global exec
exec:
 li a7, SYS_exec
 810:	489d                	li	a7,7
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <open>:
.global open
open:
 li a7, SYS_open
 818:	48bd                	li	a7,15
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 820:	48c5                	li	a7,17
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 828:	48c9                	li	a7,18
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 830:	48a1                	li	a7,8
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <link>:
.global link
link:
 li a7, SYS_link
 838:	48cd                	li	a7,19
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 840:	48d1                	li	a7,20
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 848:	48a5                	li	a7,9
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <dup>:
.global dup
dup:
 li a7, SYS_dup
 850:	48a9                	li	a7,10
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 858:	48ad                	li	a7,11
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 860:	48b1                	li	a7,12
 ecall
 862:	00000073          	ecall
 ret
 866:	8082                	ret

0000000000000868 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 868:	48b5                	li	a7,13
 ecall
 86a:	00000073          	ecall
 ret
 86e:	8082                	ret

0000000000000870 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 870:	48b9                	li	a7,14
 ecall
 872:	00000073          	ecall
 ret
 876:	8082                	ret

0000000000000878 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 878:	48d9                	li	a7,22
 ecall
 87a:	00000073          	ecall
 ret
 87e:	8082                	ret

0000000000000880 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 880:	48dd                	li	a7,23
 ecall
 882:	00000073          	ecall
 ret
 886:	8082                	ret

0000000000000888 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 888:	48e1                	li	a7,24
 ecall
 88a:	00000073          	ecall
 ret
 88e:	8082                	ret

0000000000000890 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 890:	48e5                	li	a7,25
 ecall
 892:	00000073          	ecall
 ret
 896:	8082                	ret

0000000000000898 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 898:	48e9                	li	a7,26
 ecall
 89a:	00000073          	ecall
 ret
 89e:	8082                	ret

00000000000008a0 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 8a0:	48ed                	li	a7,27
 ecall
 8a2:	00000073          	ecall
 ret
 8a6:	8082                	ret

00000000000008a8 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 8a8:	48f5                	li	a7,29
 ecall
 8aa:	00000073          	ecall
 ret
 8ae:	8082                	ret

00000000000008b0 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 8b0:	48f1                	li	a7,28
 ecall
 8b2:	00000073          	ecall
 ret
 8b6:	8082                	ret

00000000000008b8 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 8b8:	1101                	addi	sp,sp,-32
 8ba:	ec06                	sd	ra,24(sp)
 8bc:	e822                	sd	s0,16(sp)
 8be:	1000                	addi	s0,sp,32
 8c0:	feb407a3          	sb	a1,-17(s0)
 8c4:	4605                	li	a2,1
 8c6:	fef40593          	addi	a1,s0,-17
 8ca:	00000097          	auipc	ra,0x0
 8ce:	f2e080e7          	jalr	-210(ra) # 7f8 <write>
 8d2:	60e2                	ld	ra,24(sp)
 8d4:	6442                	ld	s0,16(sp)
 8d6:	6105                	addi	sp,sp,32
 8d8:	8082                	ret

00000000000008da <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 8da:	7139                	addi	sp,sp,-64
 8dc:	fc06                	sd	ra,56(sp)
 8de:	f822                	sd	s0,48(sp)
 8e0:	f426                	sd	s1,40(sp)
 8e2:	f04a                	sd	s2,32(sp)
 8e4:	ec4e                	sd	s3,24(sp)
 8e6:	0080                	addi	s0,sp,64
 8e8:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 8ea:	c299                	beqz	a3,8f0 <printint+0x16>
 8ec:	0805c863          	bltz	a1,97c <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 8f0:	2581                	sext.w	a1,a1
    neg = 0;
 8f2:	4881                	li	a7,0
 8f4:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 8f8:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 8fa:	2601                	sext.w	a2,a2
 8fc:	00000517          	auipc	a0,0x0
 900:	5bc50513          	addi	a0,a0,1468 # eb8 <digits>
 904:	883a                	mv	a6,a4
 906:	2705                	addiw	a4,a4,1
 908:	02c5f7bb          	remuw	a5,a1,a2
 90c:	1782                	slli	a5,a5,0x20
 90e:	9381                	srli	a5,a5,0x20
 910:	97aa                	add	a5,a5,a0
 912:	0007c783          	lbu	a5,0(a5)
 916:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 91a:	0005879b          	sext.w	a5,a1
 91e:	02c5d5bb          	divuw	a1,a1,a2
 922:	0685                	addi	a3,a3,1
 924:	fec7f0e3          	bgeu	a5,a2,904 <printint+0x2a>
    if (neg)
 928:	00088b63          	beqz	a7,93e <printint+0x64>
        buf[i++] = '-';
 92c:	fd040793          	addi	a5,s0,-48
 930:	973e                	add	a4,a4,a5
 932:	02d00793          	li	a5,45
 936:	fef70823          	sb	a5,-16(a4)
 93a:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 93e:	02e05863          	blez	a4,96e <printint+0x94>
 942:	fc040793          	addi	a5,s0,-64
 946:	00e78933          	add	s2,a5,a4
 94a:	fff78993          	addi	s3,a5,-1
 94e:	99ba                	add	s3,s3,a4
 950:	377d                	addiw	a4,a4,-1
 952:	1702                	slli	a4,a4,0x20
 954:	9301                	srli	a4,a4,0x20
 956:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 95a:	fff94583          	lbu	a1,-1(s2)
 95e:	8526                	mv	a0,s1
 960:	00000097          	auipc	ra,0x0
 964:	f58080e7          	jalr	-168(ra) # 8b8 <putc>
    while (--i >= 0)
 968:	197d                	addi	s2,s2,-1
 96a:	ff3918e3          	bne	s2,s3,95a <printint+0x80>
}
 96e:	70e2                	ld	ra,56(sp)
 970:	7442                	ld	s0,48(sp)
 972:	74a2                	ld	s1,40(sp)
 974:	7902                	ld	s2,32(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6121                	addi	sp,sp,64
 97a:	8082                	ret
        x = -xx;
 97c:	40b005bb          	negw	a1,a1
        neg = 1;
 980:	4885                	li	a7,1
        x = -xx;
 982:	bf8d                	j	8f4 <printint+0x1a>

0000000000000984 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 984:	7119                	addi	sp,sp,-128
 986:	fc86                	sd	ra,120(sp)
 988:	f8a2                	sd	s0,112(sp)
 98a:	f4a6                	sd	s1,104(sp)
 98c:	f0ca                	sd	s2,96(sp)
 98e:	ecce                	sd	s3,88(sp)
 990:	e8d2                	sd	s4,80(sp)
 992:	e4d6                	sd	s5,72(sp)
 994:	e0da                	sd	s6,64(sp)
 996:	fc5e                	sd	s7,56(sp)
 998:	f862                	sd	s8,48(sp)
 99a:	f466                	sd	s9,40(sp)
 99c:	f06a                	sd	s10,32(sp)
 99e:	ec6e                	sd	s11,24(sp)
 9a0:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 9a2:	0005c903          	lbu	s2,0(a1)
 9a6:	18090f63          	beqz	s2,b44 <vprintf+0x1c0>
 9aa:	8aaa                	mv	s5,a0
 9ac:	8b32                	mv	s6,a2
 9ae:	00158493          	addi	s1,a1,1
    state = 0;
 9b2:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 9b4:	02500a13          	li	s4,37
        {
            if (c == 'd')
 9b8:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 9bc:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 9c0:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 9c4:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9c8:	00000b97          	auipc	s7,0x0
 9cc:	4f0b8b93          	addi	s7,s7,1264 # eb8 <digits>
 9d0:	a839                	j	9ee <vprintf+0x6a>
                putc(fd, c);
 9d2:	85ca                	mv	a1,s2
 9d4:	8556                	mv	a0,s5
 9d6:	00000097          	auipc	ra,0x0
 9da:	ee2080e7          	jalr	-286(ra) # 8b8 <putc>
 9de:	a019                	j	9e4 <vprintf+0x60>
        else if (state == '%')
 9e0:	01498f63          	beq	s3,s4,9fe <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 9e4:	0485                	addi	s1,s1,1
 9e6:	fff4c903          	lbu	s2,-1(s1)
 9ea:	14090d63          	beqz	s2,b44 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 9ee:	0009079b          	sext.w	a5,s2
        if (state == 0)
 9f2:	fe0997e3          	bnez	s3,9e0 <vprintf+0x5c>
            if (c == '%')
 9f6:	fd479ee3          	bne	a5,s4,9d2 <vprintf+0x4e>
                state = '%';
 9fa:	89be                	mv	s3,a5
 9fc:	b7e5                	j	9e4 <vprintf+0x60>
            if (c == 'd')
 9fe:	05878063          	beq	a5,s8,a3e <vprintf+0xba>
            else if (c == 'l')
 a02:	05978c63          	beq	a5,s9,a5a <vprintf+0xd6>
            else if (c == 'x')
 a06:	07a78863          	beq	a5,s10,a76 <vprintf+0xf2>
            else if (c == 'p')
 a0a:	09b78463          	beq	a5,s11,a92 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 a0e:	07300713          	li	a4,115
 a12:	0ce78663          	beq	a5,a4,ade <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 a16:	06300713          	li	a4,99
 a1a:	0ee78e63          	beq	a5,a4,b16 <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 a1e:	11478863          	beq	a5,s4,b2e <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 a22:	85d2                	mv	a1,s4
 a24:	8556                	mv	a0,s5
 a26:	00000097          	auipc	ra,0x0
 a2a:	e92080e7          	jalr	-366(ra) # 8b8 <putc>
                putc(fd, c);
 a2e:	85ca                	mv	a1,s2
 a30:	8556                	mv	a0,s5
 a32:	00000097          	auipc	ra,0x0
 a36:	e86080e7          	jalr	-378(ra) # 8b8 <putc>
            }
            state = 0;
 a3a:	4981                	li	s3,0
 a3c:	b765                	j	9e4 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 a3e:	008b0913          	addi	s2,s6,8
 a42:	4685                	li	a3,1
 a44:	4629                	li	a2,10
 a46:	000b2583          	lw	a1,0(s6)
 a4a:	8556                	mv	a0,s5
 a4c:	00000097          	auipc	ra,0x0
 a50:	e8e080e7          	jalr	-370(ra) # 8da <printint>
 a54:	8b4a                	mv	s6,s2
            state = 0;
 a56:	4981                	li	s3,0
 a58:	b771                	j	9e4 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 a5a:	008b0913          	addi	s2,s6,8
 a5e:	4681                	li	a3,0
 a60:	4629                	li	a2,10
 a62:	000b2583          	lw	a1,0(s6)
 a66:	8556                	mv	a0,s5
 a68:	00000097          	auipc	ra,0x0
 a6c:	e72080e7          	jalr	-398(ra) # 8da <printint>
 a70:	8b4a                	mv	s6,s2
            state = 0;
 a72:	4981                	li	s3,0
 a74:	bf85                	j	9e4 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 a76:	008b0913          	addi	s2,s6,8
 a7a:	4681                	li	a3,0
 a7c:	4641                	li	a2,16
 a7e:	000b2583          	lw	a1,0(s6)
 a82:	8556                	mv	a0,s5
 a84:	00000097          	auipc	ra,0x0
 a88:	e56080e7          	jalr	-426(ra) # 8da <printint>
 a8c:	8b4a                	mv	s6,s2
            state = 0;
 a8e:	4981                	li	s3,0
 a90:	bf91                	j	9e4 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 a92:	008b0793          	addi	a5,s6,8
 a96:	f8f43423          	sd	a5,-120(s0)
 a9a:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 a9e:	03000593          	li	a1,48
 aa2:	8556                	mv	a0,s5
 aa4:	00000097          	auipc	ra,0x0
 aa8:	e14080e7          	jalr	-492(ra) # 8b8 <putc>
    putc(fd, 'x');
 aac:	85ea                	mv	a1,s10
 aae:	8556                	mv	a0,s5
 ab0:	00000097          	auipc	ra,0x0
 ab4:	e08080e7          	jalr	-504(ra) # 8b8 <putc>
 ab8:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aba:	03c9d793          	srli	a5,s3,0x3c
 abe:	97de                	add	a5,a5,s7
 ac0:	0007c583          	lbu	a1,0(a5)
 ac4:	8556                	mv	a0,s5
 ac6:	00000097          	auipc	ra,0x0
 aca:	df2080e7          	jalr	-526(ra) # 8b8 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ace:	0992                	slli	s3,s3,0x4
 ad0:	397d                	addiw	s2,s2,-1
 ad2:	fe0914e3          	bnez	s2,aba <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 ad6:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 ada:	4981                	li	s3,0
 adc:	b721                	j	9e4 <vprintf+0x60>
                s = va_arg(ap, char *);
 ade:	008b0993          	addi	s3,s6,8
 ae2:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 ae6:	02090163          	beqz	s2,b08 <vprintf+0x184>
                while (*s != 0)
 aea:	00094583          	lbu	a1,0(s2)
 aee:	c9a1                	beqz	a1,b3e <vprintf+0x1ba>
                    putc(fd, *s);
 af0:	8556                	mv	a0,s5
 af2:	00000097          	auipc	ra,0x0
 af6:	dc6080e7          	jalr	-570(ra) # 8b8 <putc>
                    s++;
 afa:	0905                	addi	s2,s2,1
                while (*s != 0)
 afc:	00094583          	lbu	a1,0(s2)
 b00:	f9e5                	bnez	a1,af0 <vprintf+0x16c>
                s = va_arg(ap, char *);
 b02:	8b4e                	mv	s6,s3
            state = 0;
 b04:	4981                	li	s3,0
 b06:	bdf9                	j	9e4 <vprintf+0x60>
                    s = "(null)";
 b08:	00000917          	auipc	s2,0x0
 b0c:	3a890913          	addi	s2,s2,936 # eb0 <malloc+0x262>
                while (*s != 0)
 b10:	02800593          	li	a1,40
 b14:	bff1                	j	af0 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 b16:	008b0913          	addi	s2,s6,8
 b1a:	000b4583          	lbu	a1,0(s6)
 b1e:	8556                	mv	a0,s5
 b20:	00000097          	auipc	ra,0x0
 b24:	d98080e7          	jalr	-616(ra) # 8b8 <putc>
 b28:	8b4a                	mv	s6,s2
            state = 0;
 b2a:	4981                	li	s3,0
 b2c:	bd65                	j	9e4 <vprintf+0x60>
                putc(fd, c);
 b2e:	85d2                	mv	a1,s4
 b30:	8556                	mv	a0,s5
 b32:	00000097          	auipc	ra,0x0
 b36:	d86080e7          	jalr	-634(ra) # 8b8 <putc>
            state = 0;
 b3a:	4981                	li	s3,0
 b3c:	b565                	j	9e4 <vprintf+0x60>
                s = va_arg(ap, char *);
 b3e:	8b4e                	mv	s6,s3
            state = 0;
 b40:	4981                	li	s3,0
 b42:	b54d                	j	9e4 <vprintf+0x60>
        }
    }
}
 b44:	70e6                	ld	ra,120(sp)
 b46:	7446                	ld	s0,112(sp)
 b48:	74a6                	ld	s1,104(sp)
 b4a:	7906                	ld	s2,96(sp)
 b4c:	69e6                	ld	s3,88(sp)
 b4e:	6a46                	ld	s4,80(sp)
 b50:	6aa6                	ld	s5,72(sp)
 b52:	6b06                	ld	s6,64(sp)
 b54:	7be2                	ld	s7,56(sp)
 b56:	7c42                	ld	s8,48(sp)
 b58:	7ca2                	ld	s9,40(sp)
 b5a:	7d02                	ld	s10,32(sp)
 b5c:	6de2                	ld	s11,24(sp)
 b5e:	6109                	addi	sp,sp,128
 b60:	8082                	ret

0000000000000b62 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 b62:	715d                	addi	sp,sp,-80
 b64:	ec06                	sd	ra,24(sp)
 b66:	e822                	sd	s0,16(sp)
 b68:	1000                	addi	s0,sp,32
 b6a:	e010                	sd	a2,0(s0)
 b6c:	e414                	sd	a3,8(s0)
 b6e:	e818                	sd	a4,16(s0)
 b70:	ec1c                	sd	a5,24(s0)
 b72:	03043023          	sd	a6,32(s0)
 b76:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 b7a:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 b7e:	8622                	mv	a2,s0
 b80:	00000097          	auipc	ra,0x0
 b84:	e04080e7          	jalr	-508(ra) # 984 <vprintf>
}
 b88:	60e2                	ld	ra,24(sp)
 b8a:	6442                	ld	s0,16(sp)
 b8c:	6161                	addi	sp,sp,80
 b8e:	8082                	ret

0000000000000b90 <printf>:

void printf(const char *fmt, ...)
{
 b90:	711d                	addi	sp,sp,-96
 b92:	ec06                	sd	ra,24(sp)
 b94:	e822                	sd	s0,16(sp)
 b96:	1000                	addi	s0,sp,32
 b98:	e40c                	sd	a1,8(s0)
 b9a:	e810                	sd	a2,16(s0)
 b9c:	ec14                	sd	a3,24(s0)
 b9e:	f018                	sd	a4,32(s0)
 ba0:	f41c                	sd	a5,40(s0)
 ba2:	03043823          	sd	a6,48(s0)
 ba6:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 baa:	00840613          	addi	a2,s0,8
 bae:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 bb2:	85aa                	mv	a1,a0
 bb4:	4505                	li	a0,1
 bb6:	00000097          	auipc	ra,0x0
 bba:	dce080e7          	jalr	-562(ra) # 984 <vprintf>
}
 bbe:	60e2                	ld	ra,24(sp)
 bc0:	6442                	ld	s0,16(sp)
 bc2:	6125                	addi	sp,sp,96
 bc4:	8082                	ret

0000000000000bc6 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 bc6:	1141                	addi	sp,sp,-16
 bc8:	e422                	sd	s0,8(sp)
 bca:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 bcc:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd0:	00000797          	auipc	a5,0x0
 bd4:	3007b783          	ld	a5,768(a5) # ed0 <freep>
 bd8:	a805                	j	c08 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 bda:	4618                	lw	a4,8(a2)
 bdc:	9db9                	addw	a1,a1,a4
 bde:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 be2:	6398                	ld	a4,0(a5)
 be4:	6318                	ld	a4,0(a4)
 be6:	fee53823          	sd	a4,-16(a0)
 bea:	a091                	j	c2e <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 bec:	ff852703          	lw	a4,-8(a0)
 bf0:	9e39                	addw	a2,a2,a4
 bf2:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 bf4:	ff053703          	ld	a4,-16(a0)
 bf8:	e398                	sd	a4,0(a5)
 bfa:	a099                	j	c40 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bfc:	6398                	ld	a4,0(a5)
 bfe:	00e7e463          	bltu	a5,a4,c06 <free+0x40>
 c02:	00e6ea63          	bltu	a3,a4,c16 <free+0x50>
{
 c06:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c08:	fed7fae3          	bgeu	a5,a3,bfc <free+0x36>
 c0c:	6398                	ld	a4,0(a5)
 c0e:	00e6e463          	bltu	a3,a4,c16 <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c12:	fee7eae3          	bltu	a5,a4,c06 <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 c16:	ff852583          	lw	a1,-8(a0)
 c1a:	6390                	ld	a2,0(a5)
 c1c:	02059713          	slli	a4,a1,0x20
 c20:	9301                	srli	a4,a4,0x20
 c22:	0712                	slli	a4,a4,0x4
 c24:	9736                	add	a4,a4,a3
 c26:	fae60ae3          	beq	a2,a4,bda <free+0x14>
        bp->s.ptr = p->s.ptr;
 c2a:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 c2e:	4790                	lw	a2,8(a5)
 c30:	02061713          	slli	a4,a2,0x20
 c34:	9301                	srli	a4,a4,0x20
 c36:	0712                	slli	a4,a4,0x4
 c38:	973e                	add	a4,a4,a5
 c3a:	fae689e3          	beq	a3,a4,bec <free+0x26>
    }
    else
        p->s.ptr = bp;
 c3e:	e394                	sd	a3,0(a5)
    freep = p;
 c40:	00000717          	auipc	a4,0x0
 c44:	28f73823          	sd	a5,656(a4) # ed0 <freep>
}
 c48:	6422                	ld	s0,8(sp)
 c4a:	0141                	addi	sp,sp,16
 c4c:	8082                	ret

0000000000000c4e <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 c4e:	7139                	addi	sp,sp,-64
 c50:	fc06                	sd	ra,56(sp)
 c52:	f822                	sd	s0,48(sp)
 c54:	f426                	sd	s1,40(sp)
 c56:	f04a                	sd	s2,32(sp)
 c58:	ec4e                	sd	s3,24(sp)
 c5a:	e852                	sd	s4,16(sp)
 c5c:	e456                	sd	s5,8(sp)
 c5e:	e05a                	sd	s6,0(sp)
 c60:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 c62:	02051493          	slli	s1,a0,0x20
 c66:	9081                	srli	s1,s1,0x20
 c68:	04bd                	addi	s1,s1,15
 c6a:	8091                	srli	s1,s1,0x4
 c6c:	0014899b          	addiw	s3,s1,1
 c70:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 c72:	00000517          	auipc	a0,0x0
 c76:	25e53503          	ld	a0,606(a0) # ed0 <freep>
 c7a:	c515                	beqz	a0,ca6 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 c7c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 c7e:	4798                	lw	a4,8(a5)
 c80:	02977f63          	bgeu	a4,s1,cbe <malloc+0x70>
 c84:	8a4e                	mv	s4,s3
 c86:	0009871b          	sext.w	a4,s3
 c8a:	6685                	lui	a3,0x1
 c8c:	00d77363          	bgeu	a4,a3,c92 <malloc+0x44>
 c90:	6a05                	lui	s4,0x1
 c92:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 c96:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 c9a:	00000917          	auipc	s2,0x0
 c9e:	23690913          	addi	s2,s2,566 # ed0 <freep>
    if (p == (char *)-1)
 ca2:	5afd                	li	s5,-1
 ca4:	a88d                	j	d16 <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 ca6:	00000797          	auipc	a5,0x0
 caa:	23278793          	addi	a5,a5,562 # ed8 <base>
 cae:	00000717          	auipc	a4,0x0
 cb2:	22f73123          	sd	a5,546(a4) # ed0 <freep>
 cb6:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 cb8:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 cbc:	b7e1                	j	c84 <malloc+0x36>
            if (p->s.size == nunits)
 cbe:	02e48b63          	beq	s1,a4,cf4 <malloc+0xa6>
                p->s.size -= nunits;
 cc2:	4137073b          	subw	a4,a4,s3
 cc6:	c798                	sw	a4,8(a5)
                p += p->s.size;
 cc8:	1702                	slli	a4,a4,0x20
 cca:	9301                	srli	a4,a4,0x20
 ccc:	0712                	slli	a4,a4,0x4
 cce:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 cd0:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 cd4:	00000717          	auipc	a4,0x0
 cd8:	1ea73e23          	sd	a0,508(a4) # ed0 <freep>
            return (void *)(p + 1);
 cdc:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 ce0:	70e2                	ld	ra,56(sp)
 ce2:	7442                	ld	s0,48(sp)
 ce4:	74a2                	ld	s1,40(sp)
 ce6:	7902                	ld	s2,32(sp)
 ce8:	69e2                	ld	s3,24(sp)
 cea:	6a42                	ld	s4,16(sp)
 cec:	6aa2                	ld	s5,8(sp)
 cee:	6b02                	ld	s6,0(sp)
 cf0:	6121                	addi	sp,sp,64
 cf2:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 cf4:	6398                	ld	a4,0(a5)
 cf6:	e118                	sd	a4,0(a0)
 cf8:	bff1                	j	cd4 <malloc+0x86>
    hp->s.size = nu;
 cfa:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 cfe:	0541                	addi	a0,a0,16
 d00:	00000097          	auipc	ra,0x0
 d04:	ec6080e7          	jalr	-314(ra) # bc6 <free>
    return freep;
 d08:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 d0c:	d971                	beqz	a0,ce0 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 d0e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 d10:	4798                	lw	a4,8(a5)
 d12:	fa9776e3          	bgeu	a4,s1,cbe <malloc+0x70>
        if (p == freep)
 d16:	00093703          	ld	a4,0(s2)
 d1a:	853e                	mv	a0,a5
 d1c:	fef719e3          	bne	a4,a5,d0e <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 d20:	8552                	mv	a0,s4
 d22:	00000097          	auipc	ra,0x0
 d26:	b3e080e7          	jalr	-1218(ra) # 860 <sbrk>
    if (p == (char *)-1)
 d2a:	fd5518e3          	bne	a0,s5,cfa <malloc+0xac>
                return 0;
 d2e:	4501                	li	a0,0
 d30:	bf45                	j	ce0 <malloc+0x92>
