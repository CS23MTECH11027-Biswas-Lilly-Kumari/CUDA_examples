// export PATH=/usr/local/cuda/bin:$PATH
#include<stdio.h>
#include<cuda.h>
__global__ void scalar(int *gar, int N){               
        int id = blockIdx.x * blockDim.x + threadIdx.x; // Global thread index
        if (id < N) {
            gar[id] = id; 
        }
    

        
}
int main(){

        int N; //size of the vector
        printf("Enter the size of the vector: ");
        scanf("%d", &N);
        int car[N], *gar;
        cudaMalloc (&gar, N*sizeof(int));
        scalar<<<1,N>>>(gar, N);
        cudaMemcpy (car, gar, N*sizeof(int), cudaMemcpyDeviceToHost);
        for(int i=0; i<N; ++i){
                printf("%d\n", car[i]);
        
        }
        cudaFree(gar);
        free(car);
        return 0;

}
