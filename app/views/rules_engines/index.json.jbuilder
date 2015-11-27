json.array!(@rules_engines) do |rules_engine|
  json.extract! rules_engine, :id, :name, :attribute, :operator, :value, :color
  json.url rules_engine_url(rules_engine, format: :json)
end
