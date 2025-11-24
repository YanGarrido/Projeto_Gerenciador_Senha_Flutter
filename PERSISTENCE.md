# Sistema de Persistência de Dados

## Visão Geral

O aplicativo utiliza múltiplas camadas de persistência para garantir que os dados sejam salvos de forma segura e eficiente.

## Tecnologias Utilizadas

### 1. Flutter Secure Storage
**Pacote:** `flutter_secure_storage: ^9.0.0`

**Uso:** Armazenamento criptografado de senhas

**Características:**
- Criptografia AES em dispositivos Android
- Keychain em dispositivos iOS
- Armazenamento seguro e persistente
- Dados mantidos mesmo após reinicialização do app

**Implementação:**
```dart
final _storage = const FlutterSecureStorage();
await _storage.write(key: 'password_uuid', value: jsonData);
```

### 2. SharedPreferences
**Pacote:** `shared_preferences: ^2.2.2`

**Uso:** Armazenamento de preferências do usuário e metadados

**Características:**
- Armazenamento key-value local
- Persiste entre sessões do app
- Rápido acesso para configurações
- Não criptografado (apenas para dados não sensíveis)

**Implementação:**
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setInt('sort_preference', sortIndex);
```

## Estrutura de Dados

### Senhas (FlutterSecureStorage)
Cada senha é armazenada com uma chave única no formato:
```
Key: password_<uuid-v4>
Value: JSON {
  "title": "Google",
  "category": "Websites",
  "username": "user@email.com",
  "password": "encrypted_password",
  "website": "https://google.com",
  "notes": "Additional info",
  "createdAt": "2025-11-23T10:30:00.000Z"
}
```

### Metadados (FlutterSecureStorage)
```
Key: passwords_metadata
Value: JSON {
  "total_count": 25,
  "last_updated": "2025-11-23T10:30:00.000Z",
  "categories": {
    "Websites": 10,
    "Banking": 5,
    "Personal": 7,
    "Work": 3
  }
}
```

### Preferências do Usuário (SharedPreferences)
- `last_sync` - Última sincronização
- `auto_backup_enabled` - Backup automático habilitado
- `sort_preference` - Preferência de ordenação (0-3)
- `theme_preference` - Tema preferido
- `password_count_cache` - Cache da contagem de senhas
- `isLoggedIn` - Estado de autenticação
- `userName` - Nome do usuário
- `userEmail` - Email do usuário

## Serviços de Persistência

### PasswordService
**Arquivo:** `lib/shared/services/password_service.dart`

**Funcionalidades:**
- ✅ `getAllPasswords()` - Busca todas as senhas
- ✅ `savePassword(PasswordModel)` - Salva/atualiza senha
- ✅ `deletePassword(String id)` - Remove senha
- ✅ `getPasswordById(String id)` - Busca senha específica
- ✅ `getPasswordsByCategory(String)` - Filtra por categoria
- ✅ `searchPasswords(String)` - Busca por texto
- ✅ `exportPasswords()` - Exporta todas as senhas (JSON)
- ✅ `importPasswords(String)` - Importa senhas de backup
- ✅ `clearAllPasswords()` - Limpa todos os dados
- ✅ `isStorageAvailable()` - Verifica disponibilidade

### StorageService
**Arquivo:** `lib/shared/services/storage_service.dart`

**Funcionalidades:**
- ✅ `getLastSync()` / `updateLastSync()` - Controle de sincronização
- ✅ `isAutoBackupEnabled()` / `setAutoBackup(bool)` - Configuração de backup
- ✅ `getSortPreference()` / `setSortPreference(int)` - Preferência de ordenação
- ✅ `getThemePreference()` / `setThemePreference(String)` - Tema
- ✅ `cachePasswordCount(int)` / `getCachedPasswordCount()` - Cache de contagem
- ✅ `clearAll()` - Limpa todas as preferências

## Fluxo de Persistência

### Salvamento de Nova Senha
```
1. Usuário preenche formulário
2. Validação dos campos
3. Geração de UUID v4 único
4. Criação do PasswordModel
5. Serialização para JSON
6. Escrita no FlutterSecureStorage
7. Atualização dos metadados
8. Cache da contagem atualizado
9. Feedback ao usuário
```

### Carregamento de Dados
```
1. App inicia → main.dart
2. Verifica disponibilidade do storage
3. Carrega preferências (sort, tema)
4. Tela carrega → initState()
5. Chama _loadPasswords()
6. Lê todas as chaves do storage
7. Deserializa JSON para PasswordModel
8. Ordena por data de criação
9. Aplica filtros/ordenação salva
10. Atualiza UI
```

### Exclusão de Senha
```
1. Usuário confirma exclusão
2. Chama deletePassword(id)
3. Remove do FlutterSecureStorage
4. Atualiza metadados
5. Atualiza cache de contagem
6. Recarrega lista na UI
```

## Backup e Recuperação

### Exportação
```dart
final jsonBackup = await passwordService.exportPasswords();
// Retorna JSON com todas as senhas
// Pode ser salvo em arquivo ou enviado para cloud
```

**Formato do Backup:**
```json
{
  "version": "1.0",
  "exported_at": "2025-11-23T10:30:00.000Z",
  "passwords": [
    {
      "id": "password_uuid-here",
      "title": "Google",
      "category": "Websites",
      ...
    }
  ]
}
```

### Importação
```dart
final importedCount = await passwordService.importPasswords(
  jsonBackup, 
  overwrite: false // Se true, sobrescreve duplicatas
);
// Retorna quantidade de senhas importadas
```

## Garantias de Persistência

### ✅ Dados Persistem:
- Entre sessões do app
- Após reinicialização do dispositivo
- Durante atualizações do app
- Mesmo se o app crashar

### ✅ Segurança:
- Senhas criptografadas em repouso
- Não exportadas em backups do sistema (Android)
- Proteção por Keychain (iOS)
- IDs únicos previnem conflitos

### ✅ Performance:
- Leitura assíncrona não bloqueia UI
- Cache de contagem para acesso rápido
- Metadados para estatísticas sem processar tudo
- Lazy loading de senhas quando necessário

## Testes de Persistência

Para testar a persistência:

1. **Teste Básico:**
```bash
# Adicione algumas senhas
# Feche o app completamente
# Reabra o app
# Verifique se as senhas aparecem
```

2. **Teste de Reinicialização:**
```bash
# Adicione senhas
# Reinicie o dispositivo
# Abra o app
# Verifique persistência
```

3. **Teste de Backup:**
```bash
# Adicione senhas
# Exporte com exportPasswords()
# Limpe dados com clearAllPasswords()
# Importe com importPasswords()
# Verifique se tudo voltou
```

## Solução de Problemas

### Storage não disponível
```dart
if (!await passwordService.isStorageAvailable()) {
  // Mostrar erro ao usuário
  // Possíveis causas:
  // - Permissões negadas
  // - Storage corrompido
  // - Problema no dispositivo
}
```

### Dados não persistem
1. Verificar se `WidgetsFlutterBinding.ensureInitialized()` está no main
2. Verificar permissões do app
3. Testar `isStorageAvailable()`
4. Verificar logs de erro

### Performance lenta
1. Verificar quantidade de senhas (>1000 pode ser lento)
2. Usar cache quando possível
3. Implementar paginação se necessário

## Melhorias Futuras

### Possíveis Adições:
- [ ] Sincronização com cloud (Firebase/Supabase)
- [ ] Backup automático agendado
- [ ] Compressão de dados para backups grandes
- [ ] Versionamento de senhas (histórico)
- [ ] Exportação criptografada com senha mestre
- [ ] Importação de outros gerenciadores (1Password, LastPass)

## Conclusão

O sistema de persistência é robusto e seguro, usando as melhores práticas do Flutter para garantir que os dados do usuário estejam sempre protegidos e disponíveis.
