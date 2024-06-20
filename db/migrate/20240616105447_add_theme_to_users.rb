class AddThemeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :theme, :string, default: 'retro'
  end
end
