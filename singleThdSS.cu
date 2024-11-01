#include <iostream>
#include <math.h>
#include <sys/time.h>

#define SIZE 128 // test 128, 256, 512

__host__ void singleThdSS(int *in, int *out) { // change to float for scaling test
    // copy the first value of in to out
    out[0] = in[0];
    // add the prior value in out to the next value in in 
    for (int i = 1; i < SIZE; i++){
        out[i] = out[i-1] + in[i];
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


int main(void){

    // allocate memory
    int *input, *output; // change to float for scaling test
    cudaMallocManaged(&input, SIZE*sizeof(int)); // change to float for scaling test
    cudaMallocManaged(&output, SIZE*sizeof(int)); // change to float for scaling test

    double t0, t1;

    // initialize inputs
    for (int i = 0; i < SIZE; i++) { 
        input[i] = 1; // change to 1.0 for scaling test
    }

    // collect first timer dp
    t0 = get_clock();
    // run the program
    singleThdSS(input, output);
    // collect second timer dp
    t1 = get_clock();

    printf("time: %f ns\n", 1000000000.0*(t1-t0));

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