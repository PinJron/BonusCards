json.id @user.id
json.type "users"

json.attributes do
  json.email @user.email
  json.negative_balance @user.negative_balance
end
json.relationships do
  json.cards do
    json.links do
      json.related :LoremLorem
    end
  end
end
json.users do
  json.cards do
    json.links do
      json.related :LoremLorem
    end
  end
end
