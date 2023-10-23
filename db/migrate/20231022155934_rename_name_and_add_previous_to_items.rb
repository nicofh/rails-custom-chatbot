class RenameNameAndAddPreviousToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :previous_item, foreign_key: { to_table: :items }, null: true
    rename_column :items, :page_name, :name
  end
end
