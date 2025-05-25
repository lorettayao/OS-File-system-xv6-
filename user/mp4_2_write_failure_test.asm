
user/_mp4_2_write_failure_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fill_data_for_test>:

char test_data_buffer[BSIZE];
char dummy_buffer[BSIZE];

void fill_data_for_test(char *buf, int marker_val, char fill_pattern)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
  10:	85b2                	mv	a1,a2
    memset(buf, fill_pattern, BSIZE);
  12:	40000613          	li	a2,1024
  16:	00000097          	auipc	ra,0x0
  1a:	3ee080e7          	jalr	1006(ra) # 404 <memset>
    buf[0] = (char)marker_val;
  1e:	01248023          	sb	s2,0(s1)
}
  22:	60e2                	ld	ra,24(sp)
  24:	6442                	ld	s0,16(sp)
  26:	64a2                	ld	s1,8(sp)
  28:	6902                	ld	s2,0(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <main>:

int main(int argc, char *argv[])
{
  2e:	7179                	addi	sp,sp,-48
  30:	f406                	sd	ra,40(sp)
  32:	f022                	sd	s0,32(sp)
  34:	ec26                	sd	s1,24(sp)
  36:	e84a                	sd	s2,16(sp)
  38:	e44e                	sd	s3,8(sp)
  3a:	1800                	addi	s0,sp,48
    int fd;
    int pbn0_for_test_lbn = -1;

    if (argc < 2)
  3c:	4785                	li	a5,1
  3e:	08a7db63          	bge	a5,a0,d4 <main+0xa6>
        fprintf(2, "  0: Normal Write (no failures simulated)\n");
        fprintf(2, "  1: Simulate Disk 0 Failure for write\n");
        exit(1);
    }

    int scenario = atoi(argv[1]);
  42:	6588                	ld	a0,8(a1)
  44:	00000097          	auipc	ra,0x0
  48:	4c0080e7          	jalr	1216(ra) # 504 <atoi>
  4c:	892a                	mv	s2,a0
    fill_data_for_test(test_data_buffer, TEST_FILE_LBN, 'W');
  4e:	05700613          	li	a2,87
  52:	4585                	li	a1,1
  54:	00001517          	auipc	a0,0x1
  58:	f8450513          	addi	a0,a0,-124 # fd8 <test_data_buffer>
  5c:	00000097          	auipc	ra,0x0
  60:	fa4080e7          	jalr	-92(ra) # 0 <fill_data_for_test>
    fill_data_for_test(dummy_buffer, 0, '.');
  64:	02e00613          	li	a2,46
  68:	4581                	li	a1,0
  6a:	00001517          	auipc	a0,0x1
  6e:	36e50513          	addi	a0,a0,878 # 13d8 <dummy_buffer>
  72:	00000097          	auipc	ra,0x0
  76:	f8e080e7          	jalr	-114(ra) # 0 <fill_data_for_test>

    printf("TEST_DRIVER: Phase 0 - Setting up file and getting PBN for File "
  7a:	4585                	li	a1,1
  7c:	00001517          	auipc	a0,0x1
  80:	b6c50513          	addi	a0,a0,-1172 # be8 <malloc+0x172>
  84:	00001097          	auipc	ra,0x1
  88:	934080e7          	jalr	-1740(ra) # 9b8 <printf>
           "LBN %d.\n",
           TEST_FILE_LBN);
    force_disk_fail(-1);
  8c:	557d                	li	a0,-1
  8e:	00000097          	auipc	ra,0x0
  92:	63a080e7          	jalr	1594(ra) # 6c8 <force_disk_fail>
    force_fail(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	608080e7          	jalr	1544(ra) # 6a0 <force_fail>

    fd = open("raid1_sim_target.dat", O_CREATE | O_RDWR | O_TRUNC);
  a0:	60200593          	li	a1,1538
  a4:	00001517          	auipc	a0,0x1
  a8:	b9450513          	addi	a0,a0,-1132 # c38 <malloc+0x1c2>
  ac:	00000097          	auipc	ra,0x0
  b0:	594080e7          	jalr	1428(ra) # 640 <open>
  b4:	84aa                	mv	s1,a0
    if (fd < 0)
  b6:	06055963          	bgez	a0,128 <main+0xfa>
    {
        printf("TEST_DRIVER_ERROR: Cannot create/open file "
  ba:	00001517          	auipc	a0,0x1
  be:	b9650513          	addi	a0,a0,-1130 # c50 <malloc+0x1da>
  c2:	00001097          	auipc	ra,0x1
  c6:	8f6080e7          	jalr	-1802(ra) # 9b8 <printf>
               "'raid1_sim_target.dat' in Phase 0\n");
        exit(1);
  ca:	4505                	li	a0,1
  cc:	00000097          	auipc	ra,0x0
  d0:	534080e7          	jalr	1332(ra) # 600 <exit>
        fprintf(2, "Usage: %s <scenario_num>\n", argv[0]);
  d4:	6190                	ld	a2,0(a1)
  d6:	00001597          	auipc	a1,0x1
  da:	a8a58593          	addi	a1,a1,-1398 # b60 <malloc+0xea>
  de:	4509                	li	a0,2
  e0:	00001097          	auipc	ra,0x1
  e4:	8aa080e7          	jalr	-1878(ra) # 98a <fprintf>
        fprintf(2, "Scenarios:\n");
  e8:	00001597          	auipc	a1,0x1
  ec:	a9858593          	addi	a1,a1,-1384 # b80 <malloc+0x10a>
  f0:	4509                	li	a0,2
  f2:	00001097          	auipc	ra,0x1
  f6:	898080e7          	jalr	-1896(ra) # 98a <fprintf>
        fprintf(2, "  0: Normal Write (no failures simulated)\n");
  fa:	00001597          	auipc	a1,0x1
  fe:	a9658593          	addi	a1,a1,-1386 # b90 <malloc+0x11a>
 102:	4509                	li	a0,2
 104:	00001097          	auipc	ra,0x1
 108:	886080e7          	jalr	-1914(ra) # 98a <fprintf>
        fprintf(2, "  1: Simulate Disk 0 Failure for write\n");
 10c:	00001597          	auipc	a1,0x1
 110:	ab458593          	addi	a1,a1,-1356 # bc0 <malloc+0x14a>
 114:	4509                	li	a0,2
 116:	00001097          	auipc	ra,0x1
 11a:	874080e7          	jalr	-1932(ra) # 98a <fprintf>
        exit(1);
 11e:	4505                	li	a0,1
 120:	00000097          	auipc	ra,0x0
 124:	4e0080e7          	jalr	1248(ra) # 600 <exit>
    }

    for (int i = 0; i < TEST_FILE_LBN; i++)
    {
        if (write(fd, dummy_buffer, BSIZE) != BSIZE)
 128:	40000613          	li	a2,1024
 12c:	00001597          	auipc	a1,0x1
 130:	2ac58593          	addi	a1,a1,684 # 13d8 <dummy_buffer>
 134:	00000097          	auipc	ra,0x0
 138:	4ec080e7          	jalr	1260(ra) # 620 <write>
 13c:	40000793          	li	a5,1024
 140:	04f51363          	bne	a0,a5,186 <main+0x158>
                   i);
            close(fd);
            exit(1);
        }
    }
    if (write(fd, dummy_buffer, BSIZE) != BSIZE)
 144:	40000613          	li	a2,1024
 148:	00001597          	auipc	a1,0x1
 14c:	29058593          	addi	a1,a1,656 # 13d8 <dummy_buffer>
 150:	8526                	mv	a0,s1
 152:	00000097          	auipc	ra,0x0
 156:	4ce080e7          	jalr	1230(ra) # 620 <write>
 15a:	40000793          	li	a5,1024
 15e:	04f50763          	beq	a0,a5,1ac <main+0x17e>
    {
        printf("TEST_DRIVER_ERROR: Failed to write target LBN placeholder in "
 162:	00001517          	auipc	a0,0x1
 166:	b7e50513          	addi	a0,a0,-1154 # ce0 <malloc+0x26a>
 16a:	00001097          	auipc	ra,0x1
 16e:	84e080e7          	jalr	-1970(ra) # 9b8 <printf>
               "Phase 0\n");
        close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	4b4080e7          	jalr	1204(ra) # 628 <close>
        exit(1);
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	482080e7          	jalr	1154(ra) # 600 <exit>
            printf("TEST_DRIVER_ERROR: Failed to write dummy block %d in Phase "
 186:	4581                	li	a1,0
 188:	00001517          	auipc	a0,0x1
 18c:	b1850513          	addi	a0,a0,-1256 # ca0 <malloc+0x22a>
 190:	00001097          	auipc	ra,0x1
 194:	828080e7          	jalr	-2008(ra) # 9b8 <printf>
            close(fd);
 198:	8526                	mv	a0,s1
 19a:	00000097          	auipc	ra,0x0
 19e:	48e080e7          	jalr	1166(ra) # 628 <close>
            exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	45c080e7          	jalr	1116(ra) # 600 <exit>
    }

    pbn0_for_test_lbn = get_disk_lbn(fd, TEST_FILE_LBN);
 1ac:	4585                	li	a1,1
 1ae:	8526                	mv	a0,s1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	508080e7          	jalr	1288(ra) # 6b8 <get_disk_lbn>
 1b8:	89aa                	mv	s3,a0
    if (pbn0_for_test_lbn <= 0)
 1ba:	04a05d63          	blez	a0,214 <main+0x1e6>
               "PBN0 %d for File LBN %d in Phase 0\n",
               pbn0_for_test_lbn, TEST_FILE_LBN);
        close(fd);
        exit(1);
    }
    close(fd);
 1be:	8526                	mv	a0,s1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	468080e7          	jalr	1128(ra) # 628 <close>
    printf("TEST_DRIVER_INFO: File LBN %d is mapped to Disk LBN (PBN0) %d.\n",
 1c8:	864e                	mv	a2,s3
 1ca:	4585                	li	a1,1
 1cc:	00001517          	auipc	a0,0x1
 1d0:	bbc50513          	addi	a0,a0,-1092 # d88 <malloc+0x312>
 1d4:	00000097          	auipc	ra,0x0
 1d8:	7e4080e7          	jalr	2020(ra) # 9b8 <printf>
           TEST_FILE_LBN, pbn0_for_test_lbn);
    printf("TEST_DRIVER: Phase 0 - Setup complete.\n\n");
 1dc:	00001517          	auipc	a0,0x1
 1e0:	bec50513          	addi	a0,a0,-1044 # dc8 <malloc+0x352>
 1e4:	00000097          	auipc	ra,0x0
 1e8:	7d4080e7          	jalr	2004(ra) # 9b8 <printf>

    switch (scenario)
 1ec:	04090863          	beqz	s2,23c <main+0x20e>
 1f0:	4785                	li	a5,1
 1f2:	0cf90363          	beq	s2,a5,2b8 <main+0x28a>
        printf("TEST_DRIVER: Scenario 1 - Simulating Disk 0 Failure.\n");
        force_disk_fail(0);
        force_fail(-1);
        break;
    default:
        fprintf(2, "TEST_DRIVER_ERROR: Unknown scenario %d\n", scenario);
 1f6:	864a                	mv	a2,s2
 1f8:	00001597          	auipc	a1,0x1
 1fc:	c6858593          	addi	a1,a1,-920 # e60 <malloc+0x3ea>
 200:	4509                	li	a0,2
 202:	00000097          	auipc	ra,0x0
 206:	788080e7          	jalr	1928(ra) # 98a <fprintf>
        exit(1);
 20a:	4505                	li	a0,1
 20c:	00000097          	auipc	ra,0x0
 210:	3f4080e7          	jalr	1012(ra) # 600 <exit>
        printf("TEST_DRIVER_ERROR: get_disk_lbn failed or returned invalid "
 214:	4605                	li	a2,1
 216:	85aa                	mv	a1,a0
 218:	00001517          	auipc	a0,0x1
 21c:	b1050513          	addi	a0,a0,-1264 # d28 <malloc+0x2b2>
 220:	00000097          	auipc	ra,0x0
 224:	798080e7          	jalr	1944(ra) # 9b8 <printf>
        close(fd);
 228:	8526                	mv	a0,s1
 22a:	00000097          	auipc	ra,0x0
 22e:	3fe080e7          	jalr	1022(ra) # 628 <close>
        exit(1);
 232:	4505                	li	a0,1
 234:	00000097          	auipc	ra,0x0
 238:	3cc080e7          	jalr	972(ra) # 600 <exit>
        printf("TEST_DRIVER: Scenario 0 - Normal Write.\n");
 23c:	00001517          	auipc	a0,0x1
 240:	bbc50513          	addi	a0,a0,-1092 # df8 <malloc+0x382>
 244:	00000097          	auipc	ra,0x0
 248:	774080e7          	jalr	1908(ra) # 9b8 <printf>
        force_disk_fail(-1);
 24c:	557d                	li	a0,-1
 24e:	00000097          	auipc	ra,0x0
 252:	47a080e7          	jalr	1146(ra) # 6c8 <force_disk_fail>
        force_fail(-1);
 256:	557d                	li	a0,-1
 258:	00000097          	auipc	ra,0x0
 25c:	448080e7          	jalr	1096(ra) # 6a0 <force_fail>
    }

    printf("TEST_DRIVER: Issuing standard write to File LBN %d.\n",
 260:	4585                	li	a1,1
 262:	00001517          	auipc	a0,0x1
 266:	c2650513          	addi	a0,a0,-986 # e88 <malloc+0x412>
 26a:	00000097          	auipc	ra,0x0
 26e:	74e080e7          	jalr	1870(ra) # 9b8 <printf>
           TEST_FILE_LBN);
    fd = open("raid1_sim_target.dat", O_RDWR);
 272:	4589                	li	a1,2
 274:	00001517          	auipc	a0,0x1
 278:	9c450513          	addi	a0,a0,-1596 # c38 <malloc+0x1c2>
 27c:	00000097          	auipc	ra,0x0
 280:	3c4080e7          	jalr	964(ra) # 640 <open>
 284:	84aa                	mv	s1,a0
    if (fd < 0)
 286:	04055c63          	bgez	a0,2de <main+0x2b0>
    {
        printf("TEST_DRIVER_ERROR: Failed to open file for test write.\n");
 28a:	00001517          	auipc	a0,0x1
 28e:	c3650513          	addi	a0,a0,-970 # ec0 <malloc+0x44a>
 292:	00000097          	auipc	ra,0x0
 296:	726080e7          	jalr	1830(ra) # 9b8 <printf>
        force_disk_fail(-1);
 29a:	557d                	li	a0,-1
 29c:	00000097          	auipc	ra,0x0
 2a0:	42c080e7          	jalr	1068(ra) # 6c8 <force_disk_fail>
        force_fail(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	3fa080e7          	jalr	1018(ra) # 6a0 <force_fail>
        exit(1);
 2ae:	4505                	li	a0,1
 2b0:	00000097          	auipc	ra,0x0
 2b4:	350080e7          	jalr	848(ra) # 600 <exit>
        printf("TEST_DRIVER: Scenario 1 - Simulating Disk 0 Failure.\n");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	b7050513          	addi	a0,a0,-1168 # e28 <malloc+0x3b2>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	6f8080e7          	jalr	1784(ra) # 9b8 <printf>
        force_disk_fail(0);
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	3fe080e7          	jalr	1022(ra) # 6c8 <force_disk_fail>
        force_fail(-1);
 2d2:	557d                	li	a0,-1
 2d4:	00000097          	auipc	ra,0x0
 2d8:	3cc080e7          	jalr	972(ra) # 6a0 <force_fail>
        break;
 2dc:	b751                	j	260 <main+0x232>
    }
    for (int i = 0; i < TEST_FILE_LBN; i++)
        read(fd, dummy_buffer, BSIZE);
 2de:	40000613          	li	a2,1024
 2e2:	00001597          	auipc	a1,0x1
 2e6:	0f658593          	addi	a1,a1,246 # 13d8 <dummy_buffer>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	32e080e7          	jalr	814(ra) # 618 <read>
    if (write(fd, test_data_buffer, BSIZE) != BSIZE)
 2f2:	40000613          	li	a2,1024
 2f6:	00001597          	auipc	a1,0x1
 2fa:	ce258593          	addi	a1,a1,-798 # fd8 <test_data_buffer>
 2fe:	8526                	mv	a0,s1
 300:	00000097          	auipc	ra,0x0
 304:	320080e7          	jalr	800(ra) # 620 <write>
 308:	40000793          	li	a5,1024
 30c:	02f50e63          	beq	a0,a5,348 <main+0x31a>
    {
        printf("TEST_DRIVER_ERROR: Failed to 'seek' by reading dummy block.\n");
 310:	00001517          	auipc	a0,0x1
 314:	be850513          	addi	a0,a0,-1048 # ef8 <malloc+0x482>
 318:	00000097          	auipc	ra,0x0
 31c:	6a0080e7          	jalr	1696(ra) # 9b8 <printf>
        close(fd);
 320:	8526                	mv	a0,s1
 322:	00000097          	auipc	ra,0x0
 326:	306080e7          	jalr	774(ra) # 628 <close>
        force_disk_fail(-1);
 32a:	557d                	li	a0,-1
 32c:	00000097          	auipc	ra,0x0
 330:	39c080e7          	jalr	924(ra) # 6c8 <force_disk_fail>
        force_fail(-1);
 334:	557d                	li	a0,-1
 336:	00000097          	auipc	ra,0x0
 33a:	36a080e7          	jalr	874(ra) # 6a0 <force_fail>
        exit(1);
 33e:	4505                	li	a0,1
 340:	00000097          	auipc	ra,0x0
 344:	2c0080e7          	jalr	704(ra) # 600 <exit>
    }
    close(fd);
 348:	8526                	mv	a0,s1
 34a:	00000097          	auipc	ra,0x0
 34e:	2de080e7          	jalr	734(ra) # 628 <close>

    printf("TEST_DRIVER: Test write issued. Calling sync().\n");
 352:	00001517          	auipc	a0,0x1
 356:	be650513          	addi	a0,a0,-1050 # f38 <malloc+0x4c2>
 35a:	00000097          	auipc	ra,0x0
 35e:	65e080e7          	jalr	1630(ra) # 9b8 <printf>
    force_disk_fail(-1);
 362:	557d                	li	a0,-1
 364:	00000097          	auipc	ra,0x0
 368:	364080e7          	jalr	868(ra) # 6c8 <force_disk_fail>
    force_fail(-1);
 36c:	557d                	li	a0,-1
 36e:	00000097          	auipc	ra,0x0
 372:	332080e7          	jalr	818(ra) # 6a0 <force_fail>
    printf("TEST_DRIVER: Scenario %d finished. Check kernel output.\n",
 376:	85ca                	mv	a1,s2
 378:	00001517          	auipc	a0,0x1
 37c:	bf850513          	addi	a0,a0,-1032 # f70 <malloc+0x4fa>
 380:	00000097          	auipc	ra,0x0
 384:	638080e7          	jalr	1592(ra) # 9b8 <printf>
           scenario);
    exit(0);
 388:	4501                	li	a0,0
 38a:	00000097          	auipc	ra,0x0
 38e:	276080e7          	jalr	630(ra) # 600 <exit>

0000000000000392 <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 398:	87aa                	mv	a5,a0
 39a:	0585                	addi	a1,a1,1
 39c:	0785                	addi	a5,a5,1
 39e:	fff5c703          	lbu	a4,-1(a1)
 3a2:	fee78fa3          	sb	a4,-1(a5)
 3a6:	fb75                	bnez	a4,39a <strcpy+0x8>
        ;
    return os;
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <strcmp>:

int strcmp(const char *p, const char *q)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e422                	sd	s0,8(sp)
 3b2:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	cb91                	beqz	a5,3cc <strcmp+0x1e>
 3ba:	0005c703          	lbu	a4,0(a1)
 3be:	00f71763          	bne	a4,a5,3cc <strcmp+0x1e>
        p++, q++;
 3c2:	0505                	addi	a0,a0,1
 3c4:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	fbe5                	bnez	a5,3ba <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 3cc:	0005c503          	lbu	a0,0(a1)
}
 3d0:	40a7853b          	subw	a0,a5,a0
 3d4:	6422                	ld	s0,8(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret

00000000000003da <strlen>:

uint strlen(const char *s)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e422                	sd	s0,8(sp)
 3de:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	cf91                	beqz	a5,400 <strlen+0x26>
 3e6:	0505                	addi	a0,a0,1
 3e8:	87aa                	mv	a5,a0
 3ea:	4685                	li	a3,1
 3ec:	9e89                	subw	a3,a3,a0
 3ee:	00f6853b          	addw	a0,a3,a5
 3f2:	0785                	addi	a5,a5,1
 3f4:	fff7c703          	lbu	a4,-1(a5)
 3f8:	fb7d                	bnez	a4,3ee <strlen+0x14>
        ;
    return n;
}
 3fa:	6422                	ld	s0,8(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret
    for (n = 0; s[n]; n++)
 400:	4501                	li	a0,0
 402:	bfe5                	j	3fa <strlen+0x20>

0000000000000404 <memset>:

void *memset(void *dst, int c, uint n)
{
 404:	1141                	addi	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 40a:	ca19                	beqz	a2,420 <memset+0x1c>
 40c:	87aa                	mv	a5,a0
 40e:	1602                	slli	a2,a2,0x20
 410:	9201                	srli	a2,a2,0x20
 412:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 416:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 41a:	0785                	addi	a5,a5,1
 41c:	fee79de3          	bne	a5,a4,416 <memset+0x12>
    }
    return dst;
}
 420:	6422                	ld	s0,8(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret

0000000000000426 <strchr>:

char *strchr(const char *s, char c)
{
 426:	1141                	addi	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	addi	s0,sp,16
    for (; *s; s++)
 42c:	00054783          	lbu	a5,0(a0)
 430:	cb99                	beqz	a5,446 <strchr+0x20>
        if (*s == c)
 432:	00f58763          	beq	a1,a5,440 <strchr+0x1a>
    for (; *s; s++)
 436:	0505                	addi	a0,a0,1
 438:	00054783          	lbu	a5,0(a0)
 43c:	fbfd                	bnez	a5,432 <strchr+0xc>
            return (char *)s;
    return 0;
 43e:	4501                	li	a0,0
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
    return 0;
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <strchr+0x1a>

000000000000044a <gets>:

char *gets(char *buf, int max)
{
 44a:	711d                	addi	sp,sp,-96
 44c:	ec86                	sd	ra,88(sp)
 44e:	e8a2                	sd	s0,80(sp)
 450:	e4a6                	sd	s1,72(sp)
 452:	e0ca                	sd	s2,64(sp)
 454:	fc4e                	sd	s3,56(sp)
 456:	f852                	sd	s4,48(sp)
 458:	f456                	sd	s5,40(sp)
 45a:	f05a                	sd	s6,32(sp)
 45c:	ec5e                	sd	s7,24(sp)
 45e:	1080                	addi	s0,sp,96
 460:	8baa                	mv	s7,a0
 462:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 464:	892a                	mv	s2,a0
 466:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 468:	4aa9                	li	s5,10
 46a:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 46c:	89a6                	mv	s3,s1
 46e:	2485                	addiw	s1,s1,1
 470:	0344d863          	bge	s1,s4,4a0 <gets+0x56>
        cc = read(0, &c, 1);
 474:	4605                	li	a2,1
 476:	faf40593          	addi	a1,s0,-81
 47a:	4501                	li	a0,0
 47c:	00000097          	auipc	ra,0x0
 480:	19c080e7          	jalr	412(ra) # 618 <read>
        if (cc < 1)
 484:	00a05e63          	blez	a0,4a0 <gets+0x56>
        buf[i++] = c;
 488:	faf44783          	lbu	a5,-81(s0)
 48c:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 490:	01578763          	beq	a5,s5,49e <gets+0x54>
 494:	0905                	addi	s2,s2,1
 496:	fd679be3          	bne	a5,s6,46c <gets+0x22>
    for (i = 0; i + 1 < max;)
 49a:	89a6                	mv	s3,s1
 49c:	a011                	j	4a0 <gets+0x56>
 49e:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 4a0:	99de                	add	s3,s3,s7
 4a2:	00098023          	sb	zero,0(s3)
    return buf;
}
 4a6:	855e                	mv	a0,s7
 4a8:	60e6                	ld	ra,88(sp)
 4aa:	6446                	ld	s0,80(sp)
 4ac:	64a6                	ld	s1,72(sp)
 4ae:	6906                	ld	s2,64(sp)
 4b0:	79e2                	ld	s3,56(sp)
 4b2:	7a42                	ld	s4,48(sp)
 4b4:	7aa2                	ld	s5,40(sp)
 4b6:	7b02                	ld	s6,32(sp)
 4b8:	6be2                	ld	s7,24(sp)
 4ba:	6125                	addi	sp,sp,96
 4bc:	8082                	ret

00000000000004be <stat>:

int stat(const char *n, struct stat *st)
{
 4be:	1101                	addi	sp,sp,-32
 4c0:	ec06                	sd	ra,24(sp)
 4c2:	e822                	sd	s0,16(sp)
 4c4:	e426                	sd	s1,8(sp)
 4c6:	e04a                	sd	s2,0(sp)
 4c8:	1000                	addi	s0,sp,32
 4ca:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 4cc:	4581                	li	a1,0
 4ce:	00000097          	auipc	ra,0x0
 4d2:	172080e7          	jalr	370(ra) # 640 <open>
    if (fd < 0)
 4d6:	02054563          	bltz	a0,500 <stat+0x42>
 4da:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 4dc:	85ca                	mv	a1,s2
 4de:	00000097          	auipc	ra,0x0
 4e2:	17a080e7          	jalr	378(ra) # 658 <fstat>
 4e6:	892a                	mv	s2,a0
    close(fd);
 4e8:	8526                	mv	a0,s1
 4ea:	00000097          	auipc	ra,0x0
 4ee:	13e080e7          	jalr	318(ra) # 628 <close>
    return r;
}
 4f2:	854a                	mv	a0,s2
 4f4:	60e2                	ld	ra,24(sp)
 4f6:	6442                	ld	s0,16(sp)
 4f8:	64a2                	ld	s1,8(sp)
 4fa:	6902                	ld	s2,0(sp)
 4fc:	6105                	addi	sp,sp,32
 4fe:	8082                	ret
        return -1;
 500:	597d                	li	s2,-1
 502:	bfc5                	j	4f2 <stat+0x34>

0000000000000504 <atoi>:

int atoi(const char *s)
{
 504:	1141                	addi	sp,sp,-16
 506:	e422                	sd	s0,8(sp)
 508:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 50a:	00054603          	lbu	a2,0(a0)
 50e:	fd06079b          	addiw	a5,a2,-48
 512:	0ff7f793          	andi	a5,a5,255
 516:	4725                	li	a4,9
 518:	02f76963          	bltu	a4,a5,54a <atoi+0x46>
 51c:	86aa                	mv	a3,a0
    n = 0;
 51e:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 520:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 522:	0685                	addi	a3,a3,1
 524:	0025179b          	slliw	a5,a0,0x2
 528:	9fa9                	addw	a5,a5,a0
 52a:	0017979b          	slliw	a5,a5,0x1
 52e:	9fb1                	addw	a5,a5,a2
 530:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 534:	0006c603          	lbu	a2,0(a3)
 538:	fd06071b          	addiw	a4,a2,-48
 53c:	0ff77713          	andi	a4,a4,255
 540:	fee5f1e3          	bgeu	a1,a4,522 <atoi+0x1e>
    return n;
}
 544:	6422                	ld	s0,8(sp)
 546:	0141                	addi	sp,sp,16
 548:	8082                	ret
    n = 0;
 54a:	4501                	li	a0,0
 54c:	bfe5                	j	544 <atoi+0x40>

000000000000054e <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 54e:	1141                	addi	sp,sp,-16
 550:	e422                	sd	s0,8(sp)
 552:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 554:	02b57463          	bgeu	a0,a1,57c <memmove+0x2e>
    {
        while (n-- > 0)
 558:	00c05f63          	blez	a2,576 <memmove+0x28>
 55c:	1602                	slli	a2,a2,0x20
 55e:	9201                	srli	a2,a2,0x20
 560:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 564:	872a                	mv	a4,a0
            *dst++ = *src++;
 566:	0585                	addi	a1,a1,1
 568:	0705                	addi	a4,a4,1
 56a:	fff5c683          	lbu	a3,-1(a1)
 56e:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 572:	fee79ae3          	bne	a5,a4,566 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 576:	6422                	ld	s0,8(sp)
 578:	0141                	addi	sp,sp,16
 57a:	8082                	ret
        dst += n;
 57c:	00c50733          	add	a4,a0,a2
        src += n;
 580:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 582:	fec05ae3          	blez	a2,576 <memmove+0x28>
 586:	fff6079b          	addiw	a5,a2,-1
 58a:	1782                	slli	a5,a5,0x20
 58c:	9381                	srli	a5,a5,0x20
 58e:	fff7c793          	not	a5,a5
 592:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 594:	15fd                	addi	a1,a1,-1
 596:	177d                	addi	a4,a4,-1
 598:	0005c683          	lbu	a3,0(a1)
 59c:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 5a0:	fee79ae3          	bne	a5,a4,594 <memmove+0x46>
 5a4:	bfc9                	j	576 <memmove+0x28>

00000000000005a6 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 5a6:	1141                	addi	sp,sp,-16
 5a8:	e422                	sd	s0,8(sp)
 5aa:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 5ac:	ca05                	beqz	a2,5dc <memcmp+0x36>
 5ae:	fff6069b          	addiw	a3,a2,-1
 5b2:	1682                	slli	a3,a3,0x20
 5b4:	9281                	srli	a3,a3,0x20
 5b6:	0685                	addi	a3,a3,1
 5b8:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 5ba:	00054783          	lbu	a5,0(a0)
 5be:	0005c703          	lbu	a4,0(a1)
 5c2:	00e79863          	bne	a5,a4,5d2 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 5c6:	0505                	addi	a0,a0,1
        p2++;
 5c8:	0585                	addi	a1,a1,1
    while (n-- > 0)
 5ca:	fed518e3          	bne	a0,a3,5ba <memcmp+0x14>
    }
    return 0;
 5ce:	4501                	li	a0,0
 5d0:	a019                	j	5d6 <memcmp+0x30>
            return *p1 - *p2;
 5d2:	40e7853b          	subw	a0,a5,a4
}
 5d6:	6422                	ld	s0,8(sp)
 5d8:	0141                	addi	sp,sp,16
 5da:	8082                	ret
    return 0;
 5dc:	4501                	li	a0,0
 5de:	bfe5                	j	5d6 <memcmp+0x30>

00000000000005e0 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 5e0:	1141                	addi	sp,sp,-16
 5e2:	e406                	sd	ra,8(sp)
 5e4:	e022                	sd	s0,0(sp)
 5e6:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 5e8:	00000097          	auipc	ra,0x0
 5ec:	f66080e7          	jalr	-154(ra) # 54e <memmove>
}
 5f0:	60a2                	ld	ra,8(sp)
 5f2:	6402                	ld	s0,0(sp)
 5f4:	0141                	addi	sp,sp,16
 5f6:	8082                	ret

