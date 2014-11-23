describe Faceboo::ProfileFetcher do
  before :each do
    @facebook = Faceboo::ProfileFetcher.new name: "Аркадий Климовский"
    allow(@facebook).to receive(:search_google).and_return google_result
    # allow(@facebook).to receive(:fetch_profile).and_return facebook_profile
  end

  it do
    expect(@facebook.call).to eq({ link: "https://ru-ru.facebook.com/klimovsky" })
  end

  def google_result
    [{title: "Аркадий Климовский | Facebook", link: "https://ru-ru.facebook.com/klimovsky"},
     {title: "Аркадий Климовский профилей | Facebook", link: "https://ru-ru.facebook.com/public/%D0%90%D1%80%D0%BA%D0%B0%D0%B4%D0%B8%D0%B9-%D0%9A%D0%BB%D0%B8%D0%BC%D0%BE%D0%B2%D1%81%D0%BA%D0%B8%D0%B9"},
     {title: "Проводим необычную стажировку для... - Аркадий Климовский ...", link: "https://ru-ru.facebook.com/permalink.php?story_fbid=363375323723373&id=234968443242408"},
     {title: "Белеберда какаято", link: "https://vk.com"}]
  end
end
