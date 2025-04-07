#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <dirent.h>
#include <pwd.h>
#include <grp.h>
#include <string.h>


void list_directory(const char* path) {
    DIR *dir;
    struct dirent *entry;
    struct stat file_stat;
    struct passwd *pwd;
    struct group *grp;
    char full_path[1024];
    
    // Get and print current directory info
    if (lstat(path, &file_stat) == 0) {
        pwd = getpwuid(file_stat.st_uid);
        grp = getgrgid(file_stat.st_gid);
        
        printf("Node: %s\n", path);
        printf("Inode: %lu\n", file_stat.st_ino);
        printf("Type: directory\n");
        printf("Size: %ld\n", file_stat.st_size);
        printf("Owner: %d %s\n", file_stat.st_uid, pwd ? pwd->pw_name : "unknown");
        printf("Group: %d %s\n\n", file_stat.st_gid, grp ? grp->gr_name : "unknown");
    }
    
    // Open directory
    dir = opendir(path);
    if (dir == NULL) {
        printf("Error opening directory %s\n", path);
        return;
    }

    // Read directory entries
    while ((entry = readdir(dir)) != NULL) {
        // Skip . and ..
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        // Create full path
        if (strcmp(path, ".") == 0) {
            snprintf(full_path, sizeof(full_path), "./%s", entry->d_name);
        } else {
            snprintf(full_path, sizeof(full_path), "%s/%s", path, entry->d_name);
        }
        
        // Get file stats
        if (lstat(full_path, &file_stat) < 0)
            continue;

        // Get owner and group info
        pwd = getpwuid(file_stat.st_uid);
        grp = getgrgid(file_stat.st_gid);

        // Print file information
        printf("Node: %s\n", full_path);
        printf("Inode: %lu\n", file_stat.st_ino);
        printf("Type: ");
        if (S_ISREG(file_stat.st_mode))
            printf("file\n");
        else if (S_ISDIR(file_stat.st_mode))
            printf("directory\n");
        else if (S_ISLNK(file_stat.st_mode))
            printf("symbolic link\n");
        else if (S_ISFIFO(file_stat.st_mode))
            printf("FIFO\n");
        else
            printf("other\n");

        printf("Size: %ld\n", file_stat.st_size);
        printf("Owner: %d %s\n", file_stat.st_uid, pwd ? pwd->pw_name : "unknown");
        printf("Group: %d %s\n\n", file_stat.st_gid, grp ? grp->gr_name : "unknown");

        // Recursively process subdirectories
        if (S_ISDIR(file_stat.st_mode)) {
            list_directory(full_path);
        }
    }

    closedir(dir);
}
int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <directory_path>\n", argv[0]);
        return 1;
    }

    list_directory(argv[1]);
    return 0;
}