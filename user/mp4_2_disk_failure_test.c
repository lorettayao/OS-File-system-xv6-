#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define BSIZE 1024
#define LOGICAL_DISK_SIZE 2048
#define DISK1_START_BLOCK 2048

char initial_data[BSIZE];
char pbn0_corrupted_data[BSIZE];
char read_buf[BSIZE];
char raw_read_buf1[BSIZE];
char raw_read_buf2[BSIZE];
char dummy_buf[BSIZE];

void fill_data(char *buf, int lbn_for_pattern, char pattern_char)
{
    memset(buf, pattern_char, BSIZE);
    buf[0] = (char)lbn_for_pattern;
}

int compare_buffers(const char *buf1, const char *buf2, int size,
                    const char *context_msg)
{
    if (memcmp(buf1, buf2, size) != 0)
    {
        printf("  ERROR: Data Mismatch! Context: %s\n", context_msg);
        printf("    Buf1 (Hex, first 16): ");
        for (int k = 0; k < 16; k++)
            printf("%x ", (unsigned char)buf1[k]);
        printf("\n");
        printf("    Buf2 (Hex, first 16): ");
        for (int k = 0; k < 16; k++)
            printf("%x ", (unsigned char)buf2[k]);
        printf("\n");
        return -1;
    }
    printf("  Data Compare OK. Context: %s\n", context_msg);
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
    int fd_write, fd_read;
    int file_lbn_to_test = 1;
    int disk_lbn = -1, pbn0 = -1, pbn1 = -1;
    int overall_pass = 1;

    char initial_pattern = 'S';
    char corrupt_pattern = 'X';

    printf("=== Combined RAID 1 Mirroring and Fallback Test ===\n");
    printf("Target File LBN: %d\n\n", file_lbn_to_test);

    fill_data(initial_data, file_lbn_to_test, initial_pattern);
    fill_data(pbn0_corrupted_data, file_lbn_to_test, corrupt_pattern);
    fill_data(dummy_buf, 0, '.');

    printf(
        "--- Phase 1: Initial Write (Pattern '%c') & Mirror Verification ---\n",
        initial_pattern);
    force_disk_fail(-1);
    fd_write = open("combined_test.dat", O_CREATE | O_RDWR | O_TRUNC);
    if (fd_write < 0)
    {
        printf("ERROR: Cannot create file\n");
        exit(1);
    }

    for (int i = 0; i <= file_lbn_to_test; i++)
    {
        if (write(fd_write, (i == file_lbn_to_test ? initial_data : dummy_buf),
                  BSIZE) != BSIZE)
        {
            printf("ERROR writing in Phase 1\n");
            close(fd_write);
            exit(1);
        }
    }
    disk_lbn = get_disk_lbn(fd_write, file_lbn_to_test);
    if (disk_lbn <= 0)
    {
        printf("ERROR: get_disk_lbn failed\n");
        close(fd_write);
        exit(1);
    }
    pbn0 = disk_lbn;
    pbn1 = disk_lbn + DISK1_START_BLOCK;
    printf("  File LBN %d mapped to Disk LBN %d (PBN0=%d, PBN1=%d).\n",
           file_lbn_to_test, disk_lbn, pbn0, pbn1);
    close(fd_write);
    printf("  Waiting for commit...\n");
    sleep(100);

    printf("  Verifying initial mirror state (Criterion 1):\n");
    if (read_physical_block_wrapper(pbn0, raw_read_buf1, "Initial PBN0") != 0)
        overall_pass = 0;
    if (read_physical_block_wrapper(pbn1, raw_read_buf2, "Initial PBN1") != 0)
        overall_pass = 0;

    if (overall_pass)
    {
        if (compare_buffers(initial_data, raw_read_buf1, BSIZE,
                            "Initial Data vs PBN0 Content") != 0)
            overall_pass = 0;
        if (compare_buffers(initial_data, raw_read_buf2, BSIZE,
                            "Initial Data vs PBN1 Content") != 0)
            overall_pass = 0;
        if (compare_buffers(raw_read_buf1, raw_read_buf2, BSIZE,
                            "PBN0 Content vs PBN1 Content") != 0)
            overall_pass = 0;
    }
    if (!overall_pass)
    {
        printf("  Phase 1 FAILED: Initial mirroring was not correct.\n");
        exit(1);
    }
    printf("  Phase 1: Initial mirroring verified PASSED.\n\n");

    printf("--- Phase 3: Simulating Disk 0 Read Failure & Testing Fallback "
           "(Criterion 3) ---\n");
    if (force_disk_fail(0) < 0)
    {
        printf("  ERROR: force_disk_fail(0) failed!\n");
        exit(1);
    }

    fd_read = open("combined_test.dat", O_RDONLY);
    if (fd_read < 0)
    {
        printf("  ERROR: Failed to open file for fallback read!\n");
        force_disk_fail(-1);
        exit(1);
    }

    for (int i = 0; i < file_lbn_to_test; i++)
    {
        if (read(fd_read, dummy_buf, BSIZE) != BSIZE)
        {
            printf(
                "  ERROR: Failed to read dummy block %d to reach target LBN!\n",
                i);
            close(fd_read);
            force_disk_fail(-1);
            exit(1);
        }
    }
    printf("  Calling standard read() for File LBN %d (should fallback to PBN1 "
           "which has '%c')...\n",
           file_lbn_to_test, initial_pattern);
    if (read(fd_read, read_buf, BSIZE) != BSIZE)
    {
        printf("  ERROR: Standard read() failed for File LBN %d during "
               "fallback test!\n",
               file_lbn_to_test);
        overall_pass = 0;
    }
    close(fd_read);

    printf("  Calling force_disk_fail(-1) to disable simulation...\n");
    force_disk_fail(-1);

    if (overall_pass)
    {
        if (compare_buffers(
                initial_data, read_buf, BSIZE,
                "Expected Initial Data (from PBN1) vs Actual Read Data") == 0)
        {
            printf("  Phase 2: Read Fallback Test PASSED (Correctly read "
                   "initial data from Disk 1).\n");
        }
        else
        {
            printf("  Phase 2: Read Fallback Test FAILED (Data mismatch).\n");
            overall_pass = 0;
        }
    }
    else
    {
        printf("  Phase 2: Read Fallback Test FAILED (Read operation itself "
               "failed).\n");
    }

    printf("\n=== Combined RAID Test Summary ===\n");
    if (overall_pass)
    {
        printf("Bread Disk Failure Fallback Test: PASS\n");
    }
    else
    {
        printf("One or more critical checks FAILED!\n");
    }

    exit(overall_pass ? 0 : 1);
    return 0;
}