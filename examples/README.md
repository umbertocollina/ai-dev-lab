# Complete Example: E-commerce Product Catalog

This example demonstrates a complete workflow from requirements to implementation for an e-commerce product catalog service.

## 📋 Requirements

See [requirements.yaml](requirements.yaml) for formal requirements specification.

**Summary**:
- RESTful API for product management
- CRUD operations on products
- Search and filtering
- Categories management
- Image upload support

## 🏗️ Architecture

See [architecture.md](architecture.md) for architecture decisions.

**Stack**:
- **Backend**: Node.js with Express
- **Database**: PostgreSQL
- **Storage**: AWS S3 for images
- **API**: RESTful with OpenAPI 3.0

## 📝 Specifications

- [API Specification](api-spec.yaml) - OpenAPI 3.0
- [Database Schema](db-schema.sql)
- [Data Models](models.json)

## 🔄 Workflow

This example was created using the following workflow:

```bash
# 1. Define requirements
# Created requirements.yaml from business needs

# 2. Design architecture
# Used DesignAgent to suggest architecture patterns

# 3. Create API specification
# Wrote OpenAPI spec following requirements

# 4. Generate implementation
# Used ImplementationAgent to generate boilerplate

# 5. Add business logic
# Implemented domain-specific logic

# 6. Generate tests
# Used TestingAgent to create test suites

# 7. Deploy
# Used DeploymentAgent for containerization
```

## 🚀 Running the Example

### Prerequisites
```bash
node >= 18.0.0
docker
docker-compose
```

### Setup

```bash
# Install dependencies
npm install

# Start database
docker-compose up -d

# Run migrations
npm run migrate

# Start server
npm run dev
```

### API Endpoints

```bash
# Health check
curl http://localhost:3000/health

# List products
curl http://localhost:3000/api/products

# Get product
curl http://localhost:3000/api/products/{id}

# Create product (requires auth)
curl -X POST http://localhost:3000/api/products \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Product Name",
    "description": "Description",
    "price": 29.99,
    "categoryId": "cat-123"
  }'
```

## 🧪 Testing

```bash
# Run unit tests
npm test

# Run integration tests
npm run test:integration

# Run e2e tests
npm run test:e2e

# Coverage report
npm run test:coverage
```

## 📚 Key Learnings

### What Worked Well

1. **Spec-First Approach**: Writing OpenAPI spec first clarified requirements
2. **Agent Collaboration**: Using multiple agents reduced boilerplate
3. **Test Generation**: Auto-generated tests covered 80% of cases
4. **Documentation**: API docs auto-generated from spec

### Challenges

1. **Business Logic**: AI needed guidance for domain-specific logic
2. **Error Handling**: Required manual refinement
3. **Performance**: Optimization needed human expertise

### Best Practices Applied

- ✅ OpenAPI spec as single source of truth
- ✅ Generated code reviewed before commit
- ✅ Manual tests for edge cases
- ✅ Human oversight for critical decisions

## 🔗 Files in This Example

```
examples/ecommerce-catalog/
├── README.md                 # This file
├── requirements.yaml         # Formal requirements
├── architecture.md           # Architecture decisions
├── api-spec.yaml            # OpenAPI specification
├── db-schema.sql            # Database schema
├── models.json              # Data models
├── package.json             # Dependencies
├── docker-compose.yaml      # Development environment
├── src/                     # Source code
│   ├── index.js
│   ├── routes/
│   ├── controllers/
│   ├── models/
│   ├── services/
│   └── middleware/
├── tests/                   # Test suites
│   ├── unit/
│   ├── integration/
│   └── e2e/
└── docs/                    # Additional documentation
```

## 💡 Using This Example

### As a Template

Copy this structure for similar projects:

```bash
cp -r examples/ecommerce-catalog my-new-project
cd my-new-project
# Update files with your requirements
```

### As a Learning Resource

Study how:
- Requirements are formalized
- Specifications are written
- Agents are used in workflow
- Code is structured
- Tests are organized

### As a Proof of Concept

Demonstrate AI-powered development to your team:
- Show the workflow
- Compare with traditional approach
- Measure time savings
- Evaluate code quality

---

[← Back to Examples](../README.md)
