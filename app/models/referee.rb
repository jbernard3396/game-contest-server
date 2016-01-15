require 'uri'

class Referee < ActiveRecord::Base
    #  belongs_to :programming_language
    belongs_to :user
    has_many :contests

=begin
<<<<<<< HEAD
  validates :user,              presence: true
  validates :round_limit,       presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :name,              presence: true, uniqueness: true
  validates :rules_url,		format: { with: /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(([\/][a-z0-9]*)*(([\/][a-z0-9]+([\-]{1}[a-z0-9]+)?)*\.[a-z]{2,6})?)?([\?]([a-z0-9]+[\=][a-z0-9]+[\&]?)*)?\z/ }
  validates :players_per_game,  numericality: { only_integer: true, greater_than: 0, less_than: 11 }
  validates :time_per_game,     numericality: { only_integer: true, greater_than: 0, less_than: 16 }
  validates :rounds_capable,	inclusion: { in: [true, false] }	
  #  validates :programming_language, presence: true
=======
    validates :user,              presence: true
    validates :match_limit,       presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :name,              presence: true, uniqueness: true
    validates :rules_url,		format: { with: /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(([\/][a-z0-9]*)*(([\/][a-z0-9]+([\-]{1}[a-z0-9]+)?)*\.[a-z]{2,6})?)?([\?]([a-z0-9]+[\=][a-z0-9]+[\&]?)*)?\z/ }
    validates :players_per_game,  numericality: { only_integer: true, greater_than: 0, less_than: 11 }
    validates :time_per_game,     numericality: { only_integer: true, greater_than: 0, less_than: 16 }
    #  validates :programming_language, presence: true
>>>>>>> 2042a496d8a3de42ef23b5007c647a47bb77bb47
=end
    validates :user,              presence: true
  	validates :round_limit,       presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :name,              presence: true, uniqueness: true
    validates :rules_url,		format: { with: /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(([\/][a-z0-9]*)*(([\/][a-z0-9]+([\-]{1}[a-z0-9]+)?)*\.[a-z]{2,6})?)?([\?]([a-z0-9]+[\=][a-z0-9]+[\&]?)*)?\z/ }
    validates :players_per_game,  numericality: { only_integer: true, greater_than: 0, less_than: 11 }
    validates :time_per_game,     numericality: { only_integer: true, greater_than: 0, less_than: 16 }
    validates :file_location,              presence: true
  	validates :rounds_capable,	inclusion: { in: [true, false] }	
    #  validates :programming_language, presence: true

    include Uploadable


    def self.search(search)
        if search
            where('name LIKE ?', "%#{search}%")
        else
            all
        end
    end

    extend FriendlyId
    friendly_id :name, use: :slugged
    after_validation :move_friendly_id_error_to_name

    def move_friendly_id_error_to_name
        errors.add :name, *errors.delete(:friendly_id) if errors[:friendly_id].present?
    end
end
