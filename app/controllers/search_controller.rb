class SearchController < ApplicationController
  respond_to :js
  
  authorize_resource
  
  def show
    respond_with(@results = Search.seach_results(params[:search]))
  end
end