# .NET Development con BDD, TDD e Clean Architecture 🔷

## Panoramica

Questo repository è specializzato nello sviluppo .NET utilizzando:
- **BDD (Behavior-Driven Development)** con Reqnroll e Gherkin
- **TDD (Test-Driven Development)** con xUnit/NUnit
- **Clean Architecture** per struttura e design
- **AI Agents** per automatizzare il processo di sviluppo

## 🎯 Stack Tecnologico

### Framework e Librerie
- **.NET 8.0+** - Framework principale
- **Reqnroll** - BDD testing framework (SpecFlow next-gen)
- **xUnit / NUnit** - Unit testing
- **FluentAssertions** - Assertion library
- **Moq / NSubstitute** - Mocking framework
- **MediatR** - CQRS pattern implementation
- **AutoMapper** - Object mapping

### Architettura
- **Clean Architecture** (Onion Architecture)
- **CQRS** con MediatR
- **Domain-Driven Design** patterns
- **Repository Pattern**
- **Unit of Work Pattern**

## 🏗️ Struttura Clean Architecture

```
Solution/
├── src/
│   ├── Domain/                      # Core business logic
│   │   ├── Entities/
│   │   ├── ValueObjects/
│   │   ├── Enums/
│   │   ├── Exceptions/
│   │   └── Interfaces/
│   │
│   ├── Application/                 # Use cases e business rules
│   │   ├── Common/
│   │   │   ├── Interfaces/
│   │   │   ├── Behaviours/
│   │   │   └── Mappings/
│   │   ├── Features/
│   │   │   └── Users/
│   │   │       ├── Commands/
│   │   │       ├── Queries/
│   │   │       └── DTOs/
│   │   └── DependencyInjection.cs
│   │
│   ├── Infrastructure/              # Data access e external services
│   │   ├── Persistence/
│   │   │   ├── Configurations/
│   │   │   ├── Migrations/
│   │   │   └── ApplicationDbContext.cs
│   │   ├── Identity/
│   │   ├── Services/
│   │   └── DependencyInjection.cs
│   │
│   └── WebApi/                      # Presentation layer
│       ├── Controllers/
│       ├── Filters/
│       ├── Middleware/
│       └── Program.cs
│
└── tests/
    ├── Domain.UnitTests/            # Unit tests per Domain
    ├── Application.UnitTests/       # Unit tests per Application
    ├── Application.IntegrationTests/ # Integration tests
    └── Application.AcceptanceTests/ # BDD tests con Reqnroll
        ├── Features/                # File .feature (Gherkin)
        ├── StepDefinitions/         # Step definitions
        ├── Hooks/                   # Before/After hooks
        └── Support/                 # Helper e utilities
```

## 🧪 BDD con Reqnroll

### Installazione

```bash
# Create solution
dotnet new sln -n MyProject

# Create projects
dotnet new classlib -n MyProject.Domain
dotnet new classlib -n MyProject.Application
dotnet new classlib -n MyProject.Infrastructure
dotnet new webapi -n MyProject.WebApi

# Create test projects
dotnet new xunit -n MyProject.Application.UnitTests
dotnet new xunit -n MyProject.Application.AcceptanceTests

# Add Reqnroll to acceptance tests
cd MyProject.Application.AcceptanceTests
dotnet add package Reqnroll
dotnet add package Reqnroll.xUnit
dotnet add package FluentAssertions
```

### Feature File Example

```gherkin
# Features/UserAuthentication.feature
Feature: User Authentication
    As a user
    I want to be able to authenticate
    So that I can access the system securely

    Background:
        Given the system is running
        And the database is clean

    Scenario: Successful user registration
        Given I am a new user
        When I register with the following details:
            | Field    | Value              |
            | Email    | user@example.com   |
            | Password | SecurePass123!     |
            | Name     | John Doe           |
        Then the registration should succeed
        And I should receive a confirmation email
        And the user should be stored in the database

    Scenario: User login with valid credentials
        Given a user exists with email "user@example.com" and password "SecurePass123!"
        When I login with email "user@example.com" and password "SecurePass123!"
        Then the login should succeed
        And I should receive an access token
        And the token should be valid for 24 hours

    Scenario Outline: User login with invalid credentials
        Given a user exists with email "user@example.com" and password "SecurePass123!"
        When I login with email "<email>" and password "<password>"
        Then the login should fail
        And I should see error "<error>"

        Examples:
            | email              | password       | error                |
            | wrong@example.com  | SecurePass123! | Invalid credentials  |
            | user@example.com   | WrongPass      | Invalid credentials  |
            | invalid-email      | SecurePass123! | Invalid email format |

    Scenario: Password reset request
        Given a user exists with email "user@example.com"
        When I request a password reset for "user@example.com"
        Then a password reset email should be sent
        And a reset token should be generated
        And the token should expire in 1 hour
```

