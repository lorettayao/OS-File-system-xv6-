
user/_mp4_1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_1>:
    tests[n]();
    exit(0);
}

void test_1()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (open("test1", O_RDONLY) < 0)
   8:	4581                	li	a1,0
   a:	00001517          	auipc	a0,0x1
   e:	d1e50513          	addi	a0,a0,-738 # d28 <malloc+0xe4>
  12:	00000097          	auipc	ra,0x0
  16:	7fc080e7          	jalr	2044(ra) # 80e <open>
  1a:	02054c63          	bltz	a0,52 <test_1+0x52>
        fprintf(2, "open test1 failed\n");

    if (open("test1/a", O_RDONLY) < 0)
  1e:	4581                	li	a1,0
  20:	00001517          	auipc	a0,0x1
  24:	d2850513          	addi	a0,a0,-728 # d48 <malloc+0x104>
  28:	00000097          	auipc	ra,0x0
  2c:	7e6080e7          	jalr	2022(ra) # 80e <open>
  30:	02054b63          	bltz	a0,66 <test_1+0x66>
        fprintf(2, "open test1/a failed\n");

    if (open("test1/d", O_RDONLY) < 0)
  34:	4581                	li	a1,0
  36:	00001517          	auipc	a0,0x1
  3a:	d3250513          	addi	a0,a0,-718 # d68 <malloc+0x124>
  3e:	00000097          	auipc	ra,0x0
  42:	7d0080e7          	jalr	2000(ra) # 80e <open>
  46:	02054a63          	bltz	a0,7a <test_1+0x7a>
        fprintf(2, "open test1/d failed\n");

    return;
}
  4a:	60a2                	ld	ra,8(sp)
  4c:	6402                	ld	s0,0(sp)
  4e:	0141                	addi	sp,sp,16
  50:	8082                	ret
        fprintf(2, "open test1 failed\n");
  52:	00001597          	auipc	a1,0x1
  56:	cde58593          	addi	a1,a1,-802 # d30 <malloc+0xec>
  5a:	4509                	li	a0,2
  5c:	00001097          	auipc	ra,0x1
  60:	afc080e7          	jalr	-1284(ra) # b58 <fprintf>
  64:	bf6d                	j	1e <test_1+0x1e>
        fprintf(2, "open test1/a failed\n");
  66:	00001597          	auipc	a1,0x1
  6a:	cea58593          	addi	a1,a1,-790 # d50 <malloc+0x10c>
  6e:	4509                	li	a0,2
  70:	00001097          	auipc	ra,0x1
  74:	ae8080e7          	jalr	-1304(ra) # b58 <fprintf>
  78:	bf75                	j	34 <test_1+0x34>
        fprintf(2, "open test1/d failed\n");
  7a:	00001597          	auipc	a1,0x1
  7e:	cf658593          	addi	a1,a1,-778 # d70 <malloc+0x12c>
  82:	4509                	li	a0,2
  84:	00001097          	auipc	ra,0x1
  88:	ad4080e7          	jalr	-1324(ra) # b58 <fprintf>
    return;
  8c:	bf7d                	j	4a <test_1+0x4a>

000000000000008e <test_2>:

void test_2()
{
  8e:	715d                	addi	sp,sp,-80
  90:	e486                	sd	ra,72(sp)
  92:	e0a2                	sd	s0,64(sp)
  94:	fc26                	sd	s1,56(sp)
  96:	0880                	addi	s0,sp,80
    int fd;
    char buf[10];
    struct stat st;

    if (open("test2", O_NOACCESS) < 0)
  98:	4591                	li	a1,4
  9a:	00001517          	auipc	a0,0x1
  9e:	cee50513          	addi	a0,a0,-786 # d88 <malloc+0x144>
  a2:	00000097          	auipc	ra,0x0
  a6:	76c080e7          	jalr	1900(ra) # 80e <open>
  aa:	06054763          	bltz	a0,118 <test_2+0x8a>
        fprintf(2, "open test2 failed\n");

    if (open("test2_fake", O_NOACCESS) < 0)
  ae:	4591                	li	a1,4
  b0:	00001517          	auipc	a0,0x1
  b4:	cf850513          	addi	a0,a0,-776 # da8 <malloc+0x164>
  b8:	00000097          	auipc	ra,0x0
  bc:	756080e7          	jalr	1878(ra) # 80e <open>
  c0:	06054663          	bltz	a0,12c <test_2+0x9e>
        fprintf(2, "open test2_fake (1) failed\n");

    if (open("test2_fake", O_RDONLY) < 0)
  c4:	4581                	li	a1,0
  c6:	00001517          	auipc	a0,0x1
  ca:	ce250513          	addi	a0,a0,-798 # da8 <malloc+0x164>
  ce:	00000097          	auipc	ra,0x0
  d2:	740080e7          	jalr	1856(ra) # 80e <open>
  d6:	06054563          	bltz	a0,140 <test_2+0xb2>
        fprintf(2, "open test2_fake (2) failed\n");

    if ((fd = open("test2_fake/d2/f2", O_NOACCESS)) < 0)
  da:	4591                	li	a1,4
  dc:	00001517          	auipc	a0,0x1
  e0:	d1c50513          	addi	a0,a0,-740 # df8 <malloc+0x1b4>
  e4:	00000097          	auipc	ra,0x0
  e8:	72a080e7          	jalr	1834(ra) # 80e <open>
  ec:	06054463          	bltz	a0,154 <test_2+0xc6>
        fprintf(2, "open test2_fake/d2/f2 failed\n");
    else
    {
        if (read(fd, buf, 10) < 0)
  f0:	4629                	li	a2,10
  f2:	fd040593          	addi	a1,s0,-48
  f6:	00000097          	auipc	ra,0x0
  fa:	6f0080e7          	jalr	1776(ra) # 7e6 <read>
  fe:	0e054263          	bltz	a0,1e2 <test_2+0x154>
            fprintf(2, "read test2_fake/d2/f2 failed\n");
        else
            printf("buf = %s\n", buf);
 102:	fd040593          	addi	a1,s0,-48
 106:	00001517          	auipc	a0,0x1
 10a:	d4a50513          	addi	a0,a0,-694 # e50 <malloc+0x20c>
 10e:	00001097          	auipc	ra,0x1
 112:	a78080e7          	jalr	-1416(ra) # b86 <printf>
 116:	a881                	j	166 <test_2+0xd8>
        fprintf(2, "open test2 failed\n");
 118:	00001597          	auipc	a1,0x1
 11c:	c7858593          	addi	a1,a1,-904 # d90 <malloc+0x14c>
 120:	4509                	li	a0,2
 122:	00001097          	auipc	ra,0x1
 126:	a36080e7          	jalr	-1482(ra) # b58 <fprintf>
 12a:	b751                	j	ae <test_2+0x20>
        fprintf(2, "open test2_fake (1) failed\n");
 12c:	00001597          	auipc	a1,0x1
 130:	c8c58593          	addi	a1,a1,-884 # db8 <malloc+0x174>
 134:	4509                	li	a0,2
 136:	00001097          	auipc	ra,0x1
 13a:	a22080e7          	jalr	-1502(ra) # b58 <fprintf>
 13e:	b759                	j	c4 <test_2+0x36>
        fprintf(2, "open test2_fake (2) failed\n");
 140:	00001597          	auipc	a1,0x1
 144:	c9858593          	addi	a1,a1,-872 # dd8 <malloc+0x194>
 148:	4509                	li	a0,2
 14a:	00001097          	auipc	ra,0x1
 14e:	a0e080e7          	jalr	-1522(ra) # b58 <fprintf>
 152:	b761                	j	da <test_2+0x4c>
        fprintf(2, "open test2_fake/d2/f2 failed\n");
 154:	00001597          	auipc	a1,0x1
 158:	cbc58593          	addi	a1,a1,-836 # e10 <malloc+0x1cc>
 15c:	4509                	li	a0,2
 15e:	00001097          	auipc	ra,0x1
 162:	9fa080e7          	jalr	-1542(ra) # b58 <fprintf>
    }

    if ((fd = open("test2_fake/d1/f1", O_NOACCESS)) < 0)
 166:	4591                	li	a1,4
 168:	00001517          	auipc	a0,0x1
 16c:	cf850513          	addi	a0,a0,-776 # e60 <malloc+0x21c>
 170:	00000097          	auipc	ra,0x0
 174:	69e080e7          	jalr	1694(ra) # 80e <open>
 178:	84aa                	mv	s1,a0
 17a:	06054e63          	bltz	a0,1f6 <test_2+0x168>
        fprintf(2, "open test2_fake/d1/f1 failed\n");
    else
    {
        if (read(fd, buf, 10) < 0)
 17e:	4629                	li	a2,10
 180:	fd040593          	addi	a1,s0,-48
 184:	00000097          	auipc	ra,0x0
 188:	662080e7          	jalr	1634(ra) # 7e6 <read>
 18c:	06054f63          	bltz	a0,20a <test_2+0x17c>
            fprintf(2, "read test2_fake/d1/f1 failed\n");
        else
            printf("buf = %s\n", buf);
 190:	fd040593          	addi	a1,s0,-48
 194:	00001517          	auipc	a0,0x1
 198:	cbc50513          	addi	a0,a0,-836 # e50 <malloc+0x20c>
 19c:	00001097          	auipc	ra,0x1
 1a0:	9ea080e7          	jalr	-1558(ra) # b86 <printf>

        if (fstat(fd, &st) < 0)
 1a4:	fb040593          	addi	a1,s0,-80
 1a8:	8526                	mv	a0,s1
 1aa:	00000097          	auipc	ra,0x0
 1ae:	67c080e7          	jalr	1660(ra) # 826 <fstat>
 1b2:	06054663          	bltz	a0,21e <test_2+0x190>
            fprintf(2, "fstat test2_fake/d1/f1 failed\n");
        else
            printf("type of test2_fake/d1/f1 is %d\n", st.type);
 1b6:	fb841583          	lh	a1,-72(s0)
 1ba:	00001517          	auipc	a0,0x1
 1be:	d1e50513          	addi	a0,a0,-738 # ed8 <malloc+0x294>
 1c2:	00001097          	auipc	ra,0x1
 1c6:	9c4080e7          	jalr	-1596(ra) # b86 <printf>
    }

    if (fd > 0)
 1ca:	00905763          	blez	s1,1d8 <test_2+0x14a>
        close(fd);
 1ce:	8526                	mv	a0,s1
 1d0:	00000097          	auipc	ra,0x0
 1d4:	626080e7          	jalr	1574(ra) # 7f6 <close>

    return;
}
 1d8:	60a6                	ld	ra,72(sp)
 1da:	6406                	ld	s0,64(sp)
 1dc:	74e2                	ld	s1,56(sp)
 1de:	6161                	addi	sp,sp,80
 1e0:	8082                	ret
            fprintf(2, "read test2_fake/d2/f2 failed\n");
 1e2:	00001597          	auipc	a1,0x1
 1e6:	c4e58593          	addi	a1,a1,-946 # e30 <malloc+0x1ec>
 1ea:	4509                	li	a0,2
 1ec:	00001097          	auipc	ra,0x1
 1f0:	96c080e7          	jalr	-1684(ra) # b58 <fprintf>
 1f4:	bf8d                	j	166 <test_2+0xd8>
        fprintf(2, "open test2_fake/d1/f1 failed\n");
 1f6:	00001597          	auipc	a1,0x1
 1fa:	c8258593          	addi	a1,a1,-894 # e78 <malloc+0x234>
 1fe:	4509                	li	a0,2
 200:	00001097          	auipc	ra,0x1
 204:	958080e7          	jalr	-1704(ra) # b58 <fprintf>
    if (fd > 0)
 208:	bfc1                	j	1d8 <test_2+0x14a>
            fprintf(2, "read test2_fake/d1/f1 failed\n");
 20a:	00001597          	auipc	a1,0x1
 20e:	c8e58593          	addi	a1,a1,-882 # e98 <malloc+0x254>
 212:	4509                	li	a0,2
 214:	00001097          	auipc	ra,0x1
 218:	944080e7          	jalr	-1724(ra) # b58 <fprintf>
 21c:	b761                	j	1a4 <test_2+0x116>
            fprintf(2, "fstat test2_fake/d1/f1 failed\n");
 21e:	00001597          	auipc	a1,0x1
 222:	c9a58593          	addi	a1,a1,-870 # eb8 <malloc+0x274>
 226:	4509                	li	a0,2
 228:	00001097          	auipc	ra,0x1
 22c:	930080e7          	jalr	-1744(ra) # b58 <fprintf>
 230:	bf69                	j	1ca <test_2+0x13c>

