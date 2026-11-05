-- Ativa o suporte a chaves estrangeiras no SQLite
PRAGMA foreign_keys = ON;

-- 1. Tabela Pai: Personagens do Jogo
CREATE TABLE TB_PERSONAGEM (
    ID_Personagem INTEGER PRIMARY KEY AUTOINCREMENT,
    Nome TEXT NOT NULL UNIQUE,
    Classe TEXT CHECK (Classe IN ('Guerreiro', 'Mago', 'Arqueiro', 'Ladino')),
    Nivel INTEGER DEFAULT 1 CHECK (Nivel > 0),
    Xp_Atual INTEGER DEFAULT 0 CHECK (Xp_Atual >= 0)
);

-- 2. Tabela Filho: Missões do Personagem (Relacionamento 1 para N)
CREATE TABLE TB_MISSAO (
    ID_Missao INTEGER PRIMARY KEY AUTOINCREMENT,
    Titulo_Missao TEXT NOT NULL,
    Recompensa_Gold INTEGER DEFAULT 50 CHECK (Recompensa_Gold >= 0),
    Status_Missao TEXT DEFAULT 'Pendente' CHECK (Status_Missao IN ('Pendente', 'Em Andamento', 'Concluida')),
    ID_Personagem INTEGER NOT NULL,
    FOREIGN KEY (ID_Personagem) REFERENCES TB_PERSONAGEM(ID_Personagem) ON DELETE CASCADE
);

-- 3. INSERINDO DADOS DE EXEMPLO (Popula as tabelas criadas)
INSERT INTO TB_PERSONAGEM (Nome, Classe, Nivel, Xp_Atual) 
VALUES ('Arthas', 'Guerreiro', 5, 1200);

INSERT INTO TB_PERSONAGEM (Nome, Classe, Nivel, Xp_Atual) 
VALUES ('Jaina', 'Mago', 4, 950);

INSERT INTO TB_MISSAO (Titulo_Missao, Recompensa_Gold, Status_Missao, ID_Personagem) 
VALUES ('Derrotar o Dragão', 500, 'Pendente', 1);

INSERT INTO TB_MISSAO (Titulo_Missao, Recompensa_Gold, Status_Missao, ID_Personagem) 
VALUES ('Recuperar o Tomo Perdido', 200, 'Concluida', 2);

-- 4. SELECTS DE VISUALIZAÇÃO (Faz os atributos e colunas aparecerem na tela do SQLite Online)
SELECT * FROM TB_PERSONAGEM;
SELECT * FROM TB_MISSAO;