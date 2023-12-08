json.id @shop.id
json.type "shops"

json.attributes do
  json.name @shop.name
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
