# JOGGERS - Restful Booker

A simple Node.js booking API for hotel reservations, extended as part of the SE322 Software Architecture course project.

## Original Project

Based on [restful-booker](https://github.com/mwinteringham/restful-booker) by Mark Winteringham.

## Requirements

- Node.js
- npm

## Installation

1. Clone the repo
2. Navigate into the project root folder
3. Run `npm install`
4. Run `npm start`

Or via Docker:
1. Clone the repo
2. Navigate into the project root folder
3. Run `docker-compose build`
4. Run `docker-compose up`
5. APIs are exposed on http://localhost:3001

## API Documentation

OpenAPI 3.1 specification is available at [`docs/api/openapi.yaml`](docs/api/openapi.yaml).

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/ping` | Health check |
| POST | `/auth` | Create auth token |
| GET | `/booking` | Get all booking IDs (with optional filters) |
| POST | `/booking` | Create a new booking |
| GET | `/booking/:id` | Get a specific booking |
| PUT | `/booking/:id` | Update a booking (auth required) |
| PATCH | `/booking/:id` | Partial update a booking (auth required) |
| DELETE | `/booking/:id` | Delete a booking (auth required) |
| GET | `/booking/search` | Search bookings with full object response |

## Architecture

C4 model diagrams are available in [`docs/architecture/`](docs/architecture/).

- **Level 1 - System Context**: Shows the Restful Booker system, its users (Hotel Guest, Hotel Admin), the Load Balancer, and the Warm Redundant Spare instance.
- **Level 2 - Container**: Shows the API Application, Primary Database, and Replica Database within the system.
- **Level 3 - Component**: Shows internal components of the API Application including controllers, validators, parsers, and data models.

### Architectural Tactics

| Tactic | Category | Description |
|--------|----------|-------------|
| **Warm Redundant Spare** | Availability | A standby instance of the application stays synchronized with the primary instance. If the primary fails, the Load Balancer detects the failure via the `/ping` health check endpoint and routes traffic to the spare instance, minimizing downtime. |
| **Input Validation** | Security | All incoming API requests pass through a validation and sanitization layer (Input Validator component) before being processed by any controller. This prevents malformed data, injection attacks, and ensures data integrity. |
| **Data Replication** | Reliability | The primary LokiJS database replicates data to a read replica node. This provides data redundancy — if the primary database fails, the replica contains a copy of all booking data, preventing data loss. |

### Generating Diagrams from DSL

To generate PNG diagrams from the Structurizr DSL file:

1. Go to [Structurizr Lite](https://structurizr.com/dsl) or use the Docker image
2. Upload or paste the contents of `docs/architecture/workspace.dsl`
3. Export the three diagrams as PNG files
4. Save them as:
   - `docs/architecture/level1-system-context.png`
   - `docs/architecture/level2-container.png`
   - `docs/architecture/level3-component.png`

## Project Structure

```
docs/
  api/
    openapi.yaml          # OpenAPI 3.1 specification
  architecture/
    workspace.dsl         # Structurizr C4 model definition
    level1-system-context.png
    level2-container.png
    level3-component.png
routes/
  index.js                # All API route handlers
models/
  booking.js              # Booking data model (LokiJS)
helpers/
  parser.js               # Response format parser (JSON/XML/URL-encoded)
  validator.js            # Input validation
```

## Team

JOGGERS - SE322 Spring 2025-2026
