# 🏦 Banco Digital — Configuração do Supabase

## 1. Instalar dependência

No `pubspec.yaml` já está configurado. Rode:
```bash
flutter pub get
```

---

## 2. Criar projeto no Supabase

1. Acesse [supabase.com](https://supabase.com) → crie um projeto
2. Vá em **Project Settings → API** e copie:
   - **Project URL** → cole em `_supabaseUrl` no arquivo `lib/servicos/supabase_servico.dart`
   - **anon public key** → cole em `_supabaseAnonKey` no mesmo arquivo

---

## 3. Criar tabelas no SQL Editor

Acesse **SQL Editor** no painel do Supabase e execute:

```sql
-- Tabela de perfis vinculada ao auth.users
CREATE TABLE public.perfis (
  id        UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  nome      TEXT NOT NULL,
  saldo     NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de transferências
CREATE TABLE public.transferencias (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id   UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  destinatario TEXT NOT NULL,
  valor        NUMERIC(12, 2) NOT NULL,
  data         TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar Row Level Security
ALTER TABLE public.perfis ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transferencias ENABLE ROW LEVEL SECURITY;

-- Políticas: usuário só acessa seus próprios dados
CREATE POLICY "Ver próprio perfil"
  ON public.perfis FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Inserir próprio perfil"
  ON public.perfis FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Atualizar próprio perfil"
  ON public.perfis FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Ver próprias transferências"
  ON public.transferencias FOR SELECT USING (auth.uid() = usuario_id);

CREATE POLICY "Inserir própria transferência"
  ON public.transferencias FOR INSERT WITH CHECK (auth.uid() = usuario_id);
```

---

## 4. Confirmação de e-mail (opcional)

- **Com confirmação** (padrão): usuário recebe e-mail antes de logar  
- **Sem confirmação**: vá em **Authentication → Settings → Email Auth** e desative "Confirm email"

---

## 5. Arquivos alterados/criados

| Arquivo | O que mudou |
|---------|-------------|
| `pubspec.yaml` | Firebase removido → Supabase adicionado |
| `lib/main.dart` | Inicializa Supabase no lugar do Firebase |
| `lib/servicos/supabase_servico.dart` | **Novo** — centralize suas credenciais aqui |
| `lib/telas_banco/login.dart` | Validação real + autenticação Supabase |
| `lib/telas_banco/cadastro.dart` | **Nova tela** — cadastro com criação de perfil |
| `lib/telas_banco/esqueci_senha.dart` | **Nova tela** — recuperação de senha por e-mail |
| `lib/telas_banco/transferencia.dart` | Firestore removido → Supabase |
| `lib/routes.dart` | Rotas `/cadastro` e `/esqueci-senha` adicionadas |

---

## 6. Fluxo completo

```
Login ──→ validação de e-mail + senha
       ──→ erro em PT-BR se inválido
       ──→ busca nome/saldo real do banco
       ──→ navega para Home com dados reais

Cadastro ──→ nome completo, e-mail, senha (×2)
          ──→ cria usuário no Supabase Auth
          ──→ insere linha na tabela perfis
          ──→ dialog pedindo confirmação de e-mail

Esqueci senha ──→ valida e-mail
              ──→ Supabase envia link de redefinição
              ──→ tela de sucesso com instruções
```
