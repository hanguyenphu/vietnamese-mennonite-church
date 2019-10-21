class CreateReceipts < ActiveRecord::Migration[6.0]
  def change
    create_table :receipts do |t|
      t.integer :number
      t.integer :donation_year
      t.float :amount
      t.text :description
      t.references :member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
