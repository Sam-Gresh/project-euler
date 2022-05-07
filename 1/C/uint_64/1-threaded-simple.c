#include <stdio.h>
#include <time.h>
#include <windows.h>
#include <process.h>
#include <stdint.h>

#define DEFAULT_THREAD_COUNT (12)

int main(int argc, char* argv[]);
void thread_start(void* args);

uint_fast64_t max;
int thread_count;
uint_fast64_t global_sum;
HANDLE mutex;

int main(int argc, char* argv[]){
    double time_spent = 0.0;

    thread_count = DEFAULT_THREAD_COUNT;
    int num_runs = 1;
    if(argc == 1){
        printf("Enter Maximum:\n");
        scanf("%lld", &max);
    }

    if(argc >= 2){
        max = atoi(argv[1]);
    }

    if(argc >= 3){
        thread_count = atoi(argv[2]);
    }

    if (argc >= 4){
        num_runs = atoi(argv[3]);
    }

    //Start timing
    clock_t begin = clock();

    for(int run = 0; run < num_runs; run++){
        global_sum = 0;
        
        mutex = CreateMutex(NULL, FALSE, NULL);
        
        HANDLE* threads = (HANDLE*) malloc(thread_count * sizeof(HANDLE));
        
        for(int i = 0; i < thread_count; i++){
            int* tid = (int*) malloc(1 * sizeof(int));
            *tid = i;
            threads[i] = (HANDLE) _beginthread(thread_start, 0, (void*) tid);
        }

        for(int i = 0; i < thread_count; i++){
            WaitForSingleObject(threads[i], INFINITE);
        }

        free(threads);
        printf("The answer is: %llu\n", global_sum);

        CloseHandle(mutex);
    }
    clock_t end = clock();
        time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
        printf("The elapsed time is %f seconds", time_spent);
        return 0;
}

void thread_start(void* args){
    int* tid = (int*) args;
    uint_fast64_t local_sum = 0;
    for(uint_fast64_t i = *tid; i < max; i += thread_count){
        if(i % 3 == 0 || i % 5 == 0){
            local_sum += i;
        }
    }

    WaitForSingleObject(mutex, INFINITE);
    global_sum += local_sum;
    ReleaseMutex(mutex);
    free(tid);
}