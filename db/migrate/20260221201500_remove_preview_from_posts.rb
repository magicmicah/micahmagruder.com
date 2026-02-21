class RemovePreviewFromPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :preview, :string
  end
end
