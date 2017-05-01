class MainController < ApplicationController
  require 'open-uri'
  require 'uri'
  require 'json'
  def index        
    @categories = JSON.parse(open("#{source}/jokes/categories").read)
    respond_to do |format|
      format.html
    end
  end

  def search
    uri = URI.parse("#{source}/jokes/search?")
    if params[:text].present?        
      uri.query = URI.encode_www_form( query: params[:text] )
      @results = JSON.parse(uri.open.read)
      search = Search.new() 
      search.value = params[:text]
      search.save
      @results["total"].times do |n|
        MainController.save_results(search, @results["result"][n]["category"], 
          @results["result"][n]["url"], @results["result"][n]["value"] )
      end
      if params[:email].present?
        message = SearchResultsMessage.new(email: params[:email], search: search)
        SearchResultsMailer.send_results(message).deliver_now
      end
    else
      if params[:category].present?
        uri = URI.parse("#{source}/jokes/random?") 
        uri.query = URI.encode_www_form( category: params[:category] )
        @results = JSON.parse(uri.open.read)
        search = Search.new() 
        search.value = "Random search"
        search.save
        MainController.save_results(search, @results["category"], @results["url"], @results["value"])
        if params[:email].present?
          message = SearchResultsMessage.new(email: params[:email], search: search)
          SearchResultsMailer.send_results(message).deliver_now
        end
      else
        uri = URI.parse("#{source}/jokes/random")         
        @results = JSON.parse(uri.open.read)
        search = Search.new() 
        search.value = "Random search"
        search.save      
        MainController.save_results(search, @results["category"], @results["url"], @results["value"])
        if params[:email].present?
          message = SearchResultsMessage.new(email: params[:email], search: search)
          SearchResultsMailer.send_results(message).deliver_now
        end
      end  
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def self.save_results(search, category, url, fact)
    result = search.results.new()
    result.category = category
    result.url = url
    result.value = fact       
    search.results << result 
  end
end
