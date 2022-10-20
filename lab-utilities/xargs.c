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

  //cmd = malloc(MAXARG * sizeof(char)); //指令
  cmd = argv[1];
  //指令的参数个数为arac - 2 + 1
  temp_argv = malloc(argc * sizeof(char *));
  //将指令后面的参数填入temp_argv
  for(i = 0; i < argc - 1; ++i)
    temp_argv[i] = argv[1 + i];

  //fprintf(1, "%s %s\n", cmd, *temp_argv);
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
  
  //free(cmd);
  
  return 0;
}