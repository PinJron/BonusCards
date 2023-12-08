json.data do
  if @errors
    json.partial! 'shops/422'
  else
    json.partial! 'shops/shops', shop: @shop
  end
end