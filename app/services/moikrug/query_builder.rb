module Moikrug
  class QueryBuilder
    def initialize options
      @options = options
    end

    def call
      query
    end

    private

    def query
      q = [city]
      if contender?
        q << '"ищу работу"'
        q << "(#{dates.join(' OR ')})"
      end
      q << '"о себе"'
      q << "(#{specializations.join(' OR ')})"
      q.join ' '
    end

    def dates
      period.map do |i|
        "\"#{I18n.l Date.today - i.month, format: :month_year}\""
      end
    end

    def city
      @options[:city]
    end

    def contender?
      @options[:contender]
    end

    def specializations
      @options[:specializations]
    end

    def period
      0...@options[:period]
    end
  end
end
