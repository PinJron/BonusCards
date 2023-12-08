json.data do
  if @errors
    json.partial! 'users/422'
  else
    json.partial! 'users/users', user: @user
  end
end
