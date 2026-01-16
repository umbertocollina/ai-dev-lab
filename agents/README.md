# Agent Framework 🤖

## Introduzione

Questo framework fornisce l'infrastruttura per creare, gestire e orchestrare agenti AI specializzati per tutte le fasi dello sviluppo software.

## 🏗️ Architettura degli Agenti

```
┌─────────────────────────────────────────────────┐
│              Agent Orchestrator                  │
│  - Coordina gli agenti                          │
│  - Gestisce il workflow                         │
│  - Gestisce lo stato globale                    │
└──────────────────┬──────────────────────────────┘
                   │
    ┌──────────────┼──────────────┐
    │              │              │
    ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│Requirements│ │  Design  │  │Implement │
│  Agent   │  │  Agent   │  │  Agent   │
└──────────┘  └──────────┘  └──────────┘
    │              │              │
    ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│ Testing  │  │Deployment│  │Monitoring│
│  Agent   │  │  Agent   │  │  Agent   │
└──────────┘  └──────────┘  └──────────┘
```

## 📁 Struttura degli Agenti

### Agenti Disponibili

1. **[Requirements Agent](requirements/README.md)** - Raccolta e formalizzazione requisiti
2. **[Design Agent](design/README.md)** - Progettazione architetturale
3. **[Implementation Agent](implementation/README.md)** - Generazione codice
4. **[Testing Agent](testing/README.md)** - Creazione e esecuzione test
5. **[Deployment Agent](deployment/README.md)** - Gestione deployment

## 🚀 Quick Start

### Installazione

```bash
# Clone del repository
git clone https://github.com/umbertocollina/ai-dev-lab.git
cd ai-dev-lab

# Setup (esempio con Python)
pip install -r requirements.txt
```

### Uso Base

```python
from agents import AgentOrchestrator, RequirementsAgent, DesignAgent

# Inizializza orchestrator
orchestrator = AgentOrchestrator()

# Registra agenti
orchestrator.register(RequirementsAgent())
orchestrator.register(DesignAgent())

# Esegui workflow
result = await orchestrator.execute({
    'task': 'Build user authentication',
    'requirements': 'Users need to login securely'
})

print(result)
```

## 🔧 Creazione di un Agente Personalizzato

### Template Base

```python
# agents/custom/my_agent.py
from agents.base import BaseAgent
from typing import Dict, Any

class MyCustomAgent(BaseAgent):
    """Custom agent description"""
    
    def __init__(self):
        super().__init__(
            name="MyCustomAgent",
            capabilities=["capability1", "capability2"],
            version="1.0.0"
        )
    
    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Process input and produce output
        
        Args:
            input_data: Input data dictionary
            
        Returns:
            Output data dictionary
        """
        # Your implementation here
        result = self._do_work(input_data)
        
        return {
            'status': 'success',
            'output': result,
            'agent': self.name
        }
    
    async def validate(self, output: Dict[str, Any]) -> bool:
        """
        Validate output quality
        
        Args:
            output: Output to validate
            
        Returns:
            True if valid, False otherwise
        """
        # Validation logic
        return 'output' in output and output['status'] == 'success'
    
    def _do_work(self, input_data: Dict) -> Any:
        """Internal work method"""
        # Implementation
        pass
```

### Registrazione dell'Agente

```python
from agents import AgentRegistry

# Registra il nuovo agente
AgentRegistry.register('my_custom_agent', MyCustomAgent)

# Usa l'agente
agent = AgentRegistry.get('my_custom_agent')
result = await agent.process(data)
```

## 📡 Comunicazione tra Agenti

### Message Protocol

Gli agenti comunicano tramite messaggi strutturati:

```python
# Message format
{
    'id': 'msg-uuid',
    'timestamp': '2026-01-16T14:00:00Z',
    'from': 'RequirementsAgent',
    'to': 'DesignAgent',
    'type': 'request',
    'payload': {
        'action': 'design_architecture',
        'requirements': {...}
    },
    'metadata': {
        'priority': 'high',
        'retry_count': 0
    }
}
```

### Message Bus

```python
from agents.messaging import MessageBus

bus = MessageBus()

# Agent pubblica un messaggio
await bus.publish('design.request', {
    'requirements': formal_requirements
})

# Agent si sottoscrive a messaggi
await bus.subscribe('design.request', design_agent.handle_message)
```

## 🔄 Workflow Orchestration

### Workflow Sequenziale

```python
from agents.orchestration import SequentialWorkflow

workflow = SequentialWorkflow([
    ('requirements', RequirementsAgent()),
    ('design', DesignAgent()),
    ('implementation', ImplementationAgent()),
    ('testing', TestingAgent())
])

result = await workflow.execute({'task': 'User auth'})
```

### Workflow Parallelo

```python
from agents.orchestration import ParallelWorkflow

# Esegui agenti in parallelo
workflow = ParallelWorkflow([
    TestingAgent(),
    SecurityScanAgent(),
    DocumentationAgent()
])

results = await workflow.execute({'code': generated_code})
```

### Workflow Condizionale

```python
from agents.orchestration import ConditionalWorkflow

workflow = ConditionalWorkflow()

workflow.add_step(
    RequirementsAgent(),
    condition=lambda ctx: ctx.get('has_requirements', False)
)

workflow.add_step(
    DesignAgent(),
    condition=lambda ctx: ctx['requirements'].get('complexity') == 'high'
)

result = await workflow.execute(context)
```

## 🎯 Agent Capabilities

### Capability System

Ogni agente dichiara le proprie capabilities:

```python
class AdvancedAgent(BaseAgent):
    def __init__(self):
        super().__init__(
            name="AdvancedAgent",
            capabilities=[
                'analyze',
                'design',
                'generate',
                'validate',
                'optimize'
            ]
        )
    
    def can_handle(self, task: str) -> bool:
        """Check if agent can handle this task"""
        return task in self.capabilities
```

### Dynamic Capability Discovery

```python
from agents import AgentRegistry

# Trova agenti per capability
agents = AgentRegistry.find_by_capability('generate')

# Trova il miglior agente per un task
best_agent = AgentRegistry.find_best_for_task(
    task='code_generation',
    criteria={'experience': 'high', 'speed': 'fast'}
)
```

## 📊 Monitoring e Logging

### Agent Telemetry

```python
from agents.monitoring import AgentMonitor

monitor = AgentMonitor()

class MonitoredAgent(BaseAgent):
    async def process(self, input_data: Dict) -> Dict:
        with monitor.track(self.name, 'process'):
            result = await super().process(input_data)
        
        monitor.record_metric(
            agent=self.name,
            metric='success_rate',
            value=1.0 if result['status'] == 'success' else 0.0
        )
        
        return result
```

### Logging Structure

```python
import logging

logger = logging.getLogger('agents')

class LoggingAgent(BaseAgent):
    async def process(self, input_data: Dict) -> Dict:
        logger.info(
            f"Agent {self.name} processing",
            extra={
                'agent': self.name,
                'input_size': len(str(input_data)),
                'timestamp': datetime.now().isoformat()
            }
        )
        
        try:
            result = await self._process(input_data)
            logger.info(f"Agent {self.name} succeeded")
            return result
        except Exception as e:
            logger.error(
                f"Agent {self.name} failed",
                extra={'error': str(e)},
                exc_info=True
            )
            raise
```

## 🔐 Security

### Input Validation

```python
from agents.security import InputValidator

class SecureAgent(BaseAgent):
    def __init__(self):
        super().__init__("SecureAgent", [])
        self.validator = InputValidator()
    
    async def process(self, input_data: Dict) -> Dict:
        # Validate schema
        self.validator.validate_schema(input_data, self.input_schema)
        
        # Sanitize inputs
        sanitized = self.validator.sanitize(input_data)
        
        # Process
        return await super().process(sanitized)
```

### Access Control

```python
from agents.security import requires_permission

class RestrictedAgent(BaseAgent):
    @requires_permission('admin')
    async def process(self, input_data: Dict) -> Dict:
        # Only admins can use this agent
        return await super().process(input_data)
```

## 🧪 Testing degli Agenti

### Unit Testing

```python
import pytest
from agents.testing import AgentTestCase

class TestMyAgent(AgentTestCase):
    def setup_method(self):
        self.agent = MyCustomAgent()
    
    @pytest.mark.asyncio
    async def test_process_success(self):
        input_data = {'task': 'test'}
        result = await self.agent.process(input_data)
        
        assert result['status'] == 'success'
        assert 'output' in result
    
    @pytest.mark.asyncio
    async def test_validation(self):
        output = {'status': 'success', 'output': 'data'}
        assert await self.agent.validate(output)
```

### Integration Testing

```python
@pytest.mark.integration
async def test_agent_workflow():
    orchestrator = AgentOrchestrator()
    orchestrator.register(RequirementsAgent())
    orchestrator.register(DesignAgent())
    
    result = await orchestrator.execute({
        'requirements': 'Test requirement'
    })
    
    assert result['status'] == 'success'
```

## 📚 Best Practices

### 1. Single Responsibility
Ogni agente dovrebbe avere un unico, ben definito scopo.

### 2. Idempotenza
Gli agenti dovrebbero produrre lo stesso output per lo stesso input.

### 3. Error Handling
Gestisci sempre gli errori e fornisci feedback utile.

```python
class RobustAgent(BaseAgent):
    async def process(self, input_data: Dict) -> Dict:
        try:
            return await self._process(input_data)
        except ValidationError as e:
            return {
                'status': 'error',
                'error_type': 'validation',
                'message': str(e)
            }
        except Exception as e:
            logger.exception("Unexpected error")
            return {
                'status': 'error',
                'error_type': 'internal',
                'message': 'Internal error occurred'
            }
```

### 4. Versioning
Versiona i tuoi agenti per gestire l'evoluzione.

```python
class VersionedAgent(BaseAgent):
    VERSION = "2.0.0"
    
    def __init__(self):
        super().__init__("VersionedAgent", [])
        self.version = self.VERSION
```

### 5. Documentation
Documenta sempre le capabilities, input e output.

```python
class DocumentedAgent(BaseAgent):
    """
    Agent description
    
    Capabilities:
        - capability1: Description
        - capability2: Description
    
    Input Format:
        {
            'field1': 'description',
            'field2': 'description'
        }
    
    Output Format:
        {
            'result': 'description',
            'metadata': 'description'
        }
    """
    pass
```

## 🔗 Prossimi Passi

1. Esplora gli agenti specifici:
   - [Requirements Agent](requirements/README.md)
   - [Design Agent](design/README.md)
   - [Implementation Agent](implementation/README.md)
   - [Testing Agent](testing/README.md)
   - [Deployment Agent](deployment/README.md)

2. Vedi esempi pratici in [workflows/examples/](../../workflows/examples/)

3. Consulta la [documentazione API completa](../api-reference/)

---

[← Torna alla Home](../../README.md)
