# ER Diagram (Text Version)

```text
User (1) ------ (1) UserProfile
  |
  | (1)
  |------< Borrowing >------(1) Book >------(1) Category
               |
               | many-to-many bridge
               v
             User <------through Borrowing------> Book
```

## Tables and Key Fields

- `users`: `email`, `password_digest`, `role`, `status`
- `user_profiles`: `user_id`, `full_name`, `phone`, `address`
- `categories`: `name`
- `books`: `category_id`, `title`, `author`, `isbn`, `description`, `total_copies`, `available_copies`
- `borrowings`: `user_id`, `book_id`, `borrowed_on`, `due_on`, `returned_on`, `status`, `renewal_count`

## Constraints

- `books.available_copies <= books.total_copies`
- `borrowings.due_on >= borrowings.borrowed_on`
- `borrowings.renewal_count >= 0`

