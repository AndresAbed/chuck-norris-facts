class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.string :category
      t.string :url
      t.text :value
      t.integer :search_id

      t.timestamps
    end
  end
end
