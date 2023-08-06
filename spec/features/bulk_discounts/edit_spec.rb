require "rails_helper"

describe "Merchant Bulk Discount Show" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")
    @discount = @m1.bulk_discounts.create!(quantity_threshold: 100, percent_discount: 50)
    visit edit_merchant_bulk_discount_path(@m1, @discount)
  end

  it "should have a form that redirects back to merchant bulk discount show with a flash message" do
    fill_in "Quantity Threshold", with: 120
    fill_in "Percent Discount", with: 45
    click_button

    expect(current_path).to eq(merchant_bulk_discount_path(@m1, @discount))
    expect(page).to have_content("Quantity Threshold: 120")
    expect(page).to have_content("Discount: 45%")
    expect(page).to have_content("Discount update successful")
  end
end
