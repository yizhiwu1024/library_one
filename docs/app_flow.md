# Application Flow

## Member Flow

1. User signs up with email and password.
2. User signs in (session stores `user_id`).
3. User browses/searches books.
4. User opens a book detail page and clicks **Borrow**.
5. System enforces rules:
   - user must be `member`
   - active borrowings < 5
   - `available_copies > 0`
6. User can view own borrowings, renew once (+10 days), or return.

## Admin Flow

1. Admin signs in.
2. Admin opens dashboard and views key metrics.
3. Admin manages books and categories (CRUD).
4. Admin manages users (role/status/profile updates).
5. Admin reviews and updates borrowing records.

## Authentication and Authorization

- Authentication uses `has_secure_password` and session-based login.
- Authorization is enforced by `require_login` and `require_admin` guards.
- Members can only mutate their own borrowing records.

