class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.integer :percent_discount
      t.integer :quantity_threshold

      t.timestamps
    end
  end
end
