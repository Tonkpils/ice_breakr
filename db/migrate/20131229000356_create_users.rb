class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.references :chat_zone, index: true

      t.timestamps
    end
  end
end
