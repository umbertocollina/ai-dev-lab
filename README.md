# AI Development Lab 🤖🔬

Un laboratorio completo per sfruttare le potenzialità dell'Intelligenza Artificiale nello sviluppo software .NET, con focus su BDD/TDD, Clean Architecture e spec-driven development.

## 🎯 Obiettivi

Questo repository è progettato per aiutare software architects e sviluppatori .NET a:

- **Sviluppare con BDD/TDD**: Utilizzare Reqnroll (Gherkin) e NUnit per test-driven development
- **Implementare Clean Architecture**: Strutture applicative seguendo i principi SOLID e DDD
- **Sfruttare l'AI in ogni fase dello sviluppo**: Dalla raccolta requisiti al deployment
- **Implementare agenti specializzati**: Per automatizzare e migliorare il processo di sviluppo
- **Adottare lo Spec-Driven Development**: Approccio metodologico basato su specifiche formali
- **Gestire task complessi**: Con orchestrazione intelligente di agenti AI

## 🔷 Focus su .NET

Questo repository è specializzato nello sviluppo **.NET** con:
- **Reqnroll** per BDD testing con feature file Gherkin
- **NUnit** per unit testing (anche con Reqnroll per consistenza)
- **Clean Architecture** con separazione dei layer (Domain, Application, Infrastructure, Presentation)
- **CQRS** con MediatR
- **Domain-Driven Design** patterns

## 📚 Struttura del Repository

```
ai-dev-lab/
├── docs/                          # Documentazione completa
│   ├── dotnet-development/        # 🔷 .NET con BDD/TDD e Clean Architecture
│   ├── spec-driven-development/   # Guide sullo spec-driven development
│   ├── ai-architecture/           # Pattern architetturali con AI
│   └── best-practices/            # Best practices e linee guida
├── agents/                        # Framework e implementazioni di agenti
│   ├── requirements/              # Agenti per raccolta requisiti
│   ├── design/                    # Agenti per design architetturale
│   ├── implementation/            # Agenti per implementazione (con focus .NET)
│   ├── testing/                   # Agenti per testing (BDD con Reqnroll)
│   └── deployment/                # Agenti per deployment
├── specs/                         # Template e esempi di specifiche
│   ├── templates/                 # Template riutilizzabili
│   └── examples/                  # Esempi pratici (inclusi .feature Gherkin)
├── workflows/                     # Workflow di orchestrazione
│   └── examples/                  # Esempi di workflow completi
└── examples/                      # Progetti esempio end-to-end
    └── dotnet-clean-architecture/ # 🔷 Esempio completo .NET con Clean Architecture
```

## 🚀 Quick Start

### 1. Inizia con .NET BDD/TDD e Clean Architecture

Questa è la **priorità principale** del repository. Leggi la [guida completa .NET](docs/dotnet-development/README.md) per:
- Configurare Reqnroll per BDD testing
- Scrivere feature file in Gherkin
- Usare NUnit per unit testing (anche con Reqnroll)
- Implementare Clean Architecture
- Applicare pattern TDD
- Usare CQRS con MediatR

**Esempio pratico**: [Sistema di Gestione Ordini](examples/dotnet-clean-architecture/README.md) - Implementazione completa con BDD, TDD e Clean Architecture.

### 2. Comprendi lo Spec-Driven Development

Lo **Spec-Driven Development** (SDD) è un approccio metodologico che pone le specifiche formali al centro del processo di sviluppo. Perfettamente integrato con BDD. Leggi la [guida completa](docs/spec-driven-development/README.md) per approfondire.

### 3. Esplora gli Agenti AI

Gli agenti AI sono componenti specializzati che supportano diverse fasi dello sviluppo .NET:

- **Requirements Agent**: Analizza e formalizza i requisiti → Feature file Gherkin
- **Architecture Agent**: Progetta Clean Architecture per .NET
- **Implementation Agent**: Genera codice C# basato su specifiche
- **Testing Agent**: Crea test Reqnroll con NUnit
- **Deployment Agent**: Gestisce il rilascio di applicazioni .NET

Vedi la [documentazione degli agenti](agents/README.md) per dettagli.

### 4. Utilizza i Workflow

I workflow orchestrano gli agenti per completare task complessi .NET. Esplora gli [esempi di workflow](workflows/README.md).

## 📖 Documentazione

### Concetti Chiave

