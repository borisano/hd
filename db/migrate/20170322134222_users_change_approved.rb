class UsersChangeApproved < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :approved, :boolean, :default => false
  end
end
