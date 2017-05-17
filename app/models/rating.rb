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
end
