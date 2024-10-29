#include <stdio.h>
#include <stdlib.h>

#define SIZE 128

__global__ void naiveSS(int *in, int *out) {
    for (int i = 0; i < SIZE; i++) {
        int value = 0;
        for (int j = 0; j <= i; j++) {
            value += in[j];
        }
        out[i] = value;
    }

}

int main() {
    // timer information source: https://developer.nvidia.com/blog/how-implement-performance-metrics-cuda-cc/
    // timer allocation
    cudaEvent_t start, end;
    cudaEventCreate(&start);
    cudaEventCreate(&end);

    // allocate memory
    int *input, *output;
    cudaMallocManaged(&input, sizeof(int) * SIZE);
    cudaMallocManaged(&output, sizeof(int) * SIZE);

    // initialize inputs
    for (int i = 0; i < SIZE; i++) {
        input[i] = 1;
    }

    // collect first timer dp
    cudaEventRecord(start);
    // run the kernel
    naiveSS<<<1, 1>>>(input, output);
    cudaDeviceSynchronize();
    // collect second timer dp
    cudaEventRecord(end);

    cudaEventSynchronize(end);
    float milsec = 0;
    // calculates total run time in ms
    cudaEventElapsedTime(&milsec, start, end);

    printf("elapsed time: %f ms\n", milsec);

    // // check results
    // for (int i = 0; i < SIZE; i++) {
    //     printf("%d ", output[i]);
    // }
    // printf("\n");

    printf("%s\n", cudaGetErrorString(cudaGetLastError()));

    // free mem
    cudaFree(input);
    cudaFree(output);

    return 0;
}