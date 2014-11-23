class Digger
  class Loot
    def initialize loot
      @loot = loot
    end

    def name
      @loot[:name]
    end

    def moikrug_link
      @loot[:link]
    end

    def facebook_link
    end
  end

  def initialize query, options
    @query = query
    @options = options
  end

  def call
    moikrug_se = moikrug_search.new(moikrug_query, @options)

    moikrug_se.call do |item|
      yield Loot.new(item)
    end
  end

  def moikrug_query
    @moikrug_query ||= Moikrug::QueryBuilder.new(@query).call
  end

  private

  def moikrug_search
    Moikrug::Search
  end
end
