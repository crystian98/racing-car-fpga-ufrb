module buffer_mux (
    input [18:0] endereco,        // Endereço de acesso
    input [8:0] data_in,          // Dados de entrada (para escrita)
    input buffer_select,          // Seleciona o buffer ativo
    output [18:0] endereco_out,   // Endereço selecionado
    output [8:0] data_out         // Dados selecionados
);

    assign endereco_out = endereco;  // Endereço permanece o mesmo
    assign data_out = data_in;       // Dados permanecem os mesmos (simples para ilustrar)
endmodule
