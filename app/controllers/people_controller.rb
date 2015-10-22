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
end


