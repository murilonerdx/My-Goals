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
Cria��o de um �ndice auxiliar, para filtragem � partir da coluna DataVenda da tabela Vendas
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

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************

/*
Demonstra��o de cria��o de procedure com par�metros de input e output
*/

CREATE PROCEDURE dbo.VendasComTotal 
(
	@Produto VARCHAR(250), 
	@QuantidadeVendas INTEGER = 0 OUTPUT 
) 
AS 
BEGIN 
	SELECT V.Pedido AS "C�digo pedido", 
	       P.Descricao AS Produto, 
		   V.Quantidade, V."Valor Unitario", (V.Quantidade * V."Valor Unitario") AS "Valor Venda" 
	  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
	 INNER JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 
	 WHERE P.Descricao = @Produto 

	 SET @QuantidadeVendas = @@ROWCOUNT;

	RETURN;
END 
GO 

DECLARE @Quantidade INTEGER;

EXEC dbo.VendasComTotal @Produto = 'Produto A', @QuantidadeVendas = @Quantidade OUTPUT 

SELECT @Quantidade AS "Quantidade de vendas" 
GO

/*
Demonstra��o de altera��o de procedure e uso de NOCOUNT
*/

ALTER PROCEDURE dbo.VendasComTotal 
(
	@Produto VARCHAR(250), 
	@QuantidadeVendas INTEGER = 0 OUTPUT 
) 
AS 
BEGIN 
	SET NOCOUNT ON;

	SELECT V.Pedido AS "C�digo pedido", 
	       P.Descricao AS Produto, 
		   V.Quantidade, V."Valor Unitario", (V.Quantidade * V."Valor Unitario") AS "Valor Venda" 
	  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
	 INNER JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 
	 WHERE P.Descricao = @Produto 

	 SET @QuantidadeVendas = @@ROWCOUNT;

	RETURN;
END 
GO 

DECLARE @Quantidade INTEGER;

EXEC dbo.VendasComTotal @Produto = 'Produto A', @QuantidadeVendas = @Quantidade OUTPUT 

SELECT @Quantidade AS "Quantidade de vendas" 
GO 

/*
Demonstra��o de uso de IF ELSE na procedure
*/

ALTER PROCEDURE dbo.VendasComTotal 
(
	@Produto VARCHAR(250), 
	@QuantidadeVendas INTEGER = 0 OUTPUT 
) 
AS 
BEGIN 
	SET NOCOUNT ON;

	IF (@QuantidadeVendas = 0) 
	BEGIN 
		SELECT V.Pedido AS "C�digo pedido", 
			   P.Descricao AS Produto, 
			   V.Quantidade, V."Valor Unitario", (V.Quantidade * V."Valor Unitario") AS "Valor Venda" 
		  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
		 INNER JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 
		 WHERE P.Descricao = @Produto 

		 SET @QuantidadeVendas = @@ROWCOUNT;
	END 
	ELSE 
	BEGIN 
		PRINT 'N�o faz nada' 
	END 

	RETURN;
END 
GO 

DECLARE @Quantidade INTEGER = 0;

EXEC dbo.VendasComTotal @Produto = 'Produto A', @QuantidadeVendas = @Quantidade OUTPUT 

SELECT @Quantidade AS "Quantidade de vendas" 

GO 

DECLARE @Quantidade INTEGER = 1; 

EXEC dbo.VendasComTotal @Produto = 'Produto A', @QuantidadeVendas = @Quantidade OUTPUT 

SELECT @Quantidade AS "Quantidade de vendas" 

GO 

/*
Demonstra��o de uso de WHILE na procedure
*/

CREATE PROCEDURE dbo.IncluiVendas 
(
	@Id_Cliente INTEGER, 
	@Id_Produto SMALLINT, 
	@Quantidade INTEGER, 
	@ValorUnitario NUMERIC(9, 2), 
	@QuantidadeDias SMALLINT, 
	@DataInicio SMALLDATETIME, 
	@QuantidadeInserida INTEGER = 0 OUTPUT 
) 
AS 
BEGIN 
	DECLARE @QuantidadeDiasControle SMALLINT = 1 
	DECLARE @DataVenda SMALLDATETIME = @DataInicio 
	DECLARE @UltimoId BIGINT = (SELECT MAX(Id) FROM dbo.Vendas) 

	WHILE (@QuantidadeDiasControle <= @QuantidadeDias) 
	BEGIN 
		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, [Valor Unitario], [Data Venda]) 
		VALUES (NEWID(), @Id_Cliente, @Id_Produto, @Quantidade, @ValorUnitario, @DataVenda) 

		SET @DataVenda = DATEADD(d, 1, @DataVenda) 
		SET @QuantidadeDiasControle += 1 
		SET @QuantidadeInserida += 1 
	END 

	SELECT Id, Quantidade, "Valor Unitario", "Data Venda" 
	  FROM dbo.Vendas 
	 WHERE Id > @UltimoId; 

	RETURN
