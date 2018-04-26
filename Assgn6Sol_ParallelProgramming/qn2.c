#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/time.h>
#include <math.h>

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

double round(double var){
    double value = (int)(var * 100 + .5);
    return (double)value / 100;
}

typedef struct acc{
  int no;
  double balance;
  int locked;
}account;

typedef struct tra{
  int seq;
  int type;
  double amount;
  int ac1;
  int ac2;
}transaction;

int THREADS = 1;
pthread_mutex_t lock;
account acc[10001];
transaction * tra;
int size=0;
int cur=0;

void * thread_fun(void *arg){
  int ac1,ac2,type;
  double amount;
  while(1){
      if(cur>=size)break;
      if((acc[tra[cur].ac1].locked==0)){
        if(tra[cur].ac2!=0){
          if(acc[tra[cur].ac2].locked!=0)continue;
        }
        pthread_mutex_lock(&lock);
        if(cur>=size){
          pthread_mutex_unlock(&lock);
          break;
        }
        if(acc[tra[cur].ac1].locked!=0){
          pthread_mutex_unlock(&lock);
          continue;
        }
        if((tra[cur].ac2!=0)){
          if(acc[tra[cur].ac2].locked!=0){
            pthread_mutex_unlock(&lock);
            continue;
          }
        }
        acc[tra[cur].ac1].locked=1;
        if(tra[cur].ac2!=0){
          acc[tra[cur].ac2].locked=1;
        }
        ac1=tra[cur].ac1;
        ac2=tra[cur].ac2;
        amount=tra[cur].amount;
        type=tra[cur].type;
        cur++;
        pthread_mutex_unlock(&lock);
        if(type==1){
          acc[ac1].balance+=(amount-(0.010*amount));
          acc[ac1].locked=0;
        }
        if(type==2){
          acc[ac1].balance-=(amount+(0.010*amount));
          acc[ac1].locked=0;
        }
        if(type==3){
          acc[ac1].balance+=(0.0710*(acc[ac1].balance));
          acc[ac1].locked=0;
        }
        if(type==4){
          acc[ac1].balance-=(amount+(0.010*amount));
          acc[ac2].balance+=(amount-(0.010*amount)); 
          acc[ac2].locked=0;
        }
        acc[ac1].locked=0;
        if(ac2!=0) acc[ac2].locked=0;
        if(cur>=size)break;
      }
  }
}

int main(int argc, char **argv){
  if(argc != 5){
    printf("Usage: %s <fileneme> <filename> <# of transactions> <# of threrads>\n", argv[0]);
    exit(-1);
  }
  THREADS = atoi(argv[4]);
  size = atoi(argv[3]);
  tra = (transaction *)malloc((size+1)*sizeof(transaction));
  int i=0;
  for(i=0;i<10000;i++){
    acc[i].locked=0;
  }
  FILE* acfile = fopen(argv[1], "r");
  if(!acfile){
    printf("Can not open accounts file\n");
    exit(-1);
  }
  i=0;
  for(; fscanf(acfile, "%d %lf", &(acc[i].no),&(acc[i].balance)) && !feof(acfile);){
    acc[i].no -= 1001;
    i++;
  }
  fclose(acfile);
  FILE* tfile = fopen(argv[2], "r");
  if(!tfile){
    printf("Can not open transaction file\n");
    exit(-1);
  }
  i=0;
  for(; fscanf(tfile, "%d %d %lf %d %d", &(tra[i].seq),&(tra[i].type),&(tra[i].amount),&(tra[i].ac1),&(tra[i].ac2)) && !feof(tfile);){
    if(tra[i].ac1!=0)tra[i].ac1 -= 1001;
    if(tra[i].ac2!=0)tra[i].ac2 -= 1001;
    i++;
  }
  fclose(tfile);
  pthread_t threads[THREADS];
  struct timeval start, end;
  gettimeofday(&start, NULL);
  pthread_mutex_init(&lock, NULL);
  int ctr=0;
  for(ctr=0; ctr < THREADS; ++ctr){
    if(pthread_create(&threads[ctr], NULL, thread_fun, NULL) != 0){
      perror("pthread_create");
      exit(-1);
    }
  }
  for(ctr=0; ctr < THREADS; ++ctr) pthread_join(threads[ctr], NULL);
  for(i=0;i<10000;i++){
    printf("%d %.2lf\n",(acc[i].no+1001),round(acc[i].balance));
  }
  gettimeofday(&end, NULL);
  free(tra);
  printf("Time taken = %ld microsecs\n", TDIFF(start, end));
  return 0;
}


