# 🔐 PassMan - Password Manager

Gerenciador de senhas seguro desenvolvido em Flutter.

## 📁 Arquitetura do Projeto

```
lib/
├── core/                          # Núcleo da aplicação
│   ├── constants/                 # Constantes globais
│   │   ├── app_colors.dart       # Paleta de cores
│   │   └── app_routes.dart       # Rotas nomeadas
│   └── theme/                     # Temas da aplicação
│       └── app_theme.dart         # Tema principal
│
├── features/                      # Funcionalidades agrupadas
│   ├── home/                      # Tela inicial
│   │   ├── controllers/
│   │   │   └── home_controller.dart
│   │   └── widgets/
│   │       ├── categories.dart
│   │       ├── categories_button.dart
│   │       ├── password_view.dart
│   │       └── search_bar_widget.dart
│   │
│   ├── password/                  # Gestão de senhas
│   │   ├── form/
│   │   │   ├── form_password_page.dart
│   │   │   └── widget/
│   │   │       └── password_form.dart
│   │   └── screens/
│   │       ├── passwords_screen.dart
│   │       └── category_screen.dart
│   │
│   └── profile/                   # Perfil do usuário
│       └── screens/
│           ├── profile_screen.dart
│           ├── profile_empty_screen.dart
│           ├── login_screen.dart
│           └── profile_register_screen.dart
│
├── shared/                        # Recursos compartilhados
│   ├── models/                    # Modelos de dados
│   │   └── password_model.dart
│   ├── services/                  # Serviços
│   │   └── password_service.dart
│   └── widgets/                   # Widgets reutilizáveis
│       ├── bottom_nav.dart
│       └── top_bar.dart
│
└── main.dart                      # Ponto de entrada

```

## 🏗️ Princípios Arquiteturais

### 1. **Separação de Responsabilidades**
- **Core**: Configurações e constantes globais
- **Features**: Funcionalidades isoladas e independentes
- **Shared**: Recursos reutilizáveis entre features

### 2. **Organização por Feature**
Cada funcionalidade principal tem sua própria pasta com:
- Controllers (lógica de negócio)
- Screens (telas)
- Widgets (componentes específicos)

### 3. **Centralização de Recursos**
- **Cores**: `core/constants/app_colors.dart`
- **Rotas**: `core/constants/app_routes.dart`
- **Tema**: `core/theme/app_theme.dart`

### 4. **Shared Resources**
Componentes e serviços usados por múltiplas features ficam em `shared/`:
- Models (modelos de dados)
- Services (lógica de negócio compartilhada)
- Widgets (componentes reutilizáveis)

## 🚀 Tecnologias

- **Flutter SDK**: Framework de desenvolvimento
- **flutter_secure_storage**: Armazenamento criptografado
- **shared_preferences**: Persistência de configurações
- **uuid**: Geração de IDs únicos

## 📱 Funcionalidades

- ✅ Armazenamento seguro de senhas
- ✅ Categorização (Websites, Banking, Personal, Work)
- ✅ Geração de senhas fortes
- ✅ Busca e filtros
- ✅ Detecção de senhas fracas
- ✅ Autenticação de usuário
- ✅ Estatísticas de segurança

## 🎨 Padrões de Design

### Cores
Definidas em `core/constants/app_colors.dart`:
- Primary: `#364973` (Dark Blue)
- Categories: Green, Purple, Orange
- Backgrounds: `#F9FAFB` (Light Grey)

### Rotas
Centralizadas em `core/constants/app_routes.dart`:
```dart
AppRoutes.bottomNav
AppRoutes.login
AppRoutes.passwords
// etc...
```

### Tema
Configurado em `core/theme/app_theme.dart` com:
- Material 3
- Cores padronizadas
- Estilos de componentes

## 📝 Boas Práticas Implementadas

1. ✅ **Const Constructors**: Performance otimizada
2. ✅ **Mounted Checks**: Prevenção de uso indevido de BuildContext
3. ✅ **Error Handling**: Tratamento adequado de exceções
4. ✅ **Code Organization**: Arquitetura limpa e escalável
5. ✅ **Type Safety**: Forte tipagem em todo o código
6. ✅ **Immutability**: Uso de final e const quando possível

## 🔄 Fluxo de Navegação

```
BottomNav (Tab Bar)
├── Home
│   ├── Categories → CategoryScreen
│   └── View All → PasswordsScreen
├── Passwords
│   └── Add Password → FormPasswordPage
└── Profile
    ├── Login → LoginScreen
    └── Register → ProfileRegisterScreen
```

## 🛠️ Como Executar

```bash
# Instalar dependências
flutter pub get

# Executar em modo debug
flutter run

# Executar em modo release
flutter run --release
```

## 📦 Dependências

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2
  uuid: ^4.5.2
```