END 
GO 

DECLARE @QuantidadeLinhasInseridas INTEGER = 0; 
DECLARE @DataInicial SMALLDATETIME = CAST('2021-01-01' AS SMALLDATETIME)

EXEC dbo.IncluiVendas @Id_Cliente = 1, @Id_Produto = 1, @Quantidade = 6, @ValorUnitario = 15.9, @QuantidadeDias = 15, @DataInicio = @DataInicial, 
                      @QuantidadeInserida = @QuantidadeLinhasInseridas OUTPUT 

SELECT @QuantidadeLinhasInseridas AS "Quantidade de vendas inclusas" 

/*
Demonstra��o de cria��o de AFTER TRIGGER
*/

CREATE TABLE dbo.LogVendas 
(
	Id BIGINT IDENTITY(1, 1) NOT NULL, 
	Id_Venda BIGINT NOT NULL, 
	Acao VARCHAR(10), 
	CONSTRAINT PK_LogVendas PRIMARY KEY CLUSTERED (Id) 
) 
GO 

CREATE TRIGGER dbo.VendasInclusao 
ON dbo.Vendas 
AFTER INSERT, DELETE 
AS 
	IF @@ROWCOUNT = 0 RETURN; 

	IF ((SELECT COUNT(*) FROM Inserted) > 0) 
	BEGIN 
		INSERT INTO dbo.LogVendas (Id_Venda, Acao) 
		SELECT Id, 'Inclus�o' FROM Inserted 
	END 
	ELSE 
	BEGIN 
		INSERT INTO dbo.LogVendas (Id_Venda, Acao) 
		SELECT Id, 'Exclus�o' FROM Deleted 
	END 
GO 

CREATE TRIGGER dbo.VendasAlteracao
ON dbo.Vendas 
AFTER UPDATE 
AS 
	INSERT INTO dbo.LogVendas (Id_Venda, Acao) 
	SELECT Id, 'Altera��o' FROM Inserted 
GO 

SELECT Id, Id_Venda, Acao 
  FROM dbo.LogVendas 

INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
SELECT NEWID(), 1, 1, 10, 10, CAST('2025-01-01' AS SMALLDATETIME) FROM dbo.Vendas 

UPDATE dbo.Vendas 
   SET Quantidade = 20 
 WHERE [Data Venda] = CAST('2025-01-01' AS SMALLDATETIME) 

DELETE FROM dbo.Vendas 
 WHERE [Data Venda] = CAST('2025-01-01' AS SMALLDATETIME) 

GO 

/*
Demonstra��o de cria��o de INSTEAD OF TRIGGER
*/

CREATE VIEW dbo.VendasProdutoA 
AS 
SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS Cliente, 
       P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE P.Descricao = 'Produto A'; 

GO 

SELECT "C�digo pedido", Cliente, Produto, Quantidade, "Valor Unitario", "Data Venda" 
  FROM dbo.VendasProdutoA 
GO 

CREATE TRIGGER dbo.VendasProdutoATrigger 
ON dbo.VendasProdutoA 
INSTEAD OF INSERT 
AS 
BEGIN 
	SET NOCOUNT ON;

	IF ((SELECT COUNT(*) 
	       FROM Inserted        AS I 
		  INNER JOIN dbo.Vendas AS V ON (I.[C�digo pedido] = V.Pedido)) > 0) 
	BEGIN 
		PRINT 'N�o incluiu nada nas Vendas'; 
	END 
	ELSE 
	BEGIN 
		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, [Valor Unitario], [Data Venda]) 
		SELECT I.[C�digo pedido], 
		       Cliente.Id AS Id_Cliente, 
			   P.Id AS Id_Produto, 
			   I.Quantidade, I.[Valor Unitario], I.[Data Venda] 
		  FROM Inserted                 AS I 
		 INNER JOIN dbo.CadastroCliente AS Cliente ON (I.Cliente = Cliente.Nome) 
		 INNER JOIN dbo.Produto         AS P ON (I.Produto = P.Descricao); 
	END 
END 
GO 

INSERT INTO dbo.VendasProdutoA ("C�digo pedido", Cliente, Produto, Quantidade, "Valor Unitario", "Data Venda") 
VALUES (NEWID(), 'Cliente 1', 'Produto A', 10000, 500, CAST('2030-01-01' AS SMALLDATETIME)) 

SELECT "C�digo pedido", Cliente, Produto, Quantidade, "Valor Unitario", "Data Venda" 
  FROM dbo.VendasProdutoA 
 ORDER BY "Data Venda" DESC 