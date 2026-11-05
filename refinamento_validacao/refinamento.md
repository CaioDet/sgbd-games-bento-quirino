# 🎮 Prática de Banco de Dados: Refinamento e Validação do Modelo Físico para Games

Bem-vindos à atividade prática de refinamento e validação de modelos físicos! Nesta aula, vamos aplicar restrições avançadas (*constraints*) em um banco de dados relacional voltado para o universo de jogos digitais, garantindo a integridade dos dados e a prevenção de erros comuns de lógica (como inventários negativos ou pontuações inválidas).

---

## 📚 1. Introdução Rápida: O que é Refinamento e Validação?
Quando criamos as tabelas de um jogo (como sistemas de personagens, lojas, itens ou missões), não basta apenas definir os nomes das colunas. Precisamos **validar** o banco de dados utilizando ferramentas nativas do SGBD para que o próprio banco impeça bugs.

Principais restrições que vamos utilizar:
* **`NOT NULL`**: Garante que o campo é obrigatório (ex: um personagem não pode ter nome vazio).
* **`CHECK`**: Cria regras de validação matemática/lógica (ex: `CHECK (vida >= 0)` para o jogador não ficar com vida negativa).
* **`DEFAULT`**: Atribui um valor padrão automático caso nada seja informado (ex: iniciar com `moedas INTEGER DEFAULT 100`).
* **`FOREIGN KEY`**: Garante a integridade referencial entre as tabelas (ex: um item do inventário precisa estar vinculado a um personagem válido).

---

## 🔍 2. Script de Demonstração (Passo a Passo Explicado)

Abaixo está um exemplo prático de como estruturar duas tabelas relacionadas (`TB_PERSONAGEM` e `TB_MISSAO`) utilizando boas práticas de modelagem física para games.

```sql
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
