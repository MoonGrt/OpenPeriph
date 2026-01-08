
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DFS_H
#define __DFS_H

/* Includes ------------------------------------------------------------------*/
#include <rtthread.h>
#include "finsh.h"
#include "cyber.h"

#define MAX_NAME_LENGTH 16
#define MAX_CONTENT_LENGTH 256
#define MAX_FILES_IN_DIR 5
#define MAX_SUBDIR_IN_DIR 3

// 文件结构体
typedef struct File {
    char name[MAX_NAME_LENGTH];  // 文件名
    char content[MAX_CONTENT_LENGTH]; // 文件内容
} File;

// 目录结构体
typedef struct Directory {
    char name[MAX_NAME_LENGTH];  // 目录名
    struct Directory* subdirs[MAX_SUBDIR_IN_DIR]; // 子目录
    File files[MAX_FILES_IN_DIR]; // 文件
    int file_count;  // 文件数量
    int subdir_count; // 子目录数量
} Directory;

// 文件系统结构体
typedef struct FileSystem {
    Directory root; // 根目录
    Directory* current_dir; // 当前工作目录
} FileSystem;

// 函数声明
// FileSystem* init_filesystem();  // 初始化文件系统
// int touch(FileSystem* fs, const char* name, const char* content);  // 创建文件
// int mkdir(FileSystem* fs, const char* name);  // 创建目录
// void ls(FileSystem* fs);  // 列出当前目录的文件和子目录
// int cd(FileSystem* fs, const char* dir_name);  // 切换到指定目录
// int cat(FileSystem* fs, const char* file_name);  // 查看文件内容
// void free_filesystem(FileSystem* fs);  // 释放文件系统内存
void init_fs(void);
void ls(int argc, char** argv);
void cd(int argc, char** argv);
void cat(int argc, char** argv);
void touch(int argc, char** argv);
void mkdir(int argc, char** argv);

#endif /* __DFS_H */
