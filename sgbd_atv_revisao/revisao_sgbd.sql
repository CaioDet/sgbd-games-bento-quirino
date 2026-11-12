-- ========================================================
-- SCRIPT CONSOLIDADO: CAMPEONATO NITRO RACING LEAGUE
-- Refinamento e Validação do Modelo Físico (SQLite)
-- ========================================================

-- 1. Ativa obrigatoriamente o suporte a chaves estrangeiras no SQLite
PRAGMA foreign_keys = ON;

-- 2. Tabela Pai 1: TB_PILOTO (Com restrições NOT NULL, UNIQUE e CHECK)
CREATE TABLE TB_PILOTO (
    id_piloto INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_piloto TEXT NOT NULL UNIQUE,
    categoria_licenca TEXT NOT NULL CHECK (categoria_licenca IN ('Iniciante', 'Profissional', 'Lenda'))
);

-- 3. Tabela Pai 2: TB_VEICULO (Com restrições de obrigatoriedade e CHECK de potência)
CREATE TABLE TB_VEICULO (
    id_veiculo INTEGER PRIMARY KEY AUTOINCREMENT,
    modelo TEXT NOT NULL,
    potencia_cv INTEGER NOT NULL CHECK (potencia_cv > 0)
);

-- 4. Tabela Filho (Associativa): TB_GARAGEM_EQUIPE (Com Foreign Keys e Cascade)
CREATE TABLE TB_GARAGEM_EQUIPE (
    id_garagem INTEGER PRIMARY KEY AUTOINCREMENT,
    id_piloto INTEGER NOT NULL,
    id_veiculo INTEGER NOT NULL,
    FOREIGN KEY (id_piloto) REFERENCES TB_PILOTO(id_piloto) ON DELETE CASCADE,
    FOREIGN KEY (id_veiculo) REFERENCES TB_VEICULO(id_veiculo) ON DELETE CASCADE
);

-- ========================================================
-- 5. INSERÇÃO DE DADOS DE TESTE (Massa válida)
-- ========================================================

-- Inserindo os 3 pilotos obrigatórios do cenário
INSERT INTO TB_PILOTO (nome_piloto, categoria_licenca) VALUES ('Ayrton', 'Lenda');
INSERT INTO TB_PILOTO (nome_piloto, categoria_licenca) VALUES ('Lewis', 'Profissional');
INSERT INTO TB_PILOTO (nome_piloto, categoria_licenca) VALUES ('Max', 'Profissional');

-- Inserindo os 3 veículos obrigatórios do cenário
INSERT INTO TB_VEICULO (modelo, potencia_cv) VALUES ('Apex GT', 650);
INSERT INTO TB_VEICULO (modelo, potencia_cv) VALUES ('Vortex F1', 900);
INSERT INTO TB_VEICULO (modelo, potencia_cv) VALUES ('Thunder Rally', 450);

-- Vinculando os pilotos aos veículos na tabela associativa
INSERT INTO TB_GARAGEM_EQUIPE (id_piloto, id_veiculo) VALUES (1, 2);
INSERT INTO TB_GARAGEM_EQUIPE (id_piloto, id_veiculo) VALUES (2, 1);
INSERT INTO TB_GARAGEM_EQUIPE (id_piloto, id_veiculo) VALUES (3, 3);

-- ========================================================
-- 6. CONSULTAS DE VISUALIZAÇÃO (Garante que apareçam na tela)
-- ========================================================
SELECT * FROM TB_PILOTO;
SELECT * FROM TB_VEICULO;
SELECT * FROM TB_GARAGEM_EQUIPE;