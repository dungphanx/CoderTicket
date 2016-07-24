class AddOwnerStatusToEvent < ActiveRecord::Migration
  def change
    add_column :events, :owner_id, :integer
    add_column :events, :status, :boolean
  end
end