### Step Definitions

```csharp
// StepDefinitions/UserAuthenticationSteps.cs
using Reqnroll;
using FluentAssertions;
using MyProject.Application.Features.Auth.Commands;
using MyProject.WebApi;

[Binding]
public class UserAuthenticationSteps
{
    private readonly ScenarioContext _scenarioContext;
    private readonly WebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    
    public UserAuthenticationSteps(
        ScenarioContext scenarioContext,
        WebApplicationFactory<Program> factory)
    {
        _scenarioContext = scenarioContext;
        _factory = factory;
        _client = factory.CreateClient();
    }

    [Given(@"I am a new user")]
    public void GivenIAmANewUser()
    {
        // Setup for new user scenario
    }

    [When(@"I register with the following details:")]
    public async Task WhenIRegisterWithTheFollowingDetails(Table table)
    {
        var registrationData = new
        {
            Email = table.Rows[0]["Value"],
            Password = table.Rows[1]["Value"],
            Name = table.Rows[2]["Value"]
        };

        var response = await _client.PostAsJsonAsync(
            "/api/auth/register", 
            registrationData
        );

        _scenarioContext["RegistrationResponse"] = response;
    }

    [Then(@"the registration should succeed")]
    public void ThenTheRegistrationShouldSucceed()
    {
        var response = _scenarioContext["RegistrationResponse"] as HttpResponseMessage;
        response.StatusCode.Should().Be(HttpStatusCode.Created);
    }

    [Then(@"I should receive a confirmation email")]
    public void ThenIShouldReceiveAConfirmationEmail()
    {
        // Verify email was sent (e.g., check mock email service)
        var emailService = _scenarioContext["EmailService"] as Mock<IEmailService>;
        emailService.Verify(
            x => x.SendConfirmationEmailAsync(It.IsAny<string>()),
            Times.Once
        );
    }
}
```

### Hooks

```csharp
// Hooks/TestHooks.cs
using Reqnroll;

[Binding]
public class TestHooks
{
    private readonly ScenarioContext _scenarioContext;

    public TestHooks(ScenarioContext scenarioContext)
    {
        _scenarioContext = scenarioContext;
    }

    [BeforeScenario]
    public async Task BeforeScenario()
    {
        // Setup before each scenario
        // E.g., reset database, initialize test data
    }

    [AfterScenario]
    public async Task AfterScenario()
    {
        // Cleanup after each scenario
    }

    [BeforeFeature]
    public static void BeforeFeature()
    {
        // Setup before feature
    }

    [AfterFeature]
    public static void AfterFeature()
    {
        // Cleanup after feature
    }
}
```

## 🔴 TDD con xUnit

### Test Structure

