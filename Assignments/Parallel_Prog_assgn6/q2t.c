#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<sys/time.h>
#include<pthread.h>

#define max_size 100000
#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

float balances[10000];
int transactionseq[max_size];
int type[max_size];
float amt[max_size];
int acnt1[max_size];
int acnt2[max_size];
int locked[10000];
int totaltrans;
int THREADS;
int current=0;
pthread_mutex_t lock;



void * doTransactions(void *arg){
	int t_type;
	float t_amt;
	int t_acnt1;
	int t_acnt2;
	while(1){
		if(current>=totaltrans)break;
		if((locked[acnt1[current]-1001]==0) && ((acnt2[current]==0)||(locked[acnt2[current]-1001]==0))){
			pthread_mutex_lock(&lock);
			if(current >= totaltrans){
      			pthread_mutex_unlock(&lock);
      			break;
        	}
			if(locked[acnt1[current]-1001]!=0){
				pthread_mutex_unlock(&lock);
				continue;
			}
            if((acnt2[current]!=0) && (locked[acnt2[current]-1001]!=0)){
                pthread_mutex_unlock(&lock);
                continue;
            }
            if(acnt2[current]==0){
			    locked[acnt1[current]-1001]=1;
            }
            if(acnt2[current]!=0){
                locked[acnt1[current]-1001]=1;
                locked[acnt2[current]-1001]=1;   
            }
			t_type=type[current];
			t_amt=amt[current];
			t_acnt1=acnt1[current];
			t_acnt2=acnt2[current];
			current++;
			pthread_mutex_unlock(&lock);
			if(t_type==1){
				balances[t_acnt1-1001]=balances[t_acnt1-1001]+t_amt-(t_amt*0.01);
			}
			else if(t_type==2){
				balances[t_acnt1-1001]=balances[t_acnt1-1001]-t_amt-(t_amt*0.01);
			}
			else if(t_type==3){
				balances[t_acnt1-1001]=balances[t_acnt1-1001]+((0.071*balances[t_acnt1-1001]));
			}
            else if(t_type==4){
                balances[t_acnt1-1001]=balances[t_acnt1-1001]-t_amt-(t_amt*0.01);
                balances[t_acnt2-1001]=balances[t_acnt2-1001]+t_amt-(t_amt*0.01);
                locked[t_acnt2-1001]=0;
            }
			locked[t_acnt1-1001]=0;
		}
		
	}	
}

int main(int argc, char **argv){
	int j;
	for(j=0;j<10000;j++)locked[j]=0;

	if(argc != 5){
        printf("4 arguements should be passed");
        exit(-1);         
    }  
    
    FILE * fd = fopen(argv[1], "r+");
    if(fd==NULL){
    	printf("unable to open file");
        exit(-1);         
    }
    int cnt=0;
    while(1){
    	float dummy1;
    	int dummy2;
    	int ret = fscanf(fd, "%d  %f",&dummy2, &dummy1);
    	if(ret==2){
    		balances[cnt]=dummy1;		
    		cnt++;
    	}
    	else break;
    }
    fclose(fd);
    cnt=0;

    fd = fopen(argv[2], "r+");
    if(fd==NULL){
    	printf("unable to open file");
        exit(-1);         
    }
    while(1){
    	int dummy1;
    	int dummy2;
    	float dummy3;
    	int dummy4;
    	int dummy5;
    	int ret = fscanf(fd, "%d %d %f %d %d", &dummy1,&dummy2,&dummy3,&dummy4,&dummy5);
    	if(ret==5){
    		transactionseq[cnt]=dummy1;
    		type[cnt]=dummy2;
    		amt[cnt]=dummy3;
    		acnt1[cnt]=dummy4;
    		acnt2[cnt]=dummy5;		
    		cnt++;
    	}
    	else break;
    }
    fclose(fd);

    totaltrans=atoi(argv[3]);
    THREADS=atoi(argv[4]);
    struct timeval start, end;
    gettimeofday(&start, NULL);
    pthread_t threads[THREADS];

    pthread_mutex_init(&lock, NULL);

    for(cnt=0; cnt < THREADS; ++cnt){
        if(pthread_create(&threads[cnt], NULL, doTransactions , NULL) != 0){
              perror("pthread_create");
              exit(-1);
        }
    }

    for(cnt=0; cnt < THREADS; ++cnt)
        pthread_join(threads[cnt], NULL);

    for(cnt=0;cnt<10000;cnt++){
    	printf("%d %.2f\n", cnt+1001,balances[cnt]);
    }
    gettimeofday(&end, NULL);
  	printf("Time taken = %ld microsecs\n", TDIFF(start, end));

	return 0;
}
