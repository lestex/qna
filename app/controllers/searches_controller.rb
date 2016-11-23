class SearchesController < ApplicationController
  respond_to :js
  
  authorize_resource
  
  def show
    respond_with(@results = Search.results(params[:search]))
  end
end