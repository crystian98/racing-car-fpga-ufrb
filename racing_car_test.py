import numpy as np
import matplotlib.pyplot as plt

# Função para converter cor de 9 bits para RGB (24 bits)
def convert_to_24bit(pixel_9bit):
    if pixel_9bit == 0b000_100_000:  # Verde
        return (0x00, 0x66, 0x00)
    elif pixel_9bit == 0b010_010_010:  # Cinza
        return (0x33, 0x33, 0x33)
    elif pixel_9bit == 0b111_111_111:  # Branco
        return (0xFF, 0xFF, 0xFF)
    elif pixel_9bit == 0b000_000_111:  # Preto
        return (0x00, 0x00, 0x00)
    elif pixel_9bit == 0b000_100_110:  # Vermelho
        return (0xFF, 0x00, 0x00)
    elif pixel_9bit == 0b100_010_001:  # Marrom
        return (0x99, 0x33, 0x19)
    else:  # Default: verde
        return (0x00, 0x66, 0x00)

# Função para detectar colisões
def detect_collision(carro_h_pos, carro_v_pos, obs1_h_pos, obs1_v_pos, obs2_h_pos, obs2_v_pos):
    reset_game = False

    # Verifica colisão com o obstáculo 1
    if (carro_h_pos >= obs1_h_pos and carro_h_pos < (obs1_h_pos + 50)) and \
       (carro_v_pos >= obs1_v_pos and carro_v_pos < (obs1_v_pos + 50)):
        reset_game = True  # Colisão detectada com o obstáculo 1

    # Verifica colisão com o obstáculo 2
    if (carro_h_pos >= obs2_h_pos and carro_h_pos < (obs2_h_pos + 50)) and \
       (carro_v_pos >= obs2_v_pos and carro_v_pos < (obs2_v_pos + 50)):
        reset_game = True  # Colisão detectada com o obstáculo 2

    return reset_game

# Configurações da tela
width, height = 640, 480

# Posições do carro e obstáculos
carro_h_pos, carro_v_pos = 300, 400
obs1_h_pos, obs1_v_pos = 200, 100
obs2_h_pos, obs2_v_pos = 400, 200
lfsr = 0  # Aleatoriedade não usada aqui

# Parâmetros de movimento dos obstáculos
VEL_OBS = 20  # Velocidade dos obstáculos
OBS_POS_INI = 0  # Posição inicial (topo da tela)
ALTURA_TELA = 525  # Altura da tela (em linhas)
LARGURA_TELA = 640  # Largura da tela (em pixels)
OBS_LARGURA = 50  # Largura dos obstáculos
FRAME_CONT_LIMITE = 1  # Divisor escolhido para uma frequência 1Hz na atualização dos obstáculos

# Inicialização do frame buffer (RGB)
frame_buffer_rgb = np.zeros((height, width, 3), dtype=np.uint8)

# Contador para movimentação do carro
carro_move_counter = 0

# Função para gerar números pseudoaleatórios (simulando o LCG)
def next_random_state(state):
    LCG_A = 1664525
    LCG_C = 1013904223
    LCG_M = 1 << 16  # Limitado a 16 bits
    return (LCG_A * state + LCG_C) % LCG_M

# Inicialização do estado aleatório
random_state = 12345

