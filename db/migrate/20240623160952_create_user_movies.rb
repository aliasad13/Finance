class CreateUserMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :user_movies do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :movie, null: false, foreign_key: true, index: true

      t.timestamps
    end
    add_index :user_movies, [:user_id, :movie_id], unique: true
  end
end
