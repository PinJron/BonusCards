json.code "unprocessable_entity"
json.status "422"

json.title "Validation Error"
json.detail "Name has already been taken"
json.source do
  json.pointer "/data/attributes/name"
end
json.meta do
  json.attribute "name"
  json.message "has already been taken"
  json.code "taken"
end