0000000000000232 <test_3>:

void test_3()
{
 232:	7139                	addi	sp,sp,-64
 234:	fc06                	sd	ra,56(sp)
 236:	f822                	sd	s0,48(sp)
 238:	f426                	sd	s1,40(sp)
 23a:	0080                	addi	s0,sp,64
    int fd;
    struct stat st;

    if ((fd = open("test3/d1ln_4", O_NOACCESS)) < 0)
 23c:	4591                	li	a1,4
 23e:	00001517          	auipc	a0,0x1
 242:	cba50513          	addi	a0,a0,-838 # ef8 <malloc+0x2b4>
 246:	00000097          	auipc	ra,0x0
 24a:	5c8080e7          	jalr	1480(ra) # 80e <open>
 24e:	02054563          	bltz	a0,278 <test_3+0x46>
        fprintf(2, "open test3/d1ln_4 failed\n");
    else
    {
        if (fstat(fd, &st) < 0)
 252:	fc040593          	addi	a1,s0,-64
 256:	00000097          	auipc	ra,0x0
 25a:	5d0080e7          	jalr	1488(ra) # 826 <fstat>
 25e:	06054463          	bltz	a0,2c6 <test_3+0x94>
            fprintf(2, "fstat test3/d1ln_4 failed\n");
        else
            printf("type of test3/d1ln_4 is %d\n", st.type);
 262:	fc841583          	lh	a1,-56(s0)
 266:	00001517          	auipc	a0,0x1
 26a:	ce250513          	addi	a0,a0,-798 # f48 <malloc+0x304>
 26e:	00001097          	auipc	ra,0x1
 272:	918080e7          	jalr	-1768(ra) # b86 <printf>
 276:	a811                	j	28a <test_3+0x58>
        fprintf(2, "open test3/d1ln_4 failed\n");
 278:	00001597          	auipc	a1,0x1
 27c:	c9058593          	addi	a1,a1,-880 # f08 <malloc+0x2c4>
 280:	4509                	li	a0,2
 282:	00001097          	auipc	ra,0x1
 286:	8d6080e7          	jalr	-1834(ra) # b58 <fprintf>
    }

    if ((fd = open("test3/d1ln_4", O_RDONLY)) < 0)
 28a:	4581                	li	a1,0
 28c:	00001517          	auipc	a0,0x1
 290:	c6c50513          	addi	a0,a0,-916 # ef8 <malloc+0x2b4>
 294:	00000097          	auipc	ra,0x0
 298:	57a080e7          	jalr	1402(ra) # 80e <open>
 29c:	02054f63          	bltz	a0,2da <test_3+0xa8>
        fprintf(2, "open test3/d1ln_4 failed\n");
    else
    {
        if (fstat(fd, &st) < 0)
 2a0:	fc040593          	addi	a1,s0,-64
 2a4:	00000097          	auipc	ra,0x0
 2a8:	582080e7          	jalr	1410(ra) # 826 <fstat>
 2ac:	0a054563          	bltz	a0,356 <test_3+0x124>
            fprintf(2, "fstat test3/d1ln_4 failed\n");
        else
            printf("type of the target file test3/d1ln_4 pointing to is %d\n",
 2b0:	fc841583          	lh	a1,-56(s0)
 2b4:	00001517          	auipc	a0,0x1
 2b8:	cb450513          	addi	a0,a0,-844 # f68 <malloc+0x324>
 2bc:	00001097          	auipc	ra,0x1
 2c0:	8ca080e7          	jalr	-1846(ra) # b86 <printf>
 2c4:	a025                	j	2ec <test_3+0xba>
            fprintf(2, "fstat test3/d1ln_4 failed\n");
 2c6:	00001597          	auipc	a1,0x1
 2ca:	c6258593          	addi	a1,a1,-926 # f28 <malloc+0x2e4>
 2ce:	4509                	li	a0,2
 2d0:	00001097          	auipc	ra,0x1
 2d4:	888080e7          	jalr	-1912(ra) # b58 <fprintf>
 2d8:	bf4d                	j	28a <test_3+0x58>
        fprintf(2, "open test3/d1ln_4 failed\n");
 2da:	00001597          	auipc	a1,0x1
 2de:	c2e58593          	addi	a1,a1,-978 # f08 <malloc+0x2c4>
 2e2:	4509                	li	a0,2
 2e4:	00001097          	auipc	ra,0x1
 2e8:	874080e7          	jalr	-1932(ra) # b58 <fprintf>
                   st.type);
    }

    if ((fd = open("test3/Fln", O_RDWR)) < 0)
 2ec:	4589                	li	a1,2
 2ee:	00001517          	auipc	a0,0x1
 2f2:	cb250513          	addi	a0,a0,-846 # fa0 <malloc+0x35c>
 2f6:	00000097          	auipc	ra,0x0
 2fa:	518080e7          	jalr	1304(ra) # 80e <open>
 2fe:	06054663          	bltz	a0,36a <test_3+0x138>
        fprintf(2, "open test3/Fln (1) failed\n");

    if ((fd = open("test3/Fln", O_NOACCESS)) < 0)
 302:	4591                	li	a1,4
 304:	00001517          	auipc	a0,0x1
 308:	c9c50513          	addi	a0,a0,-868 # fa0 <malloc+0x35c>
 30c:	00000097          	auipc	ra,0x0
 310:	502080e7          	jalr	1282(ra) # 80e <open>
 314:	84aa                	mv	s1,a0
 316:	06054463          	bltz	a0,37e <test_3+0x14c>
        fprintf(2, "open test3/Fln (2) failed\n");
    else
    {
        if (fstat(fd, &st) < 0)
 31a:	fc040593          	addi	a1,s0,-64
 31e:	00000097          	auipc	ra,0x0
 322:	508080e7          	jalr	1288(ra) # 826 <fstat>
 326:	06054663          	bltz	a0,392 <test_3+0x160>
            fprintf(2, "fstat test3/Fln failed\n");
        else
            printf("type of test3/Fln is %d\n", st.type);
 32a:	fc841583          	lh	a1,-56(s0)
 32e:	00001517          	auipc	a0,0x1
 332:	cda50513          	addi	a0,a0,-806 # 1008 <malloc+0x3c4>
 336:	00001097          	auipc	ra,0x1
 33a:	850080e7          	jalr	-1968(ra) # b86 <printf>
    }

    if (fd > 0)
 33e:	00905763          	blez	s1,34c <test_3+0x11a>
        close(fd);
 342:	8526                	mv	a0,s1
 344:	00000097          	auipc	ra,0x0
 348:	4b2080e7          	jalr	1202(ra) # 7f6 <close>

    return;
}
 34c:	70e2                	ld	ra,56(sp)
 34e:	7442                	ld	s0,48(sp)
 350:	74a2                	ld	s1,40(sp)
 352:	6121                	addi	sp,sp,64
 354:	8082                	ret
            fprintf(2, "fstat test3/d1ln_4 failed\n");
 356:	00001597          	auipc	a1,0x1
 35a:	bd258593          	addi	a1,a1,-1070 # f28 <malloc+0x2e4>
 35e:	4509                	li	a0,2
 360:	00000097          	auipc	ra,0x0
 364:	7f8080e7          	jalr	2040(ra) # b58 <fprintf>
 368:	b751                	j	2ec <test_3+0xba>
        fprintf(2, "open test3/Fln (1) failed\n");
 36a:	00001597          	auipc	a1,0x1
 36e:	c4658593          	addi	a1,a1,-954 # fb0 <malloc+0x36c>
 372:	4509                	li	a0,2
 374:	00000097          	auipc	ra,0x0
 378:	7e4080e7          	jalr	2020(ra) # b58 <fprintf>
 37c:	b759                	j	302 <test_3+0xd0>
        fprintf(2, "open test3/Fln (2) failed\n");
 37e:	00001597          	auipc	a1,0x1
 382:	c5258593          	addi	a1,a1,-942 # fd0 <malloc+0x38c>
 386:	4509                	li	a0,2
 388:	00000097          	auipc	ra,0x0
 38c:	7d0080e7          	jalr	2000(ra) # b58 <fprintf>
    if (fd > 0)
 390:	bf75                	j	34c <test_3+0x11a>
            fprintf(2, "fstat test3/Fln failed\n");
 392:	00001597          	auipc	a1,0x1
 396:	c5e58593          	addi	a1,a1,-930 # ff0 <malloc+0x3ac>
 39a:	4509                	li	a0,2
 39c:	00000097          	auipc	ra,0x0
 3a0:	7bc080e7          	jalr	1980(ra) # b58 <fprintf>
 3a4:	bf69                	j	33e <test_3+0x10c>

