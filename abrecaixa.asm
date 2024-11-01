section .data
    filename db './perdeu.txt', 0

section .bss
    buffer resb 1024          ; reserva 1024 bytes para o conteúdo
    bytes_read resq 1         ; reserva 8 bytes para o número de bytes lidos

section .text
    global _start

_start:
    ; Abrir o arquivo
    mov rax, 2             ; syscall: sys_open
    mov rdi, filename      ; nome do arquivo
    mov rsi, 0             ; flags: O_RDONLY
    syscall                 ; chamada de sistema

    ; Armazenar o descriptor de arquivo
    mov rdi, rax           ; salvar o descriptor de arquivo

    ; Ler o arquivo
    mov rax, 0             ; syscall: sys_read
    mov rsi, buffer        ; buffer onde os dados serão armazenados
    mov rdx, 1024          ; número máximo de bytes a ler
    syscall                 ; chamada de sistema

    ; Armazenar o número de bytes lidos
    mov [bytes_read], rax

    ; Escrever na saída padrão (stdout)
    mov rax, 1             ; syscall: sys_write
    mov rdi, 1             ; stdout
    mov rsi, buffer        ; buffer com dados
    mov rdx, [bytes_read]  ; número de bytes lidos
    syscall                 ; chamada de sistema

    ; Fechar o arquivo
    mov rax, 3             ; syscall: sys_close
    syscall                 ; chamada de sistema

    ; Sair do programa
    mov rax, 60            ; syscall: sys_exit
    xor rdi, rdi           ; código de saída 0
    syscall                 ; chamada de sistema

