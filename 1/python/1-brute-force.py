import time



m = int(input("Enter maximum: "))


start = time.time()
for _ in range(10):
    s = 0
    for i in range(m):
        if i % 3 == 0 or i % 5 == 0:
            s += i

    print(f"The answer is {s}")

print(f"The elapsed time is {time.time() - start}")