```csharp
// Application.UnitTests/Features/Auth/Commands/RegisterUserCommandTests.cs
using Xunit;
using FluentAssertions;
using Moq;
using MyProject.Application.Features.Auth.Commands;

public class RegisterUserCommandTests
{
    private readonly Mock<IUserRepository> _userRepositoryMock;
    private readonly Mock<IPasswordHasher> _passwordHasherMock;
    private readonly RegisterUserCommandHandler _handler;

    public RegisterUserCommandTests()
    {
        _userRepositoryMock = new Mock<IUserRepository>();
        _passwordHasherMock = new Mock<IPasswordHasher>();
        _handler = new RegisterUserCommandHandler(
            _userRepositoryMock.Object,
            _passwordHasherMock.Object
        );
    }

    [Fact]
    public async Task Handle_ValidCommand_ShouldCreateUser()
    {
        // Arrange
        var command = new RegisterUserCommand
        {
            Email = "test@example.com",
            Password = "SecurePass123!",
            Name = "Test User"
        };

        _passwordHasherMock
            .Setup(x => x.HashPassword(command.Password))
            .Returns("hashed_password");

        // Act
        var result = await _handler.Handle(command, CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result.IsSuccess.Should().BeTrue();
        _userRepositoryMock.Verify(
            x => x.AddAsync(It.Is<User>(u => 
                u.Email == command.Email &&
                u.Name == command.Name
            )),
            Times.Once
        );
    }

    [Theory]
    [InlineData("")]
    [InlineData("invalid-email")]
    [InlineData("test")]
    public async Task Handle_InvalidEmail_ShouldReturnValidationError(string email)
    {
        // Arrange
        var command = new RegisterUserCommand
        {
            Email = email,
            Password = "SecurePass123!",
            Name = "Test User"
        };

        // Act
        var result = await _handler.Handle(command, CancellationToken.None);

        // Assert
        result.IsSuccess.Should().BeFalse();
        result.Errors.Should().Contain(e => e.Contains("email"));
    }

    [Fact]
    public async Task Handle_ExistingEmail_ShouldReturnConflictError()
    {
        // Arrange
        var command = new RegisterUserCommand
        {
            Email = "existing@example.com",
            Password = "SecurePass123!",
            Name = "Test User"
        };

        _userRepositoryMock
            .Setup(x => x.ExistsAsync(command.Email))
            .ReturnsAsync(true);

        // Act
        var result = await _handler.Handle(command, CancellationToken.None);

        // Assert
        result.IsSuccess.Should().BeFalse();
        result.Errors.Should().Contain(e => e.Contains("already exists"));
    }
}
```

## 🏛️ Clean Architecture Implementation

### Domain Layer

```csharp
// Domain/Entities/User.cs
namespace MyProject.Domain.Entities;

public class User : BaseEntity
{
    public string Email { get; private set; }
    public string PasswordHash { get; private set; }
    public string Name { get; private set; }
    public bool EmailVerified { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime? LastLoginAt { get; private set; }

    private User() { } // For EF Core

    public static User Create(string email, string passwordHash, string name)
    {
        var user = new User
        {
            Id = Guid.NewGuid(),
            Email = email ?? throw new ArgumentNullException(nameof(email)),
            PasswordHash = passwordHash ?? throw new ArgumentNullException(nameof(passwordHash)),
            Name = name ?? throw new ArgumentNullException(nameof(name)),
            EmailVerified = false,
            CreatedAt = DateTime.UtcNow
        };

        user.AddDomainEvent(new UserCreatedEvent(user));
        
        return user;
    }

    public void VerifyEmail()
    {
        EmailVerified = true;
        AddDomainEvent(new UserEmailVerifiedEvent(this));
    }

    public void UpdateLastLogin()
    {
        LastLoginAt = DateTime.UtcNow;
    }
}

// Domain/Interfaces/IUserRepository.cs
public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id);
    Task<User?> GetByEmailAsync(string email);
    Task<bool> ExistsAsync(string email);
    Task AddAsync(User user);
    Task UpdateAsync(User user);
}
```

### Application Layer

```csharp
// Application/Features/Auth/Commands/RegisterUser/RegisterUserCommand.cs
using MediatR;

namespace MyProject.Application.Features.Auth.Commands;

public record RegisterUserCommand : IRequest<Result<UserDto>>
{
    public string Email { get; init; } = string.Empty;
    public string Password { get; init; } = string.Empty;
    public string Name { get; init; } = string.Empty;
}

// Application/Features/Auth/Commands/RegisterUser/RegisterUserCommandValidator.cs
using FluentValidation;

public class RegisterUserCommandValidator : AbstractValidator<RegisterUserCommand>
{
    public RegisterUserCommandValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress()
            .MaximumLength(255);

        RuleFor(x => x.Password)
            .NotEmpty()
            .MinimumLength(8)
            .Matches(@"[A-Z]").WithMessage("Password must contain uppercase letter")
            .Matches(@"[a-z]").WithMessage("Password must contain lowercase letter")
            .Matches(@"[0-9]").WithMessage("Password must contain number")
            .Matches(@"[\!\@\#\$\%\^\&\*]").WithMessage("Password must contain special character");

        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(100);
    }
}

// Application/Features/Auth/Commands/RegisterUser/RegisterUserCommandHandler.cs
public class RegisterUserCommandHandler : IRequestHandler<RegisterUserCommand, Result<UserDto>>
{
    private readonly IUserRepository _userRepository;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IMapper _mapper;

    public RegisterUserCommandHandler(
        IUserRepository userRepository,
        IPasswordHasher passwordHasher,
        IMapper mapper)
    {
        _userRepository = userRepository;
        _passwordHasher = passwordHasher;
        _mapper = mapper;
    }

    public async Task<Result<UserDto>> Handle(
        RegisterUserCommand request,
        CancellationToken cancellationToken)
    {
        // Check if user already exists
        if (await _userRepository.ExistsAsync(request.Email))
        {
            return Result<UserDto>.Failure("User with this email already exists");
        }

        // Hash password
        var passwordHash = _passwordHasher.HashPassword(request.Password);

        // Create user entity
        var user = User.Create(request.Email, passwordHash, request.Name);

        // Save to repository
        await _userRepository.AddAsync(user);

        // Map to DTO
        var userDto = _mapper.Map<UserDto>(user);

        return Result<UserDto>.Success(userDto);
    }
}
```

