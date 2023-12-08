json.data do
  json.array! @shops, partial: 'shops/shops', as: :shop
end
