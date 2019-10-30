org 100h  

jmp inicio

;Definimos el mapa


rangoDeAleatorio db 2    ;Con esto fijamos entre que valores obtenemos el resultado de aleatorio

mapaArriba db "00..........................WAR GAMES - 1983..............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"07........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"08..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo db "09..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"10..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"11..............-+++++++++:...........+:+::+................--.....---....",10,13,"12................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"13.................++::+-.............::++:..:...............++++++++-....",10,13,"14.................:++:-...............::-..................-+:--:++:.....",10,13,"15.................:+-............................................-.....--",10,13,"16.................:....................................................--",10,13,"17.......UNITED STATES.........................SOVIET UNION...............",10,13,"17........................................................................",10,13,"18  5   9   13   18   23   28   33   38   43   48   53   58   63   68   73",10,13,10,13,"$"
        
juegaUSA  db "Juega UNITED STATES: ",10,13,"$"
juegaURSS db "Juega SOVIET UNION: ",10,13,"$" 

msjx db "Ingrese coordenada x:  ","$"
msjy db 10,13,"Ingrese coordenada y:  ","$"
         
latitud db ?,?,"$"
longitud db ?,?,"$"

buffer db 3 dup(?)
cantDigitos db 2           

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Imprime el mapa del juego
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           

proc  printMap
    mov ah,09
    mov dx,offset mapaArriba
    int 21h
    mov ah,09
    mov dx,offset mapaAbajo
    int 21h
    endp
ret 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Decide quien juega
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           

proc aleatorioBinario       
    mov ah,2ch   ;toma la hora del sistema y guarda en ch:hora, cl:min, dh:seg y dl:miliseg
    int 21h
    
    xor ah,ah    ;pongo ah en cero
    mov al,dl    ;muevo los milisegundos a al
    div rangoDeAleatorio      ;tenemos 0 o 1 aleatorio en ah
    
    cmp ah,1
    je imprimirJuegaUSA 
    jne imprimirJuegaURSS
 imprimirJuegaUSA:
    mov ah,09h
    mov dx, offset juegaUSA
    int 21h
endp
ret 
 imprimirJuegaURSS:
    mov ah,09h
    mov dx, offset juegaURSS
    int 21h
    
endp
ret                            


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Pide Latitud
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

proc pedirLatitud    ;pedimos 2 números con la instrucción 0ah. Pide la cantidad de caracteres que entra en el buffer. 
    mov ah,09h
    mov dx, offset msjy                ;Imprime el mensaje ingresar coordenada x
    int 21h
    
    mov dx, offset buffer
    mov ah, 0ah
    int 21h
    
    xor bx, bx              ;Limpia bx
	mov bl, buffer[0]          ;Copia lo que hay en buffer a bl   
    mov bh, buffer[1]          ;Copia lo que hay en buffer a bl   	
;	mov buffer[bx+2], '$'         ; Lo guarda en bx    
;	mov latitud, bl                ; guardamos en la etiqueta latitud lo que hay en bl. O sea, el primer digito del numero
;	mov latitud[1],bh              ;   guardamos en la etiqueta latitud lo que hay en bx. O sea, el segundo digito del numero
	
    
     
endp
ret
         
         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Pide Longitud
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
         
proc pedirLongitud
     mov ah,09h
    mov dx, offset msjx                ;Imprime el mensaje ingresar coordenada x
    int 21h
    
    mov dx, offset buffer
    mov ah, 0ah
    int 21h
    
    xor bx, bx              ;Limpia bx
	mov bl, buffer[1]          ;Copia lo que hay en buffer a bl
	mov bh, buffer[2]         ; Lo guarda en bx    
	mov longitud[0], bl                ; guardamos en la etiqueta longitud lo que hay en bl. O sea, el primer digito del numero
	mov longitud[1],bh             ;   guardamos en la etiqueta longitud lo que hay en bx. O sea, el segundo digito del numero
	
    
     
endp
ret
                           
proc pedirCoordenada
 ;;  call pedirLongitud
  call pedirLatitud
    endp
ret          




inicio:
    call printMap
    call aleatorioBinario 
    call pedirCoordenada    


ret



