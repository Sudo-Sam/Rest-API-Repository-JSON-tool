json.array!(@application_details) do |application_detail|
  json.extract! application_detail, :id, :name, :environment, :rest_method, :uri, :request_hdr, :request_text
  json.url application_detail_url(application_detail, format: :json)
end
