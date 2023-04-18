-- CONSULTAS


use gimnasio_proyecto;

-- 1. Muestra el producto del tipo "proteinas" m�s vendido.

select pn2.*, from productos_nutricion pn2 where pn2.nombre_producto like (
select pn.nombre_producto from productos_nutricion pn inner join compra c 
on pn.id_producto =c.id_producto group by pn.nombre_producto order by sum(pn.precio*c.cantidad) desc limit 1
);




-- 2. Muestra el usuario que m�s ha gastado en productos de nutrici�n.

select u.id_usuario ,u.nombre ,sum(pn.precio*c.cantidad) as total from productos_nutricion pn inner join compra c
on pn.id_producto =c.id_producto inner join usuario u on c.id_usuario =u.id_usuario group by u.id_usuario 
order by total desc limit 1;



-- 3. Cual es la actividad que m�s reservas ha tenido. Muestra todos los datos del monitor que la imparte.

select ae.nombre_actividad ,count(r.id_actividad) as num_reservas, m.* from reserva r inner join actividades_especiales ae 
on r.id_actividad =ae.id_actividad inner join monitor m on ae.id_monitor =m.id_monitor group by ae.nombre_actividad 
order by num_reservas desc limit 1;


-- 4. Muestra cual es el monitor que lleva m�s tiempo contratado.
select m.* from monitor m where m.fecha_contratacion like (select min(m2.fecha_contratacion) from monitor m2 );


-- 5. Muestra la rutina m�s usada por los usuarios y los datos del monitor que la realiz�.

select r.nombre_rutina ,count(ur.id_rutina) as num_veces,m.* from usuarios_rutina ur inner join rutina r 
on ur.id_rutina =r.id_rutina inner join monitor m on r.id_monitor =m.id_monitor group by r.nombre_rutina 
order by num_veces desc limit 1;


________________________________________________________________________________________________________________________

						-- FUNCIONES

/* crea una funcion sql que al pasarle un id de monitor como parametro devuelva toda la informacion sobre ese monitor. 
 * Si ese id no corresponde a ningun monitor la funcion debe devolver -1.

use gimnasio_proyecto;

DELIMITER $$
CREATE FUNCTION get_monitor_info (monitor_id INT) RETURNS VARCHAR(100) deterministic
BEGIN
 	DECLARE nombre_monitor VARCHAR(100);
 	SELECT m.nombre INTO nombre_monitor 
 	FROM monitor m WHERE m.id_monitor = monitor_id;

 IF nombre_monitor IS NULL THEN
 	SET nombre_monitor = -1;
 END IF;
 
 RETURN nombre_monitor;

end $$;

select get_monitor_info (3);
 */



/*Dado un id de actividad especial pasado por parametros, devolver la duraci�n total en horas de todas las sesiones 
 * realizadas de esa actividad.
 
use gimnasio_proyecto;

DELIMITER $$
CREATE FUNCTION actividades_duracion (actividad_id INT) RETURNS int deterministic
BEGIN
 	DECLARE duracion_total int;
 	SELECT sum(ae.duracion)/60 into duracion_total from actividades_especiales ae inner join reserva r 
 	on ae.id_actividad =r.id_actividad 
	where ae.id_actividad =actividad_id;
 
 RETURN duracion_total;

end $$;

select actividades_duracion (2);


						-- PROCEDIMIENTOS

*/
/*Procedimiento que muestre todos los usuarios que han recibido una rutina del entrenador pasado por par�metros (usando una
 * funci�n desarrollada antes).


delimiter $$
create procedure mostrar_usuarios_x_entrenador (in num_monitor int)
begin
	select u.*, r.nombre_rutina from monitor m inner join rutina r on m.id_monitor =r.id_monitor 
	inner join usuarios_rutina ur on r.id_rutina =ur.id_rutina inner join usuario u on ur.id_usuario =u.id_usuario 
	where m.nombre like (select get_monitor_info (num_monitor));

end $$

call mostrar_usuarios_x_entrenador(3);

 */


