class CreateWorkers < ActiveRecord::Migration[5.0]
  def change
    create_table :workers do |t|
      t.string :email, null: false
      t.timestamps
    end

    add_index :workers, :email, unique: true
  end
end
