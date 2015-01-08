json.array!(@credit_cards) do |credit_card|
  json.extract! credit_card, :id, :email, :stripe_customer_id, :user_id, :last_digit
  json.url credit_card_url(credit_card, format: :json)
end
