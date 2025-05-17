#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int pbn_to_fail;
    int ret;

    if (argc != 2)
    {
        fprintf(2, "Usage: mp4_2_forcetest <pbn_or_-1>\n");
        exit(1);
    }

    if (argv[1][0] == '-' && argv[1][1] == '1')
        pbn_to_fail = -1;
    else
        pbn_to_fail = atoi(argv[1]);

    printf("Calling force_fail(%d)...\n", pbn_to_fail);

    ret = force_fail(pbn_to_fail);

    if (ret == 0)
    {
        printf("force_fail(%d) succeeded.\n", pbn_to_fail);

        int current_val = get_force_fail();
        printf("Current force_read_error_pbn = %d\n", current_val);

        if (current_val == pbn_to_fail)
        {
            printf("Verification PASSED: Kernel variable matches set value.\n");
        }
        else
        {
            printf("Verification FAILED: Kernel variable (%d) does NOT match "
                   "set value (%d).\n",
                   current_val, pbn_to_fail);
        }
    }
    else
    {
        printf("force_fail(%d) failed! (returned %d)\n", pbn_to_fail, ret);
    }

    exit(0);
}