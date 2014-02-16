json.array!(@styles) do |style|
  json.extract! style, :id
  json.url style_url(style, format: :json)
end
