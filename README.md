## Respuestas Parte 2
El concepto de polimorfismo fue util ya que me permite no tener que realizar verificaciones para cada emocion, 
como todas reciben el mismo mensaje y saben que deben hacer, simplemente les envio que evento ocurrio y cada una
gesiona como debe actuar, ya que ellas son quienes conocen su estado interno. 
Me permite simplificar y optimicar mucho el codigo al no tener que utilizar verificaciones previas a cada mensaje

Herencia me permite evitar repetir logica, y de esta forma reducir la cantidad de codigo que escribo
unificando metodos y variables comunes de distintas clases en una superclase superior a estas. 
De esta forma, ademas, cualquier cambio en esta clase superior se refleja en quienes heredan, facilitando
correciones y cambio de codigo
Por ende puedo hacer metodos comunes en la clase emocion que pasen en todas las otras clases de cada emocion, sin 
herencia tendria que copiar el mismo metodo en las otras 6 emociones

