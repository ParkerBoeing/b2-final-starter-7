class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  enum status: [:enabled, :disabled]

  def favorite_customers
    transactions.joins(invoice: :customer)
                .where('result = ?', 1)
                .where("invoices.status = ?", 2)
                .select("customers.*, count('transactions.result') as top_result")
                .group('customers.id')
                .order(top_result: :desc)
                .distinct
                .limit(5)
  end

  def ordered_items_to_ship
    item_ids = InvoiceItem.where("status = 0 OR status = 1").order(:created_at).pluck(:item_id)
    item_ids.map do |id|
      Item.find(id)
    end
  end

  def top_5_items
    items
    .joins(invoices: :transactions)
    .where('transactions.result = 1')
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    .group(:id)
    .order('total_revenue desc')
    .limit(5)
   end

  def self.top_merchants
    joins(invoices: [:invoice_items, :transactions])
    .where('result = ?', 1)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .group(:id)
    .order('total_revenue DESC')
    .limit(5)
  end

  def best_day
    invoices.where("invoices.status = 2")
            .joins(:invoice_items)
            .select('invoices.created_at, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
            .group("invoices.created_at")
            .order("revenue desc", "invoices.created_at desc")
            .first&.created_at&.to_date
  end

  def enabled_items
    items.where(status: 1)
  end

  def disabled_items
    items.where(status: 0)
  end

  def revenue_for_invoice(invoice_id)
    invoice_items.joins(:item)
                 .where("items.merchant_id = ?", self.id)
                 .where("invoice_items.invoice_id = ?", invoice_id)
                 .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def discounted_revenue_for_invoice(invoice_id)
  
    invoice_items.where("invoice_items.invoice_id = ?", invoice_id).sum do |ii|
      applicable_discount = self.applicable_discount(ii)
                               
      if applicable_discount
        discounted_price = ii.unit_price * (1 - applicable_discount.percent_discount/100.0)
        discounted_price * ii.quantity
      else
        ii.unit_price * ii.quantity
      end
    end
  end

  def applicable_discount(invoice_item)
    bulk_discounts
                .where("bulk_discounts.quantity_threshold <= ?", invoice_item.quantity)
                .order(percent_discount: :desc)
                .first
  end
end
