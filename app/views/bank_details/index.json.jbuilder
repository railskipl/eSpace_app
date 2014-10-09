json.array!(@bank_details) do |bank_detail|
  json.extract! bank_detail, :id, :full_name, :card_number
  json.url bank_detail_url(bank_detail, format: :json)
end
