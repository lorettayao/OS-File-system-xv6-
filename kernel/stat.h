#define T_DIR 1     // Directory
#define T_FILE 2    // File
#define T_DEVICE 3  // Device
#define T_SYMLINK 4 // symbolic link

#define M_READ 1
#define M_WRITE 2
#define M_ALL 3

/* TODO: Access Control & Symbolic Link */
struct stat
{
    int dev;     // File system's disk device
    uint ino;    // Inode number
    short type;  // Type of file
    short nlink; // Number of links to file
    uint64 size; // Size of file in bytes
};
