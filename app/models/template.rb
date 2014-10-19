class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :private, type: Boolean
  field :body, type: String

  embedded_in :templatable, polymorphic: true
end
