`timescale 1ns / 1ps  // Define o tempo de simulação (1ns unidade, 1ps precisão)

module Estados_tb;

// Declaração de sinais (Entradas e Saídas do módulo principal)
reg clk;
reg [3:0] numero;
reg reset;
reg insere;
wire ledErro;
wire [1:0] displayEstado;

// Instância do módulo a ser testado
Estados uut (  // "uut" significa Unit Under Test
    .clk(clk),
    .numero(numero),
    .reset(reset),
    .insere(insere),
    .ledErro(ledErro),
    .displayEstado(displayEstado)
);

// Geração do clock (sempre alternando entre 0 e 1)
always #5 clk = ~clk;  // Clock com período de 10ns

// Procedimento de teste
initial begin
    // Inicializa os sinais
    clk = 0;
    reset = 1;
    insere = 0;
    numero = 4'b0000;

    // Passo 1: Resetar o sistema
    #10;  // Aguarda 10ns
    reset = 0;  // Sai do reset

    // Passo 2: Inserir números na sequência correta
    #10; numero = 4'b0101; insere = 1;  // Inserindo 5
    #10; insere = 0;                    // Aguarda o clock

    #10; numero = 4'b1001; insere = 1;  // Inserindo 9
    #10; insere = 0;

    #10; numero = 4'b0000; insere = 1;  // Inserindo 0
    #10; insere = 0;

    #10; numero = 4'b0110; insere = 1;  // Inserindo 6
    #10; insere = 0;

    #10; numero = 4'b0000; insere = 1;  // Inserindo 0
    #10; insere = 0;

    // Passo 3: Testar erro (número errado)
    #10; numero = 4'b0011; insere = 1;  // Inserindo número errado (3)
    #10; insere = 0;

    // Passo 4: Corrigir erro
    #10; numero = 4'b0000; insere = 1;  // Corrige inserindo o número correto
    #10; insere = 0;

    // Passo 5: Verificar comportamento em estado de falha
    #10; numero = 4'b1001; insere = 1;  // Inserindo outro número errado (9)
    #10; insere = 0;

    // Passo 6: Finalizar simulação
    #50;
    $finish;
end

endmodule