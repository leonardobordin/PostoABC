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

## Screenshots da Tela

### Tela Inicial
<img width="998" height="700" alt="PostoABC_QL2dXst4yA" src="https://github.com/user-attachments/assets/25bdc769-0638-44f6-b598-e3b03b90670c" />

### Cadastro de Tanques
<img width="998" height="706" alt="PostoABC_QW8WyjFzGN" src="https://github.com/user-attachments/assets/4b59ab32-20ae-446c-8530-e9c9aada8026" />

### Cadastro de Bombas
<img width="998" height="706" alt="PostoABC_HFmjvigCgZ" src="https://github.com/user-attachments/assets/bf772437-54e0-4042-a7f1-602d9a270d6b" />

### Cadastro de Abastecimentos
<img width="998" height="706" alt="PostoABC_3zw3Jo3bES" src="https://github.com/user-attachments/assets/5e7800ee-6eaa-4602-aae6-dc0a9188cdff" />

### Relatório de Abastecimento
<img width="1920" height="1149" alt="PostoABC_5HvvUP6Gln" src="https://github.com/user-attachments/assets/3827909e-a63a-407a-ad61-a75fbf659db6" />

## Testes Unitários

O projeto possui testes automatizados utilizando o framework **DUnitX** (padrão moderno para Delphi). Esses testes estão organizados na pasta `tests/` e cobrem as principais camadas do sistema.

> **Observação:**  
> Nos arquivos de Controller e Repository, apenas os métodos de inserção foram testados até o momento. A implementação de testes para as demais rotinas ficará pendente para versões futuras.

### Estrutura da pasta de testes

```
tests/
├── Controllers/   # Testes dos controllers (lógica de negócio e validações)
├── Models/        # Testes dos models (estrutura de dados)
├── Repositories/  # Testes dos repositórios (acesso a dados)
├── config.ini     # Configuração dos testes
├── PostoABCTests.dpr   # Projeto principal de testes
└── PostoABCTests.dproj # Arquivo de projeto Delphi dos testes
```

### Como executar os testes

1. **Executando pelo .exe já compilado:**  
   Basta rodar o arquivo `PostoABCTests.exe` que está na pasta `tests/`. Os resultados dos testes serão exibidos no console.

2. **Executando pelo Delphi:**  
   Abra o arquivo `PostoABCTests.dpr` no Delphi, compile e execute. Os resultados dos testes também serão exibidos no console.

3. **Configuração:**  
   Certifique-se de que o banco de dados de teste está criado e o arquivo `config.ini` está corretamente configurado para o ambiente de testes.

## Desenvolvido por

Leonardo Bordin - Sistema de Gerenciamento do Posto ABC - 2025