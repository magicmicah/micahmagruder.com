class AddShowInNavToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :show_in_nav, :boolean, default: false, null: false
  end
end
