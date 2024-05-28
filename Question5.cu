#include <stdio.h>
#include <cuda_runtime.h>

__global__ void matmul(int *gm1, int *gm2,int *gres, int r1, int c1, int r2, int c2) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    int row = id / r1;
    int col = id % c2;

    if (row < r1 && col < c2) {
        int sum = 0;
        for (int k = 0; k < c1; k++) { // c1 is the same as r2
            sum += gm1[row * c1 + k] * gm2[k * c2 + col];
        }
        gres[row * c2 + col] = sum;
    }
}


int main() {
    int r1,c1,r2,c2;
    printf("Number of rows of first matrix:");
    scanf("%d",&r1);
    printf("Number of columns of first matrix:");
    scanf("%d",&c1);
    printf("Number of rows of second matrix:");
    scanf("%d",&r2);
    printf("Number of columns of second matrix:");
    scanf("%d",&c2);
    int mat_size1 = r1*c1;
    int mat_size2 = r2*c2;
    int res_size = r1 * c2;
    int cm1[r1][c1];
    int cm2[r2][c2];
    int cres[r1][c2];
    int *gm1, *gm2, *gres; 
    for(int i=0;i<r1;i++)
    {
        for(int j=0;j<c1;j++)
            {
                scanf("%d",&cm1[i][j]);
            }
    }
        for(int i=0;i<r2;i++)
        {
            for(int j=0;j<c2;j++)
                {
                    scanf("%d",&cm2[i][j]);
                }
        }
        cudaMalloc(&gm1, r1*c1 * sizeof(int));
        cudaMalloc(&gm2, r2*c2 * sizeof(int));
        cudaMalloc(&gres, r1*c2* sizeof(int));
        cudaMemcpy(gm1,cm1,r1*c1*sizeof(int),cudaMemcpyHostToDevice);
        cudaMemcpy(gm2,cm2,r2*c2*sizeof(int),cudaMemcpyHostToDevice);
        int threadsPerBlock = 256;
        int blocksPerGrid = (res_size + threadsPerBlock - 1) / threadsPerBlock;

        matmul<<<blocksPerGrid, threadsPerBlock>>>(gm1, gm2, gres, r1, c1, r2, c2 );
        cudaMemcpy(cres, gres, r1*c2* sizeof(int), cudaMemcpyDeviceToHost);

    for(int i=0;i<r1;i++)
    {
        for(int j=0;j<c2;j++)
        {
              printf("%d\t",cres[i][j]);
        }
        printf("\n");
    }
    cudaFree(gm1);
    cudaFree(gm2);
    cudaFree(gres);
    


    return 0;
}
