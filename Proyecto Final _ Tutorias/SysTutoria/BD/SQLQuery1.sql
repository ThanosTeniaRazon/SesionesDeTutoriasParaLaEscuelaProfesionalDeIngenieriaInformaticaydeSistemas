USE master;
GO
DROP DATABASE tutoria;
 
CREATE DATABASE tutoria;

USE tutoria;

create table login(
	id_usuario int primary key identity(1,1),
	Usuario			varchar(30)NOT NULL,
	contra			varchar(20)NOT NULL,
	tipo			varchar(20)NOT NULL,
);

CREATE TABLE Alumno (
		Codigo		varchar(6) primary key,
		Nombres		varchar(40)NOT NULL,
		AP			varchar(40)NOT NULL,
		AM			varchar(40)NOT NULL,
		Correo		varchar(25)NOT NULL,
);
CREATE TABLE Docentes
(
    CodigoDocentes	varchar(50) primary key,
	Nombre			varchar(50) NOT NULL,
    Paterno			varchar(50) NOT NULL,
    Materno			varchar(50) NOT NULL,	
	Correo			varchar(50) NOT NULL
);

CREATE TABLE Asignacion
(
	id_asignacion INT IDENTITY(1, 1) primary key,
	Codigo			varchar(6)NOT NULL,
	Nombres			varchar(50)NOT NULL,
	AP				varchar(40)NOT NULL,
	AM				varchar(40)NOT NULL,	
	Correo			varchar(25)NOT NULL,
	Docente			varchar(50)NOT NULL,
	foreign key (Codigo) references Alumno (Codigo),
	foreign key (Docente) references Docentes (CodigoDocentes)
);


 CREATE TABLE tutoria (
    id_asignacion    int primary key,
	codigo			varchar(50)NOT NULL,
    Fecha           varchar(255)NOT NULL,
	Hora			varchar(50)NOT NULL,
    Tema            varchar(255)NOT NULL,
	Asistencia      Varchar(8)NOT NULL,	
	Docente         varchar(50)NOT NULL,	
	foreign key (id_asignacion) references Asignacion (id_asignacion)
);



 create procedure spAlumno
   @metodo			int,
   @Codigo			varchar(6),
   @Nombres			varchar(40),
   @AP				varchar(40),
   @AM				varchar(40),
   @Correo			varchar(25)
   as
   begin
     if @metodo=1
	 begin
	   insert into Alumno values (@Codigo,@Correo,@AP,@AM,@Nombres)
	 end
	 if @metodo=2
	 begin
	   update Alumno set Nombres=@Nombres,Correo=@Correo,AP=@AP,AM=@AM where Codigo=@Codigo
	 end
	 if @metodo=3
	  begin
	  delete Alumno where Codigo=@Codigo
	  end
	 if @metodo=4
	 begin
	  select * from Alumno
	 end
   end

create procedure spDocentes
   @metodo int,
   @CodigoDocentes varchar(50),
   @Nombre varchar(50),
   @Paterno varchar(50),
   @Materno varchar(50),
   @Correo  varchar(50)
   as
   begin
     if @metodo=1
	 begin
	   insert into Docentes values (@CodigoDocentes,@Nombre,@Paterno,@Materno,@Correo)
	   insert into login values(@CodigoDocentes,@Paterno,'Usuario')
	 end
	 if @metodo=2
	 begin
	   update Docentes set Nombre=@Nombre,Paterno=@Paterno,Materno=@Materno,Correo=@Correo where CodigoDocentes=@CodigoDocentes
	 end
	 if @metodo=3
	  begin
	  delete Docentes where CodigoDocentes=@CodigoDocentes
	  end
	 if @metodo=4
	 begin
	  select * from Docentes
	 end
   end

create procedure spfiltrar
as
	with c as
		(select id_asignacion, Codigo,Nombres,AP,AM,Correo,
		ROW_NUMBER() over (partition by Codigo,Nombres,AP,AM,Correo order by id_asignacion) as duplicado
		from Asignacion )
		delete from c 		
		where duplicado > 1
		select * from Asignacion

exec spfiltrar
	
create procedure spAsignacion
   @metodo int,
   @Codigo  varchar(6),
   @Nombres varchar(50),
   @AP varchar(40),
   @AM varchar(40),
   @Correo varchar(25),
   @Docente  varchar(50)
  as
   begin
     if @metodo=1
	 begin
	   insert into Asignacion values (@Codigo,@Nombres,@AP,@AM,@Correo,@Docente)
	   exec spfiltrar
	 end
	 if @metodo=2
	 begin
	   update Asignacion set Codigo = @Codigo,Nombres=@Nombres,AP=@AP,AM=@AM,Correo=@Correo,Docente=@Docente where Codigo= @Codigo
	 end
	 if @metodo=3
	  begin
	  delete Asignacion where Codigo=@Codigo
	  end
	 if @metodo=4
	 begin
	  select * from Asignacion
	 end
   end

	/*select D.CodigoDocentes, D.Nombre + ' ' + D.Paterno + ' ' + D.Materno as datos into #t11 
	from Asignacion A inner join Docentes D on A.Docente = D.CodigoDocentes 
	select * from #t11 where CodigoDocentes = 'AHH2491';
	drop table #t11*/
	create procedure spTutoria
	   @metodo int,
	   @id_asignacion int,
	   @codigo   varchar(50),
	   @Fecha  varchar(255),
	   @Hora   varchar(50),
	   @Tema   varchar(255),
	   @Asistencia Varchar(8),
	   @Docente    varchar(50)
	   as
	   begin
		 if @metodo=1
		 begin
		   insert into tutoria values (@id_asignacion,@codigo,@Fecha,@Hora,@Tema,@Asistencia,@Docente)
		   select * from tutoria where  Docente = @Docente
		 end
		 if @metodo=2
		 begin
		   update tutoria set codigo =@codigo,Fecha=@Fecha,Hora = @Hora,Tema=@Tema,Asistencia=@Asistencia,Docente = @Docente where id_asignacion=@id_asignacion
		 end
		 if @metodo=3
		  begin
		  delete tutoria where id_asignacion=@id_asignacion
		  select * from tutoria where  Docente = @Docente
		  end
		 if @metodo=4
		 begin
		  select * from tutoria
		 end
	   end


INSERT INTO login(Usuario,contra,tipo) values('LER2154','ENCISO','Admi');
INSERT INTO login(Usuario,contra,tipo) VALUES('ACM2247', 'COLLANTES','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('JCL2235','CARBAJAL','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('NAU2112','ACURIO','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('JRH2236','ROZAS','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('LFP2479','FLORES','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('ECP2332','CARRASCO','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('EPO2173','PALOMINO','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('DCO2463','CANDIA','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('RVS2229','VILLAFUERTE','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('GTP2365','TICONA','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('YOA2196','ORME�O','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('IMV2447','MEDRANO','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('LPT2214','PALMA','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('RAP2332','ALZAMORA','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('WIZ2414','IBARRA','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('KMM2431','MEDINA','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('JCC2346','CHAVEZ','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('VCS2195','CHOQUE','Usuario');
INSERT INTO login(Usuario,contra,tipo) values('MPF2244','PE�ALOZA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('JPQ2067', 'PILLCO','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('LBC2123','BACA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('EPV2011','PACHECO','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('WZP2341','ZAMALLOA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('HVO2005','VERA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('ECA2410','CUTIPA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('DDB2125','DUE�AS','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('DAC2180','AGUIRRE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('TVV2335', 'VILLALBA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('CMC2078','MONTOYA','Usuario');
INSERT INTO login(Usuario,contra,tipo)VALUES('CQO2098','QUISPE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('VSJ2102','SOSA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('BCL2116', 'CHULLO','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('HUR2445','UGARTE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('LMC2115', 'MONZON','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('RDJ2440','DUE�AS','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('JGS2220','GAMARRA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('JQS2103', 'QUISPE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('RHH2177','HUILLCA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('VLA2087','LAVILLA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('HCB2094','CCAYAHUILLCA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('EFH2443','FALCON','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('SCL2479', 'COSIO','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('LDC2397','DIAZ','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('MVV2086', 'VENEGAS','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('HLC2098','DUE�AS','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('GQT2499', 'QUISPE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('RAM2373','ABARCA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('GZR2258', 'ZU�IGA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('AHH2491','HUAMANI','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('VQS2300','QUISPE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('OVL2243', 'VILLENA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('MMQ2499', 'MERMA','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('ARD2329','ROZAS','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('SVR2276', 'VELAZQUE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('JAC2280','ANDRADE','Usuario');
INSERT INTO login(Usuario,contra,tipo) VALUES('NOH2021','OCHOA','Usuario');

INSERT INTO Docentes VALUES('LER2154', 'LAURO', 'ENCISO', 'RODAS', 'lauro.enciso@unsaac.edu.pe');
INSERT INTO Docentes VALUES('JCL2235', 'JULIO C�SAR', 'CARBAJAL', 'LUNA', 'julio.carbajal@unsaac.edu.pe');
INSERT INTO Docentes VALUES('NAU2112', 'NILA ZONIA', 'ACURIO', 'USCA', 'nila.acurio@unsaac.edu.pe');
INSERT INTO Docentes VALUES('JRH2236', 'JAVIER ARTURO', 'ROZAS', 'HUACHO', 'javier.rozas@unsaac.edu.pe');
INSERT INTO Docentes VALUES('LFP2479', 'LINO PRISCILIANO', 'FLORES', 'PACHECO', 'lino.pacheco@unsaac.edu.pe');
INSERT INTO Docentes VALUES('ECP2332', 'EDWIN', 'CARRASCO', 'POBLETE', 'edwin.poblete@unsaac.edu.pe');
INSERT INTO Docentes VALUES('EPO2173', 'EMILIO', 'PALOMINO', 'OLIVERA', 'emilio.olivera@unsaac.edu.pe');
INSERT INTO Docentes VALUES('DCO2463', 'DENNIS IV�N', 'CANDIA', 'OVIEDO', 'dennis.oviedo@unsaac.edu.pe');
INSERT INTO Docentes VALUES('RVS2229', 'RONY', 'VILLAFUERTE', 'SERNA', 'rony.serna@unsaac.edu.pe');
INSERT INTO Docentes VALUES('GTP2365', 'GUZM�N', 'TICONA', 'PARI', 'guzman.pari@unsaac.edu.pe');
INSERT INTO Docentes VALUES('YOA2196', 'YESHICA ISELA', 'ORME�O', 'AYALA', 'yeshica.ayala@unsaac.edu.pe');
INSERT INTO Docentes VALUES('IMV2447', 'IV�N C�SAR', 'MEDRANO', 'VALENCIA', 'ivan.valencia@unsaac.edu.pe');
INSERT INTO Docentes VALUES('LPT2214', 'LUIS BELTR�N', 'PALMA', 'TTITO', 'luis.ttito@unsaac.edu.pe');
INSERT INTO Docentes VALUES('RAP2332', 'ROBERT WILBERT', 'ALZAMORA', 'PAREDES', 'robert.paredes@unsaac.edu.pe');
INSERT INTO Docentes VALUES('WIZ2414', 'WALDO ELIO', 'IBARRA', 'ZAMBRANO', 'waldo.zambrano@unsaac.edu.pe');
INSERT INTO Docentes VALUES('KMM2431', 'KARELIA', 'MEDINA', 'MIRANDA', 'karelia.miranda@unsaac.edu.pe');
INSERT INTO Docentes VALUES('JCC2346', 'JAVIER DAVID', 'CHAVEZ', 'CENTENO', 'javier.huacho@unsaac.edu.pe');
INSERT INTO Docentes VALUES('VCS2195', 'VANESSA MARIBEL', 'CHOQUE', 'SOTO', 'vanessa.soto@unsaac.edu.pe');
INSERT INTO Docentes VALUES('MPF2244', 'MANUEL AURELIO', 'PE�ALOZA', 'FIGUEROA', 'manuel.figueroa@unsaac.edu.pe');
INSERT INTO Docentes VALUES('JPQ2067', 'JOS� MAURO', 'PILLCO', 'QUISPE', 'jose.quispe@unsaac.edu.pe');
INSERT INTO Docentes VALUES('LBC2123', 'LINO AQUILES', 'BACA', 'C�RDENAS', 'lino.cardenas@unsaac.edu.pe');
INSERT INTO Docentes VALUES('EPV2011', 'ESTHER', 'PACHECO', 'V�SQUEZ', 'esther.vasquez@unsaac.edu.pe');
INSERT INTO Docentes VALUES('WZP2341', 'WILLIAN', 'ZAMALLOA', 'PARO', 'willian.paro@unsaac.edu.pe');
INSERT INTO Docentes VALUES('HVO2005', 'HARLEY', 'VERA', 'OLIVERA', 'harley.olivera@unsaac.edu.pe');
INSERT INTO Docentes VALUES('ECA2410', 'EFRAINA GLADYS', 'CUTIPA', 'ARAPA', 'efraina.arapa@unsaac.edu.pe');
INSERT INTO Docentes VALUES('DDB2125', 'DARIO FRANCISCO', 'DUE�AS', 'BUSTINZA', 'dario.bustinza@unsaac.edu.pe');
INSERT INTO Docentes VALUES('DAC2180', 'DORIS SABINA', 'AGUIRRE', 'CARBAJAL', 'doris.carbajal@unsaac.edu.pe');
INSERT INTO Docentes VALUES('TVV2335', 'TANY', 'VILLALBA', 'VILLALBA', 'tany.villalba@unsaac.edu.pe');
INSERT INTO Docentes VALUES('CMC2078', 'CARLOS FERNANDO', 'MONTOYA', 'CUBAS', 'carlos.cubas@unsaac.edu.pe');
INSERT INTO Docentes VALUES('CQO2098', 'CARLOS RAM�N', 'QUISPE', 'ONOFRE', 'carlos.onofre@unsaac.edu.pe');
INSERT INTO Docentes VALUES('VSJ2102', 'VICTOR DARIO', 'SOSA', 'JAUREGUI', 'victor.jauregui@unsaac.edu.pe');
INSERT INTO Docentes VALUES('BCL2116', 'BORIS', 'CHULLO', 'LLAVE', 'boris.llave@unsaac.edu.pe');
INSERT INTO Docentes VALUES('HUR2445', 'H�CTOR', 'UGARTE', 'ROJAS', 'hector.rojas@unsaac.edu.pe');
INSERT INTO Docentes VALUES('LMC2115', 'LUIS ALVARO', 'MONZON', 'CONDORI', 'luis.condori@unsaac.edu.pe');
INSERT INTO Docentes VALUES('RDJ2440', 'RAY', 'DUE�AS', 'JIMENEZ', 'ray.jimenez@unsaac.edu.pe');
INSERT INTO Docentes VALUES('JGS2220', 'JISBAJ', 'GAMARRA', 'SALAS', 'jisbaj.salas@unsaac.edu.pe');
INSERT INTO Docentes VALUES('JQS2103', 'JULIO VLADIMIR', 'QUISPE', 'SOTA', 'julio.sota@unsaac.edu.pe');
INSERT INTO Docentes VALUES('RHH2177', 'RAUL', 'HUILLCA', 'HUALLPARIMACHI', 'raul.huallparimachi@unsaac.edu.pe');
INSERT INTO Docentes VALUES('VLA2087', 'VANESA', 'LAVILLA', 'ALVAREZ', 'vanesa.alvarez@unsaac.edu.pe');
INSERT INTO Docentes VALUES('HCB2094', 'HANSH HARLEY', 'CCAYAHUILLCA', 'BEJAR', 'hansh.bejar@unsaac.edu.pe');
INSERT INTO Docentes VALUES('EFH2443', 'ELIDA', 'FALCON', 'HUALLPA', 'elida.huallpa@unsaac.edu.pe');
INSERT INTO Docentes VALUES('SCL2479', 'STEPHAN JHOEL', 'COSIO', 'LOAIZA', 'stephan.loaiza@unsaac.edu.pe');
INSERT INTO Docentes VALUES('LDC2397', 'LISHA SABAH', 'DIAZ', 'CACERES', 'lisha.caceres@unsaac.edu.pe');
INSERT INTO Docentes VALUES('MVV2086', 'MAR�A DEL PILAR', 'VENEGAS', 'VERGARA', 'maria.vergara@unsaac.edu.pe');
INSERT INTO Docentes VALUES('HLC2098', 'HENRY SAMUEL', 'DUE�AS', 'DE LA CRUZ', 'henry.cruz@unsaac.edu.pe');
INSERT INTO Docentes VALUES('GQT2499', 'GERAR FRANCIS', 'QUISPE', 'TORRES', 'gerar.torres@unsaac.edu.pe');
INSERT INTO Docentes VALUES('RAM2373', 'RAIMAR', 'ABARCA', 'MORA', 'raimar.mora@unsaac.edu.pe');
INSERT INTO Docentes VALUES('GZR2258', 'GABRIELA', 'ZU�IGA', 'ROJAS', 'gabriela.rojas@unsaac.edu.pe');
INSERT INTO Docentes VALUES('AHH2491', 'AGUEDO', 'HUAMANI', 'HUAYHUA', 'aguedo.huayhua@unsaac.edu.pe');
INSERT INTO Docentes VALUES('VQS2300', 'VITTALI', 'QUISPE', 'SURCO', 'vittali.surco@unsaac.edu.pe');
INSERT INTO Docentes VALUES('OVL2243', 'OLMER CLAUDIO', 'VILLENA', 'LE�N', 'olmer.leon@unsaac.edu.pe');
INSERT INTO Docentes VALUES('MMQ2499', 'MARCIO FERNANDO', 'MERMA', 'QUISPE', 'marcio.quispe@unsaac.edu.pe');
INSERT INTO Docentes VALUES('ARD2329', 'ALFREDO', 'ROZAS', 'D�VILA', 'alfredo.davila@unsaac.edu.pe');
INSERT INTO Docentes VALUES('ACM2247', 'ALFREDO', 'COLLANTES', 'MEDOZA', 'alfredo.medoza@unsaac.edu.pe');
INSERT INTO Docentes VALUES('SVR2276', 'SHIRLEY RUTH', 'VELAZQUE', 'ROJAS', 'shirley.rojas@unsaac.edu.pe');
INSERT INTO Docentes VALUES('JAC2280', 'JOSE GUILLERMO', 'ANDRADE', 'CARI', 'jose.cari@unsaac.edu.pe');
INSERT INTO Docentes VALUES('NOH2021', 'NOHELY LISSETH', 'OCHOA', 'HUAYHUA', 'nohely.huayhua@unsaac.edu.pe');

INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184194 ','FERDINAN JUNIOR ','CONDORCAHUA ','AYLLONE ','184194@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('155637 ','NESTOR ','CORRALES ','USCA ','155637@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184196 ','GONZALO ','CUSI ','FUENTES ','184196@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('191892 ','RUTH MARGOT ','LLASA ','YUCRA ','191892@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('171938 ','MARISOL ','LOPE ','TORRES ','171938@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174856 ','KALEB GEDEON ','MAMANI ','HUAMAN ','174856@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('113562 ','ELISBAN ','MENDOZA ','HUAILLAPUMA ','113562@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182924 ','RUTH MERY ','MU�OZ ','QUISPE ','182924@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('155192 ','ALFREDO ','NU�EZ ','HUALLA ','155192@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('171605 ','JERSON ','SALINAS ','ATAUSINCHI ','171605@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('155191 ','VICTOR ','URQUIZO ','CARBAJAL ','155191@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182935 ','ERICK ','USCACHI ','CCAPA ','182935@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200820 ','JOSE EMILIO ','ATAUCHI ','MAMANI ','200820@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('175022 ','OWEN DEISER ','BAUTISTA ','HURTADO ','175022@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164235 ','JOSUE CRISTIAN ','CALLAPI�A ','RODRIGUEZ ','164235@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174838 ','OSBALDO DAN ','CALLHUA ','ALDAZABAL ','174838@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192417 ','ANGEL LUIS ','CESPEDES ','VILCA ','192417@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174941 ','RONAL FRANKLIN ','CHOQUENAIRA ','GARCIA ','174941@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204319 ','LUIS FERNANDO ','CONDORI ','LACUTA ','204319@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184195 ','EMERSON ','CORDOVA ','CCOPA ','184195@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('160327 ','KEVIN YEISON ','CUSI ','HUAMAN ','160327@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200333 ','NAHYELY ALANIZ ','ESPINOZA ','COLCA ','200333@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194917 ','MARY CARMEN ','FLORES ','CASTRO ','194917@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184199 ','LUIS ALBERTO ','GALLEGOS ','CJUIRO ','184199@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192420 ','TIRSSA IVONNE ','GUEVARA ','DELGADO ','192420@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204797 ','FRAN ANTHONY ','HANCCO ','CHAMPI ','204797@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184649 ','ALVARO ','HUACHACA ','PEDRAZA ','184649@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('145002 ','RALEXS ','HUALLPA ','MONTALVO ','145002@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194519 ','JEMY SANDRO ','HUAMAN ','QUISPE ','194519@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('150397 ','BRUNO WALDIR ','LOAIZA ','MONROY ','150397@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192423 ','JHON ANTHONY ','LOPEZ ','BARAZORDA ','192423@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('170438 ','JEFERSSON ','MAMANI ','ZANABRIA ','170438@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192425 ','HERBERTH CLAUDD ','MAYTA ','SALAZAR ','192425@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141671 ','VICTOR ANIVAL ','PAREDES ','DENOS ','141671@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('150401 ','DENILSON ','PARI ','ARRIAGA ','150401@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('183078 ','EDSON LEONID ','PHUYO ','HUAMAN ','183078@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('120893 ','YENI RUTH ','PORROA ','SIVANA ','120893@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('160853 ','CARLOS EDUARDO ','PUMA ','MENDOZA ','160853@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200340 ','JOSE LUIS ','QUISPE ','TAY�A ','200340@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182937 ','HANS ROBERT ','VELASQUEZ ','DURAND ','182937@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('140987 ','ALDAIR WILBERT ','VILLARES ','SUBLE ','140987@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('114136 ','JUAN RAISER ','ALMIRON ','GONZALES ','114136@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182894 ','ANDRES RODRIGO ','ANDIA ','JAEN ','182894@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141660 ','JAIR FREDERICK ','AROSTEGUI ','CERNA ','141660@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174907 ','JEFFERSON LENNART ','CAMPOS ','SEGOVIA ','174907@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('133962 ','NOE FRANKLIN ','CHOQUENAIRA ','QUISPE ','133962@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('154622 ','JUAN CARLOS ','CONDORI ','ALCAZAR ','154622@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174944 ','WESLEY JUANPEDRO ','CONDORI ','MOZO ','174944@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182904 ','ALEX YTALO ','CURO ','MAMANI ','182904@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('163842 ','CARLOS ENRIQUE ','FERNANDEZ ','HUILLCA ','163842@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('170433 ','JULIO JOSUE ','HOLGUIN ','CONDORI ','170433@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('32648 ','LUIS ANDRES ','LIMPE ','ZEVALLOS ','32648@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184802 ','PAUL DAVID ','MAMANI ','LAROTA ','184802@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194525 ','ARELI SHALON ','PAREDES ','CURASCO ','194525@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184689 ','LISBETH ','PILLCO ','FLORES ','184689@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192428 ','ARTUR MARTI ','RADO ','HUAYOTUMA ','192428@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184209 ','AXEL STEWARF ','SAIRE ','SALAZAR ','184209@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('151830 ','NAJOR JOSUE ','VALDEIGLESIAS ','DUE�AS ','151830@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194530 ','NYCOLL TATIANA ','ZEVALLOS ','VIDAL ','194530@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('201228 ','MILTON AMED ','ACHAHUI ','CRUZ ','201228@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182893 ','JAZMIN ','AGUILAR ','PORCEL ','182893@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200330 ','JULIO CESAR ','AMAO ','ATAUCHI ','200330@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200821 ','WILGER FABRICIO ','AUCAPURI ','CORIMANYA ','200821@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('191870 ','YOLMY MILAGROS ','CAHUATA ','LAVILLA ','191870@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182897 ','JOSEPH TIMOTHY ','CALDERON ','GARMENDIA ','182897@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('201231 ','JULIO CESAR ','CALLA�AUPA ','SALLO ','201231@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184197 ','LUCIAN NEPTALI ','FERNANDEZ BACA ','CASTRO ','184197@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194918 ','DAYHANA LUCERO ','GAMARRA ','FLORES ','194918@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193001 ','EDUARDO JUAREIS ','GIFONE ','VILLASANTE ','193001@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193834 ','CRISTIAN AYRTHON ','GODOY ','LACUTA ','193834@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211855 ','DAVID ALI ','HUACHO ','CRUZ ','211855@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('195048 ','NAYELI CONSTANTINA ','LABRA ','HUAITA ','195048@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200781 ','IVAN NESTOR ','LIMPI ','TINTA ','200781@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164243 ','SEBASTIAN ISRAEL ','MACEDO ','GHEILER ','164243@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182917 ','BRUCE MAXIMO ','MAMANI ','GABRIEL ','182917@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('175061 ','NICHOLAS EDWARD ','MAMANI ','ZELA ','175061@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211311 ','WILL EDSON ','MAYTA ','TTITO ','211311@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182922 ','FRANKLIN JESUS ','MONTES ','HUILLCA ','182922@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211860 ','MILDER ','MU�OZ ','CENTENO ','211860@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141677 ','JUAN CARLOS ','NINAHUANCA ','CHOQUE ','141677@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174445 ','RODRIGO FABRICIO ','OLARTE ','CASAS ','174445@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210939 ','GUSTAVO ','PANTOJA ','OLAVE ','210939@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193837 ','ALEX HARVEY ','PFOCCORI ','QUISPE ','193837@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('171567 ','DIANA STEPHANIE ','PUCLLA ','HUAMAN ','171567@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('191873 ','GLINA DE LA FLOR ','PUMA ','HUAMANI ','191873@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('113547 ','RONY WILSON ','QUINAYA ','MEJIA ','113547@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182931 ','ANDERSON ','QUISPE ','MORA ','182931@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('120895 ','AYRTON ','QUISPE ','PICHUILLA ','120895@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210411 ','ISMAEL GERSON ','RAMOS ','ALVAREZ ','210411@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200826 ','JAIME ANTONIO ','RODRIGUEZ ','PHILLCO ','200826@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194529 ','GERSON ','TORRES ','MAMANI ','194529@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211362 ','LUIGUI FERNANDO ','VALERIANO ','HUACARPUMA ','211362@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194916 ','JEAN MARCO ','BACILIO ','HUAMAN ','194916@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193027 ','CARMEN GUADALUPE ','BLANCO ','MOZO ','193027@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194516 ','ELIAZAR ','CCA�IHUA ','LAYME ','194516@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('183885 ','HILDEMARO ','CHILE ','QUIROGA ','183885@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184646 ','CHRISTIAN ENRIQUE ','DIAZ ','HUAYLUPO ','184646@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192665 ','ROYER FUNACOSHI ','FERNANDEZ ','MANDURA ','192665@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('100511 ','JUAN CARLOS ','GUTIERREZ ','AMACHI ','100511@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184201 ','LUIS FERNANDO ','GUTIERREZ ','TAQQUERE ','184201@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194518 ','NICANOR ','HUAMAN ','JAIMES ','194518@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194520 ','FRANKLIN ','LLAMOCCA ','QUISPE ','194520@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194521 ','CRISTIAN DANIEL ','MALDONADO ','CHALCO ','194521@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192666 ','EDWARD ','MELENDEZ ','MENDIGURE ','192666@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194524 ','CRISTINA ','MELENDRES ','PEREZ ','194524@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('130741 ','HAROL HELBERT ','MERMA ','QUISPE ','130741@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('101526 ','ALVARO AMERICO ','ORUE ','QUISPE ','101526@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('183469 ','GONZALO MARTIN ','PIMENTEL ','FRANCO ','183469@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('150404 ','CAYO ABEL ','QUEKQA�O ','QUISPE ','150404@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194527 ','YOEL SANDRO ','QUISPE ','SANTA CRUZ ','194527@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194921 ','CRISTHIAN ','SAMATA ','PUMAHUALCCA ','194921@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194922 ','ESTEFAN POL ','SILVA ','GUEVARA ','194922@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182765 ','IVAN MARIO ','SUMIRE ','HANCCO ','182765@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193129 ','KEVIN JHOEL ','TTITO ','HUAMAN ','193129@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('163806 ','JHOEL FELIX ','ASENCIO ','ARQQUE ','163806@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164238 ','EVANDIR SAUL ','CASILLA ','TTITO ','164238@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('170431 ','JOSE LUIS ','CRUZ ','CARRION ','170431@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('170751 ','JOHN KEVIN ','ENRIQUEZ ','QUISPE ','170751@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('145004 ','JOSEPH ODE ','ESPIRILLA ','MACHACA ','145004@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194919 ','WILBER EMANUEL ','HUAICOCHEA ','CARDENAS ','194919@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('150495 ','SAMAN ','QUISPE ','CLEMENTE ','150495@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184653 ','MARJORIE REBECCA ','RODRIGUEZ ','CASAS ','184653@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('191874 ','MARKO LEONEL ','VALENCIA ','�AUPA ','191874@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141599 ','JAIME ','VENTURA ','JAUJA ','141599@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('163813 ','MARCELO ANGELO ','VIZCARRA ','VARGAS ','163813@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192975 ','GEORGE ALEXANDER ','ZAPANA ','FLORES ','192975@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('120008 ','CARLA PALOMA ','CUETO ','SANCHEZ ','120008@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192998 ','FABRICIO YARED ','CARDENAS ','HUAMAN ','192998@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182731 ','YERSON JOAB ','CHIRINOS ','VILCA ','182731@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193832 ','PAOLA ANDREA ','CORTEZ ','CCAHUANTICO ','193832@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192419 ','YANET ','CUSI ','QUISPE ','192419@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('151812 ','JUSTINO ','FERRO ','ALVAREZ ','151812@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184604 ','ANTHONY MAYRON ','LOPEZ ','OQUENDO ','184604@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193003 ','ELIAZAR ','NOA ','LLASCCANOA ','193003@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174864 ','DANNY BRANCO ','RAMOS ','CONDORI ','174864@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192664 ','BRAYAN GUSTAVO ','APARICIO ','CASTILLA ','192664@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174441 ','RENO MAX ','DEZA ','KACHA ','174441@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193110 ','ASTRID ','FIGUEROA ','RODRIGUEZ ','193110@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184651 ','ROY MARVIN ','MAMANI ','TAIRO ','184651@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182934 ','TEOFILO SOCRATES ','SAPACAYO ','HUAYHUA ','182934@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192997 ','RUTH MILAGROS ','ARCE ','QUISPE ','192997@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192999 ','MIGUEL ANGEL ','CCONCHO ','CASTELLANOS ','192999@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184652 ','ROSWELL JAIME ','PANDO ','MU�OZ ','184652@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('151822 ','NILSON MAURI�O ','PUMA ','MAMANI ','151822@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235387 ','NELSON ','AGUERO ','HUAMAN ','235387@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('111276 ','YON ','AGUILAR ','QUISPE ','111276@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235388 ','DANIEL ','APAZA ','CHOQQUE ','235388@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('234892 ','ALVARO ALONSO ','AYTE ','NOA ','234892@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235389 ','STEFFANO RICARDO ','CABALLERO ','ZEGARRA ','235389@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('222085 ','FRANCESCO GABRIEL ','CANAL ','ACEVEDO ','222085@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221612 ','HENRY ALEXIS ','CCA�A ','SURI ','221612@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231890 ','RAUL DIOSDADO ','CHAI�A ','CONDORI ','231890@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235390 ','YORDY WILFREDO ','CHAMPI ','CONDORI ','235390@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231924 ','KAEL ALFREDO ','CUTI ','ZEVALLOS ','231924@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231894 ','CAMILA ALEXANDRA ','FERN�NDEZ ','PUENTE DE LA VEGA ','231894@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220650 ','EMMI DANIELA ','HUAMAN ','TAIRO ','220650@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('234894 ','ISAAC LIZANDRO ','HUANCA ','ROJO ','234894@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('130381 ','ALFREDO JUNIOR ','HUANCACHOQUE ','CJUNO ','130381@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('160534 ','ERIC ','HUARACHA ','MONTALVO ','160534@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231453 ','ADRIEL ALFREDO ','LLACTAHUAMANI ','AYALA ','231453@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235391 ','HAYLLY FRANK ','MENDOZA ','LAPA ','235391@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235392 ','JOSE SNAYDER ','MITA ','PUMA ','235392@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231989 ','ALBERT ERIK ','MOROCCO ','AMANCA ','231989@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231538 ','YHOJAN HILARIO ','MOROCCO ','PINTO ','231538@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('234895 ','ANDR� GUSTAVO ','MUJICA ','PERALTA ','234895@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('234896 ','WINNY TAMARA ','NAV�O ','CCAPA ','234896@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235393 ','RODRIGO ','PUENTE DE LA VEGA ','MIRANDA ','235393@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235394 ','LYM KURTH ','PUMA ','SULLCAPUMA ','235394@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('170300 ','RUTH JACKELIN ','QUISPE ','BEJARANO ','170300@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('235395 ','DIEGO ALONSO ','QUISPE ','CASTILLA ','235395@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215733 ','JHON EFRAIN ','QUISPE ','CHURA ','215733@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231907 ','RENZO SEBASTIAN ','QUISPE ','PINARES ','231907@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231493 ','FRANKLIN ','QUISPE ','TACO ','231493@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231816 ','JORGE LUIS ','QUISPE ','TEVES ','231816@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231929 ','ABEL ','QUISPE ','VARGAS ','231929@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('234897 ','JHERSON MADDOX ','RAMOS ','CAMACHO ','234897@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174521 ','DENIS PAUL ','ROQUE ','ROQUE ','174521@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('234898 ','GABRIEL CALEB ','SUCA ','HILARES ','234898@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225555 ','MARICIELO ANTONIETA ','ZAVALA ','UCHUPE ','225555@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215719 ','BRAYAN ISAU ','CHOQUE ','MAMANI ','215719@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230601 ','GISEL DAYANA ','FARFAN ','GOMEZ ','230601@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('81561 ','DANY DARWIN ','HUACANI  ','DE LA CRUZ ','81561@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230969 ','JOSE JAVIER ','HUAMAN ','SUTTA ','230969@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231443 ','GERALD BENJAMIN ','HUANTO ','AYMA ','231443@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230970 ','NATAN ','MAMANI ','FLORES ','230970@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231867 ','MARIO GABRIEL ','MELO ','CAJAHUILLCA ','231867@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('171566 ','FRANCO STEFANO ','PAZ ','SONCCO ','171566@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220551 ','RODRIGO ANDRE ','QUESADA ','MAMANI ','220551@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230604 ','ELVIS RAUL ','SUCA ','HANCCO ','230604@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225465 ','RAUL FRANSHESCO ','VASQUEZ ','MAMANI ','225465@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164241 ','DAVID ','GIRALDO ','ENCISO ','164241@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('101664 ','LUIS ALEXEI ','QUISPE ','RODRIGUEZ ','101664@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231861 ','DIANA AZUMI ','ACCOSTUPA ','ALCCA ','231861@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231862 ','EDUARDO SEBASTIAN ','ACHAHUI ','JIMENEZ ','231862@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231863 ','ANDER GABRIEL ','ALVAREZ ','VARGAS ','231863@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231864 ','PEYTHON LEONCIO ','CA�IHUA ','PAZ ','231864@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231865 ','RAYNELD FIDEL ','CASTRO ','PARI ','231865@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230249 ','YHASMIN GRACIELA ','CCANSAYA ','CORRALES ','230249@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215817 ','BRYAN SEBASTIAN ','CHAVEZ ','LUNA ','215817@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('232317 ','ERICK SEBASTIAN ','CHUCHON ','VALDEZ ','232317@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231866 ','FIDEL ENRIQUE ','COLQUE ','QUISPE ','231866@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231441 ','ZARA SAIDA ','CRUZ ','CAHUANA ','231441@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230250 ','NOHEMI SHARIT ','CUBA ','CASTILLO ','230250@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230251 ','DOMINIC JAIR ','DELGADO ','HUAMPUTUPA ','230251@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210927 ','JELIEL ','ENRIQUEZ ','ARAMBURU ','210927@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231442 ','YAMIR WAGNER ','FLOREZ ','VEGA ','231442@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225452 ','MARCO ABEL ','GALLEGOS ','SILVA ','225452@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230252 ','YELY ','LAZO ','FLOREZ ','230252@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231444 ','JHOEL FABRIZZIO ','MAGA�A ','OSORIO ','231444@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230253 ','FRANKLIN GILBERTO ','MAMANI ','CONDORI ','230253@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231445 ','BRENDA LUCIA ','MAYHUIRE ','CHACON ','231445@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230971 ','JOSE DANIEL ','MENDOZA ','QUISPE ','230971@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231446 ','ADEL ALEJANDRO ','MERMA ','CCARHUARUPAY ','231446@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231447 ','ROSY AURELY ','MONTALVO ','SOLORZANO ','231447@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210938 ','ALAIN ANTHONY ','PALACIOS ','YAPO ','210938@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231868 ','GABRIEL ','PEREZ ','CAHUANA ','231868@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141632 ','MARCO ROSAURO ','POLO ','CHURA ','141632@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225461 ','JHON ANDHERSON ','QUISPE ','LLAVILLA ','225461@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164257 ','ROMARIO ','QUISPE ','RIMACHI ','164257@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230972 ','CARLOS RODRIGO ','RIVERA ','SOLORZANO ','230972@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230603 ','EDUARDO JHOSEF ','SANTOS ','PILLCO ','230603@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230973 ','BARUC ','SOTA ','ESCALANTE ','230973@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('230605 ','DANIELA ROSARIO ','TINCO ','HUAMAN ','230605@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210369 ','JACK ELIEZER ','TTITO ','HUAMAN ','210369@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231448 ','KALED SALVADOR ','YUCA ','CHIPANA ','231448@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225554 ','BRANDON OLMER ','ZAPATA ','VILCA ','225554@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('231449 ','ANDY JEFFERSON ','ZEVALLOS ','YANQUI ','231449@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211265 ','FLAVIO ANTONY ','CABEZA ','HUILLCA ','211265@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215714 ','LUZ DIANA ','ANCASI ','AYMACHOQUE ','215714@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204840 ','ADILSON RONALDO ','ANGULO ','AROTAYPE ','204840@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225417 ','MARCO ANTONIO ','ARAPA ','SALAZAR ','225417@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215326 ','JHON EBER ','HUAYHUA ','HUAMANI ','215326@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225416 ','MIRIAN LUCERO ','ANCCO ','ANCALLA ','225416@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220550 ','EDUARDO CRISTHIAN ','MAMANI ','ACHIRCANA ','220550@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225419 ','OSCAR DAVID ','BARRIENTOS ','HUILLCA ','225419@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224867 ','JOSE MANUEL ','BUSTINZA ','QUISPE ','224867@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225420 ','JOSEPH JESUS ','CALLA�AUPA ','SALCEDO ','225420@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224868 ','DENIS JAIR ','CANCINAS ','CARDENAS ','224868@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211885 ','JUAN ANTONY ','CCAHUA ','LAGUNA ','211885@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215882 ','EDDY ARNOLD ','CRUZ ','CCANCHI ','215882@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221447 ','JOSEPH MATTHEW ','FARFAN ','CARRION ','221447@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215785 ','SEBASTIAN ','FERNANDEZ ','PUMA ','215785@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224869 ','LUIS FERNANDO ','GALLEGOS ','BALLON ','224869@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224870 ','JOSE ALFREDO ','HUAMAN ','QUISPE ','224870@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221449 ','DAVID DANIEL ','HUILLCA ','LLANQUE ','221449@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224871 ','JHOEL ALEX ','LUICHO ','QUISPE ','224871@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225422 ','AUGUSTO FERNANDO ','MAMANI ','PALOMINO ','225422@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225423 ','JUAN DANIEL ','MASCO ','RODRIGUEZ ','225423@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224872 ','LUIS DAVID ','MEDMA ','CANLLA ','224872@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224873 ','JOSEPH SMITH ','MERMA ','FLORES ','224873@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225424 ','ROY EDUARDO ','PAUCCAR ','CHANY ','225424@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('161809 ','RICHARD BRAULIO ','PUMA ','CONDORI ','161809@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215948 ','JOSE FRANCISCO ','QUENTASI ','JUACHIN ','215948@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221986 ','BRAYAN RODRIGO ','QUISPE ','CASTILLO ','221986@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225425 ','LUIS ALEJANDRO ','RAMOS ','AGUIRRE ','225425@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221989 ','HERNAN WASHINGTON ','RAMOS ','ALATA ','221989@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225426 ','RICHARD ','RODRIGUEZ ','HUAYLLA ','225426@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200886 ','MIRCO SAIR ','SALCEDO ','ATAULLUCO ','200886@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215780 ','JESUS AUGUSTO ','ALEGRIA ','MENDOZA ','215780@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221945 ','ANGEL ISMAEL ','ALVAREZ ','CATUNTA ','221945@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215782 ','PATRICK PAUL ','CCOA ','PEREZ ','215782@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215917 ','GIAN FRANCO ','CHARALLA ','CCAMA ','215917@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221445 ','RIVALDO FRANCO ','CHILLIHUANI ','HUAMAN ','221445@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215274 ','FREDY JHON ','CHOQUEMAQUI ','CHINCHERCOMA ','215274@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('222067 ','ARACELY FIORELA ','CORAMPA ','PALACIOS ','222067@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210925 ','CRISTIAN PAUL ','DENOS ','LIVANO ','210925@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('222068 ','VANESSA ','ESCOBEDO ','MESCCO ','222068@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215725 ','BRAYAN ANTONI ','HIGUERA ','HALANOCCA ','215725@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225421 ','JHON WILLIAM ','HUANCA ','ALCCA ','225421@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('183067 ','ROSSBEL ','HUAYLLA ','HUILLCA ','183067@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210178 ','CARLOS WILLIAN ','LUNA ','CCAPA ','210178@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221946 ','JUAN CARLOS ','MAMANI ','QUISPE ','221946@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184206 ','MARCUS GEUSEPPE ','MEZA ','ZAMALLOA ','184206@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220961 ','LUIS �NGEL ','MOGROVEJO ','CCORIMANYA ','220961@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('171569 ','FERNANDO ','QUISPE ','HANCCO ','171569@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('224874 ','TIMOTEO ','QUISPE ','MERMA ','224874@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221450 ','ALEXYS ','QUISPE ','NINA ','221450@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220555 ','EDU PIERO ','VILLAVICENCIO ','SEGUIL ','220555@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221443 ','ANDRE ALFREDO ','CALDERON ','RODRIGUEZ ','221443@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215273 ','RONALD YTALI ','CCANSAYA ','CHAIZA ','215273@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215783 ','JOHAN MIHAIL ','CONDE ','SALLO ','215783@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('171676 ','DERLY HAYLEY ','HUAMAN ','AYMA ','171676@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204798 ','LINO ZEYNT ','HUARACALLO ','ARENAS ','204798@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210931 ','HJOVER ELSON ','KJUIRO ','HUAMAN ','210931@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200946 ','DIEGO SHAID ','NINANCURO ','HUARAYO ','200946@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194526 ','JOSE ALEXANDER ','QUISPE ','SALAS ','194526@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211816 ','RONALDO ','TICONA ','JANCCO ','211816@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210944 ','DIEGO EDU ','USCAPI ','PUCHO ','210944@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211363 ','LISBETH ','YUCRA ','MENDOZA ','211363@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215271 ','VICTOR ANIBAL ','ALVARO ','MENDOZA ','215271@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('225418 ','MICHAEL AUGUSTO ','BAEZ ','MONGE ','225418@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184193 ','YEISON EMERSON ','CCOSCCO ','CHAHUA ','184193@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('20203 ','PERCY URIEL ','CHOQUEHUANCA ','MACEDO ','20203@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215275 ','ORLANDO ','COCHAMA ','BORNAS ','215275@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141664 ','GEORGE ADOLFO ','CONDE ','PADIN ','141664@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('216061 ','JOSE LUIS ','HUILLCA ','DIAZ ','216061@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210936 ','DANIEL ','MONTA�EZ ','MEDINA ','210936@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164246 ','JEAN MARCO ','PACHA ','QUISPE ','164246@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200341 ','ELBERT CESAR ','SANCHEZ ','CHACON ','200341@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204322 ','NILSON LEONEL ','ZULOAGA ','CCOPA ','204322@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220211 ','LEO SMITH ','HANCCO ','VALLE ','220211@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220552 ','JOAN GONZALO ','QUISPE ','CHECYA ','220552@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141002 ','WILFREDO ','CHINO ','CHOQUENAIRA ','141002@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192426 ','WENDEL YOVAN ','NI�O DE GUZMAN ','CONDE ','192426@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('183485 ','JOSE ANTONIO ','SULLCA ','AQUINO ','183485@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211859 ','MIGUEL ANGEL ','MOREANO ','VILLENA ','211859@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182896 ','HAYDER ','AUCCAISE ','RONCO ','182896@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('154628 ','CESAR APARICIO ','CONDORI ','HUAYCHAY ','154628@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220547 ','AXEL BARNABY ','ARANIBAR ','ROJAS ','220547@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194522 ','LUIS ANTHONY ','MAMANI ','MESCCO ','194522@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221950 ','CELIA ','QUISPE ','QUISPE ','221950@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220548 ','ELVIS JAIR ','CASAFRANCA ','BENAVIDES ','220548@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221444 ','ESMAYDES ','CCORI ','TACO ','221444@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221446 ','PAMELA ','DIAZ ','MISME ','221446@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221448 ','HEIDAN TORIBIO ','GIL ','FIGUEROA ','221448@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('195036 ','ADRIEL MITHUAR ','GUEVARA ','CUSI ','195036@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210930 ','FRANZ PAUL ','HUAMAN ','BERRIO ','210930@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182975 ','RUBEN DARIO ','HUAYLLA ','PEREDO ','182975@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182977 ','JACOBO NEPTALY ','LA TORRE ','FRANCO ','182977@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220549 ','ARACELY ','LLANCAYA ','TAPIA ','220549@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220212 ','INGRID ROSARIO ','NOA ','ALLER ','220212@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200785 ','CESAR CIRO ','OLARTE ','BAUTISTA ','200785@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220213 ','PATRICK MICHAEL ','PUMACCAHUA ','HUALLPA ','220213@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221949 ','ANDY YOSEPH ','QUISPE ','HUANCA ','221949@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220610 ','ALDO ','QUISPE ','LOCUMBER ','220610@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221451 ','JAIRO JASER ','RODR�GUEZ ','CCOYTO ','221451@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220962 ','SANDRO ALEXANDER ','SALLUCA ','CHILE ','220962@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220553 ','YEFERSON ','SUPA ','CUSIPAUCAR ','220553@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220963 ','LUIS ADRIAN ','SURCO ','CUTIPA ','220963@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210435 ','ISEL YULIANA ','TICONA ','QUISPE ','210435@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('221452 ','MAX ERIXON ','TOLEDO ','BERNAL ','221452@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220964 ','RONIL NILO ','TORRES ','BAUTISTA ','220964@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220554 ','FRANK WILDER ','ULLOA ','PARQUE ','220554@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('220214 ','MARCO ANTONIO AXEL ','VARGAS ','ZEGARRA ','220214@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192190 ','CARLOS DANIEL ','ZU�IGA ','SARA ','192190@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192418 ','ANGELA LORENA ','CORNEJO ','CASTRO ','192418@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('195050 ','MEDALY ','LOZANO ','LLACCTAHUAMAN ','195050@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204800 ','GEORGE IVANOK ','MU�OZ ','CASTILLO ','204800@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('216062 ','RAMIRO ','MU�OZ ','ROSAS ','216062@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211358 ','JOHAM ESAU ','QUISPE ','HUILLCA ','211358@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210180 ','ANGHELO ','VILLALOBOS ','USCA ','210180@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204792 ','ANDREE ','ACHAHUANCO ','VALENZA ','204792@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215272 ','GIANCARLO ','APAZA ','MAMANI ','215272@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164563 ','HAIDER ALEX ','CARPIO ','HERMOZA ','164563@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211959 ','LUDVIKA ARLETH ','CCASA ','POCOHUANCA ','211959@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210924 ','IBETH JANELA DEL PILAR ','CUSI ','DIAZ ','210924@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210926 ','YELSIN MAGIBEL ','DURAN ','HUAMAN ','210926@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('90215 ','JUAN CARLOS ','GIBAJA ','HUAYHUA ','90215@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210929 ','RONALD EINAR ','GUTIERREZ ','ALFARO ','210929@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215277 ','JHON KEVIN ','HALANOCCA ','SURCO ','215277@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200878 ','ZAHID ','HUAHUACHAMPI ','HINOJOSA ','200878@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215278 ','JUAN GABRIEL ','HUISA ','MAMANI ','215278@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210937 ','PAVEL ALVARO ','MOTTA ','MENDOZA ','210937@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215788 ','KEVIN DANIEL ','PERALTA ','OROS ','215788@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211360 ','VICTORIA FATIMA ','ROZAS ','CCASA ','211360@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210409 ','DAYANA ANGELA ','CASTILLA ','VARGAS ','210409@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210922 ','FLOR DELIZ ','CCASA ','CCAHUANA ','210922@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204805 ','CHRISTIAN ','PUMACCAHUA ','CUSIHUAMAN ','204805@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215422 ','JHON JESUS ','QUISPE ','MACHACA ','215422@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215791 ','JULIO CESAR ','SOTELO ','QUISPE ','215791@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174449 ','EDMIL JAMPIER ','SAIRE ','BUSTAMANTE ','174449@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210928 ','BRANDON PAOLO ','ESTRADA ','CUYTO ','210928@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200824 ','LUIS ALVINO ','LEVITA ','QUISPE ','200824@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('992175 ','LUIS CARLOS ','MONDRAGON ','PORRAS ','992175@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('150400 ','RICARDO ','OCHOA ','MAMANI ','150400@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('103647 ','JESUS ADEL ','QUISPE ','ARONI ','103647@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194892 ','MAX ALEX ','SONCCO ','LUQUE ','194892@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192430 ','ABELARDO ','TTITO ','QUISPE ','192430@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200338 ','ROGER ','QUISPE ','AGUILAR ','200338@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('131532 ','DAVIS WASHINGTON ','ANTAYHUA ','SAPILLADO ','131532@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('183055 ','GABRIEL ','CARBAJAL ','CARRASCO ','183055@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210921 ','CAROLAY ','CCAMA ','ENRIQUEZ ','210921@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215270 ','DANIEL ','ALEGRIA ','SALLO ','215270@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141000 ','AXEL RICARDO ','ASCUE ','PE�A ','141000@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215781 ','ALEX ','BERRIOS ','THEA ','215781@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('154635 ','JOSE ANTONIO ','CONDORI ','HUILLCA ','154635@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215784 ','LUCERO ESMERALDA ','CRUZ ','YUCRA ','215784@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215786 ','JOSE CARLOS ','LEON ','MALDONADO ','215786@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210934 ','LIZETH CARLA ','MAMANI ','SALCEDO ','210934@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200858 ','MANUEL EDUARDO ','QUISPE ','CONDORI ','200858@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('215279 ','LUCERO ESTEFANY ','RAMOS ','CONDORI ','215279@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200865 ','IAN PIERO ','YANA ','CUNO ','200865@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211818 ','FRAN JHOEL ','YAPO ','HUARAYA ','211818@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211355 ','PAUL ANDR� ','AUCCACUSI ','HUANCA ','211355@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210919 ','MEI LING ','BIGGERSTAFF ','PUMACAHUA ','210919@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210920 ','ANDRIC JEREMY ','BUENO ','LESCANO ','210920@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204796 ','JANNIRA ALISON ','FARFAN ','LUNA ','204796@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192422 ','ANDY MARCELO ','HUAMAN ','QUISPE ','192422@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211857 ','YIMY YOHEL ','HUISA ','NINA ','211857@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210933 ','JORGE LUIS ','MAMANI ','JARA ','210933@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210935 ','JEANPIER XILANDER ','MERMA ','CHURA ','210935@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211858 ','DYLAN PATRICK ','MEZA ','CHALLCO ','211858@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211359 ','IAN LOGAN WILL ','QUISPE ','VENTURA ','211359@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210942 ','CRISTIAN DIEGO ','RODRIGUEZ ','PAUCCARA ','210942@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200332 ','GERALD ANTONIO ','CUSACANI ','GONZALES ','200332@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('93178 ','ISAI ISAAC ','MAMANI ','CRISPIN ','93178@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('101659 ','JOSE ADOLFO ','FERIA ','TAPARA ','101659@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('164244 ','BRAYAN VLADYMIR ','MOLOCHO ','CONDORI ','164244@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211361 ','EDUARDO ','TORRE ','CANO ','211361@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174948 ','ELVIS ','HUAMAN ','CHILO ','174948@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210940 ','JHON ESAU ','PUMACHOQUE ','CHOQUENAIRA ','210940@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182932 ','JHON ALBERTH ','QUISPE ','QUISPE ','182932@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184656 ','MARCELO EDUARDO ','SUAREZ ','MARISCAL ','184656@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184213 ','DORIAN ROGER ','ZAVALA ','TTITO ','184213@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192427 ','ERICK NICASIO ','PORTILLO ','HUAMAN ','192427@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('161136 ','JOSE ROLANDO ','TTITO ','OCSA ','161136@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('163807 ','MILTON ANDERSON ','CHATA ','HUALLPAYUNCA ','163807@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211856 ','OMAR ','HUAYAPA ','HUAMAN�AHUI ','211856@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200825 ','ANDRE MARCELO ','MENDOZA ','MAYTA ','200825@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211356 ','ORIOL FERNANDO ','PALACIOS ','DURAND ','211356@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210179 ','DAVID FERNANDO ','PRIETO ','CARDOSO ','210179@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('211862 ','ETNER YURY ','QUISPE ','ARQQUE ','211862@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210412 ','JHAMSID ','ROMERO ','BERNAL ','210412@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('210413 ','HORUS HUGO ','SANCHEZ ','ENCISO ','210413@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204807 ','LUIS MANUEL ','TINOCO ','CCOTO ','204807@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('161534 ','JORGE ENRIQUE ','ZEGARRA ','ROJAS ','161534@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('130516 ','WASHINGTON MARCO ','BUSTAMANTE ','MAMANI ','130516@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204804 ','JOSE LUIS ','PE�A ','CABALLERO ','204804@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204806 ','DENNIS OSWALDO ','SANCHEZ ','PALOMINO ','204806@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204318 ','ABEL ENRIQUE ','BELLIDO ','ARMUTO ','204318@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193109 ','JEAN FRANCO ','COLQUE ','GALINDO ','193109@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204320 ','JHONATAN ALEXANDER ','GARCIA ','ROMERO ','204320@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('160696 ','ANGGIE ANTUANE ','HUAMAN ','MORALES ','160696@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('134403 ','CIRO GABRIEL ','CALLAPI�A ','CASTILLA ','134403@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('141672 ','JULIO WILSON ','CORNEJO ','CRUZ ','141672@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204803 ','MILTON ALEXIS ','PACHARI ','LIPA ','204803@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204793 ','NIK ANTONI ','AGUILAR ','SANCHEZ ','204793@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204794 ','REBECA ARACELI ','CCANSAYA ','SONCCO ','204794@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174439 ','NORGAN SANDRO ','CHOQUECONZA ','QUISPE ','174439@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('155180 ','NAOMI ISABEL ','MASIAS ','USCAMAYTA ','155180@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204321 ','YISHAR PIERO ','NIETO ','BARRIENTOS ','204321@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204801 ','YAQUELYN ROSALINDA ','OLIVARES ','TORRES ','204801@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('175101 ','CARLA ','QUISPE ','ESCALANTE ','175101@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200788 ','BORIS ELOY ','SULLCARANI ','DIAZ ','200788@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204808 ','SEBASTIAN VICTOR ','TORREBLANCA ','PAZ ','204808@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('83221 ','LUIS ANDERSON ','TRUJILLO ','TORBISCO ','83221@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204795 ','JADYRA CHASKA ','CHOQUE ','QUISPE ','204795@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174443 ','JUAN VICTOR ','FARFAN ','MOSCOSO ','174443@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('204799 ','YASUMY MARICELY ','JALLO ','PACCAYA ','204799@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200519 ','JESUS GUSTAVO ','OCHOA ','BARRIOS ','200519@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('171879 ','THALIA ','QUISPE ','MAMANI ','171879@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('134134 ','SAULO SHALON ','MELGAREJO ','SAAVEDRA ','134134@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('125156 ','WILLIAMS DENNIS ','CONDORI ','FLORES ','125156@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200334 ','KATERINE CANDY ','LIMA ','ESPERILLA ','200334@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184654 ','MIGUEL ENRIQUE ','SACA ','ACCOSTUPA ','184654@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200827 ','KEVIN ARON ','SUMIRE ','CCAHUANA ','200827@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200518 ','ANGHELO ','ALAGON ','FERNANDEZ ','200518@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193830 ','CRISTHIAN ','CCALA ','HUAMANI ','193830@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('194523 ','JOHANA MARIA ','MAMANI ','MEZA ','194523@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('201229 ','SHAIEL ALMENDRA ','ARANA ','FLORES ','201229@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('201230 ','CRISTIAN ANDY ','CABRERA ','MEJIA ','201230@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192416 ','WILMAN ','CCASANI ','HUAMAN ','192416@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('201232 ','VITO JHON ','HUERTA ','MEDINA ','201232@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('131612 ','WILLIANS ','MONTA�EZ ','CHOQUE ','131612@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200336 ','DARCY OMAR ','ORCCON ','DIAZ ','200336@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200337 ','JUAN GABRIEL ','POMA ','SUPO ','200337@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('200520 ','ANGELA VANESSA ','REYNAGA ','FLORES ','200520@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184211 ','JHON JAIME ','TINCUSI ','CCORIMANYA ','184211@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('174913 ','EDWARD BRAYAN ','NAOLA ','PUMA ','174913@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193000 ','ALEJANDRO MIGUEL ','CHOQUELUQUE ','GARCIA ','193000@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('184202 ','ALEXANDER ','HANCCO ','LE�N ','184202@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('192424 ','KAROL GIANELLA ','MACCARCCO ','QUISPE ','192424@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('193002 ','ADELMECIA ','MERCADO ','HUAYCHO ','193002@unsaac.edu.pe ');
INSERT INTO Alumno(Codigo, Nombres, AP, AM,Correo) values	('182901 ','ALBERTO ','COLLANTE ','CARRASCO ','182901@unsaac.edu.pe ');
