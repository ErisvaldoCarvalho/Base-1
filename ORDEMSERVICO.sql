-- CTR + SHIFT + R = ATUALIZA O SCRIP CASO ESTEJA ACUSANDO ERROS
-- CTR + R = ATALHO PARA FECHAR RESULTADO
USE MASTER
GO

IF EXISTS(SELECT 1 FROM SYS.DATABASES WHERE NAME = 'ORDEMSERVICO')
BEGIN
	ALTER DATABASE ORDEMSERVICO SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE ORDEMSERVICO
END
GO

CREATE DATABASE ORDEMSERVICO
GO

USE ORDEMSERVICO
GO
--TABELA "PERMISS�ES DO USUARIO"
CREATE TABLE Permissao
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Descricao VARCHAR(250)
)
GO
--TABELA "PLANO"
CREATE TABLE Plano
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Descricao VARCHAR(150),
	Valor VARCHAR(50)
)
GO

INSERT INTO Plano(Descricao, Valor)
	VALUES('300 MEGAS', 99.90),
	('350 MEGAS + 1 ROTEADOR EM COMODATO', 119.90),
	('400 MEGAS + 1 ROTEADOR EM COMODATO', 129.90),
	('500 MEGAS + 2 ROTEADORES EM COMODATO', 139.90)
GO
CREATE PROCEDURE SP_InserirPlano
	@Id INT OUTPUT,
	@Descricao VARCHAR(150),
	@Valor VARCHAR(50)
AS
	INSERT INTO Plano(Descricao, Valor)
		VALUES(@Descricao,	@Valor)
	SET @Id = (SELECT @@IDENTITY)
GO

--EXEC SP_InserirPlano 5, '1 GIGA + 3 PONTOS DE WI-FI', 500.00
CREATE PROC SP_BuscarPlano
	@Filtro VARCHAR(50)
	as
IF EXISTS(SELECT 1 FROM Plano WHERE CONVERT(VARCHAR(50), Id) = @Filtro)
	SELECT Id, Descricao, Valor FROM Plano WHERE CONVERT(VARCHAR(50), Id) = @Filtro
ELSE
	SELECT Id, Descricao, Valor FROM Plano WHERE Descricao LIKE '%' + @filtro + '%'
GO

CREATE PROC SP_ExcluirPlano
	@Id INT
AS
	DELETE FROM Plano WHERE Id = @Id
GO
CREATE PROC SP_AlterarPlano
	@Id INT,
	@Descricao VARCHAR(150),
	@Valor VARCHAR(50)
AS
	UPDATE Plano SET
	Descricao = @Descricao,
	Valor = @Valor
	WHERE Id = @Id
GO
-- EXEC SP_AlterarPlano 9, '600', '100'
--SELECT*FROM Plano

--TABELA "PESSOA"
CREATE TABLE Pessoa
(
	-- DADOS PESSOAIS
	Id INT PRIMARY KEY IDENTITY(1,1),-----AUTOMATICO
	Ativo BIT,----------------------------FEITO
	NomeUsuario VARCHAR(150),-------------FEITO
	Senha VARCHAR(150),-------------------FEITO
	NomeCompleto VARCHAR(150),------------FEITO
	Cpf VARCHAR(14),----------------------FEITO
	Rg VARCHAR(13),-----------------------FEITO
	OrgaoExpeditor VARCHAR(6),------------FEITO
	DataNascimento DATETIME,--------------FEITO
	Cep VARCHAR(10),
	Rua VARCHAR(150),---------------------FEITO
	NumCasa VARCHAR(10),------------------FEITO
	EstadoCivil VARCHAR(10),--------------FEITO
	Nacionalidade VARCHAR(10),------------FEITO
	Email VARCHAR(30),--------------------FEITO
	Telefone VARCHAR(15),-----------------FEITO
	CelularUm VARCHAR(16),----------------FEITO
	CelularDois VARCHAR(16),--------------FEITO
	Cidade VARCHAR(10),-------------------FEITO
	Uf VARCHAR(2),------------------------FEITO
	-- DADOS DO FUNCIONARIO
	Funcionario BIT,----------------------FEITO
	Id_Permissao INT,---------------------FEITO
	Salario varchar(15),
	Cargo VARCHAR(50),--------------------FEITO
	DataAdmissao DATETIME NULL,-----------FEITO
	DataDemissao DATETIME NULL,-----------FEITO
	Banco VARCHAR(40),--------------------FEITO
	NumeroAgenciaBanco VARCHAR(10),-------FEITO
	NumeroContaBanco VARCHAR(15),---------FEITO
	-- DADOS DO CLIENTE
	Cliente BIT,--------------------------FEITO
	Id_Plano INT,
	InicioDoContrato DATETIME NULL,
	FimDoContrato DATETIME NULL,
	-- OBSERVA�OES GERAIS
	Observacao VARCHAR(250)---------------FEITO
)
GO
INSERT INTO Pessoa(Ativo, NomeUsuario, Senha, NomeCompleto, DataNascimento, Rua, NumCasa, Cpf, Rg, OrgaoExpeditor, Email, Telefone, Id_Permissao, Id_Plano, Cliente)
	VALUES (1, '3V4ND3R50N', 'Senha@123', 'EVANDERSON RIBEIRO', '05-01-1988', 'RUA DOS ABACATEIROS', '543', '02227855193', '6666666', 'SSPTO', 'evanderson@email.com', '63992019277', 1, 4, 1)
	--('LuizSenai', 'Senha@321', 'LUIZ TAL', '12345678912', 1),
	--('DaviSenai', 'Senha@456', 'DAVI TAL', '98765432198', 1),
	--('WandersonSenai', 'Senha@654', 'WANDERSON TAL', '7418529374', 1)
GO
INSERT INTO Pessoa(Ativo, NomeUsuario, Senha, NomeCompleto, Cpf, Id_Permissao, Id_Plano, Cliente)
	VALUES (1, 'admin', 'admin', 'USUARIO TESTE', '14523678955', 2, 2, 1)
GO
--DROP PROCEDURE SP_InserirUsuario
GO
CREATE PROCEDURE SP_InserirUsuario
	@Id INT OUTPUT,
	@Ativo BIT,
	@NomeUsuario VARCHAR(150),
	@Senha VARCHAR(150),
	@NomeCompleto VARCHAR(150),
	@Cpf VARCHAR(14),
	@Rg VARCHAR(13),
	@OrgaoExpeditor VARCHAR(6),
	@DataNascimento DATETIME,
	@Cep VARCHAR(10),
	@Rua VARCHAR(150),
	@NumCasa VARCHAR(10),
	@EstadoCivil VARCHAR(10),
	@Nacionalidade VARCHAR(10),
	@Email VARCHAR(30),
	@Telefone VARCHAR(15),
	@CelularUm VARCHAR(16),
	@CelularDois VARCHAR(16),
	@Cidade VARCHAR(10),
	@Uf VARCHAR(2),
	@Funcionario BIT,
	@Id_Permissao INT,
	@Salario VARCHAR(15),
	@Cargo VARCHAR(50),
	@DataAdmissao DATETIME = NULL,
	@DataDemissao DATETIME = NULL,
	@Banco VARCHAR(40),
	@NumeroAgenciaBanco VARCHAR(10),
	@NumeroContaBanco VARCHAR(15),
	@Cliente BIT,
	@InicioDoContrato DATETIME = NULL,
	@FimDoContrato DATETIME = NULL,
	@Observacao VARCHAR(250),
	@Id_Plano INT
AS
	INSERT INTO Pessoa(
	Ativo,
	NomeUsuario,
	Senha,
	NomeCompleto,
	Cpf,
	Rg,
	OrgaoExpeditor,
	DataNascimento,
	Cep,
	Rua,
	NumCasa,
	EstadoCivil,
	Nacionalidade,
	Email,
	Telefone,
	CelularUm,
	CelularDois,
	Cidade,
	Uf,
	Funcionario,
	Id_Permissao,
	Salario,
	Cargo,
	DataAdmissao,
	DataDemissao,
	Banco,
	NumeroAgenciaBanco,
	NumeroContaBanco,
	Cliente,
	InicioDoContrato,
	FimDoContrato,
	Observacao,
	Id_Plano)
	VALUES(@Ativo,
	@NomeUsuario,
	@Senha,
	@NomeCompleto,
	@Cpf,
	@Rg,
	@OrgaoExpeditor,
	@DataNascimento,
	@Cep,
	@Rua,
	@NumCasa,
	@EstadoCivil,
	@Nacionalidade,
	@Email,
	@Telefone,
	@CelularUm,
	@CelularDois,
	@Cidade,
	@Uf,
	@Funcionario,
	@Id_Permissao,
	@Salario,
	@Cargo,
	@DataAdmissao,
	@DataDemissao,
	@Banco,
	@NumeroAgenciaBanco,
	@NumeroContaBanco,
	@Cliente,
	@InicioDoContrato,
	@FimDoContrato,
	@Observacao,
	@Id_Plano)
	SET @Id = (SELECT @@IDENTITY)
GO

EXEC SP_InserirUsuario 0, 1, 'Superadmin', 'Superadmin', 'ADMINISTRADOR DO SISTEMA', '666.666.666-66', '66.666.666', 'SSP',
'05-01-1988', '77827-150', 'RUA TAL', '543', 'CASADO', 'BRASILEIRO', 'super_admin@email.com', '633411-2300', '63992019277', '13992019277',
'ARAGUAINA', 'TO', 1, 3, '2.500', 'SUPORTE1', '05-01-2021', '05-01-2022', 'Banco 0260 Nu Pagamentos S.A', '0001', '5658481-4', 1,
'2020-05-01', '2022-05-01', 'TEXTO TESTE DE OBSERVACAO', 3
GO

--TABELA "GEST�O DE O.S"
CREATE TABLE GestaoDeOs
	(
	Protocolo INT PRIMARY KEY IDENTITY(1,1),
	TipoChamado VARCHAR (150),
	Descricao VARCHAR(1000),
	DataAbertura DATETIME,
	DataDeFechamento DATETIME,
	TecnicoResponsavel VARCHAR(150),
	Id_Funcionario INT,
	Id_Cliente INT,
	Id_Plano INT,
	Id_Status INT
)
GO

--DROP PROC SP_AlterarUsuario
CREATE PROC SP_AlterarUsuario
	@Id INT, --OUTPUT,
	@Ativo BIT,
	@NomeUsuario VARCHAR(150),
	@Senha VARCHAR(150),
	@NomeCompleto VARCHAR(150),
	@Cpf VARCHAR(14),
	@Rg VARCHAR(13),
	@OrgaoExpeditor VARCHAR(6),
	@DataNascimento DATETIME,
	@Cep VARCHAR(10),
	@Rua VARCHAR(150),
	@NumCasa VARCHAR(10),
	@EstadoCivil VARCHAR(10),
	@Nacionalidade VARCHAR(10),
	@Email VARCHAR(30),
	@Telefone VARCHAR(15),
	@CelularUm VARCHAR(16),
	@CelularDois VARCHAR(16),
	@Cidade VARCHAR(10),
	@Uf VARCHAR(2),
	@Funcionario BIT,
	@Id_Permissao INT,
	@Salario FLOAT,
	@Cargo VARCHAR(50),
	@DataAdmissao DATETIME = NULL,
	@DataDemissao DATETIME = NULL,
	@Banco VARCHAR(40),
	@NumeroAgenciaBanco VARCHAR(10),
	@NumeroContaBanco VARCHAR(15),
	@Cliente BIT,
	@InicioDoContrato DATETIME = NULL,
	@FimDoContrato DATETIME = NULL,
	@Observacao VARCHAR(250),
	@Id_Plano INT
