# Chave SSH do GitHub em um Mac novo

Faça esta etapa depois de instalar as Command Line Tools e antes de clonar o
repositório. A configuração declarativa de SSH em
`modules/home/development.nix` usa `~/.ssh/id_ed25519` para `github.com` e o
Keychain do macOS para guardar a senha da chave. O login do GitHub não é o usuário
local do Mac e não aparece no comando SSH: o usuário remoto é sempre `git`.

## 1. Confira se já existe uma chave

```sh
ls -la ~/.ssh
```

Se `id_ed25519` já existir, **não o sobrescreva**. Você pode reutilizar a chave
ou gerar outra com nome diferente, ajustando antes o `IdentityFile` em
`modules/home/development.nix`. Em um Mac realmente novo, gere uma chave
Ed25519 com uma senha forte:

```sh
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ssh-keygen -t ed25519 -C "seu-email-do-github@example.com" -f "$HOME/.ssh/id_ed25519"
```

O comentário `-C` é só um rótulo da chave. Pode ser o e-mail usado na conta do
GitHub; não precisa ser igual ao nome de autor dos commits.

## 2. Guarde a senha no Keychain do macOS

```sh
eval "$(ssh-agent -s)"
/usr/bin/ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
```

O Home Manager instalará a configuração de SSH no primeiro rebuild. Não crie
um `~/.ssh/config` manual para este caso, pois ele ocuparia o caminho gerenciado
pelo Home Manager.

## 3. Cadastre somente a chave pública no GitHub

```sh
pbcopy < "$HOME/.ssh/id_ed25519.pub"
```

No GitHub, abra **Settings → SSH and GPG keys → New SSH key**. Escolha
**Authentication Key**, dê um nome que identifique este Mac e cole o conteúdo
copiado. O arquivo sem `.pub` é a chave **privada**: não o copie para o GitHub,
não o envie a ninguém e não o coloque no repositório.

## 4. Teste o acesso

```sh
ssh -T git@github.com
```

Na primeira conexão, confirme a chave do servidor apenas depois de comparar a
impressão digital mostrada com as
[impressões digitais oficiais do GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints).
A mensagem esperada é `Hi SEU_LOGIN! You've successfully authenticated`.
O comando pode terminar com código 1 mesmo quando a autenticação deu certo,
porque o GitHub não oferece shell remoto.

Agora clone `git@github.com:matheusmazeto/dotfiles.git`, conforme o
[guia de instalação](install-macos.md). Se o repositório for um fork, ajuste
o endereço do clone.

Referências: [geração e Chaves do macOS](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=mac),
[cadastro da chave pública](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=mac) e
[teste de conexão](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection).
