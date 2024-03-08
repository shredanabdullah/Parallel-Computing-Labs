#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 256

__global__ void sumArray(float *X, float *result, int size) {
    __shared__ float partialSum[BLOCK_SIZE];

    int tid = threadIdx.x;
    int index = blockIdx.x * blockDim.x + tid;

    /*initialize partial sum for this thread*/
    float sum = 0.0f;
    if (index < size) {
        sum = X[index];
    }
    
    partialSum[tid] = sum;
    __syncthreads();

    // Perform reduction to compute the final sum
    for (unsigned int stride = blockDim.x / 2; stride > 0; stride >>= 1) {
        if (tid < stride && index + stride < size) {
            partialSum[tid] += partialSum[tid + stride];
        }
        __syncthreads();
    }

    /*write the final sum to global memory*/
    if (tid == 0) {
        result[blockIdx.x] = partialSum[0];
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    char *input_file = argv[1];

    FILE *file = fopen(input_file, "r");
    if (file == NULL) {
        printf("Error: Unable to open file %s.\n", input_file);
        return 1;
    }

    /*count the number of elements in the file*/
    int size = 0;
    float temp;
    while (fscanf(file, "%f", &temp) == 1) {
        size++;
    }
    fseek(file, 0, SEEK_SET); /*reset file pointer to the beginning of the file*/

    float *h_arr = (float *)malloc(size * sizeof(float));
    for (int i = 0; i < size; i++) {
        fscanf(file, "%f", &h_arr[i]);
    }
    fclose(file);

    float *d_arr;
    float *d_result;

    /*Allocate device memory for array and result*/
    cudaMalloc((void **)&d_arr, size * sizeof(float));
    cudaMalloc((void **)&d_result, sizeof(float));

    /*copy array to device*/
    cudaMemcpy(d_arr, h_arr, size * sizeof(float), cudaMemcpyHostToDevice);

    /*Launch kernel*/
    sumArray<<<1, BLOCK_SIZE>>>(d_arr, d_result, size);

    /*copy result back to host*/
    float h_result;
    cudaMemcpy(&h_result, d_result, sizeof(float), cudaMemcpyDeviceToHost);

    
    printf("%f\n", h_result);

    /*Free device memory*/
    cudaFree(d_arr);
    cudaFree(d_result);

    /*Free host memory*/
    free(h_arr);

    return 0;
}
