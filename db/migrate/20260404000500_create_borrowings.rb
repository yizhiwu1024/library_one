class CreateBorrowings < ActiveRecord::Migration[8.1]
  def change
    create_table :borrowings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.date :borrowed_on, null: false
      t.date :due_on, null: false
      t.date :returned_on
      t.string :status, null: false, default: "borrowed"
      t.integer :renewal_count, null: false, default: 0

      t.timestamps
    end

    add_check_constraint :borrowings,
                         "due_on >= borrowed_on",
                         name: "borrowings_due_after_borrowed"
    add_check_constraint :borrowings,
                         "renewal_count >= 0",
                         name: "borrowings_renewal_nonnegative"
  end
end

