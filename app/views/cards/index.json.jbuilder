json.data do
  json.array! @cards, partial: 'cards/cards', as: :card
end
