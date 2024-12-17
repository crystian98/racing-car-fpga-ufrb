module vga_sync(
    input reset,
    input vga_clk,
    output reg blank_n,
    output reg HS,
    output reg VS,
    output reg [9:0] x,  // Coordenada horizontal (pixel_x)
    output reg [8:0] y   // Coordenada vertical (pixel_y)
);

    // Parâmetros de tempo de sincronização VGA
    parameter hori_line = 800;
    parameter vert_line = 525;
    parameter H_sync_cycle = 96;
    parameter V_sync_cycle = 2;
    parameter hori_back = 144;
    parameter vert_back = 34;
    parameter hori_front = 16;
    parameter vert_front = 11;

    reg [10:0] h_cnt;
    reg [9:0] v_cnt;
    wire cHD, cVD, cDEN;

    // Contadores horizontais e verticais
    always @(posedge vga_clk or posedge reset) begin
        if (reset) begin
            h_cnt <= 0;
            v_cnt <= 0;
        end else begin
            if (h_cnt == hori_line - 1) begin
                h_cnt <= 0;
                if (v_cnt == vert_line - 1)
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
            end else begin
                h_cnt <= h_cnt + 1;
            end
        end
    end

    assign cHD = (h_cnt < H_sync_cycle) ? 0 : 1;
    assign cVD = (v_cnt < V_sync_cycle) ? 0 : 1;

    assign cDEN = (h_cnt >= hori_back && h_cnt < (hori_line - hori_front)) &&
                  (v_cnt >= vert_back && v_cnt < (vert_line - vert_front));

    always @(posedge vga_clk) begin
        HS <= cHD;
        VS <= cVD;
        blank_n <= cDEN;
    end

    // Atualiza as coordenadas do pixel atual
    always @(posedge vga_clk) begin
        if (cDEN) begin
            x <= h_cnt - hori_back; // Coordenada horizontal
            y <= v_cnt - vert_back; // Coordenada vertical
        end else begin
            x <= 10'b0;
            y <= 10'b0;
        end
    end
endmodule