# Iterações para movimentação do carro e obstáculos
for iteration in range(10):  # Faz 10 iterações
    # Incrementa a posição do carro a cada 10 iterações
    carro_move_counter += 10
    carro_h_pos = 300 + carro_move_counter  # Move o carro para a direita em 10 pixels por iteração
    
    # Atualiza o estado pseudoaleatório
    random_state = next_random_state(random_state)
    pos_aleatoria = random_state & 0b11  # Extrai os dois bits menos significativos para posição

    # Detecta colisão
    reset_game = detect_collision(carro_h_pos, carro_v_pos, obs1_h_pos, obs1_v_pos, obs2_h_pos, obs2_v_pos)
    if reset_game:
        # Reinicia as posições do carro e dos obstáculos
        carro_h_pos, carro_v_pos = 300, 400
        obs1_h_pos, obs1_v_pos = 200, 100
        obs2_h_pos, obs2_v_pos = 400, 200

    # Calcula as novas posições dos obstáculos
    if obs1_v_pos < ALTURA_TELA:
        obs1_v_pos += VEL_OBS
    else:
        obs1_v_pos = OBS_POS_INI  # Reinicia no topo
        if pos_aleatoria == 0:
            obs1_h_pos = 320  # Meio da tela
        elif pos_aleatoria == 1:
            obs1_h_pos = 100  # Linha média à esquerda
        else:
            obs1_h_pos = 540  # Linha média à direita

    if obs2_v_pos < ALTURA_TELA:
        obs2_v_pos += VEL_OBS
    else:
        obs2_v_pos = OBS_POS_INI  # Reinicia no topo
        if pos_aleatoria == 0:
            obs2_h_pos = 320  # Meio da tela
        elif pos_aleatoria == 1:
            obs2_h_pos = 100  # Linha média à esquerda
        else:
            obs2_h_pos = 540  # Linha média à direita

    # Preenchendo o frame buffer
    for y in range(height):
        for x in range(width):
            # Fundo verde
            pixel_data = 0b000_100_000

            # Pista cinza
            if 120 <= x < 520:
                pixel_data = 0b010_010_010

            # Faixas marrons nas margens da pista
            if (x >= 110 and x < 120) or (x >= 520 and x < 530):
                pixel_data = 0b100_010_001  # Marrom

            # Linhas brancas
            if ((248 <= x < 258 or 382 <= x < 392) and (y % 24) < 16):
                pixel_data = 0b111_111_111

            # Carro preto
            if carro_h_pos <= x < (carro_h_pos + 50) and carro_v_pos <= y < (carro_v_pos + 50):
                pixel_data = 0b000_000_111

            # Faróis e para-brisa do carro
            if carro_h_pos <= x < carro_h_pos + 10 and carro_v_pos <= y < carro_v_pos + 10:
                pixel_data = 0b111_111_111  # Farol esquerdo
            if carro_h_pos + 40 <= x < carro_h_pos + 50 and carro_v_pos <= y < carro_v_pos + 10:
                pixel_data = 0b111_111_111  # Farol direito
            if carro_h_pos + 10 <= x < carro_h_pos + 40 and carro_v_pos + 10 <= y < carro_v_pos + 20:
                pixel_data = 0b111_111_111  # Parabrisa

            # Obstáculo 1 vermelho
            if obs1_h_pos <= x < (obs1_h_pos + 50) and obs1_v_pos <= y < (obs1_v_pos + 50):
                pixel_data = 0b000_100_110

            # Faróis e para-brisa do obstáculo 1
            if obs1_h_pos <= x < obs1_h_pos + 10 and obs1_v_pos + 40 <= y < obs1_v_pos + 50:
                pixel_data = 0b111_111_111  # Farol esquerdo
            if obs1_h_pos + 40 <= x < obs1_h_pos + 50 and obs1_v_pos + 40 <= y < obs1_v_pos + 50:
                pixel_data = 0b111_111_111  # Farol direito
            if obs1_h_pos + 10 <= x < obs1_h_pos + 40 and obs1_v_pos + 30 <= y < obs1_v_pos + 40:
                pixel_data = 0b111_111_111  # Parabrisa

            # Obstáculo 2 vermelho (ajustado)
            if obs2_h_pos <= x < (obs2_h_pos + 50) and obs2_v_pos <= y < (obs2_v_pos + 50):
                pixel_data = 0b000_100_110

            # Faróis e para-brisa do obstáculo 2
            if obs2_h_pos <= x < obs2_h_pos + 10 and obs2_v_pos + 40 <= y < obs2_v_pos + 50:
                pixel_data = 0b111_111_111  # Farol esquerdo
            if obs2_h_pos + 40 <= x < obs2_h_pos + 50 and obs2_v_pos + 40 <= y < obs2_v_pos + 50:
                pixel_data = 0b111_111_111  # Farol direito
            if obs2_h_pos + 10 <= x < obs2_h_pos + 40 and obs2_v_pos + 30 <= y < obs2_v_pos + 40:
                pixel_data = 0b111_111_111  # Parabrisa

            # Armazena a cor convertida no frame buffer RGB
            frame_buffer_rgb[y, x] = convert_to_24bit(pixel_data)

    # Exibe o resultado
    plt.imshow(frame_buffer_rgb)
    plt.axis('off')  # Remove os eixos
    plt.show()