00000000000005f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5f8:	4885                	li	a7,1
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <exit>:
.global exit
exit:
 li a7, SYS_exit
 600:	4889                	li	a7,2
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <wait>:
.global wait
wait:
 li a7, SYS_wait
 608:	488d                	li	a7,3
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 610:	4891                	li	a7,4
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <read>:
.global read
read:
 li a7, SYS_read
 618:	4895                	li	a7,5
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <write>:
.global write
write:
 li a7, SYS_write
 620:	48c1                	li	a7,16
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <close>:
.global close
close:
 li a7, SYS_close
 628:	48d5                	li	a7,21
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <kill>:
.global kill
kill:
 li a7, SYS_kill
 630:	4899                	li	a7,6
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <exec>:
.global exec
exec:
 li a7, SYS_exec
 638:	489d                	li	a7,7
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <open>:
.global open
open:
 li a7, SYS_open
 640:	48bd                	li	a7,15
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 648:	48c5                	li	a7,17
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 650:	48c9                	li	a7,18
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 658:	48a1                	li	a7,8
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <link>:
.global link
link:
 li a7, SYS_link
 660:	48cd                	li	a7,19
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 668:	48d1                	li	a7,20
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 670:	48a5                	li	a7,9
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <dup>:
.global dup
dup:
 li a7, SYS_dup
 678:	48a9                	li	a7,10
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 680:	48ad                	li	a7,11
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 688:	48b1                	li	a7,12
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 690:	48b5                	li	a7,13
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 698:	48b9                	li	a7,14
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 6a0:	48d9                	li	a7,22
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 6a8:	48dd                	li	a7,23
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 6b0:	48e1                	li	a7,24
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 6b8:	48e5                	li	a7,25
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 6c0:	48e9                	li	a7,26
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 6c8:	48ed                	li	a7,27
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 6d0:	48f5                	li	a7,29
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 6d8:	48f1                	li	a7,28
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 6e0:	1101                	addi	sp,sp,-32
 6e2:	ec06                	sd	ra,24(sp)
 6e4:	e822                	sd	s0,16(sp)
 6e6:	1000                	addi	s0,sp,32
 6e8:	feb407a3          	sb	a1,-17(s0)
 6ec:	4605                	li	a2,1
 6ee:	fef40593          	addi	a1,s0,-17
 6f2:	00000097          	auipc	ra,0x0
 6f6:	f2e080e7          	jalr	-210(ra) # 620 <write>
 6fa:	60e2                	ld	ra,24(sp)
 6fc:	6442                	ld	s0,16(sp)
 6fe:	6105                	addi	sp,sp,32
 700:	8082                	ret

0000000000000702 <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 702:	7139                	addi	sp,sp,-64
 704:	fc06                	sd	ra,56(sp)
 706:	f822                	sd	s0,48(sp)
 708:	f426                	sd	s1,40(sp)
 70a:	f04a                	sd	s2,32(sp)
 70c:	ec4e                	sd	s3,24(sp)
 70e:	0080                	addi	s0,sp,64
 710:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 712:	c299                	beqz	a3,718 <printint+0x16>
 714:	0805c863          	bltz	a1,7a4 <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 718:	2581                	sext.w	a1,a1
    neg = 0;
 71a:	4881                	li	a7,0
 71c:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 720:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 722:	2601                	sext.w	a2,a2
 724:	00001517          	auipc	a0,0x1
 728:	89450513          	addi	a0,a0,-1900 # fb8 <digits>
 72c:	883a                	mv	a6,a4
 72e:	2705                	addiw	a4,a4,1
 730:	02c5f7bb          	remuw	a5,a1,a2
 734:	1782                	slli	a5,a5,0x20
 736:	9381                	srli	a5,a5,0x20
 738:	97aa                	add	a5,a5,a0
 73a:	0007c783          	lbu	a5,0(a5)
 73e:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 742:	0005879b          	sext.w	a5,a1
 746:	02c5d5bb          	divuw	a1,a1,a2
 74a:	0685                	addi	a3,a3,1
 74c:	fec7f0e3          	bgeu	a5,a2,72c <printint+0x2a>
    if (neg)
 750:	00088b63          	beqz	a7,766 <printint+0x64>
        buf[i++] = '-';
 754:	fd040793          	addi	a5,s0,-48
 758:	973e                	add	a4,a4,a5
 75a:	02d00793          	li	a5,45
 75e:	fef70823          	sb	a5,-16(a4)
 762:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 766:	02e05863          	blez	a4,796 <printint+0x94>
 76a:	fc040793          	addi	a5,s0,-64
 76e:	00e78933          	add	s2,a5,a4
 772:	fff78993          	addi	s3,a5,-1
 776:	99ba                	add	s3,s3,a4
 778:	377d                	addiw	a4,a4,-1
 77a:	1702                	slli	a4,a4,0x20
 77c:	9301                	srli	a4,a4,0x20
 77e:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 782:	fff94583          	lbu	a1,-1(s2)
 786:	8526                	mv	a0,s1
 788:	00000097          	auipc	ra,0x0
 78c:	f58080e7          	jalr	-168(ra) # 6e0 <putc>
    while (--i >= 0)
 790:	197d                	addi	s2,s2,-1
 792:	ff3918e3          	bne	s2,s3,782 <printint+0x80>
}
 796:	70e2                	ld	ra,56(sp)
 798:	7442                	ld	s0,48(sp)
 79a:	74a2                	ld	s1,40(sp)
 79c:	7902                	ld	s2,32(sp)
 79e:	69e2                	ld	s3,24(sp)
 7a0:	6121                	addi	sp,sp,64
 7a2:	8082                	ret
        x = -xx;
 7a4:	40b005bb          	negw	a1,a1
        neg = 1;
 7a8:	4885                	li	a7,1
        x = -xx;
 7aa:	bf8d                	j	71c <printint+0x1a>

