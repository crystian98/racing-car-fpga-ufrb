module carro (
    input iVGA_CLK,
    input iRST_n,
    input reset_game,
    input Key0,        // Botões para mover o carro
    input Key1,
    output reg [9:0] car_h_pos, // Posição horizontal do carro
    output reg [8:0] car_v_pos  // Posição vertical do carro (corrigido para 9 bits)
);

    // Parâmetros
    parameter LARGURA_CARRO = 50;
    parameter PISTA_ESQUERDA = 120;   // Limite esquerdo da pista
    parameter PISTA_DIREITA = 520;   // Limite direito da pista
    parameter VEL_DESVIO = 5;        // Velocidade de movimento para os lados (pixels a cada comando)
    parameter FRAME_COUNT_LIMIT = 16'd50000; // Frequência de movimento

    reg [15:0] frame_counter;        // Contador de quadros para controle de movimento

    always @(posedge iVGA_CLK or negedge iRST_n) begin
        if (!iRST_n) begin
            // Reset assíncrono: Inicializa posições e contador
            frame_counter <= 16'd0;
            car_h_pos <= 10'd295;  // Centralizado horizontalmente
            car_v_pos <= 9'd400;   // Inicial vertical (agora com 9 bits)
        end else begin
            // Reset síncrono baseado em reset_game
            if (reset_game) begin
                frame_counter <= 16'd0;
                car_h_pos <= 10'd295;  // Centralizado horizontalmente
                car_v_pos <= 9'd400;   // Inicial vertical (agora com 9 bits)
            end else begin
                // Incrementa o contador de quadros
                if (frame_counter < FRAME_COUNT_LIMIT) begin
                    frame_counter <= frame_counter + 1; // Continua o contador
                end else begin
                    frame_counter <= 16'd0; // Reseta o contador

                    // Controle de movimento horizontal
                    if (Key1 && car_h_pos < (PISTA_DIREITA - LARGURA_CARRO)) begin
                        car_h_pos <= car_h_pos + VEL_DESVIO; // Mover para a direita
                    end 
                    else if (Key0 && car_h_pos > PISTA_ESQUERDA) begin
                        car_h_pos <= car_h_pos - VEL_DESVIO; // Mover para a esquerda
                    end
                end
            end
        end
    end
endmodule
