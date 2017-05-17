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

class Team < ApplicationRecord
  has_many :players
  has_many :division_memberships
  belongs_to :division
  belongs_to :organization
  belongs_to :captain, class_name: :Player
  extend ScrapeHelpers
  def self.create_from_division_page(url)
    division_page = load_url(url)
    division_id = id_from_url(url)
    team_rows_from_divisions_page(division_page).each do |row|
      team, captain, city, area, organization = row.css('td')
      team = create_minimal_from_column(team)
      team.captain = Player.create_minimal_from_column(captain)
      team.organization = Organization.create_minimal_from_column(organization)
      # team.city = city.text.strip
      team.area = area.text.strip

      team.division_id = division_id
      team.save!
    end
  end

  private
  def self.team_rows_from_divisions_page(page)
    page.css('tr[bgcolor="#FFFFFF"], tr[bgcolor="#CCCCCC"]')
  end

end
