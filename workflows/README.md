# Workflow Orchestration 🔄

## Introduzione

I workflow orchestrano gli agenti per completare task complessi end-to-end. Questo documento descrive come creare e gestire workflow di sviluppo basati su agenti AI.

## 🎯 Tipi di Workflow

### 1. Sequential Workflow
Gli agenti eseguono in sequenza, ogni output diventa input del successivo.

### 2. Parallel Workflow
Multipli agenti eseguono simultaneamente su dati diversi.

### 3. Conditional Workflow
Il flusso dipende da condizioni e risultati intermedi.

### 4. Event-Driven Workflow
Gli agenti rispondono a eventi nel sistema.

## 📋 Workflow Standard

### Feature Development Workflow

```yaml
# workflows/feature-development.yaml
name: Feature Development Workflow
version: 1.0.0
description: Complete workflow from requirements to deployment

steps:
  - name: gather_requirements
    agent: RequirementsAgent
    input:
      source: user_input
    output: requirements
    
  - name: design_architecture
    agent: DesignAgent
    input:
      requirements: ${steps.gather_requirements.output}
    output: design
    
  - name: generate_code
    agent: ImplementationAgent
    input:
      design: ${steps.design_architecture.output}
      requirements: ${steps.gather_requirements.output}
    output: code
    
  - name: generate_tests
    agent: TestingAgent
    input:
      code: ${steps.generate_code.output}
      requirements: ${steps.gather_requirements.output}
    output: tests
    
  - name: run_tests
    agent: TestingAgent
    action: execute
    input:
      tests: ${steps.generate_tests.output}
      code: ${steps.generate_code.output}
    output: test_results
    
  - name: deploy
    agent: DeploymentAgent
    condition: ${steps.run_tests.output.success}
    input:
      code: ${steps.generate_code.output}
      environment: staging
    output: deployment_info
```

### Bug Fix Workflow

```yaml
# workflows/bug-fix.yaml
name: Bug Fix Workflow
version: 1.0.0

steps:
  - name: analyze_bug
    agent: AnalysisAgent
    input:
      bug_report: ${input.bug_report}
      codebase: ${input.codebase}
    output: analysis
    
  - name: propose_fix
    agent: ImplementationAgent
    input:
      analysis: ${steps.analyze_bug.output}
    output: fix_proposal
    
  - name: generate_tests
    agent: TestingAgent
    input:
      bug_report: ${input.bug_report}
      fix: ${steps.propose_fix.output}
    output: regression_tests
    
  - name: apply_fix
    agent: ImplementationAgent
    action: apply
    input:
      fix: ${steps.propose_fix.output}
    output: fixed_code
    
  - name: validate
    agent: TestingAgent
    action: execute
    input:
      tests: ${steps.generate_tests.output}
      code: ${steps.apply_fix.output}
```

### Code Review Workflow

```yaml
# workflows/code-review.yaml
name: Code Review Workflow
version: 1.0.0

steps:
  - name: static_analysis
    agent: CodeQualityAgent
    input:
      code: ${input.code}
    output: static_analysis_results
    parallel: true
    
  - name: security_scan
    agent: SecurityAgent
    input:
      code: ${input.code}
    output: security_results
    parallel: true
    
  - name: performance_analysis
    agent: PerformanceAgent
    input:
      code: ${input.code}
    output: performance_results
    parallel: true
    
  - name: aggregate_results
    agent: ReviewAgent
    input:
      static: ${steps.static_analysis.output}
      security: ${steps.security_scan.output}
      performance: ${steps.performance_analysis.output}
    output: review_report
```

## 💻 Implementazione

### Python Workflow Engine

```python
# workflows/engine.py
import yaml
from typing import Dict, Any, List
from agents import AgentRegistry

class WorkflowEngine:
    def __init__(self):
        self.agent_registry = AgentRegistry()
        
    async def execute(self, workflow_file: str, initial_input: Dict) -> Dict:
        """Execute a workflow from YAML file"""
        with open(workflow_file) as f:
            workflow_def = yaml.safe_load(f)
        
        return await self.execute_workflow(workflow_def, initial_input)
    
    async def execute_workflow(
        self, 
        workflow: Dict, 
        initial_input: Dict
    ) -> Dict:
        """Execute workflow definition"""
        context = {'input': initial_input}
        results = {}
        
        for step in workflow['steps']:
            # Check condition
            if 'condition' in step:
                if not self._evaluate_condition(step['condition'], context):
                    continue
            
            # Get agent
            agent = self.agent_registry.get(step['agent'])
            
            # Prepare input
            step_input = self._prepare_input(step['input'], context)
            
            # Execute
            if step.get('parallel'):
                result = await self._execute_parallel(agent, step_input)
            else:
                result = await agent.process(step_input)
            
            # Store result
            results[step['name']] = result
            context[f"steps.{step['name']}"] = {'output': result}
        
        return results
    
    def _evaluate_condition(self, condition: str, context: Dict) -> bool:
        """Evaluate condition expression"""
        # SECURITY NOTE: This is a simplified example for demonstration purposes.
        # In production, use a secure expression evaluator such as:
        # - simpleeval library
        # - RestrictedPython
        # - Custom AST-based evaluator
        # Never use eval() in production with untrusted input!
        return eval(condition.replace('${', 'context["').replace('}', '"]'))
    
    def _prepare_input(self, input_spec: Dict, context: Dict) -> Dict:
        """Prepare input by resolving references"""
        result = {}
        for key, value in input_spec.items():
            if isinstance(value, str) and value.startswith('${'):
                # Resolve reference
                ref = value[2:-1]  # Remove ${ and }
                result[key] = self._resolve_reference(ref, context)
            else:
                result[key] = value
        return result
    
    def _resolve_reference(self, ref: str, context: Dict) -> Any:
        """Resolve a reference like 'steps.step_name.output'"""
        parts = ref.split('.')
        value = context
        for part in parts:
            value = value[part]
        return value
```

