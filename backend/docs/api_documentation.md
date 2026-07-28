# NewsX REST API Specification

**Base Path**: `/api/v1`

---

## Authentication Endpoints

### 1. Register User
- **POST** `/auth/register`
- **Body**: `{ "firebaseToken": "string", "name": "string", "email": "string" }`
- **Response**: `{ "status": "success", "data": { "token": "JWT_TOKEN", "user": { ... } } }`

### 2. Login User
- **POST** `/auth/login`
- **Body**: `{ "firebaseToken": "string" }`
- **Response**: `{ "status": "success", "data": { "token": "JWT_TOKEN", "user": { ... } } }`

### 3. Logout
- **POST** `/auth/logout`

---

## User Endpoints

### 4. Get User Profile
- **GET** `/user/profile`
- **Headers**: `Authorization: Bearer <JWT_TOKEN>`

### 5. Update Profile
- **PUT** `/user/profile`
- **Body**: `{ "name": "New Name", "bio": "Bio text", "language": "English", "theme": "dark" }`

### 6. User Preferences
- **GET** `/user/preferences`
- **PUT** `/user/preferences` -> `{ "categories": ["AI", "Tech", "Cricket"] }`

---

## Content & Interactions

### 7. Bookmarks
- **GET** `/bookmarks`
- **POST** `/bookmarks` -> `{ "news_id": "news_1" }`
- **DELETE** `/bookmarks/:id`

### 8. Likes & Shares
- **POST** `/likes` -> `{ "news_id": "news_1" }`
- **DELETE** `/likes/:id`
- **POST** `/shares` -> `{ "news_id": "news_1" }`

### 9. Reading History
- **GET** `/history`
- **POST** `/history` -> `{ "news_id": "news_1", "reading_time": "1 min" }`

### 10. Search & Categories
- **GET** `/categories`
- **GET** `/search?keyword=AI&category=Tech&language=English`
