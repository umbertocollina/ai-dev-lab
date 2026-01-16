# .NET Clean Architecture Example con BDD/TDD

Esempio completo di applicazione .NET che implementa Clean Architecture con BDD (Reqnroll) e TDD.

## 📋 Progetto: Sistema di Gestione Ordini E-commerce

### Requisiti Funzionali

- Gestione prodotti (CRUD)
- Gestione ordini
- Autenticazione e autorizzazione utenti
- Gestione carrello
- Processo di checkout

### Stack Tecnologico

```
- .NET 8.0
- ASP.NET Core Web API
- Entity Framework Core
- SQL Server / PostgreSQL
- Reqnroll (BDD)
- NUnit (unit testing con Reqnroll)
- MediatR (CQRS)
- FluentValidation
- AutoMapper
```

## 🏗️ Struttura della Solution

```
OrderManagement/
├── src/
│   ├── OrderManagement.Domain/
│   │   ├── Entities/
│   │   │   ├── Order.cs
│   │   │   ├── OrderItem.cs
│   │   │   ├── Product.cs
│   │   │   └── User.cs
│   │   ├── ValueObjects/
│   │   │   ├── Money.cs
│   │   │   └── Address.cs
│   │   ├── Enums/
│   │   │   └── OrderStatus.cs
│   │   └── Interfaces/
│   │       ├── IOrderRepository.cs
│   │       └── IProductRepository.cs
│   │
│   ├── OrderManagement.Application/
│   │   ├── Common/
│   │   │   ├── Interfaces/
│   │   │   ├── Behaviours/
│   │   │   │   ├── ValidationBehaviour.cs
│   │   │   │   └── LoggingBehaviour.cs
│   │   │   └── Mappings/
│   │   │       └── MappingProfile.cs
│   │   ├── Features/
│   │   │   ├── Orders/
│   │   │   │   ├── Commands/
│   │   │   │   │   ├── CreateOrder/
│   │   │   │   │   ├── UpdateOrderStatus/
│   │   │   │   │   └── CancelOrder/
│   │   │   │   ├── Queries/
│   │   │   │   │   ├── GetOrderById/
│   │   │   │   │   └── GetOrders/
│   │   │   │   └── DTOs/
│   │   │   └── Products/
│   │   │       ├── Commands/
│   │   │       ├── Queries/
│   │   │       └── DTOs/
│   │   └── DependencyInjection.cs
│   │
│   ├── OrderManagement.Infrastructure/
│   │   ├── Persistence/
│   │   │   ├── ApplicationDbContext.cs
│   │   │   ├── Configurations/
│   │   │   ├── Migrations/
│   │   │   └── Repositories/
│   │   ├── Identity/
│   │   ├── Services/
│   │   └── DependencyInjection.cs
│   │
│   └── OrderManagement.WebApi/
│       ├── Controllers/
│       │   ├── OrdersController.cs
│       │   └── ProductsController.cs
│       ├── Filters/
│       ├── Middleware/
│       ├── appsettings.json
│       └── Program.cs
│
└── tests/
    ├── OrderManagement.Domain.UnitTests/
    │   ├── Entities/
    │   └── ValueObjects/
    │
    ├── OrderManagement.Application.UnitTests/
    │   └── Features/
    │       └── Orders/
    │           ├── Commands/
    │           └── Queries/
    │
    ├── OrderManagement.Application.IntegrationTests/
    │   ├── Features/
    │   └── Infrastructure/
    │
    └── OrderManagement.Application.AcceptanceTests/
        ├── Features/
        │   ├── OrderManagement.feature
        │   ├── ProductManagement.feature
        │   └── UserAuthentication.feature
        ├── StepDefinitions/
        │   ├── OrderManagementSteps.cs
        │   └── ProductManagementSteps.cs
        ├── Hooks/
        │   └── TestHooks.cs
        └── Support/
            └── TestContext.cs
```

## 🧪 Feature File: Order Management

