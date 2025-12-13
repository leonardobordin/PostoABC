# Posto ABC - Sistema de Gerenciamento de Combustíveis

## Descrição do Projeto

Sistema desenvolvido em **Delphi 12** com banco de dados **Firebird 2.5.9** para gerenciar abastecimentos e tanques de combustíveis do Posto ABC.

## Arquitetura do Projeto

O projeto segue o padrão **MVC (Model-View-Controller)** com **Repository**:

```
PostoABC/
├── src/
│   ├── Models/           # Modelos de dados (TanqueModel, BombaModel, AbastecimentoModel)
│   ├── Controllers/      # Controladores (TanqueController, BombaController, AbastecimentoController)
│   ├── Views/            # Forms (MainForm, TanqueForm, BombaForm, AbastecimentoForm)
│   ├── Repositories/     # Camada de acesso a dados (TanqueRepository, BombaRepository, AbastecimentoRepository)
│   └── Database/         # Conexão com banco de dados (DatabaseConnection - Singleton)
├── sql/                  # Script de criação de banco
│   └── criar_base.sql
├── config.ini            # Arquivo de configuração
├── PostoABC.dpr          # Arquivo principal do projeto
└── PostoABC.dproj        # Arquivo de projeto Delphi
```

## Requisitos

- **Delphi 12** (Community ou superior)
- **Firebird 2.5.9**
- FireDAC components (já inclusos no Delphi)

## Configuração Inicial

### 1. Criar o banco de dados

```sql
-- Execute o script criar_base.sql no seu servidor Firebird
isql.exe -u sysdba -p masterkey -i sql/criar_base.sql
```
Ou execute "ExecSQL_DatabaseTest.bat" caso possua o Firebird 2.5 

### 2. Configurar arquivo config.ini

Edite o arquivo `config.ini` na raiz do projeto com as credenciais corretas:

```ini
[Banco]
Usuario=SYSDBA
Senha=masterkey
Caminho=C:\ProjetoPostoABC\PostoABC.fdb

[Imposto]
Percentual=13
```

## Funcionalidades Implementadas

### 1. Cadastro de Tanques
- Criar novos tanques (Gasolina, Diesel, etc.)
- Atualizar informações de tanques
- Deletar tanques
- Consultar nível atual de combustível

### 2. Cadastro de Bombas
- Associar bombas aos tanques
- Gerenciamento da bomba
- Controlar status (ATIVA/INATIVA)

### 3. Registro de Abastecimentos
- Registrar abastecimentos com:
  - Identificação da bomba utilizada
  - Quantidade de litros
  - Valor unitário
  - Cálculo automático de impostos (13%)
  - Valor total
- Histórico de abastecimentos

### 4. Relatórios
- Relatório agrupado de abastecimentos por período
- Exibição de:
  - Data do abastecimento
  - Tanque utilizado
  - Bomba utilizada
  - Valores detalhados
  - Soma total do período

## Padrões de Desenvolvimento

### Models
Os models contêm apenas a estrutura de dados com getters e setters:

```delphi
TTanque = class
private
  FId: Integer;
  FNome: string;
  // ... outras propriedades
public
  property Id: Integer read GetId write SetId;
  property Nome: string read GetNome write SetNome;
  // ... outras propriedades
end;
```

### Repositories
Responsáveis pela interação direta com o banco de dados:

```delphi
TRepository.Inserir(AModel);
TRepository.Atualizar(AModel);
TRepository.Deletar(AId);
TRepository.ObterPorId(AId);
TRepository.ObterTodos;
```

### Controllers
Implementam validações e lógica de negócio:

```delphi
TController.Inserir(...);
TController.CalcularImposto(...);
// ... métodos de validação e processamento
```

### Views
Forms que interagem com usuário através dos Controllers.

## Banco de Dados

### Tabelas Criadas

1. **TANQUES** - Armazena informações dos tanques
2. **BOMBAS** - Armazena informações das bombas
3. **ABASTECIMENTOS** - Registra todos os abastecimentos

Todas com auto-increment via sequences e triggers no Firebird.

## Observações Importantes

- O arquivo `config.ini` deve estar na mesma pasta que o executável
- Dependendo da instalação do Firebird deverá ser colocado a DLL fbclient.dll junto com o executável do sistema
- A conexão com banco utiliza **Singleton Pattern** para economizar recursos
- As validações de entrada são feitas nos Controllers
- Todos os erros de banco são capturados e exibidos em mensagens amigáveis

## Desenvolvido por

Leonardo Bordin - Sistema de Gerenciamento do Posto ABC - 2025

### Screenshots da Tela

## Tela Inicial
<img width="816" height="555" alt="PostoABC_xjrhWACBaM" src="https://github.com/user-attachments/assets/9caabf78-4ff4-42c2-9eec-abd43522188f" />

## Cadastro de Tanques
<img width="816" height="635" alt="PostoABC_1KL43XBzX5" src="https://github.com/user-attachments/assets/070b9eb2-6dcd-4be1-bace-1676fc9f2a24" />

## Cadastro de Bombas
<img width="816" height="635" alt="PostoABC_2WWZ8Hs8Zy" src="https://github.com/user-attachments/assets/0045be6b-5ebf-4bdb-8f42-ca2111f52c19" />

## Cadastro de Abastecimentos
<img width="1016" height="735" alt="PostoABC_6PEskCQkyH" src="https://github.com/user-attachments/assets/aaf79a29-6c85-4fdf-ae2e-463e325f3a39" />

## Relatório de Abastecimento
<img width="1928" height="1040" alt="PostoABC_9aoKZs4bOK" src="https://github.com/user-attachments/assets/891d9410-73a2-4a06-a9aa-8d6619d208fb" />
