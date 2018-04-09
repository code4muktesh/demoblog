class ESClient
  require 'elasticsearch'
  
def initialize()
  @client = Elasticsearch::Client.new log: true
  @client.transport.options[:transport_options][:headers]['Content-Type']="application/json"

end

  def index(indexName,type,id,data)
    @client.transport.options[:transport_options][:headers]['Content-Type']="application/json"

    response=@client.index  index: indexName, type: type, id: id, body: data
    return response
  end

# => {"_index"=>"myindex", ... "created"=>true}
  def search(indexName,query)
    response=@client.search index:indexName, body: query
    return response
# => {"took"=>2, ..., "hits"=>{"total":5, ...}}
  end
def delete(indexName,type,id)
  @client.delete index: indexName, type: type, id: id
end
end