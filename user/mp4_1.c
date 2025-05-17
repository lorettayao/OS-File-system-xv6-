#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "user/user.h"

typedef void (*test_func_t)();

void test_1();
void test_2();
void test_3();
void test_4();

void main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(2, "Usage: mp4_1 [n]\n");
        exit(1);
    }
    int n;

    n = atoi(argv[1]);
    test_func_t tests[] = {test_1, test_2, test_3, test_4};
    tests[n]();
    exit(0);
}

void test_1()
{
    if (open("test1", O_RDONLY) < 0)
        fprintf(2, "open test1 failed\n");

    if (open("test1/a", O_RDONLY) < 0)
        fprintf(2, "open test1/a failed\n");

    if (open("test1/d", O_RDONLY) < 0)
        fprintf(2, "open test1/d failed\n");

    return;
}

void test_2()
{
    int fd;
    char buf[10];
    struct stat st;

    if (open("test2", O_NOACCESS) < 0)
        fprintf(2, "open test2 failed\n");

    if (open("test2_fake", O_NOACCESS) < 0)
        fprintf(2, "open test2_fake (1) failed\n");

    if (open("test2_fake", O_RDONLY) < 0)
        fprintf(2, "open test2_fake (2) failed\n");

    if ((fd = open("test2_fake/d2/f2", O_NOACCESS)) < 0)
        fprintf(2, "open test2_fake/d2/f2 failed\n");
    else
    {
        if (read(fd, buf, 10) < 0)
            fprintf(2, "read test2_fake/d2/f2 failed\n");
        else
            printf("buf = %s\n", buf);
    }

    if ((fd = open("test2_fake/d1/f1", O_NOACCESS)) < 0)
        fprintf(2, "open test2_fake/d1/f1 failed\n");
    else
    {
        if (read(fd, buf, 10) < 0)
            fprintf(2, "read test2_fake/d1/f1 failed\n");
        else
            printf("buf = %s\n", buf);

        if (fstat(fd, &st) < 0)
            fprintf(2, "fstat test2_fake/d1/f1 failed\n");
        else
            printf("type of test2_fake/d1/f1 is %d\n", st.type);
    }

    if (fd > 0)
        close(fd);

    return;
}

void test_3()
{
    int fd;
    struct stat st;

    if ((fd = open("test3/d1ln_4", O_NOACCESS)) < 0)
        fprintf(2, "open test3/d1ln_4 failed\n");
    else
    {
        if (fstat(fd, &st) < 0)
            fprintf(2, "fstat test3/d1ln_4 failed\n");
        else
            printf("type of test3/d1ln_4 is %d\n", st.type);
    }

    if ((fd = open("test3/d1ln_4", O_RDONLY)) < 0)
        fprintf(2, "open test3/d1ln_4 failed\n");
    else
    {
        if (fstat(fd, &st) < 0)
            fprintf(2, "fstat test3/d1ln_4 failed\n");
        else
            printf("type of the target file test3/d1ln_4 pointing to is %d\n",
                   st.type);
    }

    if ((fd = open("test3/Fln", O_RDWR)) < 0)
        fprintf(2, "open test3/Fln (1) failed\n");

    if ((fd = open("test3/Fln", O_NOACCESS)) < 0)
        fprintf(2, "open test3/Fln (2) failed\n");
    else
    {
        if (fstat(fd, &st) < 0)
            fprintf(2, "fstat test3/Fln failed\n");
        else
            printf("type of test3/Fln is %d\n", st.type);
    }

    if (fd > 0)
        close(fd);

    return;
}

void test_4()
{
    int fd, r;
    char buf1[14], buf2[14];

    if ((fd = open("test4/aln1", O_WRONLY)) < 0)
        fprintf(2, "open test4/aln1 failed\n");

    if ((fd = open("test4/dirXln1/a", O_WRONLY)) < 0)
    {
        fprintf(2, "open test4/dirXln1/a failed\n");
        return;
    }
    strcpy(buf1, "hello os2025");
    if ((r = write(fd, buf1, 13)) != 13)
    {
        fprintf(2, "write to test4/dirXln1/a failed\n");
        close(fd);
        return;
    }
    close(fd);

    if ((fd = open("test4/dirXln1/a", O_RDONLY)) < 0)
    {
        fprintf(2, "open test4/dirXln1/a failed\n");
        return;
    }

    if ((r = read(fd, buf2, 13)) != 13)
    {
        fprintf(2, "read test4/dirXln1/a failed, r = %d\n", r);
        close(fd);
        return;
    }
    printf("%s\n", buf2);

    if (fd > 0)
        close(fd);

    return;
}
