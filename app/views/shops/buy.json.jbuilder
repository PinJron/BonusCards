if @errors
  json.partial! 'shops/buy_422', shop: @shop
else
  json.partial! 'shops/buy', card: @card, amount_due: @amount_due
end
