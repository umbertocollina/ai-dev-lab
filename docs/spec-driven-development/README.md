# Spec-Driven Development (SDD) 📋

## Cos'è lo Spec-Driven Development

Lo **Spec-Driven Development** è un approccio metodologico allo sviluppo software che pone le **specifiche formali** al centro del processo di sviluppo. A differenza del tradizionale approccio code-first, SDD richiede che le specifiche siano scritte, validate e concordate **prima** dell'implementazione.

## 🎯 Principi Fondamentali

### 1. Specification First
Le specifiche vengono create e validate prima di scrivere qualsiasi codice di implementazione. Questo garantisce:
- Chiarezza degli obiettivi
- Allineamento tra stakeholder
- Riduzione degli sprechi da refactoring

### 2. Formal Validation
Le specifiche devono essere:
- **Verificabili**: Possibilità di validare automaticamente la conformità
- **Non ambigue**: Linguaggio preciso e formale
- **Complete**: Copertura di tutti i casi d'uso rilevanti

### 3. Living Documentation
Le specifiche non sono documenti statici ma evolvono insieme al codice:
- Aggiornamento continuo
- Versionamento
- Sincronizzazione con l'implementazione

### 4. AI-Friendly
Le specifiche sono ottimizzate per l'interpretazione da parte di AI agents:
- Formato strutturato (YAML, JSON, OpenAPI)
- Linguaggio consistente
- Metadati espliciti

## 🔄 Il Processo SDD

```
┌─────────────────┐
│  Requirements   │
│   Gathering     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Write Formal   │
│  Specification  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Validate &    │
│     Review      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Generate Code  │
│  from Spec      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Validate Code  │
│  Against Spec   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Deploy &     │
│    Monitor      │
└─────────────────┘
```

## 📝 Tipi di Specifiche

### 1. API Specifications
**Standard**: OpenAPI, AsyncAPI, GraphQL Schema

**Esempio OpenAPI**:
```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
paths:
  /users/{id}:
    get:
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: User found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
```

### 2. Data Specifications
**Standard**: JSON Schema, Avro, Protocol Buffers

**Esempio JSON Schema**:
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "User",
  "type": "object",
  "properties": {
    "id": { "type": "string", "format": "uuid" },
    "name": { "type": "string", "minLength": 1 },
    "email": { "type": "string", "format": "email" }
  },
  "required": ["id", "name", "email"]
}
```

### 3. Behavior Specifications
**Standard**: Gherkin (BDD), Property-Based Tests

**Esempio Gherkin**:
```gherkin
Feature: User Authentication
  
  Scenario: Successful login
    Given a registered user with email "user@example.com"
    And the password "SecurePass123"
    When the user attempts to login
    Then the login should succeed
    And a JWT token should be returned
```

### 4. Architecture Specifications
**Standard**: ADR (Architecture Decision Records), C4 Model

**Esempio ADR**:
```markdown
# ADR 001: Use PostgreSQL for Primary Database

## Status
Accepted

## Context
Need to choose a database for user data storage.

## Decision
Use PostgreSQL as primary database.

## Consequences
- Mature, reliable SQL database
- ACID compliance
- Rich query capabilities
- Requires more setup than NoSQL
```

## 🤖 SDD e Intelligenza Artificiale

### Perché SDD è Perfetto per l'AI

1. **Formato Strutturato**: Gli AI agents possono parsare facilmente specifiche formali
2. **Chiaro Intent**: Le specifiche comunicano l'intento in modo esplicito
3. **Validazione Automatica**: Gli AI possono verificare conformità automaticamente
4. **Generazione di Codice**: Le specifiche forniscono un blueprint chiaro per la code generation

### Come gli AI Agents Utilizzano le Specifiche

```
Specification → AI Agent → Implementation
                   ↓
              Validation
                   ↓
           Conformance Check
