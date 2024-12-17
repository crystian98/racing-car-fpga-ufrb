module obstaculos(
    input iVGA_CLK,          // Clock VGA (25 MHz)
    input reset_game,
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
    parameter FRAME_CONT_LIMITE = 16'd40000; // Contador para redução de frequência

    reg [15:0] frame_cont;         // Contador de quadros para controlar a frequência do movimento
    reg [1:0] faixa_obs1, faixa_obs2; // Faixa onde os obstáculos são gerados (0, 1, 2)

    // LFSR para gerar números pseudo-aleatórios
    reg [15:0] lfsr;               // LFSR de 16 bits
    wire feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]; // Tap para gerar nova saída

    always @(posedge iVGA_CLK or negedge iRST_n) begin
        if (!iRST_n) begin
            // Reset assíncrono: Inicializa posições, contador e LFSR
            frame_cont <= 16'd0;
            obs1_v_pos <= OBS_POS_INI;
            obs2_v_pos <= OBS_POS_INI;
            faixa_obs1 <= 2'b00; // Faixa 0 para obstáculo 1
            faixa_obs2 <= 2'b10; // Faixa 2 para obstáculo 2
            obs1_h_pos <= 10'd120; // Posição inicial obstáculo 1
            obs2_h_pos <= 10'd320; // Posição inicial obstáculo 2
            lfsr <= 16'hACE1; // Valor inicial do LFSR
        end else begin
            if (reset_game) begin
                // Reset síncrono baseado em reset_game
                frame_cont <= 16'd0;
                obs1_v_pos <= OBS_POS_INI;
                obs2_v_pos <= OBS_POS_INI;
                faixa_obs1 <= 2'b00; // Faixa 0 para obstáculo 1
                faixa_obs2 <= 2'b10; // Faixa 2 para obstáculo 2
                obs1_h_pos <= 10'd120; // Posição inicial obstáculo 1
                obs2_h_pos <= 10'd320; // Posição inicial obstáculo 2
                lfsr <= 16'hACE1; // Valor inicial do LFSR
            end else begin
                // Atualiza o LFSR a cada ciclo
                lfsr <= {lfsr[14:0], feedback};

                // Incrementa o contador de quadros
                if (frame_cont == FRAME_CONT_LIMITE) begin
                    frame_cont <= 16'd0;

                    // Movimenta o obstáculo 1 para baixo
                    if (obs1_v_pos < ALTURA_TELA)
                        obs1_v_pos <= obs1_v_pos + VEL_OBS;
                    else begin
                        obs1_v_pos <= OBS_POS_INI; // Reinicia no topo
                        faixa_obs1 <= lfsr[1:0]; // Gera nova faixa aleatória para obs1
                        // Gera nova posição horizontal aleatória dentro da faixa
                        obs1_h_pos <= 10'd120 + (lfsr[7:0] % (LARGURA_TELA / 2 - 120 - OBS_LARGURA));
                    end

                    // Movimenta o obstáculo 2 para baixo
                    if (obs2_v_pos < ALTURA_TELA)
                        obs2_v_pos <= obs2_v_pos + VEL_OBS;
                    else begin
                        obs2_v_pos <= OBS_POS_INI; // Reinicia no topo
                        faixa_obs2 <= lfsr[3:2]; // Gera nova faixa aleatória para obs2
                        // Gera nova posição horizontal aleatória dentro da faixa
                        obs2_h_pos <= 10'd320 + (lfsr[7:0] % (LARGURA_TELA / 2 - 120 - OBS_LARGURA));
                    end
                end else begin
                    frame_cont <= frame_cont + 1;
                end
            end
        end
    end

endmodule
