class AddPreviewToPost < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :preview, :string
  end
end
