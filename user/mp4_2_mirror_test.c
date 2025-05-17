#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define BSIZE 1024
#define LOGICAL_DISK_SIZE 2048
#define DISK1_START_BLOCK 2048
#define NUM_TEST_BLOCKS 3

char data_to_write[BSIZE];
char pbn0_content[BSIZE];
char pbn1_content[BSIZE];
char expected_data[BSIZE];

void fill_data(char *buf, int lbn, char pattern_char)
{
    memset(buf, pattern_char, BSIZE);
    buf[0] = (char)lbn;
}

int compare_buffers(const char *buf1, const char *buf2, int size,
                    const char *context_msg)
{
    if (memcmp(buf1, buf2, size) != 0)
    {
        printf("  ERROR: Data Mismatch! Context: %s\n", context_msg);
        return -1;
    }
    return 0;
}

int read_physical_block_wrapper(int pbn, char *buf, const char *context_msg)
{
    printf("  Attempting raw_read for PBN %d (%s)...\n", pbn, context_msg);
    int ret = raw_read(pbn, buf);
    if (ret < 0)
    {
        printf("  ERROR: raw_read failed for PBN %d (%s)!\n", pbn, context_msg);
        return -1;
    }
    return 0;
}

int main()
{
    int fd_write;
    int lbn;
    int pass_mirroring = 1;
    int disk_lbns[NUM_TEST_BLOCKS];

    printf("=== RAID 1 Mirroring Verification Test (Criterion 1) ===\n");
    printf("Testing with %d sequential file logical blocks (LBN 0 to %d).\n",
           NUM_TEST_BLOCKS, NUM_TEST_BLOCKS - 1);

    printf("--- Phase 1: Writing data sequentially and getting mapping ---\n");
    fd_write = open("mirror_consistency.dat", O_CREATE | O_RDWR | O_TRUNC);
    if (fd_write < 0)
        exit(1);
    for (lbn = 0; lbn < NUM_TEST_BLOCKS; lbn++)
    {
        char pattern = 'A' + lbn;
        fill_data(data_to_write, lbn, pattern);
        printf("  Writing File LBN %d pattern '%c'\n", lbn, pattern);
        if (write(fd_write, data_to_write, BSIZE) != BSIZE)
        {
            close(fd_write);
            exit(1);
        }
        disk_lbns[lbn] = get_disk_lbn(fd_write, lbn);
        if (disk_lbns[lbn] <= 0)
        {
            close(fd_write);
            exit(1);
        }
        printf("    File LBN %d mapped to Disk LBN %d.\n", lbn, disk_lbns[lbn]);
    }
    close(fd_write);
    printf("Phase 1: Completed.\n\n");

    printf("--- Phase 2: Verifying write mirroring (Criterion 1) ---\n");
    for (lbn = 0; lbn < NUM_TEST_BLOCKS; lbn++)
    {
        char pattern = 'A' + lbn;
        int disk_lbn = disk_lbns[lbn];
        int pbn0 = disk_lbn;
        int pbn1 = disk_lbn + DISK1_START_BLOCK;
        int pass_current = 1;

        fill_data(expected_data, lbn, pattern);
        printf("  Verifying LBN %d (Disk LBN %d, Pattern '%c'):\n", lbn,
               disk_lbn, pattern);

        if (read_physical_block_wrapper(pbn0, pbn0_content, "Disk 0 copy") != 0)
        {
            pass_current = 0;
        }
        if (read_physical_block_wrapper(pbn1, pbn1_content, "Disk 1 copy") != 0)
        {
            pass_current = 0;
        }

        if (pass_current)
        {
            if (compare_buffers(expected_data, pbn0_content, BSIZE,
                                "Expected vs PBN0") != 0)
            {
                pass_current = 0;
            }
            if (compare_buffers(expected_data, pbn1_content, BSIZE,
                                "Expected vs PBN1") != 0)
            {
                pass_current = 0;
            }
            if (compare_buffers(pbn0_content, pbn1_content, BSIZE,
                                "PBN0 vs PBN1") != 0)
            {
                pass_current = 0;
            }
        }

        if (pass_current)
        {
            printf("    LBN %d - Write Mirroring Check: PASSED\n", lbn);
        }
        else
        {
            printf("    LBN %d - Write Mirroring Check: FAILED\n", lbn);
            pass_mirroring = 0;
        }
    }
    printf("Phase 2: Completed.\n\n");

    printf("\n=== Final Mirroring Test Summary ===\n");
    printf("Bwrite Mirroring Test: %s\n", pass_mirroring ? "PASS" : "FAIL");
    printf("(Consistency (Criterion 2) is implicitly checked if Mirroring and "
           "Fallback tests pass)\n");
    printf("(Run mp4_2_fallback_test for Criterion 3)\n");

    exit(pass_mirroring ? 0 : 1);

    return 0;
}