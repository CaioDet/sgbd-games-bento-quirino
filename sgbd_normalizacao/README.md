# COLÉGIO TÉCNICO BENTO QUIRINO
**1ª Série do Ensino Médio — Técnico em Jogos Digitais**  
**Material Didático e Guia Prático:** SGBD, Normalização e Versionamento  
* **Disciplina:** SGBD  
* **Ambiente:** SQLiteOnline  
* **Versão:** 2026/4º Bim.  

---

## MÓDULO 1: FUNDAMENTAÇÃO TEÓRICA APLICADA A JOGOS

### 1. CONCEITO DE SGBD NOS JOGOS DIGITAIS
O Sistema Gerenciador de Banco de Dados (SGBD) atua como a interface segura e estruturada entre os dados persistidos e a aplicação (seja a engine do jogo ou o servidor online). Dependendo do escopo do projeto, o uso do SGBD assume diferentes frentes:

* **Jogos Single-Player (Locais):** Empregam SGBDs leves e embarcados (como o *SQLite*) para gerenciar dados locais diretamente no dispositivo do usuário, incluindo salvamentos de progresso (*save games*), inventários, preferências gráficas e configurações.
* **Jogos Online / Multiplayer (GaaS - Games as a Service):** Utilizam SGBDs robustos em nuvem (como PostgreSQL, MySQL ou sistemas NoSQL como MongoDB e Redis) para processar simultaneamente milhares de requisições de perfis globais, economias virtuais, mercados de itens, tabelas de classificação (*leaderboards*) e telemetria.

### 2. INDEPENDÊNCIA ENTRE MODELOS (ARQUITETURA DE TRÊS NÍVEIS)
A independência de dados protege a estabilidade do software ao isolar alterações estruturais em três camadas distintas:

1. **Nível Físico (Interno):** Como os dados são efetivamente gravados no armazenamento do disco ou SSD (arquivos binários, blocos, índices e tabelas de hash).
2. **Nível Lógico (Concepção):** A representation conceitual das tabelas, colunas, chaves primárias, estrangeiras e relacionamentos (o modelo relacional derivado da normalização).
3. **Nível de Visão (Externo):** A forma como a interface da engine ou as telas de usuário exibem esses dados (menus de status, inventário visual, HUD).

> **Exemplo Prático:** Caso a infraestrutura de servidores precise migrar o mecanismo de armazenamento físico (Nível Físico) para otimizar a velocidade de leitura, o código da engine que requisita os itens do jogador (Nível Lógico) permanece inalterado, evitando falhas em cascata.

### 3. BOAS PRÁTICAS DE MODELAGEM FÍSICA PARA JOGOS
* **Tipos de Dados Otimizados:** Cada byte poupado reduz o consumo de memória RAM e a largura de banda de rede. Evite tipos sobredimensionados (como `BIGINT` para variáveis limitadas, a exemplo de níveis de personagem ou contagem de poções); prefira `TINYINT` ou `SMALLINT`.
* **Indexação Estratégica:** Crie índices nas chaves estrangeiras e em colunas consultadas intensamente durante o gameplay (como identificadores de jogadores em tabelas de transações). Evite o excesso de índices, pois operações de escrita (`INSERT` e `UPDATE`) tornam-se custosas para salvamentos em tempo real.
* **Desnormalização Planejada para Performance:** Embora a normalização evite redundâncias, múltiplos `JOINs` complexos em tempo de execução podem gerar travamentos (*stutters*). Em tabelas de ranqueamento global, recorre-se à duplicação controlada de dados para assegurar respostas instantâneas.
* **Garantia de Transações Seguras (ACID):** Sistemas que envolvem economia interna (leilões, comércio de itens) exigem transações estritas para prevenir a duplicação de itens ou o desaparecimento de moedas virtuais durante quedas de conexão.
* **Uso de Caches em Memória (Ex: Redis):** Dados de alta frequência (como posições em mapas abertos) devem evitar o acesso direto ao disco rígido, sendo mantidos em estruturas de memória RAM acopladas ao SGBD principal.

---

## MÓDULO 2: CENÁRIO PRÁTICO (CONTEXTO RPG E UNIVERSO DOOM)

Para aplicar os conceitos de remoção de redundância e inconsistência, trabalharemos com o registro bruto de uma guilda de aventureiros em estado não normalizado (0FN).

> **Problema Identificado na Tabela Bruta (0FN):** A estrutura armazena listas compostas na mesma célula (atributos multivalorados em `Habilidades` e `Itens_Inventario`) e repete informações estáticas de classes e bônus, gerando alto risco de anomalias de atualização.

---

## MÓDULO 3: GUIA PRÁTICO NO SQLITEONLINE

