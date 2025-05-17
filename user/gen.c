#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

typedef void (*test_func_t)();

void mkfile(char *filename)
{
    int fd = open(filename, O_CREATE | O_RDWR);
    write(fd, "hi", 3);
    close(fd);
}

void mkd(char *dirname)
{
    if (mkdir(dirname) < 0)
    {
        fprintf(2, "mkdir %s failed.", dirname);
        exit(1);
    }
}

void gentest1()
{
    mkd("test1");
    mkfile("test1/a");
    mkfile("test1/b");
    mkfile("test1/c");
    mkd("test1/d");
    mkfile("test1/d/a");
}

void gentest2()
{
    mkd("test2");
    mkd("test2/d1");
    mkd("test2/d2");
    mkd("test2/d3");
    mkfile("test2/d1/f1");
    mkfile("test2/d2/f2");
    mkfile("test2/d3/f3");
}

void gentest3()
{
    mkd("test3");
    mkd("test3/d1");
    mkd("test3/d1/D");
    mkfile("test3/d1/f1");
    mkfile("test3/d1/f2");
    mkfile("test3/d1/f3");
    mkfile("test3/d1/D/F");
}

void gentest4()
{
    mkd("test4");
    mkd("test4/dirX");
    mkfile("test4/dirX/a");
    mkfile("test4/dirX/b");
    mkfile("test4/dirX/c");
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(2, "Usage: gen [n]\n");
        exit(1);
    }
    int n;

    n = atoi(argv[1]);
    test_func_t tests[] = {gentest1, gentest2, gentest3, gentest4};
    tests[n]();

    exit(0);
}
