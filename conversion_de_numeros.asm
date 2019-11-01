ORG 100h 

JMP INICIO

;DEF DATOS
 
cantidad  DB 2
numero1 db ?
numero2 db ?
operacion db ?
valor1 DB ?
valor2 DB ?
base DB 1                                                                          
diez DB 10
nada DB 10 DUP (?) ;DUPLICA 10 VECES 0'S EN MEMORIA, ES PARA RESERVAR MEMORIA

;CODIGO

inicio:            
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Pido un numero
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov bx,offset numero1  ;el puntero apunta a la direccion de NUMERO1
    
    mov ah,1  ;Istruccion para leer el teclado

    sub cl,cl  ;cl es contador del ciclo
    
    ciclo:
        int 21h
        mov [bx],al ;Guarda en la direccion apuntada por el lo leido del teclado
        inc bx     ;incremento el puntero
        inc cl    ;incremento el contador
          
        cmp cl,cantidad ;Se fija si el largo de la cadena es igual a la cantidad de ciclos
        je agregar$          ;termina el ciclo si son iguales
        jmp ciclo        ;vuelve al inicio del ciclo
    
        agregar$:
            mov [bx],"$"     ;Imprime un signo pesos que indica el fin de la cadena
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Pido operacion
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    mov ah,1  ;Istruccion para leer el teclado    
    
    int 21h  
    mov operacion,al
 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Pido otro numero
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
                                                        
    mov bx,offset numero2  ;el puntero apunta a la direccion de NUMERO2
    mov ah,1  ;Istruccion para leer el teclado

    sub cl,cl  ;cl es contador del ciclo
    
    ciclo2:
        int 21h
        mov [bx],al ;Guarda en la direccion apuntada por el lo leido del teclado
        inc bx     ;incremento el puntero
        inc cl    ;incremento el contador
          
        cmp cl,cantidad ;Se fija si el largo de la cadena es igual a la cantidad de ciclos
        je agregar1$          ;termina el ciclo si son iguales
        jmp ciclo2        ;vuelve al inicio del ciclo
    
        agregar1$:
            mov [bx],"$"     ;Imprime un signo pesos que indica el fin de la cadena
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Covertir numero 1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                           
        sub cl, cl
        mov dx, offset numero1
        add bx, 1
       
    ciclo3: 
        mov al, [bx]
        sub al, 30h
        mul base
        add valor1, al
        mov al, base
        mul diez
        mov base, al
        dec bx
        inc cl
        cmp cl, cantidad
        je fin3
        jmp ciclo3
   fin3:
        
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Covertir numero 2
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                           
        sub cl, cl
        mov dx, offset numero2
        add bx, 1
    
    ciclo4: 
        mov al, [bx]
        sub al, 30h
        mul base
        add valor2, al
        mov al, base
        mul diez
        mov base, al
        dec bx
        inc cl        
        
        cmp cl, cantidad
        je fin4
        jmp ciclo4
   fin4:
        
  
ret
