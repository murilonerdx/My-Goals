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
Demonstra��o da exibi��o de todas as colunas de uma tabela - forma n�o recomend�vel
*/

SELECT * 
  FROM dbo.Vendas 

/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - forma recomend�vel (com a indica��o das colunas) com a utiliza��o de aspas duplas para as colunas de nomes compostos
*/

SELECT Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda", Observacao 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - forma recomend�vel (com a indica��o das colunas) com a utiliza��o de colchetes para as colunas de nomes compostos
*/

SELECT Id, Pedido, Id_Cliente, Id_Produto, Quantidade, [Valor Unitario], [Data Venda], Observacao 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - Coluna seguido diretamente de ALIAS
*/

SELECT Id Codigo, Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - Coluna seguido diretamente de ALIAS entre aspas duplas
*/

SELECT Id AS "Codigo", Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - Coluna seguido diretamente de ALIAS entre colchetes
*/

SELECT Id AS [Codigo], Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - Coluna seguido diretamente de ALIAS composto entre aspas duplas
*/

SELECT Pedido "Codigo da venda", Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - Coluna seguido diretamente de ALIAS composto entre colchetes
*/

SELECT Pedido [Codigo da venda], Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - Coluna AS ALIAS composto entre aspas duplas
*/

SELECT Pedido AS "Codigo da venda", Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - Coluna AS ALIAS composto entre colchetes
*/

SELECT Pedido AS [Codigo da venda], Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - ALIAS composto entre aspas duplas = Coluna
*/

SELECT "Codigo da venda" = Pedido, Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
  
/*
Demonstra��o da exibi��o de todas as colunas de uma tabela - ALIAS composto entre conchetes = Coluna
*/

SELECT [Codigo da venda] = Pedido, Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 

/*
Demonstra��o de uso do DISTINCT para remover linhas com colunas repetidas
*/

SELECT YEAR("Data Venda") AS "Anos de vendas" 
  FROM dbo.Vendas 
 ORDER BY YEAR("Data Venda") 

SELECT DISTINCT YEAR("Data Venda") AS "Anos de vendas" 
  FROM dbo.Vendas 
 ORDER BY YEAR("Data Venda") 

/*
Demonstra��o de algumas fun��es para uso na cl�usula SELECT
*/

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V.Quantidade, V."Valor Unitario", 
	   CAST((V.Quantidade * V."Valor Unitario") AS NUMERIC(9, 2)) AS "Valor total", 
	   V.Observacao, 
	   (Cliente.Nome + ' - ' + P.Descricao) AS "Cliente - Produto", 
	   CONCAT(Cliente.Nome, ' - ', P.Descricao) AS "Cliente - Produto CONCAT", 
	   ISNULL(V.Observacao, '') AS "Observa��o ISNULL", 
	   COALESCE(V.Observacao, '') AS "Observa��o COALESCE" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 

SELECT V.Pedido AS "C�digo pedido", 
       SUBSTRING(Cliente.Nome, 1, 3) AS "Cliente", 
	   SUBSTRING(P.Descricao, 4, 3) AS "Produto", 
	   V.Quantidade, V."Valor Unitario", 
	   CAST((V.Quantidade * V."Valor Unitario") AS NUMERIC(9, 2)) AS "Valor total", 
	   GETDATE() AS "GETDATE", CURRENT_TIMESTAMP AS "CURRENT_TIMESTAMP", 
	   DATEADD(d, 1, CURRENT_TIMESTAMP) AS "Dia posterior", 
	   DATEADD(m, 1, CURRENT_TIMESTAMP) AS "M�s posterior" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 

SELECT V.Pedido AS "C�digo pedido", 
       LEFT(Cliente.Nome, 2) AS "Cliente", 
	   RIGHT(P.Descricao, 3) AS "Produto", 
	   LEN(Cliente.Nome) AS "LEN", 
	   REPLACE(P.Descricao, 'A', 'D') AS "REPLACE", 
	   UPPER(Cliente.Nome) AS "UPPER", 
	   LOWER(P.Descricao) AS "LOWER" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V.Quantidade, 
	   CASE V.Quantidade 
	        WHEN 10 THEN 'Dez' 
			ELSE 'Vinte' END AS "CASE 1", 
	   CASE WHEN V.Quantidade < 50 THEN 'Menor que 50' 
	        ELSE 'Maior ou igual a 50' END AS "CASE 2", 
	   CASE WHEN V.Quantidade < 30 THEN 'Menor que 30' 
	        WHEN V.Quantidade >= 30 AND V.Quantidade < 70 THEN 'Maior ou igual a 30 e menor que 70' 
	        ELSE 'Maior ou igual a 70' END AS "CASE 3" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 

/*
Demonstra��o de algumas formas de ordena��o das linhas pelas colunas indicadas
*/

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY V."Data Venda" 

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY V."Data Venda" DESC 

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY "Cliente", V."Data Venda" DESC 

/*
Demonstra��o de ordena��o pelo n�mero da coluna - considerado uma m� pr�tica e deve ser evitada
*/

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY 2, 4 DESC

/*
Demonstra��o de ordena��o por uma coluna que n�o est� sendo exibida na cl�usula SELECT
*/

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY P.Id, Cliente.Id, V."Data Venda" DESC 

/*
Demonstra��o do uso de TOP para filtrar as linhas retornadas
*/

SELECT TOP 10 V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 

SELECT TOP (10) V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY P.Id, Cliente.Id, V."Data Venda" DESC 

DECLARE @BLOCOTOP SMALLINT = 10 

SELECT TOP (@BLOCOTOP) V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY P.Id, Cliente.Id, V."Data Venda" DESC 

/*
Demonstra��o do uso de TOP com a op��o WITH TIES para trazer linhas cujo valor est� "amarrado" ao mesmo valor de linhas anteriores
*/

SELECT TOP (2) WITH TIES V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY V."Data Venda" 

SELECT COUNT(*) AS "Quantidade total em 2000" 
  FROM dbo.Vendas 
 WHERE "Data Venda" = CAST('2000-01-01' AS SMALLDATETIME) 

/*
Demonstra��o do uso de OFFSET FETCH para trazer "lote" de linhas
*/

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY "C�digo pedido", V."Data Venda" 
OFFSET 0 ROWS FETCH FIRST 25 ROWS ONLY 

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY "C�digo pedido", V."Data Venda" 
OFFSET 50 ROWS FETCH NEXT 10 ROWS ONLY 

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY (SELECT NULL) 
OFFSET 0 ROWS FETCH FIRST 25 ROWS ONLY 

/*
Demonstra��o do uso de OFFSET FETCH para fazer "pagina��o"
*/

DECLARE @BLOCO_PAGINA SMALLINT = 50 
DECLARE @PAGINA SMALLINT = 1

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY "C�digo pedido", V."Data Venda" 
OFFSET (@PAGINA - 1) * @BLOCO_PAGINA ROWS FETCH NEXT @BLOCO_PAGINA ROWS ONLY 

SET @PAGINA = 2

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY "C�digo pedido", V."Data Venda" 
OFFSET (@PAGINA - 1) * @BLOCO_PAGINA ROWS FETCH NEXT @BLOCO_PAGINA ROWS ONLY 

SET @PAGINA = 3

SELECT V.Pedido AS "C�digo pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
	   V."Data Venda"
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 ORDER BY "C�digo pedido", V."Data Venda" 
OFFSET (@PAGINA - 1) * @BLOCO_PAGINA ROWS FETCH NEXT @BLOCO_PAGINA ROWS ONLY 
