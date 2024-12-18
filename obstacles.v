module obstaculos(
    input iVGA_CLK,          // Clock VGA (25 MHz)
    input reset_game,        // Reset do jogo
    input iRST_n,            // Reset ativo em nível baixo
    output reg [9:0] obs1_h_pos, // Posição horizontal do obstáculo 1
    output reg [9:0] obs2_h_pos, // Posição horizontal do obstáculo 2
    output reg [8:0] obs1_v_pos, // Posição vertical do obstáculo 1
    output reg [8:0] obs2_v_pos  // Posição vertical do obstáculo 2
);

    // Parâmetros do movimento dos obstáculos
    parameter VEL_OBS = 2;         // Velocidade dos obstáculos
    parameter OBS_POS_INI = 10'd0;  // Posição inicial (topo da tela)
    parameter ALTURA_TELA = 525;   // Altura da tela (em linhas)
    parameter LARGURA_TELA = 640;  // Largura da tela (em pixels)
    parameter OBS_LARGURA = 50;    // Largura dos obstáculos
    parameter FRAME_CONT_LIMITE = 16'd833; // Ajustado para 30 Hz (30 fps)

    // Contador de quadros
    reg [15:0] frame_cont;

    // Estado do gerador pseudoaleatório (LCG)
    reg [31:0] random_state; 
    wire [31:0] next_random;

    // Parâmetros do LCG
    parameter LCG_A = 1664525;
    parameter LCG_C = 1013904223;
    parameter LCG_M = 1 << 16; // Limitado a 16 bits para facilidade

    // Geração pseudoaleatória com o LCG
    assign next_random = (LCG_A * random_state + LCG_C) % LCG_M;

    always @(posedge iVGA_CLK or negedge iRST_n) begin
        if (!iRST_n) begin
            // Reset geral
            frame_cont <= 16'd0;
            obs1_v_pos <= OBS_POS_INI;
            obs2_v_pos <= OBS_POS_INI;
            obs1_h_pos <= 10'd120;
            obs2_h_pos <= 10'd320;
            random_state <= 32'd12345; // Semente inicial do gerador
        end else if (reset_game) begin
            // Reset do jogo
            frame_cont <= 16'd0;
            obs1_v_pos <= OBS_POS_INI;
            obs2_v_pos <= OBS_POS_INI;
            obs1_h_pos <= 10'd120;
            obs2_h_pos <= 10'd320;
            random_state <= 32'd12345; // Reinicia a semente
        end else begin
            // Atualiza o estado pseudoaleatório
            random_state <= next_random;

            // Contador de quadros
            if (frame_cont == FRAME_CONT_LIMITE) begin
                frame_cont <= 16'd0;

                // Movimento do obstáculo 1
                if (obs1_v_pos < ALTURA_TELA)
                    obs1_v_pos <= obs1_v_pos + VEL_OBS;
                else begin
                    obs1_v_pos <= OBS_POS_INI; // Reinicia no topo
                    obs1_h_pos <= 10'd120 + (next_random[7:0] % (LARGURA_TELA / 2 - 120 - OBS_LARGURA));
                end

                // Movimento do obstáculo 2
                if (obs2_v_pos < ALTURA_TELA)
                    obs2_v_pos <= obs2_v_pos + VEL_OBS;
                else begin
                    obs2_v_pos <= OBS_POS_INI; // Reinicia no topo
                    obs2_h_pos <= 10'd320 + (next_random[7:0] % (LARGURA_TELA / 2 - 120 - OBS_LARGURA));
                end
            end else begin
                frame_cont <= frame_cont + 1;
            end
        end
    end

endmodule
