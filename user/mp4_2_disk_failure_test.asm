
user/_mp4_2_disk_failure_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fill_data>:
char raw_read_buf1[BSIZE];
char raw_read_buf2[BSIZE];
char dummy_buf[BSIZE];

void fill_data(char *buf, int lbn_for_pattern, char pattern_char)
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
  1a:	66e080e7          	jalr	1646(ra) # 684 <memset>
    buf[0] = (char)lbn_for_pattern;
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
  2e:	7179                	addi	sp,sp,-48
  30:	f406                	sd	ra,40(sp)
  32:	f022                	sd	s0,32(sp)
  34:	ec26                	sd	s1,24(sp)
  36:	e84a                	sd	s2,16(sp)
  38:	e44e                	sd	s3,8(sp)
  3a:	e052                	sd	s4,0(sp)
  3c:	1800                	addi	s0,sp,48
  3e:	8a2a                	mv	s4,a0
  40:	89ae                	mv	s3,a1
  42:	8936                	mv	s2,a3
    if (memcmp(buf1, buf2, size) != 0)
  44:	00000097          	auipc	ra,0x0
  48:	7e2080e7          	jalr	2018(ra) # 826 <memcmp>
  4c:	e505                	bnez	a0,74 <compare_buffers+0x46>
  4e:	84aa                	mv	s1,a0
        for (int k = 0; k < 16; k++)
            printf("%x ", (unsigned char)buf2[k]);
        printf("\n");
        return -1;
    }
    printf("  Data Compare OK. Context: %s\n", context_msg);
  50:	85ca                	mv	a1,s2
  52:	00001517          	auipc	a0,0x1
  56:	dfe50513          	addi	a0,a0,-514 # e50 <malloc+0x15a>
  5a:	00001097          	auipc	ra,0x1
  5e:	bde080e7          	jalr	-1058(ra) # c38 <printf>
    return 0;
}
  62:	8526                	mv	a0,s1
  64:	70a2                	ld	ra,40(sp)
  66:	7402                	ld	s0,32(sp)
  68:	64e2                	ld	s1,24(sp)
  6a:	6942                	ld	s2,16(sp)
  6c:	69a2                	ld	s3,8(sp)
  6e:	6a02                	ld	s4,0(sp)
  70:	6145                	addi	sp,sp,48
  72:	8082                	ret
        printf("  ERROR: Data Mismatch! Context: %s\n", context_msg);
  74:	85ca                	mv	a1,s2
  76:	00001517          	auipc	a0,0x1
  7a:	d6a50513          	addi	a0,a0,-662 # de0 <malloc+0xea>
  7e:	00001097          	auipc	ra,0x1
  82:	bba080e7          	jalr	-1094(ra) # c38 <printf>
        printf("    Buf1 (Hex, first 16): ");
  86:	00001517          	auipc	a0,0x1
  8a:	d8250513          	addi	a0,a0,-638 # e08 <malloc+0x112>
  8e:	00001097          	auipc	ra,0x1
  92:	baa080e7          	jalr	-1110(ra) # c38 <printf>
        for (int k = 0; k < 16; k++)
  96:	84d2                	mv	s1,s4
  98:	0a41                	addi	s4,s4,16
            printf("%x ", (unsigned char)buf1[k]);
  9a:	00001917          	auipc	s2,0x1
  9e:	d8e90913          	addi	s2,s2,-626 # e28 <malloc+0x132>
  a2:	0004c583          	lbu	a1,0(s1)
  a6:	854a                	mv	a0,s2
  a8:	00001097          	auipc	ra,0x1
  ac:	b90080e7          	jalr	-1136(ra) # c38 <printf>
        for (int k = 0; k < 16; k++)
  b0:	0485                	addi	s1,s1,1
  b2:	ff4498e3          	bne	s1,s4,a2 <compare_buffers+0x74>
        printf("\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	0fa50513          	addi	a0,a0,250 # 11b0 <malloc+0x4ba>
  be:	00001097          	auipc	ra,0x1
  c2:	b7a080e7          	jalr	-1158(ra) # c38 <printf>
        printf("    Buf2 (Hex, first 16): ");
  c6:	00001517          	auipc	a0,0x1
  ca:	d6a50513          	addi	a0,a0,-662 # e30 <malloc+0x13a>
  ce:	00001097          	auipc	ra,0x1
  d2:	b6a080e7          	jalr	-1174(ra) # c38 <printf>
        for (int k = 0; k < 16; k++)
  d6:	84ce                	mv	s1,s3
  d8:	09c1                	addi	s3,s3,16
            printf("%x ", (unsigned char)buf2[k]);
  da:	00001917          	auipc	s2,0x1
  de:	d4e90913          	addi	s2,s2,-690 # e28 <malloc+0x132>
  e2:	0004c583          	lbu	a1,0(s1)
  e6:	854a                	mv	a0,s2
  e8:	00001097          	auipc	ra,0x1
  ec:	b50080e7          	jalr	-1200(ra) # c38 <printf>
        for (int k = 0; k < 16; k++)
  f0:	0485                	addi	s1,s1,1
  f2:	ff3498e3          	bne	s1,s3,e2 <compare_buffers+0xb4>
        printf("\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	0ba50513          	addi	a0,a0,186 # 11b0 <malloc+0x4ba>
  fe:	00001097          	auipc	ra,0x1
 102:	b3a080e7          	jalr	-1222(ra) # c38 <printf>
        return -1;
 106:	54fd                	li	s1,-1
 108:	bfa9                	j	62 <compare_buffers+0x34>

000000000000010a <read_physical_block_wrapper>:

int read_physical_block_wrapper(int pbn, char *buf, const char *context_msg)
{
 10a:	7179                	addi	sp,sp,-48
 10c:	f406                	sd	ra,40(sp)
 10e:	f022                	sd	s0,32(sp)
 110:	ec26                	sd	s1,24(sp)
 112:	e84a                	sd	s2,16(sp)
 114:	e44e                	sd	s3,8(sp)
 116:	1800                	addi	s0,sp,48
 118:	84aa                	mv	s1,a0
 11a:	892e                	mv	s2,a1
 11c:	89b2                	mv	s3,a2
    printf("  Attempting raw_read for PBN %d (%s)...\n", pbn, context_msg);
 11e:	85aa                	mv	a1,a0
 120:	00001517          	auipc	a0,0x1
 124:	d5050513          	addi	a0,a0,-688 # e70 <malloc+0x17a>
 128:	00001097          	auipc	ra,0x1
 12c:	b10080e7          	jalr	-1264(ra) # c38 <printf>
    int ret = raw_read(pbn, buf);
 130:	85ca                	mv	a1,s2
 132:	8526                	mv	a0,s1
 134:	00000097          	auipc	ra,0x0
 138:	7fc080e7          	jalr	2044(ra) # 930 <raw_read>
    if (ret < 0)
 13c:	00054a63          	bltz	a0,150 <read_physical_block_wrapper+0x46>
    {
        printf("  ERROR: raw_read failed for PBN %d (%s)!\n", pbn, context_msg);
        return -1;
    }
    return 0;
 140:	4501                	li	a0,0
}
 142:	70a2                	ld	ra,40(sp)
 144:	7402                	ld	s0,32(sp)
 146:	64e2                	ld	s1,24(sp)
 148:	6942                	ld	s2,16(sp)
 14a:	69a2                	ld	s3,8(sp)
 14c:	6145                	addi	sp,sp,48
 14e:	8082                	ret
        printf("  ERROR: raw_read failed for PBN %d (%s)!\n", pbn, context_msg);
 150:	864e                	mv	a2,s3
 152:	85a6                	mv	a1,s1
 154:	00001517          	auipc	a0,0x1
 158:	d4c50513          	addi	a0,a0,-692 # ea0 <malloc+0x1aa>
 15c:	00001097          	auipc	ra,0x1
 160:	adc080e7          	jalr	-1316(ra) # c38 <printf>
        return -1;
 164:	557d                	li	a0,-1
 166:	bff1                	j	142 <read_physical_block_wrapper+0x38>

0000000000000168 <main>:

int main()
{
 168:	7179                	addi	sp,sp,-48
 16a:	f406                	sd	ra,40(sp)
 16c:	f022                	sd	s0,32(sp)
 16e:	ec26                	sd	s1,24(sp)
 170:	e84a                	sd	s2,16(sp)
 172:	e44e                	sd	s3,8(sp)
 174:	1800                	addi	s0,sp,48
    int overall_pass = 1;

    char initial_pattern = 'S';
    char corrupt_pattern = 'X';

    printf("=== Combined RAID 1 Mirroring and Fallback Test ===\n");
 176:	00001517          	auipc	a0,0x1
 17a:	d5a50513          	addi	a0,a0,-678 # ed0 <malloc+0x1da>
 17e:	00001097          	auipc	ra,0x1
 182:	aba080e7          	jalr	-1350(ra) # c38 <printf>
    printf("Target File LBN: %d\n\n", file_lbn_to_test);
 186:	4585                	li	a1,1
 188:	00001517          	auipc	a0,0x1
 18c:	d8050513          	addi	a0,a0,-640 # f08 <malloc+0x212>
 190:	00001097          	auipc	ra,0x1
 194:	aa8080e7          	jalr	-1368(ra) # c38 <printf>

    fill_data(initial_data, file_lbn_to_test, initial_pattern);
 198:	05300613          	li	a2,83
 19c:	4585                	li	a1,1
 19e:	00001517          	auipc	a0,0x1
 1a2:	34250513          	addi	a0,a0,834 # 14e0 <initial_data>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	e5a080e7          	jalr	-422(ra) # 0 <fill_data>
    fill_data(pbn0_corrupted_data, file_lbn_to_test, corrupt_pattern);
 1ae:	05800613          	li	a2,88
 1b2:	4585                	li	a1,1
 1b4:	00001517          	auipc	a0,0x1
 1b8:	72c50513          	addi	a0,a0,1836 # 18e0 <pbn0_corrupted_data>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	e44080e7          	jalr	-444(ra) # 0 <fill_data>
    fill_data(dummy_buf, 0, '.');
 1c4:	02e00613          	li	a2,46
 1c8:	4581                	li	a1,0
 1ca:	00002517          	auipc	a0,0x2
 1ce:	b1650513          	addi	a0,a0,-1258 # 1ce0 <dummy_buf>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	e2e080e7          	jalr	-466(ra) # 0 <fill_data>

    printf(
 1da:	05300593          	li	a1,83
 1de:	00001517          	auipc	a0,0x1
 1e2:	d4250513          	addi	a0,a0,-702 # f20 <malloc+0x22a>
 1e6:	00001097          	auipc	ra,0x1
 1ea:	a52080e7          	jalr	-1454(ra) # c38 <printf>
        "--- Phase 1: Initial Write (Pattern '%c') & Mirror Verification ---\n",
        initial_pattern);
    force_disk_fail(-1);
 1ee:	557d                	li	a0,-1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	758080e7          	jalr	1880(ra) # 948 <force_disk_fail>
    fd_write = open("combined_test.dat", O_CREATE | O_RDWR | O_TRUNC);
 1f8:	60200593          	li	a1,1538
 1fc:	00001517          	auipc	a0,0x1
 200:	d6c50513          	addi	a0,a0,-660 # f68 <malloc+0x272>
 204:	00000097          	auipc	ra,0x0
 208:	6bc080e7          	jalr	1724(ra) # 8c0 <open>
    if (fd_write < 0)
 20c:	1c054563          	bltz	a0,3d6 <main+0x26e>
 210:	84aa                	mv	s1,a0
        exit(1);
    }

    for (int i = 0; i <= file_lbn_to_test; i++)
    {
        if (write(fd_write, (i == file_lbn_to_test ? initial_data : dummy_buf),
 212:	40000613          	li	a2,1024
 216:	00002597          	auipc	a1,0x2
 21a:	aca58593          	addi	a1,a1,-1334 # 1ce0 <dummy_buf>
 21e:	00000097          	auipc	ra,0x0
 222:	682080e7          	jalr	1666(ra) # 8a0 <write>
 226:	40000793          	li	a5,1024
 22a:	1cf51363          	bne	a0,a5,3f0 <main+0x288>
 22e:	40000613          	li	a2,1024
 232:	00001597          	auipc	a1,0x1
 236:	2ae58593          	addi	a1,a1,686 # 14e0 <initial_data>
 23a:	8526                	mv	a0,s1
 23c:	00000097          	auipc	ra,0x0
 240:	664080e7          	jalr	1636(ra) # 8a0 <write>
 244:	40000793          	li	a5,1024
 248:	1af51463          	bne	a0,a5,3f0 <main+0x288>
            printf("ERROR writing in Phase 1\n");
            close(fd_write);
            exit(1);
        }
    }
    disk_lbn = get_disk_lbn(fd_write, file_lbn_to_test);
 24c:	4585                	li	a1,1
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	6e8080e7          	jalr	1768(ra) # 938 <get_disk_lbn>
 258:	892a                	mv	s2,a0
    if (disk_lbn <= 0)
 25a:	1aa05d63          	blez	a0,414 <main+0x2ac>
        printf("ERROR: get_disk_lbn failed\n");
        close(fd_write);
        exit(1);
    }
    pbn0 = disk_lbn;
    pbn1 = disk_lbn + DISK1_START_BLOCK;
 25e:	6985                	lui	s3,0x1
 260:	8009899b          	addiw	s3,s3,-2048
 264:	00a989bb          	addw	s3,s3,a0
    printf("  File LBN %d mapped to Disk LBN %d (PBN0=%d, PBN1=%d).\n",
 268:	874e                	mv	a4,s3
 26a:	86aa                	mv	a3,a0
 26c:	862a                	mv	a2,a0
 26e:	4585                	li	a1,1
 270:	00001517          	auipc	a0,0x1
 274:	d7050513          	addi	a0,a0,-656 # fe0 <malloc+0x2ea>
 278:	00001097          	auipc	ra,0x1
 27c:	9c0080e7          	jalr	-1600(ra) # c38 <printf>
           file_lbn_to_test, disk_lbn, pbn0, pbn1);
    close(fd_write);
 280:	8526                	mv	a0,s1
 282:	00000097          	auipc	ra,0x0
 286:	626080e7          	jalr	1574(ra) # 8a8 <close>
    printf("  Waiting for commit...\n");
 28a:	00001517          	auipc	a0,0x1
 28e:	d9650513          	addi	a0,a0,-618 # 1020 <malloc+0x32a>
 292:	00001097          	auipc	ra,0x1
 296:	9a6080e7          	jalr	-1626(ra) # c38 <printf>
    sleep(100);
 29a:	06400513          	li	a0,100
 29e:	00000097          	auipc	ra,0x0
 2a2:	672080e7          	jalr	1650(ra) # 910 <sleep>

    printf("  Verifying initial mirror state (Criterion 1):\n");
 2a6:	00001517          	auipc	a0,0x1
 2aa:	d9a50513          	addi	a0,a0,-614 # 1040 <malloc+0x34a>
 2ae:	00001097          	auipc	ra,0x1
 2b2:	98a080e7          	jalr	-1654(ra) # c38 <printf>
    if (read_physical_block_wrapper(pbn0, raw_read_buf1, "Initial PBN0") != 0)
 2b6:	00001617          	auipc	a2,0x1
 2ba:	dc260613          	addi	a2,a2,-574 # 1078 <malloc+0x382>
 2be:	00002597          	auipc	a1,0x2
 2c2:	e2258593          	addi	a1,a1,-478 # 20e0 <raw_read_buf1>
 2c6:	854a                	mv	a0,s2
 2c8:	00000097          	auipc	ra,0x0
 2cc:	e42080e7          	jalr	-446(ra) # 10a <read_physical_block_wrapper>
 2d0:	84aa                	mv	s1,a0
        overall_pass = 0;
    if (read_physical_block_wrapper(pbn1, raw_read_buf2, "Initial PBN1") != 0)
 2d2:	00001617          	auipc	a2,0x1
 2d6:	db660613          	addi	a2,a2,-586 # 1088 <malloc+0x392>
 2da:	00002597          	auipc	a1,0x2
 2de:	20658593          	addi	a1,a1,518 # 24e0 <raw_read_buf2>
 2e2:	854e                	mv	a0,s3
 2e4:	00000097          	auipc	ra,0x0
 2e8:	e26080e7          	jalr	-474(ra) # 10a <read_physical_block_wrapper>
 2ec:	8cc9                	or	s1,s1,a0
 2ee:	2481                	sext.w	s1,s1
 2f0:	30049463          	bnez	s1,5f8 <main+0x490>
        overall_pass = 0;

    if (overall_pass)
    {
        if (compare_buffers(initial_data, raw_read_buf1, BSIZE,
 2f4:	00001917          	auipc	s2,0x1
 2f8:	1ec90913          	addi	s2,s2,492 # 14e0 <initial_data>
 2fc:	00001697          	auipc	a3,0x1
 300:	d9c68693          	addi	a3,a3,-612 # 1098 <malloc+0x3a2>
 304:	40000613          	li	a2,1024
 308:	00002597          	auipc	a1,0x2
 30c:	dd858593          	addi	a1,a1,-552 # 20e0 <raw_read_buf1>
 310:	854a                	mv	a0,s2
 312:	00000097          	auipc	ra,0x0
 316:	d1c080e7          	jalr	-740(ra) # 2e <compare_buffers>
 31a:	84aa                	mv	s1,a0
                            "Initial Data vs PBN0 Content") != 0)
            overall_pass = 0;
        if (compare_buffers(initial_data, raw_read_buf2, BSIZE,
 31c:	00001697          	auipc	a3,0x1
 320:	d9c68693          	addi	a3,a3,-612 # 10b8 <malloc+0x3c2>
 324:	40000613          	li	a2,1024
 328:	00002597          	auipc	a1,0x2
 32c:	1b858593          	addi	a1,a1,440 # 24e0 <raw_read_buf2>
 330:	854a                	mv	a0,s2
 332:	00000097          	auipc	ra,0x0
 336:	cfc080e7          	jalr	-772(ra) # 2e <compare_buffers>
 33a:	8cc9                	or	s1,s1,a0
 33c:	2481                	sext.w	s1,s1
 33e:	28049b63          	bnez	s1,5d4 <main+0x46c>
                            "Initial Data vs PBN1 Content") != 0)
            overall_pass = 0;
        if (compare_buffers(raw_read_buf1, raw_read_buf2, BSIZE,
 342:	00001697          	auipc	a3,0x1
 346:	d9668693          	addi	a3,a3,-618 # 10d8 <malloc+0x3e2>
 34a:	40000613          	li	a2,1024
 34e:	00002597          	auipc	a1,0x2
 352:	19258593          	addi	a1,a1,402 # 24e0 <raw_read_buf2>
 356:	00002517          	auipc	a0,0x2
 35a:	d8a50513          	addi	a0,a0,-630 # 20e0 <raw_read_buf1>
 35e:	00000097          	auipc	ra,0x0
 362:	cd0080e7          	jalr	-816(ra) # 2e <compare_buffers>
 366:	892a                	mv	s2,a0
 368:	28051863          	bnez	a0,5f8 <main+0x490>
    if (!overall_pass)
    {
        printf("  Phase 1 FAILED: Initial mirroring was not correct.\n");
        exit(1);
    }
    printf("  Phase 1: Initial mirroring verified PASSED.\n\n");
 36c:	00001517          	auipc	a0,0x1
 370:	dc450513          	addi	a0,a0,-572 # 1130 <malloc+0x43a>
 374:	00001097          	auipc	ra,0x1
 378:	8c4080e7          	jalr	-1852(ra) # c38 <printf>

    printf("--- Phase 3: Simulating Disk 0 Read Failure & Testing Fallback "
 37c:	00001517          	auipc	a0,0x1
 380:	de450513          	addi	a0,a0,-540 # 1160 <malloc+0x46a>
 384:	00001097          	auipc	ra,0x1
 388:	8b4080e7          	jalr	-1868(ra) # c38 <printf>
           "(Criterion 3) ---\n");
    if (force_disk_fail(0) < 0)
 38c:	4501                	li	a0,0
 38e:	00000097          	auipc	ra,0x0
 392:	5ba080e7          	jalr	1466(ra) # 948 <force_disk_fail>
 396:	0a054163          	bltz	a0,438 <main+0x2d0>
    {
        printf("  ERROR: force_disk_fail(0) failed!\n");
        exit(1);
    }

    fd_read = open("combined_test.dat", O_RDONLY);
 39a:	4581                	li	a1,0
 39c:	00001517          	auipc	a0,0x1
 3a0:	bcc50513          	addi	a0,a0,-1076 # f68 <malloc+0x272>
 3a4:	00000097          	auipc	ra,0x0
 3a8:	51c080e7          	jalr	1308(ra) # 8c0 <open>
 3ac:	84aa                	mv	s1,a0
    if (fd_read < 0)
 3ae:	0a055263          	bgez	a0,452 <main+0x2ea>
    {
        printf("  ERROR: Failed to open file for fallback read!\n");
 3b2:	00001517          	auipc	a0,0x1
 3b6:	e2e50513          	addi	a0,a0,-466 # 11e0 <malloc+0x4ea>
 3ba:	00001097          	auipc	ra,0x1
 3be:	87e080e7          	jalr	-1922(ra) # c38 <printf>
        force_disk_fail(-1);
 3c2:	557d                	li	a0,-1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	584080e7          	jalr	1412(ra) # 948 <force_disk_fail>
        exit(1);
 3cc:	4505                	li	a0,1
 3ce:	00000097          	auipc	ra,0x0
 3d2:	4b2080e7          	jalr	1202(ra) # 880 <exit>
        printf("ERROR: Cannot create file\n");
 3d6:	00001517          	auipc	a0,0x1
 3da:	baa50513          	addi	a0,a0,-1110 # f80 <malloc+0x28a>
 3de:	00001097          	auipc	ra,0x1
 3e2:	85a080e7          	jalr	-1958(ra) # c38 <printf>
        exit(1);
 3e6:	4505                	li	a0,1
 3e8:	00000097          	auipc	ra,0x0
 3ec:	498080e7          	jalr	1176(ra) # 880 <exit>
            printf("ERROR writing in Phase 1\n");
 3f0:	00001517          	auipc	a0,0x1
 3f4:	bb050513          	addi	a0,a0,-1104 # fa0 <malloc+0x2aa>
 3f8:	00001097          	auipc	ra,0x1
 3fc:	840080e7          	jalr	-1984(ra) # c38 <printf>
            close(fd_write);
 400:	8526                	mv	a0,s1
 402:	00000097          	auipc	ra,0x0
 406:	4a6080e7          	jalr	1190(ra) # 8a8 <close>
            exit(1);
 40a:	4505                	li	a0,1
 40c:	00000097          	auipc	ra,0x0
 410:	474080e7          	jalr	1140(ra) # 880 <exit>
        printf("ERROR: get_disk_lbn failed\n");
 414:	00001517          	auipc	a0,0x1
 418:	bac50513          	addi	a0,a0,-1108 # fc0 <malloc+0x2ca>
 41c:	00001097          	auipc	ra,0x1
 420:	81c080e7          	jalr	-2020(ra) # c38 <printf>
        close(fd_write);
 424:	8526                	mv	a0,s1
 426:	00000097          	auipc	ra,0x0
 42a:	482080e7          	jalr	1154(ra) # 8a8 <close>
        exit(1);
 42e:	4505                	li	a0,1
 430:	00000097          	auipc	ra,0x0
 434:	450080e7          	jalr	1104(ra) # 880 <exit>
        printf("  ERROR: force_disk_fail(0) failed!\n");
 438:	00001517          	auipc	a0,0x1
 43c:	d8050513          	addi	a0,a0,-640 # 11b8 <malloc+0x4c2>
 440:	00000097          	auipc	ra,0x0
 444:	7f8080e7          	jalr	2040(ra) # c38 <printf>
        exit(1);
 448:	4505                	li	a0,1
 44a:	00000097          	auipc	ra,0x0
 44e:	436080e7          	jalr	1078(ra) # 880 <exit>
    }

    for (int i = 0; i < file_lbn_to_test; i++)
    {
        if (read(fd_read, dummy_buf, BSIZE) != BSIZE)
 452:	40000613          	li	a2,1024
 456:	00002597          	auipc	a1,0x2
 45a:	88a58593          	addi	a1,a1,-1910 # 1ce0 <dummy_buf>
 45e:	00000097          	auipc	ra,0x0
 462:	43a080e7          	jalr	1082(ra) # 898 <read>
 466:	40000793          	li	a5,1024
 46a:	08f51a63          	bne	a0,a5,4fe <main+0x396>
            close(fd_read);
            force_disk_fail(-1);
            exit(1);
        }
    }
    printf("  Calling standard read() for File LBN %d (should fallback to PBN1 "
 46e:	05300613          	li	a2,83
 472:	4585                	li	a1,1
 474:	00001517          	auipc	a0,0x1
 478:	de450513          	addi	a0,a0,-540 # 1258 <malloc+0x562>
 47c:	00000097          	auipc	ra,0x0
 480:	7bc080e7          	jalr	1980(ra) # c38 <printf>
           "which has '%c')...\n",
           file_lbn_to_test, initial_pattern);
    if (read(fd_read, read_buf, BSIZE) != BSIZE)
 484:	40000613          	li	a2,1024
 488:	00002597          	auipc	a1,0x2
 48c:	45858593          	addi	a1,a1,1112 # 28e0 <read_buf>
 490:	8526                	mv	a0,s1
 492:	00000097          	auipc	ra,0x0
 496:	406080e7          	jalr	1030(ra) # 898 <read>
 49a:	40000793          	li	a5,1024
 49e:	08f51863          	bne	a0,a5,52e <main+0x3c6>
        printf("  ERROR: Standard read() failed for File LBN %d during "
               "fallback test!\n",
               file_lbn_to_test);
        overall_pass = 0;
    }
    close(fd_read);
 4a2:	8526                	mv	a0,s1
 4a4:	00000097          	auipc	ra,0x0
 4a8:	404080e7          	jalr	1028(ra) # 8a8 <close>

    printf("  Calling force_disk_fail(-1) to disable simulation...\n");
 4ac:	00001517          	auipc	a0,0x1
 4b0:	e4c50513          	addi	a0,a0,-436 # 12f8 <malloc+0x602>
 4b4:	00000097          	auipc	ra,0x0
 4b8:	784080e7          	jalr	1924(ra) # c38 <printf>
    force_disk_fail(-1);
 4bc:	557d                	li	a0,-1
 4be:	00000097          	auipc	ra,0x0
 4c2:	48a080e7          	jalr	1162(ra) # 948 <force_disk_fail>

    if (overall_pass)
    {
        if (compare_buffers(
 4c6:	00001697          	auipc	a3,0x1
 4ca:	fba68693          	addi	a3,a3,-70 # 1480 <malloc+0x78a>
 4ce:	40000613          	li	a2,1024
 4d2:	00002597          	auipc	a1,0x2
 4d6:	40e58593          	addi	a1,a1,1038 # 28e0 <read_buf>
 4da:	00001517          	auipc	a0,0x1
 4de:	00650513          	addi	a0,a0,6 # 14e0 <initial_data>
 4e2:	00000097          	auipc	ra,0x0
 4e6:	b4c080e7          	jalr	-1204(ra) # 2e <compare_buffers>
 4ea:	c555                	beqz	a0,596 <main+0x42e>
            printf("  Phase 2: Read Fallback Test PASSED (Correctly read "
                   "initial data from Disk 1).\n");
        }
        else
        {
            printf("  Phase 2: Read Fallback Test FAILED (Data mismatch).\n");
 4ec:	00001517          	auipc	a0,0x1
 4f0:	f3450513          	addi	a0,a0,-204 # 1420 <malloc+0x72a>
 4f4:	00000097          	auipc	ra,0x0
 4f8:	744080e7          	jalr	1860(ra) # c38 <printf>
            overall_pass = 0;
 4fc:	a8a5                	j	574 <main+0x40c>
            printf(
 4fe:	4581                	li	a1,0
 500:	00001517          	auipc	a0,0x1
 504:	d1850513          	addi	a0,a0,-744 # 1218 <malloc+0x522>
 508:	00000097          	auipc	ra,0x0
 50c:	730080e7          	jalr	1840(ra) # c38 <printf>
            close(fd_read);
 510:	8526                	mv	a0,s1
 512:	00000097          	auipc	ra,0x0
 516:	396080e7          	jalr	918(ra) # 8a8 <close>
            force_disk_fail(-1);
 51a:	557d                	li	a0,-1
 51c:	00000097          	auipc	ra,0x0
 520:	42c080e7          	jalr	1068(ra) # 948 <force_disk_fail>
            exit(1);
 524:	4505                	li	a0,1
 526:	00000097          	auipc	ra,0x0
 52a:	35a080e7          	jalr	858(ra) # 880 <exit>
        printf("  ERROR: Standard read() failed for File LBN %d during "
 52e:	4585                	li	a1,1
 530:	00001517          	auipc	a0,0x1
 534:	d8050513          	addi	a0,a0,-640 # 12b0 <malloc+0x5ba>
 538:	00000097          	auipc	ra,0x0
 53c:	700080e7          	jalr	1792(ra) # c38 <printf>
    close(fd_read);
 540:	8526                	mv	a0,s1
 542:	00000097          	auipc	ra,0x0
 546:	366080e7          	jalr	870(ra) # 8a8 <close>
    printf("  Calling force_disk_fail(-1) to disable simulation...\n");
 54a:	00001517          	auipc	a0,0x1
 54e:	dae50513          	addi	a0,a0,-594 # 12f8 <malloc+0x602>
 552:	00000097          	auipc	ra,0x0
 556:	6e6080e7          	jalr	1766(ra) # c38 <printf>
    force_disk_fail(-1);
 55a:	557d                	li	a0,-1
 55c:	00000097          	auipc	ra,0x0
 560:	3ec080e7          	jalr	1004(ra) # 948 <force_disk_fail>
        }
    }
    else
    {
        printf("  Phase 2: Read Fallback Test FAILED (Read operation itself "
 564:	00001517          	auipc	a0,0x1
 568:	dcc50513          	addi	a0,a0,-564 # 1330 <malloc+0x63a>
 56c:	00000097          	auipc	ra,0x0
 570:	6cc080e7          	jalr	1740(ra) # c38 <printf>
               "failed).\n");
    }

    printf("\n=== Combined RAID Test Summary ===\n");
 574:	00001517          	auipc	a0,0x1
 578:	e5c50513          	addi	a0,a0,-420 # 13d0 <malloc+0x6da>
 57c:	00000097          	auipc	ra,0x0
 580:	6bc080e7          	jalr	1724(ra) # c38 <printf>
    {
        printf("Bread Disk Failure Fallback Test: PASS\n");
    }
    else
    {
        printf("One or more critical checks FAILED!\n");
 584:	00001517          	auipc	a0,0x1
 588:	ed450513          	addi	a0,a0,-300 # 1458 <malloc+0x762>
 58c:	00000097          	auipc	ra,0x0
 590:	6ac080e7          	jalr	1708(ra) # c38 <printf>
 594:	a815                	j	5c8 <main+0x460>
            printf("  Phase 2: Read Fallback Test PASSED (Correctly read "
 596:	00001517          	auipc	a0,0x1
 59a:	de250513          	addi	a0,a0,-542 # 1378 <malloc+0x682>
 59e:	00000097          	auipc	ra,0x0
 5a2:	69a080e7          	jalr	1690(ra) # c38 <printf>
    printf("\n=== Combined RAID Test Summary ===\n");
 5a6:	00001517          	auipc	a0,0x1
 5aa:	e2a50513          	addi	a0,a0,-470 # 13d0 <malloc+0x6da>
 5ae:	00000097          	auipc	ra,0x0
 5b2:	68a080e7          	jalr	1674(ra) # c38 <printf>
        printf("Bread Disk Failure Fallback Test: PASS\n");
 5b6:	00001517          	auipc	a0,0x1
 5ba:	e4250513          	addi	a0,a0,-446 # 13f8 <malloc+0x702>
 5be:	00000097          	auipc	ra,0x0
 5c2:	67a080e7          	jalr	1658(ra) # c38 <printf>
 5c6:	4905                	li	s2,1
    }

    exit(overall_pass ? 0 : 1);
 5c8:	00193513          	seqz	a0,s2
 5cc:	00000097          	auipc	ra,0x0
 5d0:	2b4080e7          	jalr	692(ra) # 880 <exit>
        if (compare_buffers(raw_read_buf1, raw_read_buf2, BSIZE,
 5d4:	00001697          	auipc	a3,0x1
 5d8:	b0468693          	addi	a3,a3,-1276 # 10d8 <malloc+0x3e2>
 5dc:	40000613          	li	a2,1024
 5e0:	00002597          	auipc	a1,0x2
 5e4:	f0058593          	addi	a1,a1,-256 # 24e0 <raw_read_buf2>
 5e8:	00002517          	auipc	a0,0x2
 5ec:	af850513          	addi	a0,a0,-1288 # 20e0 <raw_read_buf1>
 5f0:	00000097          	auipc	ra,0x0
 5f4:	a3e080e7          	jalr	-1474(ra) # 2e <compare_buffers>
        printf("  Phase 1 FAILED: Initial mirroring was not correct.\n");
 5f8:	00001517          	auipc	a0,0x1
 5fc:	b0050513          	addi	a0,a0,-1280 # 10f8 <malloc+0x402>
 600:	00000097          	auipc	ra,0x0
 604:	638080e7          	jalr	1592(ra) # c38 <printf>
        exit(1);
 608:	4505                	li	a0,1
 60a:	00000097          	auipc	ra,0x0
 60e:	276080e7          	jalr	630(ra) # 880 <exit>

0000000000000612 <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char *strcpy(char *s, const char *t)
{
 612:	1141                	addi	sp,sp,-16
 614:	e422                	sd	s0,8(sp)
 616:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 618:	87aa                	mv	a5,a0
 61a:	0585                	addi	a1,a1,1
 61c:	0785                	addi	a5,a5,1
 61e:	fff5c703          	lbu	a4,-1(a1)
 622:	fee78fa3          	sb	a4,-1(a5)
 626:	fb75                	bnez	a4,61a <strcpy+0x8>
        ;
    return os;
}
 628:	6422                	ld	s0,8(sp)
 62a:	0141                	addi	sp,sp,16
 62c:	8082                	ret

000000000000062e <strcmp>:

int strcmp(const char *p, const char *q)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e422                	sd	s0,8(sp)
 632:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 634:	00054783          	lbu	a5,0(a0)
 638:	cb91                	beqz	a5,64c <strcmp+0x1e>
 63a:	0005c703          	lbu	a4,0(a1)
 63e:	00f71763          	bne	a4,a5,64c <strcmp+0x1e>
        p++, q++;
 642:	0505                	addi	a0,a0,1
 644:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 646:	00054783          	lbu	a5,0(a0)
 64a:	fbe5                	bnez	a5,63a <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 64c:	0005c503          	lbu	a0,0(a1)
}
 650:	40a7853b          	subw	a0,a5,a0
 654:	6422                	ld	s0,8(sp)
 656:	0141                	addi	sp,sp,16
 658:	8082                	ret

000000000000065a <strlen>:

uint strlen(const char *s)
{
 65a:	1141                	addi	sp,sp,-16
 65c:	e422                	sd	s0,8(sp)
 65e:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 660:	00054783          	lbu	a5,0(a0)
 664:	cf91                	beqz	a5,680 <strlen+0x26>
 666:	0505                	addi	a0,a0,1
 668:	87aa                	mv	a5,a0
 66a:	4685                	li	a3,1
 66c:	9e89                	subw	a3,a3,a0
 66e:	00f6853b          	addw	a0,a3,a5
 672:	0785                	addi	a5,a5,1
 674:	fff7c703          	lbu	a4,-1(a5)
 678:	fb7d                	bnez	a4,66e <strlen+0x14>
        ;
    return n;
}
 67a:	6422                	ld	s0,8(sp)
 67c:	0141                	addi	sp,sp,16
 67e:	8082                	ret
    for (n = 0; s[n]; n++)
 680:	4501                	li	a0,0
 682:	bfe5                	j	67a <strlen+0x20>

0000000000000684 <memset>:

void *memset(void *dst, int c, uint n)
{
 684:	1141                	addi	sp,sp,-16
 686:	e422                	sd	s0,8(sp)
 688:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 68a:	ca19                	beqz	a2,6a0 <memset+0x1c>
 68c:	87aa                	mv	a5,a0
 68e:	1602                	slli	a2,a2,0x20
 690:	9201                	srli	a2,a2,0x20
 692:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 696:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 69a:	0785                	addi	a5,a5,1
 69c:	fee79de3          	bne	a5,a4,696 <memset+0x12>
    }
    return dst;
}
 6a0:	6422                	ld	s0,8(sp)
 6a2:	0141                	addi	sp,sp,16
 6a4:	8082                	ret

00000000000006a6 <strchr>:

char *strchr(const char *s, char c)
{
 6a6:	1141                	addi	sp,sp,-16
 6a8:	e422                	sd	s0,8(sp)
 6aa:	0800                	addi	s0,sp,16
    for (; *s; s++)
 6ac:	00054783          	lbu	a5,0(a0)
 6b0:	cb99                	beqz	a5,6c6 <strchr+0x20>
        if (*s == c)
 6b2:	00f58763          	beq	a1,a5,6c0 <strchr+0x1a>
    for (; *s; s++)
 6b6:	0505                	addi	a0,a0,1
 6b8:	00054783          	lbu	a5,0(a0)
 6bc:	fbfd                	bnez	a5,6b2 <strchr+0xc>
            return (char *)s;
    return 0;
 6be:	4501                	li	a0,0
}
 6c0:	6422                	ld	s0,8(sp)
 6c2:	0141                	addi	sp,sp,16
 6c4:	8082                	ret
    return 0;
 6c6:	4501                	li	a0,0
 6c8:	bfe5                	j	6c0 <strchr+0x1a>

00000000000006ca <gets>:

char *gets(char *buf, int max)
{
 6ca:	711d                	addi	sp,sp,-96
 6cc:	ec86                	sd	ra,88(sp)
 6ce:	e8a2                	sd	s0,80(sp)
 6d0:	e4a6                	sd	s1,72(sp)
 6d2:	e0ca                	sd	s2,64(sp)
 6d4:	fc4e                	sd	s3,56(sp)
 6d6:	f852                	sd	s4,48(sp)
 6d8:	f456                	sd	s5,40(sp)
 6da:	f05a                	sd	s6,32(sp)
 6dc:	ec5e                	sd	s7,24(sp)
 6de:	1080                	addi	s0,sp,96
 6e0:	8baa                	mv	s7,a0
 6e2:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 6e4:	892a                	mv	s2,a0
 6e6:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 6e8:	4aa9                	li	s5,10
 6ea:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 6ec:	89a6                	mv	s3,s1
 6ee:	2485                	addiw	s1,s1,1
 6f0:	0344d863          	bge	s1,s4,720 <gets+0x56>
        cc = read(0, &c, 1);
 6f4:	4605                	li	a2,1
 6f6:	faf40593          	addi	a1,s0,-81
 6fa:	4501                	li	a0,0
 6fc:	00000097          	auipc	ra,0x0
 700:	19c080e7          	jalr	412(ra) # 898 <read>
        if (cc < 1)
 704:	00a05e63          	blez	a0,720 <gets+0x56>
        buf[i++] = c;
 708:	faf44783          	lbu	a5,-81(s0)
 70c:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 710:	01578763          	beq	a5,s5,71e <gets+0x54>
 714:	0905                	addi	s2,s2,1
 716:	fd679be3          	bne	a5,s6,6ec <gets+0x22>
    for (i = 0; i + 1 < max;)
 71a:	89a6                	mv	s3,s1
 71c:	a011                	j	720 <gets+0x56>
 71e:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 720:	99de                	add	s3,s3,s7
 722:	00098023          	sb	zero,0(s3) # 1000 <malloc+0x30a>
    return buf;
}
 726:	855e                	mv	a0,s7
 728:	60e6                	ld	ra,88(sp)
 72a:	6446                	ld	s0,80(sp)
 72c:	64a6                	ld	s1,72(sp)
 72e:	6906                	ld	s2,64(sp)
 730:	79e2                	ld	s3,56(sp)
 732:	7a42                	ld	s4,48(sp)
 734:	7aa2                	ld	s5,40(sp)
 736:	7b02                	ld	s6,32(sp)
 738:	6be2                	ld	s7,24(sp)
 73a:	6125                	addi	sp,sp,96
 73c:	8082                	ret

000000000000073e <stat>:

int stat(const char *n, struct stat *st)
{
 73e:	1101                	addi	sp,sp,-32
 740:	ec06                	sd	ra,24(sp)
 742:	e822                	sd	s0,16(sp)
 744:	e426                	sd	s1,8(sp)
 746:	e04a                	sd	s2,0(sp)
 748:	1000                	addi	s0,sp,32
 74a:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 74c:	4581                	li	a1,0
 74e:	00000097          	auipc	ra,0x0
 752:	172080e7          	jalr	370(ra) # 8c0 <open>
    if (fd < 0)
 756:	02054563          	bltz	a0,780 <stat+0x42>
 75a:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 75c:	85ca                	mv	a1,s2
 75e:	00000097          	auipc	ra,0x0
 762:	17a080e7          	jalr	378(ra) # 8d8 <fstat>
 766:	892a                	mv	s2,a0
    close(fd);
 768:	8526                	mv	a0,s1
 76a:	00000097          	auipc	ra,0x0
 76e:	13e080e7          	jalr	318(ra) # 8a8 <close>
    return r;
}
 772:	854a                	mv	a0,s2
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	64a2                	ld	s1,8(sp)
 77a:	6902                	ld	s2,0(sp)
 77c:	6105                	addi	sp,sp,32
 77e:	8082                	ret
        return -1;
 780:	597d                	li	s2,-1
 782:	bfc5                	j	772 <stat+0x34>

0000000000000784 <atoi>:

int atoi(const char *s)
{
 784:	1141                	addi	sp,sp,-16
 786:	e422                	sd	s0,8(sp)
 788:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 78a:	00054603          	lbu	a2,0(a0)
 78e:	fd06079b          	addiw	a5,a2,-48
 792:	0ff7f793          	andi	a5,a5,255
 796:	4725                	li	a4,9
 798:	02f76963          	bltu	a4,a5,7ca <atoi+0x46>
 79c:	86aa                	mv	a3,a0
    n = 0;
 79e:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 7a0:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 7a2:	0685                	addi	a3,a3,1
 7a4:	0025179b          	slliw	a5,a0,0x2
 7a8:	9fa9                	addw	a5,a5,a0
 7aa:	0017979b          	slliw	a5,a5,0x1
 7ae:	9fb1                	addw	a5,a5,a2
 7b0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 7b4:	0006c603          	lbu	a2,0(a3)
 7b8:	fd06071b          	addiw	a4,a2,-48
 7bc:	0ff77713          	andi	a4,a4,255
 7c0:	fee5f1e3          	bgeu	a1,a4,7a2 <atoi+0x1e>
    return n;
}
 7c4:	6422                	ld	s0,8(sp)
 7c6:	0141                	addi	sp,sp,16
 7c8:	8082                	ret
    n = 0;
 7ca:	4501                	li	a0,0
 7cc:	bfe5                	j	7c4 <atoi+0x40>

00000000000007ce <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 7ce:	1141                	addi	sp,sp,-16
 7d0:	e422                	sd	s0,8(sp)
 7d2:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 7d4:	02b57463          	bgeu	a0,a1,7fc <memmove+0x2e>
    {
        while (n-- > 0)
 7d8:	00c05f63          	blez	a2,7f6 <memmove+0x28>
 7dc:	1602                	slli	a2,a2,0x20
 7de:	9201                	srli	a2,a2,0x20
 7e0:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 7e4:	872a                	mv	a4,a0
            *dst++ = *src++;
 7e6:	0585                	addi	a1,a1,1
 7e8:	0705                	addi	a4,a4,1
 7ea:	fff5c683          	lbu	a3,-1(a1)
 7ee:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 7f2:	fee79ae3          	bne	a5,a4,7e6 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 7f6:	6422                	ld	s0,8(sp)
 7f8:	0141                	addi	sp,sp,16
 7fa:	8082                	ret
        dst += n;
 7fc:	00c50733          	add	a4,a0,a2
        src += n;
 800:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 802:	fec05ae3          	blez	a2,7f6 <memmove+0x28>
 806:	fff6079b          	addiw	a5,a2,-1
 80a:	1782                	slli	a5,a5,0x20
 80c:	9381                	srli	a5,a5,0x20
 80e:	fff7c793          	not	a5,a5
 812:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 814:	15fd                	addi	a1,a1,-1
 816:	177d                	addi	a4,a4,-1
 818:	0005c683          	lbu	a3,0(a1)
 81c:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 820:	fee79ae3          	bne	a5,a4,814 <memmove+0x46>
 824:	bfc9                	j	7f6 <memmove+0x28>

0000000000000826 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 826:	1141                	addi	sp,sp,-16
 828:	e422                	sd	s0,8(sp)
 82a:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 82c:	ca05                	beqz	a2,85c <memcmp+0x36>
 82e:	fff6069b          	addiw	a3,a2,-1
 832:	1682                	slli	a3,a3,0x20
 834:	9281                	srli	a3,a3,0x20
 836:	0685                	addi	a3,a3,1
 838:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 83a:	00054783          	lbu	a5,0(a0)
 83e:	0005c703          	lbu	a4,0(a1)
 842:	00e79863          	bne	a5,a4,852 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 846:	0505                	addi	a0,a0,1
        p2++;
 848:	0585                	addi	a1,a1,1
    while (n-- > 0)
 84a:	fed518e3          	bne	a0,a3,83a <memcmp+0x14>
    }
    return 0;
 84e:	4501                	li	a0,0
 850:	a019                	j	856 <memcmp+0x30>
            return *p1 - *p2;
 852:	40e7853b          	subw	a0,a5,a4
}
 856:	6422                	ld	s0,8(sp)
 858:	0141                	addi	sp,sp,16
 85a:	8082                	ret
    return 0;
 85c:	4501                	li	a0,0
 85e:	bfe5                	j	856 <memcmp+0x30>

0000000000000860 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 860:	1141                	addi	sp,sp,-16
 862:	e406                	sd	ra,8(sp)
 864:	e022                	sd	s0,0(sp)
 866:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 868:	00000097          	auipc	ra,0x0
 86c:	f66080e7          	jalr	-154(ra) # 7ce <memmove>
}
 870:	60a2                	ld	ra,8(sp)
 872:	6402                	ld	s0,0(sp)
 874:	0141                	addi	sp,sp,16
 876:	8082                	ret

0000000000000878 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 878:	4885                	li	a7,1
 ecall
 87a:	00000073          	ecall
 ret
 87e:	8082                	ret

0000000000000880 <exit>:
.global exit
exit:
 li a7, SYS_exit
 880:	4889                	li	a7,2
 ecall
 882:	00000073          	ecall
 ret
 886:	8082                	ret

0000000000000888 <wait>:
.global wait
wait:
 li a7, SYS_wait
 888:	488d                	li	a7,3
 ecall
 88a:	00000073          	ecall
 ret
 88e:	8082                	ret

0000000000000890 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 890:	4891                	li	a7,4
 ecall
 892:	00000073          	ecall
 ret
 896:	8082                	ret

0000000000000898 <read>:
.global read
read:
 li a7, SYS_read
 898:	4895                	li	a7,5
 ecall
 89a:	00000073          	ecall
 ret
 89e:	8082                	ret

00000000000008a0 <write>:
.global write
write:
 li a7, SYS_write
 8a0:	48c1                	li	a7,16
 ecall
 8a2:	00000073          	ecall
 ret
 8a6:	8082                	ret

00000000000008a8 <close>:
.global close
close:
 li a7, SYS_close
 8a8:	48d5                	li	a7,21
 ecall
 8aa:	00000073          	ecall
 ret
 8ae:	8082                	ret

00000000000008b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 8b0:	4899                	li	a7,6
 ecall
 8b2:	00000073          	ecall
 ret
 8b6:	8082                	ret

00000000000008b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 8b8:	489d                	li	a7,7
 ecall
 8ba:	00000073          	ecall
 ret
 8be:	8082                	ret

00000000000008c0 <open>:
.global open
open:
 li a7, SYS_open
 8c0:	48bd                	li	a7,15
 ecall
 8c2:	00000073          	ecall
 ret
 8c6:	8082                	ret

00000000000008c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 8c8:	48c5                	li	a7,17
 ecall
 8ca:	00000073          	ecall
 ret
 8ce:	8082                	ret

00000000000008d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 8d0:	48c9                	li	a7,18
 ecall
 8d2:	00000073          	ecall
 ret
 8d6:	8082                	ret

00000000000008d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 8d8:	48a1                	li	a7,8
 ecall
 8da:	00000073          	ecall
 ret
 8de:	8082                	ret

00000000000008e0 <link>:
.global link
link:
 li a7, SYS_link
 8e0:	48cd                	li	a7,19
 ecall
 8e2:	00000073          	ecall
 ret
 8e6:	8082                	ret

00000000000008e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 8e8:	48d1                	li	a7,20
 ecall
 8ea:	00000073          	ecall
 ret
 8ee:	8082                	ret

00000000000008f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 8f0:	48a5                	li	a7,9
 ecall
 8f2:	00000073          	ecall
 ret
 8f6:	8082                	ret

00000000000008f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 8f8:	48a9                	li	a7,10
 ecall
 8fa:	00000073          	ecall
 ret
 8fe:	8082                	ret

0000000000000900 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 900:	48ad                	li	a7,11
 ecall
 902:	00000073          	ecall
 ret
 906:	8082                	ret

0000000000000908 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 908:	48b1                	li	a7,12
 ecall
 90a:	00000073          	ecall
 ret
 90e:	8082                	ret

0000000000000910 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 910:	48b5                	li	a7,13
 ecall
 912:	00000073          	ecall
 ret
 916:	8082                	ret

0000000000000918 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 918:	48b9                	li	a7,14
 ecall
 91a:	00000073          	ecall
 ret
 91e:	8082                	ret

0000000000000920 <force_fail>:
.global force_fail
force_fail:
 li a7, SYS_force_fail
 920:	48d9                	li	a7,22
 ecall
 922:	00000073          	ecall
 ret
 926:	8082                	ret

0000000000000928 <get_force_fail>:
.global get_force_fail
get_force_fail:
 li a7, SYS_get_force_fail
 928:	48dd                	li	a7,23
 ecall
 92a:	00000073          	ecall
 ret
 92e:	8082                	ret

0000000000000930 <raw_read>:
.global raw_read
raw_read:
 li a7, SYS_raw_read
 930:	48e1                	li	a7,24
 ecall
 932:	00000073          	ecall
 ret
 936:	8082                	ret

0000000000000938 <get_disk_lbn>:
.global get_disk_lbn
get_disk_lbn:
 li a7, SYS_get_disk_lbn
 938:	48e5                	li	a7,25
 ecall
 93a:	00000073          	ecall
 ret
 93e:	8082                	ret

0000000000000940 <raw_write>:
.global raw_write
raw_write:
 li a7, SYS_raw_write
 940:	48e9                	li	a7,26
 ecall
 942:	00000073          	ecall
 ret
 946:	8082                	ret

0000000000000948 <force_disk_fail>:
.global force_disk_fail
force_disk_fail:
 li a7, SYS_force_disk_fail
 948:	48ed                	li	a7,27
 ecall
 94a:	00000073          	ecall
 ret
 94e:	8082                	ret

0000000000000950 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 950:	48f5                	li	a7,29
 ecall
 952:	00000073          	ecall
 ret
 956:	8082                	ret

0000000000000958 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 958:	48f1                	li	a7,28
 ecall
 95a:	00000073          	ecall
 ret
 95e:	8082                	ret

0000000000000960 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 960:	1101                	addi	sp,sp,-32
 962:	ec06                	sd	ra,24(sp)
 964:	e822                	sd	s0,16(sp)
 966:	1000                	addi	s0,sp,32
 968:	feb407a3          	sb	a1,-17(s0)
 96c:	4605                	li	a2,1
 96e:	fef40593          	addi	a1,s0,-17
 972:	00000097          	auipc	ra,0x0
 976:	f2e080e7          	jalr	-210(ra) # 8a0 <write>
 97a:	60e2                	ld	ra,24(sp)
 97c:	6442                	ld	s0,16(sp)
 97e:	6105                	addi	sp,sp,32
 980:	8082                	ret

0000000000000982 <printint>:

static void printint(int fd, int xx, int base, int sgn)
{
 982:	7139                	addi	sp,sp,-64
 984:	fc06                	sd	ra,56(sp)
 986:	f822                	sd	s0,48(sp)
 988:	f426                	sd	s1,40(sp)
 98a:	f04a                	sd	s2,32(sp)
 98c:	ec4e                	sd	s3,24(sp)
 98e:	0080                	addi	s0,sp,64
 990:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0)
 992:	c299                	beqz	a3,998 <printint+0x16>
 994:	0805c863          	bltz	a1,a24 <printint+0xa2>
        neg = 1;
        x = -xx;
    }
    else
    {
        x = xx;
 998:	2581                	sext.w	a1,a1
    neg = 0;
 99a:	4881                	li	a7,0
 99c:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 9a0:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
 9a2:	2601                	sext.w	a2,a2
 9a4:	00001517          	auipc	a0,0x1
 9a8:	b1c50513          	addi	a0,a0,-1252 # 14c0 <digits>
 9ac:	883a                	mv	a6,a4
 9ae:	2705                	addiw	a4,a4,1
 9b0:	02c5f7bb          	remuw	a5,a1,a2
 9b4:	1782                	slli	a5,a5,0x20
 9b6:	9381                	srli	a5,a5,0x20
 9b8:	97aa                	add	a5,a5,a0
 9ba:	0007c783          	lbu	a5,0(a5)
 9be:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 9c2:	0005879b          	sext.w	a5,a1
 9c6:	02c5d5bb          	divuw	a1,a1,a2
 9ca:	0685                	addi	a3,a3,1
 9cc:	fec7f0e3          	bgeu	a5,a2,9ac <printint+0x2a>
    if (neg)
 9d0:	00088b63          	beqz	a7,9e6 <printint+0x64>
        buf[i++] = '-';
 9d4:	fd040793          	addi	a5,s0,-48
 9d8:	973e                	add	a4,a4,a5
 9da:	02d00793          	li	a5,45
 9de:	fef70823          	sb	a5,-16(a4)
 9e2:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 9e6:	02e05863          	blez	a4,a16 <printint+0x94>
 9ea:	fc040793          	addi	a5,s0,-64
 9ee:	00e78933          	add	s2,a5,a4
 9f2:	fff78993          	addi	s3,a5,-1
 9f6:	99ba                	add	s3,s3,a4
 9f8:	377d                	addiw	a4,a4,-1
 9fa:	1702                	slli	a4,a4,0x20
 9fc:	9301                	srli	a4,a4,0x20
 9fe:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 a02:	fff94583          	lbu	a1,-1(s2)
 a06:	8526                	mv	a0,s1
 a08:	00000097          	auipc	ra,0x0
 a0c:	f58080e7          	jalr	-168(ra) # 960 <putc>
    while (--i >= 0)
 a10:	197d                	addi	s2,s2,-1
 a12:	ff3918e3          	bne	s2,s3,a02 <printint+0x80>
}
 a16:	70e2                	ld	ra,56(sp)
 a18:	7442                	ld	s0,48(sp)
 a1a:	74a2                	ld	s1,40(sp)
 a1c:	7902                	ld	s2,32(sp)
 a1e:	69e2                	ld	s3,24(sp)
 a20:	6121                	addi	sp,sp,64
 a22:	8082                	ret
        x = -xx;
 a24:	40b005bb          	negw	a1,a1
        neg = 1;
 a28:	4885                	li	a7,1
        x = -xx;
 a2a:	bf8d                	j	99c <printint+0x1a>

0000000000000a2c <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 a2c:	7119                	addi	sp,sp,-128
 a2e:	fc86                	sd	ra,120(sp)
 a30:	f8a2                	sd	s0,112(sp)
 a32:	f4a6                	sd	s1,104(sp)
 a34:	f0ca                	sd	s2,96(sp)
 a36:	ecce                	sd	s3,88(sp)
 a38:	e8d2                	sd	s4,80(sp)
 a3a:	e4d6                	sd	s5,72(sp)
 a3c:	e0da                	sd	s6,64(sp)
 a3e:	fc5e                	sd	s7,56(sp)
 a40:	f862                	sd	s8,48(sp)
 a42:	f466                	sd	s9,40(sp)
 a44:	f06a                	sd	s10,32(sp)
 a46:	ec6e                	sd	s11,24(sp)
 a48:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++)
 a4a:	0005c903          	lbu	s2,0(a1)
 a4e:	18090f63          	beqz	s2,bec <vprintf+0x1c0>
 a52:	8aaa                	mv	s5,a0
 a54:	8b32                	mv	s6,a2
 a56:	00158493          	addi	s1,a1,1
    state = 0;
 a5a:	4981                	li	s3,0
            else
            {
                putc(fd, c);
            }
        }
        else if (state == '%')
 a5c:	02500a13          	li	s4,37
        {
            if (c == 'd')
 a60:	06400c13          	li	s8,100
            {
                printint(fd, va_arg(ap, int), 10, 1);
            }
            else if (c == 'l')
 a64:	06c00c93          	li	s9,108
            {
                printint(fd, va_arg(ap, uint64), 10, 0);
            }
            else if (c == 'x')
 a68:	07800d13          	li	s10,120
            {
                printint(fd, va_arg(ap, int), 16, 0);
            }
            else if (c == 'p')
 a6c:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a70:	00001b97          	auipc	s7,0x1
 a74:	a50b8b93          	addi	s7,s7,-1456 # 14c0 <digits>
 a78:	a839                	j	a96 <vprintf+0x6a>
                putc(fd, c);
 a7a:	85ca                	mv	a1,s2
 a7c:	8556                	mv	a0,s5
 a7e:	00000097          	auipc	ra,0x0
 a82:	ee2080e7          	jalr	-286(ra) # 960 <putc>
 a86:	a019                	j	a8c <vprintf+0x60>
        else if (state == '%')
 a88:	01498f63          	beq	s3,s4,aa6 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++)
 a8c:	0485                	addi	s1,s1,1
 a8e:	fff4c903          	lbu	s2,-1(s1)
 a92:	14090d63          	beqz	s2,bec <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 a96:	0009079b          	sext.w	a5,s2
        if (state == 0)
 a9a:	fe0997e3          	bnez	s3,a88 <vprintf+0x5c>
            if (c == '%')
 a9e:	fd479ee3          	bne	a5,s4,a7a <vprintf+0x4e>
                state = '%';
 aa2:	89be                	mv	s3,a5
 aa4:	b7e5                	j	a8c <vprintf+0x60>
            if (c == 'd')
 aa6:	05878063          	beq	a5,s8,ae6 <vprintf+0xba>
            else if (c == 'l')
 aaa:	05978c63          	beq	a5,s9,b02 <vprintf+0xd6>
            else if (c == 'x')
 aae:	07a78863          	beq	a5,s10,b1e <vprintf+0xf2>
            else if (c == 'p')
 ab2:	09b78463          	beq	a5,s11,b3a <vprintf+0x10e>
            {
                printptr(fd, va_arg(ap, uint64));
            }
            else if (c == 's')
 ab6:	07300713          	li	a4,115
 aba:	0ce78663          	beq	a5,a4,b86 <vprintf+0x15a>
                {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c')
 abe:	06300713          	li	a4,99
 ac2:	0ee78e63          	beq	a5,a4,bbe <vprintf+0x192>
            {
                putc(fd, va_arg(ap, uint));
            }
            else if (c == '%')
 ac6:	11478863          	beq	a5,s4,bd6 <vprintf+0x1aa>
                putc(fd, c);
            }
            else
            {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 aca:	85d2                	mv	a1,s4
 acc:	8556                	mv	a0,s5
 ace:	00000097          	auipc	ra,0x0
 ad2:	e92080e7          	jalr	-366(ra) # 960 <putc>
                putc(fd, c);
 ad6:	85ca                	mv	a1,s2
 ad8:	8556                	mv	a0,s5
 ada:	00000097          	auipc	ra,0x0
 ade:	e86080e7          	jalr	-378(ra) # 960 <putc>
            }
            state = 0;
 ae2:	4981                	li	s3,0
 ae4:	b765                	j	a8c <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 ae6:	008b0913          	addi	s2,s6,8
 aea:	4685                	li	a3,1
 aec:	4629                	li	a2,10
 aee:	000b2583          	lw	a1,0(s6)
 af2:	8556                	mv	a0,s5
 af4:	00000097          	auipc	ra,0x0
 af8:	e8e080e7          	jalr	-370(ra) # 982 <printint>
 afc:	8b4a                	mv	s6,s2
            state = 0;
 afe:	4981                	li	s3,0
 b00:	b771                	j	a8c <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 b02:	008b0913          	addi	s2,s6,8
 b06:	4681                	li	a3,0
 b08:	4629                	li	a2,10
 b0a:	000b2583          	lw	a1,0(s6)
 b0e:	8556                	mv	a0,s5
 b10:	00000097          	auipc	ra,0x0
 b14:	e72080e7          	jalr	-398(ra) # 982 <printint>
 b18:	8b4a                	mv	s6,s2
            state = 0;
 b1a:	4981                	li	s3,0
 b1c:	bf85                	j	a8c <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 b1e:	008b0913          	addi	s2,s6,8
 b22:	4681                	li	a3,0
 b24:	4641                	li	a2,16
 b26:	000b2583          	lw	a1,0(s6)
 b2a:	8556                	mv	a0,s5
 b2c:	00000097          	auipc	ra,0x0
 b30:	e56080e7          	jalr	-426(ra) # 982 <printint>
 b34:	8b4a                	mv	s6,s2
            state = 0;
 b36:	4981                	li	s3,0
 b38:	bf91                	j	a8c <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 b3a:	008b0793          	addi	a5,s6,8
 b3e:	f8f43423          	sd	a5,-120(s0)
 b42:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 b46:	03000593          	li	a1,48
 b4a:	8556                	mv	a0,s5
 b4c:	00000097          	auipc	ra,0x0
 b50:	e14080e7          	jalr	-492(ra) # 960 <putc>
    putc(fd, 'x');
 b54:	85ea                	mv	a1,s10
 b56:	8556                	mv	a0,s5
 b58:	00000097          	auipc	ra,0x0
 b5c:	e08080e7          	jalr	-504(ra) # 960 <putc>
 b60:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b62:	03c9d793          	srli	a5,s3,0x3c
 b66:	97de                	add	a5,a5,s7
 b68:	0007c583          	lbu	a1,0(a5)
 b6c:	8556                	mv	a0,s5
 b6e:	00000097          	auipc	ra,0x0
 b72:	df2080e7          	jalr	-526(ra) # 960 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b76:	0992                	slli	s3,s3,0x4
 b78:	397d                	addiw	s2,s2,-1
 b7a:	fe0914e3          	bnez	s2,b62 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 b7e:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 b82:	4981                	li	s3,0
 b84:	b721                	j	a8c <vprintf+0x60>
                s = va_arg(ap, char *);
 b86:	008b0993          	addi	s3,s6,8
 b8a:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 b8e:	02090163          	beqz	s2,bb0 <vprintf+0x184>
                while (*s != 0)
 b92:	00094583          	lbu	a1,0(s2)
 b96:	c9a1                	beqz	a1,be6 <vprintf+0x1ba>
                    putc(fd, *s);
 b98:	8556                	mv	a0,s5
 b9a:	00000097          	auipc	ra,0x0
 b9e:	dc6080e7          	jalr	-570(ra) # 960 <putc>
                    s++;
 ba2:	0905                	addi	s2,s2,1
                while (*s != 0)
 ba4:	00094583          	lbu	a1,0(s2)
 ba8:	f9e5                	bnez	a1,b98 <vprintf+0x16c>
                s = va_arg(ap, char *);
 baa:	8b4e                	mv	s6,s3
            state = 0;
 bac:	4981                	li	s3,0
 bae:	bdf9                	j	a8c <vprintf+0x60>
                    s = "(null)";
 bb0:	00001917          	auipc	s2,0x1
 bb4:	90890913          	addi	s2,s2,-1784 # 14b8 <malloc+0x7c2>
                while (*s != 0)
 bb8:	02800593          	li	a1,40
 bbc:	bff1                	j	b98 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 bbe:	008b0913          	addi	s2,s6,8
 bc2:	000b4583          	lbu	a1,0(s6)
 bc6:	8556                	mv	a0,s5
 bc8:	00000097          	auipc	ra,0x0
 bcc:	d98080e7          	jalr	-616(ra) # 960 <putc>
 bd0:	8b4a                	mv	s6,s2
            state = 0;
 bd2:	4981                	li	s3,0
 bd4:	bd65                	j	a8c <vprintf+0x60>
                putc(fd, c);
 bd6:	85d2                	mv	a1,s4
 bd8:	8556                	mv	a0,s5
 bda:	00000097          	auipc	ra,0x0
 bde:	d86080e7          	jalr	-634(ra) # 960 <putc>
            state = 0;
 be2:	4981                	li	s3,0
 be4:	b565                	j	a8c <vprintf+0x60>
                s = va_arg(ap, char *);
 be6:	8b4e                	mv	s6,s3
            state = 0;
 be8:	4981                	li	s3,0
 bea:	b54d                	j	a8c <vprintf+0x60>
        }
    }
}
 bec:	70e6                	ld	ra,120(sp)
 bee:	7446                	ld	s0,112(sp)
 bf0:	74a6                	ld	s1,104(sp)
 bf2:	7906                	ld	s2,96(sp)
 bf4:	69e6                	ld	s3,88(sp)
 bf6:	6a46                	ld	s4,80(sp)
 bf8:	6aa6                	ld	s5,72(sp)
 bfa:	6b06                	ld	s6,64(sp)
 bfc:	7be2                	ld	s7,56(sp)
 bfe:	7c42                	ld	s8,48(sp)
 c00:	7ca2                	ld	s9,40(sp)
 c02:	7d02                	ld	s10,32(sp)
 c04:	6de2                	ld	s11,24(sp)
 c06:	6109                	addi	sp,sp,128
 c08:	8082                	ret

