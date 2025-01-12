module Estados_tb;

// Declaração de sinais (Entradas e Saídas do módulo principal)
reg clk;
reg [3:0] numero;
reg reset;
reg insere;
wire ledErro;
wire [6:0] display;

// Instância do módulo a ser testado
Estados uut (
    .clk(clk),
    .numero(numero),
    .reset(reset),
    .insere(insere),
    .ledErro(ledErro),
    .display(display)
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

    // Monitoramento contínuo de variáveis
    $monitor("Time: %t | Estado: %b | Numero: %b | ledErro: %b | Display: %b", 
             $time, uut.estado_atual, numero, ledErro, display);

    // Passo 1: Resetar o sistema
    #10;  // Aguarda 10ns
    $display("Resetando o sistema...");
    reset = 0;  // Sai do reset

    // Passo 2: Inserir números na sequência correta
    #10; numero = 4'b0101; insere = 1;  // Inserindo 5
    $display("Inserindo numero: 5");
    #10; insere = 0;  // Aguarda o clock

    #10; numero = 4'b1001; insere = 1;  // Inserindo 9
    $display("Inserindo numero: 9");
    #10; insere = 0;

    #10; numero = 4'b0000; insere = 1;  // Inserindo 0
    $display("Inserindo numero: 0");
    #10; insere = 0;

    #10; numero = 4'b0110; insere = 1;  // Inserindo 6
    $display("Inserindo numero: 6");
    #10; insere = 0;

    #10; numero = 4'b0000; insere = 1;  // Inserindo 0
    $display("Inserindo numero: 0");
    #10; insere = 0;

    // Passo 3: Testar erro (número errado)
    #10; numero = 4'b0011; insere = 1;  // Inserindo número errado (3)
    $display("Inserindo numero errado: 3");
    #10; insere = 0;

    // Passo 4: Corrigir erro
    #10; numero = 4'b0000; insere = 1;  // Corrige inserindo o número correto
    $display("Corrigindo com numero correto: 0");
    #10; insere = 0;

    // Passo 5: Verificar comportamento em estado de falha
    #10; numero = 4'b1001; insere = 1;  // Inserindo outro número errado (9)
    $display("Inserindo numero errado: 9");
    #10; insere = 0;

    // Passo 6: Finalizar simulação
    #50;
    $display("Finalizando simulação...");
    $finish;
end

endmodule
