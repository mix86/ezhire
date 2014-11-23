describe Goo do
  before(:each) do
    @fake_api = double(discovered_api: nil)
    @fake_client = double(new: @fake_api)
    allow_any_instance_of(Goo).to receive(:google_client).and_return(@fake_client)
  end

  context "initialize" do
    it "accepts correct params" do
      @google = Goo.new :moikrug, max_pages: 3

      expect(@google.send :cx).not_to be_nil
      expect(@google.send :max_pages).to eq 3
    end

    it "sets default value to max_pages param" do
      @google = Goo.new :ololo

      expect(@google.send :max_pages).to eq 1
    end
  end

  context "connect" do
    it "initializes google api client" do
      @google = Goo.new(:ololo)
      expect(@fake_client).to receive(:new) # TODO: .with(:some_args)
      expect(@fake_api).to receive(:discovered_api).with("customsearch")

      @google.send(:connect)
    end
  end

  context "#search" do
    let(:expected_results) do
      expected_results = [
        { title: "Лента событий Сергей Андрюхин — Мой Круг",
          link: "http://sorgoz.moikrug.ru/feed/" },
        { title: "Сергей Андрюхин : фотоальбом — Мой Круг",
          link: "http://sorgoz.moikrug.ru/album/" },
        { title: "Сергей Андрюхин — Мой Круг",
          link: "http://andryuhins.moikrug.ru/" },
        { title: "Сергей Андрюхин : фотографии — Мой Круг",
          link: "http://moikrug.ru/users/P158093754/photos/738008134/" },
        { title: "Андрюхин Сергей — Мой Круг",
          link: "http://andryuhin-sergey.moikrug.ru/" },
        { title: "сергей константинович андрюхин — Мой Круг",
          link: "http://andryuhin-s.moikrug.ru/" },
        { title: "Обсуждение: Посоветуйте книгу по XSLT — Мой Круг",
          link: "http://moikrug.ru/feed/445200085/" },
        { title: "Изменения должностей в компании «Яндекс» — Мой Круг",
          link: "http://moikrug.ru/companies/548669435/positionchanges/?filter=leaving&page=15" }
      ]
      expected_results *= 3
      expected_results.reverse
    end

    before(:each) do
      @google = Goo.new :someid, max_pages: 3
      allow(@google).to receive(:connect)
      allow(@google).to receive(:fetch_page).and_return(google_result)
    end

    it "calls connect method" do
      expect(@google).to receive(:connect).once
      @google.search('ololo') { break }
    end

    it "returns correct result" do
      @google.search('ololo') do |item|
        expected_result = expected_results.pop
        expect(item).to eq(expected_result)
      end
      expect(expected_results.size).to be_zero
    end

    it "calls fetch_page method for each page" do
      expect(@google).to receive(:fetch_page).with(1)
      expect(@google).to receive(:fetch_page).with(2)
      expect(@google).to receive(:fetch_page).with(3)
      @google.search('ololo') {}
    end

    it "calls fetch_page method only once if break" do
      expect(@google).to receive(:fetch_page).with(1).once
      @google.search('ololo') { break }
    end

    private

    def google_result
      queries = double(nextPage: [double(totalResults: "56", count: 10, startIndex: 11)])
      items = [double(title: "Лента событий Сергей Андрюхин — Мой Круг",
                      link: "http://sorgoz.moikrug.ru/feed/"),
               double(title: "Сергей Андрюхин : фотоальбом — Мой Круг",
                      link: "http://sorgoz.moikrug.ru/album/"),
               double(title: "Сергей Андрюхин — Мой Круг",
                      link: "http://andryuhins.moikrug.ru/"),
               double(title: "Сергей Андрюхин : фотографии — Мой Круг",
                      link: "http://moikrug.ru/users/P158093754/photos/738008134/"),
               double(title: "Андрюхин Сергей — Мой Круг",
                      link: "http://andryuhin-sergey.moikrug.ru/"),
               double(title: "сергей константинович андрюхин — Мой Круг",
                      link: "http://andryuhin-s.moikrug.ru/"),
               double(title: "Обсуждение: Посоветуйте книгу по XSLT — Мой Круг",
                      link: "http://moikrug.ru/feed/445200085/"),
               double(title: "Изменения должностей в компании «Яндекс» — Мой Круг",
                      link: "http://moikrug.ru/companies/548669435/positionchanges/?filter=leaving&page=15")]

      double data: double(queries: queries, items: items)
    end
  end
end
