json.array!(@messages) do |message|
  json.extract! message, :id, :subject, :body, :is_read, :is_deleted_by_sender, :is_deleted_by_recipient, :is_trashed_by_recipient
  json.url message_url(message, format: :json)
end