00000000000003a6 <test_4>:

void test_4()
{
 3a6:	7139                	addi	sp,sp,-64
 3a8:	fc06                	sd	ra,56(sp)
 3aa:	f822                	sd	s0,48(sp)
 3ac:	f426                	sd	s1,40(sp)
 3ae:	0080                	addi	s0,sp,64
    int fd, r;
    char buf1[14], buf2[14];

    if ((fd = open("test4/aln1", O_WRONLY)) < 0)
 3b0:	4585                	li	a1,1
 3b2:	00001517          	auipc	a0,0x1
 3b6:	c7650513          	addi	a0,a0,-906 # 1028 <malloc+0x3e4>
 3ba:	00000097          	auipc	ra,0x0
 3be:	454080e7          	jalr	1108(ra) # 80e <open>
 3c2:	06054663          	bltz	a0,42e <test_4+0x88>
        fprintf(2, "open test4/aln1 failed\n");

    if ((fd = open("test4/dirXln1/a", O_WRONLY)) < 0)
 3c6:	4585                	li	a1,1
 3c8:	00001517          	auipc	a0,0x1
 3cc:	c8850513          	addi	a0,a0,-888 # 1050 <malloc+0x40c>
 3d0:	00000097          	auipc	ra,0x0
 3d4:	43e080e7          	jalr	1086(ra) # 80e <open>
 3d8:	84aa                	mv	s1,a0
 3da:	06054463          	bltz	a0,442 <test_4+0x9c>
    {
        fprintf(2, "open test4/dirXln1/a failed\n");
        return;
    }
    strcpy(buf1, "hello os2025");
 3de:	00001597          	auipc	a1,0x1
 3e2:	ca258593          	addi	a1,a1,-862 # 1080 <malloc+0x43c>
 3e6:	fd040513          	addi	a0,s0,-48
 3ea:	00000097          	auipc	ra,0x0
 3ee:	176080e7          	jalr	374(ra) # 560 <strcpy>
    if ((r = write(fd, buf1, 13)) != 13)
 3f2:	4635                	li	a2,13
 3f4:	fd040593          	addi	a1,s0,-48
 3f8:	8526                	mv	a0,s1
 3fa:	00000097          	auipc	ra,0x0
 3fe:	3f4080e7          	jalr	1012(ra) # 7ee <write>
 402:	47b5                	li	a5,13
 404:	04f50963          	beq	a0,a5,456 <test_4+0xb0>
    {
        fprintf(2, "write to test4/dirXln1/a failed\n");
 408:	00001597          	auipc	a1,0x1
 40c:	c8858593          	addi	a1,a1,-888 # 1090 <malloc+0x44c>
 410:	4509                	li	a0,2
 412:	00000097          	auipc	ra,0x0
 416:	746080e7          	jalr	1862(ra) # b58 <fprintf>
        close(fd);
 41a:	8526                	mv	a0,s1
 41c:	00000097          	auipc	ra,0x0
 420:	3da080e7          	jalr	986(ra) # 7f6 <close>

    if (fd > 0)
        close(fd);

    return;
}
 424:	70e2                	ld	ra,56(sp)
 426:	7442                	ld	s0,48(sp)
 428:	74a2                	ld	s1,40(sp)
 42a:	6121                	addi	sp,sp,64
 42c:	8082                	ret
        fprintf(2, "open test4/aln1 failed\n");
 42e:	00001597          	auipc	a1,0x1
 432:	c0a58593          	addi	a1,a1,-1014 # 1038 <malloc+0x3f4>
 436:	4509                	li	a0,2
 438:	00000097          	auipc	ra,0x0
 43c:	720080e7          	jalr	1824(ra) # b58 <fprintf>
 440:	b759                	j	3c6 <test_4+0x20>
        fprintf(2, "open test4/dirXln1/a failed\n");
 442:	00001597          	auipc	a1,0x1
 446:	c1e58593          	addi	a1,a1,-994 # 1060 <malloc+0x41c>
 44a:	4509                	li	a0,2
 44c:	00000097          	auipc	ra,0x0
 450:	70c080e7          	jalr	1804(ra) # b58 <fprintf>
        return;
 454:	bfc1                	j	424 <test_4+0x7e>
    close(fd);
 456:	8526                	mv	a0,s1
 458:	00000097          	auipc	ra,0x0
 45c:	39e080e7          	jalr	926(ra) # 7f6 <close>
    if ((fd = open("test4/dirXln1/a", O_RDONLY)) < 0)
 460:	4581                	li	a1,0
 462:	00001517          	auipc	a0,0x1
 466:	bee50513          	addi	a0,a0,-1042 # 1050 <malloc+0x40c>
 46a:	00000097          	auipc	ra,0x0
 46e:	3a4080e7          	jalr	932(ra) # 80e <open>
 472:	84aa                	mv	s1,a0
 474:	02054c63          	bltz	a0,4ac <test_4+0x106>
    if ((r = read(fd, buf2, 13)) != 13)
 478:	4635                	li	a2,13
 47a:	fc040593          	addi	a1,s0,-64
 47e:	00000097          	auipc	ra,0x0
 482:	368080e7          	jalr	872(ra) # 7e6 <read>
 486:	47b5                	li	a5,13
 488:	02f50c63          	beq	a0,a5,4c0 <test_4+0x11a>
        fprintf(2, "read test4/dirXln1/a failed, r = %d\n", r);
 48c:	862a                	mv	a2,a0
 48e:	00001597          	auipc	a1,0x1
 492:	c2a58593          	addi	a1,a1,-982 # 10b8 <malloc+0x474>
 496:	4509                	li	a0,2
 498:	00000097          	auipc	ra,0x0
 49c:	6c0080e7          	jalr	1728(ra) # b58 <fprintf>
        close(fd);
 4a0:	8526                	mv	a0,s1
 4a2:	00000097          	auipc	ra,0x0
 4a6:	354080e7          	jalr	852(ra) # 7f6 <close>
        return;
 4aa:	bfad                	j	424 <test_4+0x7e>
        fprintf(2, "open test4/dirXln1/a failed\n");
 4ac:	00001597          	auipc	a1,0x1
 4b0:	bb458593          	addi	a1,a1,-1100 # 1060 <malloc+0x41c>
 4b4:	4509                	li	a0,2
 4b6:	00000097          	auipc	ra,0x0
 4ba:	6a2080e7          	jalr	1698(ra) # b58 <fprintf>
        return;
 4be:	b79d                	j	424 <test_4+0x7e>
    printf("%s\n", buf2);
 4c0:	fc040593          	addi	a1,s0,-64
 4c4:	00001517          	auipc	a0,0x1
 4c8:	c1c50513          	addi	a0,a0,-996 # 10e0 <malloc+0x49c>
 4cc:	00000097          	auipc	ra,0x0
 4d0:	6ba080e7          	jalr	1722(ra) # b86 <printf>
    if (fd > 0)
 4d4:	f49058e3          	blez	s1,424 <test_4+0x7e>
        close(fd);
 4d8:	8526                	mv	a0,s1
 4da:	00000097          	auipc	ra,0x0
 4de:	31c080e7          	jalr	796(ra) # 7f6 <close>
 4e2:	b789                	j	424 <test_4+0x7e>

00000000000004e4 <main>:
{
 4e4:	7179                	addi	sp,sp,-48
 4e6:	f406                	sd	ra,40(sp)
 4e8:	f022                	sd	s0,32(sp)
 4ea:	1800                	addi	s0,sp,48
    if (argc != 2)
 4ec:	4789                	li	a5,2
 4ee:	02f50063          	beq	a0,a5,50e <main+0x2a>
        fprintf(2, "Usage: mp4_1 [n]\n");
 4f2:	00001597          	auipc	a1,0x1
 4f6:	bf658593          	addi	a1,a1,-1034 # 10e8 <malloc+0x4a4>
 4fa:	4509                	li	a0,2
 4fc:	00000097          	auipc	ra,0x0
 500:	65c080e7          	jalr	1628(ra) # b58 <fprintf>
        exit(1);
 504:	4505                	li	a0,1
 506:	00000097          	auipc	ra,0x0
 50a:	2c8080e7          	jalr	712(ra) # 7ce <exit>
    n = atoi(argv[1]);
 50e:	6588                	ld	a0,8(a1)
 510:	00000097          	auipc	ra,0x0
 514:	1c2080e7          	jalr	450(ra) # 6d2 <atoi>
    test_func_t tests[] = {test_1, test_2, test_3, test_4};
 518:	00000797          	auipc	a5,0x0
 51c:	ae878793          	addi	a5,a5,-1304 # 0 <test_1>
 520:	fcf43823          	sd	a5,-48(s0)
 524:	00000797          	auipc	a5,0x0
 528:	b6a78793          	addi	a5,a5,-1174 # 8e <test_2>
 52c:	fcf43c23          	sd	a5,-40(s0)
 530:	00000797          	auipc	a5,0x0
 534:	d0278793          	addi	a5,a5,-766 # 232 <test_3>
 538:	fef43023          	sd	a5,-32(s0)
 53c:	00000797          	auipc	a5,0x0
 540:	e6a78793          	addi	a5,a5,-406 # 3a6 <test_4>
 544:	fef43423          	sd	a5,-24(s0)
    tests[n]();
 548:	050e                	slli	a0,a0,0x3
 54a:	ff040793          	addi	a5,s0,-16
 54e:	953e                	add	a0,a0,a5
 550:	fe053783          	ld	a5,-32(a0)
 554:	9782                	jalr	a5
    exit(0);
 556:	4501                	li	a0,0
 558:	00000097          	auipc	ra,0x0
 55c:	276080e7          	jalr	630(ra) # 7ce <exit>

0000000000000560 <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 560:	1141                	addi	sp,sp,-16
 562:	e422                	sd	s0,8(sp)
 564:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 566:	87aa                	mv	a5,a0
 568:	0585                	addi	a1,a1,1
 56a:	0785                	addi	a5,a5,1
 56c:	fff5c703          	lbu	a4,-1(a1)
 570:	fee78fa3          	sb	a4,-1(a5)
 574:	fb75                	bnez	a4,568 <strcpy+0x8>
        ;
    return os;
}
 576:	6422                	ld	s0,8(sp)
 578:	0141                	addi	sp,sp,16
 57a:	8082                	ret

000000000000057c <strcmp>:

int strcmp(const char *p, const char *q)
{
 57c:	1141                	addi	sp,sp,-16
 57e:	e422                	sd	s0,8(sp)
 580:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 582:	00054783          	lbu	a5,0(a0)
 586:	cb91                	beqz	a5,59a <strcmp+0x1e>
 588:	0005c703          	lbu	a4,0(a1)
 58c:	00f71763          	bne	a4,a5,59a <strcmp+0x1e>
        p++, q++;
 590:	0505                	addi	a0,a0,1
 592:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 594:	00054783          	lbu	a5,0(a0)
 598:	fbe5                	bnez	a5,588 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 59a:	0005c503          	lbu	a0,0(a1)
}
 59e:	40a7853b          	subw	a0,a5,a0
 5a2:	6422                	ld	s0,8(sp)
 5a4:	0141                	addi	sp,sp,16
 5a6:	8082                	ret

00000000000005a8 <strlen>:

uint strlen(const char *s)
{
 5a8:	1141                	addi	sp,sp,-16
 5aa:	e422                	sd	s0,8(sp)
 5ac:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 5ae:	00054783          	lbu	a5,0(a0)
 5b2:	cf91                	beqz	a5,5ce <strlen+0x26>
 5b4:	0505                	addi	a0,a0,1
 5b6:	87aa                	mv	a5,a0
 5b8:	4685                	li	a3,1
 5ba:	9e89                	subw	a3,a3,a0
 5bc:	00f6853b          	addw	a0,a3,a5
 5c0:	0785                	addi	a5,a5,1
 5c2:	fff7c703          	lbu	a4,-1(a5)
 5c6:	fb7d                	bnez	a4,5bc <strlen+0x14>
        ;
    return n;
}
 5c8:	6422                	ld	s0,8(sp)
 5ca:	0141                	addi	sp,sp,16
 5cc:	8082                	ret
    for (n = 0; s[n]; n++)
 5ce:	4501                	li	a0,0
 5d0:	bfe5                	j	5c8 <strlen+0x20>

00000000000005d2 <memset>:

void *memset(void *dst, int c, uint n)
{
 5d2:	1141                	addi	sp,sp,-16
 5d4:	e422                	sd	s0,8(sp)
 5d6:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 5d8:	ca19                	beqz	a2,5ee <memset+0x1c>
 5da:	87aa                	mv	a5,a0
 5dc:	1602                	slli	a2,a2,0x20
 5de:	9201                	srli	a2,a2,0x20
 5e0:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 5e4:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 5e8:	0785                	addi	a5,a5,1
 5ea:	fee79de3          	bne	a5,a4,5e4 <memset+0x12>
    }
    return dst;
}
 5ee:	6422                	ld	s0,8(sp)
 5f0:	0141                	addi	sp,sp,16
 5f2:	8082                	ret

