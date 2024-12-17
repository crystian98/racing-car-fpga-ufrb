# racing-car-fpga-ufrb

# Projeto do Controlador VGA para Jogo de Corrida

## Visão Geral

O projeto envolve a implementação de um controlador VGA para um jogo de corrida simples, utilizando um FPGA. O controlador VGA gerencia a sincronização de vídeo, geração das coordenadas dos pixels e a conversão dessas coordenadas para um endereço linear no frame buffer, permitindo que os gráficos sejam exibidos na tela. O fluxo de dados do sistema envolve a geração dos sinais de sincronização VGA, a criação das coordenadas cartesianas (x, y) dos pixels e a conversão dessas coordenadas em um endereço linear para acessar o frame buffer.

## Hierarquia do Controlador VGA

A arquitetura do controlador VGA é dividida em três módulos principais:

1. **Módulo `video_sync_generator`**: 
   - **Função**: Este módulo gera os sinais de sincronização horizontal (HS) e vertical (VS), o sinal de blanking (`blank_n`), e as coordenadas dos pixels (`x` e `y`) com base nos temporizadores VGA.
   - **Entradas**:
     - `reset`: Sinal de reset para reiniciar os contadores.
     - `vga_clk`: Clock do sistema VGA.
   - **Saídas**:
     - `HS`: Sinal de sincronização horizontal.
     - `VS`: Sinal de sincronização vertical.
     - `blank_n`: Sinal que habilita ou desabilita a renderização dos pixels.
     - `x`: Coordenada horizontal do pixel (0 a 639).
     - `y`: Coordenada vertical do pixel (0 a 479).

2. **Módulo `coordenada_x_endereco`**:
   - **Função**: Este módulo converte as coordenadas cartesianas (x, y) em um endereço linear para o frame buffer.
   - **Entrada**:
     - `x`: Coordenada horizontal do pixel.
     - `y`: Coordenada vertical do pixel.
   - **Saída**:
     - `endereco`: Endereço linear do frame buffer, calculado por `endereco = y * 640 + x`, onde 640 é a largura da tela.

## Fluxo de Dados

### 1. Geração dos Sinais de Sincronização

O controlador VGA começa com a geração dos sinais de sincronização. O `video_sync_generator` cria os sinais `HS` e `VS` que controlam a sincronização do monitor. Ele também gera o sinal `blank_n`, que determina se os pixels podem ser exibidos na tela. Os contadores horizontais (`h_cnt`) e verticais (`v_cnt`) são utilizados para determinar a posição atual na tela.

- **Horizontal**: A cada ciclo de clock, o contador horizontal (`h_cnt`) é incrementado até atingir o valor máximo (definido pela largura da tela e pela sincronia horizontal). Quando o contador horizontal atinge esse valor, o contador vertical (`v_cnt`) é incrementado.
- **Vertical**: Da mesma forma, o contador vertical é incrementado até o valor máximo (definido pela altura da tela e pela sincronia vertical).

### 2. Cálculo das Coordenadas dos Pixels

Quando o sinal `blank_n` é ativo (indicado pela combinação de sinais horizontais e verticais válidos), as coordenadas do pixel (`x` e `y`) são geradas com base nos contadores `h_cnt` e `v_cnt`. Essas coordenadas são então passadas para o módulo `coordenada_x_endereco`.

### 3. Conversão para Endereço Linear

O módulo `coordenada_x_endereco` recebe as coordenadas cartesianas (`x`, `y`) e as converte em um endereço linear para o frame buffer. O endereço é calculado utilizando a fórmula:
