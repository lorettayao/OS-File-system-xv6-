#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define BSIZE 1024
#define TEST_FILE_LBN 1

char test_data_buffer[BSIZE];
char dummy_buffer[BSIZE];

void fill_data_for_test(char *buf, int marker_val, char fill_pattern)
{
    memset(buf, fill_pattern, BSIZE);
    buf[0] = (char)marker_val;
}

int main(int argc, char *argv[])
{
    int fd;
    int pbn0_for_test_lbn = -1;

    if (argc < 2)
    {
        fprintf(2, "Usage: %s <scenario_num>\n", argv[0]);
        fprintf(2, "Scenarios:\n");
        fprintf(2, "  0: Normal Write (no failures simulated)\n");
        fprintf(2, "  1: Simulate Disk 0 Failure for write\n");
        exit(1);
    }

    int scenario = atoi(argv[1]);
    fill_data_for_test(test_data_buffer, TEST_FILE_LBN, 'W');
    fill_data_for_test(dummy_buffer, 0, '.');

    printf("TEST_DRIVER: Phase 0 - Setting up file and getting PBN for File "
           "LBN %d.\n",
           TEST_FILE_LBN);
    force_disk_fail(-1);
    force_fail(-1);

    fd = open("raid1_sim_target.dat", O_CREATE | O_RDWR | O_TRUNC);
    if (fd < 0)
    {
        printf("TEST_DRIVER_ERROR: Cannot create/open file "
               "'raid1_sim_target.dat' in Phase 0\n");
        exit(1);
    }

    for (int i = 0; i < TEST_FILE_LBN; i++)
    {
        if (write(fd, dummy_buffer, BSIZE) != BSIZE)
        {
            printf("TEST_DRIVER_ERROR: Failed to write dummy block %d in Phase "
                   "0\n",
                   i);
            close(fd);
            exit(1);
        }
    }
    if (write(fd, dummy_buffer, BSIZE) != BSIZE)
    {
        printf("TEST_DRIVER_ERROR: Failed to write target LBN placeholder in "
               "Phase 0\n");
        close(fd);
        exit(1);
    }

    pbn0_for_test_lbn = get_disk_lbn(fd, TEST_FILE_LBN);
    if (pbn0_for_test_lbn <= 0)
    {
        printf("TEST_DRIVER_ERROR: get_disk_lbn failed or returned invalid "
               "PBN0 %d for File LBN %d in Phase 0\n",
               pbn0_for_test_lbn, TEST_FILE_LBN);
        close(fd);
        exit(1);
    }
    close(fd);
    printf("TEST_DRIVER_INFO: File LBN %d is mapped to Disk LBN (PBN0) %d.\n",
           TEST_FILE_LBN, pbn0_for_test_lbn);
    printf("TEST_DRIVER: Phase 0 - Setup complete.\n\n");

    switch (scenario)
    {
    case 0:
        printf("TEST_DRIVER: Scenario 0 - Normal Write.\n");
        force_disk_fail(-1);
        force_fail(-1);
        break;
    case 1:
        printf("TEST_DRIVER: Scenario 1 - Simulating Disk 0 Failure.\n");
        force_disk_fail(0);
        force_fail(-1);
        break;
    default:
        fprintf(2, "TEST_DRIVER_ERROR: Unknown scenario %d\n", scenario);
        exit(1);
    }

    printf("TEST_DRIVER: Issuing standard write to File LBN %d.\n",
           TEST_FILE_LBN);
    fd = open("raid1_sim_target.dat", O_RDWR);
    if (fd < 0)
    {
        printf("TEST_DRIVER_ERROR: Failed to open file for test write.\n");
        force_disk_fail(-1);
        force_fail(-1);
        exit(1);
    }
    for (int i = 0; i < TEST_FILE_LBN; i++)
        read(fd, dummy_buffer, BSIZE);
    if (write(fd, test_data_buffer, BSIZE) != BSIZE)
    {
        printf("TEST_DRIVER_ERROR: Failed to 'seek' by reading dummy block.\n");
        close(fd);
        force_disk_fail(-1);
        force_fail(-1);
        exit(1);
    }
    close(fd);

    printf("TEST_DRIVER: Test write issued. Calling sync().\n");
    force_disk_fail(-1);
    force_fail(-1);
    printf("TEST_DRIVER: Scenario %d finished. Check kernel output.\n",
           scenario);
    exit(0);
}