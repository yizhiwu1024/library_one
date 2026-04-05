# Library Management System (Rails + PostgreSQL)

This project implements a role-based library management system for the course phase-1 requirements.

## Stack

- Ruby on Rails 8
- PostgreSQL
- Session-based authentication (`has_secure_password`, no Devise/CanCanCan)

## Functional Coverage

- Models: `User`, `UserProfile`, `Category`, `Book`, `Borrowing`
- Nested resource: `books/:book_id/borrowings#create`
- Relationships: one-to-one, one-to-many, many-to-many through
- Authentication + authorization + session management
- DRY partials for shared UI and forms

## Local Setup

```powershell
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
bin/rails server
```

Open `http://localhost:3000`.

## Test Accounts

- Admin: `admin@library.com` / `123456`
- Member: `user@library.com` / `123456`

## Test Suite

```powershell
bin/rails test
```

## Seed Data Includes

- Admin and member accounts
- Categories and books
- One overdue borrowing sample
- Two books with zero available copies (unavailable scenario)

## Phase-1 Submission Artifacts

- ER diagram: `docs/er_diagram.md`
- Application flow: `docs/app_flow.md`
- Requirements mapping: `docs/requirements_traceability.md`

## Deployment Notes

This app is PostgreSQL-first and can be deployed to Heroku or alternatives (Render/Railway). Ensure production DB credentials are configured via environment variables.
