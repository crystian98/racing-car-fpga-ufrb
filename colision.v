module collision_detection(
    input [9:0] car_h_pos,        
    input [8:0] car_v_pos, 
    input [9:0] obs1_h_pos,
    input [8:0] obs1_v_pos, 
    input [9:0] obs2_h_pos,    
    input [8:0] obs2_v_pos, 
    output reg reset_game       
);

    always @(*) begin
        // Inicializa o sinal de reset
        reset_game = 1'b0;

        // Verifica colisão com o obstáculo 1
        if ((car_h_pos >= obs1_h_pos && car_h_pos < (obs1_h_pos + 50)) &&
            (car_v_pos >= obs1_v_pos && car_v_pos < (obs1_v_pos + 50))) begin
            reset_game = 1'b1;  // Colisão detectada com o obstáculo 1
        end

        // Verifica colisão com o obstáculo 2
        if ((car_h_pos >= obs2_h_pos && car_h_pos < (obs2_h_pos + 50)) &&
            (car_v_pos >= obs2_v_pos && car_v_pos < (obs2_v_pos + 50))) begin
            reset_game = 1'b1;  // Colisão detectada com o obstáculo 2
        end
    end

endmodule
