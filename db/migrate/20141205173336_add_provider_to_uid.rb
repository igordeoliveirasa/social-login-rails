class AddProviderToUid < ActiveRecord::Migration
  def change
    add_column :uids, :provider, :string
  end
end