```gherkin
# Features/OrderManagement.feature
Feature: Order Management
    As a customer
    I want to manage my orders
    So that I can purchase products

    Background:
        Given the system is running
        And the following products exist:
            | Id | Name           | Price | Stock |
            | 1  | Laptop         | 999   | 10    |
            | 2  | Mouse          | 29    | 50    |
            | 3  | Keyboard       | 79    | 30    |
        And I am authenticated as "customer@example.com"

    Scenario: Create a new order successfully
        When I create an order with the following items:
            | ProductId | Quantity |
            | 1         | 1        |
            | 2         | 2        |
        Then the order should be created successfully
        And the order total should be 1057
        And the order status should be "Pending"
        And the product stocks should be updated:
            | ProductId | NewStock |
            | 1         | 9        |
            | 2         | 48       |

    Scenario: Cannot create order with insufficient stock
        Given product "1" has stock of 0
        When I create an order with product "1" and quantity 1
        Then the order creation should fail
        And I should see error "Insufficient stock"

    Scenario: View order details
        Given I have an existing order with id "order-123"
        When I view order details for "order-123"
        Then I should see the order information:
            | Field      | Value   |
            | Id         | order-123 |
            | Status     | Pending |
            | TotalAmount| 1057    |
        And I should see the order items

    Scenario: Cancel an order
        Given I have an order with id "order-456" and status "Pending"
        When I cancel order "order-456"
        Then the order status should change to "Cancelled"
        And the product stocks should be restored

    Scenario Outline: Update order status
        Given I have an order with id "order-789" and status "<CurrentStatus>"
        When I update order status to "<NewStatus>"
        Then the status update should be "<Result>"

        Examples:
            | CurrentStatus | NewStatus  | Result  |
            | Pending       | Processing | Success |
            | Processing    | Shipped    | Success |
            | Shipped       | Delivered  | Success |
            | Delivered     | Processing | Failure |
            | Cancelled     | Processing | Failure |
```

## 📝 Step Definitions

```csharp
// StepDefinitions/OrderManagementSteps.cs
using Reqnroll;
using NUnit.Framework;
using FluentAssertions;
using OrderManagement.Application.Features.Orders.Commands;
using OrderManagement.Application.Features.Orders.DTOs;

[Binding]
public class OrderManagementSteps
{
    private readonly ScenarioContext _scenarioContext;
    private readonly HttpClient _client;
    private HttpResponseMessage? _response;
    private OrderDto? _orderResult;

    public OrderManagementSteps(ScenarioContext scenarioContext, HttpClient client)
    {
        _scenarioContext = scenarioContext;
        _client = client;
    }

    [Given(@"the following products exist:")]
    public async Task GivenTheFollowingProductsExist(Table table)
    {
        foreach (var row in table.Rows)
        {
            var product = new
            {
                Id = int.Parse(row["Id"]),
                Name = row["Name"],
                Price = decimal.Parse(row["Price"]),
                Stock = int.Parse(row["Stock"])
            };

            await _client.PostAsJsonAsync("/api/products", product);
        }
    }

    [Given(@"I am authenticated as ""(.*)""")]
    public async Task GivenIAmAuthenticatedAs(string email)
    {
        // Setup authentication
        var loginResponse = await _client.PostAsJsonAsync("/api/auth/login", new
        {
            Email = email,
            Password = "test"
        });

        var result = await loginResponse.Content.ReadFromJsonAsync<dynamic>();
        var token = result?.AccessToken;

        _client.DefaultRequestHeaders.Authorization = 
            new AuthenticationHeaderValue("******", token);
    }

    [When(@"I create an order with the following items:")]
    public async Task WhenICreateAnOrderWithTheFollowingItems(Table table)
    {
        var items = table.Rows.Select(row => new
        {
            ProductId = int.Parse(row["ProductId"]),
            Quantity = int.Parse(row["Quantity"])
        }).ToList();

        _response = await _client.PostAsJsonAsync("/api/orders", new
        {
            Items = items
        });

        if (_response.IsSuccessStatusCode)
        {
            _orderResult = await _response.Content.ReadFromJsonAsync<OrderDto>();
        }
    }

    [Then(@"the order should be created successfully")]
    public void ThenTheOrderShouldBeCreatedSuccessfully()
    {
        _response.Should().NotBeNull();
        _response!.StatusCode.Should().Be(HttpStatusCode.Created);
        _orderResult.Should().NotBeNull();
    }

    [Then(@"the order total should be (.*)")]
    public void ThenTheOrderTotalShouldBe(decimal expectedTotal)
    {
        _orderResult.Should().NotBeNull();
        _orderResult!.TotalAmount.Should().Be(expectedTotal);
    }

    [Then(@"the order status should be ""(.*)""")]
    public void ThenTheOrderStatusShouldBe(string expectedStatus)
    {
        _orderResult.Should().NotBeNull();
        _orderResult!.Status.Should().Be(expectedStatus);
    }

    [Then(@"the product stocks should be updated:")]
    public async Task ThenTheProductStocksShouldBeUpdated(Table table)
    {
        foreach (var row in table.Rows)
        {
            var productId = int.Parse(row["ProductId"]);
            var expectedStock = int.Parse(row["NewStock"]);

            var product = await _client.GetFromJsonAsync<ProductDto>($"/api/products/{productId}");
            product.Should().NotBeNull();
            product!.Stock.Should().Be(expectedStock);
        }
    }
}
```

