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

## Project Structure

```
docs/
  api/
    openapi.yaml          # OpenAPI 3.1 specification
  architecture/           # C4 diagrams (Phase 3)
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
