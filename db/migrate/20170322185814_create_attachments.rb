class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.integer :task_id
      t.string :doc

      t.timestamps
    end
  end
end
