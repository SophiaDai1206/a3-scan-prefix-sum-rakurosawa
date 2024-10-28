#include <stdio.h>
#include <stdlib.h>

#define SIZE 8

__global__ void naiveSS(int *in, int *out) {
    __shared__ int source[SIZE];
    __shared__ int destination[SIZE];
    __shared__ int temp[SIZE];

    int tIdx = threadIdx.x;
    source[tIdx] = in[tIdx];

    for (int i = 1; i < SIZE; i *= 2){
        __syncthreads();
        if (tIdx < i){
            destination[tIdx] = source[tIdx];
        }
        else{
            destination[tIdx] = source[tIdx] + source[tIdx - (i)];

        }
        __syncthreads();
        temp[tIdx] = destination[tIdx];
        destination[tIdx] = source[tIdx];
        source[tIdx] = temp[tIdx];
    }

    out[tIdx] = source[tIdx];

}

int main() {
    // allocate memory
    int *input, *output;
    cudaMallocManaged(&input, sizeof(int) * SIZE);
    cudaMallocManaged(&output, sizeof(int) * SIZE);

    // // initialize inputs
    // for (int i = 0; i < SIZE; i++) {
    //     input[i] = 1;
    // }
    // input[0] = 3;
    // input[1] = 1;
    // input[2] = 7;
    // input[3] = 0;
    // input[4] = 4;
    // input[5] = 1;
    // input[6] = 6;
    // input[7] = 3;

    naiveSS<<<1, SIZE>>>(input, output);
    cudaDeviceSynchronize();

    // check results
    for (int i = 0; i < SIZE; i++) {
        printf("%d ", output[i]);
    }
    printf("\n");

    printf("%s\n", cudaGetErrorString(cudaGetLastError()));

    // free mem
    cudaFree(input);
    cudaFree(output);

    return 0;
}