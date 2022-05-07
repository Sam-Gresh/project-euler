#include <stdio.h>
#include <time.h>
#include <stdint.h>

int main(int argc, char* argv[]){
    double time_spent = 0.0;
    

    long max;
    int num_runs = 1;
    if(argc == 1){
        printf("Enter Maximum:\n");
        scanf("%ld", &max);
    }

    if(argc >= 2){
        max = atoi(argv[1]);
    }

    if(argc >= 3){
        num_runs = atoi(argv[2]);
    }
    

    clock_t begin = clock();

    for(int run = 0; run < num_runs; run++){
        uint_fast64_t sum = 0;
        for(uint_fast64_t i = 0; i < max; i++){
            if(i % 3 == 0 || i % 5 == 0){
                sum += i;
            }
        }
        printf("The answer is: %llu\n", sum);
    }

    clock_t end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The elapsed time is %f seconds", time_spent);
    return 0;
}