### Utilizzo del Workflow Engine

```python
# examples/run_workflow.py
from workflows.engine import WorkflowEngine

async def main():
    engine = WorkflowEngine()
    
    # Execute feature development workflow
    result = await engine.execute(
        'workflows/feature-development.yaml',
        initial_input={
            'requirements': '''
                Build a user authentication system with:
                - Email/password registration
                - Secure login
                - JWT tokens
                - Password reset
            '''
        }
    )
    
    print("Workflow completed!")
    print(f"Requirements: {result['gather_requirements']}")
    print(f"Design: {result['design_architecture']}")
    print(f"Code generated: {len(result['generate_code']['files'])} files")
    print(f"Tests: {result['run_tests']['passed']}/{result['run_tests']['total']}")

if __name__ == '__main__':
    import asyncio
    asyncio.run(main())
```

## 🎛️ Workflow CLI

```bash
# Run a workflow
./workflows/run.sh feature-development requirements.txt

# List available workflows
./workflows/list.sh

# Validate workflow definition
./workflows/validate.sh my-workflow.yaml

# Monitor workflow execution
./workflows/monitor.sh workflow-id
```

### CLI Implementation

```bash
#!/bin/bash
# workflows/run.sh

WORKFLOW=$1
INPUT=$2

python3 -m workflows.cli run \
  --workflow "workflows/${WORKFLOW}.yaml" \
  --input "$INPUT" \
  --output "output/${WORKFLOW}-$(date +%s)"
```

## 📊 Monitoring e Logging

### Workflow Execution Tracking

```python
class WorkflowMonitor:
    def __init__(self):
        self.executions = {}
    
    def track_execution(self, workflow_id: str):
        """Track workflow execution"""
        self.executions[workflow_id] = {
            'status': 'running',
            'start_time': datetime.now(),
            'steps_completed': 0,
            'steps_total': 0
        }
    
    def update_step(self, workflow_id: str, step_name: str, status: str):
        """Update step status"""
        execution = self.executions[workflow_id]
        if 'steps' not in execution:
            execution['steps'] = {}
        execution['steps'][step_name] = {
            'status': status,
            'timestamp': datetime.now()
        }
        if status == 'completed':
            execution['steps_completed'] += 1
```

## 🔄 Error Handling

### Retry Strategy

```yaml
# Workflow with retry configuration
steps:
  - name: flaky_operation
    agent: ExternalAPIAgent
    retry:
      max_attempts: 3
      backoff: exponential
      initial_delay: 1s
    on_error:
      action: log_and_continue
```

### Error Handling Implementation

```python
async def execute_with_retry(self, agent, input_data, retry_config):
    """Execute with retry logic"""
    max_attempts = retry_config.get('max_attempts', 1)
    backoff = retry_config.get('backoff', 'linear')
    initial_delay = retry_config.get('initial_delay', 1)
    
    for attempt in range(max_attempts):
        try:
            return await agent.process(input_data)
        except Exception as e:
            if attempt == max_attempts - 1:
                raise
            
            delay = self._calculate_delay(attempt, backoff, initial_delay)
            await asyncio.sleep(delay)
            
            logger.warning(
                f"Retry attempt {attempt + 1}/{max_attempts} "
                f"after {delay}s delay"
            )
```

## 📚 Best Practices

### 1. Idempotenza
Progetta workflow idempotenti quando possibile:
```yaml
steps:
  - name: create_resource
    agent: ResourceAgent
    idempotent: true
    idempotency_key: ${input.resource_id}
```

### 2. Checkpoint e Resume
Salva stato intermedio per resume:
```yaml
checkpoint:
  enabled: true
  frequency: after_each_step
  storage: ./checkpoints
```

### 3. Timeouts
Imposta timeout appropriati:
```yaml
steps:
  - name: long_running_task
    agent: HeavyAgent
    timeout: 300s  # 5 minutes
```

### 4. Parallel Execution
Usa parallelismo quando possibile:
```yaml
steps:
  - name: parallel_tests
    parallel: true
    agents:
      - UnitTestAgent
      - IntegrationTestAgent
      - E2ETestAgent
```

## 🔗 Esempi Completi

Vedi la directory [examples/](./examples/) per workflow completi e funzionanti:

- [examples/simple-workflow.yaml](./examples/simple-workflow.yaml)
- [examples/advanced-workflow.yaml](./examples/advanced-workflow.yaml)
- [examples/microservices-workflow.yaml](./examples/microservices-workflow.yaml)

---

[← Agents](../agents/README.md) | [→ Examples](../examples/README.md)
