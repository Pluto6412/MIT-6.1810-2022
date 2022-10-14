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
