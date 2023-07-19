
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

macro leerCadena entrada, tamanio
                       
      push si                          
      push cx           
          
          
      LOCAL lectura
      LOCAL finLectura
            
      mov si, 0
      mov cx, tamanio
      dec cx
      
      lectura:
            mov ah, 01h
            int 21h 
            
            cmp al, Enter
            je finLectura 
            
            mov entrada[si], al
           
            inc si                                                          
                       
      loop LOCAL lectura
      
      finLectura:
                      
                     
      mov entrada[si], "$"
      
      print saltoLinea                                
      pop cx
      pop si
      
endm


macro print msj 
    push dx
    push ax
    
    mov dx, offset msj
    mov ah, 9
    int 21h
    
    pop ax
    pop dx
endm          
         
macro println msj
    push dx
    push ax
    
    mov dx, offset msj  
    mov ah, 9
    int 21h
   
    mov dx, offset saltoLinea  
    mov ah, 9
    int 21h   
    
    pop ax
    pop dx
endm 

macro printNumero numero
    push ax
    push bx
    push dx  
    push si 
    push cx
          
    local obtenerDigitosLoop
    
    
    mov bx, 10
    mov ax, numero   
    mov si, 2d 
    mov cx, 2
        
    obtenerDigitosLoop:
        div bx           
        
        mov edadString[si], dx
        add edadString[si], 30h
        
        push ax
        
        mov ax, bx
        mov bx, 10
        mul bx
        mov bx, ax
        
        pop ax                    
        
        dec si
        dec si                            
   
    loop obtenerDigitosLoop      
    
    print edadString
    
    pop cx
    pop si
    pop dx
    pop bx
    pop ax    
    
endm 
      
macro pedir msj, entrada
   println msj
   leerCadena entrada,20d    
endm 
     
                                               
macro obtenerEdad anio1 anio2, resultado
      push cx
      push ax
      push bx
      push dx
      push si
      push di
                         
      local pasarDigitos1
      local pasarDigitos2
             
      mov cx, 4 ;la cantidad de digitos que tiene un anio
      mov ax, 0
      mov bx, 0
      mov dx, 0
      mov si, 0
      mov di, 1000
      pasarDigitos1:
          
          mov ah, 0
          mov al, anio1[si] 
          sub ax, 30h
          mul di
          
          add bx, ax            
          
          
          mov ax, di  
          push bx
          mov bx, 10d
          mov dx, 0d
          div bx
          pop bx
          mov di, ax
          
          
          inc si
      loop pasarDigitos1       
      
      push bx ; se guarda el valor obtenido
      
      mov cx, 4 ;la cantidad de digitos que tiene un anio
      mov ax, 0
      mov bx, 0
      mov dx, 0
      mov si, 0
      mov di, 1000
      pasarDigitos2:
          
          mov ah, 0
          mov al, anio2[si] 
          sub ax, 30h
          mul di
          
          add bx, ax            
          
          
          mov ax, di  
          push bx
          mov bx, 10d
          mov dx, 0d
          div bx
          pop bx
          mov di, ax
          
          
          inc si
      loop pasarDigitos2
      
      mov ax, bx          
      pop bx ;Se tienen ambos valores en uno y en otro
      
      sub ax, bx
      
      mov resultado, ax
      
      pop di
      pop si       
      pop dx       
      pop bx
      pop ax
      pop cx
endm

      

.data  
;variables de datos
cedula db          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
apellido db        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
nombre db          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
telefono db        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
direccion db       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
anioNacimiento db  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  
edad      dw       0
edadString dw      0,0,"$"

;mensajes
mensaje1  DB "Ingrese la cedula en formato VXXXXXX $"
mensaje2  DB "Ingrese el apellido $"
mensaje3  DB "Ingrese el nombre $"
mensaje4  DB "Ingrese el telefono $"    
mensaje5  DB "Ingrese la direccion $"
mensaje6  DB "Ingrese el anio de nacimiento $"

mensaje7  DB "Cedula: $"  
mensaje8  DB "Apellido: $"
mensaje9  DB "Nombre: $"
mensaje10  DB "Telefono: $"
mensaje11 DB "Direccion: $"
mensaje12 DB "Edad: $"
mensaje13 DB " Es mayor de edad $"
mensaje14 DB " Es menor de edad $"

mensajeSalida db "DATOS PERSONALES $"
;constantes
anioActual db "2023"
saltoLinea db 10,13,"$"  
enter db 0DH

.code      
mov edad, 19d     
 
               
pedir mensaje1, cedula
pedir mensaje2, apellido
pedir mensaje3, nombre
pedir mensaje4, telefono
pedir mensaje5, direccion
pedir mensaje6, anioNacimiento


println saltoLinea
                     
                     
;Se calcula la edad  
                
obtenerEdad anioNacimiento, anioActual, edad                     
                    

println mensajeSalida

print mensaje7
println cedula

print mensaje8
println apellido

print mensaje9
println nombre

print mensaje10
println telefono

print mensaje11
println direccion           

print mensaje12
printNumero edad 

cmp edad, 18
jge mayorEdad
jmp menorEdad

mayorEdad:  
print mensaje13

jmp finPrograma

menorEdad:

print mensaje14    


finPrograma:

ret