0000000000000c0a <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 c0a:	715d                	addi	sp,sp,-80
 c0c:	ec06                	sd	ra,24(sp)
 c0e:	e822                	sd	s0,16(sp)
 c10:	1000                	addi	s0,sp,32
 c12:	e010                	sd	a2,0(s0)
 c14:	e414                	sd	a3,8(s0)
 c16:	e818                	sd	a4,16(s0)
 c18:	ec1c                	sd	a5,24(s0)
 c1a:	03043023          	sd	a6,32(s0)
 c1e:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 c22:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 c26:	8622                	mv	a2,s0
 c28:	00000097          	auipc	ra,0x0
 c2c:	e04080e7          	jalr	-508(ra) # a2c <vprintf>
}
 c30:	60e2                	ld	ra,24(sp)
 c32:	6442                	ld	s0,16(sp)
 c34:	6161                	addi	sp,sp,80
 c36:	8082                	ret

0000000000000c38 <printf>:

void printf(const char *fmt, ...)
{
 c38:	711d                	addi	sp,sp,-96
 c3a:	ec06                	sd	ra,24(sp)
 c3c:	e822                	sd	s0,16(sp)
 c3e:	1000                	addi	s0,sp,32
 c40:	e40c                	sd	a1,8(s0)
 c42:	e810                	sd	a2,16(s0)
 c44:	ec14                	sd	a3,24(s0)
 c46:	f018                	sd	a4,32(s0)
 c48:	f41c                	sd	a5,40(s0)
 c4a:	03043823          	sd	a6,48(s0)
 c4e:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 c52:	00840613          	addi	a2,s0,8
 c56:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 c5a:	85aa                	mv	a1,a0
 c5c:	4505                	li	a0,1
 c5e:	00000097          	auipc	ra,0x0
 c62:	dce080e7          	jalr	-562(ra) # a2c <vprintf>
}
 c66:	60e2                	ld	ra,24(sp)
 c68:	6442                	ld	s0,16(sp)
 c6a:	6125                	addi	sp,sp,96
 c6c:	8082                	ret

