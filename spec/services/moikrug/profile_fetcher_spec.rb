describe Moikrug::ProfileFetcher do
  before :each do
    @fetcher = Moikrug::ProfileFetcher.new link: "http://buuu.moikrug.ru/"
    allow(@fetcher).to receive(:fetch_page).and_return moikrug_profile
  end

  it 'parses correct html' do
    result = @fetcher.call
    expect(result).to eq({ name: "Борис Бульба",
                           link: "http://buuu.moikrug.ru/",
                           skills: "очень крутой чел",
                           nick: 'buuu',
                           userpic: '/path/to/image',
                           experience: [{ title: 'CTO',
                                          company: 'Ашан',
                                          duties: 'ходить на работу' }] })
  end


  it 'does not fail on bad input' do
    allow(@fetcher).to receive(:fetch_page).and_return bad_html
    expect(Rails.logger).to receive(:error).with("undefined method `attribute' for nil:NilClass")
    result = @fetcher.call
    expect(result).to eq(nil)
  end

  it 'does not fail on SocketError' do
    allow(@fetcher).to receive(:fetch_page).and_raise(SocketError)
    expect(Rails.logger).to receive(:error).with("SocketError")
    result = @fetcher.call
    expect(result).to eq(nil)
  end

  private

  def bad_html
    Nokogiri::HTML('<html></html>')
  end

  def moikrug_profile
    s = '<body>
      <meta itemprop="name" content="Борис Бульба">
      <meta itemprop="url" content="http://buuu.moikrug.ru/">
      <div class="Profile_Info">
        <div>
          <div>очень крутой чел</div>
        </div>
      </div>
      <img id="person_avatar" src="/path/to/image">
      <ul class="Profile_PositionList">
        <li class="first">
          <h4 class="Profile_Position_title summary">CTO</h4>
          <p itemprop="worksFor">
            <span itemprop="name">Ашан</span>
          </p>
          <div class="Profile_PositionDetails text">ходить на работу</div>
        </li>
      </ul>
    </body>'
    Nokogiri::HTML(s)
  end
end
