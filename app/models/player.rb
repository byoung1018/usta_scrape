# == Schema Information
#
# Table name: players
#
#  id              :integer          not null, primary key
#  name            :string
#  usta_number     :integer
#  city            :string
#  gender          :string
#  expiration_date :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Player < ApplicationRecord
  has_many :ratings
  has_many :teams, through: :team_memberships
  has_many :team_memberships
  extend ScrapeHelpers
end
