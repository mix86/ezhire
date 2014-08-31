describe Moikrug do
  before :each do
    @moikrug = Moikrug.new 'москва', ['ruby', 'rails']
    allow(@moikrug).to receive(:search_google).and_return google_result
    allow(@moikrug).to receive(:fetch_profile).and_return moikrug_profile
  end

  it do
    result = @moikrug.search
    expect(result.size).to eq 1
    expect(result.first).to eq({ name: "Борис Бульба",
                                 link: "http://buuu.moikrug.ru/",
                                 skills: "очень крутой чел",
                                 nick: 'buuu',
                                 userpic: '/path/to/image',
                                 experience: [{ title: 'CTO',
                                                company: 'Ашан',
                                                duties: 'ходить на работу' }] })
  end

  private

  def google_result
    [{ :title=>"Борис Бульба — Мой Круг", :link=>"http://buuu.moikrug.ru/" }]
  end

  def moikrug_profile
    s = '<body>
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
