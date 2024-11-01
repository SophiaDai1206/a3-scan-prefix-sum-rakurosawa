#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define SIZE 128 // test 128, 256, 512

__global__ void naiveSS(int *in, int *out) { // change to float for scaling test
    for (int i = 0; i < SIZE; i++) {
        int value = 0;
        for (int j = 0; j <= i; j++) {
            value += in[j];
        }
        out[i] = value;
    }

}


double get_clock() {
    struct timeval tv; int ok;
    ok = gettimeofday(&tv, (void *) 0);
    if (ok<0) { 
        printf("gettimeofday error"); 
    }
    return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

int main() {

    // allocate memory
    int *input, *output; // change to float for scaling test
    cudaMallocManaged(&input, sizeof(int) * SIZE); // change to float for scaling test
    cudaMallocManaged(&output, sizeof(int) * SIZE); // change to float for scaling test

    double t0, t1;

    // initialize inputs
    for (int i = 0; i < SIZE; i++) {
        input[i] = 1; // change to 1.0 for scaling test
    }

    // collect first timer dp
    t0 = get_clock();
    // run the kernel
    naiveSS<<<1, 1>>>(input, output);
    cudaDeviceSynchronize();
    // collect second timer dp
    t1 = get_clock();

   printf("time: %f ns\n", 1000000000.0*(t1-t0));

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