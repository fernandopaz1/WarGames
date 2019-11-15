          
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


 
jmp inicio

;Definimos el mapa                    

rangoDeAleatorio    db 2    ;Con esto fijamos entre que valores obtenemos el resultado de aleatorio
mapaArriba          db "00..........................WAR GAMES - 1983..............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"07........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"08..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13
mapaAbajo           db "09..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"10..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"11..............-+++++++++:...........+:+::+................--.....---....",10,13,"12................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"13.................++::+-.............::++:..:...............++++++++-....",10,13,"14.................:++:-...............::-..................-+:--:++:.....",10,13,"15.................:+-............................................-.....--",10,13,"16.................:....................................................--",10,13,"17.......UNITED STATES.........................SOVIET UNION...............",10,13,"18........................................................................",10,13,"19  5   9   13   18   23   28   33   38   43   48   53   58   63   68   73",10,13,10,13,"$"
msjbaseSecretaUSA   db 10,13,"Ingrese base secreta de USA: ",10,13,"$"
msjbaseSecretaURSS  db 10,13,"Ingrese base secreta de URSS: ",10,13,"$"
juegaUSA            db 10,13,"Juega UNITED STATES: ",10,13,"$"
juegaURSS           db 10,13,"Juega SOVIET UNION: ",10,13,"$" 
msjx                db 10,13,"Ingrese coordenada x:  ","$"
msjy                db 10,13,"Ingrese coordenada y:  ","$"
latitud             db ?,?,"$"
longitud            db ?,?,"$"
latitudSecreta      db ?,?,"$"
longitudSecreta     db ?,?,"$"
buffer              db 3 dup(?)
cantDigitos         db 2          
base                db 1 
diez                db 10   
valor               db ?   
valorLong           db ?
valorLat            db ?
baseSecretaUSA      db ?,?,"$"  ;En el primero esta la longitud y en el segudo la latitud
baseSecretaURSS     db ?,?,"$"
msjEnter            db " ",10,13,"$"
cantidadDeColumnas  db 76
cantidadDeFilas     db 19  
dentroDelMapa       db 0    ;Es una etiquta que usamos para ver si la coordenada esta en el mapa
msjFueraDelMapa     db 10,13,10,13,"Coordenada fuera del mapa",10,13,"$"
turno               db ?
usaTieneW           db 1
urssTieneW          db 1
msjUSAPierde     db 10,13,10,13,"Aguante la URSS Viejaaaa",10,13,"$"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Imprime el mapa del juego
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           

printMap proc 
    mov ah,09
    
    mov dx,offset msjEnter
    int 21h

    mov dx,offset mapaArriba  ;Ahora mapaArriba no termina con "$" por lo que termina de imprimir cuando encuentra
    int 21h                   ;el "$" en mapa abajo. Por eso solo usamos una instrucci�n
     
    ret
printMap endp
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Decide quien juega
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           

proc aleatorioBinario        
    mov ah,2ch   ;toma la hora del sistema y guarda en ch:hora, cl:min, dh:seg y dl:miliseg
    int 21h
    
    xor ah,ah    ;pongo ah en cero
    mov al,dl    ;muevo los milisegundos a al
    div rangoDeAleatorio      ;tenemos 0 o 1 aleatorio en ah
    
    mov turno, ah

    cmp turno,1
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
    
    ret
endp aleatorioBinario                        
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Pide dos digitos
;
; bx: offset de la etiqueda donde se guardan los digitos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
pedirDosDigitos proc    
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
    ret
pedirDosDigitos endp


;este proc lo usamos cuando el jugador ingresa la base secreta usamos la instruccion 07h.     
pedirDosDigitosSecreto proc     
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
    ret
pedirDosDigitosSecreto endp


pedirLatitudSecreta proc  
    mov ah,09
    mov dx,offset msjy
    int 21h 
    
    mov bx, offset latitud ;definimos a bx como puntero
    
    call pedirDosDigitosSecreto
    
    mov bx, offset latitud
    call deAsciiAEntero
    mov valorLat, ah
    ret
pedirLatitudSecreta endp


pedirLongitudSecreta proc  
    mov ah,09
    mov dx,offset msjx
    int 21h       
    
    mov bx, offset longitud
    
    call pedirDosDigitosSecreto
     
    mov bx, offset longitud
    call deAsciiAEntero

    mov valorLong, ah
    ret