Utilizaremos o ambiente web SQLiteOnline (https://sqliteonline.com) para estruturar o banco de dados relacional de forma normalizada.

### PASSO 1: INICIALIZAÇÃO DO AMBIENTE
1. Acesse o navegador e entre em **sqliteonline.com**.
2. No menu superior esquerdo, certifique-se de que o mecanismo selecionado na opção **Engine** seja **SQLite**.

### PASSO 2: CARGA INICIAL (TABELA BRUTA - 0FN)
Insira a estrutura não normalizada inicial executando o seguinte script:

```sql
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
```

### PASSO 3: PRIMEIRA FORMA NORMAL (1FN) — ATOMICIDADE
Eliminamos o atributo multivalorado do inventário criando uma tabela separada onde cada linha armazena um único item atômico:

```sql
CREATE TABLE TB_INVENTARIO_1FN (
 ID_Item INTEGER PRIMARY KEY AUTOINCREMENT,
 ID_Jogador INTEGER,
 Nome_Item TEXT,
 FOREIGN KEY (ID_Jogador) REFERENCES TB_JOGADOR_BRUTO(ID_Jogador)
);

INSERT INTO TB_INVENTARIO_1FN (ID_Jogador, Nome_Item) VALUES
(1, 'Espada de Aco'), (1, 'Pocao de Cura'),
(2, 'Cajado de Quartzo'), (2, 'Elixir de Mana');
```

### PASSO 4: SEGUNDA FORMA NORMAL (2FN) — DEPENDÊNCIA FUNCIONAL TOTAL
Isolamos as habilidades em um catálogo e criamos uma tabela associativa (relação N:N) com chave primária composta:

```sql
CREATE TABLE TB_HABILIDADE (
 ID_Habilidade INTEGER PRIMARY KEY AUTOINCREMENT,
 Nome_Habilidade TEXT
);

INSERT INTO TB_HABILIDADE (Nome_Habilidade) VALUES ('Igni'), ('Quen'), ('Bola de Fogo');

CREATE TABLE TB_JOGADOR_HABILIDADE (
 ID_Jogador INTEGER,
 ID_Habilidade INTEGER,
 PRIMARY KEY (ID_Jogador, ID_Habilidade),
 FOREIGN KEY (ID_Jogador) REFERENCES TB_JOGADOR_BRUTO(ID_Jogador),
 FOREIGN KEY (ID_Habilidade) REFERENCES TB_HABILIDADE(ID_Habilidade)
);

INSERT INTO TB_JOGADOR_HABILIDADE VALUES (1, 1), (1, 2), (2, 3);
```

### PASSO 5: TERCEIRA FORMA NORMAL (3FN) — ELIMINAÇÃO DE DEPENDÊNCIA TRANSITIVA
Removemos a dependência transitiva do bônus em relação à classe, criando a tabela de classes definitiva:

```sql
CREATE TABLE TB_CLASSE (
 ID_Classe INTEGER PRIMARY KEY AUTOINCREMENT,
 Nome_Classe TEXT,
 Bonus_Classe TEXT
);

INSERT INTO TB_CLASSE (Nome_Classe, Bonus_Classe) VALUES 
('Bruxo', '+5 Forca'), ('Feiticeira', '+5 Magia');

CREATE TABLE TB_JOGADOR_FINAL (
 ID_Jogador INTEGER PRIMARY KEY,
 Nome TEXT,
 ID_Classe INTEGER,
 FOREIGN KEY (ID_Classe) REFERENCES TB_CLASSE(ID_Classe)
);

INSERT INTO TB_JOGADOR_FINAL VALUES (1, 'Geralt', 1), (2, 'Yennefer', 2);
```

---

## MÓDULO 4: EXPORTAÇÃO E VERSIONAMENTO NO GITHUB

Para concluir a atividade prática, o banco de dados estruturado deve ser exportado e versionado em um repositório público.

### 1. BAIXANDO O BANCO DE DADOS DO SQLITEONLINE
1. No menu superior do SQLiteOnline, clique em **File**.
2. Selecione a opção **Save Database** para baixar o arquivo binário consolidado (ex: `sqlite.db`).
3. Renomeie o arquivo para `banco_rpg_normalizado.db`.

### 2. PUBLICANDO NO GITHUB
1. Acesse sua conta no GitHub (**github.com**).
2. No canto superior direito, clique no ícone **+** e selecione **New repository**.
3. Defina o nome do repositório (ex: `projeto-sgbd-rpg`), selecione a visibilidade como **Public**, marque a opção **Add a README file** e clique em **Create repository**.
4. Na página principal do repositório, clique em **Add file** e selecione **Upload files**.
5. Arraste o arquivo `banco_rpg_normalizado.db` para a área de envio.
6. Insira uma mensagem de commit descritiva no campo inferior e clique no botão verde **Commit changes** para finalizar a entrega oficial da atividade.
