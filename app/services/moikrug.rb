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

      Rails.logger.debug "#{item[:link]} => #{link}"

      @profile = fetch_profile
      { name: name,
        link: link,
        nick: nick,
        skills: skills,
        userpic: userpic,
        experience: experience }
    end
  end

  def query
    [@city,
     '"ищу работу"',
     "\"#{I18n.l Date.today - 2.week, format: :month_year}\"",
     '"о себе"',
     "(#{@specializations.join(' OR ')})"].join ' '
  end

  private

  def search_google
    Rails.logger.info "Google query is '#{query}'"
    Goo.new(:moikrug, max_pages: 5).search query
  end

  def fetch_profile
    response = HTTParty.get(link)
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

  def name
    @item[:title].gsub(/(?:Услуги|Лента событий)?(.*)— Мой Круг/, '\1').strip
  end

  def link
    "http://#{nick}.moikrug.ru"
  end

  def nick
    @item[:link].gsub(/http[s]?:\/\/([a-z0-9\-]+)\.moikrug\.ru\/?.*/, '\1')
  end

  def sanitize_strict t
    Sanitize.fragment(t, Sanitize::Config::RESTRICTED).strip
  end

  def sanitize_basic t
    Sanitize.fragment(t, Sanitize::Config::BASIC).strip
  end
end