## 🔴 Unit Test Example

```csharp
// Application.UnitTests/Features/Orders/Commands/CreateOrderCommand.feature
Feature: Create Order Command
    Unit tests for creating orders

    Scenario: Handle valid command should create order
        Given a valid create order command
        When the handler processes the command
        Then the order should be created
        And the order total should be calculated correctly

    Scenario: Handle insufficient stock should return error
        Given a create order command with quantity 20 for product with stock 10
        When the handler processes the command
        Then the result should fail
        And the error should mention "Insufficient stock"
```

```csharp
// Application.UnitTests/StepDefinitions/CreateOrderCommandSteps.cs
using NUnit.Framework;
using FluentAssertions;
using Moq;
using Reqnroll;
using OrderManagement.Application.Features.Orders.Commands.CreateOrder;

[Binding]
public class CreateOrderCommandSteps
{
    private Mock<IOrderRepository> _orderRepositoryMock;
    private Mock<IProductRepository> _productRepositoryMock;
    private CreateOrderCommandHandler _handler;
    private CreateOrderCommand _command;
    private Result _result;

    [BeforeScenario]
    public void Setup()
    {
        _orderRepositoryMock = new Mock<IOrderRepository>();
        _productRepositoryMock = new Mock<IProductRepository>();
        _handler = new CreateOrderCommandHandler(
            _orderRepositoryMock.Object,
            _productRepositoryMock.Object
        );
    }

    [Given(@"a valid create order command")]
    public void GivenAValidCreateOrderCommand()
    {
        _command = new CreateOrderCommand
        {
            Items = new List<OrderItemDto>
            {
                new() { ProductId = 1, Quantity = 2 },
                new() { ProductId = 2, Quantity = 1 }
            }
        };

        var product1 = Product.Create("Laptop", 999m, 10);
        var product2 = Product.Create("Mouse", 29m, 50);

        _productRepositoryMock
            .Setup(x => x.GetByIdAsync(1))
            .ReturnsAsync(product1);

        _productRepositoryMock
            .Setup(x => x.GetByIdAsync(2))
            .ReturnsAsync(product2);
    }

    [Given(@"a create order command with quantity (.*) for product with stock (.*)")]
    public void GivenACreateOrderCommandWithQuantityForProductWithStock(int quantity, int stock)
    {
        _command = new CreateOrderCommand
        {
            Items = new List<OrderItemDto>
            {
                new() { ProductId = 1, Quantity = quantity }
            }
        };

        var product = Product.Create("Laptop", 999m, stock);
        _productRepositoryMock
            .Setup(x => x.GetByIdAsync(1))
            .ReturnsAsync(product);
    }

    [When(@"the handler processes the command")]
    public async Task WhenTheHandlerProcessesTheCommand()
    {
        _result = await _handler.Handle(_command, CancellationToken.None);
    }

    [Then(@"the order should be created")]
    public void ThenTheOrderShouldBeCreated()
    {
        _result.Should().NotBeNull();
        _result.IsSuccess.Should().BeTrue();
    }

    [Then(@"the order total should be calculated correctly")]
    public void ThenTheOrderTotalShouldBeCalculatedCorrectly()
    {
        _result.Value.TotalAmount.Should().Be(2027m); // (999*2 + 29*1)
    }

    [Then(@"the result should fail")]
    public void ThenTheResultShouldFail()
    {
        _result.IsSuccess.Should().BeFalse();
    }

    [Then(@"the error should mention ""(.*)""")]
    public void ThenTheErrorShouldMention(string errorText)
    {
        _result.Errors.Should().Contain(e => e.Contains(errorText));
    }
}
```
```

## 🏛️ Domain Entity Example

```csharp
// Domain/Entities/Order.cs
namespace OrderManagement.Domain.Entities;

