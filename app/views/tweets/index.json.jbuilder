json.array! @tweets do |tweet|
  json.id tweet.id
  json.message tweet.message
  json.username tweet.user.username
  json.created_at tweet.created_at
end
