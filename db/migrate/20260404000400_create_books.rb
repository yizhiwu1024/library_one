class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.string :author, null: false
      t.string :isbn, null: false
      t.text :description
      t.integer :total_copies, null: false, default: 0
      t.integer :available_copies, null: false, default: 0

      t.timestamps
    end

    add_index :books, :isbn, unique: true
    add_check_constraint :books,
                         "available_copies <= total_copies",
                         name: "books_available_lte_total"
  end
end

