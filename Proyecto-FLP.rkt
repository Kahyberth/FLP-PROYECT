#lang eopl


;INTEGRANTES
;Kahyberth Stiven Gonzalez Sayas:2060121
;Juan Camilo Varela Ocoro:206016

;Nota: Cada ejemplo aparece al lado de cada especificacion lexicografica.

#|
-------------------------------------------------------------------------------------------->

<Gramatica>

<programa>  ::== <expresion>
<expresion> ::== <bool-expresion>
<expresion> ::== <identificador>
<expresion> ::== <numero>
<expresion> ::== <primitiva>
<expresion> ::== "Console.log" "(" {<identificador>}* ")"
<expresion> ::== "let" { <identificador> = <expresion> }*(,) "in" <expresion> "end"
<expresion> ::== "set" <identificador> ":=" <expresion>
<expresion> ::== "begin" <expresion> {<expresion>}*(;) "end"
<expresion> ::== "{" <expresion> <bool-primitiva> <expresion> "}"
<expresion> ::== "[" {<expresion>}*(,) "]"
<expresion> ::== "(" <expresion> primitiva <expresion> ")"
<expresion> ::== "Array" "." {<expresion>}*(,) "." primitiva
<expresion> ::== <bool-oper> <bool-expresion>
<expresion> ::== "if" <bool-expresion> "then" <expresion> "else" <expresion> "end"
<expresion> ::== "proc" "(" {<identificador>}*(,) ")" <expresion> "end"
<expresion> ::== "for" <identificador> "=" <expresion< "to" <expresion< "do" <expresion> "end"
<expresion> ::== "while" <bool-expresion> "then" expresion "end"
<expresion> ::== "struct" "=" identificador "(" (separated-list expresion ",") ")"

<bool-expresion> ::== 
                     true
                     false
                     <bool-primitiva> "(" {<expresion>}*(,) ")"
                     <bool-oper> "(" {<bool-expresion>}*(,) ")"

<primitiva> ::== + |-|*|%|=| add1 | sub1 | length | concat

<bool-primitiva> ::== < | > | <= | >= | != | ==

<bool-oper> ::== not | and | or
-------------------------------------------------------------------------------------------->

|#



;Especificacion lexicografica

