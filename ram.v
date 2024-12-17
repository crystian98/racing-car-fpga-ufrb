// Módulo de memória RAM para armazenamento do frame buffer
module frame_buffer (
    input [18:0] endereco,   // Endereço de leitura e escrita (assumindo 640x480 de pixels)
    input [8:0] data_in,     // Dados de entrada (cor do pixel em 9 bits: 3 para R, G e B)
    input we,                // Sinal de escrita
    input clk,               // Clock
    output reg [8:0] data_out // Dados de saída (pixel lido em 9 bits)
);

    // Memória para armazenar 640x480 pixels (cada pixel é 9 bits)
    reg [8:0] mem [0:307199]; 

    always @(posedge clk) begin
        if (we) begin
            mem[endereco] <= data_in; // Escreve na memória
        end
        data_out <= mem[endereco];    // Lê da memória
    end

endmodule
