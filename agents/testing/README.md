# Testing Agent 🧪

## Panoramica

Il **Testing Agent** crea e esegue test per validare l'implementazione contro le specifiche, con focus su **BDD (Reqnroll)** e **TDD (xUnit/NUnit)** per applicazioni .NET.

## 🎯 Capabilities

- **BDD Test Generation**: Generazione di feature file Gherkin e step definitions
- **TDD Test Generation**: Generazione di unit test con xUnit/NUnit
- **Test Execution**: Esecuzione automatica di test BDD e TDD
- **Coverage Analysis**: Analisi di code coverage
- **Integration Testing**: Test di integrazione per Clean Architecture

## 💻 BDD Testing con Reqnroll

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

## 🔴 TDD Testing con xUnit

### Unit Test Generation

```csharp
// Generated unit test
public class RegisterUserCommandHandlerTests
{
    private readonly Mock<IUserRepository> _repositoryMock;
    private readonly RegisterUserCommandHandler _handler;

    public RegisterUserCommandHandlerTests()
    {
        _repositoryMock = new Mock<IUserRepository>();
        _handler = new RegisterUserCommandHandler(_repositoryMock.Object);
    }

    [Fact]
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

    [Theory]
    [InlineData("")]
    [InlineData("invalid")]
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
