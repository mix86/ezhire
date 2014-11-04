class WordRelation
  include Mongoid::Document
  extend EnumerateIt

  class Relations < EnumerateIt::Base
    associate_values :synonym, :opposite
  end

  field :source, type: String
  field :target, type: String
  field :relation, type: String

  has_enumeration_for :relation, :with => Relations, :create_helpers => true
end
