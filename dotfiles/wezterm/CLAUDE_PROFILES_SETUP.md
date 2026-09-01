# Configurazione Profili Claude per WezTerm

Questa guida spiega come utilizzare due account Claude separati in WezTerm.

## Setup Iniziale

### 1. Crea le Directory per i Due Account

```bash
# Account personale
mkdir -p ~/.claude-personal

# Account di lavoro
mkdir -p ~/.claude-work
```

### 2. Copia la Configurazione Attuale (Opzionale)

Se hai già un account Claude configurato in `~/.claude/`:

```bash
# Copia la configurazione esistente nel profilo personale
cp -r ~/.claude/* ~/.claude-personal/

# Oppure nel profilo di lavoro
cp -r ~/.claude/* ~/.claude-work/
```

### 3. Autenticazione per Ogni Account

**Account Personale:**
```bash
# Avvia una shell con il profilo personale
export CLAUDE_CONFIG_HOME=~/.claude-personal
claude auth login
```

**Account di Lavoro:**
```bash
# Avvia una shell con il profilo di lavoro
export CLAUDE_CONFIG_HOME=~/.claude-work
claude auth login
```

Nota: Se `CLAUDE_CONFIG_HOME` non è supportato da Claude CLI, usa questo workaround:
```bash
# Crea script wrapper
cat > ~/bin/claude-personal << 'EOF'
#!/bin/bash
HOME_BACKUP=$HOME
export HOME=~/.claude-personal-home
mkdir -p $HOME/.claude
claude "$@"
export HOME=$HOME_BACKUP
EOF

chmod +x ~/bin/claude-personal
```

## Utilizzo dei Profili

### Metodo 1: Keybinding (Raccomandato)

1. Premi `SHIFT + Space` (LEADER)
2. Premi `p` per aprire il menu profili
3. Seleziona:
   - **Claude Account 1 (Personal)** - per l'account personale
   - **Claude Account 2 (Work)** - per l'account di lavoro
   - **Default Shell** - per shell normale senza override

### Metodo 2: Menu di Avvio

1. Premi `CMD + SHIFT + L` (default WezTerm)
2. Seleziona il profilo desiderato

### Metodo 3: Manualmente

Apri un nuovo tab e esegui:

```bash
# Account personale
export CLAUDE_CONFIG_HOME=~/.claude-personal
claude

# Account di lavoro
export CLAUDE_CONFIG_HOME=~/.claude-work
claude
```

## Personalizzazione

### Cambiare i Nomi dei Profili

Modifica il file `/Users/mcha/.config/wezterm/config/profiles.lua`:

```lua
config.launch_menu = {
    {
        label = "Il Mio Nome Personalizzato",
        args = { "zsh", "-l", "-c", "export CLAUDE_CONFIG_HOME=~/.mia-directory && exec zsh" },
    },
}
```

### Impostare un Profilo di Default

Nel file `profiles.lua`, decomenta e modifica:

```lua
config.default_prog = { "zsh", "-l", "-c", "export CLAUDE_CONFIG_HOME=~/.claude-personal && exec zsh" }
```

### Aggiungere Altri Profili

Aggiungi nuove voci a `config.launch_menu`:

```lua
{
    label = "Claude Account 3 (Freelance)",
    args = { "zsh", "-l", "-c", "export CLAUDE_CONFIG_HOME=~/.claude-freelance && exec zsh" },
},
```

## Verifica della Configurazione

Per verificare quale account stai usando:

```bash
echo $CLAUDE_CONFIG_HOME
ls -la $CLAUDE_CONFIG_HOME
claude --version
```

## Troubleshooting

### Il profilo non si carica

1. Verifica che la directory esista:
   ```bash
   ls -la ~/.claude-personal
   ```

2. Controlla i permessi:
   ```bash
   chmod 755 ~/.claude-personal
   ```

3. Ricarica WezTerm: `CMD + R`

### Claude non riconosce CLAUDE_CONFIG_HOME

Se Claude CLI non supporta `CLAUDE_CONFIG_HOME`, usa invece symlink:

```bash
# Script per switchare account
switch-to-personal() {
    rm -rf ~/.claude
    ln -s ~/.claude-personal ~/.claude
}

switch-to-work() {
    rm -rf ~/.claude
    ln -s ~/.claude-work ~/.claude
}
```

### Le configurazioni si mescolano

Assicurati che ogni sessione WezTerm usi la variabile d'ambiente corretta:

```bash
# Aggiungi al ~/.zshrc
if [ -n "$CLAUDE_CONFIG_HOME" ]; then
    echo "✓ Using Claude config: $CLAUDE_CONFIG_HOME"
fi
```

## Struttura Directory

```
~/.claude-personal/
├── settings.json       # Configurazioni personali
├── rules/              # Regole custom personali
└── [auth files]        # Token autenticazione personale

~/.claude-work/
├── settings.json       # Configurazioni lavoro
├── rules/              # Regole custom lavoro
└── [auth files]        # Token autenticazione lavoro
```

## Prossimi Passi

1. ✓ Crea le directory per i due account
2. ✓ Autentica entrambi gli account
3. ✓ Testa il profilo switcher con `LEADER + p`
4. Personalizza `settings.json` per ogni account
5. Crea regole custom separate in `rules/` per ogni account

## Note Importanti

- Ogni profilo mantiene autenticazione, impostazioni e cronologia separate
- Le regole globali in `~/.claude/rules/` NON vengono condivise automaticamente
- Ricarica WezTerm (`CMD + R`) dopo aver modificato la configurazione
