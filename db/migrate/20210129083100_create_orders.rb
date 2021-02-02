class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.float :total, null: false
      t.references :cart, null: true

      t.timestamps
    end
  end
end
