#include <stdio.h>
#include <cooperative_groups.h>
#include <time.h>
#include <stdint.h>

#define DEFAULT_THREADS_PER_BLOCK   256
#define DEFAULT_NUM_BLOCKS          10




__global__ void check_divis(unsigned long long max, uint_fast64_t* out, int thread_count){
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    uint_fast64_t local_sum = 0;
    for(uint_fast64_t i = tid; i< max; i += thread_count){
        if (i % 3 == 0 || i % 5 == 0){
            local_sum += i;
        }
    }
    out[tid] = local_sum;
}


int main(int argc, char* argv[]) {
    uint_fast64_t* d_partial_sums;

    unsigned long long max;
    int threads_per_block;
    int numBlocks;
    int num_runs = 1;
    threads_per_block = DEFAULT_THREADS_PER_BLOCK;
    numBlocks = DEFAULT_NUM_BLOCKS;
    if(argc == 1){
        printf("Enter Maximum:\n");
        max = 1000;
        numBlocks = DEFAULT_NUM_BLOCKS;
        threads_per_block = DEFAULT_THREADS_PER_BLOCK;
    }
    if(argc >= 2){
        max = atoi(argv[1]);
    }
    if(argc >= 3){
        numBlocks = atoi(argv[2]);
    }
    if(argc >= 4){
        num_runs = atoi(argv[3]);
    }
    clock_t begin = clock();

    uint_fast64_t total;
    for(int run = 0; run < num_runs; run++){
        int thread_count = threads_per_block * numBlocks;

        cudaMalloc((void**)&d_partial_sums, thread_count * sizeof(uint_fast64_t));



        check_divis<<<numBlocks, threads_per_block>>>(max, d_partial_sums, thread_count);

        uint_fast64_t* partial_sums = (uint_fast64_t*) malloc(thread_count * sizeof(uint_fast64_t));

        cudaMemcpy(partial_sums, d_partial_sums, thread_count * sizeof(uint_fast64_t), cudaMemcpyDeviceToHost);

        total = 0;
        for(int i = 0; i < thread_count; i++){
            total = total += partial_sums[i];
        }
        printf("The answer is: %llu\n", total);

        cudaFree(d_partial_sums);
    }
    
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The elapsed time is %f seconds\n", time_spent);
    return 0;
}