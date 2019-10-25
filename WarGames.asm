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
         
latitud db 0
longitud db 0  

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
         

proc pedirLatitud
    mov ah,09h                         ;Imprime el mensaje ingresar coordenada y
    mov dx, offset msjy
    int 21h

     
    mov bx, offset latitud ;definimos a bx como puntero
    sub cl,cl
    
    mov ah, 1   
     
    pedirNumero:
        int 21h 
        mov [bx], al     
        
        inc cl ; es un contador
        inc bx
        cmp cl, cantDigitos
    je pedirNumero   
    
endp
ret
         
         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Pide Longitud
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
         
proc pedirLongitud
    mov ah,09h
    mov dx, offset msjx                ;Imprime el mensaje ingresar coordenada x
    int 21h
   
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
 ;   call pedirLongitud
  call pedirLatitud
    endp
ret          




inicio:
    call printMap
    call aleatorioBinario 
    call pedirCoordenada    


ret



