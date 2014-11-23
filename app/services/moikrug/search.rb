module Moikrug
  class Search
    def initialize query, options
      @query = query
      @options = options
    end

    def call
      google = goo.new(:moikrug, @options)

      google.search(query) do |item|
        if profile? item
          yield name: extract_name(item), link: link(extract_nick item)
        end
      end
    end

    private

    def goo
      Goo
    end

    def query
      @query
    end

    def extract_name item
      re = /(?:Услуги|Лента событий)?([^—:]+)(?:: (?:фотоальбом|фотографии))? — Мой Круг/
      item[:title].gsub(re, '\1').strip
    end

    def link nick
      "http://#{nick}.moikrug.ru/"
    end

    def extract_nick item
      item[:link].gsub(/http[s]?:\/\/([a-z0-9\-]+)\.moikrug\.ru\/?.*/, '\1')
    end

    def profile? item
      /http[s]?:\/\/([a-z0-9\-]+)\.moikrug\.ru\/?.*/.match(item[:link])
    end
  end
end
