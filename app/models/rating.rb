# == Schema Information
#
# Table name: ratings
#
#  id          :integer          not null, primary key
#  player_id   :integer
#  rating_type :string
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Rating < ApplicationRecord
  belongs_to :player

  def self.parse_rating_string(string)
    attrs = {level: string[/[2-6]\.[0,5]/]}
    attrs[:rating_type] = string[/[a-z,A-Z]/].downcase
    attrs[:year] = string[/[0-9]{4}/]

    attrs
  end

  def self.create_from_string(player_id, string)
    attrs = Rating.parse_rating_string(string)
    year = Time.now.year
    attrs.merge!({player_id: player_id, year: year})
    rating = Rating.find_or_create_by(attrs)
    binding.pry unless rating && rating.persisted?
    rating
  end
end
