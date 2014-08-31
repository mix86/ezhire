class Moikrug
  def initialize city, specializations
    @city = city
    @specializations = specializations

    @skills_xpath = '//div[@class="Profile_Info"]/div/div[1]'
    @positions_xpath = '//ul[@class="Profile_PositionList"]/li'
    @title_xpath = 'h4[@class="Profile_Position_title summary"]'
    @company_xpath = 'p[@itemprop="worksFor"]//span[@itemprop="name"]'
    @duties_xpath = 'div[@class="Profile_PositionDetails text"]'
  end

  def search
    @result = search_google

    @result.map do |item|
      @item = item
      @profile = fetch_profile
      { name: item[:title].gsub(/(.*) — Мой Круг/, '\1'),
        link: @item[:link],
        nick: nick,
        skills: skills,
        userpic: userpic,
        experience: experience }
    end
  end

  private

  def query
    [@city,
     '"ищу работу"',
     '"августа 2014"',
     '"о себе"',
     "(#{@specializations.join(' OR ')})"].join ' '
  end

  def search_google
    Goo.new(:moikrug).search query
  end

  def fetch_profile
    response = HTTParty.get(@item[:link])
    body = response.body
    body.force_encoding Encoding::CP1251
    body.encode! Encoding::UTF_8
    Nokogiri::HTML(body)
  end

  def skills
    sanitize_basic(@profile.xpath(@skills_xpath).to_s)
  end

  def experience
    positions = @profile.xpath(@positions_xpath)

    positions.map do |p|
      title = p.xpath(@title_xpath).to_s
      company = p.xpath(@company_xpath).to_s
      duties = p.xpath(@duties_xpath).to_s

      { title: sanitize_strict(title),
        company: sanitize_strict(company),
        duties: sanitize_basic(duties) }
    end
  end

  def userpic
    userpic = @profile.xpath('//img[@id="person_avatar"][1]')
    if userpic.present?
      userpic.attr('src').value
    else
      nil
    end
  end

  def nick
    @item[:link].gsub(/http:\/\/([a-z0-9\-]+)\.moikrug\.ru\/?/, '\1')
  end

  def sanitize_strict t
    Sanitize.fragment(t, Sanitize::Config::RESTRICTED).strip
  end

  def sanitize_basic t
    Sanitize.fragment(t, Sanitize::Config::BASIC).strip
  end
end
