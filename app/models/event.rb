class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  extend EnumerateIt

  class Kind < EnumerateIt::Base
    associate_values :call, :email, :meeting
  end

  field :kind, type: String

  field :planned_at, type: DateTime
  field :closed_at, type: DateTime
  field :note, type: String

  belongs_to :person
  belongs_to :project
  belongs_to :owner, class_name: "User", inverse_of: :events
  embeds_many :interview, class_name: 'Question', as: :askable

  scope :of, -> (user) { where(owner: user) }
  scope :today, -> { gte(planned_at: Date.current) }
  scope :overdue, -> { where(closed_at: nil).lt(planned_at: Time.zone.now) }
  scope :next, -> { where(closed_at: nil).gte(planned_at: Date.tomorrow) }
  scope :someday, -> { where(closed_at: nil).gte(planned_at: Date.tomorrow + 1.day) }

  validates :kind, presence: true
  validates :owner, presence: true
  validates :planned_at, presence: true

  has_enumeration_for :kind, :with => Kind, :create_helpers => true

  def close!
    self.closed_at = Time.zone.now
  end

  def closed?
    closed_at.present?
  end

  def due?
    planned_at.to_date == Date.current
  end

  def overdue?
    planned_at < Time.zone.now
  end

  def actual_interview
    return interview if interview.present?
    project.interview.map { |question| Question.new(question: question) }
  end

end
