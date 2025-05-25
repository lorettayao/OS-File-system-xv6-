
user/_mp4_2_mirror_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fill_data>:
char pbn0_content[BSIZE];
char pbn1_content[BSIZE];
char expected_data[BSIZE];

void fill_data(char *buf, int lbn, char pattern_char)
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
    memset(buf, pattern_char, BSIZE);
  12:	40000613          	li	a2,1024
  16:	00000097          	auipc	ra,0x0
  1a:	406080e7          	jalr	1030(ra) # 41c <memset>
    buf[0] = (char)lbn;
  1e:	01248023          	sb	s2,0(s1)
}
  22:	60e2                	ld	ra,24(sp)
  24:	6442                	ld	s0,16(sp)
  26:	64a2                	ld	s1,8(sp)
  28:	6902                	ld	s2,0(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <compare_buffers>:

int compare_buffers(const char *buf1, const char *buf2, int size,
                    const char *context_msg)
{
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	1000                	addi	s0,sp,32
  38:	84b6                	mv	s1,a3
    if (memcmp(buf1, buf2, size) != 0)
  3a:	00000097          	auipc	ra,0x0
  3e:	584080e7          	jalr	1412(ra) # 5be <memcmp>
  42:	e511                	bnez	a0,4e <compare_buffers+0x20>
    {
        printf("  ERROR: Data Mismatch! Context: %s\n", context_msg);
        return -1;
    }
    return 0;
}
  44:	60e2                	ld	ra,24(sp)
  46:	6442                	ld	s0,16(sp)
  48:	64a2                	ld	s1,8(sp)
  4a:	6105                	addi	sp,sp,32
  4c:	8082                	ret
        printf("  ERROR: Data Mismatch! Context: %s\n", context_msg);
  4e:	85a6                	mv	a1,s1
  50:	00001517          	auipc	a0,0x1
  54:	b2850513          	addi	a0,a0,-1240 # b78 <malloc+0xea>
  58:	00001097          	auipc	ra,0x1
  5c:	978080e7          	jalr	-1672(ra) # 9d0 <printf>
        return -1;
  60:	557d                	li	a0,-1
  62:	b7cd                	j	44 <compare_buffers+0x16>

0000000000000064 <read_physical_block_wrapper>:

int read_physical_block_wrapper(int pbn, char *buf, const char *context_msg)
{
  64:	7179                	addi	sp,sp,-48
  66:	f406                	sd	ra,40(sp)
  68:	f022                	sd	s0,32(sp)
  6a:	ec26                	sd	s1,24(sp)
  6c:	e84a                	sd	s2,16(sp)
  6e:	e44e                	sd	s3,8(sp)
  70:	1800                	addi	s0,sp,48
  72:	84aa                	mv	s1,a0
  74:	892e                	mv	s2,a1
  76:	89b2                	mv	s3,a2
    printf("  Attempting raw_read for PBN %d (%s)...\n", pbn, context_msg);
  78:	85aa                	mv	a1,a0
  7a:	00001517          	auipc	a0,0x1
  7e:	b2650513          	addi	a0,a0,-1242 # ba0 <malloc+0x112>
  82:	00001097          	auipc	ra,0x1
  86:	94e080e7          	jalr	-1714(ra) # 9d0 <printf>
    int ret = raw_read(pbn, buf);
  8a:	85ca                	mv	a1,s2
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	63a080e7          	jalr	1594(ra) # 6c8 <raw_read>
    if (ret < 0)
  96:	00054a63          	bltz	a0,aa <read_physical_block_wrapper+0x46>
    {
        printf("  ERROR: raw_read failed for PBN %d (%s)!\n", pbn, context_msg);
        return -1;
    }
    return 0;
  9a:	4501                	li	a0,0
}
  9c:	70a2                	ld	ra,40(sp)
  9e:	7402                	ld	s0,32(sp)
  a0:	64e2                	ld	s1,24(sp)
  a2:	6942                	ld	s2,16(sp)
  a4:	69a2                	ld	s3,8(sp)
  a6:	6145                	addi	sp,sp,48
  a8:	8082                	ret
        printf("  ERROR: raw_read failed for PBN %d (%s)!\n", pbn, context_msg);
  aa:	864e                	mv	a2,s3
  ac:	85a6                	mv	a1,s1
  ae:	00001517          	auipc	a0,0x1
  b2:	b2250513          	addi	a0,a0,-1246 # bd0 <malloc+0x142>
  b6:	00001097          	auipc	ra,0x1
  ba:	91a080e7          	jalr	-1766(ra) # 9d0 <printf>
        return -1;
  be:	557d                	li	a0,-1
  c0:	bff1                	j	9c <read_physical_block_wrapper+0x38>

00000000000000c2 <main>:

int main()
{
  c2:	7119                	addi	sp,sp,-128
  c4:	fc86                	sd	ra,120(sp)
  c6:	f8a2                	sd	s0,112(sp)
  c8:	f4a6                	sd	s1,104(sp)
  ca:	f0ca                	sd	s2,96(sp)
  cc:	ecce                	sd	s3,88(sp)
  ce:	e8d2                	sd	s4,80(sp)
  d0:	e4d6                	sd	s5,72(sp)
  d2:	e0da                	sd	s6,64(sp)
  d4:	fc5e                	sd	s7,56(sp)
  d6:	f862                	sd	s8,48(sp)
  d8:	f466                	sd	s9,40(sp)
  da:	f06a                	sd	s10,32(sp)
  dc:	ec6e                	sd	s11,24(sp)
  de:	0100                	addi	s0,sp,128
    int fd_write;
    int lbn;
    int pass_mirroring = 1;
    int disk_lbns[NUM_TEST_BLOCKS];

    printf("=== RAID 1 Mirroring Verification Test (Criterion 1) ===\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	b3050513          	addi	a0,a0,-1232 # c10 <malloc+0x182>
  e8:	00001097          	auipc	ra,0x1
  ec:	8e8080e7          	jalr	-1816(ra) # 9d0 <printf>
    printf("Testing with %d sequential file logical blocks (LBN 0 to %d).\n",
  f0:	4609                	li	a2,2
  f2:	458d                	li	a1,3
  f4:	00001517          	auipc	a0,0x1
  f8:	b5c50513          	addi	a0,a0,-1188 # c50 <malloc+0x1c2>
  fc:	00001097          	auipc	ra,0x1
 100:	8d4080e7          	jalr	-1836(ra) # 9d0 <printf>
           NUM_TEST_BLOCKS, NUM_TEST_BLOCKS - 1);

    printf("--- Phase 1: Writing data sequentially and getting mapping ---\n");
 104:	00001517          	auipc	a0,0x1
 108:	b8c50513          	addi	a0,a0,-1140 # c90 <malloc+0x202>
 10c:	00001097          	auipc	ra,0x1
 110:	8c4080e7          	jalr	-1852(ra) # 9d0 <printf>
    fd_write = open("mirror_consistency.dat", O_CREATE | O_RDWR | O_TRUNC);
 114:	60200593          	li	a1,1538
 118:	00001517          	auipc	a0,0x1
 11c:	bb850513          	addi	a0,a0,-1096 # cd0 <malloc+0x242>
 120:	00000097          	auipc	ra,0x0
 124:	538080e7          	jalr	1336(ra) # 658 <open>
    if (fd_write < 0)
 128:	0e054463          	bltz	a0,210 <main+0x14e>
 12c:	89aa                	mv	s3,a0
 12e:	f8040a93          	addi	s5,s0,-128
 132:	8a56                	mv	s4,s5
 134:	04100493          	li	s1,65
        exit(1);
    for (lbn = 0; lbn < NUM_TEST_BLOCKS; lbn++)
    {
        char pattern = 'A' + lbn;
        fill_data(data_to_write, lbn, pattern);
 138:	00001b17          	auipc	s6,0x1
 13c:	e60b0b13          	addi	s6,s6,-416 # f98 <data_to_write>
        printf("  Writing File LBN %d pattern '%c'\n", lbn, pattern);
 140:	00001b97          	auipc	s7,0x1
 144:	ba8b8b93          	addi	s7,s7,-1112 # ce8 <malloc+0x25a>
        if (disk_lbns[lbn] <= 0)
        {
            close(fd_write);
            exit(1);
        }
        printf("    File LBN %d mapped to Disk LBN %d.\n", lbn, disk_lbns[lbn]);
 148:	00001c97          	auipc	s9,0x1
 14c:	bc8c8c93          	addi	s9,s9,-1080 # d10 <malloc+0x282>
    for (lbn = 0; lbn < NUM_TEST_BLOCKS; lbn++)
 150:	04400c13          	li	s8,68
 154:	fbf4891b          	addiw	s2,s1,-65
        fill_data(data_to_write, lbn, pattern);
 158:	0ff4f613          	andi	a2,s1,255
 15c:	85ca                	mv	a1,s2
 15e:	855a                	mv	a0,s6
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <fill_data>
        printf("  Writing File LBN %d pattern '%c'\n", lbn, pattern);
 168:	8626                	mv	a2,s1
 16a:	85ca                	mv	a1,s2
 16c:	855e                	mv	a0,s7
 16e:	00001097          	auipc	ra,0x1
 172:	862080e7          	jalr	-1950(ra) # 9d0 <printf>
        if (write(fd_write, data_to_write, BSIZE) != BSIZE)
 176:	40000613          	li	a2,1024
 17a:	85da                	mv	a1,s6
 17c:	854e                	mv	a0,s3
 17e:	00000097          	auipc	ra,0x0
 182:	4ba080e7          	jalr	1210(ra) # 638 <write>
 186:	40000793          	li	a5,1024
 18a:	08f51863          	bne	a0,a5,21a <main+0x158>
        disk_lbns[lbn] = get_disk_lbn(fd_write, lbn);
 18e:	85ca                	mv	a1,s2
 190:	854e                	mv	a0,s3
 192:	00000097          	auipc	ra,0x0
 196:	53e080e7          	jalr	1342(ra) # 6d0 <get_disk_lbn>
 19a:	862a                	mv	a2,a0
 19c:	00aa2023          	sw	a0,0(s4)
        if (disk_lbns[lbn] <= 0)
 1a0:	08a05763          	blez	a0,22e <main+0x16c>
        printf("    File LBN %d mapped to Disk LBN %d.\n", lbn, disk_lbns[lbn]);
 1a4:	85ca                	mv	a1,s2
 1a6:	8566                	mv	a0,s9
 1a8:	00001097          	auipc	ra,0x1
 1ac:	828080e7          	jalr	-2008(ra) # 9d0 <printf>
    for (lbn = 0; lbn < NUM_TEST_BLOCKS; lbn++)
 1b0:	2485                	addiw	s1,s1,1
 1b2:	0a11                	addi	s4,s4,4
 1b4:	fb8490e3          	bne	s1,s8,154 <main+0x92>
    }
    close(fd_write);
 1b8:	854e                	mv	a0,s3
 1ba:	00000097          	auipc	ra,0x0
 1be:	486080e7          	jalr	1158(ra) # 640 <close>
    printf("Phase 1: Completed.\n\n");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	b7650513          	addi	a0,a0,-1162 # d38 <malloc+0x2aa>
 1ca:	00001097          	auipc	ra,0x1
 1ce:	806080e7          	jalr	-2042(ra) # 9d0 <printf>

    printf("--- Phase 2: Verifying write mirroring (Criterion 1) ---\n");
 1d2:	00001517          	auipc	a0,0x1
 1d6:	b7e50513          	addi	a0,a0,-1154 # d50 <malloc+0x2c2>
 1da:	00000097          	auipc	ra,0x0
 1de:	7f6080e7          	jalr	2038(ra) # 9d0 <printf>
 1e2:	04100913          	li	s2,65
    int pass_mirroring = 1;
 1e6:	4b85                	li	s7,1
        int disk_lbn = disk_lbns[lbn];
        int pbn0 = disk_lbn;
        int pbn1 = disk_lbn + DISK1_START_BLOCK;
        int pass_current = 1;

        fill_data(expected_data, lbn, pattern);
 1e8:	00001c17          	auipc	s8,0x1
 1ec:	1b0c0c13          	addi	s8,s8,432 # 1398 <expected_data>
        printf("  Verifying LBN %d (Disk LBN %d, Pattern '%c'):\n", lbn,
 1f0:	00001d97          	auipc	s11,0x1
 1f4:	ba0d8d93          	addi	s11,s11,-1120 # d90 <malloc+0x302>
               disk_lbn, pattern);

        if (read_physical_block_wrapper(pbn0, pbn0_content, "Disk 0 copy") != 0)
 1f8:	00001d17          	auipc	s10,0x1
 1fc:	5a0d0d13          	addi	s10,s10,1440 # 1798 <pbn0_content>
        {
            pass_current = 0;
        }
        if (read_physical_block_wrapper(pbn1, pbn1_content, "Disk 1 copy") != 0)
 200:	00002c97          	auipc	s9,0x2
 204:	998c8c93          	addi	s9,s9,-1640 # 1b98 <pbn1_content>
        int pbn1 = disk_lbn + DISK1_START_BLOCK;
 208:	6b05                	lui	s6,0x1
 20a:	800b0b1b          	addiw	s6,s6,-2048
 20e:	a8f1                	j	2ea <main+0x228>
        exit(1);
 210:	4505                	li	a0,1
 212:	00000097          	auipc	ra,0x0
 216:	406080e7          	jalr	1030(ra) # 618 <exit>
            close(fd_write);
 21a:	854e                	mv	a0,s3
 21c:	00000097          	auipc	ra,0x0
 220:	424080e7          	jalr	1060(ra) # 640 <close>
            exit(1);
 224:	4505                	li	a0,1
 226:	00000097          	auipc	ra,0x0
 22a:	3f2080e7          	jalr	1010(ra) # 618 <exit>
            close(fd_write);
 22e:	854e                	mv	a0,s3
 230:	00000097          	auipc	ra,0x0
 234:	410080e7          	jalr	1040(ra) # 640 <close>
            exit(1);
 238:	4505                	li	a0,1
 23a:	00000097          	auipc	ra,0x0
 23e:	3de080e7          	jalr	990(ra) # 618 <exit>
        {
            printf("    LBN %d - Write Mirroring Check: FAILED\n", lbn);
            pass_mirroring = 0;
        }
    }
    printf("Phase 2: Completed.\n\n");
 242:	00001517          	auipc	a0,0x1
 246:	c4650513          	addi	a0,a0,-954 # e88 <malloc+0x3fa>
 24a:	00000097          	auipc	ra,0x0
 24e:	786080e7          	jalr	1926(ra) # 9d0 <printf>

    printf("\n=== Final Mirroring Test Summary ===\n");
 252:	00001517          	auipc	a0,0x1
 256:	c4e50513          	addi	a0,a0,-946 # ea0 <malloc+0x412>
 25a:	00000097          	auipc	ra,0x0
 25e:	776080e7          	jalr	1910(ra) # 9d0 <printf>
    printf("Bwrite Mirroring Test: %s\n", pass_mirroring ? "PASS" : "FAIL");
 262:	00001597          	auipc	a1,0x1
 266:	99e58593          	addi	a1,a1,-1634 # c00 <malloc+0x172>
 26a:	000b9663          	bnez	s7,276 <main+0x1b4>
 26e:	00001597          	auipc	a1,0x1
 272:	99a58593          	addi	a1,a1,-1638 # c08 <malloc+0x17a>
 276:	00001517          	auipc	a0,0x1
 27a:	c5250513          	addi	a0,a0,-942 # ec8 <malloc+0x43a>
 27e:	00000097          	auipc	ra,0x0
 282:	752080e7          	jalr	1874(ra) # 9d0 <printf>
    printf("(Consistency (Criterion 2) is implicitly checked if Mirroring and "
 286:	00001517          	auipc	a0,0x1
 28a:	c6250513          	addi	a0,a0,-926 # ee8 <malloc+0x45a>
 28e:	00000097          	auipc	ra,0x0
 292:	742080e7          	jalr	1858(ra) # 9d0 <printf>
           "Fallback tests pass)\n");
    printf("(Run mp4_2_fallback_test for Criterion 3)\n");
 296:	00001517          	auipc	a0,0x1
 29a:	caa50513          	addi	a0,a0,-854 # f40 <malloc+0x4b2>
 29e:	00000097          	auipc	ra,0x0
 2a2:	732080e7          	jalr	1842(ra) # 9d0 <printf>

    exit(pass_mirroring ? 0 : 1);
 2a6:	001bc513          	xori	a0,s7,1
 2aa:	00000097          	auipc	ra,0x0
 2ae:	36e080e7          	jalr	878(ra) # 618 <exit>
            if (compare_buffers(pbn0_content, pbn1_content, BSIZE,
 2b2:	00001697          	auipc	a3,0x1
 2b6:	b6668693          	addi	a3,a3,-1178 # e18 <malloc+0x38a>
 2ba:	40000613          	li	a2,1024
 2be:	85e6                	mv	a1,s9
 2c0:	856a                	mv	a0,s10
 2c2:	00000097          	auipc	ra,0x0
 2c6:	d6c080e7          	jalr	-660(ra) # 2e <compare_buffers>
            printf("    LBN %d - Write Mirroring Check: FAILED\n", lbn);
 2ca:	85d2                	mv	a1,s4
 2cc:	00001517          	auipc	a0,0x1
 2d0:	b8c50513          	addi	a0,a0,-1140 # e58 <malloc+0x3ca>
 2d4:	00000097          	auipc	ra,0x0
 2d8:	6fc080e7          	jalr	1788(ra) # 9d0 <printf>
            pass_mirroring = 0;
 2dc:	4b81                	li	s7,0
    for (lbn = 0; lbn < NUM_TEST_BLOCKS; lbn++)
 2de:	0a91                	addi	s5,s5,4
 2e0:	2905                	addiw	s2,s2,1
 2e2:	04400793          	li	a5,68
 2e6:	f4f90ee3          	beq	s2,a5,242 <main+0x180>
 2ea:	fbf90a1b          	addiw	s4,s2,-65
        int disk_lbn = disk_lbns[lbn];
 2ee:	000aa983          	lw	s3,0(s5)
        fill_data(expected_data, lbn, pattern);
 2f2:	0ff97613          	andi	a2,s2,255
 2f6:	85d2                	mv	a1,s4
 2f8:	8562                	mv	a0,s8
 2fa:	00000097          	auipc	ra,0x0
 2fe:	d06080e7          	jalr	-762(ra) # 0 <fill_data>
        printf("  Verifying LBN %d (Disk LBN %d, Pattern '%c'):\n", lbn,
 302:	86ca                	mv	a3,s2
 304:	864e                	mv	a2,s3
 306:	85d2                	mv	a1,s4
 308:	856e                	mv	a0,s11
 30a:	00000097          	auipc	ra,0x0
 30e:	6c6080e7          	jalr	1734(ra) # 9d0 <printf>
        if (read_physical_block_wrapper(pbn0, pbn0_content, "Disk 0 copy") != 0)
 312:	00001617          	auipc	a2,0x1
 316:	ab660613          	addi	a2,a2,-1354 # dc8 <malloc+0x33a>
 31a:	85ea                	mv	a1,s10
 31c:	854e                	mv	a0,s3
 31e:	00000097          	auipc	ra,0x0
 322:	d46080e7          	jalr	-698(ra) # 64 <read_physical_block_wrapper>
 326:	84aa                	mv	s1,a0
        if (read_physical_block_wrapper(pbn1, pbn1_content, "Disk 1 copy") != 0)
 328:	00001617          	auipc	a2,0x1
 32c:	ab060613          	addi	a2,a2,-1360 # dd8 <malloc+0x34a>
 330:	85e6                	mv	a1,s9
 332:	013b053b          	addw	a0,s6,s3
 336:	00000097          	auipc	ra,0x0
 33a:	d2e080e7          	jalr	-722(ra) # 64 <read_physical_block_wrapper>
 33e:	8cc9                	or	s1,s1,a0
 340:	2481                	sext.w	s1,s1
 342:	f4c1                	bnez	s1,2ca <main+0x208>
            if (compare_buffers(expected_data, pbn0_content, BSIZE,
 344:	00001697          	auipc	a3,0x1
 348:	aa468693          	addi	a3,a3,-1372 # de8 <malloc+0x35a>
 34c:	40000613          	li	a2,1024
 350:	85ea                	mv	a1,s10
 352:	8562                	mv	a0,s8
 354:	00000097          	auipc	ra,0x0
 358:	cda080e7          	jalr	-806(ra) # 2e <compare_buffers>
 35c:	84aa                	mv	s1,a0
            if (compare_buffers(expected_data, pbn1_content, BSIZE,
 35e:	00001697          	auipc	a3,0x1
 362:	aa268693          	addi	a3,a3,-1374 # e00 <malloc+0x372>
 366:	40000613          	li	a2,1024
 36a:	85e6                	mv	a1,s9
 36c:	8562                	mv	a0,s8
 36e:	00000097          	auipc	ra,0x0
 372:	cc0080e7          	jalr	-832(ra) # 2e <compare_buffers>
 376:	8cc9                	or	s1,s1,a0
 378:	2481                	sext.w	s1,s1
 37a:	fc85                	bnez	s1,2b2 <main+0x1f0>
            if (compare_buffers(pbn0_content, pbn1_content, BSIZE,
 37c:	00001697          	auipc	a3,0x1
 380:	a9c68693          	addi	a3,a3,-1380 # e18 <malloc+0x38a>
 384:	40000613          	li	a2,1024
 388:	85e6                	mv	a1,s9
 38a:	856a                	mv	a0,s10
 38c:	00000097          	auipc	ra,0x0
 390:	ca2080e7          	jalr	-862(ra) # 2e <compare_buffers>
 394:	f91d                	bnez	a0,2ca <main+0x208>
            printf("    LBN %d - Write Mirroring Check: PASSED\n", lbn);
 396:	85d2                	mv	a1,s4
 398:	00001517          	auipc	a0,0x1
 39c:	a9050513          	addi	a0,a0,-1392 # e28 <malloc+0x39a>
 3a0:	00000097          	auipc	ra,0x0
 3a4:	630080e7          	jalr	1584(ra) # 9d0 <printf>
 3a8:	bf1d                	j	2de <main+0x21c>

00000000000003aa <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e422                	sd	s0,8(sp)
 3ae:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 3b0:	87aa                	mv	a5,a0
 3b2:	0585                	addi	a1,a1,1
 3b4:	0785                	addi	a5,a5,1
 3b6:	fff5c703          	lbu	a4,-1(a1)
 3ba:	fee78fa3          	sb	a4,-1(a5)
 3be:	fb75                	bnez	a4,3b2 <strcpy+0x8>
        ;
    return os;
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <strcmp>:

int strcmp(const char *p, const char *q)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 3cc:	00054783          	lbu	a5,0(a0)
 3d0:	cb91                	beqz	a5,3e4 <strcmp+0x1e>
 3d2:	0005c703          	lbu	a4,0(a1)
 3d6:	00f71763          	bne	a4,a5,3e4 <strcmp+0x1e>
        p++, q++;
 3da:	0505                	addi	a0,a0,1
 3dc:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 3de:	00054783          	lbu	a5,0(a0)
 3e2:	fbe5                	bnez	a5,3d2 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 3e4:	0005c503          	lbu	a0,0(a1)
}
 3e8:	40a7853b          	subw	a0,a5,a0
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <strlen>:

uint strlen(const char *s)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 3f8:	00054783          	lbu	a5,0(a0)
 3fc:	cf91                	beqz	a5,418 <strlen+0x26>
 3fe:	0505                	addi	a0,a0,1
 400:	87aa                	mv	a5,a0
 402:	4685                	li	a3,1
 404:	9e89                	subw	a3,a3,a0
 406:	00f6853b          	addw	a0,a3,a5
 40a:	0785                	addi	a5,a5,1
 40c:	fff7c703          	lbu	a4,-1(a5)
 410:	fb7d                	bnez	a4,406 <strlen+0x14>
        ;
    return n;
}
 412:	6422                	ld	s0,8(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret
    for (n = 0; s[n]; n++)
 418:	4501                	li	a0,0
 41a:	bfe5                	j	412 <strlen+0x20>

000000000000041c <memset>:

void *memset(void *dst, int c, uint n)
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 422:	ca19                	beqz	a2,438 <memset+0x1c>
 424:	87aa                	mv	a5,a0
 426:	1602                	slli	a2,a2,0x20
 428:	9201                	srli	a2,a2,0x20
 42a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 42e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 432:	0785                	addi	a5,a5,1
 434:	fee79de3          	bne	a5,a4,42e <memset+0x12>
    }
    return dst;
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret

000000000000043e <strchr>:

char *strchr(const char *s, char c)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e422                	sd	s0,8(sp)
 442:	0800                	addi	s0,sp,16
    for (; *s; s++)
 444:	00054783          	lbu	a5,0(a0)
 448:	cb99                	beqz	a5,45e <strchr+0x20>
        if (*s == c)
 44a:	00f58763          	beq	a1,a5,458 <strchr+0x1a>
    for (; *s; s++)
 44e:	0505                	addi	a0,a0,1
 450:	00054783          	lbu	a5,0(a0)
 454:	fbfd                	bnez	a5,44a <strchr+0xc>
            return (char *)s;
    return 0;
 456:	4501                	li	a0,0
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
    return 0;
 45e:	4501                	li	a0,0
 460:	bfe5                	j	458 <strchr+0x1a>

0000000000000462 <gets>:

char *gets(char *buf, int max)
{
 462:	711d                	addi	sp,sp,-96
 464:	ec86                	sd	ra,88(sp)
 466:	e8a2                	sd	s0,80(sp)
 468:	e4a6                	sd	s1,72(sp)
 46a:	e0ca                	sd	s2,64(sp)
 46c:	fc4e                	sd	s3,56(sp)
 46e:	f852                	sd	s4,48(sp)
 470:	f456                	sd	s5,40(sp)
 472:	f05a                	sd	s6,32(sp)
 474:	ec5e                	sd	s7,24(sp)
 476:	1080                	addi	s0,sp,96
 478:	8baa                	mv	s7,a0
 47a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 47c:	892a                	mv	s2,a0
 47e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 480:	4aa9                	li	s5,10
 482:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 484:	89a6                	mv	s3,s1
 486:	2485                	addiw	s1,s1,1
 488:	0344d863          	bge	s1,s4,4b8 <gets+0x56>
        cc = read(0, &c, 1);
 48c:	4605                	li	a2,1
 48e:	faf40593          	addi	a1,s0,-81
 492:	4501                	li	a0,0
 494:	00000097          	auipc	ra,0x0
 498:	19c080e7          	jalr	412(ra) # 630 <read>
        if (cc < 1)
 49c:	00a05e63          	blez	a0,4b8 <gets+0x56>
        buf[i++] = c;
 4a0:	faf44783          	lbu	a5,-81(s0)
 4a4:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 4a8:	01578763          	beq	a5,s5,4b6 <gets+0x54>
 4ac:	0905                	addi	s2,s2,1
 4ae:	fd679be3          	bne	a5,s6,484 <gets+0x22>
    for (i = 0; i + 1 < max;)
 4b2:	89a6                	mv	s3,s1
 4b4:	a011                	j	4b8 <gets+0x56>
 4b6:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 4b8:	99de                	add	s3,s3,s7
 4ba:	00098023          	sb	zero,0(s3)
    return buf;
}
 4be:	855e                	mv	a0,s7
 4c0:	60e6                	ld	ra,88(sp)
 4c2:	6446                	ld	s0,80(sp)
 4c4:	64a6                	ld	s1,72(sp)
 4c6:	6906                	ld	s2,64(sp)
 4c8:	79e2                	ld	s3,56(sp)
 4ca:	7a42                	ld	s4,48(sp)
 4cc:	7aa2                	ld	s5,40(sp)
 4ce:	7b02                	ld	s6,32(sp)
 4d0:	6be2                	ld	s7,24(sp)
 4d2:	6125                	addi	sp,sp,96
 4d4:	8082                	ret

00000000000004d6 <stat>:

int stat(const char *n, struct stat *st)
{
 4d6:	1101                	addi	sp,sp,-32
 4d8:	ec06                	sd	ra,24(sp)
 4da:	e822                	sd	s0,16(sp)
 4dc:	e426                	sd	s1,8(sp)
 4de:	e04a                	sd	s2,0(sp)
 4e0:	1000                	addi	s0,sp,32
 4e2:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 4e4:	4581                	li	a1,0
 4e6:	00000097          	auipc	ra,0x0
 4ea:	172080e7          	jalr	370(ra) # 658 <open>
    if (fd < 0)
 4ee:	02054563          	bltz	a0,518 <stat+0x42>
 4f2:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 4f4:	85ca                	mv	a1,s2
 4f6:	00000097          	auipc	ra,0x0
 4fa:	17a080e7          	jalr	378(ra) # 670 <fstat>
 4fe:	892a                	mv	s2,a0
    close(fd);
 500:	8526                	mv	a0,s1
 502:	00000097          	auipc	ra,0x0
 506:	13e080e7          	jalr	318(ra) # 640 <close>
    return r;
}
 50a:	854a                	mv	a0,s2
 50c:	60e2                	ld	ra,24(sp)
 50e:	6442                	ld	s0,16(sp)
 510:	64a2                	ld	s1,8(sp)
 512:	6902                	ld	s2,0(sp)
 514:	6105                	addi	sp,sp,32
 516:	8082                	ret
        return -1;
 518:	597d                	li	s2,-1
 51a:	bfc5                	j	50a <stat+0x34>

000000000000051c <atoi>:

int atoi(const char *s)
{
 51c:	1141                	addi	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 522:	00054603          	lbu	a2,0(a0)
 526:	fd06079b          	addiw	a5,a2,-48
 52a:	0ff7f793          	andi	a5,a5,255
 52e:	4725                	li	a4,9
 530:	02f76963          	bltu	a4,a5,562 <atoi+0x46>
 534:	86aa                	mv	a3,a0
    n = 0;
 536:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 538:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 53a:	0685                	addi	a3,a3,1
 53c:	0025179b          	slliw	a5,a0,0x2
 540:	9fa9                	addw	a5,a5,a0
 542:	0017979b          	slliw	a5,a5,0x1
 546:	9fb1                	addw	a5,a5,a2
 548:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 54c:	0006c603          	lbu	a2,0(a3)
 550:	fd06071b          	addiw	a4,a2,-48
 554:	0ff77713          	andi	a4,a4,255
 558:	fee5f1e3          	bgeu	a1,a4,53a <atoi+0x1e>
    return n;
}
 55c:	6422                	ld	s0,8(sp)
 55e:	0141                	addi	sp,sp,16
 560:	8082                	ret
    n = 0;
 562:	4501                	li	a0,0
 564:	bfe5                	j	55c <atoi+0x40>

0000000000000566 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 566:	1141                	addi	sp,sp,-16
 568:	e422                	sd	s0,8(sp)
 56a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 56c:	02b57463          	bgeu	a0,a1,594 <memmove+0x2e>
    {
        while (n-- > 0)
 570:	00c05f63          	blez	a2,58e <memmove+0x28>
 574:	1602                	slli	a2,a2,0x20
 576:	9201                	srli	a2,a2,0x20
 578:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 57c:	872a                	mv	a4,a0
            *dst++ = *src++;
 57e:	0585                	addi	a1,a1,1
 580:	0705                	addi	a4,a4,1
 582:	fff5c683          	lbu	a3,-1(a1)
 586:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 58a:	fee79ae3          	bne	a5,a4,57e <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 58e:	6422                	ld	s0,8(sp)
 590:	0141                	addi	sp,sp,16
 592:	8082                	ret
        dst += n;
 594:	00c50733          	add	a4,a0,a2
        src += n;
 598:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 59a:	fec05ae3          	blez	a2,58e <memmove+0x28>
 59e:	fff6079b          	addiw	a5,a2,-1
 5a2:	1782                	slli	a5,a5,0x20
 5a4:	9381                	srli	a5,a5,0x20
 5a6:	fff7c793          	not	a5,a5
 5aa:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 5ac:	15fd                	addi	a1,a1,-1
 5ae:	177d                	addi	a4,a4,-1
 5b0:	0005c683          	lbu	a3,0(a1)
 5b4:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 5b8:	fee79ae3          	bne	a5,a4,5ac <memmove+0x46>
 5bc:	bfc9                	j	58e <memmove+0x28>

00000000000005be <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 5be:	1141                	addi	sp,sp,-16
 5c0:	e422                	sd	s0,8(sp)
 5c2:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 5c4:	ca05                	beqz	a2,5f4 <memcmp+0x36>
 5c6:	fff6069b          	addiw	a3,a2,-1
 5ca:	1682                	slli	a3,a3,0x20
 5cc:	9281                	srli	a3,a3,0x20
 5ce:	0685                	addi	a3,a3,1
 5d0:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 5d2:	00054783          	lbu	a5,0(a0)
 5d6:	0005c703          	lbu	a4,0(a1)
 5da:	00e79863          	bne	a5,a4,5ea <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 5de:	0505                	addi	a0,a0,1
        p2++;
 5e0:	0585                	addi	a1,a1,1
    while (n-- > 0)
 5e2:	fed518e3          	bne	a0,a3,5d2 <memcmp+0x14>
    }
    return 0;
 5e6:	4501                	li	a0,0
 5e8:	a019                	j	5ee <memcmp+0x30>
            return *p1 - *p2;
 5ea:	40e7853b          	subw	a0,a5,a4
}
 5ee:	6422                	ld	s0,8(sp)
 5f0:	0141                	addi	sp,sp,16
 5f2:	8082                	ret
    return 0;
 5f4:	4501                	li	a0,0
 5f6:	bfe5                	j	5ee <memcmp+0x30>

00000000000005f8 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 5f8:	1141                	addi	sp,sp,-16
 5fa:	e406                	sd	ra,8(sp)
 5fc:	e022                	sd	s0,0(sp)
 5fe:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 600:	00000097          	auipc	ra,0x0
 604:	f66080e7          	jalr	-154(ra) # 566 <memmove>
}
 608:	60a2                	ld	ra,8(sp)
 60a:	6402                	ld	s0,0(sp)
 60c:	0141                	addi	sp,sp,16
 60e:	8082                	ret

0000000000000610 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 610:	4885                	li	a7,1
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <exit>:
.global exit
exit:
 li a7, SYS_exit
 618:	4889                	li	a7,2
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <wait>:
.global wait
wait:
 li a7, SYS_wait
 620:	488d                	li	a7,3
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 628:	4891                	li	a7,4
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <read>:
.global read
read:
 li a7, SYS_read
 630:	4895                	li	a7,5
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <write>:
.global write
write:
 li a7, SYS_write
 638:	48c1                	li	a7,16
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <close>:
.global close
close:
 li a7, SYS_close
 640:	48d5                	li	a7,21
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <kill>:
.global kill
kill:
 li a7, SYS_kill
 648:	4899                	li	a7,6
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <exec>:
.global exec
exec:
 li a7, SYS_exec
 650:	489d                	li	a7,7
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <open>:
.global open
open:
 li a7, SYS_open
 658:	48bd                	li	a7,15
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 660:	48c5                	li	a7,17
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 668:	48c9                	li	a7,18
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 670:	48a1                	li	a7,8
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <link>:
.global link
link:
 li a7, SYS_link
 678:	48cd                	li	a7,19
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 680:	48d1                	li	a7,20
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 688:	48a5                	li	a7,9
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <dup>:
.global dup
dup:
 li a7, SYS_dup
 690:	48a9                	li	a7,10
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 698:	48ad                	li	a7,11
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6a0:	48b1                	li	a7,12
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6a8:	48b5                	li	a7,13
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6b0:	48b9                	li	a7,14
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 6b8:	48d9                	li	a7,22
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 6c0:	48dd                	li	a7,23
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 6c8:	48e1                	li	a7,24
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 6d0:	48e5                	li	a7,25
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 6d8:	48e9                	li	a7,26
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 6e0:	48ed                	li	a7,27
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 6e8:	48f5                	li	a7,29
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 6f0:	48f1                	li	a7,28
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 6f8:	1101                	addi	sp,sp,-32
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	feb407a3          	sb	a1,-17(s0)
 704:	4605                	li	a2,1
 706:	fef40593          	addi	a1,s0,-17
 70a:	00000097          	auipc	ra,0x0
 70e:	f2e080e7          	jalr	-210(ra) # 638 <write>
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6105                	addi	sp,sp,32
 718:	8082                	ret

000000000000071a <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 71a:	7139                	addi	sp,sp,-64
 71c:	fc06                	sd	ra,56(sp)
 71e:	f822                	sd	s0,48(sp)
 720:	f426                	sd	s1,40(sp)
 722:	f04a                	sd	s2,32(sp)
 724:	ec4e                	sd	s3,24(sp)
 726:	0080                	addi	s0,sp,64
 728:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 72a:	c299                	beqz	a3,730 <printint+0x16>
 72c:	0805c863          	bltz	a1,7bc <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 730:	2581                	sext.w	a1,a1
    neg = 0;
 732:	4881                	li	a7,0
 734:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 738:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 73a:	2601                	sext.w	a2,a2
 73c:	00001517          	auipc	a0,0x1
 740:	83c50513          	addi	a0,a0,-1988 # f78 <digits>
 744:	883a                	mv	a6,a4
 746:	2705                	addiw	a4,a4,1
 748:	02c5f7bb          	remuw	a5,a1,a2
 74c:	1782                	slli	a5,a5,0x20
 74e:	9381                	srli	a5,a5,0x20
 750:	97aa                	add	a5,a5,a0
 752:	0007c783          	lbu	a5,0(a5)
 756:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 75a:	0005879b          	sext.w	a5,a1
 75e:	02c5d5bb          	divuw	a1,a1,a2
 762:	0685                	addi	a3,a3,1
 764:	fec7f0e3          	bgeu	a5,a2,744 <printint+0x2a>
    if (neg)
 768:	00088b63          	beqz	a7,77e <printint+0x64>
        buf[i++] = '-';
 76c:	fd040793          	addi	a5,s0,-48
 770:	973e                	add	a4,a4,a5
 772:	02d00793          	li	a5,45
 776:	fef70823          	sb	a5,-16(a4)
 77a:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 77e:	02e05863          	blez	a4,7ae <printint+0x94>
 782:	fc040793          	addi	a5,s0,-64
 786:	00e78933          	add	s2,a5,a4
 78a:	fff78993          	addi	s3,a5,-1
 78e:	99ba                	add	s3,s3,a4
 790:	377d                	addiw	a4,a4,-1
 792:	1702                	slli	a4,a4,0x20
 794:	9301                	srli	a4,a4,0x20
 796:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 79a:	fff94583          	lbu	a1,-1(s2)
 79e:	8526                	mv	a0,s1
 7a0:	00000097          	auipc	ra,0x0
 7a4:	f58080e7          	jalr	-168(ra) # 6f8 <putc>
    while (--i >= 0)
 7a8:	197d                	addi	s2,s2,-1
 7aa:	ff3918e3          	bne	s2,s3,79a <printint+0x80>
}
 7ae:	70e2                	ld	ra,56(sp)
 7b0:	7442                	ld	s0,48(sp)
 7b2:	74a2                	ld	s1,40(sp)
 7b4:	7902                	ld	s2,32(sp)
 7b6:	69e2                	ld	s3,24(sp)
 7b8:	6121                	addi	sp,sp,64
 7ba:	8082                	ret
        x = -xx;
 7bc:	40b005bb          	negw	a1,a1
        neg = 1;
 7c0:	4885                	li	a7,1
        x = -xx;
 7c2:	bf8d                	j	734 <printint+0x1a>

00000000000007c4 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 7c4:	7119                	addi	sp,sp,-128
 7c6:	fc86                	sd	ra,120(sp)
 7c8:	f8a2                	sd	s0,112(sp)
 7ca:	f4a6                	sd	s1,104(sp)
 7cc:	f0ca                	sd	s2,96(sp)
 7ce:	ecce                	sd	s3,88(sp)
 7d0:	e8d2                	sd	s4,80(sp)
 7d2:	e4d6                	sd	s5,72(sp)
 7d4:	e0da                	sd	s6,64(sp)
 7d6:	fc5e                	sd	s7,56(sp)
 7d8:	f862                	sd	s8,48(sp)
 7da:	f466                	sd	s9,40(sp)
 7dc:	f06a                	sd	s10,32(sp)
 7de:	ec6e                	sd	s11,24(sp)
 7e0:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 7e2:	0005c903          	lbu	s2,0(a1)
 7e6:	18090f63          	beqz	s2,984 <vprintf+0x1c0>
 7ea:	8aaa                	mv	s5,a0
 7ec:	8b32                	mv	s6,a2
 7ee:	00158493          	addi	s1,a1,1
    state = 0;
 7f2:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 7f4:	02500a13          	li	s4,37
        {
            if (c == 'd')
 7f8:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 7fc:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 800:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 804:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 808:	00000b97          	auipc	s7,0x0
 80c:	770b8b93          	addi	s7,s7,1904 # f78 <digits>
 810:	a839                	j	82e <vprintf+0x6a>
                putc(fd, c);
 812:	85ca                	mv	a1,s2
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	ee2080e7          	jalr	-286(ra) # 6f8 <putc>
 81e:	a019                	j	824 <vprintf+0x60>
        else if (state == '%')
 820:	01498f63          	beq	s3,s4,83e <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 824:	0485                	addi	s1,s1,1
 826:	fff4c903          	lbu	s2,-1(s1)
 82a:	14090d63          	beqz	s2,984 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 82e:	0009079b          	sext.w	a5,s2
        if (state == 0)
 832:	fe0997e3          	bnez	s3,820 <vprintf+0x5c>
            if (c == '%')
 836:	fd479ee3          	bne	a5,s4,812 <vprintf+0x4e>
                state = '%';
 83a:	89be                	mv	s3,a5
 83c:	b7e5                	j	824 <vprintf+0x60>
            if (c == 'd')
 83e:	05878063          	beq	a5,s8,87e <vprintf+0xba>
            else if (c == 'l')
 842:	05978c63          	beq	a5,s9,89a <vprintf+0xd6>
            else if (c == 'x')
 846:	07a78863          	beq	a5,s10,8b6 <vprintf+0xf2>
            else if (c == 'p')
 84a:	09b78463          	beq	a5,s11,8d2 <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 84e:	07300713          	li	a4,115
 852:	0ce78663          	beq	a5,a4,91e <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 856:	06300713          	li	a4,99
 85a:	0ee78e63          	beq	a5,a4,956 <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 85e:	11478863          	beq	a5,s4,96e <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 862:	85d2                	mv	a1,s4
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	e92080e7          	jalr	-366(ra) # 6f8 <putc>
                putc(fd, c);
 86e:	85ca                	mv	a1,s2
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	e86080e7          	jalr	-378(ra) # 6f8 <putc>
            }
            state = 0;
 87a:	4981                	li	s3,0
 87c:	b765                	j	824 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 87e:	008b0913          	addi	s2,s6,8 # 1008 <data_to_write+0x70>
 882:	4685                	li	a3,1
 884:	4629                	li	a2,10
 886:	000b2583          	lw	a1,0(s6)
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	e8e080e7          	jalr	-370(ra) # 71a <printint>
 894:	8b4a                	mv	s6,s2
            state = 0;
 896:	4981                	li	s3,0
 898:	b771                	j	824 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 89a:	008b0913          	addi	s2,s6,8
 89e:	4681                	li	a3,0
 8a0:	4629                	li	a2,10
 8a2:	000b2583          	lw	a1,0(s6)
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	e72080e7          	jalr	-398(ra) # 71a <printint>
 8b0:	8b4a                	mv	s6,s2
            state = 0;
 8b2:	4981                	li	s3,0
 8b4:	bf85                	j	824 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 8b6:	008b0913          	addi	s2,s6,8
 8ba:	4681                	li	a3,0
 8bc:	4641                	li	a2,16
 8be:	000b2583          	lw	a1,0(s6)
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	e56080e7          	jalr	-426(ra) # 71a <printint>
 8cc:	8b4a                	mv	s6,s2
            state = 0;
 8ce:	4981                	li	s3,0
 8d0:	bf91                	j	824 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 8d2:	008b0793          	addi	a5,s6,8
 8d6:	f8f43423          	sd	a5,-120(s0)
 8da:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 8de:	03000593          	li	a1,48
 8e2:	8556                	mv	a0,s5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	e14080e7          	jalr	-492(ra) # 6f8 <putc>
    putc(fd, 'x');
 8ec:	85ea                	mv	a1,s10
 8ee:	8556                	mv	a0,s5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	e08080e7          	jalr	-504(ra) # 6f8 <putc>
 8f8:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fa:	03c9d793          	srli	a5,s3,0x3c
 8fe:	97de                	add	a5,a5,s7
 900:	0007c583          	lbu	a1,0(a5)
 904:	8556                	mv	a0,s5
 906:	00000097          	auipc	ra,0x0
 90a:	df2080e7          	jalr	-526(ra) # 6f8 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 90e:	0992                	slli	s3,s3,0x4
 910:	397d                	addiw	s2,s2,-1
 912:	fe0914e3          	bnez	s2,8fa <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 916:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 91a:	4981                	li	s3,0
 91c:	b721                	j	824 <vprintf+0x60>
                s = va_arg(ap, char *);
 91e:	008b0993          	addi	s3,s6,8
 922:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 926:	02090163          	beqz	s2,948 <vprintf+0x184>
                while (*s != 0)
 92a:	00094583          	lbu	a1,0(s2)
 92e:	c9a1                	beqz	a1,97e <vprintf+0x1ba>
                    putc(fd, *s);
 930:	8556                	mv	a0,s5
 932:	00000097          	auipc	ra,0x0
 936:	dc6080e7          	jalr	-570(ra) # 6f8 <putc>
                    s++;
 93a:	0905                	addi	s2,s2,1
                while (*s != 0)
 93c:	00094583          	lbu	a1,0(s2)
 940:	f9e5                	bnez	a1,930 <vprintf+0x16c>
                s = va_arg(ap, char *);
 942:	8b4e                	mv	s6,s3
            state = 0;
 944:	4981                	li	s3,0
 946:	bdf9                	j	824 <vprintf+0x60>
                    s = "(null)";
 948:	00000917          	auipc	s2,0x0
 94c:	62890913          	addi	s2,s2,1576 # f70 <malloc+0x4e2>
                while (*s != 0)
 950:	02800593          	li	a1,40
 954:	bff1                	j	930 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 956:	008b0913          	addi	s2,s6,8
 95a:	000b4583          	lbu	a1,0(s6)
 95e:	8556                	mv	a0,s5
 960:	00000097          	auipc	ra,0x0
 964:	d98080e7          	jalr	-616(ra) # 6f8 <putc>
 968:	8b4a                	mv	s6,s2
            state = 0;
 96a:	4981                	li	s3,0
 96c:	bd65                	j	824 <vprintf+0x60>
                putc(fd, c);
 96e:	85d2                	mv	a1,s4
 970:	8556                	mv	a0,s5
 972:	00000097          	auipc	ra,0x0
 976:	d86080e7          	jalr	-634(ra) # 6f8 <putc>
            state = 0;
 97a:	4981                	li	s3,0
 97c:	b565                	j	824 <vprintf+0x60>
                s = va_arg(ap, char *);
 97e:	8b4e                	mv	s6,s3
            state = 0;
 980:	4981                	li	s3,0
 982:	b54d                	j	824 <vprintf+0x60>
        }
    }
}
 984:	70e6                	ld	ra,120(sp)
 986:	7446                	ld	s0,112(sp)
 988:	74a6                	ld	s1,104(sp)
 98a:	7906                	ld	s2,96(sp)
 98c:	69e6                	ld	s3,88(sp)
 98e:	6a46                	ld	s4,80(sp)
 990:	6aa6                	ld	s5,72(sp)
 992:	6b06                	ld	s6,64(sp)
 994:	7be2                	ld	s7,56(sp)
 996:	7c42                	ld	s8,48(sp)
 998:	7ca2                	ld	s9,40(sp)
 99a:	7d02                	ld	s10,32(sp)
 99c:	6de2                	ld	s11,24(sp)
 99e:	6109                	addi	sp,sp,128
 9a0:	8082                	ret

00000000000009a2 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 9a2:	715d                	addi	sp,sp,-80
 9a4:	ec06                	sd	ra,24(sp)
 9a6:	e822                	sd	s0,16(sp)
 9a8:	1000                	addi	s0,sp,32
 9aa:	e010                	sd	a2,0(s0)
 9ac:	e414                	sd	a3,8(s0)
 9ae:	e818                	sd	a4,16(s0)
 9b0:	ec1c                	sd	a5,24(s0)
 9b2:	03043023          	sd	a6,32(s0)
 9b6:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 9ba:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 9be:	8622                	mv	a2,s0
 9c0:	00000097          	auipc	ra,0x0
 9c4:	e04080e7          	jalr	-508(ra) # 7c4 <vprintf>
}
 9c8:	60e2                	ld	ra,24(sp)
 9ca:	6442                	ld	s0,16(sp)
 9cc:	6161                	addi	sp,sp,80
 9ce:	8082                	ret

00000000000009d0 <printf>:

void printf(const char *fmt, ...)
{
 9d0:	711d                	addi	sp,sp,-96
 9d2:	ec06                	sd	ra,24(sp)
 9d4:	e822                	sd	s0,16(sp)
 9d6:	1000                	addi	s0,sp,32
 9d8:	e40c                	sd	a1,8(s0)
 9da:	e810                	sd	a2,16(s0)
 9dc:	ec14                	sd	a3,24(s0)
 9de:	f018                	sd	a4,32(s0)
 9e0:	f41c                	sd	a5,40(s0)
 9e2:	03043823          	sd	a6,48(s0)
 9e6:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 9ea:	00840613          	addi	a2,s0,8
 9ee:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 9f2:	85aa                	mv	a1,a0
 9f4:	4505                	li	a0,1
 9f6:	00000097          	auipc	ra,0x0
 9fa:	dce080e7          	jalr	-562(ra) # 7c4 <vprintf>
}
 9fe:	60e2                	ld	ra,24(sp)
 a00:	6442                	ld	s0,16(sp)
 a02:	6125                	addi	sp,sp,96
 a04:	8082                	ret

0000000000000a06 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 a06:	1141                	addi	sp,sp,-16
 a08:	e422                	sd	s0,8(sp)
 a0a:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 a0c:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a10:	00000797          	auipc	a5,0x0
 a14:	5807b783          	ld	a5,1408(a5) # f90 <freep>
 a18:	a805                	j	a48 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 a1a:	4618                	lw	a4,8(a2)
 a1c:	9db9                	addw	a1,a1,a4
 a1e:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 a22:	6398                	ld	a4,0(a5)
 a24:	6318                	ld	a4,0(a4)
 a26:	fee53823          	sd	a4,-16(a0)
 a2a:	a091                	j	a6e <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 a2c:	ff852703          	lw	a4,-8(a0)
 a30:	9e39                	addw	a2,a2,a4
 a32:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 a34:	ff053703          	ld	a4,-16(a0)
 a38:	e398                	sd	a4,0(a5)
 a3a:	a099                	j	a80 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3c:	6398                	ld	a4,0(a5)
 a3e:	00e7e463          	bltu	a5,a4,a46 <free+0x40>
 a42:	00e6ea63          	bltu	a3,a4,a56 <free+0x50>
{
 a46:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a48:	fed7fae3          	bgeu	a5,a3,a3c <free+0x36>
 a4c:	6398                	ld	a4,0(a5)
 a4e:	00e6e463          	bltu	a3,a4,a56 <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a52:	fee7eae3          	bltu	a5,a4,a46 <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 a56:	ff852583          	lw	a1,-8(a0)
 a5a:	6390                	ld	a2,0(a5)
 a5c:	02059713          	slli	a4,a1,0x20
 a60:	9301                	srli	a4,a4,0x20
 a62:	0712                	slli	a4,a4,0x4
 a64:	9736                	add	a4,a4,a3
 a66:	fae60ae3          	beq	a2,a4,a1a <free+0x14>
        bp->s.ptr = p->s.ptr;
 a6a:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 a6e:	4790                	lw	a2,8(a5)
 a70:	02061713          	slli	a4,a2,0x20
 a74:	9301                	srli	a4,a4,0x20
 a76:	0712                	slli	a4,a4,0x4
 a78:	973e                	add	a4,a4,a5
 a7a:	fae689e3          	beq	a3,a4,a2c <free+0x26>
    }
    else
        p->s.ptr = bp;
 a7e:	e394                	sd	a3,0(a5)
    freep = p;
 a80:	00000717          	auipc	a4,0x0
 a84:	50f73823          	sd	a5,1296(a4) # f90 <freep>
}
 a88:	6422                	ld	s0,8(sp)
 a8a:	0141                	addi	sp,sp,16
 a8c:	8082                	ret

0000000000000a8e <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 a8e:	7139                	addi	sp,sp,-64
 a90:	fc06                	sd	ra,56(sp)
 a92:	f822                	sd	s0,48(sp)
 a94:	f426                	sd	s1,40(sp)
 a96:	f04a                	sd	s2,32(sp)
 a98:	ec4e                	sd	s3,24(sp)
 a9a:	e852                	sd	s4,16(sp)
 a9c:	e456                	sd	s5,8(sp)
 a9e:	e05a                	sd	s6,0(sp)
 aa0:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 aa2:	02051493          	slli	s1,a0,0x20
 aa6:	9081                	srli	s1,s1,0x20
 aa8:	04bd                	addi	s1,s1,15
 aaa:	8091                	srli	s1,s1,0x4
 aac:	0014899b          	addiw	s3,s1,1
 ab0:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 ab2:	00000517          	auipc	a0,0x0
 ab6:	4de53503          	ld	a0,1246(a0) # f90 <freep>
 aba:	c515                	beqz	a0,ae6 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 abc:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 abe:	4798                	lw	a4,8(a5)
 ac0:	02977f63          	bgeu	a4,s1,afe <malloc+0x70>
 ac4:	8a4e                	mv	s4,s3
 ac6:	0009871b          	sext.w	a4,s3
 aca:	6685                	lui	a3,0x1
 acc:	00d77363          	bgeu	a4,a3,ad2 <malloc+0x44>
 ad0:	6a05                	lui	s4,0x1
 ad2:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 ad6:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 ada:	00000917          	auipc	s2,0x0
 ade:	4b690913          	addi	s2,s2,1206 # f90 <freep>
    if (p == (char *)-1)
 ae2:	5afd                	li	s5,-1
 ae4:	a88d                	j	b56 <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 ae6:	00001797          	auipc	a5,0x1
 aea:	4b278793          	addi	a5,a5,1202 # 1f98 <base>
 aee:	00000717          	auipc	a4,0x0
 af2:	4af73123          	sd	a5,1186(a4) # f90 <freep>
 af6:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 af8:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 afc:	b7e1                	j	ac4 <malloc+0x36>
            if (p->s.size == nunits)
 afe:	02e48b63          	beq	s1,a4,b34 <malloc+0xa6>
                p->s.size -= nunits;
 b02:	4137073b          	subw	a4,a4,s3
 b06:	c798                	sw	a4,8(a5)
                p += p->s.size;
 b08:	1702                	slli	a4,a4,0x20
 b0a:	9301                	srli	a4,a4,0x20
 b0c:	0712                	slli	a4,a4,0x4
 b0e:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 b10:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 b14:	00000717          	auipc	a4,0x0
 b18:	46a73e23          	sd	a0,1148(a4) # f90 <freep>
            return (void *)(p + 1);
 b1c:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 b20:	70e2                	ld	ra,56(sp)
 b22:	7442                	ld	s0,48(sp)
 b24:	74a2                	ld	s1,40(sp)
 b26:	7902                	ld	s2,32(sp)
 b28:	69e2                	ld	s3,24(sp)
 b2a:	6a42                	ld	s4,16(sp)
 b2c:	6aa2                	ld	s5,8(sp)
 b2e:	6b02                	ld	s6,0(sp)
 b30:	6121                	addi	sp,sp,64
 b32:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 b34:	6398                	ld	a4,0(a5)
 b36:	e118                	sd	a4,0(a0)
 b38:	bff1                	j	b14 <malloc+0x86>
    hp->s.size = nu;
 b3a:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 b3e:	0541                	addi	a0,a0,16
 b40:	00000097          	auipc	ra,0x0
 b44:	ec6080e7          	jalr	-314(ra) # a06 <free>
    return freep;
 b48:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 b4c:	d971                	beqz	a0,b20 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 b4e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 b50:	4798                	lw	a4,8(a5)
 b52:	fa9776e3          	bgeu	a4,s1,afe <malloc+0x70>
        if (p == freep)
 b56:	00093703          	ld	a4,0(s2)
 b5a:	853e                	mv	a0,a5
 b5c:	fef719e3          	bne	a4,a5,b4e <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 b60:	8552                	mv	a0,s4
 b62:	00000097          	auipc	ra,0x0
 b66:	b3e080e7          	jalr	-1218(ra) # 6a0 <sbrk>
    if (p == (char *)-1)
 b6a:	fd5518e3          	bne	a0,s5,b3a <malloc+0xac>
                return 0;
 b6e:	4501                	li	a0,0
 b70:	bf45                	j	b20 <malloc+0x92>
