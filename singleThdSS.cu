// include any headers
#include <iostream>
#include <math.h>

#define SIZE 128

__host__ void singleThdSS(int *in, int *out) {
    // copy the first value of in to out
    out[0] = in[0];
    // add the prior value in out to the next value in in 
    for (int i = 1; i < SIZE; i++){
        out[i] = out[i-1] + in[i];
    }
}

int main(void){
    // timer information source: https://developer.nvidia.com/blog/how-implement-performance-metrics-cuda-cc/
    // timer allocation
    cudaEvent_t start, end;
    cudaEventCreate(&start);
    cudaEventCreate(&end);

    // allocate memory
    int *input, *output;
    cudaMallocManaged(&input, SIZE*sizeof(int));
    cudaMallocManaged(&output, SIZE*sizeof(int));

    // initialize inputs
    for (int i = 0; i < SIZE; i++) {
        input[i] = 1;
    }

    // collect first timer dp
    cudaEventRecord(start);
    // run the program
    singleThdSS(input, output);
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

    // free memory
    cudaFree(input);
    cudaFree(output);

    return 0;
}