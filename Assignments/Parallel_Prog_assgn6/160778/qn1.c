#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#include<string.h>
#include<pthread.h>
#include<math.h>

#define MAX_THREADS 64
#define USAGE_EXIT(s) do{ \
                            printf("Usage: %s <# of elements> <# of threads> \n %s\n", argv[0], s); \
                            exit(-1);\
                    }while(0);

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

struct thread_param{
                       pthread_t tid;
                       int *array;
                       int size;
                       int skip;
                       int thread_ctr;
                       double max;  
                       int max_index;
};

int prime(int element){
	if(element==0||element==1)return 0;
	if(element==2||element==3)return 1;
	if(element%2==0||element%3==0)return 0;
	int i=5;
	for(i=5;i*i<=element;i=i+6){
		if(element%i==0||element%(i+2)==0) return 0;
	}
	return 1;
}

double function(int element)
{
	if(prime(element))return element;
	return 0;
}

void* find_max(void *arg)
{
     struct thread_param *param = (struct thread_param *) arg;
     int ctr = param->thread_ctr;

     param->max = function(param->array[ctr]);
     param->max_index = ctr;
     ctr += param->skip;

     while(ctr < param->size){
           double x = function(param->array[ctr]);
           if(x > param->max){
                param->max = x;
                param->max_index = ctr;
           }
           ctr += param->skip;
     }          
     return NULL;
}

int main(int argc, char **argv)
{
  struct thread_param *params;
  struct timeval start, end;
  int *a, num_elements, ctr, num_threads;
  long long int max;
  int max_index=-1;

  if(argc !=3)
           USAGE_EXIT("not enough parameters");

  num_elements = atoi(argv[1]);
  if(num_elements <=0)
          USAGE_EXIT("invalid num elements");
  
  num_threads = atoi(argv[2]);
  if(num_threads <=0 || num_threads > MAX_THREADS){
          USAGE_EXIT("invalid num of threads");
  }


  a = malloc(num_elements * sizeof(int));
  if(!a){
          USAGE_EXIT("invalid num elements, not enough memory");
  }

  srand(time(0));  
  for(ctr=0; ctr<num_elements; ++ctr)
        a[ctr] = random();

  params = malloc(num_threads * sizeof(struct thread_param));
  bzero(params, num_threads * sizeof(struct thread_param));

  gettimeofday(&start, NULL);
      
  for(ctr=0; ctr < num_threads; ++ctr){
        struct thread_param *param = params + ctr;
        param->size = num_elements;
        param->skip = num_threads;
        param->array = a;
        param->thread_ctr = ctr;
        
        if(pthread_create(&param->tid, NULL, find_max, param) != 0){
              perror("pthread_create");
              exit(-1);
        }
 
  }
     
  for(ctr=0; ctr < num_threads; ++ctr){
        struct thread_param *param = params + ctr;
        pthread_join(param->tid, NULL);
        if(ctr == 0 || (ctr > 0 && param->max > max)){
             max = param->max;
             max_index = param->max_index;
        }
  }
  if(max==0)max_index=-1;
  printf("MaxPrime= %lld at index=%d\n", max, max_index);
  gettimeofday(&end, NULL);
  printf("Time taken = %ld microsecs\n", TDIFF(start, end));
  free(a);
  free(params);
}