pedirLongitudSecreta endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Pide Latitud
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

   ;pedimos 2 n�meros con la instrucci�n 0ah. Pide la cantidad de caracteres que entra en el buffer. 
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

proc estaEnElMapa
    mov dentroDelMapa, 0
      
    cmp al,0
    jae LatMayorA0  ;salta solo si la latitud es mayor a cero
    jmp NoEstaEnElMapa  
    
LatMayorA0:
    cmp al,19
    jbe LatMenorA19            ;salta solo si la latitud es menor a 19
jmp NoEstaEnElMapa

LatMenorA19:
    cmp bl,0
    jae LongMayorA0            ;salta solo si la longitud es mayor a 0
jmp NoEstaEnElMapa
    
LongMayorA0:
    cmp bl,73          ;comparamos con 73 porque en cada fila hay 74 caracteres pero empezamos a contar desde el cero
    jbe siEstaEnElMapa           ;sata solo si la longitud es menor a 74
jmp NoEstaEnElMapa
    
siEstaEnElMapa:
    mov dentroDelMapa,1
NoEstaEnElMapa:
    endp
ret
    
proc disparar
    mov al, valorLat
    mov bl, valorLong
    call estaEnElMapa
    cmp dentroDelMapa, 0
    je mensajeFueraDelMapa

    sub valorLong, 1                ;Resta 1 para pararse en la esquina superior izquier del cuadradito
    sub valorLat,1  
    
    sub ch,ch                       ;limpia el contador del cicloD2: recorre la latitud
    iteramosLatitud:
       sub cl,cl                    ;ponemos el contador del ciclo que recorre la longitud en cero   
       iteramosLongitud:
            sub bx,bx                ;limpiamos el valor de la longitud
            mov bl, valorLong            
            add bl, cl                 ;Sumamos el indice que recorre la longitud  
            
            sub ax,ax            
            mov al, valorLat   
            add al,ch          ;sumamos el indice que recorre a latitud            
            
            call estaEnElMapa
            cmp dentroDelMapa,1
            je puedoDisparar 
            
siguientePosicion:
            
        inc cl
        cmp cl, 3 
        je nuevaLatitud
        jmp iteramosLongitud
            
        nuevaLatitud:
            inc ch
            cmp ch,3
            je finDisparo
        jmp iteramosLatitud


puedoDisparar: 
    mul cantidadDeColumnas       ;multiplicamos la cantidand de columnas con la latitud                             
    add bx,ax          ;sumamos ambos para ver el indice        
    mov mapaArriba[bx], " "  
    jmp siguientePosicion    

mensajeFueraDelMapa:
    mov ah,09 
    mov dx,offset msjFueraDelMapa 
    int 21h
                
finDisparo:
endp
ret
 
proc hayWDeUSA

    mov usaTieneW, 0    
    mov bx, offset mapaArriba;
   
    sub cx,cx
    recorreLatitudes:
        sub dx,dx   ;Recorre longitudes
        recorreLongitudes:

            mov al, cl
            mul cantidadDeColumnas

            add ax, dx

            push bx
            push cx
            add bx, ax

            mov cl, [bx]
            cmp cl, "W"
            je encontramosW
    volver:
            pop cx
            pop bx

            inc dx
            cmp dl, cantidadDeColumnas
            je noRecorreLongitudes
            jmp recorreLongitudes
    noRecorreLongitudes:
    inc cx
    cmp cl,cantidadDeFilas
    je noHayWDeUsa
    jmp recorreLatitudes

encontramosW:
    cmp dl,30
    jbe estaEnUsa
    jmp volver

estaEnUsa:
    mov usaTieneW,1
    pop cx
    pop bx

noHayWDeUsa:  
    ret
endp hayWDeUSA



proc hayW
    call hayWDeUSA
    cmp usaTieneW,0
    je usaPierde
    jmp siHayW

usaPierde:
    mov ah,09h
    mov dx, offset usaPierde
    int 21h      
siHayW:
endp
ret

inicio:
    ;call printMap
    ;call pedirBasesSecretas
    ;call aleatorioBinario
    seguirJugando:  
        call pedirCoordenada 
        call disparar  
        call printMap 
        call hayW
        cmp usaTieneW,0
        je finalDelJuego
    jmp seguirJugando
finalDelJuego:
ret