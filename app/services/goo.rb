require 'google/api_client'

API_KEY = 'AIzaSyCpk6-D7fy_ek6IVPF-xpPQyI7UFEqiZfU'
SEARCH_IDS = {
  moikrug: '000279295368688324683:bzudsefpqqq',
  facebook: '000279295368688324683:sce5zpk0zsk'
}

class Goo
  def initialize cx_id, params = {}
    @cx_id = cx_id
    @max_pages = params[:max_pages] || 1
  end

  def search(q)
    result = []
    call_google(q) do |r|
      result += r.data.items.map { |item| {title: item.title, link: item.link} }
    end
    result
  end

  private

  def connect
    @client ||= Google::APIClient.new(key: API_KEY, authorization: nil)
    @search ||= @client.discovered_api('customsearch')
  end

  def call_google q
    connect
    start = 1
    (0...max_pages).map do |_|
      response = fetch_page q, start
      yield response

      begin
        start = response.data.queries.nextPage.first.startIndex
      rescue NoMethodError
        break
      end
    end
  end

  def fetch_page q, start
    params = { q: q, cx: cx, start: start }

    response = @client.execute(api_method: @search.cse.list, parameters: params)
    puts "*** CSE query with params #{params} ***"
    if response.status == 200
      info = response.data.searchInformation
      page = response.data.queries.request.first
      log "founds #{info.totalResults}(#{info.searchTime} sec.)"
      log "returns #{page.count} items from #{page.startIndex} (total #{page.totalResults})"
      log "searchTerms: #{page.searchTerms}"
      response
    else
      fail RuntimeError, response.body
    end
  end

  def cx
    SEARCH_IDS[@cx_id]
  end

  def max_pages
    @max_pages
  end

  def log msg
    puts puts "*** CSE #{msg} ***"
  end
end