(define especificacion-lexica
  '(
    (espacio-blanco (whitespace) skip)
    (comentario ("//" (arbno (not #\newline))) skip)
    (identificador (letter (arbno (or letter digit "?" "$"))) symbol)
    (numero (digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero (digit (arbno digit)"." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)"." digit (arbno digit)) number)
    )
  )

;Especificacion gramatical

(define especificacion-gramatical
  '(
    (programa (expresion)a-program) ;Programa
    (expresion(bool-expresion)bool-exp) ;Bool-expresion
    (expresion(identificador)var-exp) ;Identificadores
    (expresion(numero)lit-exp) ;Numeros
    (expresion("let" (arbno identificador "=" expresion) "in" expresion)let-exp) ;let q = Array.[1,2,3,4,5,6].length in let k = Array.[Hola,Mundo].concat in 2
    (expresion("console.log" "(" "\"" (arbno identificador)  "\"" ")") console-exp);console.log("Hola Mundo")
    (expresion( "\"" (arbno identificador)  "\"") text-exp) ;"Hola" ---> "Hola"
    (expresion("set" identificador ":=" expresion)set-exp) ;set hola := adios
    (expresion("begin" expresion (separated-list expresion ";") "end" )begin-exp); begin (x = 5) if {x < 10} then mayor else menor end;set x := 10 end
    (expresion(primitiva)prim-exp) ;Representa las primitivas
    (expresion("("  expresion primitiva expresion (arbno primitiva expresion) ")")op-exp) ;Representa las operaciones -> (1 + 2 + 3 + 4 + 5 + 6)
    (expresion("Array" "." "[" (separated-list expresion ",") "]" "." primitiva )only-exp) ;Array.[1,2,3,4,5,6,7].length, example
    (expresion("[" (separated-list expresion ",") "]" "." primitiva) lst-exp) ;[123,321,3,4,3,21,32]
    (expresion("if" bool-expresion "then" expresion "else" expresion ";")if-exp) ;if {3 < 2} then 2 else 3 end
    (expresion("proc" "(" (separated-list identificador ",") ")" expresion "end")proc-exp) ; proc (Arroz,Pollo,Gasimba) Pollo end
    (expresion("for" identificador "=" expresion "to" expresion "do" expresion "end")for-exp) ;for bucle = Array.[1,2,3,4,5].length to 4 do 5 end
    (expresion("while"  expresion "then" expresion "end")while-exp) ;while {x < 3} then (x = (x + 1)) end, example
    (expresion("struct" "=" identificador "(" (separated-list expresion ",") ")")struct-exp) ;struct = Menu (Salmon,Pollo,Sopa,Salchipapa,Cafe,Gaseosa)
    (expresion("struct-access" "." expresion)access-exp) ;struct-access.author
    (expresion("struct-change" "." expresion "=" expresion)change-exp) ;struct-change.author = StephenKing
    
    ;Bool-expresion

    (bool-expresion("true")true-bool) ;true
    (bool-expresion("false")false-bool) ;false
    (bool-expresion ("{" expresion  bool-primitiva expresion "}") bool-prims) ;{4 < 5}
    (bool-expresion(bool-oper)bool-op);Bool-oper
    (bool-expresion("." "[" expresion bool-oper expresion "]")bool-logic);Bool-oper
    
    ;Primitivas

    (primitiva ("+")sum-prim)     ;+
    (primitiva ("-")res-prim)     ;-
    (primitiva ("*")mul-prim)     ;-
    (primitiva ("=")equal-prim)
    (primitiva ("/")div-prim)     ; Ejemplos
    (primitiva ("add1")add1-prim) ; Array.[1].add1
    (primitiva ("sub1")sub1-prim) ; Array.[2].sub1
    (primitiva ("%")mod-prim)   ; (20 % 2)
    (primitiva ("length")length-prim) ; Array.[2,3,21,5,6,12].length
    (primitiva ("concat")concat-prim) ; Array.[Hola,Mundo].concat
    
 
    ;Bool-primitiva
    
    (bool-primitiva("<")menor-prims)        ; {5 < 6}
    (bool-primitiva(">")mayor-prims)        ; {7 > 6}
    (bool-primitiva("<=")menor-igual-prims) ; {3 <= 6}
    (bool-primitiva(">=")mayor-igual-prims) ; {89 >= 21}
    (bool-primitiva("==")igual-prims)       ; {7 == 7}
    (bool-primitiva("!=")difer-prims)       ; {4 != 3}

    ;Bool-operation
    
    (bool-oper("and")and-op) ;.[{3 < 4} and {3 > 4}]        |
    (bool-oper("or")or-op)   ;.[{2 <= 4} or {4 == 4}]       v segundo ejemplo
    (bool-oper("not")not-op)    ; not .[{4 < 4} or {3 > 2}] // .[{4 < 4} not {3 > 2}]

    ))

;Generar datatytpes

(sllgen:make-define-datatypes especificacion-lexica especificacion-gramatical)
;(define data (sllgen:show-define-datatypes especificacion-lexica especificacion-gramatical))


;Evaluar programa
(define evaluar-programa
  (lambda (pgm)
    (cases programa pgm
      (a-program (exp) (evaluar-expresion exp ambiente-inicial))
      ))
  )

;Definicion de ambientes
(define-datatype ambiente ambiente?
  (ambiente-vacio)
  (ambiente-extendido
   (lid (list-of symbol?))
   (lva vector?)
   (env ambiente?))
  (ambiente-extendido-recursivo
   (proc-names (list-of symbol?))
   (llargs (list-of (list-of symbol?)))
   (lbodys (list-of expresion?)) ;Cuerpo procs
   (env ambiente?));Expresion a evaluarambiente-extendido-recursivo
   )
  


(define apply-env
  (lambda (amb var)
    (deref (apply-env-ref amb var))))


(define apply-env-ref
  (lambda (env var)
    (cases ambiente env
      (ambiente-vacio () (eopl:error "No se encuentra la ligadura " var))
      (ambiente-extendido
       (lid lval old-env)
       (letrec
           (
            (buscar-id
             (lambda (lidd lvall varr pos)
               (cond
                 [(null? lidd) (apply-env-ref old-env varr)]
                 [(eqv? (car lidd) varr) (a-ref pos lvall)]
                 [else (buscar-id (cdr lidd) lvall varr (+ pos 1))])))
            )
         (buscar-id lid lval var 0)))
      
      (ambiente-extendido-recursivo
       (proc-names llargs bodies env-old)
       (letrec(
               (buscar-proc
                (lambda (proc-names llargs bodies)
                  (cond
                    [(null? proc-names)
                     (apply-env-ref env-old var)]
                    [(eqv?(car proc-names)var)
                     (a-ref 0 (list->vector (list(clausura (car llargs)(car bodies)env))))]
                    [else
                     (buscar-proc (cdr proc-names)
                                  (cdr llargs)
                                  (cdr bodies))]))))
         (buscar-proc proc-names llargs bodies))))))


    

(define ambiente-inicial
  (ambiente-extendido '(x y z) (list->vector '(1 2 3)) 
                      (ambiente-extendido '(a b c) (list->vector '(4 5 6))
                                          (ambiente-vacio))))


