import os
import socket
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    mesage = "Hello from " + socket.gethostname() + "! Application version " + os.environ['VERSION']
    return mesage

if __name__ == "__main__":
    app.run(host='0.0.0.0')
