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
    // allocate memory
    int *input, *output;
    cudaMallocManaged(&input, SIZE*sizeof(int));
    cudaMallocManaged(&output, SIZE*sizeof(int));

    // initialize inputs
    for (int i = 0; i < SIZE; i++) {
        input[i] = 1;
    }

    singleThdSS(input, output);

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