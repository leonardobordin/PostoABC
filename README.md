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

## Cálculo de Impostos

O imposto é calculado no código Delphi (Controller) e não via trigger, permitindo alterações futuras no percentual sem modificar o banco:

```delphi
Imposto = (ValorAbastecimento * PercentualImposto) / 100
ValorTotal = ValorAbastecimento + Imposto
```

## Banco de Dados

### Tabelas Criadas

1. **TANQUES** - Armazena informações dos tanques
2. **BOMBAS** - Armazena informações das bombas
3. **ABASTECIMENTOS** - Registra todos os abastecimentos

Todas com auto-increment via sequences e triggers no Firebird.

## Compilação e Execução

1. Abra o projeto `PostoABC.dproj` no Delphi 12
2. Configure o caminho para o config.ini
3. Compile o projeto: **Build → Build Project**
4. Execute: **Run → Run** ou **F9**

## Observações Importantes

- O arquivo `config.ini` deve estar na mesma pasta que o executável
- A conexão com banco utiliza **Singleton Pattern** para economizar recursos
- As validações de entrada são feitas nos Controllers
- Todos os erros de banco são capturados e exibidos em mensagens amigáveis

## Desenvolvido por

Leonardo Bordin - Sistema de Gerenciamento do Posto ABC - 2025
