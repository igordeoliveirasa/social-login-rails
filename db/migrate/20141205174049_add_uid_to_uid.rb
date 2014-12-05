class AddUidToUid < ActiveRecord::Migration
  def change
    add_column :uids, :uid, :string
  end
end
