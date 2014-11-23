require 'google/api_client'

API_KEY = 'AIzaSyCpk6-D7fy_ek6IVPF-xpPQyI7UFEqiZfU'
SEARCH_IDS = {
  moikrug: '000279295368688324683:bzudsefpqqq',
  facebook: '000279295368688324683:sce5zpk0zsk'
}

class Goo
  def initialize cx_id, max_pages: 1, start: 1
    @cx_id = cx_id
    @max_pages = max_pages
    @start = start
  end

  def search query
    @query = query
    connect

    call_google do |result|
      result.data.items.each do |item|
        yield(title: item.title, link: item.link)
      end
    end
  end

  private

  def connect
    @client ||= google_client.new(key: API_KEY, authorization: nil)
    @api ||= @client.discovered_api('customsearch')
  end

  def google_client
    Google::APIClient
  end

  def call_google
    (@start...@start + max_pages).map do |page_number|
      response = fetch_page page_number

      yield response

      begin
        response.data.queries.nextPage.first.startIndex
      rescue NoMethodError
        break
      end
    end
  end

  def fetch_page number
    log "query with params #{params.merge(start: number)}"

    response = @client.execute api_method: @api.cse.list,
                               parameters: params.merge(start: number)
    fail RuntimeError, response.body if response.status != 200
    response
  end

  def params
    { q: @query,
      cr: "countryRU",
      cx: cx,
      filter: "1",
      googlehost: "google.ru",
      hl: "ru",
      lr: "lang_ru",
      safe: "off",
      fields: "items(link,title),queries" }
  end

  def cx
    SEARCH_IDS[@cx_id]
  end

  def start
    @start
  end

  def max_pages
    @max_pages
  end

  def log msg
    puts "*** CSE #{msg} ***"
  end
end
