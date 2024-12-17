module random_gen (
    input clk,
    input reset,
    output reg [7:0] rand_out // Usamos reg aqui porque a variável será modificada no bloco always
);
    reg [7:0] lfsr; // LFSR como um registro (reg) porque será modificado no bloco always

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 8'hFF; // Valor inicial (pode ser qualquer valor desejado)
        end else begin
            // Lógica do LFSR - Operação XOR entre os bits 7 e 5
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5]};
        end
    end

    // Atribuição contínua para rand_out (saída do LFSR)
    always @(*) begin
        rand_out = lfsr;
    end
endmodule
