module frame_buffer (
    input [18:0] endereco,      // Endereço de leitura/escrita
    input [8:0] data_in,        // Dados de entrada (cor do pixel)
    input write_enable,         // Habilita escrita
    input read_enable,          // Habilita leitura
    input clk,                  // Clock
    output reg [8:0] data_out   // Dados de saída 
);

    // Memória para armazenar 640x480 pixels 
    reg [8:0] mem [0:307199];

    always @(posedge clk) begin
        if (write_enable) begin
            mem[endereco] <= data_in; // Escreve na memória
        end
        if (read_enable) begin
            data_out <= mem[endereco]; // Lê da memória
        end
    end
endmodule