0000000000000c6e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 c6e:	1141                	addi	sp,sp,-16
 c70:	e422                	sd	s0,8(sp)
 c72:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 c74:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c78:	00001797          	auipc	a5,0x1
 c7c:	8607b783          	ld	a5,-1952(a5) # 14d8 <freep>
 c80:	a805                	j	cb0 <free+0x42>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 c82:	4618                	lw	a4,8(a2)
 c84:	9db9                	addw	a1,a1,a4
 c86:	feb52c23          	sw	a1,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 c8a:	6398                	ld	a4,0(a5)
 c8c:	6318                	ld	a4,0(a4)
 c8e:	fee53823          	sd	a4,-16(a0)
 c92:	a091                	j	cd6 <free+0x68>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 c94:	ff852703          	lw	a4,-8(a0)
 c98:	9e39                	addw	a2,a2,a4
 c9a:	c790                	sw	a2,8(a5)
        p->s.ptr = bp->s.ptr;
 c9c:	ff053703          	ld	a4,-16(a0)
 ca0:	e398                	sd	a4,0(a5)
 ca2:	a099                	j	ce8 <free+0x7a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ca4:	6398                	ld	a4,0(a5)
 ca6:	00e7e463          	bltu	a5,a4,cae <free+0x40>
 caa:	00e6ea63          	bltu	a3,a4,cbe <free+0x50>
{
 cae:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb0:	fed7fae3          	bgeu	a5,a3,ca4 <free+0x36>
 cb4:	6398                	ld	a4,0(a5)
 cb6:	00e6e463          	bltu	a3,a4,cbe <free+0x50>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cba:	fee7eae3          	bltu	a5,a4,cae <free+0x40>
    if (bp + bp->s.size == p->s.ptr)
 cbe:	ff852583          	lw	a1,-8(a0)
 cc2:	6390                	ld	a2,0(a5)
 cc4:	02059713          	slli	a4,a1,0x20
 cc8:	9301                	srli	a4,a4,0x20
 cca:	0712                	slli	a4,a4,0x4
 ccc:	9736                	add	a4,a4,a3
 cce:	fae60ae3          	beq	a2,a4,c82 <free+0x14>
        bp->s.ptr = p->s.ptr;
 cd2:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 cd6:	4790                	lw	a2,8(a5)
 cd8:	02061713          	slli	a4,a2,0x20
 cdc:	9301                	srli	a4,a4,0x20
 cde:	0712                	slli	a4,a4,0x4
 ce0:	973e                	add	a4,a4,a5
 ce2:	fae689e3          	beq	a3,a4,c94 <free+0x26>
    }
    else
        p->s.ptr = bp;
 ce6:	e394                	sd	a3,0(a5)
    freep = p;
 ce8:	00000717          	auipc	a4,0x0
 cec:	7ef73823          	sd	a5,2032(a4) # 14d8 <freep>
}
 cf0:	6422                	ld	s0,8(sp)
 cf2:	0141                	addi	sp,sp,16
 cf4:	8082                	ret

