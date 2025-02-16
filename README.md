# Project Title

## Description
This project is a **Ruby on Rails** application that provides an **API for managing users, follows, and clock records**. It follows **Domain-Driven Design (DDD) principles**.

---

## Installation

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/w-bt/good-night.git
cd your-repo
```

### 2️⃣ Install Dependencies
```sh
bundle install
```

### 3️⃣ Set Up the Database
```sh
rails db:create
rails db:migrate
rails db:seed
```

---

## Usage
### Start the Rails Server
```sh
rails server
```
Access the application at **[http://localhost:3000](http://localhost:3000)**.

---

## Linting
Run the lint suite:
```sh
make lint
# or
make all
```

---

## Testing
Run the test suite:
```sh
make test
# or
make all
```

---

## API Documentation
The **API documentation** is available in the `swagger/v1/swagger.yaml` file (**[http://localhost:3000/api-docs/index.html](http://localhost:3000/api-docs/index.html)**).  
You can use **Swagger UI** to view and interact with the API.

---

## Endpoints

### Users
- **GET** `/api/v1/users` → List all users
- **POST** `/api/v1/users` → Create a new user
- **GET** `/api/v1/users/{id}` → Get a user by ID
- **PUT** `/api/v1/users/{id}` → Update a user by ID
- **DELETE** `/api/v1/users/{id}` → Delete a user by ID

### Follows
- **GET** `/api/v1/users/{id}/followers` → Get followers of the user
- **GET** `/api/v1/users/{id}/followees` → Get followees of the user
- **POST** `/api/v1/users/{id}/followees` → Follow or unfollow a user

### Clocks
- **POST** `/api/v1/users/{id}/clocks` → Clock in or clock out a user
- **GET** `/api/v1/users/{id}/clocks` → Get list of clock records for a user
- **GET** `/api/v1/users/{id}/followees_clock/daily` → Get followees' clock daily records
- **GET** `/api/v1/users/{id}/followees_clock/weekly` → Get followees' clock weekly records

---
