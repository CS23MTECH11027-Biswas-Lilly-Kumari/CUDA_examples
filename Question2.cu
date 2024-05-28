// export PATH=/usr/local/cuda/bin:$PATH
//Question : Add 2 vectors
#include<stdio.h>
#include<cuda.h>
__global__ void addVectors(int *gar1, int *gar2, int *gar3, int N){               
        int id = blockIdx.x * blockDim.x + threadIdx.x; // Global thread index
        if (id < N) {
            gar3[id] = gar1[id] + gar2[id]; 
        }
    

        
}
int main(){

        int N; //size of the vector
        printf("Enter the size of the vector: ");
        scanf("%d", &N);
        int *gar1, *gar2, *gar3 ;
        int *car1 = (int*)malloc(N * sizeof(int)); 
        int *car2 = (int*)malloc(N * sizeof(int)); 
        int *car3 = (int*)malloc(N * sizeof(int)); 

        for (int i = 0; i < N; ++i) {
            car1[i] = i;
            car2[i] = N - i;
        }    
        cudaMalloc (&gar1, N*sizeof(int));
        cudaMalloc (&gar2, N*sizeof(int));
        cudaMalloc (&gar3, N*sizeof(int));
        cudaMemcpy(gar1, car1, N * sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(gar2, car2, N * sizeof(int), cudaMemcpyHostToDevice);
        //cudaMalloc (&gar2, N*sizeof(int));
        addVectors<<<1,N>>>(gar1, gar2, gar3, N);
        cudaMemcpy (car3, gar3, N*sizeof(int), cudaMemcpyDeviceToHost);
        for(int i=0; i<N; ++i){
                printf("%d\n", car3[i]);
        
        }
        cudaFree(gar1);
        cudaFree(gar2);
        cudaFree(gar3);
        free(car1);
        free(car2);
        free(car3);
        return 0;

}