00000000000005f4 <strchr>:

char *strchr(const char *s, char c)
{
 5f4:	1141                	addi	sp,sp,-16
 5f6:	e422                	sd	s0,8(sp)
 5f8:	0800                	addi	s0,sp,16
    for (; *s; s++)
 5fa:	00054783          	lbu	a5,0(a0)
 5fe:	cb99                	beqz	a5,614 <strchr+0x20>
        if (*s == c)
 600:	00f58763          	beq	a1,a5,60e <strchr+0x1a>
    for (; *s; s++)
 604:	0505                	addi	a0,a0,1
 606:	00054783          	lbu	a5,0(a0)
 60a:	fbfd                	bnez	a5,600 <strchr+0xc>
            return (char *)s;
    return 0;
 60c:	4501                	li	a0,0
}
 60e:	6422                	ld	s0,8(sp)
 610:	0141                	addi	sp,sp,16
 612:	8082                	ret
    return 0;
 614:	4501                	li	a0,0
 616:	bfe5                	j	60e <strchr+0x1a>

0000000000000618 <gets>:

char *gets(char *buf, int max)
{
 618:	711d                	addi	sp,sp,-96
 61a:	ec86                	sd	ra,88(sp)
 61c:	e8a2                	sd	s0,80(sp)
 61e:	e4a6                	sd	s1,72(sp)
 620:	e0ca                	sd	s2,64(sp)
 622:	fc4e                	sd	s3,56(sp)
 624:	f852                	sd	s4,48(sp)
 626:	f456                	sd	s5,40(sp)
 628:	f05a                	sd	s6,32(sp)
 62a:	ec5e                	sd	s7,24(sp)
 62c:	1080                	addi	s0,sp,96
 62e:	8baa                	mv	s7,a0
 630:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 632:	892a                	mv	s2,a0
 634:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 636:	4aa9                	li	s5,10
 638:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 63a:	89a6                	mv	s3,s1
 63c:	2485                	addiw	s1,s1,1
 63e:	0344d863          	bge	s1,s4,66e <gets+0x56>
        cc = read(0, &c, 1);
 642:	4605                	li	a2,1
 644:	faf40593          	addi	a1,s0,-81
 648:	4501                	li	a0,0
 64a:	00000097          	auipc	ra,0x0
 64e:	19c080e7          	jalr	412(ra) # 7e6 <read>
        if (cc < 1)
 652:	00a05e63          	blez	a0,66e <gets+0x56>
        buf[i++] = c;
 656:	faf44783          	lbu	a5,-81(s0)
 65a:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 65e:	01578763          	beq	a5,s5,66c <gets+0x54>
 662:	0905                	addi	s2,s2,1
 664:	fd679be3          	bne	a5,s6,63a <gets+0x22>
    for (i = 0; i + 1 < max;)
 668:	89a6                	mv	s3,s1
 66a:	a011                	j	66e <gets+0x56>
 66c:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 66e:	99de                	add	s3,s3,s7
 670:	00098023          	sb	zero,0(s3)
    return buf;
}
 674:	855e                	mv	a0,s7
 676:	60e6                	ld	ra,88(sp)
 678:	6446                	ld	s0,80(sp)
 67a:	64a6                	ld	s1,72(sp)
 67c:	6906                	ld	s2,64(sp)
 67e:	79e2                	ld	s3,56(sp)
 680:	7a42                	ld	s4,48(sp)
 682:	7aa2                	ld	s5,40(sp)
 684:	7b02                	ld	s6,32(sp)
 686:	6be2                	ld	s7,24(sp)
 688:	6125                	addi	sp,sp,96
 68a:	8082                	ret

