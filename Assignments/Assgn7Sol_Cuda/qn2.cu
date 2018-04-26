#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#include<pthread.h>
#include<math.h>

#define MAX_THREAD 1024

#define USAGE_EXIT(s) do{ \
                            printf("Usage: %s <# of elements> <random seed> \n %s\n", argv[0], s); \
                            exit(-1);\
                    }while(0);

#define CUDA_ERROR_EXIT(str) do{\
                                cudaError err = cudaGetLastError();\
                                if( err != cudaSuccess){\
                                         printf("Cuda Error: '%s' for %s\n", cudaGetErrorString(err), str);\
                                         exit(-1);\
                                }\
                             }while(0);

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

__global__ void calculate(long long int *da, const long long int max_in, const long long int in, const long long int prev, long long int *d_ans, const long long int ctr, const long long int u){
      long long int i = blockDim.x * blockIdx.x + threadIdx.x;
      long long int l =  i*in + prev;
      long long int r =  (i+1)*in-1 + prev;
      if(r > max_in)
           return;
      if(i%2==0){
        da[l]=da[l]^da[r];
      }
      else{
        da[r]=da[l]^da[r];
      }
      if(prev!=0 && ctr==u) da[0] = da[0]^da[prev];
      if(ctr==u)
        *d_ans = da[0];
}

int main(int argc, char **argv)
{
  struct timeval start, end;
  long long int *a, num_elements, ctr;
  long long int *ans;
  long long int *d_ans;

  if(argc !=3)
           USAGE_EXIT("not enough parameters");

  num_elements = atoi(argv[1]);
  if(num_elements <=0)
          USAGE_EXIT("invalid num elements");

  long long int SEED = atoi(argv[2]);
  long long int size = num_elements * sizeof(long long int);

  a = (long long int *)malloc(size);
  ans = (long long int *)malloc(sizeof(long long int));
  if(!a){
          USAGE_EXIT("invalid num elements, not enough memory");
  }

  srand(SEED);

  for(ctr=0; ctr<num_elements; ++ctr)
        a[ctr] = random();
  long long int * da;
  cudaMalloc(&da,  size);
  CUDA_ERROR_EXIT("cudaMalloc1");

  cudaMalloc(&d_ans, sizeof(long long int));
  CUDA_ERROR_EXIT("cudaMalloc2");

  cudaMemcpy(da, a, size, cudaMemcpyHostToDevice);
  CUDA_ERROR_EXIT("memcpy1");

  gettimeofday(&start, NULL);
  long long int prev = 0;
  long long int max_in = 0;
  long long int flag=0;
  long long int num = num_elements;
  for(;;){
    if(num_elements==1){
      flag=1;
      break;
    }
    if(num_elements<=0)
      break;
    long long int u = (long long int)log2((double)num_elements);
    long long int x = pow(2,u);
    max_in = prev + x -1;
    for(ctr=1; ctr<=u; ++ctr){
      long long int in = pow(2,ctr);
      long long int threads = num_elements/in;
      if(threads>MAX_THREAD)threads = MAX_THREAD;
      long long int blocks = num_elements/threads;
      calculate<<<blocks, threads>>>(da, max_in, in, prev, d_ans, ctr, u);
      CUDA_ERROR_EXIT("kernel invocation");
    }
    prev += pow(2,u);
    num_elements = num - prev;
  }

  cudaMemcpy(ans, d_ans, sizeof(long long int), cudaMemcpyDeviceToHost);
  CUDA_ERROR_EXIT("memcpy2");

  if(flag==1 && num==1){
    (*ans) = 0^a[num-1];
  }
  else if(flag==1){
    (*ans) = (*ans)^a[num-1];
  }
  printf("XOR = %lld\n", (*ans));

  gettimeofday(&end, NULL);
  printf("Time taken = %ld microsecs\n", TDIFF(start, end));
  free(a);
  cudaFree(da);
  free(ans);
  cudaFree(d_ans);
}
