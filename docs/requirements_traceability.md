# Phase 1 Requirements Traceability

## Functional Requirements

- **4+ models with controllers/views**
  - Models: `User`, `UserProfile`, `Category`, `Book`, `Borrowing`
  - Controllers include `UsersController`, `BooksController`, `BorrowingsController`, `Admin::*`
  - Views under `app/views/*`

- **At least 1 nested resource**
  - `resources :books do resources :borrowings, only: [:create] end`

- **At least 3 relationship types**
  - One-to-one: `User has_one UserProfile`
  - One-to-many: `Category has_many Books`, `User has_many Borrowings`, `Book has_many Borrowings`
  - Many-to-many through: `User has_many Books, through: Borrowings`

- **User authentication and authorization (from scratch)**
  - Authentication: `has_secure_password`, `SessionsController`
  - Authorization: `require_login`, `require_admin`, ownership checks

- **Sessions for logged-in users**
  - `session[:user_id]` used in `ApplicationController#current_user`

- **DRY with partials**
  - Shared and form partials: `app/views/shared/_flash.html.erb`, `app/views/users/_form.html.erb`, `app/views/admin/books/_form.html.erb`, `app/views/admin/categories/_form.html.erb`

## Technical Requirements

- **PostgreSQL**
  - `config/database.yml` uses `postgresql`

- **CSS in stylesheet**
  - Styles in `app/assets/stylesheets/application.css`

- **Seed data + test accounts**
  - `db/seeds.rb` includes admin/member users and sample domain data

- **ER diagram and app flow docs**
  - `docs/er_diagram.md`, `docs/app_flow.md`

