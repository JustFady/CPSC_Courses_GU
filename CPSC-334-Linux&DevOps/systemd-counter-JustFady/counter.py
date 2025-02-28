import signal
import sys
import os
import time
from datetime import datetime

output_file = "/tmp/currentCount.out"
counter = 0
name = "Fady Youssef"
running = True

def handle_sigterm(signum, frame):
    """Handles SIGTERM signal"""
    global running
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log = f"{name}: {timestamp} Received SIGTERM, exiting\n"

    # Write to file before exiting
    with open(output_file, "a") as f:
        f.write(log)
        f.flush()  # Ensure data is written before exit

    print(log, end="")
    sys.exit(0)

# Register SIGTERM handler
signal.signal(signal.SIGTERM, handle_sigterm)

with open(output_file, "a") as f:
    while True:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"{name}: {timestamp} #{counter}\n"
        print(log_entry, end="", flush=True)
        f.write(log_entry)
        f.flush()
        counter += 1
        time.sleep(1)