000000000000068c <stat>:

int stat(const char *n, struct stat *st)
{
 68c:	1101                	addi	sp,sp,-32
 68e:	ec06                	sd	ra,24(sp)
 690:	e822                	sd	s0,16(sp)
 692:	e426                	sd	s1,8(sp)
 694:	e04a                	sd	s2,0(sp)
 696:	1000                	addi	s0,sp,32
 698:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 69a:	4581                	li	a1,0
 69c:	00000097          	auipc	ra,0x0
 6a0:	172080e7          	jalr	370(ra) # 80e <open>
    if (fd < 0)
 6a4:	02054563          	bltz	a0,6ce <stat+0x42>
 6a8:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 6aa:	85ca                	mv	a1,s2
 6ac:	00000097          	auipc	ra,0x0
 6b0:	17a080e7          	jalr	378(ra) # 826 <fstat>
 6b4:	892a                	mv	s2,a0
    close(fd);
 6b6:	8526                	mv	a0,s1
 6b8:	00000097          	auipc	ra,0x0
 6bc:	13e080e7          	jalr	318(ra) # 7f6 <close>
    return r;
}
 6c0:	854a                	mv	a0,s2
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	64a2                	ld	s1,8(sp)
 6c8:	6902                	ld	s2,0(sp)
 6ca:	6105                	addi	sp,sp,32
 6cc:	8082                	ret
        return -1;
 6ce:	597d                	li	s2,-1
 6d0:	bfc5                	j	6c0 <stat+0x34>

00000000000006d2 <atoi>:

int atoi(const char *s)
{
 6d2:	1141                	addi	sp,sp,-16
 6d4:	e422                	sd	s0,8(sp)
 6d6:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 6d8:	00054603          	lbu	a2,0(a0)
 6dc:	fd06079b          	addiw	a5,a2,-48
 6e0:	0ff7f793          	andi	a5,a5,255
 6e4:	4725                	li	a4,9
 6e6:	02f76963          	bltu	a4,a5,718 <atoi+0x46>
 6ea:	86aa                	mv	a3,a0
    n = 0;
 6ec:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 6ee:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 6f0:	0685                	addi	a3,a3,1
 6f2:	0025179b          	slliw	a5,a0,0x2
 6f6:	9fa9                	addw	a5,a5,a0
 6f8:	0017979b          	slliw	a5,a5,0x1
 6fc:	9fb1                	addw	a5,a5,a2
 6fe:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 702:	0006c603          	lbu	a2,0(a3)
 706:	fd06071b          	addiw	a4,a2,-48
 70a:	0ff77713          	andi	a4,a4,255
 70e:	fee5f1e3          	bgeu	a1,a4,6f0 <atoi+0x1e>
    return n;
}
 712:	6422                	ld	s0,8(sp)
 714:	0141                	addi	sp,sp,16
 716:	8082                	ret
    n = 0;
 718:	4501                	li	a0,0
 71a:	bfe5                	j	712 <atoi+0x40>

000000000000071c <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e422                	sd	s0,8(sp)
 720:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 722:	02b57463          	bgeu	a0,a1,74a <memmove+0x2e>
    {
        while (n-- > 0)
 726:	00c05f63          	blez	a2,744 <memmove+0x28>
 72a:	1602                	slli	a2,a2,0x20
 72c:	9201                	srli	a2,a2,0x20
 72e:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 732:	872a                	mv	a4,a0
            *dst++ = *src++;
 734:	0585                	addi	a1,a1,1
 736:	0705                	addi	a4,a4,1
 738:	fff5c683          	lbu	a3,-1(a1)
 73c:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 740:	fee79ae3          	bne	a5,a4,734 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 744:	6422                	ld	s0,8(sp)
 746:	0141                	addi	sp,sp,16
 748:	8082                	ret
        dst += n;
 74a:	00c50733          	add	a4,a0,a2
        src += n;
 74e:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 750:	fec05ae3          	blez	a2,744 <memmove+0x28>
 754:	fff6079b          	addiw	a5,a2,-1
 758:	1782                	slli	a5,a5,0x20
 75a:	9381                	srli	a5,a5,0x20
 75c:	fff7c793          	not	a5,a5
 760:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 762:	15fd                	addi	a1,a1,-1
 764:	177d                	addi	a4,a4,-1
 766:	0005c683          	lbu	a3,0(a1)
 76a:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 76e:	fee79ae3          	bne	a5,a4,762 <memmove+0x46>
 772:	bfc9                	j	744 <memmove+0x28>

0000000000000774 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 774:	1141                	addi	sp,sp,-16
 776:	e422                	sd	s0,8(sp)
 778:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 77a:	ca05                	beqz	a2,7aa <memcmp+0x36>
 77c:	fff6069b          	addiw	a3,a2,-1
 780:	1682                	slli	a3,a3,0x20
 782:	9281                	srli	a3,a3,0x20
 784:	0685                	addi	a3,a3,1
 786:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 788:	00054783          	lbu	a5,0(a0)
 78c:	0005c703          	lbu	a4,0(a1)
 790:	00e79863          	bne	a5,a4,7a0 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 794:	0505                	addi	a0,a0,1
        p2++;
 796:	0585                	addi	a1,a1,1
    while (n-- > 0)
 798:	fed518e3          	bne	a0,a3,788 <memcmp+0x14>
    }
    return 0;
 79c:	4501                	li	a0,0
 79e:	a019                	j	7a4 <memcmp+0x30>
            return *p1 - *p2;
 7a0:	40e7853b          	subw	a0,a5,a4
}
 7a4:	6422                	ld	s0,8(sp)
 7a6:	0141                	addi	sp,sp,16
 7a8:	8082                	ret
    return 0;
 7aa:	4501                	li	a0,0
 7ac:	bfe5                	j	7a4 <memcmp+0x30>

