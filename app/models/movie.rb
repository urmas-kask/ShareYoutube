class Movie < ApplicationRecord
  belongs_to :user
  validates :url, presence: true
  delegate :email, to: :user, prefix: true
  before_save :make_embed_url

  def make_embed_url
    self.url = url.gsub("watch\?v=", "embed\/")
  end
end
