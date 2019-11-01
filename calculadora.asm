ORG 100h 

JMP INICIO

;DEF DATOS
 
CANTIDAD  DB 2
NUMERO1 db ?
NUMERO2 db ?
operacion db ?
VALOR1 DB ?
VALOR2 DB ?
BASE DB 1                                                                          
DIEZ DB 10
NADA DB 10 DUP (?) ;DUPLICA 10 VECES 0'S EN MEMORIA, ES PARA RESERVAR MEMORIA

;CODIGO

inicio:            
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Pido un numero
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov bx,offset NUMERO1  ;el puntero apunta a la direccion de NUMERO1
    
    mov ah,1  ;Istruccion para leer el teclado

    sub cl,cl  ;cl es contador del ciclo
    
    ciclo:
        int 21h
        mov [bx],al ;Guarda en la direccion apuntada por el lo leido del teclado
        inc bx     ;incremento el puntero
        inc cl    ;incremento el contador
          
        cmp cl,CANTIDAD ;Se fija si el largo de la cadena es igual a la cantidad de ciclos
        je agregar$          ;termina el ciclo si son iguales
        jmp ciclo        ;vuelve al inicio del ciclo
    
        agregar$:
            mov [bx],"$"     ;Imprime un signo pesos que indica el fin de la cadena
            mov ah,09h
            mov dx,offset NUMERO1
            int 21h           
    
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Pido operacion
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    mov ah,1  ;Istruccion para leer el teclado    
    
    int 21h  
    mov operacion,al
 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;                     Pido otro numero
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
                                                        
    mov bx,offset NUMERO2  ;el puntero apunta a la direccion de NUMERO2
    mov ah,1  ;Istruccion para leer el teclado

    sub cl,cl  ;cl es contador del ciclo
    
    ciclo:
        int 21h
        mov [bx],al ;Guarda en la direccion apuntada por el lo leido del teclado
        inc bx     ;incremento el puntero
        inc cl    ;incremento el contador
          
        cmp cl,CANTIDAD ;Se fija si el largo de la cadena es igual a la cantidad de ciclos
        je agregar$          ;termina el ciclo si son iguales
        jmp ciclo        ;vuelve al inicio del ciclo
    
        agregar$:
            mov [bx],"$"     ;Imprime un signo pesos que indica el fin de la cadena
            mov ah,09h
            mov dx,offset NUMERO1
            int 21h
    
ret
