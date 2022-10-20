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