### Infrastructure Layer

```csharp
// Infrastructure/Persistence/ApplicationDbContext.cs
using Microsoft.EntityFrameworkCore;

namespace MyProject.Infrastructure.Persistence;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);
        base.OnModelCreating(modelBuilder);
    }
}

// Infrastructure/Persistence/Configurations/UserConfiguration.cs
public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("Users");

        builder.HasKey(u => u.Id);

        builder.Property(u => u.Email)
            .IsRequired()
            .HasMaxLength(255);

        builder.HasIndex(u => u.Email)
            .IsUnique();

        builder.Property(u => u.PasswordHash)
            .IsRequired();

        builder.Property(u => u.Name)
            .IsRequired()
            .HasMaxLength(100);
    }
}
```

## 🔄 Workflow di Sviluppo BDD/TDD

### 1. Red Phase (Scrivi test che fallisce)

```gherkin
Feature: User Registration
    Scenario: Register new user
        When I register with valid details
        Then the registration should succeed
```

```csharp
[When(@"I register with valid details")]
public async Task WhenIRegisterWithValidDetails()
{
    // Implementation che chiama l'API
}

[Then(@"the registration should succeed")]
public void ThenTheRegistrationShouldSucceed()
{
    // Assertion che fallisce perché non c'è implementazione
}
```

### 2. Green Phase (Implementa per far passare il test)

```csharp
// Implementa RegisterUserCommand e Handler
public class RegisterUserCommandHandler : IRequestHandler<RegisterUserCommand, Result>
{
    public async Task<Result> Handle(RegisterUserCommand request, CancellationToken cancellationToken)
    {
        // Implementazione minima per far passare il test
        return Result.Success();
    }
}
```

### 3. Refactor Phase (Migliora il codice)

```csharp
// Refactoring con validazione, error handling, etc.
public class RegisterUserCommandHandler : IRequestHandler<RegisterUserCommand, Result>
{
    public async Task<Result> Handle(RegisterUserCommand request, CancellationToken cancellationToken)
    {
        // Validazione
        // Business logic
        // Error handling
        // Logging
        return Result.Success();
    }
}
```

## 📚 Best Practices

### BDD Best Practices
1. **Scrivi scenari dal punto di vista dell'utente**
2. **Usa linguaggio ubiquitario del dominio**
3. **Mantieni gli step riutilizzabili**
4. **Evita dettagli tecnici nei feature file**
5. **Un scenario = un comportamento specifico**

### TDD Best Practices
1. **Red-Green-Refactor cycle**
2. **Test isolati e indipendenti**
3. **Un test = un caso specifico**
4. **Arrange-Act-Assert pattern**
5. **Mock solo ciò che è necessario**

### Clean Architecture Best Practices
1. **Dependency Inversion**: Domain non dipende da nulla
2. **Single Responsibility**: Ogni classe ha un unico scopo
3. **Interface Segregation**: Interface piccole e specifiche
4. **Separation of Concerns**: Ogni layer ha responsabilità chiare
5. **CQRS**: Separa comandi e query

## 🔗 Risorse

- [Reqnroll Documentation](https://docs.reqnroll.net/)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [.NET Architecture Guides](https://dotnet.microsoft.com/learn/dotnet/architecture-guides)
- [xUnit Documentation](https://xunit.net/)
- [FluentAssertions](https://fluentassertions.com/)

---

[← Torna alla Home](../../README.md)
