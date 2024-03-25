.data
	vetor: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10	# Apenas um exemplo de vetor
	msgVetor: .asciiz "O vetor possui os seguintes elementos: "
	pergunta: .asciiz "\nDigite um numero inteiro : "
	msgTrue: .asciiz "Vetor alterado com sucesso!\n"
	msgFalse: .asciiz "Vetor nao alterado!\n"
	espaco: .asciiz " "
	
.text
	jal imprimirVetor		# Chama a função de imprimir o vetor
	
	li $v0, 4			# Informando ao sistema que iremos imprimir uma string
	la $a0, pergunta	# Armazendo no argumento 0 qual string iremos imprimir
	syscall
	
	# Pegando o input do numero inteiro
	li $v0, 5				# Informando ao sistemas que iremos fazer uma leitura do stdin
	syscall
	move $t1, $v0			# Armazendo o valor de v0 em t1
	
	addi $t2,$zero, 1		# Definindo o valor de t2 = 1
	beq $t2,$t1, True		# Comparando se t1 == 1
	# Se t1 != 1, não fazemos nada
		li $v0, 4			# Informando ao sistema que iremos imprimir uma string
		la $a0, msgFalse	# Armazendo no argumento 0 qual string iremos imprimir
		syscall
		j ExitBeq				
	
	True:
		li $v0, 4			# Informando ao sistema que iremos imprimir uma string
		la $a0, msgTrue		# Armazendo no argumento 0 qual string iremos imprimir
		syscall
		jal alteraValoresVetor
	ExitBeq:
	jal imprimirVetor
	j ExitProgram			# Vai para o fim do programa (Necessário para evitar que o programa entre em loop)

imprimirVetor:
	la $s0, vetor 			# Armzaena o registrador $s0 o endereço do vetor na posição 0
	li $v0, 4				# Informando ao sistema que iremos imprimir uma string
	la $a0, msgVetor		# Armazendo no argumento 0 qual string iremos imprimir
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
	# Considerando que 0 seja um numero par e que o vetor começa na posição 0. Os valores que irão receber 5 será vetor[0], vetor[2], vetor[4] ...
	
	la $s0, vetor 			# Armzaena o registrador $s0 o endereço do vetor na posição 0
	lw $t0, ($s0)			# Carregando o primeiro elemento de vetor para t0
	addi $t8, $zero, 0 		# Setando o nosso contador(t8) para 0
	addi $t7, $zero, 0 		# Setando a variável auxiliar para 0 (Ela vai definir se iremos igualar a 5 o elemento do vetor)
	
	LoopA:
	slti $t9, $t8, 10        # Verifica se o contador é menor que 10
	beq $t9, $zero,ExitLoopA# Se contador > 10, sai do loop
	
	andi $t6, $t8, 1        # Guarda em t6 se o indice é par (Se t8 impar => t6 = 1; Se t8 par => t6 = 0)
	beq $t6, $zero, Par  # Se for par, vá para notPar
	
	addi $s0, $s0, 4        # Incrementa o ponteiro do vetor para apontar para o próximo elemento
    lw $t0, ($s0)           # Carrega o próximo elemento do vetor
    addi $t8, $t8, 1        # Incrementa o contador
    j LoopA                 # Retorna ao início do loop
    
    Par:
    li $t9, 5               # Carrega o valor 5 em $t9
    sw $t9, ($s0)           # Armazena 5 no elemento atual do vetor
    addi $s0, $s0, 4        # Incrementa o ponteiro do vetor para o próximo elemento
    lw $t0, ($s0)           # Carrega o próximo elemento do vetor
    addi $t8, $t8, 1        # Incrementa o contador
    j LoopA                 # Retorna ao início do loop	

	ExitLoopA:
    jr $ra                  # Retorna ao programa

ExitProgram:
