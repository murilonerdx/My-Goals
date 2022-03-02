/*
 * Esta se��o � apenas para cria��o das tabelas para este cap�tulo
 * � feito primeiro o DROP da(s) tabela(s) caso ela j� exista
 * Ap�s � feita a cria��o da tabela no contexto do cap�tulo
 * Por fim a popula��o da tabela com o contexto do cap�tulo
 *
 * Recomenda-se executar esta parte inicial a cada cap�tulo
 */

 /*
 * Caso tenha eventuais problemas de convers�o de datas, execute o seguinte comando:
 *
 * SET DATEFORMAT ymd
 *
 * No in�cio de cada script estou incluindo este comando, caso voc� retome o exerc�cio em outro dia,
 * � s� executar este comando (1 vez apenas, pois � por sess�o) antes de executar as queries
 */

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
SET DATEFORMAT ymd

IF EXISTS(SELECT * FROM sys.sequences WHERE name = 'SeqIdVendas')  
BEGIN 
	DROP SEQUENCE dbo.SeqIdVendas 
END 

IF EXISTS(SELECT * FROM sys.synonyms WHERE name = 'VendasSinonimo')  
BEGIN 
	DROP SYNONYM dbo.VendasSinonimo 
END 

IF OBJECT_ID('dbo.VendasProdutoQuantidadeValor', 'TF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.VendasProdutoQuantidadeValor 
END 

IF OBJECT_ID('dbo.VendasProduto', 'IF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.VendasProduto 
END 

IF OBJECT_ID('dbo.ValorTotal', 'FN') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.ValorTotal 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasProdutoB')  
BEGIN 
	DROP VIEW dbo.VendasProdutoB 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasProdutoA')  
BEGIN 
	DROP VIEW dbo.VendasProdutoA 
END 

IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'VendasProdutoATrigger')  
BEGIN 
	DROP TRIGGER dbo.VendasProdutoATrigger 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasProdutoA')  
BEGIN 
	DROP VIEW dbo.VendasProdutoA 
END 

IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'VendasAlteracao')  
BEGIN 
	DROP TRIGGER dbo.VendasAlteracao 
END 

IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'VendasInclusao')  
BEGIN 
	DROP TRIGGER dbo.VendasInclusao 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'LogVendas')  
BEGIN 
	DROP TABLE dbo.LogVendas 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'IncluiVendas')  
BEGIN 
	DROP PROCEDURE dbo.IncluiVendas 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'VendasComTotal')  
BEGIN 
	DROP PROCEDURE dbo.VendasComTotal 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'VendasInclusaoDinamico')  
BEGIN 
	DROP PROCEDURE dbo.VendasInclusaoDinamico 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasViewIndexed')  
BEGIN 
	DROP VIEW dbo.VendasViewIndexed 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'PopularVendas')  
BEGIN 
	DROP PROCEDURE dbo.PopularVendas 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Vendas')  
BEGIN 
	DROP TABLE dbo.Vendas 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Produto')  
BEGIN 
	DROP TABLE dbo.Produto 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'CadastroCliente')  
BEGIN 
	DROP TABLE dbo.CadastroCliente 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Cidade')  
BEGIN 
	DROP TABLE dbo.Cidade 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Estado')  
BEGIN 
	DROP TABLE dbo.Estado 
END 

GO 

/*
Tabela de dom�nio que representa os estados brasileiros
*/

CREATE TABLE dbo.Estado 
(
	Id TINYINT IDENTITY(1, 1) NOT NULL, 
	Descricao VARCHAR(150) NOT NULL, 
	CONSTRAINT PK_Estado PRIMARY KEY (Id) 
)

INSERT INTO dbo.Estado (Descricao) 
VALUES ('S�o Paulo'), 
       ('Rio de Janeiro'), 
	   ('Minas Gerais') 

/*
Tabela de dom�nio que representa as cidades brasileiras
Utiliza-se o c�digo da tabela de dom�nio de Estado para identificar � qual estado pertence cada cidade
*/

CREATE TABLE dbo.Cidade 
(
	Id SMALLINT IDENTITY(1, 1) NOT NULL, 
	Id_Estado TINYINT NOT NULL, 
	Descricao VARCHAR(250) NOT NULL, 
	CONSTRAINT PK_Cidade PRIMARY KEY (Id), 
	CONSTRAINT FK_Estado_Cidade FOREIGN KEY (Id_Estado) REFERENCES Estado (Id) 
) 

INSERT INTO dbo.Cidade (Id_Estado, Descricao) 
VALUES (1, 'Santo Andr�'), 
       (1, 'S�o Bernardo do Campo'), 
	   (1, 'S�o Caetano do Sul'), 
	   (2, 'Duque de Caxias'), 
	   (2, 'Niter�i'), 
	   (2, 'Petr�polis'), 
	   (3, 'Uberl�ndia'), 
	   (3, 'Contagem'), 
	   (3, 'Juiz de Fora') 

/*
Representa��o da tabela de cadastro de clientes
H� v�nculo do cliente com a tabela de dom�nio Cidade
Como a tabela de dom�nio Cidade j� possui v�nculo com a tabela Estado, n�o � necess�rio criar v�nculo forte entre a tabela CadastroCliente e a tabela Estado
*/

CREATE TABLE dbo.CadastroCliente 
(
	Id INTEGER IDENTITY(1, 1) NOT NULL, 
	Nome VARCHAR(150) NOT NULL, 
	Endereco VARCHAR(250) NOT NULL, 
	Id_Cidade SMALLINT NOT NULL, 
	Email VARCHAR(250) NOT NULL, 
	Telefone1 VARCHAR(20) NOT NULL, 
	Telefone2 VARCHAR(20) NULL, 
	Telefone3 VARCHAR(20) NULL, 
	CONSTRAINT PK_CadastroCliente PRIMARY KEY (Id), 
	CONSTRAINT FK_Cidade_CadastroCliente FOREIGN KEY (Id_Cidade) REFERENCES Cidade (Id) 
) 

INSERT INTO dbo.CadastroCliente (Nome, Endereco, Id_Cidade, Email, Telefone1, Telefone2, Telefone3) 
VALUES ('Cliente 1',  'Rua 1',  1, 'cliente_1@email.com',  '(11) 0000-0000', NULL, NULL), 
       ('Cliente 2',  'Rua 2',  1, 'cliente_2@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 3',  'Rua 3',  1, 'cliente_3@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 4',  'Rua 4',  2, 'cliente_4@email.com',  '(11) 0000-0000', '(11) 1111-1111', NULL), 
	   ('Cliente 5',  'Rua 5',  2, 'cliente_5@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 6',  'Rua 6',  2, 'cliente_6@email.com',  '(11) 0000-0000', '(11) 1111-1111', NULL), 
	   ('Cliente 7',  'Rua 7',  3, 'cliente_7@email.com',  '(11) 0000-0000', NULL,             NULL), 
	   ('Cliente 8',  'Rua 8',  3, 'cliente_8@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 9',  'Rua 9',  3, 'cliente_9@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 10', 'Rua 10', 4, 'cliente_10@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 11', 'Rua 11', 4, 'cliente_11@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 12', 'Rua 12', 4, 'cliente_12@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 13', 'Rua 13', 5, 'cliente_13@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 14', 'Rua 14', 5, 'cliente_14@email.com', '(21) 0000-0000', '(21) 1111-1111', NULL), 
	   ('Cliente 15', 'Rua 15', 5, 'cliente_15@email.com', '(21) 0000-0000', '(21) 1111-1111', NULL), 
	   ('Cliente 16', 'Rua 16', 6, 'cliente_16@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 17', 'Rua 17', 6, 'cliente_17@email.com', '(21) 0000-0000', NULL,             NULL), 
	   ('Cliente 18', 'Rua 18', 6, 'cliente_18@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 19', 'Rua 19', 7, 'cliente_19@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 20', 'Rua 20', 7, 'cliente_20@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 21', 'Rua 21', 7, 'cliente_21@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 22', 'Rua 22', 8, 'cliente_22@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 23', 'Rua 23', 8, 'cliente_23@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 24', 'Rua 24', 8, 'cliente_24@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 25', 'Rua 25', 9, 'cliente_25@email.com', '(31) 0000-0000', NULL,             NULL), 
	   ('Cliente 26', 'Rua 26', 9, 'cliente_26@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 27', 'Rua 27', 9, 'cliente_27@email.com', '(31) 0000-0000', '(31) 1111-1111', NULL) 

/*
Cria��o de uma tabela para cadastro simples de produtos
*/

CREATE TABLE dbo.Produto 
(
	Id SMALLINT IDENTITY(1, 1) NOT NULL, 
	Descricao VARCHAR(250) NOT NULL, 
	CONSTRAINT PK_Produto PRIMARY KEY (Id) 
) 

/*
Cria��o de um �ndice auxiliar, para filtragem � partir da coluna Descricao da tabela Produto
*/

CREATE NONCLUSTERED INDEX IDX_Produto_Descricao ON dbo.Produto (Descricao) 

INSERT INTO dbo.Produto (Descricao) 
VALUES ('Produto A'), 
       ('Produto B'), 
       ('Produto C')

/*
Cria��o de uma tabela de vendas que ir� unir informa��es de clientes e produtos
*/

CREATE TABLE dbo.Vendas 
(
	Id BIGINT IDENTITY(1, 1) NOT NULL, 
	Pedido UNIQUEIDENTIFIER NOT NULL, 
	Id_Cliente INTEGER NOT NULL, 
	Id_Produto SMALLINT NOT NULL, 
	Quantidade SMALLINT NOT NULL, 
	"Valor Unitario" NUMERIC(9, 2) NOT NULL, 
	"Data Venda" SMALLDATETIME NOT NULL, 
	Observacao NVARCHAR(100) NULL, 
	CONSTRAINT PK_Vendas PRIMARY KEY (Id, Id_Cliente, Id_Produto), 
	CONSTRAINT UC_Vendas_Pedido_Cliente_Produto UNIQUE (Pedido, Id_Cliente, Id_Produto), 
	CONSTRAINT FK_CadastroCliente_Vendas FOREIGN KEY (Id_Cliente) REFERENCES CadastroCliente (Id), 
	CONSTRAINT FK_Produto_Vendas FOREIGN KEY (Id_Produto) REFERENCES Produto (Id) 
) 

/*
Cria��o de um �ndice auxiliar, para uso no JOIN atrav�s das colunas Id_Cliente (com a tabela CadastroCliente) e Id_Produto (com a tabela Produto) 
*/

CREATE NONCLUSTERED INDEX IDX_Vendas_Id_Cliente ON dbo.Vendas (Id_Cliente) 
CREATE NONCLUSTERED INDEX IDX_Vendas_Id_Produto ON dbo.Vendas (Id_Produto) 

/*
Cria��o de um �ndice auxiliar, para filtragem � partir da coluna "Data Venda" da tabela Vendas
*/

CREATE NONCLUSTERED INDEX IDX_Vendas_DataVenda ON dbo.Vendas("Data Venda") INCLUDE (Quantidade, "Valor Unitario") 
GO 

CREATE PROCEDURE dbo.PopularVendas 
AS 
BEGIN 
	DECLARE @DataInicial SMALLDATETIME = CAST('2000-01-01' AS SMALLDATETIME) 
	DECLARE @DataFinal SMALLDATETIME = CAST('2020-12-15' AS SMALLDATETIME) 
	DECLARE @DataAtual SMALLDATETIME = @DataInicial
	DECLARE @Bloco SMALLINT = 5000 
	DECLARE @BlocoAtual SMALLINT = 0 
	DECLARE @Pedido UNIQUEIDENTIFIER 

	BEGIN TRANSACTION 

	WHILE (@DataFinal > @DataAtual) 
	BEGIN 
		IF (@BlocoAtual >= @Bloco) 
		BEGIN 
			COMMIT TRANSACTION 
			BEGIN TRANSACTION 
			SET @BlocoAtual = 0 
		END 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 1, 1, 10, 5.65, @DataAtual), 
			   (@Pedido, 1, 2, 10, 7.65, @DataAtual)
				
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 2, 1, 20, 5.65, @DataAtual), 
			   (@Pedido, 2, 2, 20, 7.65, @DataAtual) 
		
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 3, 1, 30, 5.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 4, 2, 40, 7.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 5, 1, 50, 5.65, @DataAtual), 
			   (@Pedido, 5, 2, 50, 7.65, @DataAtual) 
	
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 6, 2, 60, 7.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 7, 1, 70, 5.65, @DataAtual) 

		SET @DataAtual = DATEADD(d, 1, @DataAtual)
		SET @BlocoAtual = @BlocoAtual + 10 
	END 

	IF (@BlocoAtual > 0) 
	BEGIN 
		COMMIT TRANSACTION 
	END 
END 
GO 

EXEC dbo.PopularVendas 
GO 

/*
Inclus�o de linhas de exemplo com datas completas (data / hora) e descri��o na coluna Observa��o, lembrando que esta coluna � um NVARCHAR!
*/

DECLARE @Pedido UNIQUEIDENTIFIER 

SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 1, 1, 10, 5.65, CAST('2020-12-16 09:00:00' AS SMALLDATETIME), N'Observa��o 1'), 
       (@Pedido, 1, 2, 10, 7.65, CAST('2020-12-16 10:00:00' AS SMALLDATETIME), N'Observa��o 2')
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 2, 1, 20, 5.65, CAST('2020-12-16 11:00:00' AS SMALLDATETIME), N'Observa��o 3'), 
       (@Pedido, 2, 2, 20, 7.65, CAST('2020-12-16 12:00:00' AS SMALLDATETIME), N'Observa��o 4')
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 3, 1, 30, 5.65, CAST('2020-12-16 13:00:00' AS SMALLDATETIME), N'Observa��o 5') 
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 4, 2, 40, 7.65, CAST('2020-12-16 14:00:00' AS SMALLDATETIME), N'Observa��o 6') 
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 5, 1, 50, 5.65, CAST('2020-12-16 15:00:00' AS SMALLDATETIME), N'Observa��o 7'), 
       (@Pedido, 5, 2, 50, 7.65, CAST('2020-12-16 16:00:00' AS SMALLDATETIME), N'Observa��o 8') 
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 6, 2, 60, 7.65, CAST('2020-12-16 17:00:00' AS SMALLDATETIME), N'Observa��o 9') 
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 7, 1, 70, 5.65, CAST('2020-12-16 18:00:00' AS SMALLDATETIME), N'Observa��o 10') 
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 1, 1, 10, 5.65, CAST('2020-12-17 09:00:00' AS SMALLDATETIME), N'Observa��o 11'), 
       (@Pedido, 1, 2, 10, 7.65, CAST('2020-12-17 10:00:00' AS SMALLDATETIME), N'Observa��o 12')
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 2, 1, 20, 5.65, CAST('2020-12-17 11:00:00' AS SMALLDATETIME), N'Observa��o 13'), 
       (@Pedido, 2, 2, 20, 7.65, CAST('2020-12-17 12:00:00' AS SMALLDATETIME), N'Observa��o 14') 
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 3, 1, 30, 5.65, CAST('2020-12-17 13:00:00' AS SMALLDATETIME), N'Observa��o 15')
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 4, 2, 40, 7.65, CAST('2020-12-17 14:00:00' AS SMALLDATETIME), N'Observa��o 16')
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 5, 1, 50, 5.65, CAST('2020-12-17 15:00:00' AS SMALLDATETIME), N'Observa��o 17'), 
       (@Pedido, 5, 2, 50, 7.65, CAST('2020-12-17 16:00:00' AS SMALLDATETIME), N'Observa��o 18')
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 6, 2, 60, 7.65, CAST('2020-12-17 17:00:00' AS SMALLDATETIME), N'Observa��o 19')
SET @Pedido = NEWID() 
INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao) 
VALUES (@Pedido, 7, 1, 70, 5.65, CAST('2020-12-17 18:00:00' AS SMALLDATETIME), N'Observa��o 20') 

