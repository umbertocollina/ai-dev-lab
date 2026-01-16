# Contributing to AI Development Lab 🤝

Grazie per il tuo interesse a contribuire! Questo documento fornisce linee guida per contribuire al progetto.

## 🎯 Come Contribuire

### Tipi di Contributi

Accettiamo diversi tipi di contributi:

1. **📝 Documentazione**
   - Miglioramenti alla documentazione esistente
   - Nuovi tutorial ed esempi
   - Traduzioni

2. **🤖 Nuovi Agenti**
   - Implementazione di nuovi agenti specializzati
   - Miglioramenti agli agenti esistenti

3. **🔄 Workflow**
   - Nuovi workflow di esempio
   - Pattern di orchestrazione

4. **📋 Specifiche**
   - Template per nuovi tipi di specifiche
   - Esempi pratici

5. **🐛 Bug Fixes**
   - Correzione di bug
   - Miglioramenti di performance

6. **✨ Features**
   - Nuove funzionalità
   - Tool e utility

## 🚀 Getting Started

### Setup Ambiente di Sviluppo

```bash
# Fork e clone del repository
git clone https://github.com/YOUR_USERNAME/ai-dev-lab.git
cd ai-dev-lab

# Crea un branch per il tuo lavoro
git checkout -b feature/my-contribution

# Fai le tue modifiche...

# Commit e push
git add .
git commit -m "Add: descriptive commit message"
git push origin feature/my-contribution
```

### Struttura dei Commit

Usa [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: Nuova feature
- `fix`: Bug fix
- `docs`: Documentazione
- `style`: Formattazione
- `refactor`: Refactoring
- `test`: Test
- `chore`: Maintenance

**Esempi**:
```
feat: add implementation agent for Python code generation
docs: improve spec-driven development guide
fix: correct workflow execution order
```

## 📋 Linee Guida

### Documentazione

- Usa Markdown per tutta la documentazione
- Includi esempi pratici
- Mantieni consistenza con lo stile esistente
- Documenta in Italiano (lingua principale del progetto)
- Aggiungi riferimenti a risorse esterne quando appropriato

### Codice

Quando contribuisci codice (esempi, agenti, etc.):

```python
# Usa docstrings chiare
def my_function(param: str) -> dict:
    """
    Brief description
    
    Args:
        param: Description of parameter
    
    Returns:
        Description of return value
    
    Example:
        >>> my_function("test")
        {'result': 'test'}
    """
    pass

# Usa type hints
# Gestisci errori appropriatamente
# Includi test quando possibile
```

### Nuovi Agenti

Template per nuovo agente:

```python
from agents.base import BaseAgent
from typing import Dict, Any

class MyNewAgent(BaseAgent):
    """
    [Clear description of agent purpose]
    
    Capabilities:
        - capability1: Description
        - capability2: Description
    """
    
    def __init__(self):
        super().__init__(
            name="MyNewAgent",
            capabilities=["capability1", "capability2"],
            version="1.0.0"
        )
    
    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        [Description]
        
        Args:
            input_data: Input format description
        
        Returns:
            Output format description
        """
        # Implementation
        pass
    
    async def validate(self, output: Dict[str, Any]) -> bool:
        """Validate output quality"""
        # Validation logic
        pass
```

Includi anche:
- README.md nella directory dell'agente
- Esempi di utilizzo
- Test unitari (se applicabile)

### Workflow

Quando contribuisci un workflow:

```yaml
# workflows/my-workflow.yaml
name: My Workflow Name
version: 1.0.0
description: Clear description of what this workflow does

steps:
  - name: step_name
    agent: AgentName
    input:
      # Input specification
    output: output_name
```

Includi:
- Descrizione chiara dello scopo
- Documentazione dei parametri
- Esempio di utilizzo
- Use case concreti

### Specifiche e Template

Per nuovi template di specifiche:

- Usa formato standard (YAML, JSON)
- Includi commenti esplicativi
- Fornisci esempi concreti
- Documenta ogni campo

## 🧪 Testing

Se il tuo contributo include codice:

```python
# tests/test_my_contribution.py
import pytest

@pytest.mark.asyncio
async def test_my_feature():
    """Test description"""
    # Arrange
    # Act
    # Assert
    pass
```

## 📝 Pull Request Process

1. **Assicurati** che il tuo codice segua le linee guida
2. **Aggiorna** la documentazione se necessario
3. **Aggiungi** esempi se appropriato
4. **Descrivi** le modifiche nella PR:

```markdown
## Descrizione
[Cosa fa questo PR]

## Tipo di Modifica
- [ ] Bug fix
- [ ] Nuova feature
- [ ] Breaking change
- [ ] Documentazione

## Testing
[Come hai testato le modifiche]

## Checklist
- [ ] Codice segue le linee guida
- [ ] Documentazione aggiornata
- [ ] Esempi inclusi
- [ ] Test aggiunti (se applicabile)
```

## 💬 Community

### Comunicazione

- **GitHub Issues**: Per bug reports e feature requests
- **GitHub Discussions**: Per domande e discussioni
- **Pull Requests**: Per contributi di codice

### Code of Conduct

Ci aspettiamo che tutti i contributori:

- Siano rispettosi e costruttivi
- Accettino feedback in modo positivo
- Focalizzino su ciò che è meglio per la community
- Mostrino empatia verso altri membri

## 🏆 Riconoscimenti

I contributori verranno riconosciuti in:

- README.md (sezione Contributors)
- Release notes per contributi significativi
- Documentation per contributi specifici

## ❓ Domande?

Se hai domande:

1. Controlla la [documentazione esistente](docs/)
2. Cerca in [GitHub Issues](https://github.com/umbertocollina/ai-dev-lab/issues)
3. Apri una nuova [Discussion](https://github.com/umbertocollina/ai-dev-lab/discussions)

## 📚 Risorse

- [Markdown Guide](https://www.markdownguide.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)

---

Grazie per contribuire a rendere AI Development Lab migliore! 🚀
