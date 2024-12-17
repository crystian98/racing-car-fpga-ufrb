module vga_controller(
    input iRST_n,
    input iVGA_CLK,
    input key0,             // Sinal de 1 bit para o primeiro switch
    input key1,             // Sinal de 1 bit para o segundo switch
    output reg oBLANK_n,
    output reg oHS,
    output reg oVS,
    output [7:0] b_data,
    output [7:0] g_data,
    output [7:0] r_data
);

    // Declarações internas
    wire [23:0] bgr_data;       // Dados RGB atuais (wire, não reg)
    wire [23:0] mem_pixel_data; // Dados RGB provenientes da memória RAM
    wire [9:0] car_h_pos;       // Posição horizontal do carro
    wire [8:0] car_v_pos;       // Posição vertical do carro
    wire [9:0] pixel_x;         // Coordenadas atuais do pixel
    wire [8:0] pixel_y;
    wire [9:0] obs1_h_pos;      // Posição horizontal do obstáculo 1
    wire [8:0] obs1_v_pos;      // Posição vertical do obstáculo 1
    wire [9:0] obs2_h_pos;      // Posição horizontal do obstáculo 2
    wire [8:0] obs2_v_pos;      // Posição vertical do obstáculo 2
    wire reset_game;

    // Wires intermediários para os sinais do vga_sync
    wire blank_n_wire;
    wire hs_wire;
    wire vs_wire;

    // Endereço da memória traduzido pelas coordenadas
    wire [18:0] endereco_memoria;

    // Instância do módulo de sincronização VGA
    vga_sync vs (
        .reset(~iRST_n),
        .vga_clk(iVGA_CLK),
        .blank_n(blank_n_wire),  // Conectado ao wire intermediário
        .HS(hs_wire),            // Conectado ao wire intermediário
        .VS(vs_wire),            // Conectado ao wire intermediário
        .x(pixel_x),
        .y(pixel_y)
    );

    // Lógica sequencial para atualizar os sinais reg com base nos wires intermediários
    always @(posedge iVGA_CLK or negedge iRST_n) begin
        if (!iRST_n) begin
            oBLANK_n <= 1'b0;
            oHS <= 1'b0;
            oVS <= 1'b0;
        end else begin
            oBLANK_n <= blank_n_wire;
            oHS <= hs_wire;
            oVS <= vs_wire;
        end
    end

    // Instância do módulo carro
    carro car_inst (
        .iVGA_CLK(iVGA_CLK),
        .iRST_n(iRST_n),
        .reset_game(reset_game),
        .Key0(key0),
        .Key1(key1),
        .car_h_pos(car_h_pos),
        .car_v_pos(car_v_pos)
    );

    // Instância do módulo dos obstáculos
    obstaculos obst_ctrl (
        .iVGA_CLK(iVGA_CLK),
        .reset_game(reset_game),
        .iRST_n(iRST_n),
        .obs1_h_pos(obs1_h_pos),
        .obs1_v_pos(obs1_v_pos),
        .obs2_h_pos(obs2_h_pos),
        .obs2_v_pos(obs2_v_pos)
    );

    // Instância do módulo de detecção de colisão
    collision_detection collision_inst (
        .car_h_pos(car_h_pos),
        .car_v_pos(car_v_pos),
        .obs1_h_pos(obs1_h_pos),
        .obs1_v_pos(obs1_v_pos),
        .obs2_h_pos(obs2_h_pos),
        .obs2_v_pos(obs2_v_pos),
        .reset_game(reset_game)  // Sinal de reset de jogo
    );

    // Instância do módulo drawer
    drawer drawer_inst (
        .x(pixel_x),                    // Coordenada horizontal do pixel
        .y(pixel_y),                    // Coordenada vertical do pixel
        .carro_h_pos(car_h_pos),        // Posição horizontal do carro
        .carro_v_pos(car_v_pos),        // Posição vertical do carro
        .obs1_v_pos(obs1_v_pos),        // Posição vertical do obstáculo 1
        .obs2_v_pos(obs2_v_pos),        // Posição vertical do obstáculo 2
        .obs1_h_pos(obs1_h_pos),        // Posição horizontal do obstáculo 1
        .obs2_h_pos(obs2_h_pos),        // Posição horizontal do obstáculo 2
        .pixel_data(bgr_data)           // Dados RGB gerados pelo drawer
    );

    // Instância do módulo de conversão de coordenadas para endereço
    coordenada_to_endereco addr_converter (
        .x(pixel_x),           // Coordenada horizontal
        .y(pixel_y),           // Coordenada vertical
        .endereco(endereco_memoria) // Endereço linear gerado
    );

    // Instância do módulo de memória RAM
    memoria_ram ram_inst (
        .endereco(endereco_memoria), // Endereço baseado nas coordenadas do pixel
        .data_in(bgr_data),          // Dados de entrada gerados pelo drawer
        .we(1'b1),                   // Escreve na memória em todos os ciclos
        .clk(iVGA_CLK),
        .data_out(mem_pixel_data)    // Dados RGB lidos da memória
    );

    // Atribui os dados RGB da memória ao barramento de saída
    assign b_data = mem_pixel_data[23:16];
    assign g_data = mem_pixel_data[15:8];
    assign r_data = mem_pixel_data[7:0];

endmodule
