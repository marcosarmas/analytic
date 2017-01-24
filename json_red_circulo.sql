declare @id varchar(10),
		@link varchar(max),
		@imagen varchar(max)


create table #tmp(
	fila varchar(max)
)
declare @fila varchar(max)
	declare @c int
	declare @link2 varchar(max)

/*declare cur_personas cursor for
select id, link, [imagen-src] from personas where id in (select id_origen from amigos_comunes_conexiones)
open cur_personas
fetch next from cur_personas into @id, @link, @imagen
while @@FETCH_STATUS <> -1
begin
	set @c = 0
	set @link2 = ''
	set @fila = ''
	set @fila = @fila + '{"name":"'+@link+'",'
	select @c=count(*) from amigos_comunes_conexiones where id_origen = @id
	set @fila = @fila + '"size":'+ cast(@c as varchar) +','
	set @fila = @fila + '"imports":[' 
	
	declare cur_link cursor for
	select link from amigos_comunes_conexiones 
	where id_origen = @id 
	open cur_link
	fetch next from cur_link into @link2
	while @@FETCH_STATUS <> -1
	begin
		set @fila = @fila + '"'+@link2+'",' 
		fetch next from cur_link into @link2
	end
	close cur_link deallocate cur_link
	set @fila = substring(@fila,1,len(@fila)-1)
	set @fila = @fila + '], "image":"'+@imagen+'"},'
	insert into #tmp values(@fila)
	fetch next from cur_personas into @id, @link, @imagen
end
close cur_personas deallocate cur_personas
*/

		
declare cur_personas cursor for
select id_destino, link, [imagen-src] from amigos where id_destino in (select id_origen from amigos_comunes_conexiones)
open cur_personas
fetch next from cur_personas into @id, @link, @imagen
while @@FETCH_STATUS <> -1
begin
	set @c = 0
	set @link2 = ''
	set @fila = ''
	set @fila = @fila + '{"name":"'+@link+'",'
	select @c=count(*) from amigos_comunes_conexiones where id_origen = @id
	set @fila = @fila + '"size":'+ cast(@c as varchar) +','
	set @fila = @fila + '"imports":[' 
	
	declare cur_link cursor for
	select link from amigos
	where id_destino in (select id_destino from amigos_comunes_conexiones where id_origen = @id)
	and id_destino in (select id_origen from amigos_comunes_conexiones)
	open cur_link
	fetch next from cur_link into @link2
	while @@FETCH_STATUS <> -1
	begin
		set @fila = @fila + '"'+@link2+'",' 
		fetch next from cur_link into @link2
	end
	close cur_link deallocate cur_link
	set @fila = substring(@fila,1,len(@fila)-1)
	set @fila = @fila + '], "image":"'+@imagen+'"},'
	insert into #tmp values(@fila)
	fetch next from cur_personas into @id, @link, @imagen
end
close cur_personas deallocate cur_personas

select * from #tmp

drop table #tmp