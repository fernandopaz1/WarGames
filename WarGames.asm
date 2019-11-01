org 100h  

jmp inicio

;Definimos el mapa


rangoDeAleatorio db 2    ;Con esto fijamos entre que valores obtenemos el resultado de aleatorio

mapaArriba db "00..........................WAR GAMES - 1983..............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"07........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"08..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo db "09..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"10..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"11..............-+++++++++:...........+:+::+................--.....---....",10,13,"12................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"13.................++::+-.............::++:..:...............++++++++-....",10,13,"14.................:++:-...............::-..................-+:--:++:.....",10,13,"15.................:+-............................................-.....--",10,13,"16.................:....................................................--",10,13,"17.......UNITED STATES.........................SOVIET UNION...............",10,13,"17........................................................................",10,13,"18  5   9   13   18   23   28   33   38   43   48   53   58   63   68   73",10,13,10,13,"$"


msjbaseSecretaUSA  db 10,13,"Ingrese base secreta de USA: ",10,13,"$"
msjbaseSecretaURSS  db 10,13,"Ingrese base secreta de URSS: ",10,13,"$"
        

juegaUSA  db 10,13,"Juega UNITED STATES: ",10,13,"$"
juegaURSS db 10,13,"Juega SOVIET UNION: ",10,13,"$" 


msjx db 10,13,"Ingrese coordenada x:  ","$"
msjy db 10,13,"Ingrese coordenada y:  ","$"
         
latitud db ?,?,"$"
longitud db ?,?,"$"

latitudSecreta db ?,?,"$"
longitudSecreta db ?,?,"$"


buffer db 3 dup(?)
cantDigitos db 2           

base db 1 

diez db 10   
valor db ?   
valorLong db  ?
valorLat db ?

baseSecretaUSA db ?,?,"$"    ;En el primero esta la longitud y en el segudo la latitud
baseSecretaURSS db ?,?,"$" 

cantidadDeColumnas db 73
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
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Pide dos digitos
;
; bx: offset de la etiqueda donde se guardan los digitos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
proc pedirDosDigitos    
    sub cl,cl
    mov ah, 01h   
    
     
    pedirNumero:
        int 21h 
        mov [bx], al     
        inc cl ; es un contador
        inc bx
        cmp cl, cantDigitos
        je fin
    jmp pedirNumero   
fin:
endp
ret


;este proc lo usamos cuando el jugador ingresa la base secreta usamos la instruccion 07h.     
proc pedirDosDigitosSecreto     
    sub cl,cl                                                     
    mov ah, 07h  ;No imprime la entrada en pantalla   
    
     
    pedirNumeroSecreto:
        int 21h 
        mov [bx], al     
        inc cl ; es un contador
        inc bx
        cmp cl, cantDigitos
        je finSecreto
    jmp pedirNumeroSecreto   
finSecreto:
endp
ret


 proc pedirLatitudSecreta  
    mov ah,09
    mov dx,offset msjy
    int 21h 
    
    mov bx, offset latitud ;definimos a bx como puntero
    
    call pedirDosDigitosSecreto
    
    mov bx, offset latitud
    call deAsciiAEntero
    mov valorLat, ah
endp
ret

proc pedirLongitudSecreta  
    mov ah,09
    mov dx,offset msjx
    int 21h       
    
    mov bx, offset longitud
    
    call pedirDosDigitosSecreto
     
    mov bx, offset longitud
    call deAsciiAEntero

    mov valorLong, ah
endp
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Pide Latitud
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

   ;pedimos 2 números con la instrucción 0ah. Pide la cantidad de caracteres que entra en el buffer. 
 proc pedirLatitud  
    mov ah,09
    mov dx,offset msjy
    int 21h 
    
    mov bx, offset latitud ;definimos a bx como puntero
    
    call pedirDosDigitos
    
    mov bx, offset latitud
    call deAsciiAEntero
    mov valorLat, ah
endp
ret

         
         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Pide Longitud
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
         

proc pedirLongitud  
    mov ah,09
    mov dx,offset msjx
    int 21h       
    
    mov bx, offset longitud
    
    call pedirDosDigitos
     
    mov bx, offset longitud
    call deAsciiAEntero

    mov valorLong, ah
endp
ret

proc pedirBasesSecretas
  mov ah,09 
  mov dx,offset msjbaseSecretaUSA 
  int 21h
                                          
    
  pedirLongOtraVezUSA:
  call pedirLongitudSecreta 
  mov ah, valorLong
  mov al, valorLat
  
  cmp valorLong, 33  ;Se fija si ingreso un numero entre 0 y 33
  jae pedirLongOtraVezUSA 
  
  call pedirLatitudSecreta
  
  mov baseSecretaUSA[0], ah
  mov baseSecretaUSA[1], al  
  
  
  mov ah,09 
  mov dx,offset msjbaseSecretaURSS 
  int 21h
  
    
pedirLongOtraURSS:  
  call pedirLongitudSecreta
  cmp valorLong,33
  jbe pedirLongOtraURSS

  call pedirLatitudSecreta
  mov al, valorLat
  mov ah, valorLong 
  mov baseSecretaURSS[0], ah
  mov baseSecretaURSS[1], al  

    endp
ret 

         

                           
proc pedirCoordenada
  call pedirLongitud
  call pedirLatitud
    endp
ret          
                   
 ;;;;;;;
 ;            Antes de llamar a esta funcion hacer mov bx, offset etiqueta a transformar
 
 ;;; Guarda el resultado transformado en AH;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,;,,;,,;
proc deAsciiAEntero
    sub cl, cl
    add bx, 1  
    mov valor, 0   ;; limpiamos valor para que cuando tenga otro llamado este limpia.
    ciclo:
        mov al, [bx]
        sub al, 30h
        mul base
        add valor, al
        mov al, base
        mul diez
        mov base, al
        dec bx
        inc cl
        cmp cl, cantDigitos
        je fin3
     jmp ciclo
fin3:
    mov base,1
    mov ah, valor 
endp 
ret
    
proc disparar
   sub bx,bx
   mov bl, valorLong
   mov al, valorLat
   mul cantidadDeColumnas 
   add bx,ax
   mapaArriba[bx]
   
endp
ret
 
inicio:
    call printMap
    call pedirBasesSecretas
    call aleatorioBinario  
    call pedirCoordenada    


ret



