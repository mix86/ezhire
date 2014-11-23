module Faceboo
  class ProfileFetcher
    def initialize name: nil
      @name = name
    end

    def call
      @result = search_google.select { |item| looks_like_good_result? item }.first
      if @result
        { link: @result[:link] }
      end
    end

    private

    def search_google
      Goo.new(:facebook).search query
    end

    def query
      @name
    end

    def looks_like_good_result? item
      /^#{@name} \| Facebook$/.match(item[:title]).present?
    end
  end
end
