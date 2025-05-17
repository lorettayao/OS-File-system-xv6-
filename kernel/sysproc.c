#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void)
{
    int n;
    if (argint(0, &n) < 0)
        return -1;
    exit(n);
    return 0; // not reached
}

uint64 sys_getpid(void) { return myproc()->pid; }

uint64 sys_fork(void) { return fork(); }

uint64 sys_wait(void)
{
    uint64 p;
    if (argaddr(0, &p) < 0)
        return -1;
    return wait(p);
}

uint64 sys_sbrk(void)
{
    int addr;
    int n;

    if (argint(0, &n) < 0)
        return -1;
    addr = myproc()->sz;
    if (growproc(n) < 0)
        return -1;
    return addr;
}

uint64 sys_sleep(void)
{
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
        return -1;
    acquire(&tickslock);
    ticks0 = ticks;
    while (ticks - ticks0 < n)
    {
        if (myproc()->killed)
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    }
    release(&tickslock);
    return 0;
}

uint64 sys_kill(void)
{
    int pid;

    if (argint(0, &pid) < 0)
        return -1;
    return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void)
{
    uint xticks;

    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);
    return xticks;
}

// --- RAID 1 Test Hook Syscall ---
extern int force_read_error_pbn;
extern int force_disk_fail_id;

// System call to simulate a read error on a specific physical block of Disk 0.
// Argument: pbn - the physical block number (0 to LOGICAL_DISK_SIZE-1) to fail,
// or -1 to disable.
uint64 sys_force_fail(void)
{
    int pbn;
    if (argint(0, &pbn) < 0)
        return -1;

    if (pbn >= LOGICAL_DISK_SIZE || pbn < -1)
        return -1;

    force_read_error_pbn = pbn;
    return 0;
}

// System call to get the current value of force_read_error_pbn
uint64 sys_get_force_fail(void) { return (uint64)force_read_error_pbn; }

// System call to force disk 0/1 fail
uint64 sys_force_disk_fail(void)
{
    int disk_id;
    if (argint(0, &disk_id) < 0)
        return -1;
    if (disk_id < -1 || disk_id > 1)
        return -1;
    force_disk_fail_id = disk_id;
    return 0;
}

// --- End RAID 1 Test Hook Syscall ---
