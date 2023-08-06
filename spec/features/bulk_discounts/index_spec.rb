require "rails_helper"

describe "merchant bulk_discounts index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
    @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)

    @discount_1 = BulkDiscount.create!(quantity_threshold: 5, percent_discount: 10, merchant: @merchant1)
    @discount_2 = BulkDiscount.create!(quantity_threshold: 7, percent_discount: 12,merchant: @merchant1)
    @discount_3 = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 15,merchant: @merchant1)
    @discount_4 = BulkDiscount.create!(quantity_threshold: 12, percent_discount: 17,merchant: @merchant1)
    @discount_5 = BulkDiscount.create!(quantity_threshold: 15, percent_discount: 20,merchant: @merchant1)
    @discount_6 = BulkDiscount.create!(quantity_threshold: 20, percent_discount: 25,merchant: @merchant2)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  it "can see all bulk discount ids and attributes that are associated with the merchant" do
    expect(page).to have_content(@discount_1.id)
    expect(page).to have_content(@discount_1.percent_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
    expect(page).to have_content(@discount_2.id)
    expect(page).to have_content(@discount_3.id)
    expect(page).to have_content(@discount_4.id)
    expect(page).to have_content(@discount_5.id)
    expect(page).to_not have_content(@discount_6.id)
  end

  it "each bulk discount has a link to its show page" do
    expect(page).to have_link("#{@discount_1.id}")
    expect(page).to have_link("#{@discount_2.id}")
    expect(page).to have_link("#{@discount_3.id}")
    expect(page).to have_link("#{@discount_4.id}")
    expect(page).to have_link("#{@discount_5.id}")
    expect(page).to_not have_link("#{@discount_6.id}")

    click_link "#{@discount_1.id}"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount_1))
  end

  it "has a link to create a new bulk discount" do
    within "#New_discount" do
      expect(page).to have_link("Create Discount")
      click_link "Create Discount"
    end
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))

    fill_in "Percent Discount", with: 30
    fill_in "Quantity Threshold", with: 50
    click_button
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    within "#Discounts" do
      expect(page).to have_content("Quantity Threshold: 50")
      expect(page).to have_content("Discount: 30")
    end
  end

  it "has a link to delete next to each bulk discount" do
    within "##{@discount_1.id}" do
      expect(page).to have_link("Delete Discount")
      click_link "Delete Discount"
    end
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    within "#Discounts" do
      expect(page).to_not have_content("Quantity Threshold: 5")
      expect(page).to_not have_content("Discount: 10")
    end
  end
end
