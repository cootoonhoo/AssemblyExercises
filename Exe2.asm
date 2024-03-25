.data 
	pergunta1: .asciiz "Digite o primeiro numero inteiro: " 
	pergunta2: .asciiz "Digite o segundo numero inteiro: "
	resposta: .asciiz " e maior que "
.text
	# Imprimindo a primeira pergunta
	li $v0, 4		# Informando ao sistema que iremos imprimir uma string
	la $a0, pergunta1	# Armazendo no argumento 0 qual string iremos imprimir
	syscall
	
	# Pegando o input do primeiro numero
	li $v0, 5		# Informando ao sistemas que iremos fazer uma leitura do stdin
	syscall
	
	# Salvando o input de n1
	move $t0, $v0		# Armazendo o valor de v0 em t0
	
	# Imprimindo a segunda pergunta
	li $v0, 4		# Informando ao sistema que iremos imprimir uma string
	la $a0, pergunta2	# Armazendo no argumento 0 qual string iremos imprimir
	syscall
	
	# Pegando o input do segundo numero
	li $v0, 5		# Informando ao sistemas que iremos fazer uma leitura do stdin
	syscall
	
	#Salvando o input de n2
	move $t1, $v0		# Armazendo o valor de v0 em t1
	
	# Lógica de validar o menor numero
	slt $t2, $t0, $t1	# Comparando se t0 < t1 
	bne $zero, $t2, True	# Vendo se o resultado do slt não é zero -> Se t2 = 0  t0 > t1, ao contrário t0 < t1
	
	# Caso em que t0 > t1
	li $v0, 1		# Informando ao sistemas que iremos printar um registrador
	move $a0,$t0		# Passando ao argumento qual registrador iremos printar (Nesse caso o maior vem primeiro, ou seja t0)
	syscall
	
	li $v0, 4		# Informando ao sistema que iremos imprimir uma string
	la $a0, resposta	# Armazendo no argumento 0 a string de resposta
	syscall
	
	li $v0, 1		# Informando ao sistemas que iremos printar um registrador
	move $a0,$t1		# Passando ao argumento qual registrador iremos printar(Nesse caso o menor vem depois, ou seja t1)
	syscall
	j Exit			# Indo para o final do programa para evitar entrar no label True
	
	# Caso em que t1 > t0
	True:			
	li $v0, 1		# Informando ao sistemas que iremos printar um registrador
	move $a0,$t1		# Passando ao argumento qual registrador iremos printar (Nesse caso o maior vem primeiro, ou seja t1)
	syscall
	li $v0, 4		# Informando ao sistema que iremos imprimir uma string
	la $a0, resposta	# Armazendo no argumento 0 a string de resposta
	syscall
	li $v0, 1		# Informando ao sistemas que iremos printar um registrador
	move $a0,$t0		# Passando ao argumento qual registrador iremos printar(Nesse caso o menor vem depois, ou seja t0)
	syscall
	Exit:
	
	