AS
	UPDATE Pessoa SET
	Ativo = @Ativo,
	NomeUsuario = @NomeUsuario,
	Senha = @Senha,
	NomeCompleto = @NomeCompleto,
	Cpf = @Cpf,
	Rg = @Rg,
	OrgaoExpeditor = @OrgaoExpeditor,
	DataNascimento = @DataNascimento,
	Cep = @Cep,
	Rua = @Rua,
	NumCasa = @NumCasa,
	EstadoCivil = @EstadoCivil,
	Nacionalidade = @Nacionalidade,
	Email = @Email,
	Telefone = @Telefone,
	CelularUm = @CelularUm,
	CelularDois = @CelularDois,
	Cidade = @Cidade,
	Uf = @Uf,
	Funcionario = @Funcionario,
	Id_Permissao = @Id_Permissao,
	Salario = @Salario,
	Cargo = @Cargo,
	DataAdmissao = @DataAdmissao,
	DataDemissao = @DataDemissao,
	Banco = @Banco,
	NumeroAgenciaBanco = @NumeroAgenciaBanco,
	NumeroContaBanco = @NumeroContaBanco,
	Cliente = @Cliente,
	InicioDoContrato = @InicioDoContrato,
	FimDoContrato = @FimDoContrato,
	Observacao = @Observacao,
	Id_Plano = @Id_Plano
	WHERE Id = @Id
GO

SELECT * FROM PLano
SELECT NomeCompleto, Cpf, Ativo, Cliente, Funcionario, Id_Plano, Id_Permissao FROM Pessoa
--TABELA "STATUS DA O.S"
CREATE TABLE StatusOs
	(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Descricao VARCHAR(15) 
)

--INSERT DAS TABELAS "PERMISS�O"
INSERT INTO Permissao(Descricao)
	VALUES('Abrir O.S'),
	('Abrir O.S, Fechar O.S'),
	('Abrir O.S, Fechar O.S, Encaminhar O.S')
GO

--TABELA "STATUS DA O.S"
INSERT INTO StatusOs(Descricao)
	VALUES ('Aberto'),
	('Fechado'),
	('Encaminhado')
GO
--TABELA "GEST�O DE O.S"
INSERT INTO GestaoDeOs(TipoChamado, Descricao, DataAbertura, DataDeFechamento, TecnicoResponsavel, Id_Funcionario, Id_Cliente, Id_Plano, Id_Status)
	VALUES ('Loss',	'Cliente sem conex�o, ONU apresentando perca de sinal.', null, NULL, NULL , 1, 3, 1, 1)
GO

--DROP PROC SP_BuscarUsuario
CREATE PROC SP_BuscarUsuario
	@Filtro VARCHAR(250) = ''
AS
	SELECT
	Pessoa.Id,
	Ativo,
	NomeUsuario,
	Senha,
	NomeCompleto,
	Cpf,
	Rg,
	OrgaoExpeditor,
	DataNascimento,
	Cep,
	Rua,
	NumCasa,
	EstadoCivil,
	Nacionalidade,
	Email,
	Telefone,
	CelularUm,
	CelularDois,
	Cidade,
	Uf,
	Funcionario,
	Id_Permissao,
	Salario,
	Cargo,
	DataAdmissao,
	DataDemissao,
	Banco,
	NumeroAgenciaBanco,
	NumeroContaBanco,
	Cliente,
	InicioDoContrato,
	FimDoContrato,
	Observacao,
	Id_Plano,
	Plano.Descricao AS Plano
	FROM Pessoa 
	LEFT JOIN Plano ON Pessoa.Id_Plano = Plano.Id
	WHERE NomeCompleto LIKE '%' + @filtro + '%'
	OR Cpf LIKE '%'+ @filtro +'%'--CONVERT(VARCHAR(50), Id) = @Filtro
GO


CREATE PROC SP_ExcluirUsuario
	@Id INT
AS
	DELETE FROM Pessoa WHERE Id = @Id
GO

/*
DECLARE @Filtro VARCHAR(50) = '50'

IF EXISTS(SELECT 1 FROM Plano WHERE CONVERT(VARCHAR(50), Id) = @Filtro)
	SELECT Id, Descricao, Valor FROM Plano WHERE CONVERT(VARCHAR(50), Id) = @Filtro
ELSE
	SELECT Id, Descricao, Valor FROM Plano WHERE Descricao LIKE '%' + @filtro + '%'
*/