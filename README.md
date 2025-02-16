# Project Title

## Description
This project is a Ruby on Rails application that provides an API for managing users, follows, and clock records. It follows Domain-Driven Design (DDD) principles.

## Installation

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/w-bt/good-night.git
cd good-night
```

### 2️⃣ Install Dependencies
```sh
bundle install
```

### 3️⃣ Set Up the Database
```sh
rails db:create
rails db:migrate
```
Generate dummy application and authentication tokens for local testing:
```sh
rake doorkeeper:generate_application
rake auth:dummy
```
(Optional) Generate more data for testing:
```sh
rails db:seed
```

## Usage

### Start the Rails Server
```sh
rails server
```
Access the application at [http://localhost:3000](http://localhost:3000).

---

## Linting
Run the lint suite:
```sh
make lint
# or
make all
```

## Testing
Run the test suite:
```sh
make test
# or
make all
```

---

## API Documentation
The API documentation is available in the **`swagger/v1/swagger.yaml`** file.

To interact with the API using Swagger UI, open:
[http://localhost:3000/api-docs/index.html](http://localhost:3000/api-docs/index.html)

---

## Endpoints

### **Oauth Token**
- `POST /oauth/token` → Create token for authentication

### **Users**
- `GET /api/v1/users` → List all users
- `POST /api/v1/users` → Create a new user
- `GET /api/v1/users/{id}` → Get a user by ID
- `PUT /api/v1/users/{id}` → Update a user by ID
- `DELETE /api/v1/users/{id}` → Delete a user by ID

### **Follows**
- `GET /api/v1/users/{id}/followers` → Get followers of the user
- `GET /api/v1/users/{id}/followees` → Get followees of the user
- `POST /api/v1/users/{id}/followees` → Follow or unfollow a user

### **Clocks**
- `POST /api/v1/users/{id}/clocks` → Clock in or clock out a user
- `GET /api/v1/users/{id}/clocks` → Get list of clock records for a user
- `GET /api/v1/users/{id}/followees_clock/daily` → Get followees' clock daily records
- `GET /api/v1/users/{id}/followees_clock/weekly` → Get followees' clock weekly records

---

## 🔥 What’s Next?

To improve performance, scalability, and reliability, here are some recommended next steps:

### 1️⃣ **Implement Database Partitioning**
- **Why?** The `clocks`, `clock_dailies`, and `clock_weeklies` tables will grow significantly over time.
- **Solution:** Use **pg_partman** or **native Postgres partitioning** to:
  - Partition `clocks` **daily** and retain data for **1 year**.
  - Partition `clock_dailies` **daily** and retain data for **1 year**.
  - Partition `clock_weeklies` **monthly** and retain data for **1 year**.
- **Benefit:** Improves query performance and reduces index bloat.

### 2️⃣ **Implement Proxy Cache in Nginx**
- **Why?** Reducing backend load for frequently accessed API responses.
- **Solution:** Configure **Nginx reverse proxy cache** for endpoints like:
  - `GET /api/v1/users/{id}`
  - `GET /api/v1/users/{id}/followers`
  - `GET /api/v1/users/{id}/followees`
  - `GET /api/v1/users/{id}/followees_clock/daily`
  - `GET /api/v1/users/{id}/followees_clock/weekly`
- **Benefit:** Decreases response time and offloads traffic from Rails.

### 3️⃣ **Implement Background Job Scheduling**
- **Why?** Some tasks (e.g., analytics, report generation) should run asynchronously.
- **Solution:** Use **Sidekiq (preferred)** for:
  - Nightly report aggregation
  - Cleaning up expired records
  - Sending notifications
- **Benefit:** Sidekiq provides better control over job retries compared to Active Job. It allows for more fine-grained management of retry logic, including custom retry intervals, exponential backoff, and error handling..

### 4️⃣ **Introduce Rate Limiting**
- **Why?** Prevent API abuse and improve fairness in resource usage.
- **Solution:** Use **Rack::Attack** to limit:
  - Requests per user per minute (`X requests/min`)
  - Login attempts to prevent brute force attacks
- **Benefit:** Improves security and API stability.

### 5️⃣ **Implement Elasticsearch**
- **Why?** Advanced reporting and analytics require efficient data retrieval and aggregation.
- **Solution:** Integrate Elasticsearch to handle search queries and aggregations on clock data.
- **Benefit:** Enables faster and more complex reporting capabilities.

---

## 🚀 Contributing
Contributions are welcome! Please follow the standard **GitHub Flow**:
1. Fork the repository
2. Create a new branch (`feature-branch`)
3. Commit changes with clear messages
4. Push to your fork and create a PR

---

## 📝 License
This project is licensed under the **MIT License**.

