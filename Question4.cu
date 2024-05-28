#include <stdio.h>
#include <cuda_runtime.h>

__global__ void square(int *matrix, int *result, int matrixSize) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    int row = id / matrixSize;
    int col = id % matrixSize;

    if (row < matrixSize && col < matrixSize) {
        int sum = 0;
        for (int k = 0; k < matrixSize; ++k) {
            sum += matrix[row * matrixSize + k] * matrix[k * matrixSize + col];
        }
        result[row * matrixSize + col] = sum;
    }
}

int main() {
     int matrixSize;
    printf("The size of the matrix:");
    scanf("%d", &matrixSize);
    const int N = matrixSize * matrixSize;

    int cmat[matrixSize][matrixSize];
    int cres[matrixSize][matrixSize];

    for(int i=0;i<matrixSize;i++)
        {
            for(int j=0;j<matrixSize;j++)
                {
                    scanf("%d",&cmat[i][j]);
                }
        }

    int *gmat, *gres;
    cudaMalloc(&gmat, N * sizeof(int));
    cudaMalloc(&gres, N * sizeof(int));

    cudaMemcpy(gmat, cmat, N * sizeof(int), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;

    square<<<blocksPerGrid, threadsPerBlock>>>(gmat, gres, matrixSize);

    cudaMemcpy(cres, gres, N * sizeof(int), cudaMemcpyDeviceToHost);

    // Print result
    for (int i = 0; i < matrixSize; i++) {
        for (int j = 0; j < matrixSize; j++) {
            printf("%d ", cres[i][j]);
        }
        printf("\n");
    }

    
    cudaFree(gmat);
    cudaFree(gres);
    return 0;
}
