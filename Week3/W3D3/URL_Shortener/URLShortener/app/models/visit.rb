# == Schema Information
#
# Table name: visits
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  shortened_url_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Visit < ApplicationRecord
  validates :user_id, presence: true
  validates :shortened_url_id, presence: true

  def self.record_visit!(user_id, shortened_url_id)
    #user_id = user.id
    #shortened_url_id = shortened_url.id
    Visit.create!(:user_id => user_id, :shortened_url_id => shortened_url_id)
  end

  belongs_to(
    :user,
    class_name: :User,
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :shortened_url,
    class_name: :ShortenedUrl,
    foreign_key: :shortened_url_id,
    primary_key: :id
  )
end
