.386
.model flat, stdcall
.stack 4096

; =========================================================================
; PROTÓTIPOS DA WIN32 API
; =========================================================================
ExitProcess PROTO, dwExitCode:DWORD
GetModuleHandleA PROTO, lpModuleName:DWORD
RegisterClassExA PROTO, lpwcx:DWORD
CreateWindowExA PROTO, dwExStyle:DWORD, lpClassName:DWORD, lpWindowName:DWORD, dwStyle:DWORD, x:DWORD, y:DWORD, nWidth:DWORD, nHeight:DWORD, hWndParent:DWORD, hMenu:DWORD, hInstance:DWORD, lpParam:DWORD
ShowWindow PROTO, hWnd:DWORD, nCmdShow:DWORD
UpdateWindow PROTO, hWnd:DWORD
PeekMessageA PROTO, lpMsg:DWORD, hWnd:DWORD, wMsgFilterMin:DWORD, wMsgFilterMax:DWORD, wRemoveMsg:DWORD
TranslateMessage PROTO, lpMsg:DWORD
DispatchMessageA PROTO, lpMsg:DWORD
DefWindowProcA PROTO, hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
PostQuitMessage PROTO, nExitCode:DWORD

GetDC PROTO, hWnd:DWORD
ReleaseDC PROTO, hWnd:DWORD, hDC:DWORD
SetDIBitsToDevice PROTO, hdc:DWORD, xDest:DWORD, yDest:DWORD, w:DWORD, h:DWORD, xSrc:DWORD, ySrc:DWORD, StartScan:DWORD, cLines:DWORD, lpvBits:DWORD, lpbmi:DWORD, ColorUse:DWORD
Sleep PROTO, dwMilliseconds:DWORD
GetAsyncKeyState PROTO, vKey:DWORD

; =========================================================================
; ESTRUTURAS WIN32
; =========================================================================
POINT_STRUCT STRUCT
    x DWORD ?
    y DWORD ?
POINT_STRUCT ENDS

MSG_STRUCT STRUCT
    hwnd    DWORD ?
    message DWORD ?
    wParam  DWORD ?
    lParam  DWORD ?
    time    DWORD ?
    pt      POINT_STRUCT <>
MSG_STRUCT ENDS

WNDCLASSEX_STRUCT STRUCT
    cbSize          DWORD 48
    style           DWORD ?
    lpfnWndProc     DWORD ?
    cbClsExtra      DWORD 0
    cbWndExtra      DWORD 0
    hInstance       DWORD ?
    hIcon           DWORD 0
    hCursor         DWORD 0
    hbrBackground   DWORD 0
    lpszMenuName    DWORD 0
    lpszClassName   DWORD ?
    hIconSm         DWORD 0
WNDCLASSEX_STRUCT ENDS

BITMAPINFOHEADER STRUCT
    biSize          DWORD 40
    biWidth         DWORD ?
    biHeight        DWORD ?
    biPlanes        WORD 1
    biBitCount      WORD 32
    biCompression   DWORD 0
    biSizeImage     DWORD 0
    biXPelsPerMeter DWORD 0
    biYPelsPerMeter DWORD 0
    biClrUsed       DWORD 0
    biClrImportant  DWORD 0
BITMAPINFOHEADER ENDS

; =========================================================================
; CONSTANTES DO JOGO (Mapa 29x13)
; =========================================================================
.const
LARGURA_MAPA    EQU 29
ALTURA_MAPA     EQU 13
TAMANHO_TILE    EQU 32

POS_INICIAL_X   EQU 64
POS_INICIAL_Y   EQU 352     ; Linha 11 (para ficar apoiado no chão da linha 12)
VELOCIDADE      EQU 4

FORCA_PULO      EQU -12
GRAVIDADE       EQU 1
VELOCIDADE_MAX  EQU 8

VK_LEFT         EQU 025h
VK_UP           EQU 026h
VK_RIGHT        EQU 027h
VK_SPACE        EQU 020h
VK_ESCAPE       EQU 01Bh
PM_REMOVE       EQU 0001h
WM_DESTROY      EQU 0002h
WS_OVERLAPPEDWINDOW EQU 00CF0000h

