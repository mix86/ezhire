class Moikrug
  def initialize city, specializations, months = 1, looking_for = true
    @city = city
    @specializations = specializations
    @months = months
    @looking_for = looking_for

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

      next unless @profile

      { name: name,
        link: link,
        nick: nick,
        skills: skills,
        userpic: userpic,
        experience: experience }
    end.compact
  end

  def query
    q = [@city]
    if @looking_for
      q << '"ищу работу"'
      q << "(#{query_dates.join(' OR ')})"
    end
    q << '"о себе"'
    q << "(#{@specializations.join(' OR ')})"
    q.join ' '
  end

  def query_dates
    (0...@months).map do |i|
      "\"#{I18n.l Date.today - i.month, format: :month_year}\""
    end
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
  rescue SocketError => e
    Rails.logger.error e
    nil
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
    "http://#{nick}.moikrug.ru/"
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