00000000000007ae <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 7ae:	1141                	addi	sp,sp,-16
 7b0:	e406                	sd	ra,8(sp)
 7b2:	e022                	sd	s0,0(sp)
 7b4:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 7b6:	00000097          	auipc	ra,0x0
 7ba:	f66080e7          	jalr	-154(ra) # 71c <memmove>
}
 7be:	60a2                	ld	ra,8(sp)
 7c0:	6402                	ld	s0,0(sp)
 7c2:	0141                	addi	sp,sp,16
 7c4:	8082                	ret

00000000000007c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7c6:	4885                	li	a7,1
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 7ce:	4889                	li	a7,2
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7d6:	488d                	li	a7,3
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7de:	4891                	li	a7,4
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <read>:
.global read
read:
 li a7, SYS_read
 7e6:	4895                	li	a7,5
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <write>:
.global write
write:
 li a7, SYS_write
 7ee:	48c1                	li	a7,16
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <close>:
.global close
close:
 li a7, SYS_close
 7f6:	48d5                	li	a7,21
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 7fe:	4899                	li	a7,6
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <exec>:
.global exec
exec:
 li a7, SYS_exec
 806:	489d                	li	a7,7
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <open>:
.global open
open:
 li a7, SYS_open
 80e:	48bd                	li	a7,15
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 816:	48c5                	li	a7,17
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 81e:	48c9                	li	a7,18
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 826:	48a1                	li	a7,8
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <link>:
.global link
link:
 li a7, SYS_link
 82e:	48cd                	li	a7,19
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 836:	48d1                	li	a7,20
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 83e:	48a5                	li	a7,9
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <dup>:
.global dup
dup:
 li a7, SYS_dup
 846:	48a9                	li	a7,10
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 84e:	48ad                	li	a7,11
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 856:	48b1                	li	a7,12
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 85e:	48b5                	li	a7,13
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 866:	48b9                	li	a7,14
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 86e:	48d9                	li	a7,22
 ecall
 870:	00000073          	ecall
 ret
 874:	8082                	ret

0000000000000876 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 876:	48dd                	li	a7,23
 ecall
 878:	00000073          	ecall
 ret
 87c:	8082                	ret

000000000000087e <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 87e:	48e1                	li	a7,24
 ecall
 880:	00000073          	ecall
 ret
 884:	8082                	ret

0000000000000886 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 886:	48e5                	li	a7,25
 ecall
 888:	00000073          	ecall
 ret
 88c:	8082                	ret

000000000000088e <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 88e:	48e9                	li	a7,26
 ecall
 890:	00000073          	ecall
 ret
 894:	8082                	ret

0000000000000896 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 896:	48ed                	li	a7,27
 ecall
 898:	00000073          	ecall
 ret
 89c:	8082                	ret

000000000000089e <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 89e:	48f5                	li	a7,29
 ecall
 8a0:	00000073          	ecall
 ret
 8a4:	8082                	ret

00000000000008a6 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 8a6:	48f1                	li	a7,28
 ecall
 8a8:	00000073          	ecall
 ret
 8ac:	8082                	ret

00000000000008ae <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 8ae:	1101                	addi	sp,sp,-32
 8b0:	ec06                	sd	ra,24(sp)
 8b2:	e822                	sd	s0,16(sp)
 8b4:	1000                	addi	s0,sp,32
 8b6:	feb407a3          	sb	a1,-17(s0)
 8ba:	4605                	li	a2,1
 8bc:	fef40593          	addi	a1,s0,-17
 8c0:	00000097          	auipc	ra,0x0
 8c4:	f2e080e7          	jalr	-210(ra) # 7ee <write>
 8c8:	60e2                	ld	ra,24(sp)
 8ca:	6442                	ld	s0,16(sp)
 8cc:	6105                	addi	sp,sp,32
 8ce:	8082                	ret

00000000000008d0 <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 8d0:	7139                	addi	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f426                	sd	s1,40(sp)
 8d8:	f04a                	sd	s2,32(sp)
 8da:	ec4e                	sd	s3,24(sp)
 8dc:	0080                	addi	s0,sp,64
 8de:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 8e0:	c299                	beqz	a3,8e6 <printint+0x16>
 8e2:	0805c863          	bltz	a1,972 <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 8e6:	2581                	sext.w	a1,a1
    neg = 0;
 8e8:	4881                	li	a7,0
 8ea:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 8ee:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 8f0:	2601                	sext.w	a2,a2
 8f2:	00001517          	auipc	a0,0x1
 8f6:	81650513          	addi	a0,a0,-2026 # 1108 <digits>
 8fa:	883a                	mv	a6,a4
 8fc:	2705                	addiw	a4,a4,1
 8fe:	02c5f7bb          	remuw	a5,a1,a2
 902:	1782                	slli	a5,a5,0x20
 904:	9381                	srli	a5,a5,0x20
 906:	97aa                	add	a5,a5,a0
 908:	0007c783          	lbu	a5,0(a5)
 90c:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 910:	0005879b          	sext.w	a5,a1
 914:	02c5d5bb          	divuw	a1,a1,a2
 918:	0685                	addi	a3,a3,1
 91a:	fec7f0e3          	bgeu	a5,a2,8fa <printint+0x2a>
    if (neg)
 91e:	00088b63          	beqz	a7,934 <printint+0x64>
        buf[i++] = '-';
 922:	fd040793          	addi	a5,s0,-48
 926:	973e                	add	a4,a4,a5
 928:	02d00793          	li	a5,45
 92c:	fef70823          	sb	a5,-16(a4)
 930:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 934:	02e05863          	blez	a4,964 <printint+0x94>
 938:	fc040793          	addi	a5,s0,-64
 93c:	00e78933          	add	s2,a5,a4
 940:	fff78993          	addi	s3,a5,-1
 944:	99ba                	add	s3,s3,a4
 946:	377d                	addiw	a4,a4,-1
 948:	1702                	slli	a4,a4,0x20
 94a:	9301                	srli	a4,a4,0x20
 94c:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 950:	fff94583          	lbu	a1,-1(s2)
 954:	8526                	mv	a0,s1
 956:	00000097          	auipc	ra,0x0
 95a:	f58080e7          	jalr	-168(ra) # 8ae <putc>
    while (--i >= 0)
 95e:	197d                	addi	s2,s2,-1
 960:	ff3918e3          	bne	s2,s3,950 <printint+0x80>
}
 964:	70e2                	ld	ra,56(sp)
 966:	7442                	ld	s0,48(sp)
 968:	74a2                	ld	s1,40(sp)
 96a:	7902                	ld	s2,32(sp)
 96c:	69e2                	ld	s3,24(sp)
 96e:	6121                	addi	sp,sp,64
 970:	8082                	ret
        x = -xx;
 972:	40b005bb          	negw	a1,a1
        neg = 1;
 976:	4885                	li	a7,1
        x = -xx;
 978:	bf8d                	j	8ea <printint+0x1a>

