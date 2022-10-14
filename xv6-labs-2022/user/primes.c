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