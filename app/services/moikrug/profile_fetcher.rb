module Moikrug
  class ProfileFetcher
    def initialize link: nil
      @link = link
    end

    def call
      raise RuntimeError, "link is nil" if @link.nil?
      @profile = fetch_page
      { name: name,
        link: link,
        skills: skills,
        nick: nick,
        userpic: userpic,
        experience: experience }
    rescue NoMethodError, SocketError => e
      Rails.logger.error e.message
      nil
    end

    private

    def fetch_page
      response = HTTParty.get(@link)
      body = response.body
      body.force_encoding Encoding::CP1251
      body.encode! Encoding::UTF_8
      Nokogiri::HTML(body)
    end

    def skills
      sanitize_basic(@profile.xpath(skills_xpath).to_s)
    end

    def experience
      positions = @profile.xpath(positions_xpath)

      positions.map do |p|
        title = p.xpath(title_xpath).to_s
        company = p.xpath(company_xpath).to_s
        duties = p.xpath(duties_xpath).to_s

        { title: sanitize_strict(title),
          company: sanitize_strict(company),
          duties: sanitize_basic(duties) }
      end
    end

    def userpic
      userpic = @profile.xpath(userpic_xpath)
      if userpic.present?
        userpic.attr('src').value
      else
        nil
      end
    end

    def name
      @profile.xpath(name_xpath).attr("content").value
    end

    def link
      @profile.xpath(link_xpath).attr("content").value
    end

    def nick
      link.gsub(/http[s]?:\/\/([a-z0-9\-]+)\.moikrug\.ru\/?.*/, '\1')
    end

    def name_xpath
      '//meta[@itemprop="name"][1]'
    end

    def link_xpath
      '//meta[@itemprop="url"][1]'
    end

    def userpic_xpath
      '//img[@id="person_avatar"][1]'
    end

    def skills_xpath
      '//div[@class="Profile_Info"]/div/div[1]'
    end

    def positions_xpath
      '//ul[@class="Profile_PositionList"]/li'
    end

    def title_xpath
      'h4[@class="Profile_Position_title summary"]'
    end

    def company_xpath
      'p[@itemprop="worksFor"]//span[@itemprop="name"]'
    end

    def duties_xpath
      'div[@class="Profile_PositionDetails text"]'
    end

    def sanitize_strict t
      Sanitize.fragment(t, Sanitize::Config::RESTRICTED).strip
    end

    def sanitize_basic t
      Sanitize.fragment(t, Sanitize::Config::BASIC).strip
    end
  end
end