000000000000097a <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 97a:	7119                	addi	sp,sp,-128
 97c:	fc86                	sd	ra,120(sp)
 97e:	f8a2                	sd	s0,112(sp)
 980:	f4a6                	sd	s1,104(sp)
 982:	f0ca                	sd	s2,96(sp)
 984:	ecce                	sd	s3,88(sp)
 986:	e8d2                	sd	s4,80(sp)
 988:	e4d6                	sd	s5,72(sp)
 98a:	e0da                	sd	s6,64(sp)
 98c:	fc5e                	sd	s7,56(sp)
 98e:	f862                	sd	s8,48(sp)
 990:	f466                	sd	s9,40(sp)
 992:	f06a                	sd	s10,32(sp)
 994:	ec6e                	sd	s11,24(sp)
 996:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 998:	0005c903          	lbu	s2,0(a1)
 99c:	18090f63          	beqz	s2,b3a <vprintf+0x1c0>
 9a0:	8aaa                	mv	s5,a0
 9a2:	8b32                	mv	s6,a2
 9a4:	00158493          	addi	s1,a1,1
    state = 0;
 9a8:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 9aa:	02500a13          	li	s4,37
        {
            if (c == 'd')
 9ae:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 9b2:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 9b6:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 9ba:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9be:	00000b97          	auipc	s7,0x0
 9c2:	74ab8b93          	addi	s7,s7,1866 # 1108 <digits>
 9c6:	a839                	j	9e4 <vprintf+0x6a>
                putc(fd, c);
 9c8:	85ca                	mv	a1,s2
 9ca:	8556                	mv	a0,s5
 9cc:	00000097          	auipc	ra,0x0
 9d0:	ee2080e7          	jalr	-286(ra) # 8ae <putc>
 9d4:	a019                	j	9da <vprintf+0x60>
        else if (state == '%')
 9d6:	01498f63          	beq	s3,s4,9f4 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 9da:	0485                	addi	s1,s1,1
 9dc:	fff4c903          	lbu	s2,-1(s1)
 9e0:	14090d63          	beqz	s2,b3a <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 9e4:	0009079b          	sext.w	a5,s2
        if (state == 0)
 9e8:	fe0997e3          	bnez	s3,9d6 <vprintf+0x5c>
            if (c == '%')
 9ec:	fd479ee3          	bne	a5,s4,9c8 <vprintf+0x4e>
                state = '%';
 9f0:	89be                	mv	s3,a5
 9f2:	b7e5                	j	9da <vprintf+0x60>
            if (c == 'd')
 9f4:	05878063          	beq	a5,s8,a34 <vprintf+0xba>
            else if (c == 'l')
 9f8:	05978c63          	beq	a5,s9,a50 <vprintf+0xd6>
            else if (c == 'x')
 9fc:	07a78863          	beq	a5,s10,a6c <vprintf+0xf2>
            else if (c == 'p')
 a00:	09b78463          	beq	a5,s11,a88 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 a04:	07300713          	li	a4,115
 a08:	0ce78663          	beq	a5,a4,ad4 <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 a0c:	06300713          	li	a4,99
 a10:	0ee78e63          	beq	a5,a4,b0c <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 a14:	11478863          	beq	a5,s4,b24 <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 a18:	85d2                	mv	a1,s4
 a1a:	8556                	mv	a0,s5
 a1c:	00000097          	auipc	ra,0x0
 a20:	e92080e7          	jalr	-366(ra) # 8ae <putc>
                putc(fd, c);
 a24:	85ca                	mv	a1,s2
 a26:	8556                	mv	a0,s5
 a28:	00000097          	auipc	ra,0x0
 a2c:	e86080e7          	jalr	-378(ra) # 8ae <putc>
            }
            state = 0;
 a30:	4981                	li	s3,0
 a32:	b765                	j	9da <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 a34:	008b0913          	addi	s2,s6,8
 a38:	4685                	li	a3,1
 a3a:	4629                	li	a2,10
 a3c:	000b2583          	lw	a1,0(s6)
 a40:	8556                	mv	a0,s5
 a42:	00000097          	auipc	ra,0x0
 a46:	e8e080e7          	jalr	-370(ra) # 8d0 <printint>
 a4a:	8b4a                	mv	s6,s2
            state = 0;
 a4c:	4981                	li	s3,0
 a4e:	b771                	j	9da <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 a50:	008b0913          	addi	s2,s6,8
 a54:	4681                	li	a3,0
 a56:	4629                	li	a2,10
 a58:	000b2583          	lw	a1,0(s6)
 a5c:	8556                	mv	a0,s5
 a5e:	00000097          	auipc	ra,0x0
 a62:	e72080e7          	jalr	-398(ra) # 8d0 <printint>
 a66:	8b4a                	mv	s6,s2
            state = 0;
 a68:	4981                	li	s3,0
 a6a:	bf85                	j	9da <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 a6c:	008b0913          	addi	s2,s6,8
 a70:	4681                	li	a3,0
 a72:	4641                	li	a2,16
 a74:	000b2583          	lw	a1,0(s6)
 a78:	8556                	mv	a0,s5
 a7a:	00000097          	auipc	ra,0x0
 a7e:	e56080e7          	jalr	-426(ra) # 8d0 <printint>
 a82:	8b4a                	mv	s6,s2
            state = 0;
 a84:	4981                	li	s3,0
 a86:	bf91                	j	9da <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 a88:	008b0793          	addi	a5,s6,8
 a8c:	f8f43423          	sd	a5,-120(s0)
 a90:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 a94:	03000593          	li	a1,48
 a98:	8556                	mv	a0,s5
 a9a:	00000097          	auipc	ra,0x0
 a9e:	e14080e7          	jalr	-492(ra) # 8ae <putc>
    putc(fd, 'x');
 aa2:	85ea                	mv	a1,s10
 aa4:	8556                	mv	a0,s5
 aa6:	00000097          	auipc	ra,0x0
 aaa:	e08080e7          	jalr	-504(ra) # 8ae <putc>
 aae:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ab0:	03c9d793          	srli	a5,s3,0x3c
 ab4:	97de                	add	a5,a5,s7
 ab6:	0007c583          	lbu	a1,0(a5)
 aba:	8556                	mv	a0,s5
 abc:	00000097          	auipc	ra,0x0
 ac0:	df2080e7          	jalr	-526(ra) # 8ae <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ac4:	0992                	slli	s3,s3,0x4
 ac6:	397d                	addiw	s2,s2,-1
 ac8:	fe0914e3          	bnez	s2,ab0 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 acc:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 ad0:	4981                	li	s3,0
 ad2:	b721                	j	9da <vprintf+0x60>
                s = va_arg(ap, char *);
 ad4:	008b0993          	addi	s3,s6,8
 ad8:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 adc:	02090163          	beqz	s2,afe <vprintf+0x184>
                while (*s != 0)
 ae0:	00094583          	lbu	a1,0(s2)
 ae4:	c9a1                	beqz	a1,b34 <vprintf+0x1ba>
                    putc(fd, *s);
 ae6:	8556                	mv	a0,s5
 ae8:	00000097          	auipc	ra,0x0
 aec:	dc6080e7          	jalr	-570(ra) # 8ae <putc>
                    s++;
 af0:	0905                	addi	s2,s2,1
                while (*s != 0)
 af2:	00094583          	lbu	a1,0(s2)
 af6:	f9e5                	bnez	a1,ae6 <vprintf+0x16c>
                s = va_arg(ap, char *);
 af8:	8b4e                	mv	s6,s3
            state = 0;
 afa:	4981                	li	s3,0
 afc:	bdf9                	j	9da <vprintf+0x60>
                    s = "(null)";
 afe:	00000917          	auipc	s2,0x0
 b02:	60290913          	addi	s2,s2,1538 # 1100 <malloc+0x4bc>
                while (*s != 0)
 b06:	02800593          	li	a1,40
 b0a:	bff1                	j	ae6 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 b0c:	008b0913          	addi	s2,s6,8
 b10:	000b4583          	lbu	a1,0(s6)
 b14:	8556                	mv	a0,s5
 b16:	00000097          	auipc	ra,0x0
 b1a:	d98080e7          	jalr	-616(ra) # 8ae <putc>
 b1e:	8b4a                	mv	s6,s2
            state = 0;
 b20:	4981                	li	s3,0
 b22:	bd65                	j	9da <vprintf+0x60>
                putc(fd, c);
 b24:	85d2                	mv	a1,s4
 b26:	8556                	mv	a0,s5
 b28:	00000097          	auipc	ra,0x0
 b2c:	d86080e7          	jalr	-634(ra) # 8ae <putc>
            state = 0;
 b30:	4981                	li	s3,0
 b32:	b565                	j	9da <vprintf+0x60>
                s = va_arg(ap, char *);
 b34:	8b4e                	mv	s6,s3
            state = 0;
 b36:	4981                	li	s3,0
 b38:	b54d                	j	9da <vprintf+0x60>
        }
    }
}
 b3a:	70e6                	ld	ra,120(sp)
 b3c:	7446                	ld	s0,112(sp)
 b3e:	74a6                	ld	s1,104(sp)
 b40:	7906                	ld	s2,96(sp)
 b42:	69e6                	ld	s3,88(sp)
 b44:	6a46                	ld	s4,80(sp)
 b46:	6aa6                	ld	s5,72(sp)
 b48:	6b06                	ld	s6,64(sp)
 b4a:	7be2                	ld	s7,56(sp)
 b4c:	7c42                	ld	s8,48(sp)
 b4e:	7ca2                	ld	s9,40(sp)
 b50:	7d02                	ld	s10,32(sp)
 b52:	6de2                	ld	s11,24(sp)
 b54:	6109                	addi	sp,sp,128
 b56:	8082                	ret

0000000000000b58 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 b58:	715d                	addi	sp,sp,-80
 b5a:	ec06                	sd	ra,24(sp)
 b5c:	e822                	sd	s0,16(sp)
 b5e:	1000                	addi	s0,sp,32
 b60:	e010                	sd	a2,0(s0)
 b62:	e414                	sd	a3,8(s0)
 b64:	e818                	sd	a4,16(s0)
 b66:	ec1c                	sd	a5,24(s0)
 b68:	03043023          	sd	a6,32(s0)
 b6c:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 b70:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 b74:	8622                	mv	a2,s0
 b76:	00000097          	auipc	ra,0x0
 b7a:	e04080e7          	jalr	-508(ra) # 97a <vprintf>
}
 b7e:	60e2                	ld	ra,24(sp)
 b80:	6442                	ld	s0,16(sp)
 b82:	6161                	addi	sp,sp,80
 b84:	8082                	ret

