class ES_PostClient
  require 'elasticsearch/es_client'

  def initialize()
     @ESClient=ESClient.new
     @indexName="post"
  end

  def index(type,id,data)

    response=@ESClient.index(@indexName, type,id, data )
    return response
  end
  def search(query)
    response=@ESClient.search(@indexName,  query)
    return response
  end
  def delete(type,id)
    @ESClient.delete(@indexName, type,id)
  end
end