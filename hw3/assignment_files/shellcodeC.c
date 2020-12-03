#include <stdio.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/un.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
int main(int argc, const char **argv){
	write(3, "test", 4);
	exit(0);
	return(0);
}