0000000000000cf6 <malloc>:
    free((void *)(hp + 1));
    return freep;
}

void *malloc(uint nbytes)
{
 cf6:	7139                	addi	sp,sp,-64
 cf8:	fc06                	sd	ra,56(sp)
 cfa:	f822                	sd	s0,48(sp)
 cfc:	f426                	sd	s1,40(sp)
 cfe:	f04a                	sd	s2,32(sp)
 d00:	ec4e                	sd	s3,24(sp)
 d02:	e852                	sd	s4,16(sp)
 d04:	e456                	sd	s5,8(sp)
 d06:	e05a                	sd	s6,0(sp)
 d08:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 d0a:	02051493          	slli	s1,a0,0x20
 d0e:	9081                	srli	s1,s1,0x20
 d10:	04bd                	addi	s1,s1,15
 d12:	8091                	srli	s1,s1,0x4
 d14:	0014899b          	addiw	s3,s1,1
 d18:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 d1a:	00000517          	auipc	a0,0x0
 d1e:	7be53503          	ld	a0,1982(a0) # 14d8 <freep>
 d22:	c515                	beqz	a0,d4e <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 d24:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 d26:	4798                	lw	a4,8(a5)
 d28:	02977f63          	bgeu	a4,s1,d66 <malloc+0x70>
 d2c:	8a4e                	mv	s4,s3
 d2e:	0009871b          	sext.w	a4,s3
 d32:	6685                	lui	a3,0x1
 d34:	00d77363          	bgeu	a4,a3,d3a <malloc+0x44>
 d38:	6a05                	lui	s4,0x1
 d3a:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 d3e:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 d42:	00000917          	auipc	s2,0x0
 d46:	79690913          	addi	s2,s2,1942 # 14d8 <freep>
    if (p == (char *)-1)
 d4a:	5afd                	li	s5,-1
 d4c:	a88d                	j	dbe <malloc+0xc8>
        base.s.ptr = freep = prevp = &base;
 d4e:	00002797          	auipc	a5,0x2
 d52:	f9278793          	addi	a5,a5,-110 # 2ce0 <base>
 d56:	00000717          	auipc	a4,0x0
 d5a:	78f73123          	sd	a5,1922(a4) # 14d8 <freep>
 d5e:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 d60:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 d64:	b7e1                	j	d2c <malloc+0x36>
            if (p->s.size == nunits)
 d66:	02e48b63          	beq	s1,a4,d9c <malloc+0xa6>
                p->s.size -= nunits;
 d6a:	4137073b          	subw	a4,a4,s3
 d6e:	c798                	sw	a4,8(a5)
                p += p->s.size;
 d70:	1702                	slli	a4,a4,0x20
 d72:	9301                	srli	a4,a4,0x20
 d74:	0712                	slli	a4,a4,0x4
 d76:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 d78:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 d7c:	00000717          	auipc	a4,0x0
 d80:	74a73e23          	sd	a0,1884(a4) # 14d8 <freep>
            return (void *)(p + 1);
 d84:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 d88:	70e2                	ld	ra,56(sp)
 d8a:	7442                	ld	s0,48(sp)
 d8c:	74a2                	ld	s1,40(sp)
 d8e:	7902                	ld	s2,32(sp)
 d90:	69e2                	ld	s3,24(sp)
 d92:	6a42                	ld	s4,16(sp)
 d94:	6aa2                	ld	s5,8(sp)
 d96:	6b02                	ld	s6,0(sp)
 d98:	6121                	addi	sp,sp,64
 d9a:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 d9c:	6398                	ld	a4,0(a5)
 d9e:	e118                	sd	a4,0(a0)
 da0:	bff1                	j	d7c <malloc+0x86>
    hp->s.size = nu;
 da2:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 da6:	0541                	addi	a0,a0,16
 da8:	00000097          	auipc	ra,0x0
 dac:	ec6080e7          	jalr	-314(ra) # c6e <free>
    return freep;
 db0:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 db4:	d971                	beqz	a0,d88 <malloc+0x92>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 db6:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 db8:	4798                	lw	a4,8(a5)
 dba:	fa9776e3          	bgeu	a4,s1,d66 <malloc+0x70>
        if (p == freep)
 dbe:	00093703          	ld	a4,0(s2)
 dc2:	853e                	mv	a0,a5
 dc4:	fef719e3          	bne	a4,a5,db6 <malloc+0xc0>
    p = sbrk(nu * sizeof(Header));
 dc8:	8552                	mv	a0,s4
 dca:	00000097          	auipc	ra,0x0
 dce:	b3e080e7          	jalr	-1218(ra) # 908 <sbrk>
    if (p == (char *)-1)
 dd2:	fd5518e3          	bne	a0,s5,da2 <malloc+0xac>
                return 0;
 dd6:	4501                	li	a0,0
 dd8:	bf45                	j	d88 <malloc+0x92>
