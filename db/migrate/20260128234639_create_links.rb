class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.text :comment
      t.datetime :bookmarked_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end

    add_index :links, :bookmarked_at
    add_index :links, :url
  end
end
