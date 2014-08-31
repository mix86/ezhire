class Settings
  include Mongoid::Document

  field :questionnaire, type: Array, default: ->{ [] }
  field :interview, type: Array, default: ->{ [] }

  embedded_in :user
end
