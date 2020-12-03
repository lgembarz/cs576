import socket
import sys
from os.path import expanduser

# Create a UDS socket
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
home = expanduser("~")
server_address = home + '/victim.sock'
print('connecting to {}'.format(server_address))
try:
    sock.connect(server_address)
except socket.error as msg:
    print(msg)
    sys.exit(1)

try:

    fo = open("secrets.txt", "r")

    # Send data
    message = bytes(fo.read(), 'ascii')
    #print('sending' + message)
    sock.sendall(message)

finally:
    print('closing socket')
    fo.close()
    sock.close()
