module Estados(
    // Entradas
    input clk,                      // Clock
    input [3:0] numero,             // Número da pista
    input reset,                    // Sinal de reset
    input insere,                   // Sinal acionado na inserção de cada novo número
    
    // Saídas
    output ledErro,                 // LED que demonstra erro
    output [6:0] display            // Display de sete segmentos
);

// Declaração de estados
localparam [2:0] 
    estado_inicial = 3'b000,
    estado_verificacao = 3'b001,
    estado_sucesso_total = 3'b010,
    estado_sucesso_parcial = 3'b011,
    estado_falha = 3'b100;

// Variáveis internas
reg [2:0] estado_atual, prox_estado; // prox_estado agora será controlado no always
reg [2:0] posicao_atual;             // Para controlar em qual casa da pista está o robô
reg erro_ocorrido;                   // Indica se houve erro na sequência
wire [2:0] prox_estado_wire;         // Wire para receber a saída do VerificacaoErro

// Sequência esperada da pista (590060)
wire [23:0] pista = 24'b0101_1001_0000_0000_0110_0000;

// Instância do módulo de verificação de erros
VerificacaoErro verificador (
    .estado_atual(estado_atual),
    .numero(numero),
    .posicao_atual(posicao_atual),
    .pista(pista),
    .erro_ocorrido(ledErro),
    .prox_estado(prox_estado_wire)   // Conecta ao wire
);

// Instância do mapeador do display
MapeamentoDisplay mapeador (
    .estado_atual(estado_atual),
    .posicao_atual(posicao_atual),
    .display(display)
);

// Controle do estado atual
always @(posedge clk or posedge reset) begin
    if (reset) begin
        estado_atual <= estado_inicial;
        posicao_atual <= 0;
    end else if (insere) begin
        estado_atual <= prox_estado_wire; // Atualiza prox_estado a partir do wire

        // Avança a posição apenas se estiver no estado de verificação e não houver erro
        if (estado_atual == estado_verificacao && !ledErro)
            posicao_atual <= posicao_atual + 1;
    end
end

endmodule