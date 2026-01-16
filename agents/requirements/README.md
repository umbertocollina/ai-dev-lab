# Requirements Agent 📋

## Panoramica

Il **Requirements Agent** è responsabile di raccogliere, analizzare e formalizzare i requisiti del software. Trasforma input in linguaggio naturale in specifiche formali e strutturate.

## 🎯 Capabilities

- **Extract**: Estrazione di requisiti da testo naturale
- **Formalize**: Trasformazione in specifiche formali
- **Validate**: Validazione della completezza e consistenza
- **Prioritize**: Prioritizzazione dei requisiti
- **Trace**: Tracciabilità dei requisiti

## 🔄 Workflow

```
Input (Natural Language)
         ↓
    [Extract]
         ↓
  Raw Requirements
         ↓
    [Formalize]
         ↓
 Formal Specification
         ↓
    [Validate]
         ↓
 Validated Requirements
         ↓
    [Output]
```

## 💻 Implementazione

### Base Agent

```python
from agents.base import BaseAgent
from typing import Dict, List, Any

class RequirementsAgent(BaseAgent):
    """
    Agent for requirements gathering and formalization
    """
    
    def __init__(self):
        super().__init__(
            name="RequirementsAgent",
            capabilities=[
                "extract",
                "formalize",
                "validate",
                "prioritize"
            ],
            version="1.0.0"
        )
    
    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Process natural language requirements
        
        Input:
            {
                'text': 'Natural language requirements',
                'context': 'Project context',
                'stakeholders': ['list', 'of', 'stakeholders']
            }
        
        Output:
            {
                'status': 'success',
                'requirements': [
                    {
                        'id': 'REQ-001',
                        'type': 'functional',
                        'description': '...',
                        'priority': 'high',
                        'stakeholder': '...'
                    }
                ],
                'specification': {...}
            }
        """
        text = input_data.get('text', '')
        context = input_data.get('context', '')
        
        # Extract requirements
        raw_requirements = await self._extract_requirements(text, context)
        
        # Formalize
        formal_requirements = await self._formalize(raw_requirements)
        
        # Validate
        validated = await self._validate(formal_requirements)
        
        # Prioritize
        prioritized = await self._prioritize(validated)
        
        return {
            'status': 'success',
            'requirements': prioritized,
            'specification': self._generate_spec(prioritized)
        }
    
    async def _extract_requirements(
        self, 
        text: str, 
        context: str
    ) -> List[Dict]:
        """Extract requirements from natural language"""
        # Implementation using NLP/AI
        pass
    
    async def _formalize(self, raw_requirements: List[Dict]) -> List[Dict]:
        """Convert to formal specification format"""
        pass
    
    async def _validate(self, requirements: List[Dict]) -> List[Dict]:
        """Validate completeness and consistency"""
        pass
    
    async def _prioritize(self, requirements: List[Dict]) -> List[Dict]:
        """Prioritize requirements"""
        pass
```

## 📝 Formato Output

### Functional Requirements

```yaml
# requirements.yaml
functional_requirements:
  - id: REQ-F-001
    title: User Registration
    description: |
      Users must be able to register with email and password
    acceptance_criteria:
      - Email must be valid format
      - Password must be at least 8 characters
      - System sends confirmation email
    priority: high
    stakeholder: Product Owner
    estimated_effort: medium
    
  - id: REQ-F-002
    title: User Login
    description: |
      Users must be able to login with credentials
    acceptance_criteria:
      - Valid credentials allow login
      - Invalid credentials show error
      - System issues JWT token
    priority: high
    stakeholder: Product Owner
    estimated_effort: medium
```

### Non-Functional Requirements

```yaml
non_functional_requirements:
  - id: REQ-NF-001
    category: Performance
    description: API response time < 200ms
    measurement: Response time for 95th percentile
    target: 200ms
    priority: high
    
  - id: REQ-NF-002
    category: Security
    description: Passwords must be hashed
    implementation: bcrypt with salt
    priority: critical
```

## 🛠️ Utilizzo

### Esempio Base

```python
from agents.requirements import RequirementsAgent

agent = RequirementsAgent()

# Input in linguaggio naturale
input_data = {
    'text': '''
        We need a user authentication system. 
        Users should be able to register with email and password.
        They should be able to login and receive a token.
        Passwords must be secure.
        The system should be fast.
    ''',
    'context': 'E-commerce platform',
    'stakeholders': ['Product Owner', 'Security Team']
}

# Process
result = await agent.process(input_data)

# Output
print(result['requirements'])
# [
#   {'id': 'REQ-F-001', 'type': 'functional', ...},
#   {'id': 'REQ-F-002', 'type': 'functional', ...},
#   {'id': 'REQ-NF-001', 'type': 'non-functional', ...}
# ]
```

### Esempio con File

```python
# Leggi requisiti da file
with open('requirements.txt', 'r') as f:
    requirements_text = f.read()

result = await agent.process({
    'text': requirements_text,
    'context': 'Web application',
    'output_format': 'yaml'
})

# Salva specifiche
with open('specs/requirements.yaml', 'w') as f:
    f.write(result['specification'])
```

## 🧪 Testing

```python
import pytest
from agents.requirements import RequirementsAgent

@pytest.mark.asyncio
async def test_extract_requirements():
    agent = RequirementsAgent()
    
    input_data = {
        'text': 'Users need to login with email and password',
        'context': 'Web app'
    }
    
    result = await agent.process(input_data)
    
    assert result['status'] == 'success'
    assert len(result['requirements']) > 0
    assert result['requirements'][0]['type'] in ['functional', 'non-functional']

@pytest.mark.asyncio
async def test_formalization():
    agent = RequirementsAgent()
    
    # Test che i requisiti siano formalizzati correttamente
    input_data = {
        'text': 'The app should be fast',
        'context': 'Mobile app'
    }
    
    result = await agent.process(input_data)
    
    # Verifica che il requisito vago sia stato formalizzato
    reqs = result['requirements']
    assert any('response time' in r['description'].lower() for r in reqs)
```

## 📊 Metriche

L'agent traccia le seguenti metriche:

- **Extraction Rate**: Numero di requisiti estratti per 100 parole
- **Formalization Quality**: Score di qualità della formalizzazione (0-1)
- **Validation Pass Rate**: % di requisiti che passano la validazione
- **Completeness Score**: Score di completezza dei requisiti (0-1)

## 🔗 Integration con Altri Agenti

### Con Design Agent

```python
# Requirements Agent → Design Agent
requirements_result = await requirements_agent.process(input_data)

design_input = {
    'requirements': requirements_result['requirements'],
    'context': 'System design'
}

design_result = await design_agent.process(design_input)
```

### Con Validation Agent

```python
# Validazione continua dei requisiti
validated = await validation_agent.validate({
    'requirements': requirements_result['requirements'],
    'code': implementation_result['code']
})
```

## 📚 Best Practices

1. **Specificity**: Trasforma requisiti vaghi in specifici
   - ❌ "Il sistema deve essere veloce"
   - ✅ "Il tempo di risposta API deve essere < 200ms per il 95% delle richieste"

2. **Testability**: Ogni requisito deve essere testabile
   - Include acceptance criteria chiari
   - Definisci metriche misurabili

3. **Traceability**: Mantieni tracciabilità
   - ID univoci per ogni requisito
   - Link a stakeholder e decisioni

4. **Prioritization**: Usa framework come MoSCoW
   - Must have
   - Should have
   - Could have
   - Won't have

---

[← Agents Overview](../README.md) | [Next: Design Agent →](../design/README.md)
