.data 
dividendo:
	.asciiz "Digite o dividendo: "
divisor:
	.asciiz "Digite o divisor: "
nova_linha:
	.asciiz "\n"
quociente:
	.asciiz "Quociente = "
resto:
	.asciiz "Resto     = "
	
divisao_invalido:
	.asciiz "Nao é possivel realizar essa divisao"	
	
.text

.globl main

main:

li $v0, 4
la $a0, dividendo
syscall

li $v0, 5 #Dividendo
syscall
move $a1,$v0

li $v0, 4
la $a0, divisor
syscall

li $v0, 5 #Divisor
syscall
move $a2,$v0

beq $a2,0,invalido#dividor=0 vai para invalido

move $s6,$a1 #variavel auxiliar para dividendo
move $s7,$a2 #variavel auxiliar para divisor

complemento_de_2:

slti $t1,$a1,0 #t1=0 se s0<zer0
beq $t1,1,dividendo_negativo #se t1=1 vai para dividendo_negativo para transformar em um positivo
j verifica_divisor

dividendo_negativo:#faz complemento de 2 no divisor
not $a1,$a1
addi $a1,$a1,1


verifica_divisor:#verifica se divisor é negativo para complemento de 2
slti $t1,$a2,0 #t1=0 se s0<zer0
beq $t1,1,divisor_negativo #se t1=1 vai para divisor_negativo para transformar em um positivo
j divfac

divisor_negativo:
not $a2,$a2
addi $a2,$a2,1
j divfac

exit:#função para printar resultado

bgt $s6,0,nega_quociente#se s6>0 vai para negar_quociente (dividendo maior que 0)
mul $s0,$s0,-1 #muda sinal do quociente
mul $s1,$s1,-1 #muda sinal do resto

nega_quociente:
bgt $s7,0,resultado#se s7>0 vai para resultado sem mudar sinal do quociente(divisor maior que 0)
mul $s0,$s0,-1 #muda sinal do quociente

resultado:
mthi $s1  #coloca o valor do resto no registrador hi
#mfhi $t0  #coloca o valor do hi em t0

mtlo $s0  #coloca o valor do quociente no registrador lo
#mflo $t1  #coloca o valor do lo em t1

li $v0, 4
la $a0, quociente
syscall

move $a0,$s0 
li $v0,1
syscall #imprime quociente

li $v0, 4
la $a0, nova_linha
syscall

li $v0, 4
la $a0, resto
syscall

move $a0,$s1
li $v0,1
syscall #imprime resto

li $v0, 4
la $a0, nova_linha
syscall

li $v0,10
syscall # return 0

divfac:

add $s1,$zero,$zero #32 bits mais significativo
add $s0,$zero,$a1 #32 bits menos significativo 

sll $s0,$s0,1 #desloca o resto 1x para a esquerda
add $s3,$zero,$zero #salva o menos significativo em um auxiliar

addi $s4,$zero,0# inicializa o registrador em 1

passo3:
addi $s4,$s4,1# incrementa o registrador em 1
slti $t5,$s4,33
beq  $t5,$zero,passo6

sub $s1,$s1,$a2 #subtrai dividor ao resto nos 32 mais significativo

slti $t0,$s1,0 #t0=1 se resto<0
beq  $t0,1,passo4_2# vai para passo4.2 se t0=1
#se t0!=0

slti $t1,$s0,0 #t1=0 se s0<zer0
beq $t1,1,desloca_e_soma1 #se t1 !=0 vai para passa1

#se t1=0
sll $s0,$s0,1 #desloca registrador menos significativo para esquerda
sll $s1,$s1,1 #desloca registrador mais significativo para esquerda
addi $s0,$s0,1 #soma 1 ao registrador menos significativo
addi $s3,$s1,0 #conserva mais significativo em uma variavel
j passo3

desloca_e_soma1:
sll $s0,$s0,1 #desloca registrador menos significativo para esquerda
sll $s1,$s1,1 #desloca registrador mais significativo para esquerda
addi $s0,$s0,1 #soma 1 ao registrador menos significativo
addi $s1,$s1,1 #soma 1 ao registrador mais significativo
addi $s3,$s1,0 #conserva mais significativo em uma variavel
j passo3

passo4_2:  #conserva o mais signifcativo e desloca q bit a esquerda o resto
move $s1,$s3#conserva o mais significativo

slti $t1,$s0,0 #t1=1 se s0<zer0
beq $t1,1,desloca #se t1 !=0 vai para passa1

#se o menos siginificativo for >=0
sll $s0,$s0,1 #desloca registrador menos significativo para esquerda
sll $s1,$s1,1 #desloca registrador mais significativo para esquerda
addi $s3,$s1,0 #conserva mais significativo em uma variavel
j passo3 #retorna a função divfac

desloca:  #passa 1 do ultimo bit do registrador menos significativo para o registrador mais significativo
sll $s0,$s0,1 #desloca registrador menos significativo para esquerda
sll $s1,$s1,1 #desloca registrador mais significativo para esquerda
addi $s1,$s1,1 #soma 1 ao registrador mais significativo
addi $s3,$s1,0 #conserva mais significativo em uma variavel
j passo3 #retorna a função divfac

passo6:

srl $s1,$s1,1# move 1 bit a direita o mais significativo

j exit

invalido:

li $v0, 4
la $a0, nova_linha
syscall

li $v0, 4
la $a0, divisao_invalido
syscall

li $v0, 4
la $a0, nova_linha
syscall

li $v0,10
syscall # return 0