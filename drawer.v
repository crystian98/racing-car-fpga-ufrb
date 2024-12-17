module drawer(
    input [9:0] x, 
    input [8:0] y,            // Coordenadas atuais do pixel
    input [9:0] carro_h_pos,     // Posição horizontal do carro
    input [8:0] carro_v_pos,     // Posição vertical do carro
    input [8:0] obs1_v_pos,      // Posição vertical do obstáculo 1
    input [8:0] obs2_v_pos,      // Posição vertical do obstáculo 2
    input [9:0] lfsr,            // Saída do LFSR para determinar a posição dos obstáculos
    input [9:0] obs1_h_pos, // Posição horizontal do obstáculo 1
    input [9:0] obs2_h_pos, // Posição horizontal do obstáculo 2
    output reg [23:0] pixel_data // Cor do pixel calculada
);

    wire [8:0] new_obs2_v_pos; // Variável interna para nova posição do obstáculo 2

    assign new_obs2_v_pos = (obs1_v_pos == obs2_v_pos) ? (obs2_v_pos + 50) : obs2_v_pos;

    always @(*) begin
        // Inicializa com a cor de fundo neutra (um cinza claro, por exemplo)
        pixel_data = 24'h800000; // Cor de fundo verde

        // Pista de corrida (cinza no meio)
        if (x >= 120 && x < 520)
            pixel_data = 24'h808080; // Cor cinza para a pista

        // Faixas marrons nas margens da pista
        if ((x >= 110 && x < 120) || (x >= 520 && x < 530))
            pixel_data = 24'h8B4513; // Cor marrom para as faixas

        // Linhas divisórias brancas
        if (((x >= 248 && x < 258) || (x >= 382 && x < 392)) && (y % 24) < 16)
            pixel_data = 24'hFFFFFF; // Cor branca para as linhas divisórias

        // Desenha o carro (preto)
        if (x >= carro_h_pos && x < (carro_h_pos + 50) && y >= carro_v_pos && y < (carro_v_pos + 50))
            pixel_data = 24'h000000; // Cor preta para o carro

        // Faróis e para-brisa do carro
        if (x >= carro_h_pos && x < (carro_h_pos + 10) && y >= carro_v_pos && y < (carro_v_pos + 10))
            pixel_data = 24'hFFFFFF; // Farol esquerdo
        if (x >= (carro_h_pos + 40) && x < (carro_h_pos + 50) && y >= carro_v_pos && y < (carro_v_pos + 10))
            pixel_data = 24'hFFFFFF; // Farol direito
        if (x >= (carro_h_pos + 10) && x < (carro_h_pos + 40) && y >= (carro_v_pos + 10) && y < (carro_v_pos + 20))
            pixel_data = 24'hFFFFFF; // Parabrisa

        // Desenha o obstáculo 1 (vermelho)
        if (x >= obs1_h_pos && x < (obs1_h_pos + 50) && y >= obs1_v_pos && y < (obs1_v_pos + 50))
            pixel_data = 24'hFF0000; // Cor vermelha para o obstáculo 1

        // Faróis e para-brisa do obstáculo 1
        if (x >= obs1_h_pos && x < (obs1_h_pos + 10) && y >= obs1_v_pos && y < (obs1_v_pos + 10))
            pixel_data = 24'hFFFFFF; // Farol esquerdo do obstáculo 1
        if (x >= (obs1_h_pos + 40) && x < (obs1_h_pos + 50) && y >= obs1_v_pos && y < (obs1_v_pos + 10))
            pixel_data = 24'hFFFFFF; // Farol direito do obstáculo 1
        if (x >= (obs1_h_pos + 10) && x < (obs1_h_pos + 40) && y >= (obs1_v_pos + 10) && y < (obs1_v_pos + 20))
            pixel_data = 24'hFFFFFF; // Parabrisa do obstáculo 1

        // Desenha o obstáculo 2 (vermelho)
        if (x >= obs2_h_pos && x < (obs2_h_pos + 50) && y >= new_obs2_v_pos && y < (new_obs2_v_pos + 50))
            pixel_data = 24'hFF0000; // Cor vermelha para o obstáculo 2

        // Faróis e para-brisa do obstáculo 2
        if (x >= obs2_h_pos && x < (obs2_h_pos + 10) && y >= new_obs2_v_pos && y < (new_obs2_v_pos + 10))
            pixel_data = 24'hFFFFFF; // Farol esquerdo do obstáculo 2
        if (x >= (obs2_h_pos + 40) && x < (obs2_h_pos + 50) && y >= new_obs2_v_pos && y < (new_obs2_v_pos + 10))
            pixel_data = 24'hFFFFFF; // Farol direito do obstáculo 2
        if (x >= (obs2_h_pos + 10) && x < (obs2_h_pos + 40) && y >= (new_obs2_v_pos + 10) && y < (new_obs2_v_pos + 20))
            pixel_data = 24'hFFFFFF; // Parabrisa do obstáculo 2
    end
endmodule
