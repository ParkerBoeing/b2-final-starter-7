class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    invoice_items.sum do |invoice_item|
      applicable_discount = invoice_item.item.merchant.applicable_discount(invoice_item)
      if applicable_discount
        discount = applicable_discount.percent_discount / 100.0
        discounted_price = invoice_item.unit_price * (1 - discount)
        (invoice_item.quantity * discounted_price).round(2)
      else
        invoice_item.quantity * invoice_item.unit_price
      end
    end
  end
end
