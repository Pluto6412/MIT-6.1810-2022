# Lab: system calls

## Using gdb(easy)

### 任务：学习使用 gdb 来调试 Xv6 内核 

按照实验要求启动 gdb，出现错误：

```
warning: No executable has been specified and target does not support
determining executable automatically.  Try using the "file" command.
```

根据 https://pdos.csail.mit.edu/6.S081/2022/labs/gdb.html 的建议，执行 file kernel/kernel 命令后成功运行 gdb。

```json
❯ gdb-multiarch
GNU gdb (Ubuntu 12.1-0ubuntu1~22.04) 12.1
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word".
The target architecture is set to "riscv:rv64".
warning: No executable has been specified and target does not support
determining executable automatically.  Try using the "file" command.
0x0000000000001000 in ?? ()
(gdb) file kernel/kernel
Reading symbols from kernel/kernel...
(gdb) b syscall
Breakpoint 1 at 0x80001fe2: file kernel/syscall.c, line 133.
(gdb) c
Continuing.
[Switching to Thread 1.2]

Thread 2 hit Breakpoint 1, syscall () at kernel/syscall.c:133
133     {
(gdb)
```

## System call tracing (moderate)

### 任务描述

添加一个 trace 系统调用用来跟踪系统调用的执行情况。程序接受一个掩码来表示需要跟踪哪些系统调用，在那些系统调用返回前，需要输出一行信息，包括进程 id，系统调用的名称和返回值。trace 系统调用需要跟踪调用它的进程和这个进程之后新建的所有子进程，但不影响其他进程。

### 根据实验提示，先添加一个 trace 系统调用的原型

在 Xv6 中已经编写了一个用户空间的程序 trace，功能是在 trace 启动的情况下运行其他的程序。将 $U/_trace 加入 UPROGS 中，再进行编译时会失败，因为 trace 系统调用现在并不存在。

- 在 `user/user.h` 中添加：

```C
int trace(int);
```

- 在 `user/usys.pl` 中添加：

```perl
entry("trace");
```

- 在 `kernel/syscall.h` 中添加：

```C
#define SYS_trace 22
```

在经过了上面的添加后，已经可以成功进行编译了，执行 trace 32 grep hello README：

```json
xv6 kernel is booting

hart 2 starting
hart 1 starting
init: starting sh
$ trace 32 grep hello README
3 trace: unknown sys call 22
trace: trace failed
$
```

trace 系统调用还没有在内核中实现，因此输出 trace fail。

### 实现 trace 系统调用

- 在 `kernel/proc.h` 中的 struct proc 结构体中添加新的变量 mask 用来记录掩码。
- 在 `kernel/sysproc.c` 中添加 sys_trace() 函数用来将接受到的掩码参数存入对应的 proc 结构体中。根据 sysproc.c 中的其他函数可以发现如何获取系统调用的参数。

```C
uint64
uint64
sys_trace(void)
{
  int mask;

  argint(0, &mask);
  myproc()->mask = mask;
}
```

- 修改 `kernel/proc.c` 中的 fork() 函数来将父进程的掩码参数复制到子进程中。

```C
// 在 proc.c 中添加的代码
np->mask = p->mask;
```

- 修改 `kernel/syscall.c` 中的 syscall() 函数来打印输出。注意在前面的定义和映射中添加 trace 系统调用，并添加用于通过掩码识别系统调用名称的数组。

```C
/******/

extern uint64 sys_close(void);
extern uint64 sys_trace(void);

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
    /*******/
    [SYS_close] sys_close,
    [SYS_trace] sys_trace,
};

// 添加识别名
char *syscall_name[23] = {"", "fork", "exit", "wait", "pipe", "read",
                           "kill", "exec", "fstat", "chdir", "dup",
                           "getpid", "sbrk", "sleep", "uptime", "open",
                           "write", "mknod", "unlink", "link", "mkdir",
                           "close", "trace"};

void syscall(void)
{
  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
		if (p->mask & (1 << num))
      printf("%d: syscall %s -> %d\n", p->pid, syscall_name[num], p->trapframe->a0);
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
```

至此，任务 System call tracing 完成。

## Sysinfo (moderate)

### 任务描述

添加一个系统调用 sysinfo，功能是收集运行时系统的信息。系统调用接收一个参数：一个指向结构体 struct sysinfo 的指针，内核应该将结构体填满，fremem 应该为空闲内存的比特数，nproc 应该为状态不为 UNUSED 的进程个数。Xv6 中已经包含了一个测试用程序 sysinfotest，如果这个程序输出 "sysinfotest:OK"，代表通过了测试。

### 添加系统调用原型

与前面一样添加系统调用原型，注意在 `user/user.h` 中添加时要先声明结构体。

```C
struct sysinfo;
int sysinfo(struct sysinfo *);
```

### 实现 sysinfo 系统调用

- 在 `kernel/kalloc.c` 中添加一个函数获取空闲内存的大小。

```C
// 返回空闲内存的比特数
int freemem(void)
{
  struct run *r = kmem.freelist;
  uint64 num = 0; // 空闲页的数目
  while (r)
  {
    r = r->next;
    num++;
  }
  return num * PGSIZE;
}
```

- 在 `kernel/proc.c` 中添加一个函数获取进程的个数。

```C
// 返回当前使用中的进程的个数
int procnum(void)
{
  struct proc *p;
  int num = 0;
  for (p = proc; p < &proc[NPROC]; ++p)
  {
    if (p->state != UNUSED)
      num++;
  }
  return num;
}
```

- sysinfo 需要将一个 struct sysinfo 结构体复制回用户空间，观察 `kernel/sysfile.c` 中的 sys_fstat() 函数和 `kernel/file.c` 中的 filestat() 函数来参考如何使用 copyout() 函数。（记得将上面两步添加的函数添加到 `kernel/defs.h` 中）

```C
uint64 sys_sysinfo(void)
{
  struct sysinfo info;
  uint64 addr;
  argaddr(0, &addr);
  info.freemem = freemem();
  info.nproc = procnum();
  if(copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    return -1;
  return 0;
}
```

至此，任务 Sysinfo 完成。

## make grade 测试结果

```json
== Test trace 32 grep ==
$ make qemu-gdb
trace 32 grep: OK (2.6s)
== Test trace all grep ==
$ make qemu-gdb
trace all grep: OK (0.7s)
== Test trace nothing ==
$ make qemu-gdb
trace nothing: OK (0.9s)
== Test trace children ==
$ make qemu-gdb
trace children: OK (8.6s)
== Test sysinfotest ==
$ make qemu-gdb
sysinfotest: OK (1.2s)
    (Old xv6.out.sysinfotest failure log removed)
```
