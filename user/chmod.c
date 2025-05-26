#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void usage() {
    fprintf(2, "Usage: chmod [-R] (+|-)(r|w|rw|wr) file_name|dir_name\n");
    exit(1);
}

int parse_mode(char *s, int *mode, int *is_add) {
    if (s[0] != '+' && s[0] != '-')
        return -1;
    *is_add = (s[0] == '+');
    *mode = 0;
    for (int i = 1; s[i]; i++) {
        if (s[i] == 'r') *mode |= 1; // M_READ
        else if (s[i] == 'w') *mode |= 2; // M_WRITE
        else return -1;
    }
    return 0;
}

int main(int argc, char *argv[]) {
    int recursive = 0;
    int arg_idx = 1;

    if (argc < 3)
        usage();

    if (strcmp(argv[1], "-R") == 0) {
        recursive = 1;
        arg_idx++;
    }

    if (argc - arg_idx != 2)
        usage();

    char *mode_str = argv[arg_idx];
    char *path = argv[arg_idx + 1];
    printf("Calling chmod on path = %s\n", path);


    int mode, is_add;
    if (parse_mode(mode_str, &mode, &is_add) < 0)
        usage();

    if (chmod(path, mode, is_add, recursive) < 0) {
        fprintf(2, "chmod: cannot chmod %s\n", path);
        exit(1);
    }

    exit(0);
}
