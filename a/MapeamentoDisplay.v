module MapeamentoDisplay(
    input [2:0] estado_atual,     // Estado atual da FSM
    input [2:0] posicao_atual,    // Posição atual na pista
    output reg [6:0] display      // Saída para o display de sete segmentos
);

    always @(*) begin
        case (estado_atual)
            3'b010: display = 7'b0110000; // Sucesso total -> S
            3'b011: display = 7'b0001100; // Sucesso parcial -> P
            3'b100: display = 7'b0000111; // Falha -> F
            default: begin
                // Mapeia posição na pista (0-5) para números no display
                case (posicao_atual)
                    0: display = 7'b1000000; // 0
                    1: display = 7'b1111001; // 1
                    2: display = 7'b0100100; // 2
                    3: display = 7'b0110000; // 3
                    4: display = 7'b0011001; // 4
                    5: display = 7'b0010010; // 5
                    default: display = 7'b1111111; // Apagado
                endcase
            end
        endcase
    end

endmodule