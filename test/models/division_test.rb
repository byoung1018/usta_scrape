# == Schema Information
#
# Table name: divisions
#
#  id            :integer          not null, primary key
#  age_group     :string
#  division_type :string
#  year          :string
#  level         :string
#  gender        :string
#  label         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
