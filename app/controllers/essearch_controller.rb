class EssearchController < ApplicationController

  def search
    #abort params[:q].inspect
    @ES_PostClient=ES_PostClient.new
    query={"query":{"multi_match":{"query":params[:q],"fields":["title","content"]}}}
    @result=@ES_PostClient.search(query)
    #abort result.inspect
  end
  def bulkindex

  end
end
