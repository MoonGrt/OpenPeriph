#include "dfs.h"

// 静态分配文件系统对象
static FileSystem fs;

// 初始化文件系统
void init_fs(void)
{
    fs.current_dir = &fs.root;

    // 初始化根目录
    rt_strncpy(fs.root.name, "/", MAX_NAME_LENGTH);
    fs.root.file_count = 0;
    fs.root.subdir_count = 0;

    // 创建根目录中的文件
    rt_strncpy(fs.root.files[fs.root.file_count].name, "README", MAX_NAME_LENGTH);
    rt_strncpy(fs.root.files[fs.root.file_count].content,
               "-----------------------------\r\n"
               " Welcome to the File System!\r\n"
               "-----------------------------\r\n"
            //    "Available commands:\r\n"
            //    "1. ls - List files and directories in the current directory.\r\n"
            //    "2. cd <directory_name> - Change to a specified directory.\r\n"
            //    "3. cat <file_name> - Display the content of a file.\r\n"
            //    "Feel free to explore!\r\n"
               , MAX_CONTENT_LENGTH);
    fs.root.file_count++;

    // 创建根目录中的子目录
    // Directory* docs_dir = &fs.root.subdirs[fs.root.subdir_count];
    // docs_dir->file_count = 0;
    // docs_dir->subdir_count = 0;
    // rt_strncpy(docs_dir->name, "docs", MAX_NAME_LENGTH);
    // fs.root.subdirs[fs.root.subdir_count] = docs_dir;
    // fs.root.subdir_count++;

    // Directory* docs_dir = &fs.root.subdirs[fs.root.subdir_count];
    // docs_dir->file_count = 0;
    // docs_dir->subdir_count = 0;
    // rt_strncpy(docs_dir->name, "docs", MAX_NAME_LENGTH);
    // fs.root.subdir_count++;
}

// ls: 列出当前目录的文件和子目录
void ls(int argc, char **argv)
{
    Directory *dir = fs.current_dir;
    // printf("File list:\r\n");
    for (int i = 0; i < dir->file_count; i++)
    {
        printf("%s\r\n", dir->files[i].name);
    }
    // printf("Subdirectory list:\r\n");
    for (int i = 0; i < dir->subdir_count; i++)
    {
        printf("%s/\r\n", dir->subdirs[i]->name);
    }
}
MSH_CMD_EXPORT(ls, list files and directories);

// cd: 切换到指定目录
void cd(int argc, char **argv)
{
    if (argc == 1)
    {
        fs.current_dir = &fs.root;
        return;
    }
    const char *dir_name = argv[1];
    if (rt_strncmp(dir_name, "..", MAX_NAME_LENGTH) == 0)
    {
        if (fs.current_dir != &fs.root)
        {
            fs.current_dir = &fs.root; // 假设仅支持从子目录返回根目录
        }
        return;
    }
    for (int i = 0; i < fs.current_dir->subdir_count; i++)
    {
        if (rt_strncmp(fs.current_dir->subdirs[i]->name, dir_name, MAX_NAME_LENGTH) == 0)
        {
            fs.current_dir = fs.current_dir->subdirs[i];
            return;
        }
    }
    printf("Directory %s not found!\r\n", dir_name);
}
MSH_CMD_EXPORT(cd, change directory);

// cat: 显示文件内容
void cat(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("Usage: cat <file_name>\r\n");
        return;
    }
    const char *file_name = argv[1];
    for (int i = 0; i < fs.current_dir->file_count; i++)
    {
        if (rt_strncmp(fs.current_dir->files[i].name, file_name, MAX_NAME_LENGTH) == 0)
        {
            printf("%s\r\n", fs.current_dir->files[i].content);
            return;
        }
    }
    printf("File %s not found!\r\n", file_name);
}
MSH_CMD_EXPORT(cat, show file content);

// 创建文件
void touch(int argc, char **argv)
{
    if (argc < 3)
    {
        printf("Usage: create_file <file_name> <content>\r\n");
        return;
    }
    const char *file_name = argv[1];
    const char *content = argv[2];
    Directory *dir = fs.current_dir;
    if (dir->file_count >= MAX_FILES_IN_DIR)
    {
        printf("Maximum file count reached in this directory!\r\n");
        return;
    }
    for (int i = 0; i < dir->file_count; i++)
    {
        if (rt_strncmp(dir->files[i].name, file_name, MAX_NAME_LENGTH) == 0)
        {
            printf("File %s already exists!\r\n", file_name);
            return;
        }
    }
    rt_strncpy(dir->files[dir->file_count].name, file_name, MAX_NAME_LENGTH);
    rt_strncpy(dir->files[dir->file_count].content, content, MAX_CONTENT_LENGTH);
    dir->file_count++;
    // printf("File %s created successfully!\r\n", file_name);
}
MSH_CMD_EXPORT(touch, create file);

// // 创建目录
// void mkdir(int argc, char** argv) {
//     if (argc < 2) {
//         printf("Usage: create_directory <directory_name>\r\n");
//         return;
//     }
//     const char* dir_name = argv[1];
//     Directory* dir = fs.current_dir;
//     if (dir->subdir_count >= MAX_SUBDIR_IN_DIR) {
//         printf("Maximum directory count reached in this directory!\r\n");
//         return;
//     }
//     for (int i = 0; i < dir->subdir_count; i++) {
//         if (rt_strncmp(dir->subdirs[i]->name, dir_name, MAX_NAME_LENGTH) == 0) {
//             printf("Directory %s already exists!\r\n", dir_name);
//             return;
//         }
//     }
//     // Directory* new_dir = &dir->subdirs[dir->subdir_count];
//     // new_dir->file_count = 0;
//     // new_dir->subdir_count = 0;
//     // rt_strncpy(new_dir->name, dir_name, MAX_NAME_LENGTH);
//     // dir->subdirs[dir->subdir_count] = new_dir;
//     // dir->subdir_count++;
//     // printf("Directory %s created successfully!\r\n", dir_name);
// }
// MSH_CMD_EXPORT(mkdir, create directory);