(define-datatype procval procval?
  (clausura (lid (list-of symbol?))
            (body expresion?)
            (env ambiente?)))



;Evaluacion de expresiones
(define evaluar-expresion
  (lambda (exp env)
    (cases expresion exp
      (lit-exp (exp) exp)
      (var-exp (exp) (apply-env env exp))
      (prim-exp (prim)(evaluar-primitivas prim env)) 
      (bool-exp(exp)(evaluar-bool-exp exp env))  
      (text-exp (exp)(let([x(map(lambda(x) (symbol->string x))exp)])(car x)))
      (console-exp (txt)(let
                  ([texto (map(lambda(x) (symbol->string x))txt)])
                  (letrec
                    ((concatenate(lambda (lista-txt)
                       (cond
                         [(null? lista-txt)""]
                         [(list? lista-txt)(string-append (car lista-txt)" "(concatenate(cdr lista-txt)))]
                         [else (concatenate (cdr lista-txt))]))))(concatenate texto))))

      (if-exp (bool exp1 exp2)(let([ls-exp(evaluar-expresion exp1 env)]
                                   [ls-exp2(evaluar-expresion exp2 env)])
                                (if (evaluar-bool-exp bool env)
                                    ls-exp
                                    ls-exp2)))

      (let-exp (ids rands body)
               (let
                   (
                    (ls-rands (map(lambda (x) (evaluar-expresion x env))rands))
                    )
                 (evaluar-expresion body (ambiente-extendido ids ls-rands env))))

      (op-exp (exp prim exp2 prim2 lsexp)
                (let*
                    (
                     [ls-exp1(evaluar-expresion exp env)]
                     [ls-exp2(evaluar-expresion exp2 env)]
                     [ls-exp3(map(lambda(x)(evaluar-expresion x env))lsexp)]
                     )
                  (evaluar-primitivas prim ls-exp1 ls-exp2 prim2 ls-exp3)))

      (only-exp (expresion primitiva)
                (let
                    (
                     [ls-exp (map(lambda(x)(evaluar-expresion x env))expresion)]
                     )
                  (evaluar-alternativa primitiva ls-exp)))

      (lst-exp (exp prim)
               (let([x(map(lambda(y)(evaluar-expresion y env))exp)])
                 (evaluar-alternativa prim x)))

      (begin-exp (exp lexp)
                 (if (null? lexp)
                   (evaluar-expresion exp env)
                   (begin
                     (evaluar-expresion exp env)
                (letrec
                    ((eval-exps
                      (lambda (lexp)
                        (cond
                 [(null? (cdr lexp)) (evaluar-expresion (car lexp) env)]
                 [else
                  (begin
                    (evaluar-expresion (car lexp) env)
                    (eval-exps (cdr lexp)))]))))
                       (eval-exps lexp)))))
      
      
      (set-exp (id exp)
               (let
                   (
                    [ref (apply-env-ref env id)]
                    [val (evaluar-expresion exp env)]
                    )
                 (begin
                   (set-ref! ref val)0)))

     (while-exp (it exp)
                (letrec
                    (
                     [contador 0]
                     [it1 (evaluar-expresion it env)]
                     [exp1 (evaluar-expresion exp env)]
                     [while(lambda (iter expr)
                             (cond
                               [(eqv? iter expr)expr]
                               [else (while (+ 1 iter) expr)]))])
                  (while 1 exp1)))
                            
      (else 0))))


