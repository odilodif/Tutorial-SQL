/************Aqui haces una suma normal con group by por cada uno de los campos p.id, p.nombre*****************/

select	p.id,
		p.nombre,
		sum(r.puntos) as total
	from pilotos p inner join resultados r on
			p.id = r.piloto_id
	group by p.id, p.nombre
	order by total desc;
  
 
 /************** Aqui ya integras algo de funcion de ventana el OVER y aqui eliminas el group by ahora aparece todas las filas que intervienen y suma pero el total de todos los puntos de todas las carreras y de todos los pilotos un total=132 **********************/

select	p.id,
		p.nombre,
		sum(r.puntos) over () as total
	from pilotos p 
  inner join resultados r on 	p.id = r.piloto_id;
      
 /***********Recien aqui se genera las ventanas o las particiones por el id del piloto*******************/    

select	p.id,
		p.nombre,
		sum(r.puntos) over (partition by p.id) as total
	from pilotos p 
  inner join resultados r on 	p.id = r.piloto_id
	order by total desc;
  
/**********Aqui aumenta la columna r.puntos debido a que quiere los respectivos puntos de cada rows o fila y ordena la dos columnas de manera descendente******************/

select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total
	from pilotos p inner join resultados r on
			p.id = r.piloto_id
	order by total desc, r.puntos desc;
  
  
  
  
/*********Aqui entre una funcion de ventana row_number() donde a cada linea me va a poner un de manera incremental desde 1 hasta... nxxxx sin order by exterior  ahora el order by por el id del piloto dentro de la ventana ***************************/

select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total,
		row_number() over (order by p.id) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id;
      
      
      
      
/*********************Aqui se cambia el order by del ide de los pilotos por la columna r.puntos ordenados de manera descendente
  *********************************************/
select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total,
		row_number() over (order by r.puntos desc) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id
	order by total desc;
  
  
  
  
  
  /******************Agrega row_numbrer y se modifica over (partition by p.id order by r.puntos desc) se agrega la particion y se ordena por r.puntos de manera descendente*********/

select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total,
		row_number() over (partition by p.id order by r.puntos desc) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id;
      
      
      
      
      
/****************le quita la funcion SUM() y solo queda la funcion row_number con esto se logra ordenar los puntos de manera descendente  ******************/
		
select	p.id,
		p.nombre,
		r.puntos,
		row_number() over (partition by p.id order by r.puntos desc) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id;
      
            
 /*************Aqui realiza un subquery donde ya estan ordenados y spliteados por cada piloto pero quiere solo los 4 primeros lugares ****************/
		
select 	id,
		nombre,
		sum(puntos) as total
	from	(
	select	p.id,
			p.nombre,
			r.puntos,
			row_number() over (partition by p.id order by r.puntos desc) as ranking
		from pilotos p inner join resultados r on
				p.id = r.piloto_id
			) as subconsulta
	where ranking <= 4
	group by id, nombre
	order by total desc;