public class Order : BaseEntity
{
    private readonly List<OrderItem> _items = new();

    public string OrderNumber { get; private set; }
    public Guid UserId { get; private set; }
    public OrderStatus Status { get; private set; }
    public Money TotalAmount { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime? CompletedAt { get; private set; }

    public IReadOnlyCollection<OrderItem> Items => _items.AsReadOnly();

    private Order() { } // For EF Core

    public static Order Create(Guid userId, IEnumerable<OrderItem> items)
    {
        if (!items.Any())
            throw new DomainException("Order must contain at least one item");

        var order = new Order
        {
            Id = Guid.NewGuid(),
            OrderNumber = GenerateOrderNumber(),
            UserId = userId,
            Status = OrderStatus.Pending,
            CreatedAt = DateTime.UtcNow
        };

        foreach (var item in items)
        {
            order._items.Add(item);
        }

        order.CalculateTotalAmount();
        order.AddDomainEvent(new OrderCreatedEvent(order));

        return order;
    }

    public Result UpdateStatus(OrderStatus newStatus)
    {
        if (!CanTransitionTo(newStatus))
        {
            return Result.Failure($"Cannot transition from {Status} to {newStatus}");
        }

        Status = newStatus;
        
        if (newStatus == OrderStatus.Completed)
        {
            CompletedAt = DateTime.UtcNow;
        }

        AddDomainEvent(new OrderStatusChangedEvent(this, newStatus));
        return Result.Success();
    }

    public Result Cancel()
    {
        if (Status != OrderStatus.Pending && Status != OrderStatus.Processing)
        {
            return Result.Failure("Can only cancel pending or processing orders");
        }

        Status = OrderStatus.Cancelled;
        AddDomainEvent(new OrderCancelledEvent(this));
        return Result.Success();
    }

    private void CalculateTotalAmount()
    {
        var total = _items.Sum(i => i.SubTotal.Amount);
        TotalAmount = Money.Create(total, "EUR");
    }

    private bool CanTransitionTo(OrderStatus newStatus)
    {
        return (Status, newStatus) switch
        {
            (OrderStatus.Pending, OrderStatus.Processing) => true,
            (OrderStatus.Processing, OrderStatus.Shipped) => true,
            (OrderStatus.Shipped, OrderStatus.Delivered) => true,
            (OrderStatus.Delivered, OrderStatus.Completed) => true,
            _ => false
        };
    }

    private static string GenerateOrderNumber()
    {
        return $"ORD-{DateTime.UtcNow:yyyyMMdd}-{Guid.NewGuid().ToString()[..8].ToUpper()}";
    }
}
```

## 🚀 Come Eseguire l'Esempio

### Setup

```bash
# Clone repository
git clone https://github.com/umbertocollina/ai-dev-lab.git
cd ai-dev-lab/examples/dotnet-clean-architecture

# Restore dependencies
dotnet restore

# Setup database
cd src/OrderManagement.Infrastructure
dotnet ef database update

# Run application
cd ../OrderManagement.WebApi
dotnet run
```

### Run Tests

```bash
# Run all tests
dotnet test

# Run unit tests only
dotnet test --filter Category=Unit

# Run BDD acceptance tests
dotnet test --filter Category=Acceptance

# Run with coverage
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

## 📚 Cosa Dimostra Questo Esempio

1. **Clean Architecture**: Separazione chiara dei layer (Domain, Application, Infrastructure, Presentation)
2. **BDD con Reqnroll**: Feature file in Gherkin con step definitions complete
3. **TDD con Reqnroll e NUnit**: Unit test con feature file Gherkin per consistenza
4. **CQRS**: Separazione comandi e query con MediatR
5. **Domain-Driven Design**: Rich domain model con business logic nel Domain
6. **Repository Pattern**: Astrazione dell'accesso ai dati
7. **Validation**: FluentValidation per validazione input
8. **Mapping**: AutoMapper per mapping DTOs

---

[← Back to .NET Development](../../docs/dotnet-development/README.md)
