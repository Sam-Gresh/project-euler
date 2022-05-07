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

__global__ void sum_list( uint_fast64_t* in, uint_fast64_t* out){
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    uint_fast64_t local_sum = in[tid * 2] + in[tid * 2 + 1];
    out[tid] = local_sum;
}

int main(int argc, char* argv[]) {
    uint_fast64_t* d_partial_sums;
    uint_fast64_t* d_temp;
    unsigned long long max;
    
    int threads_per_block = DEFAULT_THREADS_PER_BLOCK;
    int num_blocks = DEFAULT_NUM_BLOCKS;
    int num_runs = 1;

    if(argc == 1){
        printf("Enter Maximum:\n");
        max = 1000;
        num_blocks = DEFAULT_NUM_BLOCKS;
        threads_per_block = DEFAULT_THREADS_PER_BLOCK;
    }
    if(argc >= 2){
        max = atoi(argv[1]);
    }
    if(argc >= 3){
        num_blocks = atoi(argv[2]);
    }
    if(argc >= 4){
        num_runs = atoi(argv[3]);
    }
    clock_t begin = clock();

    for(int run = 0; run < num_runs; run++){
        int thread_count = threads_per_block * num_blocks;
        int length = thread_count;
        


        cudaMalloc((void**)&d_partial_sums, thread_count * sizeof(uint_fast64_t));
        cudaMalloc((void**)&d_temp, thread_count * sizeof(uint_fast64_t));


        
        check_divis<<<num_blocks, threads_per_block>>>(max, d_partial_sums, thread_count);

        int nb = num_blocks;
        int tpb = threads_per_block;
        while(length > 1){
            
            sum_list<<<num_blocks, threads_per_block>>>(d_partial_sums, d_temp);
            if(nb > 1){
                nb /= 2;
            }
            else{
                tpb /= 2;
            }
            length /= 2;
            cudaMemcpy(d_partial_sums, d_temp, length * sizeof(uint_fast64_t), cudaMemcpyDeviceToDevice);
            
        }

        uint_fast64_t total;
        cudaMemcpy(&total, d_partial_sums, 1 * sizeof(uint_fast64_t), cudaMemcpyDeviceToHost);
        printf("The answer is: %llu\n", total);

        cudaFree(d_partial_sums);
        cudaFree(d_temp);
    }
    
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The elapsed time is %f seconds\n", time_spent);
    return 0;
    
}