class Project
  include Mongoid::Document

  field :name, type: String
  field :note, type: String
  field :interview, type: Array, default: -> { [] }
  field :stats, type: Hash, default: -> { {} }

  has_many :candidates, class_name: 'Person'
  belongs_to :owner, class_name: 'User', inverse_of: :projects

  embeds_many :questionnaire, class_name: 'Question', as: :askable
  embeds_many :templates, class_name: 'Template', as: :templatable

  scope :of, -> (user) { where(owner: user) }
end
