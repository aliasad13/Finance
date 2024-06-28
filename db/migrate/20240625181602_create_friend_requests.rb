class CreateFriendRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :friend_requests do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    # Add indexes
    add_index :friend_requests, :sender_id
    add_index :friend_requests, :receiver_id
    add_index :friend_requests, [:sender_id, :receiver_id], unique: true
  end
end
