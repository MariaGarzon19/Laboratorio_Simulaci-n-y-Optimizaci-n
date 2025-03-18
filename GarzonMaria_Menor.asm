.data
    msg1: .asciiz "Ingrese la cantidad de números (3-5): "
    msg2: .asciiz "Ingrese un número: "
    msg3: .asciiz "El número mayor es: "
    newline: .asciiz "\n"
    numbers: .word 0, 0, 0, 0, 0   # Espacio para almacenar hasta 5 números

.text
.globl main

main:
    # Mostrar mensaje para pedir cantidad de números
    li $v0, 4
    la $a0, msg1
    syscall

    # Leer la cantidad de números
    li $v0, 5
    syscall
    move $t0, $v0  # Guardar la cantidad en $t0

    # Validar que esté entre 3 y 5
    li $t1, 3
    blt $t0, $t1, exit  # Si es menor a 3, salir
    li $t1, 5
    bgt $t0, $t1, exit  # Si es mayor a 5, salir

    # Leer los números del usuario
    li $t2, 0  # Índice del arreglo
read_loop:
    li $v0, 4
    la $a0, msg2
    syscall

    li $v0, 5
    syscall
    sw $v0, numbers($t2)  # Guardar número en el arreglo

    addi $t2, $t2, 4  # Siguiente posición
    sub $t0, $t0, 1  # Reducir contador
    bgtz $t0, read_loop  # Repetir si quedan números por ingresar

    # Buscar el número mayor
    la $t2, numbers  # Dirección base del arreglo
    lw $t3, 0($t2)   # Inicializar con el primer número
    li $t4, 1        # Contador de iteraciones
find_max:
    lw $t5, 0($t2)  # Cargar número actual
    blt $t5, $t3, update_min  # Si es mayor, actualizar
    j next
update_min:
    move $t3, $t5  # Actualizar el número menor
next:
    addi $t2, $t2, 4  # Siguiente posición
    addi $t4, $t4, 1  # Aumentar contador
    blt $t4, 5, find_min  # Repetir si quedan elementos

    # Mostrar resultado
    li $v0, 4
    la $a0, msg3
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    # Salto de línea
    li $v0, 4
    la $a0, newline
    syscall

exit:
    li $v0, 10
    syscall  # Terminar programa