0000000000000b86 <printf>:

void printf(const char *fmt, ...)
{
 b86:	711d                	addi	sp,sp,-96
 b88:	ec06                	sd	ra,24(sp)
 b8a:	e822                	sd	s0,16(sp)
 b8c:	1000                	addi	s0,sp,32
 b8e:	e40c                	sd	a1,8(s0)
 b90:	e810                	sd	a2,16(s0)
 b92:	ec14                	sd	a3,24(s0)
 b94:	f018                	sd	a4,32(s0)
 b96:	f41c                	sd	a5,40(s0)
 b98:	03043823          	sd	a6,48(s0)
 b9c:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 ba0:	00840613          	addi	a2,s0,8
 ba4:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 ba8:	85aa                	mv	a1,a0
 baa:	4505                	li	a0,1
 bac:	00000097          	auipc	ra,0x0
 bb0:	dce080e7          	jalr	-562(ra) # 97a <vprintf>
}
 bb4:	60e2                	ld	ra,24(sp)
 bb6:	6442                	ld	s0,16(sp)
 bb8:	6125                	addi	sp,sp,96
 bba:	8082                	ret

0000000000000bbc <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 bbc:	1141                	addi	sp,sp,-16
 bbe:	e422                	sd	s0,8(sp)
 bc0:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 bc2:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc6:	00000797          	auipc	a5,0x0
 bca:	55a7b783          	ld	a5,1370(a5) # 1120 <freep>
 bce:	a805                	j	bfe <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 bd0:	4618                	lw	a4,8(a2)
 bd2:	9db9                	addw	a1,a1,a4
 bd4:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 bd8:	6398                	ld	a4,0(a5)
 bda:	6318                	ld	a4,0(a4)
 bdc:	fee53823          	sd	a4,-16(a0)
 be0:	a091                	j	c24 <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 be2:	ff852703          	lw	a4,-8(a0)
 be6:	9e39                	addw	a2,a2,a4
 be8:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 bea:	ff053703          	ld	a4,-16(a0)
 bee:	e398                	sd	a4,0(a5)
 bf0:	a099                	j	c36 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bf2:	6398                	ld	a4,0(a5)
 bf4:	00e7e463          	bltu	a5,a4,bfc <free+0x40>
 bf8:	00e6ea63          	bltu	a3,a4,c0c <free+0x50>
{
 bfc:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfe:	fed7fae3          	bgeu	a5,a3,bf2 <free+0x36>
 c02:	6398                	ld	a4,0(a5)
 c04:	00e6e463          	bltu	a3,a4,c0c <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c08:	fee7eae3          	bltu	a5,a4,bfc <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 c0c:	ff852583          	lw	a1,-8(a0)
 c10:	6390                	ld	a2,0(a5)
 c12:	02059713          	slli	a4,a1,0x20
 c16:	9301                	srli	a4,a4,0x20
 c18:	0712                	slli	a4,a4,0x4
 c1a:	9736                	add	a4,a4,a3
 c1c:	fae60ae3          	beq	a2,a4,bd0 <free+0x14>
        bp->s.ptr = p->s.ptr;
 c20:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 c24:	4790                	lw	a2,8(a5)
 c26:	02061713          	slli	a4,a2,0x20
 c2a:	9301                	srli	a4,a4,0x20
 c2c:	0712                	slli	a4,a4,0x4
 c2e:	973e                	add	a4,a4,a5
 c30:	fae689e3          	beq	a3,a4,be2 <free+0x26>
    }
    else
        p->s.ptr = bp;
 c34:	e394                	sd	a3,0(a5)
    freep = p;
 c36:	00000717          	auipc	a4,0x0
 c3a:	4ef73523          	sd	a5,1258(a4) # 1120 <freep>
}
 c3e:	6422                	ld	s0,8(sp)
 c40:	0141                	addi	sp,sp,16
 c42:	8082                	ret

0000000000000c44 <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 c44:	7139                	addi	sp,sp,-64
 c46:	fc06                	sd	ra,56(sp)
 c48:	f822                	sd	s0,48(sp)
 c4a:	f426                	sd	s1,40(sp)
 c4c:	f04a                	sd	s2,32(sp)
 c4e:	ec4e                	sd	s3,24(sp)
 c50:	e852                	sd	s4,16(sp)
 c52:	e456                	sd	s5,8(sp)
 c54:	e05a                	sd	s6,0(sp)
 c56:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 c58:	02051493          	slli	s1,a0,0x20
 c5c:	9081                	srli	s1,s1,0x20
 c5e:	04bd                	addi	s1,s1,15
 c60:	8091                	srli	s1,s1,0x4
 c62:	0014899b          	addiw	s3,s1,1
 c66:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 c68:	00000517          	auipc	a0,0x0
 c6c:	4b853503          	ld	a0,1208(a0) # 1120 <freep>
 c70:	c515                	beqz	a0,c9c <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 c72:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 c74:	4798                	lw	a4,8(a5)
 c76:	02977f63          	bgeu	a4,s1,cb4 <malloc+0x70>
 c7a:	8a4e                	mv	s4,s3
 c7c:	0009871b          	sext.w	a4,s3
 c80:	6685                	lui	a3,0x1
 c82:	00d77363          	bgeu	a4,a3,c88 <malloc+0x44>
 c86:	6a05                	lui	s4,0x1
 c88:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 c8c:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 c90:	00000917          	auipc	s2,0x0
 c94:	49090913          	addi	s2,s2,1168 # 1120 <freep>
    if (p == (char *)-1)
 c98:	5afd                	li	s5,-1
 c9a:	a88d                	j	d0c <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 c9c:	00000797          	auipc	a5,0x0
 ca0:	48c78793          	addi	a5,a5,1164 # 1128 <base>
 ca4:	00000717          	auipc	a4,0x0
 ca8:	46f73e23          	sd	a5,1148(a4) # 1120 <freep>
 cac:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 cae:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 cb2:	b7e1                	j	c7a <malloc+0x36>
            if (p->s.size == nunits)
 cb4:	02e48b63          	beq	s1,a4,cea <malloc+0xa6>
                p->s.size -= nunits;
 cb8:	4137073b          	subw	a4,a4,s3
 cbc:	c798                	sw	a4,8(a5)
                p += p->s.size;
 cbe:	1702                	slli	a4,a4,0x20
 cc0:	9301                	srli	a4,a4,0x20
 cc2:	0712                	slli	a4,a4,0x4
 cc4:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 cc6:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 cca:	00000717          	auipc	a4,0x0
 cce:	44a73b23          	sd	a0,1110(a4) # 1120 <freep>
            return (void *)(p + 1);
 cd2:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 cd6:	70e2                	ld	ra,56(sp)
 cd8:	7442                	ld	s0,48(sp)
 cda:	74a2                	ld	s1,40(sp)
 cdc:	7902                	ld	s2,32(sp)
 cde:	69e2                	ld	s3,24(sp)
 ce0:	6a42                	ld	s4,16(sp)
 ce2:	6aa2                	ld	s5,8(sp)
 ce4:	6b02                	ld	s6,0(sp)
 ce6:	6121                	addi	sp,sp,64
 ce8:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 cea:	6398                	ld	a4,0(a5)
 cec:	e118                	sd	a4,0(a0)
 cee:	bff1                	j	cca <malloc+0x86>
    hp->s.size = nu;
 cf0:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 cf4:	0541                	addi	a0,a0,16
 cf6:	00000097          	auipc	ra,0x0
 cfa:	ec6080e7          	jalr	-314(ra) # bbc <free>
    return freep;
 cfe:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 d02:	d971                	beqz	a0,cd6 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 d04:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 d06:	4798                	lw	a4,8(a5)
 d08:	fa9776e3          	bgeu	a4,s1,cb4 <malloc+0x70>
        if (p == freep)
 d0c:	00093703          	ld	a4,0(s2)
 d10:	853e                	mv	a0,a5
 d12:	fef719e3          	bne	a4,a5,d04 <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 d16:	8552                	mv	a0,s4
 d18:	00000097          	auipc	ra,0x0
 d1c:	b3e080e7          	jalr	-1218(ra) # 856 <sbrk>
    if (p == (char *)-1)
 d20:	fd5518e3          	bne	a0,s5,cf0 <malloc+0xac>
                return 0;
 d24:	4501                	li	a0,0
 d26:	bf45                	j	cd6 <malloc+0x92>
