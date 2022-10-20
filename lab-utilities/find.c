#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void
match(char *path, char *fileName);

void
find(char *path, char *fileName);

int
main(int argc, char *argv[])
{
  if(argc < 2 || argc > 3)
  {
    fprintf(2, "Usage: find [file_path] [file_name]\n");
    exit(1);
  }

  if(argc == 2)
    find(".", argv[1]);
  else
    find(argv[1], argv[2]);
  exit(0);
}

void
match(char *path, char *fileName)
{
  char *p = path;
  while(*p != 0) {
    //printf("%s==flag\n", p);
    if(strcmp(p, fileName) == 0) {
      printf("%s\n", path);
      return;
    }
    p++;
  }
}

void
find(char *path, char *fileName)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0) {
    fprintf(2, "find: cannot open %s\n", path);
    close(fd);
    return;
  }

  if(fstat(fd, &st) < 0) {
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type) {
    case T_DEVICE:
    case T_FILE:
      match(path, fileName);
      break;
    case T_DIR:
      if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
        printf("ls: path too long\n");
        break;
      }
      strcpy(buf, path);
      p = buf + strlen(buf);
      *p++ = '/';
      while(read(fd, &de, sizeof(de)) == sizeof(de)) {
        if(de.inum == 0)
          continue;
        if(de.name[0] == '.' && de.name[1] == '\0')
          continue;
        if(de.name[0] == '.' && de.name[1] == '.')
          continue;
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;
        if(stat(buf, &st) < 0) {
          printf("ls: cannot stat %s\n", buf);
          continue;
        }
        find(buf, fileName);
      }
      break;
  }
  close(fd);
}