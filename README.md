Este es un proyecto de la matería Organización del computador de la Licenciatura en sistemas de la Universidad General Sarmiento.

Es un juego hecho en ensamblador de la arquitectura Intel 8086.

El juego trata de un enfrentamiento entre dos potencias (USA y URSS) y nuestro objetivo es que haya dos jugadores que se encargan de armar estrategias para que una de las dos potencias gane. En principio contamos con un mapa hecho con caracteres ASCII que muestra las dos potencias dibujadas con la letra W.

Al inicio del juego, los jugadores deben ingresar las coordenadas de su base secreta (fila, columna) sin que se muestre en pantalla, y así evitar que el otro jugador pueda verlo. Las coordenadas de la base secreta puede estar en cualquier parte siempre que se respeten las restricciones, USA tiene la libertad de poner su base secreta en cualquier coordenada que esté dentro del rango de columnas entre 0 y 33, en el caso de URSS debe poner su base secreta en el rango de 33 hasta el fin del mapa. Seguido a las coordenadas para las bases secretas que ingresan los jugadores, el juego de forma aleatoria, decide quien empieza a jugar. 

El ataque consiste en que cada jugador ingresa las coordenadas del país contrario donde quiere atacar, luego de ingresar las coordenadas se presiona la tecla Enter para disparar, con esto se borran del mapa no solo las coordenadas ingresadas por el jugador, sino también las posiciones contiguas.

El juego termina cuando una de las dos potencias elimina todas las W del oponente o cuando acierta la base secreta del oponente.

