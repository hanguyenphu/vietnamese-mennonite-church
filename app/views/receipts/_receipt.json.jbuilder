json.extract! receipt, :id, :number, :donation_year, :amount, :description, :member_id, :created_at, :updated_at
json.url receipt_url(receipt, format: :json)
