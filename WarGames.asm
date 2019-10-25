org 100h  

jmp inicio

;Definimos el mapa


rangoDeAleatorio db 2    ;Con esto fijamos entre que valores obtenemos el resultado de aleatorio

mapaArriba db "00..........................WAR GAMES - 1983..............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............",10,13,10,13,"$"
        
juegaUSA  db "Juega UNITED STATES: ",10,13,"$"
juegaURSS db "Juega SOVIET UNION: ",10,13,"$"          
latitud db 0
longitud db 0
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

inicio:
    call printMap 
    call pedirCoordenada    
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Decide quien juega
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           

proc aleatorioBinario:         
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

proc pedirLatitud 
    mov bx, offset latitud ;definimos a bx como putero
    sub cl,cl
    mov ah, 1   
    int 21h 
     
    pedirNumero:
        
        mov [bx], al     
        
        inc cl ; es un contador
        inc bx
        cmp cl, cantDigitos
    je pedirNumero   
    
endp
ret

proc pedirLongitud
    mov bx, offset longitud
    sub cl, cl  ;limpia cl
    mov ah, 1           
    
    pedirNumero2:
        int 21h
        mov [bx], al
        inc cl
        inc bx
        cmp cl, cantDigitos 
     je pedirNumero2 
endp
ret
                           
proc pedirCoordenada
    call pedirLatitud
    call pedirLongitud
    endp
ret          


ret



