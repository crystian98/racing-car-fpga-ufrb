module color_converter(
    input [8:0] pixel_9bit,  // Cor de 9 bits de entrada
    output reg [23:0] pixel_24bit  // Cor de 24 bits de saída
);

    always @(*) begin
        case (pixel_9bit)
            // Verde (R=0, G=4, B=0)
            9'b000_100_000: pixel_24bit = 24'h00_66_00;
            // Cinza (R=2, G=2, B=2)
            9'b010_010_010: pixel_24bit = 24'h33_33_33;
            // Marrom (R=4, G=2, B=1)
            9'b100_010_001: pixel_24bit = 24'h66_33_19;
            // Branco (R=7, G=7, B=7)
            9'b111_111_111: pixel_24bit = 24'hFF_FF_FF;
            // Preto (R=0, G=0, B=0)
            9'b000_000_000: pixel_24bit = 24'h00_00_00;
            // Vermelho (R=7, G=0, B=0)
            9'b111_000_000: pixel_24bit = 24'hFF_00_00;
            // Azul (R=0, G=0, B=7)
            9'b000_000_111: pixel_24bit = 24'h00_00_FF;
            // Default
            default: pixel_24bit = 24'h00_00_00; //preto por pdrão
        endcase
    end

endmodule
