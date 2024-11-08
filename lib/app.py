import time
import sys
import traceback

def main():
    print("Entering main function")
    try:
        while True:
            print("Hello, World!")
            sys.stdout.flush()  # Force output to be written immediately
            time.sleep(10)
    except Exception as e:
        print(f"An error occurred: {e}")
        print(traceback.format_exc())
        sys.stdout.flush()

if __name__ == "__main__":
    print("Starting myswarm")
    sys.stdout.flush()
    main()