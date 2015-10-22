module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join("_")

    settings analysis: {
      analyzer: {
        default: {
          type: "custom",
          tokenizer: "standard",
          filter: ["lowercase", "default_filter"]
        },
        sortable: {
          tokenizer: 'keyword',
          filter: ["lowercase"]
        }
      },
      filter: {
        default_filter: {
          type: "nGram",
          min_gram: 3,
          max_gram: 50
        }
      }
    } 

    
    after_save(){
      __elasticsearch__.index_document 
      true
    }
    
    after_touch() { 
      __elasticsearch__.index_document 
      true
    }

  end

  def touch
    reload
    super
  end


end