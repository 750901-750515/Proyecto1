# ALGORITMO DE LA SOLUCIÓN DE LAS TORRES DE HANOI EN RISC-V
# JUAN PABLO FIGUEROA MARTÍN 750901
# LUIS PABLO DE LOS REYES RENTERÍA 750515


.text
	addi s4,zero, 0x5 # Inicializa la variable s4 con el número de discos
	addi t3,zero, 0x20 # Define un OFFSET de 32 bytes para el espacio entre discos
	mul t3,t3, s4 # Calcula el desplazamiento total para la posición del disco inferior
	lui s5,0x10020 # Carga la dirección base de la torre A (fuente) en s5
	addi s6,s5,0x4 # Establece la dirección de la torre B (auxiliar) en s6
	addi s7,s5,0x8 # Establece la dirección de la torre C (destino) en s7
	add s6,s6,t3 # Ajusta la dirección de la parte inferior de la torre B
	add s7,s7,t3 # Ajusta la dirección de la parte inferior de la torre C
	
bucle:	blt t2,s4,acomodar # Si t2 (número de discos acomodados) es menor que N, procede a acomodar discos
	lui s5,0x10020 # Restaura el puntero a la torre A (fuente)
	jal resolverTorresDeHanoi # Llama a la función resolverTorresDeHanoi
	jal exit # Finaliza el programa
	
acomodar:
	addi t2,t2,0x1 # Incrementa t2 para acomodar el siguiente disco en la torre A
	sw t2, 0x0(s5) # Almacena el disco en la parte superior de la torre A
	addi s5,s5,0x20 # Mueve el puntero de la torre A a la siguiente posición
	jal bucle # Regresa al bucle principal
	
resolverTorresDeHanoi:
	addi t2,zero,0x1 # Inicializa t2 con 1 para la condición de caso base
	beq s4,t2,mover # Si N es igual a 1, salta a mover
	
	addi sp,sp,-0x4 # Reserva espacio en la pila para almacenar la dirección de retorno (RA) y N
	sw ra, 0x0(sp) # Guarda la dirección de retorno en la pila
	addi sp,sp,-0x4
	sw s4,0x0(sp) # Guarda el valor de N en la pila
	addi s4,s4,-0x1 # Decrementa N en 1 para la llamada recursiva
	add t1,s6,zero # Almacena la dirección de la torre B (aux) en t1
	add s6,s7,zero # Copia la dirección de la torre C (dest) en s6
	add s7,t1,zero # Mueve el valor de t1 (torre B) a s7 (para ser usado como auxiliar)
	
	jal resolverTorresDeHanoi # Llama recursivamente a resolverTorresDeHanoi
	
	add t1,s6,zero # Almacena la dirección de la torre B (aux) en t1
	add s6,s7,zero # Copia la dirección de la torre C (dest) en s6
	add s7,t1,zero # Mueve el valor de t1 (torre B) a s7 (para ser usado como auxiliar)
	lw s4,0x0(sp) # Restaura el valor de N desde la pila
	addi sp,sp,0x4
	lw ra,0x0(sp) # Restaura la dirección de retorno desde la pila
	addi sp,sp,0x4
	sw zero,0x0(s5) # Limpia la parte superior de la torre A (marca el disco como movido)
	addi s5,s5,0x20 # Mueve el puntero de la torre A hacia abajo
	addi s7,s7,-0x20 # Mueve el puntero de la torre C hacia arriba (nuevo disco agregado)
	sw s4, 0x0(s7) # Coloca el disco en la parte superior de la torre C
	addi sp,sp,-0x4 # Reserva espacio en la pila para la dirección de retorno (RA) y N
	sw ra,0x0(sp) # Guarda la dirección de retorno en la pila
	addi sp, sp,-0x4
	sw s4,0x0(sp) # Guarda el valor de N en la pila
	addi s4,s4,-0x1 # Decrementa N en 1 para la llamada recursiva
	add t1,s5,zero # Almacena la dirección de la torre A en t1
	add s5,s6,zero # Copia la dirección de la torre B (aux) a s5
	add s6,t1,zero # Mueve el valor de t1 (torre A) a s6 (para ser usado como auxiliar)
	jal resolverTorresDeHanoi # Llama recursivamente a resolverTorresDeHanoi
	add t1,s5,zero # Almacena la dirección de la torre B en t1
	add s5,s6,zero # Copia la dirección de la torre C a s5
	add s6,t1,zero # Mueve el valor de t1 (torre B) a s6 (para ser usado como auxiliar)
	
	lw s4,0x0(sp) # Restaura el valor de N desde la pila
	addi sp,sp,0x4
	lw ra,0x0(sp) # Restaura la dirección de retorno desde la pila
	addi sp,sp, 0x4
	jalr ra # Regresa a la dirección almacenada en RA
mover:
	sw zero,0x0(s5) # Limpia la parte superior de la torre B (marca el disco como movido)
	addi s5,s5,0x20 # Mueve el puntero de la torre B hacia abajo
	addi s7,s7,-0x20 # Mueve el puntero de la torre C hacia arriba (nuevo disco agregado)
	sw s4,0x0(s7) # Coloca el disco en la parte superior de la torre C		
	jalr ra # Regresa a la dirección almacenada en RA
exit: nop
