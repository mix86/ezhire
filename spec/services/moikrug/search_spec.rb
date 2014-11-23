describe Moikrug::Search do
  context "#initialize" do
    it do
      google_instance = double(search: nil)
      google_class = double(new: google_instance)
      allow_any_instance_of(Moikrug::Search).to receive(:goo).and_return(google_class)

      expect(google_class).to receive(:new).with(:moikrug, bar: 1)
      expect(google_instance).to receive(:search).with('ololo')

      Moikrug::Search.new('ololo', bar: 1).call
    end
  end

  context "#call" do
    it do
      google_result.each do |result|
        allow_any_instance_of(Goo).to receive(:search).and_yield(result)

        Moikrug::Search.new(nil, {}).call do |item|
          expect(item).to eq(name: "Сергей Андрюхин",
                             link: "http://sorgoz.moikrug.ru/")
        end

      end
    end
  end

  private

  def google_result
    [{ title: "Лента событий Сергей Андрюхин — Мой Круг",
       link: "http://sorgoz.moikrug.ru/feed/" },
     { title: "Услуги Сергей Андрюхин — Мой Круг",
       link: "http://sorgoz.moikrug.ru/feed/" },
     { title: "Сергей Андрюхин : фотоальбом — Мой Круг",
       link: "http://sorgoz.moikrug.ru/album/" },
     { title: "Сергей Андрюхин — Мой Круг",
       link: "http://sorgoz.moikrug.ru/" },
     { title: "Сергей Андрюхин : фотографии — Мой Круг",
       link: "http://moikrug.ru/users/P158093754/photos/738008134/" },
     { title: "Обсуждение: Посоветуйте книгу по XSLT — Мой Круг",
       link: "http://moikrug.ru/feed/445200085/" },
     { title: "Изменения должностей в компании «Яндекс» — Мой Круг",
       link: "http://moikrug.ru/companies/548669435/positionchanges/?filter=leaving&page=15" }]
  end
end
