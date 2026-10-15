-- ====================================================================
-- PASSO 1: CARGA INICIAL (TABELA BRUTA - 0FN)
-- ====================================================================
CREATE TABLE TB_JOGADOR_BRUTO (
    ID_Jogador INTEGER PRIMARY KEY,
    Nome TEXT,
    Classe TEXT,
    Bonus_Classe TEXT,
    Habilidades TEXT,
    Itens_Inventario TEXT
);

INSERT INTO TB_JOGADOR_BRUTO VALUES
(1, 'Geralt', 'Bruxo', '+5 Forca', 'Igni, Quen', 'Espada de Aco, Pocao de Cura'),
(2, 'Yennefer', 'Feiticeira', '+5 Magia', 'Bola de Fogo', 'Cajado de Quartzo, Elixir de Mana');

-- ====================================================================
-- PASSO 2: PRIMEIRA FORMA NORMAL (1FN) — ATOMICIDADE
-- ====================================================================
CREATE TABLE TB_INVENTARIO_1FN (
    ID_Item INTEGER PRIMARY KEY AUTOINCREMENT,
    ID_Jogador INTEGER,
    Nome_Item TEXT,
    FOREIGN KEY (ID_Jogador) REFERENCES TB_JOGADOR_BRUTO(ID_Jogador)
);

INSERT INTO TB_INVENTARIO_1FN (ID_Jogador, Nome_Item) VALUES
(1, 'Espada de Aco'), 
(1, 'Pocao de Cura'),
(2, 'Cajado de Quartzo'), 
(2, 'Elixir de Mana');

-- ====================================================================
-- PASSO 3: SEGUNDA FORMA NORMAL (2FN) — DEPENDÊNCIA FUNCIONAL TOTAL
-- ====================================================================
CREATE TABLE TB_HABILIDADE (
    ID_Habilidade INTEGER PRIMARY KEY AUTOINCREMENT,
    Nome_Habilidade TEXT
);

INSERT INTO TB_HABILIDADE (Nome_Habilidade) VALUES 
('Igni'), 
('Quen'), 
('Bola de Fogo');

CREATE TABLE TB_JOGADOR_HABILIDADE (
    ID_Jogador INTEGER,
    ID_Habilidade INTEGER,
    PRIMARY KEY (ID_Jogador, ID_Habilidade),
    FOREIGN KEY (ID_Jogador) REFERENCES TB_JOGADOR_BRUTO(ID_Jogador),
    FOREIGN KEY (ID_Habilidade) REFERENCES TB_HABILIDADE(ID_Habilidade)
);

INSERT INTO TB_JOGADOR_HABILIDADE VALUES 
(1, 1), 
(1, 2), 
(2, 3);

-- ====================================================================
-- PASSO 4: TERCEIRA FORMA NORMAL (3FN) — ELIMINAÇÃO DE DEPENDÊNCIA TRANSITIVA
-- ====================================================================
CREATE TABLE TB_CLASSE (
    ID_Classe INTEGER PRIMARY KEY AUTOINCREMENT,
    Nome_Classe TEXT,
    Bonus_Classe TEXT
);

INSERT INTO TB_CLASSE (Nome_Classe, Bonus_Classe) VALUES 
('Bruxo', '+5 Forca'), 
('Feiticeira', '+5 Magia');

CREATE TABLE TB_JOGADOR_FINAL (
    ID_Jogador INTEGER PRIMARY KEY,
    Nome TEXT,
    ID_Classe INTEGER,
    FOREIGN KEY (ID_Classe) REFERENCES TB_CLASSE(ID_Classe)
);

INSERT INTO TB_JOGADOR_FINAL VALUES 
(1, 'Geralt', 1), 
(2, 'Yennefer', 2);
