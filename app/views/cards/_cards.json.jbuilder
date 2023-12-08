json.id card.id
json.type "cards"

json.attributes do
  json.bonuses card.bonuses
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