00000000000007ac <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 7ac:	7119                	addi	sp,sp,-128
 7ae:	fc86                	sd	ra,120(sp)
 7b0:	f8a2                	sd	s0,112(sp)
 7b2:	f4a6                	sd	s1,104(sp)
 7b4:	f0ca                	sd	s2,96(sp)
 7b6:	ecce                	sd	s3,88(sp)
 7b8:	e8d2                	sd	s4,80(sp)
 7ba:	e4d6                	sd	s5,72(sp)
 7bc:	e0da                	sd	s6,64(sp)
 7be:	fc5e                	sd	s7,56(sp)
 7c0:	f862                	sd	s8,48(sp)
 7c2:	f466                	sd	s9,40(sp)
 7c4:	f06a                	sd	s10,32(sp)
 7c6:	ec6e                	sd	s11,24(sp)
 7c8:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 7ca:	0005c903          	lbu	s2,0(a1)
 7ce:	18090f63          	beqz	s2,96c <vprintf+0x1c0>
 7d2:	8aaa                	mv	s5,a0
 7d4:	8b32                	mv	s6,a2
 7d6:	00158493          	addi	s1,a1,1
    state = 0;
 7da:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 7dc:	02500a13          	li	s4,37
        {
            if (c == 'd')
 7e0:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 7e4:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 7e8:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 7ec:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f0:	00000b97          	auipc	s7,0x0
 7f4:	7c8b8b93          	addi	s7,s7,1992 # fb8 <digits>
 7f8:	a839                	j	816 <vprintf+0x6a>
                putc(fd, c);
 7fa:	85ca                	mv	a1,s2
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	ee2080e7          	jalr	-286(ra) # 6e0 <putc>
 806:	a019                	j	80c <vprintf+0x60>
        else if (state == '%')
 808:	01498f63          	beq	s3,s4,826 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 80c:	0485                	addi	s1,s1,1
 80e:	fff4c903          	lbu	s2,-1(s1)
 812:	14090d63          	beqz	s2,96c <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 816:	0009079b          	sext.w	a5,s2
        if (state == 0)
 81a:	fe0997e3          	bnez	s3,808 <vprintf+0x5c>
            if (c == '%')
 81e:	fd479ee3          	bne	a5,s4,7fa <vprintf+0x4e>
                state = '%';
 822:	89be                	mv	s3,a5
 824:	b7e5                	j	80c <vprintf+0x60>
            if (c == 'd')
 826:	05878063          	beq	a5,s8,866 <vprintf+0xba>
            else if (c == 'l')
 82a:	05978c63          	beq	a5,s9,882 <vprintf+0xd6>
            else if (c == 'x')
 82e:	07a78863          	beq	a5,s10,89e <vprintf+0xf2>
            else if (c == 'p')
 832:	09b78463          	beq	a5,s11,8ba <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 836:	07300713          	li	a4,115
 83a:	0ce78663          	beq	a5,a4,906 <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 83e:	06300713          	li	a4,99
 842:	0ee78e63          	beq	a5,a4,93e <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 846:	11478863          	beq	a5,s4,956 <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 84a:	85d2                	mv	a1,s4
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	e92080e7          	jalr	-366(ra) # 6e0 <putc>
                putc(fd, c);
 856:	85ca                	mv	a1,s2
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	e86080e7          	jalr	-378(ra) # 6e0 <putc>
            }
            state = 0;
 862:	4981                	li	s3,0
 864:	b765                	j	80c <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 866:	008b0913          	addi	s2,s6,8
 86a:	4685                	li	a3,1
 86c:	4629                	li	a2,10
 86e:	000b2583          	lw	a1,0(s6)
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	e8e080e7          	jalr	-370(ra) # 702 <printint>
 87c:	8b4a                	mv	s6,s2
            state = 0;
 87e:	4981                	li	s3,0
 880:	b771                	j	80c <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 882:	008b0913          	addi	s2,s6,8
 886:	4681                	li	a3,0
 888:	4629                	li	a2,10
 88a:	000b2583          	lw	a1,0(s6)
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	e72080e7          	jalr	-398(ra) # 702 <printint>
 898:	8b4a                	mv	s6,s2
            state = 0;
 89a:	4981                	li	s3,0
 89c:	bf85                	j	80c <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 89e:	008b0913          	addi	s2,s6,8
 8a2:	4681                	li	a3,0
 8a4:	4641                	li	a2,16
 8a6:	000b2583          	lw	a1,0(s6)
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	e56080e7          	jalr	-426(ra) # 702 <printint>
 8b4:	8b4a                	mv	s6,s2
            state = 0;
 8b6:	4981                	li	s3,0
 8b8:	bf91                	j	80c <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 8ba:	008b0793          	addi	a5,s6,8
 8be:	f8f43423          	sd	a5,-120(s0)
 8c2:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 8c6:	03000593          	li	a1,48
 8ca:	8556                	mv	a0,s5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	e14080e7          	jalr	-492(ra) # 6e0 <putc>
    putc(fd, 'x');
 8d4:	85ea                	mv	a1,s10
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	e08080e7          	jalr	-504(ra) # 6e0 <putc>
 8e0:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e2:	03c9d793          	srli	a5,s3,0x3c
 8e6:	97de                	add	a5,a5,s7
 8e8:	0007c583          	lbu	a1,0(a5)
 8ec:	8556                	mv	a0,s5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	df2080e7          	jalr	-526(ra) # 6e0 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8f6:	0992                	slli	s3,s3,0x4
 8f8:	397d                	addiw	s2,s2,-1
 8fa:	fe0914e3          	bnez	s2,8e2 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 8fe:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 902:	4981                	li	s3,0
 904:	b721                	j	80c <vprintf+0x60>
                s = va_arg(ap, char *);
 906:	008b0993          	addi	s3,s6,8
 90a:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 90e:	02090163          	beqz	s2,930 <vprintf+0x184>
                while (*s != 0)
 912:	00094583          	lbu	a1,0(s2)
 916:	c9a1                	beqz	a1,966 <vprintf+0x1ba>
                    putc(fd, *s);
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	dc6080e7          	jalr	-570(ra) # 6e0 <putc>
                    s++;
 922:	0905                	addi	s2,s2,1
                while (*s != 0)
 924:	00094583          	lbu	a1,0(s2)
 928:	f9e5                	bnez	a1,918 <vprintf+0x16c>
                s = va_arg(ap, char *);
 92a:	8b4e                	mv	s6,s3
            state = 0;
 92c:	4981                	li	s3,0
 92e:	bdf9                	j	80c <vprintf+0x60>
                    s = "(null)";
 930:	00000917          	auipc	s2,0x0
 934:	68090913          	addi	s2,s2,1664 # fb0 <malloc+0x53a>
                while (*s != 0)
 938:	02800593          	li	a1,40
 93c:	bff1                	j	918 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 93e:	008b0913          	addi	s2,s6,8
 942:	000b4583          	lbu	a1,0(s6)
 946:	8556                	mv	a0,s5
 948:	00000097          	auipc	ra,0x0
 94c:	d98080e7          	jalr	-616(ra) # 6e0 <putc>
 950:	8b4a                	mv	s6,s2
            state = 0;
 952:	4981                	li	s3,0
 954:	bd65                	j	80c <vprintf+0x60>
                putc(fd, c);
 956:	85d2                	mv	a1,s4
 958:	8556                	mv	a0,s5
 95a:	00000097          	auipc	ra,0x0
 95e:	d86080e7          	jalr	-634(ra) # 6e0 <putc>
            state = 0;
 962:	4981                	li	s3,0
 964:	b565                	j	80c <vprintf+0x60>
                s = va_arg(ap, char *);
 966:	8b4e                	mv	s6,s3
            state = 0;
 968:	4981                	li	s3,0
 96a:	b54d                	j	80c <vprintf+0x60>
        }
    }
}
 96c:	70e6                	ld	ra,120(sp)
 96e:	7446                	ld	s0,112(sp)
 970:	74a6                	ld	s1,104(sp)
 972:	7906                	ld	s2,96(sp)
 974:	69e6                	ld	s3,88(sp)
 976:	6a46                	ld	s4,80(sp)
 978:	6aa6                	ld	s5,72(sp)
 97a:	6b06                	ld	s6,64(sp)
 97c:	7be2                	ld	s7,56(sp)
 97e:	7c42                	ld	s8,48(sp)
 980:	7ca2                	ld	s9,40(sp)
 982:	7d02                	ld	s10,32(sp)
 984:	6de2                	ld	s11,24(sp)
 986:	6109                	addi	sp,sp,128
 988:	8082                	ret

