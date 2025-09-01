class CreateFamousQuotes < ActiveRecord::Migration[7.2]
  def change
    create_table :famous_quotes do |t|
      t.string :content, null: false
      t.string :author, null: false

      t.timestamps
    end
  end
end
