Para usar ipopt en Matlab >7.2 con el mex32 file

X=ipopt(StartPoint, val_lb, val_ub, zeros(1,nconst),zeros(1,nconst),'ipopt_f','eval_g','','','',[],'', 'hessian_approximation','limited-memory')


Hace falta definir una funcion que compute el gradiente (eval_g)
Antes se usaba ipoptFD.m pero ahora no reconoce las opciones.
Podemos intentar usar eval_grad de misqp (una adaptaci�n al menos).
Tambien hay que ver si con alguna opci�n activada, ipopt calcula
sus propias diferencias finitas.


Por otro lado, como el campo del gradiente se declara vacio, hay que a�adir esto al final:
'hessian_approximation','limited-memory'