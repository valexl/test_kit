class PeopleController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: PeopleDatatable.new(view_context) }
    end
  end

  def load
    IKit::TestIkit::Parser::Main.new.analyze!

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def clear
    Person.destroy_all
    refresh_elasticsearch_cluster! rescue nil #если Elasticsearch упал

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private 
    def refresh_elasticsearch_cluster! 
      #заставить применить изменения. так как elasticsearch - nearrealtime то после удаления может сулчится так что страница обновилась а данные не успели удалитсья из Elasticsearch
      uri = URI.parse("http://127.0.0.1:9200/_refresh")
      response = Net::HTTP.post_form(uri, {})
    end

end


