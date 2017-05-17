# == Schema Information
#
# Table name: teams
#
#  id               :integer          not null, primary key
#  captain_id       :integer
#  co_captain_id    :integer
#  area             :string
#  home_facility_id :string
#  organization_id  :string
#  name             :string
#  division_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
