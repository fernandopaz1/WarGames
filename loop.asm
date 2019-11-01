
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

;calcula la suma de 7 elementos de un vector


mov cx,7  ;cant de elementos
mov al,0  ;donde guadro la suma
mov bx,0  ;indice del vector

bucle:
    add al,vector[bx]   ;es la etiqueta vector desplazada bx, offset
    inc bx
    loop bucle          ;Es un salto condicional bucle, loop es short
                        ;loop trabaja solo con cx salta solo si cx es distinto de cero, no trabaja con flags
    mov resul,al                                                    
ret
   
;daros: lo defino aca abajo asi me ahorro el jmp inicio, pero es conveniente definir los datos al inicio
vector db 5,4,5,2,1,3,6
resul db 0



