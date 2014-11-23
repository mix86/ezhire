class SearchQuery
  include Mongoid::Document

  field :city, type: String
  field :specializations, type: Array, default: -> { [] }
  field :period, type: Integer
  field :contender, type: Boolean, default: true

  embedded_in :project
end
