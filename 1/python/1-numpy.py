import numpy as np
import time

def mod(a):
  if a % 3 == 0 or a % 5 == 0:
    return a
  else:
    return 0


if __name__ == "__main__":
    m = int(input("Enter maximum: "))
    start = time.time()
    A = np.arange(0, m, dtype=np.uint64)


    C = np.empty_like(A, dtype=A.dtype)

    vmod = np.vectorize(mod)
    C = vmod(A)
    s = C.sum()
    print(f"The answer is {s}")
    print(f"The elapsed time is {time.time() - start}")