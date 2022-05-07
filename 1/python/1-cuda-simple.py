import numpy as np
from numba import vectorize, jit
import time

@vectorize(['uint64(uint64)'], target='cuda')
def mod(a):
  if a % 3 == 0 or a % 5 == 0:
    return a
  else:
    return 0

if __name__ == "__main__":
    m = int(input("Enter maximum: "))
    start = time.time()

    for _ in range(10):
        A = np.arange(0, m, dtype=np.uint64)


        C = np.empty_like(A, dtype=A.dtype)

        C = mod(A)
        s = C.sum()
        print(f"The answer is {s}")
    print(f"The elapsed time is {time.time() - start}")