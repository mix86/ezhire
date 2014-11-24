module PeopleHelper
  def active_tab
    :people
  end

  def userpic_src person
    if person.moikrug_profile && person.moikrug_profile[:userpic]
      person.moikrug_profile[:userpic]
    else
      'http://nilcolor.moikrug.ru/images/blank_photo/portrait.png'
    end
  end

  def moikrug_name person
    return unless person.moikrug_profile.present?
    person.moikrug_profile[:nick]
  end

  def moikrug_url person
    person.moikrug_link
  end

  def facebook_name person
    return unless person.facebook_link.present?
    /^.*facebook\.com\/(?:people\/)?([^\/]+).*$/.match(person.facebook_link)[1]
  end

  def facebook_url person
  end

  def contact_link url, text, label
    if text.present?
      text = text.gsub(/http[s]?:\/\//, '')
      link_tag = "<a href='#{url}' target='_blank'>#{text}</a>"
    else
      link_tag = "<small><i class='nodata'>пока неизвестен</i></small>"
    end

    html = <<-HTML
      <div class="row">
        <div class="small-1 column"><strong>#{label}</strong></div>
        <div class="small-10 column">
          #{link_tag}
        </div>
      </div>
    HTML

    raw html
  end

  def email_link person
    contact_link "mailto:#{person.email}", person.email, icon(:at)
  end

  def phone_link person
    contact_link "tel:#{person.phone}", person.phone, icon(:phone)
  end

  def skype_link person
    contact_link "skype:#{person.skype}", person.skype, icon(:skype)
  end

  def moikrug_link person
    contact_link moikrug_url(person), moikrug_name(person), "MK"
  end

  def linkedin_link person
    contact_link person.linkedin_link, person.linkedin_link, icon(:linkedin)
  end

  def github_link person
    contact_link person.github_link, person.github_link, icon(:github)
  end

  def stackoverflow_link person
    contact_link person.stackoverflow_link, person.stackoverflow_link, icon('stack-overflow')
  end

  def vk_link person
    contact_link person.vk_link, person.vk_link, icon(:vk)
  end

  def twitter_link person
    contact_link person.twitter_link, person.twitter_link, icon(:twitter)
  end

  def googleplus_link person
    contact_link person.googleplus_link, person.googleplus_link, icon('google-plus')
  end

  def facebook_link person
    contact_link person.facebook_link, facebook_name(person), icon(:facebook)
  end

  def resume_link person
    contact_link person.resume_link, person.resume_link, icon('file-o')
  end
end