; =========================================================================
; DADOS DO JOGO (.data)
; =========================================================================
.data
className       db "JanelaJogoClass", 0
windowName      db "Plataforma MASM x86 - Engine Completa", 0

mapa db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1
     db 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
     db 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1
     db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

player_x        DWORD POS_INICIAL_X
player_y        DWORD POS_INICIAL_Y
velocidade_y    SDWORD 0
estaNoChao      DWORD 0

scr_w           DWORD 928
scr_h           DWORD 416
fb_buffer       db 1544192 dup(0)
fb_ptr          DWORD OFFSET fb_buffer

bmi             BITMAPINFOHEADER <40, 928, -416, 1, 32, 0, 0, 0, 0, 0, 0>

hWnd            DWORD ?
hInstance       DWORD ?
hDC             DWORD ?

spriteChao      db 32, 32
                dd 32 dup(00A0A0A0h)
                dd 31 dup(32 dup(00505050h))

spriteArmadilha db 32, 32
                dd 16 dup(32 dup(00000000h))
                dd 2 dup(15 dup(0), 2 dup(000000FFh), 15 dup(0))
                dd 2 dup(14 dup(0), 4 dup(000000FFh), 14 dup(0))
                dd 2 dup(12 dup(0), 8 dup(000000FFh), 12 dup(0))
                dd 2 dup(10 dup(0), 12 dup(000000FFh), 10 dup(0))
                dd 2 dup(8 dup(0), 16 dup(000000FFh), 8 dup(0))
                dd 2 dup(6 dup(0), 20 dup(000000FFh), 6 dup(0))
                dd 2 dup(4 dup(0), 24 dup(000000FFh), 4 dup(0))
                dd 2 dup(0 dup(0), 32 dup(000000FFh))

spriteJogador   db 32, 32
                dd 4 dup(32 dup(00000000h))
                dd 4 dup(10 dup(0), 4 dup(0000FF00h), 4 dup(00FFFFFFh), 4 dup(0000FF00h), 4 dup(00FFFFFFh), 6 dup(0000FF00h), 0 dup(0))
                dd 20 dup(6 dup(0), 20 dup(0000FF00h), 6 dup(0))
                dd 4 dup(6 dup(0), 8 dup(0000C000h), 4 dup(0), 8 dup(0000C000h), 6 dup(0))

.code

; =========================================================================
; FUNÇÃO AUXILIAR: Lê o tipo de tile com validação de limites
; =========================================================================
ObterTilePixel PROC px:DWORD, py:DWORD
    ; Valida se px e py estão dentro da tela
    cmp px, 0
    jl OutOfBounds
    cmp px, 928
    jge OutOfBounds
    cmp py, 0
    jl OutOfBounds
    cmp py, 416
    jge OutOfBounds

    mov eax, py
    xor edx, edx
    mov ecx, TAMANHO_TILE
    div ecx
    mov ebx, LARGURA_MAPA
    mul ebx
    mov ecx, eax

    mov eax, px
    xor edx, edx
    mov ebx, TAMANHO_TILE
    div ebx
    add ecx, eax

    mov bl, byte ptr [mapa + ecx]
    ret

OutOfBounds:
    mov bl, 1               ; Considera parede sólida se tentar sair do mapa
    ret
ObterTilePixel ENDP

DrawSprite PROC USES eax ebx ecx edx esi edi, posX:DWORD, posY:DWORD, pSprite:DWORD
    mov eax, posX
    mov ebx, posY
    mov esi, pSprite

    xor ecx, ecx
    mov cl, byte ptr [esi]
    
    xor edx, edx
    mov dl, byte ptr [esi+1]
    
    add esi, 2

    test ecx, ecx
    jz FimDesenho
    test edx, edx
    jz FimDesenho

    mov edi, fb_ptr
    imul ebx, scr_w
    add ebx, eax
    shl ebx, 2
    add edi, ebx

LoopLinha:
    push ecx
    push edi

LoopColuna:
    mov eax, dword ptr [esi]
    
    cmp eax, 00000000h
    je PulaPixel
    
    mov dword ptr [edi], eax

