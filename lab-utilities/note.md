# Lab: Xv6 and Unix utilities

## Boot Xv6(easy)

实验环境：Windows11 + WSL2 + Ubuntu22.04LTS

## sleep(easy)

### 任务：实现sleep命令，暂停固定的ticks。

可以使用系统调用sleep，所以并不困难，本质上解决的只有如何从命令行获取相应参数和输出的问题，通过参考其他命令实现就可以完成。

结合xv6参考书里的描述，就可以理解如何获取来自shell的参数。其中，argc表示参数的个数，*argv[] 是参数列表（argv[0]惯例上是程序的名称）。

sleep的实现如下：

```C
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int x;

  if(argc != 2){
    fprintf(2, "Usage: sleep...\n");
    exit(1);
  }

  x = atoi(argv[1]);
  if(x <= 0){
    fprintf(2, "Error: tick should be larger than 0\n");
    exit(1);
  }
  sleep(x);

  exit(0);
}
```

## pingpong(easy)

### 任务：创建一个子进程，父进程将一个比特通过管道发送给子进程，子进程收到后打印pid和规定内容，再将一个比特同样通过管道发送给父进程，然后退出，父进程收到后打印pid和规定内容，然后退出。

首先要理解进程的概念，子进程在创建时的内存同父进程一样，父子进程拥有不同的内存空间和寄存器，改变一个进程中的变量不会影响另一个进程。

然后要理解文件描述符的概念，文件描述符指向的对象可以是文件/管道/设备等。每个进程都有一个从0开始的文件描述符空间，根据Unix系统的惯例，进程从文件描述符0读入（标准输入），从文件描述符1输出（标准输出），从文件描述符2输出错误（标准错误输出）。

最后是管道，管道是一个小的内核缓冲区，它以文件描述符对的形式提供给进程，一个用于写操作，一个用于读操作。从管道的一端写的数据可以从管道的另一端读取。管道提供了一种进程间交互的方式。

pingpong的实现如下：

```C
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int p1[2], p2[2];
  char s[10];

  if(argc > 1) {
    fprintf(2, "Usage: pingpong\n");
    exit(1);
  }

  pipe(p1);
  pipe(p2);
  if(fork() == 0) {
    if(read(p1[0], s, 1)) {
      fprintf(1, "%d: received ping\n", getpid());
        write(p2[1], "p", 1);
        exit(0);
    }
  } else {
    write(p1[1], "p", 1);
    if(read(p2[0], s, 1)) {
      fprintf(1, "%d: received pong\n", getpid());
    }
  }

  exit(0);
}
```

## primes(moderate)/(hard)

### 任务：使用管道实现一个并发的质数筛

这里在实现的过程中需要利用上面用到的的通过管道进行进程间通信的功能。当然也要了解Eratosthenes质数筛的原理。简单来说，就是从2开始，将每个质数的倍数标记成合数，最终留下的就是质数。可以形象的看成是1到n的数落在很多层筛纸上，这些筛纸每层都会筛掉一部分数（数i的倍数），最终经过层层筛检留下来的就是质数。

利用管道和多进程实现Eratosthenes筛是非常巧妙的，文章 https://swtch.com/~rsc/thread/ 的中间对此有一个简单的说明。将每个进程看成一层筛纸，将通过管道收到的第一个数的倍数筛掉，剩下的数继续通过管道发往下一个进程。

注意要关闭不使用的文件描述符，退出不使用的进程，否则会导致程序更早地耗尽资源。

记得要在筛去无用的数的同时输出每个进程收到的第一个数。

primes的实现如下：

```C
#include "kernel/types.h"
#include "user/user.h"

void prime(int inputF);

int main(int argc, char *argv[])
{
  int p[2];
  int i;

  if (argc > 1)
  {
    fprintf(2, "Usage: primes\n");
    exit(1);
  }

  pipe(p);
  if (fork() == 0)
  {
    close(p[1]);
    prime(p[0]);
    close(p[0]);
  }
  else
  {
    for (i = 2; i < 36; ++i)
    {
      close(p[0]);
      write(p[1], &i, sizeof(int));
    }
    close(p[1]);
  }
  wait(0);

  exit(0);
}

void prime(int inputF)
{
  int base, tmp;
  int p1[2];

  if(read(inputF, &base, sizeof(int)) == 0)
  {
    exit(0);
  }
  fprintf(1, "prime %d\n", base);

  pipe(p1);
  if(fork() == 0)
  {
    close(p1[1]);
    prime(p1[0]);
    close(p1[0]);
    //exit(0);
  }
  else
  {
    close(p1[0]);
    while(read(inputF, &tmp, sizeof(int)))
    {
      if(tmp % base != 0)
      {
        write(p1[1], &tmp, sizeof(int));
      }
    }
    close(p1[1]);
  }
  wait(0);
  exit(0);
}
```

## find(moderate)

### 任务：编写一个Unix的find命令的简化版，找到一个文件树中所有具有特定文件名的文件。

可以参考user/ls.c中读取目录的方式。包括对目录下的内容的遍历、对文件类型的识别等等。

使用递归来遍历所有的子目录，注意在递归时跳过"."和".."两个目录，避免出现死循环。

find的实现如下：

```C
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
```

## xargs(moderate)

### 任务：编写一个Unix的xargs命令的简化版，它的参数描述了一个待运行的命令，它从标准输入读取多行参数，并为每一行参数运行前面的作为xargs参数的命令，在运行时将从标准输入读入的参数添加到命令的后面。

首先，要理解xargs这个命令的含义。注意这里需要实现的并不是Unix中xargs命令的标准实现，而只是简化的版本，相当于Unix系统中的"xargs -n 1"。理解xargs命令可以参考 https://shapeshed.com/unix-xargs/ ，这个命令的主要用途在于将标准输入转化为命令行输入，让一些不支持接受标准输入作为参数的命令可以从标准输入中接收参数。简单的说就是将收到的标准输入中的每一行作为额外的参数加到命令的最后运行命令。

例如：echo "a\nb\nc" | echo alpha 就相当于运行了三次echo命令，依次是echo alpha a, echo alpha b, echo alpha c。（注意：xv6的echo命令不支持识别""中的字符串，会将""直接识别为普通字符，要进行类似的测试请运行实验文档中提到的shell脚本）

在具体实现中，提取出要运行的命令，对于标准输入的每一行，构造出新的参数列表，新建一个子进程，调用exec函数来执行命令。

xargs的实现如下：

```C
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/param.h"

char *readline()
{
  char *buf = malloc(MAXARG);
  char *pos = buf;
  while(read(0, pos, sizeof(char)) != 0)
  {
    if(*pos == '\n' || *pos == '\0')
    {
      *pos = '\0';
      return buf;
    }
    pos++;
  }
  if(pos != buf)
    return buf;
  free(buf);
  return 0;
}

int main(int argc, char *argv[])
{
  int i, pid;
  char *cmd;
  char *temp;
  char **temp_argv;

  if(argc < 2)
  {
    fprintf(2, "Usage: xargs [command]\n");
    exit(1);
  }

  cmd = argv[1];
  //指令的参数个数为arac - 2 + 1
  temp_argv = malloc(argc * sizeof(char *));
  //将指令后面的参数填入temp_argv
  for(i = 0; i < argc - 1; ++i)
    temp_argv[i] = argv[1 + i];

  while((temp = readline()) != 0)
  {
    pid = fork();
    if(pid == 0)
    {
      temp_argv[argc - 1] = temp;
      exec(cmd, temp_argv);
    }
    else
      wait(0);
    free(temp);
  }
  free(cmd);
  
  return 0;
}
```