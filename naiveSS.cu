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
    // allocate memory
    int *input, *output;
    cudaMallocManaged(&input, sizeof(int) * SIZE);
    cudaMallocManaged(&output, sizeof(int) * SIZE);

    // initialize inputs
    for (int i = 0; i < SIZE; i++) {
        input[i] = 1;
    }

    naiveSS<<<1, 1>>>(input, output);
    cudaDeviceSynchronize();

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