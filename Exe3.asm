.data
	vetor: .word
	msgVetor: .asciiz "Digite 10 numeros inteiros para preencher o vetor:\n"
	msgImprimeVetor: .asciiz "Elementos do vetor:\n"
	pergunta: .asciiz "\nDigite um numero inteiro : "
	espaco: .asciiz " "
.text
	jal GravarVetor
	
	li $v0, 4               # Informamos ao sistema que vamos imprimir uma mensagem para o usuário
    la $a0, pergunta		# Armazendo no argumento 0 qual string iremos imprimir
    syscall
	
	li $v0, 5				# Informando ao sistemas que iremos fazer uma leitura do stdin
	syscall
	
	move $t3, $v0			# Salvando o input em t3
	
	jal alteraValoresVetor  # Inicia a função de alterar os valores do vetor	
	jal imprimirVetor		# Imprime o vetor para comprar com os inputs
	j ExitProgram			# Vai para exit program para evitar qualquer código replicar indesejadamente
	
GravarVetor:
	li $v0, 4               # Informamos ao sistema que vamos imprimir uma mensagem para o usuário
    la $a0, msgVetor		# Armazendo no argumento 0 qual string iremos imprimir
    syscall

	la $s0, vetor           # Carrega o endereço inicial do vetor em s0
	li $t8, 0               # Inicializa o contador para 0
	
	LoopGravacao:
	slti $t9, $t8, 10       # Verifica se o contador é menor que 10
	beq $t9, $zero,ExitGrv 	# Se contador >= 10, sai do loop
	
	li $v0, 5				# Informando ao sistemas que iremos fazer uma leitura do stdin
	syscall
	
	move $t1, $v0          # Move o valor lido para $t1
	sw $t1, ($s0)          # Armazena o valor lido no vetor
	addi $s0, $s0, 4       # Incrementa o registrador do vetor para apontar para o próximo elemento
	addi $t8, $t8, 1       # Incrementa o contador
    j LoopGravacao         # Retorna ao início do loop
	
	ExitGrv:
    jr $ra                 # Retorna ao programa principal
    
    
imprimirVetor:
	la $s0, vetor 			# Armzaena o registrador $s0 o endereço do vetor na posição 0
	
	li $v0, 4				# Informando ao sistema que iremos imprimir uma string
	la $a0, msgImprimeVetor	# Armazendo no argumento 0 qual string iremos imprimir
	syscall

	lw $t0, ($s0)			# Carregando o primeiro elemento de vetor para t0
	addi $t8, $zero, 0 		# Setando o nosso contador(t8) para 0
	
	Loop:
	slti $t9,$t8,10			# Verificia se o contador(t8) é menor do que 0 => Se true(1), continua o loop; Se false(1) já percorremos todo o array, podemos sair 
	beq $t9,$zero, ExitLoop	# Compara o resultado de t8 < 10; Se 1 -> Continuamos no loop; Se 0 -> Podemos sair
	
	li $v0, 1				# Informando ao sistemas que iremos printar um registrador
	move $a0,$t0			# Passando ao argumento qual registrador iremos printar
	syscall
	
	# Impressão do espaco para ficar mais simples de entender
	li $v0, 4				# Informando ao sistema que iremos imprimir uma string
	la $a0, espaco			# Armazendo no argumento 0 qual string iremos imprimir
	syscall
	
	addi $s0,$s0,4			# Incrementa o registrador do vetor para apontar para o próximo elemento
	lw $t0, ($s0)        	# Carrega o próximo elemento do vetor e guardea ele em $t0
	addi $t8, $t8, 1     	# Incrementa o contador
	j Loop               	# Retorna ao início do loop

	ExitLoop:
	jr $ra 					# Retorna para o programa principal/ sai da função
   
alteraValoresVetor:	
	la $s0, vetor           # Endereço do vetor
	lw $t0, ($s0)           # Carrega o primeiro elemento do vetor para $t0
    lw $t1, 12($s0)         # Carrega o terceiro elemento do vetor para $t1
    li $t5, 1               # Valor para atualizar posições ímpares
    li $t6, 2               # Valor para atualizar posições pares
    addi $t8, $zero, 0 		# Setando o nosso contador(t8) para 0
    slt $t4, $t3, $t1       # Compara se o número lido é menor que o terceiro elemento do vetor (Se t4 == 1, t3 <  t1)
	
	LoopAltera:
	slti $t9, $t8, 10       		# Verifica se o contador é menor que 10
	beq $t9, $zero, ExitLoopAltera  # Se contador >= 10, sai do loop
	
	andi $t7, $t8, 1        # Verifica se o índice é par ou ímpar. (Se t8 impar => t7 = 1; Se t8 par => t7 = 0)
	beq $t7, $zero, Par     # Se o indice for par, vá para Par
	
	bne $t4,$zero, Continue # Se $t4 != 0(Ou seja, input < v[3]), significa que devemos alterar apenas posições pares e aqui estamos dentro das impares
	sw $t5, ($s0)           # Atualiza a posição ímpar com o valor de $t5
    j Continue              # Continua o loop
    
    Par:
    beq $t4,$zero, Continue # Se $t4 == 0(Ou seja, input > v[3]), significa que devemos alterar apenas posições impares e aqui estamos dentro das pares
    sw $t6, ($s0)           # Atualiza a posição par com o valor de $t6
    
    Continue:
    addi $s0, $s0, 4        # Incrementa o ponteiro do vetor para apontar para o próximo elemento
    addi $t8, $t8, 1        # Incrementa o contador
    lw $t0, ($s0)           # Carrega o próximo elemento do vetor
    j LoopAltera            # Retorna ao início do loop
	   
	ExitLoopAltera:
    jr $ra                  # Retorna ao programa
   
ExitProgram: