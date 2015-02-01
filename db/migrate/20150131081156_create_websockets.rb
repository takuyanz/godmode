class CreateWebsockets < ActiveRecord::Migration
  def change
    create_table :websockets do |t|

      t.timestamps
    end
  end
end