/*Haz un procedimiento que, dado un nombre de ejercicio pasado por par�metros, devuelva la dificultad,el nombre y descripci�n
 * del ejercicio, as� como en que rutinas se encuentra ya incluido y cu�ntas veces.


delimiter $$
create procedure informe_ejercicios (in nombre_ejercicio varchar(100))
begin
	select  re.id_rutina, count(re.id_ejercicio),eg.nivel,eg.nombre ,eg.descripcion FROM ejercicios_gym eg 
 	inner join rutina_ejercicio re on eg.id_ejercicio =re.id_ejercicio where eg.nombre like nombre_ejercicio
 	group by re.id_rutina 
 ;

end $$

call informe_ejercicios('Banded crunch isometric hold');

*/

						-- CURSOR

use gimnasio_proyecto;
					
					delimiter &&
					create procedure mostrar_estadisticas()
					begin
					    declare salida varchar(10000) default '========ESTADISTICAS=======\n-----------Totales-------\nVentas Totales: ';
					    declare total decimal(15,2);
					    declare done bool default FALSE;
					    declare anio integer;
					    declare contador integer default 1;
					    declare contador2 integer default 1;
					    declare dia varchar(20) default '';
					    declare mes varchar(20) default '';
					    declare c1 cursor for  -- CURSOR DE A�OS
					        select year(c.fecha_compra), sum(pn.precio*c.cantidad)
					        from productos_nutricion pn
					        inner join compra c on pn.id_producto = c.id_producto
					        group by year(c.fecha_compra);
					    declare c2 cursor for   -- CURSOR DIAS
					        select dayname(c.fecha_compra), sum(pn.precio*c.cantidad)
					        from productos_nutricion pn
					        inner join compra c on pn.id_producto = c.id_producto
					        group by dayname(c.fecha_compra)
					        order by dayofweek(c.fecha_compra) asc;
					    declare c3 cursor for   -- CURSOR MESES
					        select monthname(c.fecha_compra), sum(pn.precio*c.cantidad)
					        from productos_nutricion pn
					        inner join compra c on pn.id_producto = c.id_producto
					        group by monthname(c.fecha_compra)
					        order by month(c.fecha_compra) asc;
					    declare continue HANDLER FOR NOT FOUND SET done = TRUE;   -- para salir del bucle del cursor
						    select sum(pn.precio*c.cantidad) into total
						    from productos_nutricion pn
						    inner join compra c on pn.id_producto = c.id_producto;
					   		set salida = concat(salida, total, '�\n');
					    open c1;    -- recorremos el cursor de a�os
					    while (NOT done) do
					        fetch c1 into anio, total;
					        if (NOT done) then
					            set salida = concat(salida, 'En ', anio, ': ', total, '�\n');
					        end if;
					    end while;
					    close c1;
					    set salida = concat(salida, '=============LISTADOS==========\n');
					    set salida = concat(salida, '----------Valor de las ventas por d�a--------\n');
					    set done = false;     -- hay que iniciarlo otra vez porque lo cambiamos a true antes
					    open c2;
					    while (NOT done) do
					        fetch c2 into dia, total;
					        if (NOT done) then
					            set salida = concat(salida, contador, '.', dia, ': ', total, '�\n');
					            set contador = contador + 1;
					        end if;
					    end while;
					    close c2;
					    open c3;   -- RECORREMOS EL CURSOR DE MESES
					    set salida = concat(salida, '----------Valor de las ventas por mes--------\n');
					    set done = false;    					    -- hay que iniciarlo otra vez porque lo cambiamos a true antes
					    while (NOT done) do
					        fetch c3 into mes, total;
					        if (NOT done) then    
						set salida = concat(salida, contador2, '.', mes, ': ', total, '�\n');
						set contador2 = contador2 + 1;
						end if;
					    end while;
					    close c3;
						set salida = concat(salida, '===============================\n');
					
					    select salida;
					end &&
					
					call mostrar_estadisticas(); 

