class CreateUids < ActiveRecord::Migration
  def change
    create_table :uids do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
