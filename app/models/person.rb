class Person
  include Mongoid::Document
  extend EnumerateIt

  class Status < EnumerateIt::Base
    associate_values :new, :accepted, :rejected
  end

  before_save :fix_links

  field :name, type: String

  field :moikrug_link, type: String
  field :moikrug_profile, type: Hash

  field :facebook_link, type: String
  field :facebook_profile, type: Hash

  field :skills, type: String, default: ''
  field :experience, type: Array, default: -> { Array.new }

  field :email, type: String
  field :phone, type: String
  field :skype, type: String
  field :linkedin_link, type: String
  field :github_link, type: String
  field :stackoverflow_link, type: String
  field :facebook_link, type: String
  field :vk_link, type: String
  field :twitter_link, type: String
  field :googleplus_link, type: String

  field :status, type: String, default: :new

  scope :of, -> (user) { where(owner: user) }
  scope :accepted, -> { where(status: Status::ACCEPTED) }

  belongs_to :owner, class_name: "User", inverse_of: :candidates
  belongs_to :project

  has_enumeration_for :status, :with => Status, :create_helpers => true


  def fix_links
    self.facebook_link = URI.decode(facebook_link) if facebook_link
  end
end
