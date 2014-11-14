module PeopleHelper
  def active_tab
    :people
  end

  def moikrug_name person
    return '' unless person.moikrug
    person.moikrug[:nick]
  end

  def moikrug_url person
    return '' unless person.moikrug
    person.moikrug[:link]
  end

  def facebook_name person
    return '' unless person.facebook
    person.facebook[:link]
  end

  def facebook_url person
    return '' unless person.facebook
    person.facebook[:link]
  end
end
