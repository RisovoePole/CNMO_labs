import time

def timer(func):
    def wrapper():
        start = time.time()

        result = func()

        end = time.time()

        print(f"Execution time for {func.__name__} is {end - start:.5f} seconds.\n")

        return result
    return wrapper