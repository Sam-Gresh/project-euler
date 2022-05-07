from multiprocessing import Process, Value
import ctypes
import time

POOL_SIZE = 12


def task(tid, m, s):
    local_sum = 0
    for i in range(tid, m, POOL_SIZE):
        if i % 3 == 0 or i % 5 == 0:
            local_sum += i

    s.value += local_sum



if __name__ == "__main__":
    m = int(input("Enter maximum: "))
    start = time.time()

    for _ in range(10):
        s = Value(ctypes.c_ulonglong, 0, lock=True)
        processes = []
        for i in range(POOL_SIZE):
            processes.append(Process(target=task, args=(i, m, s)))
            processes[i].start()

        for p in processes:
            p.join()

        print(f"The answer is {s.value}")
    print(f"The elapsed time is {time.time() - start}")