000000000000098a <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 98a:	715d                	addi	sp,sp,-80
 98c:	ec06                	sd	ra,24(sp)
 98e:	e822                	sd	s0,16(sp)
 990:	1000                	addi	s0,sp,32
 992:	e010                	sd	a2,0(s0)
 994:	e414                	sd	a3,8(s0)
 996:	e818                	sd	a4,16(s0)
 998:	ec1c                	sd	a5,24(s0)
 99a:	03043023          	sd	a6,32(s0)
 99e:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 9a2:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 9a6:	8622                	mv	a2,s0
 9a8:	00000097          	auipc	ra,0x0
 9ac:	e04080e7          	jalr	-508(ra) # 7ac <vprintf>
}
 9b0:	60e2                	ld	ra,24(sp)
 9b2:	6442                	ld	s0,16(sp)
 9b4:	6161                	addi	sp,sp,80
 9b6:	8082                	ret

00000000000009b8 <printf>:

void printf(const char *fmt, ...)
{
 9b8:	711d                	addi	sp,sp,-96
 9ba:	ec06                	sd	ra,24(sp)
 9bc:	e822                	sd	s0,16(sp)
 9be:	1000                	addi	s0,sp,32
 9c0:	e40c                	sd	a1,8(s0)
 9c2:	e810                	sd	a2,16(s0)
 9c4:	ec14                	sd	a3,24(s0)
 9c6:	f018                	sd	a4,32(s0)
 9c8:	f41c                	sd	a5,40(s0)
 9ca:	03043823          	sd	a6,48(s0)
 9ce:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 9d2:	00840613          	addi	a2,s0,8
 9d6:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 9da:	85aa                	mv	a1,a0
 9dc:	4505                	li	a0,1
 9de:	00000097          	auipc	ra,0x0
 9e2:	dce080e7          	jalr	-562(ra) # 7ac <vprintf>
}
 9e6:	60e2                	ld	ra,24(sp)
 9e8:	6442                	ld	s0,16(sp)
 9ea:	6125                	addi	sp,sp,96
 9ec:	8082                	ret

