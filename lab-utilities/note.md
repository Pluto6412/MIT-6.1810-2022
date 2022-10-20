# Lab: Xv6 and Unix utilities

## Boot Xv6 easy

实验环境：Windows11 + WSL2 + Ubuntu22.04.1LTS

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

管道的使用在前面的pingpong中已经体会过了，