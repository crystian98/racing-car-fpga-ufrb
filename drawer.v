module drawer(
    input [9:0] x, 
    input [8:0] y,            // Coordenadas atuais do pixel
    input [9:0] carro_h_pos,  // Posição horizontal do carro
    input [8:0] carro_v_pos,  // Posição vertical do carro
    input [8:0] obs1_v_pos,   // Posição vertical do obstáculo 1
    input [8:0] obs2_v_pos,   // Posição vertical do obstaculo 2
    input [9:0] lfsr,         // Saída do LFSR para determinar a posição dos obstáculos
    input [9:0] obs1_h_pos,   // Posição horizontal do obstáculo 1
    input [9:0] obs2_h_pos,   // Posição horizontal do obstáculo 2
    output reg [8:0] pixel_data // Cor do pixel
);

    wire [8:0] new_obs2_v_pos; // Variável interna para nova posição do obstáculo 2

    assign new_obs2_v_pos = (obs1_v_pos == obs2_v_pos) ? (obs2_v_pos + 50) : obs2_v_pos;

    always @(*) begin
        // Inicializa com a cor de fundo verde (R=0, G=4, B=0)
        pixel_data = 9'b000_100_000; // Cor de fundo verde

        // Pista de corrida (cinza no meio: R=2, G=2, B=2)
        if (x >= 120 && x < 520)
            pixel_data = 9'b010_010_010; // Cor cinza

        // Faixas marrons nas margens da pista (R=4, G=2, B=1)
        if ((x >= 110 && x < 120) || (x >= 520 && x < 530))
            pixel_data = 9'b100_010_001; // Cor marrom

        // Linhas divisórias brancas (R=7, G=7, B=7)
        if (((x >= 248 && x < 258) || (x >= 382 && x < 392)) && (y % 24) < 16)
            pixel_data = 9'b111_111_111; // Cor branca

        // Desenha o carro (preto: R=0, G=0, B=0)
        if (x >= carro_h_pos && x < (carro_h_pos + 50) && y >= carro_v_pos && y < (carro_v_pos + 50))
            pixel_data = 9'b000_000_000; // Cor preta

        // Faróis e para-brisa do carro (branco: R=7, G=7, B=7)
        if (x >= carro_h_pos && x < (carro_h_pos + 10) && y >= carro_v_pos && y < (carro_v_pos + 10))
            pixel_data = 9'b111_111_111; // Farol esquerdo
        if (x >= (carro_h_pos + 40) && x < (carro_h_pos + 50) && y >= carro_v_pos && y < (carro_v_pos + 10))
            pixel_data = 9'b111_111_111; // Farol direito
        if (x >= (carro_h_pos + 10) && x < (carro_h_pos + 40) && y >= (carro_v_pos + 10) && y < (carro_v_pos + 20))
            pixel_data = 9'b111_111_111; // Parabrisa

        // Desenha o obstáculo 1 (vermelho: R=7, G=0, B=0)
        if (x >= obs1_h_pos && x < (obs1_h_pos + 50) && y >= obs1_v_pos && y < (obs1_v_pos + 50))
            pixel_data = 9'b111_000_000; // Cor vermelha

        // Faróis e para-brisa do obstáculo 1 (branco: R=7, G=7, B=7)
        if (x >= obs1_h_pos && x < (obs1_h_pos + 10) && y >= obs1_v_pos && y < (obs1_v_pos + 10))
            pixel_data = 9'b111_111_111; // Farol esquerdo
        if (x >= (obs1_h_pos + 40) && x < (obs1_h_pos + 50) && y >= obs1_v_pos && y < (obs1_v_pos + 10))
            pixel_data = 9'b111_111_111; // Farol direito
        if (x >= (obs1_h_pos + 10) && x < (obs1_h_pos + 40) && y >= (obs1_v_pos + 10) && y < (obs1_v_pos + 20))
            pixel_data = 9'b111_111_111; // Parabrisa

        // Desenha o obstáculo 2 (vermelho: R=7, G=0, B=0)
        if (x >= obs2_h_pos && x < (obs2_h_pos + 50) && y >= new_obs2_v_pos && y < (new_obs2_v_pos + 50))
            pixel_data = 9'b111_000_000; // Cor vermelha

        // Faróis e para-brisa do obstáculo 2 (branco: R=7, G=7, B=7)
        if (x >= obs2_h_pos && x < (obs2_h_pos + 10) && y >= new_obs2_v_pos && y < (new_obs2_v_pos + 10))
            pixel_data = 9'b111_111_111; // Farol esquerdo
        if (x >= (obs2_h_pos + 40) && x < (obs2_h_pos + 50) && y >= new_obs2_v_pos && y < (new_obs2_v_pos + 10))
            pixel_data = 9'b111_111_111; // Farol direito
        if (x >= (obs2_h_pos + 10) && x < (obs2_h_pos + 40) && y >= (new_obs2_v_pos + 10) && y < (new_obs2_v_pos + 20))
            pixel_data = 9'b111_111_111; // Parabrisa
    end
endmodule
