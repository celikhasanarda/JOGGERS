workspace "Restful Booker" "C4 Architecture for the Restful Booker hotel booking system - SE322 Project" {

    model {
        # --- People ---
        guest = person "Hotel Guest" "A guest who makes and manages hotel bookings via the API." "Guest"
        admin = person "Hotel Admin" "An administrator who manages bookings (update/delete) with authentication." "Admin"

        # --- Software System ---
        restfulBooker = softwareSystem "Restful Booker System" "A hotel booking management system that provides RESTful API endpoints for creating, reading, updating and deleting bookings." {

            # --- Containers ---
            apiApp = container "API Application" "Provides hotel booking functionality via RESTful HTTP endpoints. Built with Node.js and Express." "Node.js / Express" "WebApp" {

                # --- Components ---
                pingController = component "Ping Controller" "Health check endpoint (GET /ping). Returns 201 if the API is running." "Express Route"
                authController = component "Auth Controller" "Handles authentication (POST /auth). Validates credentials and issues tokens." "Express Route"
                bookingController = component "Booking Controller" "Handles booking CRUD operations (GET/POST/PUT/PATCH/DELETE /booking). Manages hotel reservations." "Express Route"
                searchController = component "Search Controller" "Handles booking search (GET /booking/search). Returns full booking objects matching filter criteria." "Express Route"
                inputValidator = component "Input Validator" "Validates and sanitizes all incoming request payloads before processing. Implements Input Validation tactic." "Express Middleware" "Validator"
                responseParser = component "Response Parser" "Formats response data into JSON, XML, or URL-encoded formats based on Accept header." "Helper Module"
                bookingModel = component "Booking Model" "Data access layer for booking operations. Interfaces with the in-memory database." "Data Model"
                authMiddleware = component "Auth Middleware" "Verifies Cookie token or Basic Auth header for protected endpoints (PUT/PATCH/DELETE)." "Middleware"
            }

            database = container "Primary Database" "Stores all booking data including guest information, dates, and pricing." "LokiJS (In-Memory)" "Database"
            replicaDatabase = container "Replica Database" "Read replica of the primary database for data redundancy. Implements Data Replication tactic." "LokiJS (In-Memory)" "Database,Replica"
        }

        # --- Warm Redundant Spare (Architectural Tactic) ---
        restfulBookerSpare = softwareSystem "Warm Redundant Spare" "A standby instance of the Restful Booker system that stays synchronized and ready to take over if the primary instance fails. Implements Warm Redundant Spare availability tactic." "Spare"

        # --- External Systems ---
        loadBalancer = softwareSystem "Load Balancer / Health Monitor" "Routes traffic to the primary system. Monitors health via /ping endpoint and switches to spare instance on failure." "Infrastructure"

        # --- Relationships (System Context - Level 1) ---
        guest -> restfulBooker "Creates and views bookings" "HTTPS/JSON"
        admin -> restfulBooker "Manages bookings (update/delete)" "HTTPS/JSON with Auth"
        loadBalancer -> restfulBooker "Routes traffic and monitors health" "HTTP"
        loadBalancer -> restfulBookerSpare "Failover traffic routing when primary is down" "HTTP"
        restfulBooker -> restfulBookerSpare "Synchronizes state" "Internal Sync"

        # --- Relationships (Container - Level 2) ---
        guest -> apiApp "Makes API requests" "HTTPS/JSON"
        admin -> apiApp "Makes authenticated API requests" "HTTPS/JSON"
        apiApp -> database "Reads from and writes to" "LokiJS API"
        database -> replicaDatabase "Replicates data to" "Sync"

        # --- Relationships (Component - Level 3) ---
        guest -> pingController "Checks API health" "GET /ping"
        guest -> bookingController "Creates and views bookings" "GET/POST /booking"
        guest -> searchController "Searches bookings" "GET /booking/search"
        admin -> authController "Authenticates" "POST /auth"
        admin -> bookingController "Updates and deletes bookings" "PUT/PATCH/DELETE /booking/{id}"

        bookingController -> inputValidator "Validates request payload"
        searchController -> inputValidator "Validates query parameters"
        bookingController -> authMiddleware "Checks authentication for protected routes"
        bookingController -> bookingModel "CRUD operations"
        searchController -> bookingModel "Search operations"
        bookingController -> responseParser "Formats response"
        searchController -> responseParser "Formats response"
        authController -> authMiddleware "Issues and validates tokens"
        bookingModel -> database "Reads and writes data" "LokiJS API"
    }

    views {
        # Level 1 - System Context Diagram
        systemContext restfulBooker "SystemContext" {
            include *
            autoLayout
            title "Level 1: System Context Diagram - Restful Booker"
            description "Shows the Restful Booker system in context with its users and external systems. Includes Warm Redundant Spare for availability and Load Balancer for health monitoring."
        }

        # Level 2 - Container Diagram
        container restfulBooker "Containers" {
            include *
            include loadBalancer
            autoLayout
            title "Level 2: Container Diagram - Restful Booker"
            description "Shows the internal containers of the Restful Booker system. The API Application handles all business logic, Primary Database stores data, and Replica Database provides data redundancy."
        }

        # Level 3 - Component Diagram
        component apiApp "Components" {
            include *
            include database
            autoLayout
            title "Level 3: Component Diagram - API Application"
            description "Shows the internal components of the API Application. Input Validator implements the Input Validation tactic by sanitizing all incoming requests before processing."
        }

        styles {
            element "Person" {
                shape Person
                background #08427B
                color #ffffff
            }
            element "Guest" {
                background #08427B
            }
            element "Admin" {
                background #999999
            }
            element "Software System" {
                background #1168BD
                color #ffffff
            }
            element "Spare" {
                background #E07000
                color #ffffff
                shape RoundedBox
            }
            element "Infrastructure" {
                background #6B6B6B
                color #ffffff
            }
            element "Container" {
                background #438DD5
                color #ffffff
            }
            element "WebApp" {
                shape RoundedBox
            }
            element "Database" {
                shape Cylinder
                background #438DD5
            }
            element "Replica" {
                background #E07000
                color #ffffff
            }
            element "Component" {
                background #85BBF0
                color #000000
            }
            element "Validator" {
                background #E07000
                color #ffffff
                shape RoundedBox
            }
        }
    }

}