00000000000009ee <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 9ee:	1141                	addi	sp,sp,-16
 9f0:	e422                	sd	s0,8(sp)
 9f2:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 9f4:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f8:	00000797          	auipc	a5,0x0
 9fc:	5d87b783          	ld	a5,1496(a5) # fd0 <freep>
 a00:	a805                	j	a30 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 a02:	4618                	lw	a4,8(a2)
 a04:	9db9                	addw	a1,a1,a4
 a06:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 a0a:	6398                	ld	a4,0(a5)
 a0c:	6318                	ld	a4,0(a4)
 a0e:	fee53823          	sd	a4,-16(a0)
 a12:	a091                	j	a56 <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 a14:	ff852703          	lw	a4,-8(a0)
 a18:	9e39                	addw	a2,a2,a4
 a1a:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 a1c:	ff053703          	ld	a4,-16(a0)
 a20:	e398                	sd	a4,0(a5)
 a22:	a099                	j	a68 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a24:	6398                	ld	a4,0(a5)
 a26:	00e7e463          	bltu	a5,a4,a2e <free+0x40>
 a2a:	00e6ea63          	bltu	a3,a4,a3e <free+0x50>
{
 a2e:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a30:	fed7fae3          	bgeu	a5,a3,a24 <free+0x36>
 a34:	6398                	ld	a4,0(a5)
 a36:	00e6e463          	bltu	a3,a4,a3e <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3a:	fee7eae3          	bltu	a5,a4,a2e <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 a3e:	ff852583          	lw	a1,-8(a0)
 a42:	6390                	ld	a2,0(a5)
 a44:	02059713          	slli	a4,a1,0x20
 a48:	9301                	srli	a4,a4,0x20
 a4a:	0712                	slli	a4,a4,0x4
 a4c:	9736                	add	a4,a4,a3
 a4e:	fae60ae3          	beq	a2,a4,a02 <free+0x14>
        bp->s.ptr = p->s.ptr;
 a52:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 a56:	4790                	lw	a2,8(a5)
 a58:	02061713          	slli	a4,a2,0x20
 a5c:	9301                	srli	a4,a4,0x20
 a5e:	0712                	slli	a4,a4,0x4
 a60:	973e                	add	a4,a4,a5
 a62:	fae689e3          	beq	a3,a4,a14 <free+0x26>
    }
    else
        p->s.ptr = bp;
 a66:	e394                	sd	a3,0(a5)
    freep = p;
 a68:	00000717          	auipc	a4,0x0
 a6c:	56f73423          	sd	a5,1384(a4) # fd0 <freep>
}
 a70:	6422                	ld	s0,8(sp)
 a72:	0141                	addi	sp,sp,16
 a74:	8082                	ret

