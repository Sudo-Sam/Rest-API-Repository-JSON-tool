class RulesEngine < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
      indexes :json_attribute, analyzer: 'english'
      indexes :value, analyzer: 'english'
    end
  end
end

RulesEngine.import force:true

