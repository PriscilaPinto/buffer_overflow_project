# buffer_overflow_project
Este é um repositório de um projeto de desafio onde alteramos um payload de um exploit conhecido para realizar uma outra funcionalidade.

## Descrição

O [exploit escolhido](https://github.com/saleemrashid/sudo-cve-2019-18634) para o desafio foi um que explora uma vulnerabilidade dentro de algumas versões do sudo - [CVE-2019-18634](https://nvd.nist.gov/vuln/detail/CVE-2019-18634).

O sudo é uma ferramenta utilizada em sistemas Unix/Linux onde permite que usuários comuns possam executar comandos com privilégios elevados.

A CVE-2019-18634 aborda a falha onde permite que um usuário comum obtenha privilégios elevados (root), mesmo sem ter essa permissão.

A falha está em uma opção dentro do sudo chamada pwfeedback - permite um feedback visual durante a entrada de senha. Quando habilitada, para cada tecla pressionada, um asterisco é impresso, ajudando os usuários a entender que a entrada está sendo registrada. Essa opção não é habilitada por padrão, mas algumas distribuições, como Linux Mint, a ativam por padrão.

Quando pwfeedback está habilitado, essa falha permite que um usuário, mesmo sem permissões no arquivo sudoers, dispare um bufferoverflow. Isso ocorre devido a uma falha na manipulação do buffer de entrada, que não ignora corretamente a opção pwfeedback quando a entrada vem de um terminal diferente do terminal do usuário.

Veja mais sobre a vulnerabilidade do [Sudo](https://www.sudo.ws/security/advisories/pwfeedback/)

## Pré-requisitos

Para que o exploit seja executado corretamente é necessário ter previamente instalado:

- [Linux Mint 19.2](https://linuxmint.com/torrents/?ref=news.itsfoss.com)

- Versão do sudo 1.8.21p2

Importante: Realize os testes em um ambiente controlado como uma máquina virtual e configure para que a conexão com a internet esteja desligada.


## Passo 1: Clonando o repositório em sua máquina 

Comece clonando este repositório para sua máquina local. Abra o terminal e execute o seguinte comando:

```bash
git clone https://github.com/PriscilaPinto/buffer_overflow_project
```

Isso criará uma cópia local do repositório em seu ambiente.

## Passo 2: Compilar o arquivo `abrecaixa.asm`

Uma vez feita o clone do repositório, é necessário compilar os arquivos corretamente. O arquivo `abrecaixa.asm` é um arquivo escrito em assembly onde ele abre o arquivo `perdeu.txt` no terminal. Para compilar o arquivo:

```bash
cd buffer_overflow_project
~$ nasm -f elf64 abrecaixa.asm -o abrecaixa.o
```

Esse comando irá compilar o arquivo em x64, pois o sistema operacional utilizado para a PoC é baseado em x64.

Após compilar é necessário linkar os arquivos para gerar o executável, para isso:

```bash
ld -o abrecaixa abrecaixa.o
```

Com esse comando, o executável será gerado.

Para conferir se a compilação ocorreu com sucesso, execute o arquivo `abrecaixa` que foi gerado:

```bash
./abrecaixa
```
O executável deve abrir no seu terminal o conteúdo do arquivo `perdeu.txt`.

## Passo 3: Compilando o arquivo `exploit_mod_payload.c`

Para compilar o arquivo `exploit_mod_payload.c` é necessário digititar o seguinte comando:

```bash
gcc exploit_mod_payload.c -o exploit_mod_payload
```

Uma vez executado o comando acima, o executável será gerado com o seguinte nome `exploit_mod_payload`

## Passo 4: Realizando o ataque

Com todos os arquivos e executáveis gerados corretamente, agora podemos iniciar o ataque:

```bash
./exploit_mod_payload
```

Com isso, o exploit irá mostrar no terminal o conteúdo que há dentro do arquivo `perdeu.txt` e sobrecarregar a tela com diversos programas abertos, além de realizar o acesso como root sem ter o devido permissionamento.
Uma vez tendo o acesso como root da máquina é possível escalar o ataque para realizar outras atividades.

## Observações

Por se utilizar um ubuntu um pouco antigo, podem acabar faltando alguns pacotes para compilar os arquivos, caso aconteça, execute o seguinte comando para baixar as dependências:

```bash
sudo apt install build-essential
```

Caso esteja enfrentando problemas com o nasm, pode ser que o nasm não esteja instalado no Linux, para isso:

```bash
sudo apt install nasm
```


