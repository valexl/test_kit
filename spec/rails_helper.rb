# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

def refresh_elasticsearch_cluster
  uri = URI.parse("http://127.0.0.1:9200/_refresh")
  response = Net::HTTP.post_form(uri, {})
end