0000000000000a76 <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 a76:	7139                	addi	sp,sp,-64
 a78:	fc06                	sd	ra,56(sp)
 a7a:	f822                	sd	s0,48(sp)
 a7c:	f426                	sd	s1,40(sp)
 a7e:	f04a                	sd	s2,32(sp)
 a80:	ec4e                	sd	s3,24(sp)
 a82:	e852                	sd	s4,16(sp)
 a84:	e456                	sd	s5,8(sp)
 a86:	e05a                	sd	s6,0(sp)
 a88:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a8a:	02051493          	slli	s1,a0,0x20
 a8e:	9081                	srli	s1,s1,0x20
 a90:	04bd                	addi	s1,s1,15
 a92:	8091                	srli	s1,s1,0x4
 a94:	0014899b          	addiw	s3,s1,1
 a98:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 a9a:	00000517          	auipc	a0,0x0
 a9e:	53653503          	ld	a0,1334(a0) # fd0 <freep>
 aa2:	c515                	beqz	a0,ace <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 aa4:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 aa6:	4798                	lw	a4,8(a5)
 aa8:	02977f63          	bgeu	a4,s1,ae6 <malloc+0x70>
 aac:	8a4e                	mv	s4,s3
 aae:	0009871b          	sext.w	a4,s3
 ab2:	6685                	lui	a3,0x1
 ab4:	00d77363          	bgeu	a4,a3,aba <malloc+0x44>
 ab8:	6a05                	lui	s4,0x1
 aba:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 abe:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 ac2:	00000917          	auipc	s2,0x0
 ac6:	50e90913          	addi	s2,s2,1294 # fd0 <freep>
    if (p == (char *)-1)
 aca:	5afd                	li	s5,-1
 acc:	a88d                	j	b3e <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 ace:	00001797          	auipc	a5,0x1
 ad2:	d0a78793          	addi	a5,a5,-758 # 17d8 <base>
 ad6:	00000717          	auipc	a4,0x0
 ada:	4ef73d23          	sd	a5,1274(a4) # fd0 <freep>
 ade:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 ae0:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 ae4:	b7e1                	j	aac <malloc+0x36>
            if (p->s.size == nunits)
 ae6:	02e48b63          	beq	s1,a4,b1c <malloc+0xa6>
                p->s.size -= nunits;
 aea:	4137073b          	subw	a4,a4,s3
 aee:	c798                	sw	a4,8(a5)
                p += p->s.size;
 af0:	1702                	slli	a4,a4,0x20
 af2:	9301                	srli	a4,a4,0x20
 af4:	0712                	slli	a4,a4,0x4
 af6:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 af8:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 afc:	00000717          	auipc	a4,0x0
 b00:	4ca73a23          	sd	a0,1236(a4) # fd0 <freep>
            return (void *)(p + 1);
 b04:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 b08:	70e2                	ld	ra,56(sp)
 b0a:	7442                	ld	s0,48(sp)
 b0c:	74a2                	ld	s1,40(sp)
 b0e:	7902                	ld	s2,32(sp)
 b10:	69e2                	ld	s3,24(sp)
 b12:	6a42                	ld	s4,16(sp)
 b14:	6aa2                	ld	s5,8(sp)
 b16:	6b02                	ld	s6,0(sp)
 b18:	6121                	addi	sp,sp,64
 b1a:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 b1c:	6398                	ld	a4,0(a5)
 b1e:	e118                	sd	a4,0(a0)
 b20:	bff1                	j	afc <malloc+0x86>
    hp->s.size = nu;
 b22:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 b26:	0541                	addi	a0,a0,16
 b28:	00000097          	auipc	ra,0x0
 b2c:	ec6080e7          	jalr	-314(ra) # 9ee <free>
    return freep;
 b30:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 b34:	d971                	beqz	a0,b08 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 b36:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 b38:	4798                	lw	a4,8(a5)
 b3a:	fa9776e3          	bgeu	a4,s1,ae6 <malloc+0x70>
        if (p == freep)
 b3e:	00093703          	ld	a4,0(s2)
 b42:	853e                	mv	a0,a5
 b44:	fef719e3          	bne	a4,a5,b36 <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 b48:	8552                	mv	a0,s4
 b4a:	00000097          	auipc	ra,0x0
 b4e:	b3e080e7          	jalr	-1218(ra) # 688 <sbrk>
    if (p == (char *)-1)
 b52:	fd5518e3          	bne	a0,s5,b22 <malloc+0xac>
                return 0;
 b56:	4501                	li	a0,0
 b58:	bf45                	j	b08 <malloc+0x92>