1. **[.NET Development con BDD/TDD](docs/dotnet-development/README.md)** 🔷 **PRIORITÀ**
   - Reqnroll e Gherkin per BDD
   - NUnit per TDD e unit testing (anche con Reqnroll)
   - Clean Architecture in .NET
   - CQRS con MediatR
   - Domain-Driven Design

2. **[Spec-Driven Development](docs/spec-driven-development/README.md)**
   - Cos'è e perché utilizzarlo
   - Come scrivere specifiche efficaci
   - Integrazione con BDD/Gherkin
   - Tool e metodologie

3. **[AI-Powered Architecture](docs/ai-architecture/README.md)**
   - Pattern architetturali con AI
   - Design patterns per agenti
   - Clean Architecture con AI
   - Scalabilità e performance

4. **[Agent Framework](agents/README.md)**
   - Architettura degli agenti
   - Comunicazione tra agenti
   - Agenti specializzati per .NET
   - Estensibilità

5. **[Task Orchestration](workflows/README.md)**
   - Gestione delle dipendenze
   - Coordinamento degli agenti
   - Workflow per progetti .NET
   - Error handling e retry

## 🛠️ Utilizzo Pratico

### Esempio: Sviluppo di una Feature con BDD/TDD (.NET)

```bash
# 1. Definisci la feature in Gherkin
cat > Features/UserRegistration.feature << 'EOF'
Feature: User Registration
    Scenario: Register new user
        When I register with email "user@example.com"
        Then the registration should succeed
EOF

# 2. Esegui test (RED - fallisce perché non c'è implementazione)
dotnet test

# 3. Implementa step definitions
# StepDefinitions/UserRegistrationSteps.cs

# 4. Implementa handler con TDD
# Application/Features/Auth/Commands/RegisterUserCommand.cs

# 5. Esegui test (GREEN - passa)
dotnet test

# 6. Refactoring
# Migliora codice mantenendo i test verdi
```

### Workflow Completo

```yaml
# specs/dotnet-feature.yaml
feature: User Authentication
technology:
  framework: .NET 8.0
  testing: Reqnroll + NUnit
  architecture: Clean Architecture
requirements:
  - secure registration with email/password
  - login with JWT tokens
  - password reset functionality
agents:
  - requirements   # Genera feature file Gherkin
  - design         # Progetta Clean Architecture
  - implementation # Genera codice C# con CQRS
  - testing        # Genera step definitions e unit tests con NUnit
```

# 2. Esegui il workflow
./workflows/feature-development.sh specs/my-feature.yaml

# 3. Gli agenti lavoreranno in sequenza
# - Requirements Agent: analizza e formalizza
# - Design Agent: progetta l'architettura
# - Implementation Agent: genera il codice
# - Testing Agent: crea e esegue i test
```

## 🎓 Risorse di Apprendimento

### Spec-Driven Development

Lo spec-driven development si basa su questi principi:

1. **Specification First**: Le specifiche vengono scritte prima del codice
2. **Formal Validation**: Le specifiche sono verificabili formalmente
3. **Living Documentation**: Le specifiche evolvono con il codice
4. **AI-Friendly**: Le specifiche sono ottimizzate per l'interpretazione AI

**Benefici**:
- Riduzione degli errori di interpretazione
- Migliore comunicazione tra stakeholder
- Documentazione sempre aggiornata
- Integrazione naturale con AI agents

### AI per Software Architects

Come architetto software, puoi sfruttare l'AI per:

- **Analisi di requisiti**: Estrazione automatica da documenti e conversazioni
- **Design review**: Validazione automatica di decisioni architetturali
- **Generazione di documentation**: Creazione automatica di diagrammi e docs
- **Pattern suggestion**: Suggerimento di pattern appropriati al contesto
- **Code generation**: Generazione di boilerplate e implementazioni standard
- **Testing strategy**: Definizione automatica di strategie di test
- **Performance analysis**: Analisi predittiva di performance
- **Security assessment**: Identificazione automatica di vulnerabilità

## 🤝 Contribuire

Questo è un laboratorio in continua evoluzione. I contributi sono benvenuti! Vedi [CONTRIBUTING.md](CONTRIBUTING.md) per le linee guida.

## 📝 License

MIT License - vedi [LICENSE](LICENSE) per dettagli.

## 🔗 Risorse Utili

- [OpenAPI Specification](https://swagger.io/specification/)
- [AsyncAPI Specification](https://www.asyncapi.com/)
- [ADR (Architecture Decision Records)](https://adr.github.io/)
- [C4 Model for Software Architecture](https://c4model.com/)

---

**Inizia il tuo viaggio nell'AI-powered software development! 🚀**