;Evaluar-primitivas booleanas 
(define evaluar-bool-exp
  (lambda (bool-exp env)
    (cases bool-expresion bool-exp
      (true-bool()#true)
      (false-bool()#false)
      (bool-prims (expresion bool expresion1)(let((lista-exp2(evaluar-expresion expresion env))
                                                  (lista-exp3(evaluar-expresion expresion1 env)))
                                               (evaluar-primitiva-bool bool lista-exp2 lista-exp3)))
      (bool-logic (exp bool-logic exp2)(let
                                           (
                                            [ls-exp1 (evaluar-expresion exp env)]
                                            [ls-exp2 (evaluar-expresion exp2 env)]
                                            )
                                         (evaluar-operadores bool-logic ls-exp1 ls-exp2)))
                                         
      (else "ok"))))

;Evaluar primitivas booleanas
(define evaluar-primitiva-bool
  (lambda (bool-exp lval1 lval2)
    (cases bool-primitiva bool-exp
      (menor-prims () (< lval1 lval2))
      (mayor-prims () (> lval1 lval2))
      (menor-igual-prims () (<= lval1  lval2))
      (mayor-igual-prims () (>= lval1  lval2))
      (igual-prims () (eqv? lval1 lval2))
      (difer-prims () (eqv? (not lval1) lval2))
      (else "ok"))))


(define evaluar-operadores
  (lambda (logic lval lval2)
    (cases bool-oper logic
      (and-op ()(and lval lval2))
      (or-op () (or lval lval2))
      (not-op () (not lval))
      (else 0))))

(define evaluar-primitivas
  (lambda (prim lval lval2 prim2 ls-exp)
    (cases primitiva prim
      (sum-prim () (operacion + lval lval2 ls-exp 0))
      (res-prim () (operacion - lval lval2 ls-exp 0))
      (mul-prim () (operacion * lval lval2 ls-exp 0))
      (div-prim () (operacion / lval lval2 ls-exp 0))
      (else "ok"))))

(define evaluar-alternativa
  (lambda (prim lval1)
    (cases primitiva prim
      (sum-prim () (+ (car lval1) (cadr lval1)))
      (res-prim () (- (car lval1) (cadr lval1)))
      (mul-prim () (* (car lval1) (cadr lval1)))
      (div-prim () (/ (car lval1) (cadr lval1)))
      (mod-prim () (modulo (car lval1) (cadr lval1)))
      (length-prim () (length lval1))
      (concat-prim () (string-append (car lval1) (cadr lval1)))
      (add1-prim () (+ 1 (car lval1)))
      (sub1-prim () (- (car lval1)1 ))
      (else 0))))

  
(define operacion
  (lambda (op lval lval2 lsexp ac)
    (cond
      [(null? lsexp)0]
      [(list? lsexp)(letrec
                        ((operacion-interna (lambda (lsexp1 ac)
                                         (cond
                                           [(null? lsexp1)0]
                                           [else (op (car lsexp1) (operacion-interna (cdr lsexp1) ac))]))))
                      (op lval lval2 (operacion-interna lsexp 0)))]
      [else eopl:error"No se puede realizar la suma"])))



;Referencia
(define-datatype referencia referencia?
  (a-ref (pos number?)
         (vec vector?)))
;Extractor de referencia
(define deref
  (lambda (ref)
    (primitiva-deref ref)))

;Extractor de la posición del vector
(define primitiva-deref
  (lambda (ref)
    (cases referencia ref
      (a-ref (pos vec)
             (vector-ref vec pos)))))

;Muta el valor pasado por posición del vector

(define set-ref!
  (lambda (ref val)
    (primitiva-setref! ref val)))

;Función que se encarga de mutar el valor del vector
(define primitiva-setref!
  (lambda (ref val)
    (cases referencia ref
      (a-ref(pos vec)
            (vector-set! vec pos val)))))





;(define apply-env
;  (lambda (env var)
;    (deref (apply-env-ref env var))))


;----------------------------------------------------------------------------------------

;Interpretador
(define interpretador
  (sllgen:make-rep-loop "-->" evaluar-programa
                        (sllgen:make-stream-parser
                         especificacion-lexica especificacion-gramatical)))

(interpretador)
