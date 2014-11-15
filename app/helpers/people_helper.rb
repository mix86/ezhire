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
    if person.moikrug_profile
      person.moikrug_profile[:nick]
    else
      '(noname)'
    end
  end

  def moikrug_url person
    person.moikrug_link || :nolink
  end

  def facebook_name person
    person.facebook_link || :nolink
  end

  def facebook_url person
    person.facebook_link || :nolink
  end
end
