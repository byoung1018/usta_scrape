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

require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
