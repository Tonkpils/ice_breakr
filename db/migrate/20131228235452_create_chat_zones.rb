class CreateChatZones < ActiveRecord::Migration
  def change
    create_table :chat_zones do |t|
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