PulaPixel:
    add esi, 4
    add edi, 4
    dec ecx
    jnz LoopColuna

    pop edi
    mov eax, scr_w
    shl eax, 2
    add edi, eax
    
    pop ecx
    dec edx
    jnz LoopLinha

FimDesenho:
    ret
DrawSprite ENDP

WndProc PROC hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    cmp uMsg, WM_DESTROY
    je OnDestroy
    INVOKE DefWindowProcA, hWin, uMsg, wParam, lParam
    ret

OnDestroy:
    INVOKE PostQuitMessage, 0
    xor eax, eax
    ret
WndProc ENDP

ChecarArmadilha PROC
    mov eax, player_y
    add eax, 16
    xor edx, edx
    mov ecx, TAMANHO_TILE
    div ecx
    mov ebx, LARGURA_MAPA
    mul ebx
    mov ecx, eax

    mov eax, player_x
    add eax, 16
    xor edx, edx
    mov ebx, TAMANHO_TILE
    div ebx
    add ecx, eax

    mov bl, byte ptr [mapa + ecx]
    cmp bl, 2
    jne FimArmadilha

    mov player_x, POS_INICIAL_X
    mov player_y, POS_INICIAL_Y
    mov velocidade_y, 0
    mov estaNoChao, 0

FimArmadilha:
    ret
ChecarArmadilha ENDP

ProcessarEntrada PROC
    LOCAL novoX:DWORD, yTop:DWORD, yBottom:DWORD

    mov eax, player_y
    add eax, 4
    mov yTop, eax

    mov eax, player_y
    add eax, TAMANHO_TILE
    sub eax, 4
    mov yBottom, eax

; 1. Mover Esquerda
    INVOKE GetAsyncKeyState, VK_LEFT
    test ax, 8000h
    jz ChecarDireita

    mov eax, player_x
    sub eax, VELOCIDADE
    mov novoX, eax

    INVOKE ObterTilePixel, novoX, yTop
    cmp bl, 1
    je ChecarDireita
    INVOKE ObterTilePixel, novoX, yBottom
    cmp bl, 1
    je ChecarDireita

    mov eax, novoX
    mov player_x, eax

; 2. Mover Direita
ChecarDireita:
    INVOKE GetAsyncKeyState, VK_RIGHT
    test ax, 8000h
    jz ChecarPulo

    mov eax, player_x
    add eax, TAMANHO_TILE
    dec eax
    add eax, VELOCIDADE
    mov novoX, eax

    INVOKE ObterTilePixel, novoX, yTop
    cmp bl, 1
    je ChecarPulo
    INVOKE ObterTilePixel, novoX, yBottom
    cmp bl, 1
    je ChecarPulo

    mov eax, player_x
    add eax, VELOCIDADE
    mov player_x, eax

; 3. Pulo
ChecarPulo:
    INVOKE GetAsyncKeyState, VK_UP
    test ax, 8000h
    jz FimEntrada

    cmp estaNoChao, 1
    jne FimEntrada

    mov velocidade_y, FORCA_PULO
    mov estaNoChao, 0

FimEntrada:
    ret
ProcessarEntrada ENDP

AtualizarFisica PROC
    LOCAL novoY:DWORD, yPe:DWORD

    mov eax, velocidade_y
    add eax, GRAVIDADE

    cmp eax, VELOCIDADE_MAX
    jle SalvarVelocidade
    mov eax, VELOCIDADE_MAX

SalvarVelocidade:
    mov velocidade_y, eax

    mov eax, player_y
    add eax, velocidade_y
    mov novoY, eax

    mov eax, velocidade_y
    cmp eax, 0
    jl Subindo

    mov eax, novoY
    add eax, TAMANHO_TILE
    dec eax
    mov yPe, eax

    mov ebx, player_x
    add ebx, 4
    INVOKE ObterTilePixel, ebx, yPe
    cmp bl, 1
    je ColidiuComChao

    mov ebx, player_x
    add ebx, TAMANHO_TILE
    sub ebx, 4
    INVOKE ObterTilePixel, ebx, yPe
    cmp bl, 1
    je ColidiuComChao

    mov eax, novoY
    mov player_y, eax
    mov estaNoChao, 0
    ret

