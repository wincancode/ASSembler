
   
    
;---------------------------------
;|              MACROS           |
;---------------------------------   


;----------------------------------
;|  Imprime un mensaje en pantalla|
;----------------------------------                      
macro print msj 
    pusha
    
    mov dx, offset msj
    mov ah, 9h
    int 21h
    
    popa
endm          
     

;------------------------------------------------------------
;|  Imprime un mensaje en pantalla dejando un salto de linea|
;------------------------------------------------------------
macro println msj
    push dx
	push ax
	
	mov dx, offset msj  
	mov ah, 9h
	int 21h
   
	mov dx, offset saltoDeLinea  
	mov ah, 9h
	int 21h   
	
	pop ax
	pop dx
endm


;---------------------------------------------------------------------------              
;Lee un valor y lo guarda en una variable un numero. Deja un salto de linea;
;---------------------------------------------------------------------------
macro leerNum dato
    push ax
    
    mov ah,01h  
    int 21h   
    mov dato, al 
             
    sub dato, 030h ;Se ajusta el ascii        
             
    mov dx, offset saltoDeLinea  
    mov ah, 9h
    int 21h      
    
    pop ax
endm    


;---------------------------------------------------------------------------------
;Mueve una variable float (arreglo de dos, uno entero y uno decimal> a otro float;
;---------------------------------------------------------------------------------
macro movF b, a ;movFloat 
    push ax
    
    mov ax, a[0]
    mov b[0], ax
    
    mov ax, a[2]
    mov b[2], ax
    
    pop ax
    
endm


;----------------------------------------------------------------
;Redondea un float hacia abajo. Si recibe 3,3456 se devuelve 3,3;
;----------------------------------------------------------------
macro redondear a
    pusha
        
        mov ax, a[2]
        mov P_obtenerCantidadDigitos, ax
        call obtenerCantidadDigitos
        
        mov P1_potencia, 10d
        mov bx, R_obtenerCantidadDigitos
        dec bx
        mov P2_potencia, bx                   
        call potencia
    
    
        mov bx, R_potencia
        div bx      
         
        
        mov a[2], ax
        
        
        
    popa   
endm       




           
          
 
;---------------------------------
;|              FIN MACROSS      |
;---------------------------------  
     


org 100h 

    altura equ 40
    anchura equ 80   
    inicio equ 5
    separacion equ 10
    
    rectangulo_inix equ 0
    rectangulo_iniy equ 130 
    
    cuadrado_inix  equ 90 ;80+10
    cuadrado_iniy  equ 130   
 
    triangulo_inix equ 140 ;cuadrado_inix + altura + separacion
    triangulo_iniy equ 170  ;130 + altura      
    
   
    circulo_inix equ 240 ;triangulo_inix + altura + separacion
    circulo_iniy equ 150 ;130 + 20
    
    
   
.data       
 
    ;-------------------------------------------------------------------------------------------------------------------------;
    ;El sistema de funciones utiliza parametros y retornos. Se agrega un caracter al inicio para representar el tipo de dato. ;
    ;-------------------------------------------------------------------------------------------------------------------------;
    ;P_: Parametro                                                                                                            ;
    ;R_: Valor retornado                                                                                                      ;
    ;-------------------------------------------------------------------------------------------------------------------------;
    
    
    
    ;------------------------------------------------------
    ;Parametros y valores de retorno de los procedimientos; 
    ;------------------------------------------------------
                             
    
    ;--------------------
    P1_calculoArea dw 0,0
    P2_calculoArea dw 0,0
    R_calculoArea  dw 0,0
    ;--------------------
    
    ;--------------------   
    P_decimalCarry dw 0,0 
    R_decimalCarry dw 0,0                        
    ;--------------------
 
    ;-----------------------------------------
    P_obtenerDigitos  dw 0,0
    R1_obtenerDigitos dw 0,0,0,0 ;parte entera
    R2_obtenerDigitos dw 0,0 ;parte decimal
    ;-----------------------------------------
    
    
    ;------------------------    
    R_leerEntradaLarga dw 0,0    
    ;------------------------  
    
    ;--------------------
    P1_multiplicar dw 0,0
    P2_multiplicar dw 0,0
    R_multiplicar dw 0,0
    ;--------------------
    
          
    ;--------------------     
    P1_dividir dw 0,0
    P2_dividir dw 0
    R_dividir dw 0,0         
    ;--------------------    
                         
    ;----------------------------                     
    P_obtenerCantidadDigitos dw 0
    R_obtenerCantidadDigitos dw 0                     
    ;----------------------------  
    
    ;----------------
    P1_potencia dw 0
    P2_potencia dw 0
    R_potencia  dw 0                                             
    ;----------------
                         
    ;-------------------                     
    P_printFloat dw 0,0                     
    ;-------------------                         
    
    
    ;---------------------------------------------------------
    ;Variables necesarias para el funcionamiento del programa
    ;---------------------------------------------------------
       
    eleccion db 0       
    
    
    ;---------------------------------------------------------
    ;Variables auxiliares
    ;---------------------------------------------------------                                          
                             
                                
    auxiliar dw 0 ;Valores auxiliares   
    auxiliar2 dw 0
    auxChar db 0,"$" 
                                        
           
    ;---------------------------------------------------------
    ;Constantes
    ;---------------------------------------------------------       
           
           
    pi DW 3d,1d                ;El valor pi                                                                                                  
    
    saltoDeLinea DB 13,10,"$"  ;un valor constante que indica un salto de linea. 
       
    enter db 0Dh               ;valor que representa el "enter" en ASCII    
    
    
    ;---------------------------------------------------------
    ;Mensajes a mostrar en pantalla
    ;---------------------------------------------------------       
    
    coma db ",$"  
    
    ;----------------------------------------------------------------------------
    mensajeInicial_1 DB "Ingrese la figura a la cual le desea calcular el area $"  
    mensajeInicial_2 DB "1. Rectangulo $"
    mensajeInicial_3 DB "2. Triangulo $"
    mensajeInicial_4 DB "3. Cuadrado $"
    mensajeInicial_5 DB "4. Circulo $" 
    ;----------------------------------------------------------------------------
    
    ;-----------------------------------------------------------
    seleccionRectangulo_1 DB "Ingrese la longitud del lado 1 $"
    seleccionRectangulo_2 DB "Ingrese la longitud del lado 2 $"
    ;-----------------------------------------------------------
    
    ;---------------------------------------------
    seleccionTriangulo_1 DB "Ingrese la altura $"
    seleccionTriangulo_2 DB "Ingrese la base $" 
    ;---------------------------------------------
    
    ;------------------------------------------------------
    seleccionCuadrado_1 DB "Ingrese la longitud de lado $" 
    ;------------------------------------------------------
    
    ;------------------------------------------
    seleccionCirculo_1 DB "Ingrese el radio $"   
    ;------------------------------------------
    
    ;------------------------------------------------------
    mensajeFinal_1 db "El area de la figura es igual a: $"
    ;------------------------------------------------------

     
     
.code     
   mov ax, @data
    mov ds, ax
 
mov al, 13h
mov ah, 0
int 10h    ; Pone el modo grafico        


;call dibujarRectangulo
;call dibujarCuadrado  
;call dibujarTriangulo              
;call dibujarCirculo



;-----------------------------------------------------------
;Se imprimen los mensajes del menu principal en pantalla
;-----------------------------------------------------------
println mensajeInicial_1
println mensajeInicial_2
println mensajeInicial_3
println mensajeInicial_4
println mensajeInicial_5
             
             
;-------------------
;Se lee la eleccion        
;-------------------   
leerNum eleccion

call clrscr                     

;-----------------------------------------------------------
;Se verifica la eleccion y segun cual sea, se va a una zona 
;del codigo para pedir los datos del area correspondiente                                                           
;-----------------------------------------------------------                                                            
cmp eleccion, 1d
je seleccionRectangulo

cmp eleccion, 2d
je seleccionTriangulo

cmp eleccion, 3d
je seleccionCuadrado

cmp eleccion, 4d
je seleccionCirculo
 
;pendiente: hacer jump a seleccion invalida 
 
 
;-----------------------------------------------------------
;Se piden los datos correspondientes al area del rectangulo, 
;se calcula y se va al fin de la seleccion
;----------------------------------------------------------- 
seleccionRectangulo:
    
    
                    
    println seleccionRectangulo_1

    call leerEntradaLarga
    
    movf P1_calculoArea, R_leerEntradaLarga 
  
    println seleccionRectangulo_2
               
    call leerEntradaLarga
    
    movf P2_calculoArea, R_leerEntradaLarga 
  
    call areaRectangulo  
    
    call dibujarRectangulo
    
    jmp finSeleccion


;-----------------------------------------------------------
;Se piden los datos correspondientes al area del triangulo, 
;se calcula y se va al fin de la seleccion
;----------------------------------------------------------- 
seleccionTriangulo: 
   
                

   
    println seleccionTriangulo_1

    call leerEntradaLarga
    
    movf P1_calculoArea, R_leerEntradaLarga 
    
  
    println seleccionTriangulo_2
               
    call leerEntradaLarga
    
    movf P2_calculoArea, R_leerEntradaLarga 
    
    call areaTriangulo                 
    
    call dibujarTriangulo  
    
    jmp finSeleccion


;-----------------------------------------------------------
;Se piden los datos correspondientes al area del cuadrado, 
;se calcula y se va al fin de la seleccion
;----------------------------------------------------------- 
seleccionCuadrado: 

     
    println seleccionCuadrado_1

    call leerEntradaLarga
    
    movf P1_calculoArea, R_leerEntradaLarga 
    movf P2_calculoArea, R_leerEntradaLarga   
      
 
    call areaRectangulo 
    
    call dibujarCuadrado  
    
    jmp finSeleccion


;-----------------------------------------------------------
;Se piden los datos correspondientes al area del circulo, 
;se calcula y se va al fin de la seleccion
;-----------------------------------------------------------     
seleccionCirculo:

    
    println seleccionCirculo_1

    call leerEntradaLarga
    
    movf P1_calculoArea, R_leerEntradaLarga 

    call areaCirculo
   
    call dibujarCirculo
   
   
    jmp finSeleccion
    
finSeleccion:

;-----------------------------------------------------------
;Finalizado el calculo de area se imprime en pantalla
;;-----------------------------------------------------------          

movf P_printFloat, R_calculoArea
print mensajeFinal_1
call printFloat


mov ah, 4ch ; Interrupcion para cerrar el programa correctamente
int 21h     

    

ret


                   
;---------------------------------
;|              PROCS            |
;---------------------------------
                               
 
;------------------------------------------------
; calcular el area de un rectangulo (P1, P2>:(R>
;------------------------------------------------
proc areaRectangulo
   push ax
   
   movf P1_multiplicar, P1_calculoArea
   movf P2_multiplicar, P2_calculoArea   
   
   call multiplicar
     
   movf R_calculoArea, R_multiplicar
   
   pop ax   
ret

;------------------------------------------------
; calcular el area de un circulo (P1>:(R>
;------------------------------------------------
proc areaCirculo
   pusha
   
   movf P1_multiplicar, P1_calculoArea
   movf P2_multiplicar, P1_calculoArea   
      
   call multiplicar ;r2
   
   
   movf P1_multiplicar, R_multiplicar
   movf P2_multiplicar, pi
   
   call multiplicar ;r2 * pi
   
   
 
   movf R_calculoArea, R_multiplicar
         
   popa
ret

;------------------------------------------------
; calcular el area de un triangulo (P1, P2>:(R>
;------------------------------------------------
     
proc areaTriangulo
   push ax
   
   movf P1_multiplicar, P1_calculoArea
   movf P2_multiplicar, P2_calculoArea   

   
   call multiplicar ;base por altura
   
   movf P1_dividir, R_multiplicar  
   mov P2_dividir, 2d
   
   call dividir ;base por altura / 2
   
   movf R_calculoArea, R_dividir  
   
   
   pop ax
    
   

ret    
  
  
  

;-------------------------------------------------------------------
;   guarda la cantidad de digitos de un valor en la variable digitos. <P>:P
;-------------------------------------------------------------------
                       
 proc obtenerCantidadDigitos                                   
    pusha
 
    mov R_obtenerCantidadDigitos, 00h  ;Se inicialia el retorno
    cmp P_obtenerCantidadDigitos, 00h  ;Si se recibe 0, entonces hay 0 digitos
    je obtenerCantidadDigitos_fin  
    
    ;-------------------------------------------------------------------
    ;Se divide el numero entre 10 hasta que sea cero, y se va contando cada 
    ;iteracion.
    ;-------------------------------------------------------------------
    obtenerCantidadDigitosCiclo:
    
        mov ax, P_obtenerCantidadDigitos
        mov dx, 00h 
        mov bx, 0Ah
        div bx  
        
        mov P_obtenerCantidadDigitos, ax       
       
        inc R_obtenerCantidadDigitos
        cmp ax, 00h
        
        
     jne obtenerCantidadDigitosCiclo
    
    obtenerCantidadDigitos_fin:
    
    popa
  ret     

;------------------------------------------------
; elevar un numero a otro (P1,P2>:(R>
;------------------------------------------------

proc potencia
    
    push ax
    push cx                 
    
    mov ax, P1_potencia   
    mov R_potencia, ax
    
    ;-------------------------------------------------------------------
    ;Se verifican los casos base de la potencia
    ;-------------------------------------------------------------------
    
    cmp P2_potencia, 0d
    je fin_potencia_uno ;n^0 = 1
    
    cmp P1_potencia, 0d
    je fin_potencia_cero; 0^n = 0
    
    cmp P1_potencia, 1d 
    je fin_potencia_uno ;1^n = 1
    
    cmp P2_potencia, 1d ;n^1 = n
    je fin_potencia
    
    mov cx, P2_potencia 
    dec cx ;n^m = n*n^m-1
    
    
    ;-------------------------------------------------------------------
    ;Se multiplica por cada vez que se quiera la potencia
    ;-------------------------------------------------------------------
    potencia_ciclo:
        
         mul P1_potencia    
    
    loop potencia_ciclo
    
    ;-------------------------------------------------------------------
    ;Se devuelve el dato 
    ;-------------------------------------------------------------------
    
    mov R_potencia, ax
    
    jmp fin_potencia             
                 
    fin_potencia_uno: 
    mov R_potencia, 1d   
    
    fin_potencia_cero:             
    mov R_potencia, 0d
    
    fin_potencia:
    
    pop cx
    pop ax
ret     


;------------------------------------------------
; dividirEntreDos P1<decimal>,P2(entero) : R
;------------------------------------------------ 

proc dividir
    pusha
    
    ;-------------------------------------------------------------------
    ;Se multiplica el primer elemento por 10, para eliminar su parte decimal
    ;-------------------------------------------------------------------
    mov dx, 0d
    redondear P1_dividir
    mov ax, P1_dividir[0]
    mov bx, 10d
    mul bx  ;*10 
    add ax, P1_dividir[2]  ;se le aniade la parte decimal
    
    ;Se guardan los valores del primer escalado
    push ax
    push dx
    
    ;-------------------------------------------------------------------
    ;Se multiplica por 10 el segundo elemento para obtener un mismo factor
    ;-------------------------------------------------------------------        
    mov ax, P2_dividir 
    mul bx  ; *10
    mov bx, ax    
    
    pop dx
    pop ax  
    
    ;-------------------------------------------------------------------
    ;Se tiene el entero * el factor. Cualquier division ahora es proporcional   
    ;-------------------------------------------------------------------
 
    div bx ;ax:dx / bx      
    mov R_dividir[0], ax  
    
    ;-------------------------------------------------------------------
    ;Se obtiene la parte decimal, se arregla el resto y se vuelve a
    ;dividir entre el valor original
    ;-------------------------------------------------------------------
    mov ax, dx 
    mov bx,10d
    mul bx
    mov dx, 0d
    div P2_dividir
    
    mov R_dividir[2], ax
         
                                        
    popa   
ret

;------------------------------------------------
; multiplicar P1,P2 :(AX,DX>
;------------------------------------------------

proc multiplicar
    pusha
    
    ;-------------------------------------------------------------------
    ;Se multiplica por 10 para eliminar el decimal
    ;-------------------------------------------------------------------
    mov dx, 0d
    mov ax, P2_multiplicar[0]
    mov bx, 10d
    mul bx  ;*10 
    add ax, P2_multiplicar[2]  ;se le aniade la parte decimal    
    mov cx, ax
    
    
    
    ;-------------------------------------------------------------------
    ;Si el valor recibido es mayor a 2000, no se realiza la conversion al 
    ;segundo parametro para evitar overflows
    ;-------------------------------------------------------------------
    cmp P1_multiplicar[0], 2000d 
    jge notNormalMul
    
    ;-------------------------------------------------------------------
    ;Realiza el factr al primer elemento
    ;-------------------------------------------------------------------
    normalMul:
        mov dx, 0d
        mov ax, P1_multiplicar[0]
        mov bx, 10d
        mul bx  ;*10 
        add ax, P1_multiplicar[2]  ;se le aniade la parte decimal
        
        
        jmp continueMul
    ;-------------------------------------------------------------------
    ;No realiza el factor con el primer elemento
    ;-------------------------------------------------------------------
    notNormalMul:
        mov ax, P1_multiplicar[0]
        mul cx
        mov bx, 10d ;10*10 
        div bx
        jmp finMul
    
    ;-------------------------------------------------------------------
    ;Con el factor, se realiza la division y se divide entre 100 para 
    ;eliminar el factor de conversion
    ;-------------------------------------------------------------------
    continueMul:
                                                                   
    ;Se tiene un elemento en AX, y otro guardado de antemano en CX. Se multiplican.   
    mul cx         
    mov bx, 100d ;10*10   
    div bx
    
    
    ;-------------------------------------------------------------------
    ;Se termina la multiplicacion, ya sea por un metodo u otro.
    ;-------------------------------------------------------------------
    finMul: 
     
    mov R_multiplicar[0], ax
    mov R_multiplicar[2], dx
    
    
    popa  
    
ret

                                                     

                                         
;----------------------------------------
; Imprimir un float <P>:<>
;-----------------------------------------

proc printFloat
    
    push ax
    push bx
    push dx  
    push si 
    push cx
          
    
    
    ;-------------------------------------------------------------------
    ;Se preparan las variables necesarias. bx se usa para dividir el numero
    ;ax contiene el numero a imprimir, en primer lugar toma la parte decimal
    ;cx se usa primero como bandera, y luego como contador y si se usa como otro contador
    ;-------------------------------------------------------------------
    mov bx, 10
    mov ax, P_printFloat[2]     
    mov cx, 0d 
    mov si, 0d
    
    ;-------------------------------------------------------------------
    ;Loop principal
    ;-------------------------------------------------------------------    
    printParteEntera:    
    
        ;-------------------------------------------------------------------
        ;Se divide el numero para obtener el digito mas a la derecha 
        ;-------------------------------------------------------------------
        mov dx, 0d
        div bx
        
        ;-------------------------------------------------------------------
        ;Se ajusta el valor de numero a su caracter ASCII
        ;se hace push del caracter a la pila y se aumenta el contador
        ;-------------------------------------------------------------------           
        add dx, 30h ;el caracter esta en el resto
        push dx 
        xor dx, dx                                                        
        inc si
        
        ;-------------------------------------------------------------------
        ;En caso de que ax sea cero, entonces se termino de colocar todos 
        ;los valores en la pila
        ;-------------------------------------------------------------------
        cmp ax, 0d
        je pasarParteDecimal
        jmp otroLoop
        
        pasarParteDecimal: 
            ;-------------------------------------------------------------------
            ;Si la flag de cx esta encendida, entonces no se continua el loop
            ;-------------------------------------------------------------------
            cmp cx, 1d
            je finLoop
            
            ;-------------------------------------------------------------------
            ;Si la flag no esta colocada, se mueve a ax una flag a la pila para 
            ;saber que a partir de ese punto en la pila, es la otra parte del 
            ;numero
            ;-------------------------------------------------------------------  
            mov ax,1d 
            push ax   ;setting a flag      
            
            ;-------------------------------------------------------------------
            ;Se coloca en ax la parte entera del numero para separar sus digitos
            ;y se coloca la flag en cx para la siguiente vez que ax sea cero
            ;-------------------------------------------------------------------
            mov ax, P_printFloat[0]     
            mov cx, 1d
                   
        otroLoop:        
    
    jmp printParteEntera
    
    finLoop:
    
    
    ;-------------------------------------------------------------------
    ;Se mueve a cx, si. Esto indica que se debe de imprimir SI cantidad
    ;de caracteres
    ;-------------------------------------------------------------------          
    mov cx, si          
    
    
    
    ;-------------------------------------------------------------------
    ;para este punto el numero esta guardado de forma inversa en la pila
    ;Si se quiere imprimir 123,4 se descompuso el numero y se guardo en la
    ;pila como "4<-3<-2<-1", y al sacarlos de la pila, se empieza desde el
    ;ultimo ingresado, que fue el 1, por lo que se imprime correctamente
    ;-------------------------------------------------------------------
    printLoop:
        ;-------------------------------------------------------------------
        ;Se guarda el valor en la pila en dx
        ;-------------------------------------------------------------------
        pop dx    
        
        ;-------------------------------------------------------------------
        ;Si se encuentra la flag colocada anteriormente (1) significa que ya
        ;Se imprimio la parte entera y toca la parte decimal. Se imprime una
        ;coma
        ;-------------------------------------------------------------------
        cmp dx, 1d
        je imprimirComa
        jmp noImprimirComa
        
        imprimirComa:  
            ;-------------------------------------------------------------------
            ;Se imprime una coma y se obtiene el siguiente valor
            ;-------------------------------------------------------------------
            print coma
            pop dx   
        noImprimirComa:    
        
        ;-------------------------------------------------------------------
        ;Se imprime el caracter correspondiente
        ;-------------------------------------------------------------------
        
        mov auxChar[0], dl
        print auxChar
                  
        
    loop printLoop
    
    pop cx
    pop si
    pop dx
    pop bx
    pop ax                

ret    
endp     
 
                                         
;----------------------------------------
; leer entradas de mas de un digito <>:<R>
;-----------------------------------------
  
proc leerEntradaLarga
    
    ;-------------------------------------------------------------------
    ;Se inicializan los retornos en cero                                        
    ;-------------------------------------------------------------------
    mov R_leerEntradaLarga[0], 00h
    mov R_leerEntradaLarga[2], 00h
    
    ;-------------------------------------------------------------------
    ;Se asigna 3 a cx, pues solo se pueden ingresar 4 caracteres (00,0> 
    ;-------------------------------------------------------------------  
    mov cx, 3
    ;------------------------------------------------------------------- 
    ;Se asigna 0 a si, pues es el puntero que representa en que parte de
    ;la entrada se encuentra. 0: enteros, 2: decimal
    ;-------------------------------------------------------------------
    mov si, 0 
    
    
    mov dx, 10d;
    leerDigito:
        ;-------------------------------------------------------------------
        ;Se lee el caracter ingresado                                       
        ;-------------------------------------------------------------------
        mov ah,01h  
        int 21h                                    
         
        ;-------------------------------------------------------------------        
        ;Se convierte el valor leido en numeros y se multiplica por el factor
        ;correspondiente, es decir, 123 = 1*100 + 2*10 + 3*1             
        ;-------------------------------------------------------------------               
        sub al,30h                 
        mov ah, 00h 
        
        mov auxiliar, dx
        mul dx          
        mov dx, auxiliar
        
        ;-------------------------------------------------------------------        
        ;Se suma el valor en Ax al retorno en su parte correspondiente 
        ;(decimal o entera)
        ;-------------------------------------------------------------------        
        add R_LeerEntradaLarga[si], ax        
        
        ;-------------------------------------------------------------------        
        ;Se divide entre 10 el factor guardado en dx
        ;-------------------------------------------------------------------        
        mov ax, dx
        mov dx, 0                
        mov bx, 10d
        div bx
               
        mov dx, ax
        
        ;-------------------------------------------------------------------        
        ;Se verifica si toca escribir el valor decimal  (si ya se ingresaron
        ;2 numeros)             
        ;-------------------------------------------------------------------        
        cmp cx, 2d                  
        je leerEntradaLarga_AsignarSI?verdadero
        jmp leerEntradaLarga_AsignarSI?falso
        
        
        leerEntradaLarga_AsignarSI?verdadero:
            ;------------------------------------------------------------------- 
            ;Si se debe ingresar un decimal, se imprime una coma y se cambia
            ;el puntero a si y se reinicia el factor (solo se recibe un decimal>
            ;-------------------------------------------------------------------               
            print coma
            mov si, 2d
            mov dx, 1d             
            
        leerEntradaLarga_AsignarSI?falso: 
    

    loop leerDigito
    
    leerEntradaLarga_Fin: 
    
    ;-------------------------------------------------------------------        
    ;Se imprime un salto de linea al final de la lectura
    ;-------------------------------------------------------------------        
    mov dx, offset saltoDeLinea  
    mov ah, 9h
    int 21h                                   

       
      
ret       


proc dibujarTriangulo
    pusha    
     
    
    mov al, 1010b ; poner colo de la figura
    mov cx, triangulo_inix  ; posicion x
    mov dx, triangulo_iniy  ; posicion y
    
    ; Lado izquierdo
        
    Tl1: mov ah, 0ch   ; colorear
        int 10h
        
        inc cx
        dec dx
        cmp dx, triangulo_iniy-altura
        jnz tl1      
        
        ; Lado derecho
    
    Tl2: mov ah, 0ch   ; colorear
        int 10h
        
        inc cx
        inc dx
        cmp dx, triangulo_iniy
        jnz tl2  
        
        ; Lado base
    
    Tl3: mov ah, 0ch
        int 10h
        
        dec cx
        cmp cx, triangulo_inix
        jnz tl3

    popa
ret       



proc dibujarCuadrado
    pusha
     
    mov al, 1011b ; poner color para la figura
    mov cx, cuadrado_inix  ; posicion x
    mov dx, cuadrado_iniy  ; posicion y 
    ; Linea superior
    cl1: mov ah, 0ch   ; Interrupcion para colorear el pixel
        int 10h
        
        inc cx
        cmp cx, cuadrado_inix+altura
        jnz cl1
            
        ; Linea derecha
    cl2: mov ah, 0ch
        int 10h
        
        inc dx
        cmp dx, cuadrado_iniy+altura
        jnz cl2 
        
        ; Linea inferior
    cl3: mov ah, 0ch
        int 10h
        
        dec cx
        cmp cx, cuadrado_inix
        jnz cl3
        
        ; Linea izquierda
    cl4: mov ah, 0ch
        int 10h
        
        dec dx
        cmp dx, cuadrado_iniy
        jnz cl4         
    
    popa
ret           

proc dibujarRectangulo    
    
    pusha
     
    mov al, 1001b ; poner color para la figura
    mov cx, rectangulo_inix  ; posicion x
    mov dx, rectangulo_iniy  ; posicion y 
    ; Linea superior
    rl1: mov ah, 0ch   ; Interrupcion para colorear el pixel
        int 10h
        
        inc cx
        cmp cx, rectangulo_inix+anchura
        jnz rl1
            
        ; Linea derecha
    rl2: mov ah, 0ch
        int 10h
        
        inc dx
        cmp dx, rectangulo_iniy+altura
        jnz rl2 
        
        ; Linea inferior
    rl3: mov ah, 0ch
        int 10h
        
        dec cx
        cmp cx, rectangulo_inix
        jnz rl3
        
        ; Linea izquierda
    rl4: mov ah, 0ch
        int 10h
        
        dec dx
        cmp dx, rectangulo_iniy
        jnz rl4         
    
    popa
ret   

proc dibujarCirculo
    pop auxiliar
    pusha
    
    mov al, 0010b

    mov cx, circulo_inix
    mov dx, circulo_iniy

    ; primer cuadrante 
    
     ; parte inferior del cuadrante
     mov bx, inicio
     push bx

     ci_inf: call imprimir_pixel
    
        
        dec dx
        dec bx
        cmp bx, 0
        jnz ci_inf
        
        pop bx
        dec bx
        push bx
        inc cx
        cmp bx, 0
        jnz ci_inf                        
        
        ; parte media del cuadrante
        mov bx, inicio
        
     ci_mid: call imprimir_pixel
        
        dec dx
        inc cx
        dec bx
        cmp bx, 0 
        jnz ci_mid
        
        ; parte superior del cuadrante
        pop bx
        inc bx
        push bx
     
     ci_sup: call imprimir_pixel    
        
        inc cx
        dec bx
        cmp bx, 0
        jnz ci_sup
        
        pop bx
        inc bx
        push bx
        dec dx
        cmp bx, inicio+1
        jnz ci_sup 
        
        
     ; segundo cuadrante 
     
     ; parte superior del cuadrante
     inc dx
     pop bx
     dec bx
     push bx
     
     cii_sup: call imprimir_pixel
        
        inc cx
        dec bx
        cmp bx, 0 
        jnz cii_sup
        
        pop bx
        dec bx
        push bx
        inc dx
        cmp bx, 0
        jnz cii_sup  
        
     ; parte media del cuadrante 
     mov bx, inicio
     
     cii_mid: call imprimir_pixel
     
        inc dx
        inc cx
        dec bx
        cmp bx, 0
        jnz cii_mid 
        
     ; parte inferior del cuadrante
     pop bx
     inc bx
     push bx
     
     cii_inf: call imprimir_pixel
        
        inc dx 
        dec bx
        cmp bx, 0
        jnz cii_inf
        
        pop bx
        inc bx
        push bx
        inc cx
        cmp bx, inicio+1
        jnz cii_inf
        
    ; tercer cuadrante 
    
    ; parte superior del cuadrante 
    dec cx
    pop bx
    dec bx
    push bx
    
    ciii_sup: call imprimir_pixel
        
        inc dx
        dec bx
        cmp bx, 0
        jnz ciii_sup 
        
        pop bx
        dec bx
        push bx
        dec cx
        cmp bx, 0 
        jnz ciii_sup
        
    ; parte media del cuadrante
    mov bx, inicio
    
    ciii_mid: call imprimir_pixel
    
        inc dx
        dec cx
        dec bx
        cmp bx, 0 
        jnz ciii_mid
        
    ; parte inferior del cuadrante
    pop bx
    inc bx
    push bx
    
    ciii_inf: call imprimir_pixel
    
        dec cx
        dec bx
        cmp bx, 0
        jnz ciii_inf
        
        pop bx
        inc bx
        push bx
        inc dx
        cmp bx, inicio+1
        jnz ciii_inf
        
    ; cuarto cuadrante 
    
    ; parte inferior del cuadrante 
    dec dx
    pop bx
    dec bx
    push bx
    
    civ_inf: call imprimir_pixel
        
        dec cx
        dec bx
        cmp bx, 0
        jnz civ_inf
        
        pop bx
        dec bx
        push bx
        dec dx
        cmp bx, 0 
        jnz civ_inf
        
    ; parte media del cuadrante
    mov bx, inicio
    
    civ_mid: call imprimir_pixel
    
        dec dx
        dec cx
        dec bx
        cmp bx, 0 
        jnz civ_mid
        
    ; parte superior del cuadrante
    pop bx
    inc bx
    push bx
    
    civ_sup: call imprimir_pixel
    
        dec dx
        dec bx
        cmp bx, 0
        jnz civ_sup
        
        pop bx
        inc bx
        push bx
        dec cx
        cmp bx, inicio+1
        jnz civ_sup
        
    
    popa    
    push auxiliar
ret
endp

imprimir_pixel proc 
    mov ah, 0ch
    int 10h
    
    ret
imprimir_pixel endp   


proc clrscr 
       mov ah, 0Fh   
       int 10h
       mov AH, 0
       int 10h 
       
 ret 
endp