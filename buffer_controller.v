module buffer_controller (
    input vsync,                 // Sinal de sincronização vertical
    input clk,                   // Clock
    output reg buffer_select,    // Sinal para selecionar o buffer ativo (0 ou 1)
    output reg write_enable,     // Habilita escrita no buffer inativo
    output reg read_enable       // Habilita leitura no buffer ativo
);

    // Registrador para detectar borda de subida do VSYNC
    reg vsync_last = 0;

    always @(posedge clk) begin
        // Detecta borda de subida do VSYNC
        if (vsync && !vsync_last) begin
            buffer_select <= ~buffer_select; // Alterna entre os buffers
        end
        vsync_last <= vsync;

        // Configura sinais de leitura e escrita
        write_enable <= ~buffer_select; // Habilita escrita no buffer inativo
        read_enable <= buffer_select;  // Habilita leitura no buffer ativo
    end
endmodule
