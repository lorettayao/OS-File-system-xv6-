#define NPROC 64                  // maximum number of processes
#define NCPU 8                    // maximum number of CPUs
#define NOFILE 16                 // open files per process
#define NFILE 100                 // open files per system
#define NINODE 50                 // maximum number of active i-nodes
#define NDEV 10                   // maximum major device number
#define ROOTDEV 1                 // device number of file system root disk
#define MAXARG 32                 // max exec arguments
#define MAXOPBLOCKS 10            // max # of blocks any FS op writes
#define LOGSIZE (MAXOPBLOCKS * 3) // max data blocks in on-disk log
#define NBUF (MAXOPBLOCKS * 3)    // size of disk block cache
// #define FSSIZE 1000               // size of file system in blocks
#define FSSIZE 4096   // size of file system in blocks(1000->4096)
#define MAXPATH 128   // maximum file path name
#define NPORT 128     // maximum number of ports
#define NSOCK 32      // maximum number of sockets
#define SBUFFSIZE 128 // size of buffer

// --- RAID 1 Constants ---
#define LOGICAL_DISK_SIZE (FSSIZE / 2)
#define DISK1_START_BLOCK (FSSIZE / 2)
// --- End RAID 1 Constants ---
