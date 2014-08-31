class Faceboo
  def initialize name
    @name = name
  end

  def search_one
    @result = search_google.select { |item| looks_like_good_result? item }.first
    if @result
      { link: @result[:link] }
    end
  end

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
