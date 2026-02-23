import time


def timer(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()

        print(f"{end - start:.7f} sec.\n")

        return result
    return wrapper