```

**Esempio di Workflow**:
1. Developer scrive OpenAPI spec
2. Design Agent valida la spec per best practices
3. Implementation Agent genera il codice boilerplate
4. Testing Agent genera test cases dalla spec
5. Validation Agent verifica che il codice implementi la spec

## 🛠️ Tool e Framework

### Tool per la Creazione di Specifiche

- **OpenAPI**: Swagger Editor, Stoplight Studio
- **AsyncAPI**: AsyncAPI Studio
- **JSON Schema**: JSON Schema Editor
- **Gherkin**: Cucumber, SpecFlow

### Tool per la Validazione

- **OpenAPI**: Spectral, Swagger Validator
- **JSON Schema**: AJV, Joi
- **Contract Testing**: Pact, Spring Cloud Contract

### Tool per la Generazione di Codice

- **OpenAPI**: OpenAPI Generator, Swagger Codegen
- **GraphQL**: GraphQL Code Generator
- **Protocol Buffers**: protoc

## 📚 Best Practices

### 1. Inizia con un Template
Usa template predefiniti per mantenere consistenza:
```yaml
# specs/templates/api-spec-template.yaml
openapi: 3.0.0
info:
  title: <API_NAME>
  version: 1.0.0
  description: <DESCRIPTION>
# ... rest of template
```

### 2. Versiona le Specifiche
Usa semantic versioning per le specifiche:
- **Major**: Breaking changes
- **Minor**: Nuove funzionalità backward-compatible
- **Patch**: Bug fixes e chiarimenti

### 3. Review Process
Stabilisci un processo di review per le specifiche:
1. Developer crea la spec
2. Peer review
3. AI agent validation
4. Architect approval

### 4. Test dalla Specifica
Genera test automaticamente dalla specifica:
```javascript
// Example: Generate tests from OpenAPI
const spec = loadOpenAPISpec('api-spec.yaml');
const tests = generateTests(spec);
tests.forEach(test => test.run());
```

### 5. Documentation Sync
Mantieni documentazione sincronizzata con spec:
```bash
# Generate docs from spec
openapi-generator generate -i api-spec.yaml -g html2 -o docs/
```

## 🎓 Esempio Completo: Sistema di Autenticazione

### Step 1: Requirements
```yaml
# specs/auth-requirements.yaml
feature: User Authentication System
stakeholders:
  - Product Owner
  - Security Team
  - Backend Team
requirements:
  functional:
    - REQ-001: Users can register with email and password
    - REQ-002: Users can login with credentials
    - REQ-003: System issues JWT tokens
    - REQ-004: Users can reset password
  non-functional:
    - REQ-NFR-001: Password must be hashed with bcrypt
    - REQ-NFR-002: JWT tokens expire after 24h
    - REQ-NFR-003: API response time < 200ms
```

### Step 2: API Specification
```yaml
# specs/auth-api.yaml
openapi: 3.0.0
info:
  title: Authentication API
  version: 1.0.0
paths:
  /auth/register:
    post:
      summary: Register new user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
                  minLength: 8
              required: [email, password]
      responses:
        '201':
          description: User created
        '400':
          description: Invalid input
        '409':
          description: Email already exists
```

### Step 3: Behavior Specification
```gherkin
# specs/auth-behavior.feature
Feature: User Authentication

  Scenario: User registers successfully
    Given no user exists with email "test@example.com"
    When I POST to "/auth/register" with:
      | email              | password    |
      | test@example.com   | Secret123!  |
    Then the response status should be 201
    And the user should be stored in database
    And the password should be hashed

  Scenario: User cannot register with weak password
    When I POST to "/auth/register" with:
      | email              | password |
      | test@example.com   | 123      |
    Then the response status should be 400
    And the error should mention "password too weak"
```

### Step 4: Data Specification
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "User",
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid"
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "passwordHash": {
      "type": "string",
      "description": "bcrypt hash of password"
    },
    "createdAt": {
      "type": "string",
      "format": "date-time"
    }
  },
  "required": ["id", "email", "passwordHash", "createdAt"]
}
```

## 🔗 Risorse Aggiuntive

### Documenti Standard
- [OpenAPI Specification](https://swagger.io/specification/)
- [JSON Schema](https://json-schema.org/)
- [AsyncAPI](https://www.asyncapi.com/)
- [Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)

### Libri Consigliati
- "Specification by Example" di Gojko Adzic
- "Domain-Driven Design" di Eric Evans
- "Design by Contract" di Bertrand Meyer

### Community
- [OpenAPI Initiative](https://www.openapis.org/)
- [AsyncAPI Community](https://www.asyncapi.com/community)

---

[← Torna alla Home](../../README.md) | [Next: AI Architecture →](../ai-architecture/README.md)
