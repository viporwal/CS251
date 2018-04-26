#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/time.h>
#include <math.h>

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

double round(double var)
{
    double value = (int)(var * 100 + .5);
    return (double)value / 100;
}

typedef struct acc{
  int no;
  double balance;
}account;

typedef struct tra{
  int seq;
  int type;
  double amount;
  int ac1;
  int ac2;
}transaction;

account acc[10000];
transaction tra[100000];
int size=0;

int exec=0;
int cur=0;

void thread_fun(){
  int ac1,ac2,type,seq;
  double amount;
  int i=0;
  for(i=0;i<size;i++){
    if(cur>=size)break;
    if(tra[cur].type!=3){
      ac1=tra[cur].ac1;
      ac2=tra[cur].ac2;
      amount=tra[cur].amount;
      type=tra[cur].type;
      cur++;
      if(type==1){
        acc[(ac1-1001)].balance+=(amount-(amount/100.0));
      }
      if(type==2){
        acc[(ac1-1001)].balance-=(amount+(amount/100.0));
      }
      if(type==4){
        acc[(ac1-1001)].balance-=(amount+(amount/100.0));
        acc[(ac2-1001)].balance+=(amount-(amount/100.0));
      }
      exec++;
    }
    else{
      ac1=tra[cur].ac1;
      amount=tra[cur].amount;
      cur++;
      acc[ac1-1001].balance+=(7.1*((acc[ac1-1001].balance)/100.0));
      exec++;
    }
  }
}

int main(int argc, char **argv){
  if(argc != 4){
    printf("Usage: %s <fileneme> <filename> <# of transactions> \n", argv[0]);
    exit(-1);
  }
  struct timeval start, end;
  size = atoi(argv[3]);
  int i=0;
  FILE* acfile = fopen(argv[1], "r");
  for(; fscanf(acfile, "%d %lf", &(acc[i].no),&(acc[i].balance)) && !feof(acfile);) i++;
  fclose(acfile);
  FILE* tfile = fopen(argv[2], "r");
  i=0;
  for(; fscanf(tfile, "%d %d %lf %d %d", &(tra[i].seq),&(tra[i].type),&(tra[i].amount),&(tra[i].ac1),&(tra[i].ac2)) && !feof(tfile);) i++;
  fclose(tfile);
  gettimeofday(&start, NULL);
  thread_fun();
  for(i=0;i<10000;i++){

    printf("%d %.2lf\n",acc[i].no,round(acc[i].balance));
  }
  gettimeofday(&end, NULL);
  printf("Time taken = %ld microsecs\n", TDIFF(start, end));
  return 0;
}