GO 

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por produto que esteja com um determinado valor
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE P.Descricao = 'Produto A' 

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por produto que n�o estejam com um determinado valor
Neste caso foi utilizado o operador standard <>
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE P.Descricao <> 'Produto A' 

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por produto que n�o estejam com um determinado valor
Neste caso foi utilizado o operador propriet�rio !=
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE P.Descricao != 'Produto A' 

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por produto que esteja com um determinado valor ou de outro determinado valor
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE P.Descricao = 'Produto A' 
    OR P.Descricao = 'Produto B' 

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE P.Descricao IN ('Produto A', 'Produto B' ) 

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" = CAST('2020-12-04' AS SMALLDATETIME) 
   AND (P.Descricao = 'Produto A' OR P.Descricao = 'Produto B') 

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por uma data de venda espec�fica, convertendo a coluna "Data Venda"
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE CONVERT(VARCHAR, V."Data Venda", 23) = '2020-12-04' 

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por uma data de venda espec�fica, convertendo o valor do predicado
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" = CAST('2020-12-04' AS SMALLDATETIME) 

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por uma data de venda espec�fica, convertendo o valor do predicado
Resultado n�o trar� todas as vendas do dia, pois o filtro implicitamente converte a data incluindo a hora 00:00:00
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" = '2020-12-04' 

/*
Demonstra��o de como pegar informa��es de Vendas com v�nculo direto �s tabelas CadastroCliente e Produto filtrando por uma data de venda espec�fica, convertendo o valor do predicado
Resultado trar� todas as vendas do dia, pois o filtro abrange a data/hora maior ou igual a '2020-12-16 00:00:00' e menor que '2020-12-17 00:00:00', assim traz tudo do dia
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" >= CAST('2020-12-16' AS SMALLDATETIME) 
   AND V."Data Venda" < DATEADD(d, 1, CAST('2020-12-16' AS SMALLDATETIME)) 

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" >= CAST('2020-12-16' AS SMALLDATETIME) 
   AND V."Data Venda" < CAST('2020-12-17' AS SMALLDATETIME) 

/*
Demonstra��o de como pegar informa��es de Vendas de um determinado produto utilizando subquery com IN
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 WHERE V.Id_Produto IN (SELECT Id 
                          FROM dbo.Produto 
					     WHERE Descricao = 'Produto A') 

/*
Demonstra��o de como pegar informa��es de Vendas de um determinado produto utilizando subquery com EXISTS
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 WHERE EXISTS (SELECT Id 
                 FROM dbo.Produto 
			    WHERE Id = V.Id_Produto
				  AND Descricao = 'Produto A') 

/*
Demonstra��o de como pegar informa��es de Vendas, o SQL Server far� a convers�o impl�cita do VARCHAR para NVARCHAR
*/

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V.Observacao = CAST('Observa��o 1' AS VARCHAR(100)) 

/*
Demonstra��o de como pegar informa��es de Vendas, para fazer a convers�o da String direto para NVARCHAR basta incluir o caractere N antes do valor do predicado
*/

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V.Observacao = N'Observa��o 1' 

/*
Demonstra��o de como pegar informa��es de Vendas, � poss�vel fazer convers�o da String NVARCHAR utilizando o CAST
*/

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V.Observacao = CAST('Observa��o 1' AS NVARCHAR(100)) 

/*
Demonstra��o de como pegar informa��es de Vendas, onde a coluna observa��o estiver com NULO
*/

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V.Observacao IS NULL 

/*
Demonstra��o de como pegar informa��es de Vendas, onde a coluna observa��o estiver N�O NULO
*/

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V.Observacao IS NOT NULL 

/*
Demonstra��o de como pegar informa��es de Vendas, utilizando no predicado o operador LIKE
*/

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE Cliente.Nome LIKE '%7' 

/*
Demonstra��o de como pegar informa��es de Vendas, utilizando no predicado o operador NOT LIKE
*/

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE Cliente.Nome NOT LIKE '%7' 

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE NOT P.Descricao = 'Produto A' 

SELECT P.Descricao AS "Produto", 
       Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda", V.Observacao 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE Cliente.Nome LIKE 'Cli%2' 
