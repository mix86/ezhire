class Settings
  include Mongoid::Document

  field :questionnaire, type: Array, default: ->{ [] }
  field :interview, type: Array, default: ->{ [] }

  embeds_many :templates, class_name: "Template", as: :templatable
  embedded_in :user
end
