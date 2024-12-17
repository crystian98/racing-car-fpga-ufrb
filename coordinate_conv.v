module coordenada_to_endereco(
    input [9:0] x,   // Coordenada horizontal (0 a 639)
    input [8:0] y,   // Coordenada vertical (0 a 479)
    output [18:0] endereco // Endereço linear (0 a 307199)
);
    assign endereco = y * 640 + x;
endmodule
