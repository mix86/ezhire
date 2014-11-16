class ThePerson
  include Mongoid::Document

  store_in collection: "people"

  field :moikrug, type: Hash
  field :facebook, type: Hash

  field :moikrug_link, type: String
  field :moikrug_profile, type: Hash

  field :facebook_link, type: String
  field :facebook_profile, type: Hash

  field :skills, type: String
  field :experience, type: Array
end

namespace :db do
  task :migrate do
    ThePerson.all.each do |person|
      unless person.moikrug_link
        person.moikrug_link = person.moikrug[:link] if person.moikrug
        person.moikrug_profile = person.moikrug
        person.save!
      end

      unless person.facebook_link
        person.facebook_link = person.facebook[:link] if person.facebook
        person.facebook_profile = person.facebook
        person.save!
      end

      unless person.skills
        person.skills ||= person.moikrug[:skills] if person.moikrug
        person.save!
      end

      unless person.experience
        person.experience ||= person.moikrug[:experience] if person.facebook
        person.save!
      end
    end
    puts 'WELL DONE!'
  end
end
