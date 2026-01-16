# Testing Agent 🧪

## Panoramica

Il **Testing Agent** crea e esegue test per validare l'implementazione contro le specifiche, con focus su **BDD/TDD con Reqnroll e NUnit** per applicazioni .NET.

## 🎯 Capabilities

- **BDD Test Generation**: Generazione di feature file Gherkin e step definitions
- **TDD Test Generation**: Generazione di unit test con Reqnroll e NUnit
- **Test Execution**: Esecuzione automatica di test BDD e TDD
- **Coverage Analysis**: Analisi di code coverage
- **Integration Testing**: Test di integrazione per Clean Architecture

## 💻 BDD Testing con Reqnroll e NUnit

### Generazione Feature File

```gherkin
# Generated feature file
Feature: User Authentication
    Scenario: Successful login
        Given a user exists with email "test@example.com"
        When I login with valid credentials
        Then I should receive an access token
```

### Generazione Step Definitions

```csharp
// Generated step definition
[Binding]
public class AuthenticationSteps
{
    private readonly ScenarioContext _context;
    private readonly HttpClient _client;

    [When(@"I login with valid credentials")]
    public async Task WhenILoginWithValidCredentials()
    {
        var response = await _client.PostAsJsonAsync("/api/auth/login", new
        {
            Email = "test@example.com",
            Password = "password"
        });
        
        _context["LoginResponse"] = response;
    }
    
    [Then(@"I should receive an access token")]
    public async Task ThenIShouldReceiveAnAccessToken()
    {
        var response = _context["LoginResponse"] as HttpResponseMessage;
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<AuthResponse>();
        result.AccessToken.Should().NotBeNullOrEmpty();
    }
}
```

## 🔴 TDD Testing con Reqnroll e NUnit

Anche i test unitari utilizzano Reqnroll con NUnit per consistenza.

### Unit Test Generation con Feature File

```gherkin
# Generated feature file for unit tests
Feature: Register User Command Handler
    Unit tests for user registration

    Scenario: Valid command creates user
        Given a valid registration command
        When the handler processes it
        Then a user should be created
        And saved to repository
```

### Generated Step Definitions

```csharp
// Generated step definition for unit test
using NUnit.Framework;
using FluentAssertions;
using Moq;
using Reqnroll;

[Binding]
public class RegisterUserCommandSteps
{
    private readonly Mock<IUserRepository> _repositoryMock;
    private readonly RegisterUserCommandHandler _handler;
    private Result _result;

    public RegisterUserCommandSteps()
    {
        _repositoryMock = new Mock<IUserRepository>();
        _handler = new RegisterUserCommandHandler(_repositoryMock.Object);
    }

    [Given(@"a valid registration command")]
    public void GivenAValidRegistrationCommand()
    {
        var command = new RegisterUserCommand
        {
            Email = "test@example.com",
            Password = "SecurePass123!"
        };
        ScenarioContext.Current["command"] = command;
    }

    [When(@"the handler processes it")]
    public async Task WhenTheHandlerProcessesIt()
    {
        var command = ScenarioContext.Current["command"] as RegisterUserCommand;
        _result = await _handler.Handle(command, CancellationToken.None);
    }

    [Then(@"a user should be created")]
    public void ThenAUserShouldBeCreated()
    {
        _result.IsSuccess.Should().BeTrue();
    }

    [Then(@"saved to repository")]
    public void ThenSavedToRepository()
    {
        _repositoryMock.Verify(
            x => x.AddAsync(It.IsAny<User>()),
            Times.Once
        );
    }
}
```

### NUnit Traditional Tests (Opzionale)

Se necessario, puoi usare anche attributi NUnit tradizionali:

```csharp
// Traditional NUnit test
using NUnit.Framework;
using FluentAssertions;
using Moq;

[TestFixture]
public class RegisterUserCommandHandlerTests
{
    private Mock<IUserRepository> _repositoryMock;
    private RegisterUserCommandHandler _handler;

    [SetUp]
    public void Setup()
    {
        _repositoryMock = new Mock<IUserRepository>();
        _handler = new RegisterUserCommandHandler(_repositoryMock.Object);
    }

    [Test]
    public async Task Handle_ValidCommand_ShouldCreateUser()
    {
        // Arrange
        var command = new RegisterUserCommand
        {
            Email = "test@example.com",
            Password = "SecurePass123!"
        };

        // Act
        var result = await _handler.Handle(command, CancellationToken.None);

        // Assert
        result.IsSuccess.Should().BeTrue();
        _repositoryMock.Verify(
            x => x.AddAsync(It.IsAny<User>()),
            Times.Once
        );
    }

    [TestCase("")]
    [TestCase("invalid")]
    public async Task Handle_InvalidEmail_ShouldFail(string email)
    {
        // Arrange
        var command = new RegisterUserCommand { Email = email };

        // Act
        var result = await _handler.Handle(command, CancellationToken.None);

        // Assert
        result.IsSuccess.Should().BeFalse();
    }
}
```

## 🧪 Integration Testing

### Generated Integration Test

```csharp
public class OrderApiTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public OrderApiTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task CreateOrder_ValidRequest_ReturnsCreated()
    {
        // Arrange
        var request = new CreateOrderRequest
        {
            Items = new[] { new OrderItemDto { ProductId = 1, Quantity = 2 } }
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/orders", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);
    }
}
```

## 📊 Test Coverage

Il Testing Agent traccia:
- **Line Coverage**: % di linee coperte
- **Branch Coverage**: % di branch coperte  
- **Method Coverage**: % di metodi coperti
- **Class Coverage**: % di classi coperte

```bash
# Generate coverage report
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

---

[← Implementation Agent](../implementation/README.md) | [Next: Deployment Agent →](../deployment/README.md)
