module VerificacaoErro(
    input [2:0] estado_atual,     // Estado atual da FSM
    input [3:0] numero,           // Número inserido
    input [2:0] posicao_atual,    // Posição atual na pista
    input [23:0] pista,           // Sequência esperada da pista
    output reg erro_ocorrido,     // Sinaliza se houve erro
    output reg [2:0] prox_estado  // Próximo estado
);

    always @(*) begin
        erro_ocorrido = 0;
        prox_estado = estado_atual;

        case (estado_atual)
            3'b000: begin // Estado inicial
                prox_estado = 3'b001; // Vai para verificação
            end

            3'b001: begin // Estado de verificação
                // Compara o número atual com o esperado
                if (numero != pista[23 - posicao_atual*4 -: 4]) begin
                    erro_ocorrido = 1;
                    prox_estado = (estado_atual == 3'b011) ? 3'b100 : 3'b011; // Falha ou sucesso parcial
                end else if (posicao_atual == 5) begin
                    prox_estado = 3'b010; // Sucesso total
                end
            end

            default: prox_estado = estado_atual;
        endcase
    end

endmodule