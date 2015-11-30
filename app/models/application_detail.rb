class ApplicationDetail < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
      indexes :uri, analyzer: 'english'
    end
  end
end
ApplicationDetail.import force:true