ColidiuComChao:
    mov eax, yPe
    xor edx, edx
    mov ecx, TAMANHO_TILE
    div ecx
    imul eax, TAMANHO_TILE
    sub eax, TAMANHO_TILE
    mov player_y, eax

    mov velocidade_y, 0
    mov estaNoChao, 1
    ret

Subindo:
    cmp novoY, 0
    jge PuloSubindoOK
    mov novoY, 0
    mov velocidade_y, 0

PuloSubindoOK:
    mov eax, novoY
    mov player_y, eax
    mov estaNoChao, 0
    ret
AtualizarFisica ENDP

Renderizar PROC
    LOCAL linha:DWORD, coluna:DWORD
    LOCAL pixelX:DWORD, pixelY:DWORD

    mov edi, fb_ptr
    mov ecx, 928 * 416
    mov eax, 00181820h
    rep stosd

    mov linha, 0
LoopLinhas:
    mov coluna, 0
LoopColunas:
    mov eax, coluna
    mov ebx, TAMANHO_TILE
    mul ebx
    mov pixelX, eax

    mov eax, linha
    mov ebx, TAMANHO_TILE
    mul ebx
    mov pixelY, eax

    mov eax, linha
    mov ebx, LARGURA_MAPA
    mul ebx
    add eax, coluna
    mov bl, byte ptr [mapa + eax]

    cmp bl, 1
    je DesenharChao
    cmp bl, 2
    je DesenharArmadilha
    jmp ProximoTile

DesenharChao:
    INVOKE DrawSprite, pixelX, pixelY, ADDR spriteChao
    jmp ProximoTile

DesenharArmadilha:
    INVOKE DrawSprite, pixelX, pixelY, ADDR spriteArmadilha

ProximoTile:
    inc coluna
    cmp coluna, LARGURA_MAPA
    jl LoopColunas

    inc linha
    cmp linha, ALTURA_MAPA
    jl LoopLinhas

    INVOKE DrawSprite, player_x, player_y, ADDR spriteJogador

    LEA eax, bmi
    INVOKE SetDIBitsToDevice, hDC, 0, 0, scr_w, scr_h, 0, 0, 0, scr_h, fb_ptr, eax, 0
    ret
Renderizar ENDP

main PROC
    LOCAL wc:WNDCLASSEX_STRUCT
    LOCAL msg:MSG_STRUCT

    INVOKE GetModuleHandleA, 0
    mov hInstance, eax

    mov wc.cbSize, sizeof WNDCLASSEX_STRUCT
    mov wc.style, 3
    mov wc.lpfnWndProc, OFFSET WndProc
    mov eax, hInstance
    mov wc.hInstance, eax
    mov wc.lpszClassName, OFFSET className
    INVOKE RegisterClassExA, ADDR wc

    INVOKE CreateWindowExA, 0, ADDR className, ADDR windowName, WS_OVERLAPPEDWINDOW, 100, 100, 944, 455, 0, 0, hInstance, 0
    mov hWnd, eax

    INVOKE ShowWindow, hWnd, 1
    INVOKE UpdateWindow, hWnd
    INVOKE GetDC, hWnd
    mov hDC, eax

GameLoop:
    LEA eax, msg
    INVOKE PeekMessageA, eax, 0, 0, 0, PM_REMOVE
    test eax, eax
    jz ExecutarJogo

    cmp msg.message, WM_DESTROY
    je SairPrograma

    LEA eax, msg
    INVOKE TranslateMessage, eax
    LEA eax, msg
    INVOKE DispatchMessageA, eax
    jmp GameLoop

ExecutarJogo:
    INVOKE GetAsyncKeyState, VK_ESCAPE
    test ax, 8000h
    jnz SairPrograma

    CALL ProcessarEntrada
    CALL AtualizarFisica
    CALL ChecarArmadilha
    CALL Renderizar

    INVOKE Sleep, 16
    jmp GameLoop

SairPrograma:
    INVOKE ReleaseDC, hWnd, hDC
    INVOKE ExitProcess, 0
    ret
main ENDP

END main