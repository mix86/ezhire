class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable

  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  has_many :candidates, class_name: "Person", inverse_of: :owner
  has_many :projects, class_name: "Project", inverse_of: :owner
  has_many :events, inverse_of: :owner

  embeds_one :settings, class_name: "Settings"

  #HACK FOR DEVISE 3.2.4
  def self.serialize_into_session(record)
    [record.id.to_s, record.authenticatable_salt]
  end

  # TODO: оставлено про запас, для дальнейшей борьбы с глюками монги и тп...
  # def self.serialize_from_session(key, salt)
  #   if key.is_a? String
  #     record = to_adapter.get(key)
  #   else
  #     raise NotImplementedError, key
  #     record = to_adapter.get(key[0]["$oid"])
  #   end
  #   record if record && record.authenticatable_salt == salt
  # end
end
