class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :reported_by_id
      t.integer :assigned_to_id
      t.integer :request_type_id
      t.boolean :member_facing
      t.integer :vertical_id
      t.date :required_by
      t.string :link
      t.integer :priority_id
      t.integer :status_id
      t.timestamps
    end
  end
end
