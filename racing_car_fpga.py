import pygame
import sys

# Configurações da simulação
WIDTH, HEIGHT = 1280, 960  # Aumentado para ocupar a tela toda
CAR_WIDTH, CAR_HEIGHT = 100, 100  # Aumentado proporcionalmente
CAR_SPEED = 4  # Velocidade de movimento horizontal do carro
OBSTACLE_WIDTH, OBSTACLE_HEIGHT = 100, 100  # Obstáculos aumentados proporcionalmente
OBSTACLE_SPEED = 10  # Velocidade de movimento dos obstáculos
PISTA_LARGURA = WIDTH - 480  # Largura da pista
FAIXA_CENTRAL = 240 + (PISTA_LARGURA // 2 - CAR_WIDTH // 2)  # Posição inicial e central do carro
FAIXAS = [240 + PISTA_LARGURA // 6, 240 + PISTA_LARGURA // 2, 240 + 5 * PISTA_LARGURA // 6]  # Posições fixas das 3 faixas

# Inicializar pygame
pygame.init()
screen = pygame.display.set_mode((WIDTH, HEIGHT), pygame.FULLSCREEN)
pygame.display.set_caption("Jogo de Carro")
pygame.mouse.set_visible(False)
clock = pygame.time.Clock()

# Estado do gerador pseudoaleatório (LCG)
random_state = 12345  # Semente inicial

# Parâmetros do LCG
LCG_A = 1664525
LCG_C = 1013904223
LCG_M = 1 << 16  # Limitado a 16 bits para facilidade

def next_random():
    global random_state
    random_state = (LCG_A * random_state + LCG_C) % LCG_M
    return random_state

# Função para desenhar o cenário e o estado atual
def draw_frame(carro_h_pos, obstaculos):
    screen.fill((0, 128, 0))  # Fundo verde

    # Pista de corrida (cinza no meio)
    pygame.draw.rect(screen, (128, 128, 128), (240, 0, WIDTH - 480, HEIGHT))

    # Margens da pista (marrom)
    pygame.draw.rect(screen, (139, 69, 19), (240, 0, 20, HEIGHT))  # Esquerda
    pygame.draw.rect(screen, (139, 69, 19), (WIDTH - 260, 0, 20, HEIGHT))  # Direita

    # Faixas brancas tracejadas
    part_width = (WIDTH - 480) // 3
    for y in range(0, HEIGHT, 36):
        pygame.draw.rect(screen, (255, 255, 255), (240 + part_width, y, 12, 24))
        pygame.draw.rect(screen, (255, 255, 255), (240 + 2 * part_width, y, 12, 24))

    # Desenhar o carro
    carro_v_pos = HEIGHT - 200 - int(1.5 * CAR_HEIGHT)  # Subir proporcionalmente
    pygame.draw.rect(screen, (0, 0, 0), (carro_h_pos, carro_v_pos, CAR_WIDTH, CAR_HEIGHT))  # Corpo
    pygame.draw.rect(screen, (255, 255, 255), (carro_h_pos, carro_v_pos, 20, 20))  # Farol esq
    pygame.draw.rect(screen, (255, 255, 255), (carro_h_pos + CAR_WIDTH - 20, carro_v_pos, 20, 20))  # Farol dir
    pygame.draw.rect(screen, (255, 255, 255), (carro_h_pos + 20, carro_v_pos + 20, CAR_WIDTH - 40, 20))  # Parabrisa

    # Desenhar obstáculos
    for obs_h_pos, obs_v_pos in obstaculos:
        pygame.draw.rect(screen, (255, 0, 0), (obs_h_pos, obs_v_pos, OBSTACLE_WIDTH, OBSTACLE_HEIGHT))  # Corpo
        pygame.draw.rect(screen, (255, 255, 255), (obs_h_pos, obs_v_pos + OBSTACLE_HEIGHT - 20, 20, 20))  # Farol esq
        pygame.draw.rect(screen, (255, 255, 255), (obs_h_pos + OBSTACLE_WIDTH - 20, obs_v_pos + OBSTACLE_HEIGHT - 20, 20, 20))  # Farol dir
        pygame.draw.rect(screen, (255, 255, 255), (obs_h_pos + 20, obs_v_pos + OBSTACLE_HEIGHT - 40, OBSTACLE_WIDTH - 40, 20))  # Parabrisa

# Função para verificar colisão entre o carro e os obstáculos
def check_collision(carro_h_pos, obstaculos):
    carro_v_pos = HEIGHT - 200 - int(1.5 * CAR_HEIGHT)

    for obs_h_pos, obs_v_pos in obstaculos:
        # Verificando colisão
        if (carro_h_pos < obs_h_pos + OBSTACLE_WIDTH and
            carro_h_pos + CAR_WIDTH > obs_h_pos and
            carro_v_pos < obs_v_pos + OBSTACLE_HEIGHT and
            carro_v_pos + CAR_HEIGHT > obs_v_pos):
            return True  # Colidiu
    return False  # Não colidiu

# Inicializar posições
carro_h_pos = FAIXA_CENTRAL
obstaculos = [(FAIXAS[next_random() % 3], -OBSTACLE_HEIGHT), (FAIXAS[next_random() % 3], -OBSTACLE_HEIGHT * 4)]

# Loop principal do jogo
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
            running = False

    # Controles do carro
    keys = pygame.key.get_pressed()
    if keys[pygame.K_LEFT] and carro_h_pos > 240:
        carro_h_pos -= CAR_SPEED
    if keys[pygame.K_RIGHT] and carro_h_pos < WIDTH - 260 - CAR_WIDTH:
        carro_h_pos += CAR_SPEED

    # Atualizar posições dos obstáculos
    novos_obstaculos = []
    for x, y in obstaculos:
        if y < HEIGHT:
            novos_obstaculos.append((x, y + OBSTACLE_SPEED))
        else:
            novos_obstaculos.append((FAIXAS[next_random() % 3], -OBSTACLE_HEIGHT))  # Obstáculo na posição da faixa
    obstaculos = novos_obstaculos

    # Verificar colisão
    if check_collision(carro_h_pos, obstaculos):
        print("Colisão detectada!")
        running = False

    # Desenhar o quadro
    draw_frame(carro_h_pos, obstaculos)
    pygame.display.flip()
    clock.tick(60)

pygame.quit()
sys.exit()
