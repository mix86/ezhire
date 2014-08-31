require 'google/api_client'

API_KEY = 'AIzaSyCpk6-D7fy_ek6IVPF-xpPQyI7UFEqiZfU'
SEARCH_IDS = {
  moikrug: '000279295368688324683:bzudsefpqqq',
  facebook: '000279295368688324683:sce5zpk0zsk'
}

class Goo
  def initialize cx_id
    @cx_id = cx_id
  end

  def search(q)
    result = call_google(q)
    result.data.items.map { |item| {title: item.title, link: item.link} }
  end

  private

  def call_google q
    @client ||= Google::APIClient.new(key: API_KEY, authorization: nil)
    @search ||= @client.discovered_api('customsearch')
    response = @client.execute(api_method: @search.cse.list, parameters: {q: q, cx: cx})
    if response.status == 200
      response
    else
      fail RuntimeError, response.body
    end
  end

  def cx
    SEARCH_IDS[@cx_id]
  end
end
