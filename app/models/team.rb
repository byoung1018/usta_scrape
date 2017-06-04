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
  belongs_to :home_facility, class_name: :Organization, optional: true
  belongs_to :captain, class_name: :Player
  belongs_to :co_captain, class_name: :Player, optional: true
  extend ScrapeHelpers
  include ScrapeHelpers

  def self.create_from_division_page(division_url)
    division_page = load_url(division_url)
    division_id = id_from_url(division_url)
    team_rows_from_divisions_page(division_page).each do |row|
      team, captain, city, area, organization = row.css('td')
      team = create_minimal_from_column(team)
      next if team.division_id
      team.captain = Player.create_minimal_from_column(captain)
      team.organization = Organization.create_minimal_from_column(organization)
      # team.city = city.text.strip
      team.area = area.text.strip

      team.division_id = division_id
      team.save!
    end
  end

  def create_players_from_team_page

    if last_complete_save
      puts "skipping #{url}"
      return self
    else
      puts "scraping #{url}"
    end

    page = load_url(url)
    players_table = page.css('table').select{|t|t.text.include? 'Rostered'}.last

    player_rows = players_table.css('tr')[2..-1]
    player_rows.map do |row|
      next if row.text.include?('No Players Found!')
      name, city, gender, rating= row.css('td').map {|column| column.text.strip}
      name_anchor = row.css('a').first
      binding.pry unless name_anchor
      id = id_from_anchor(name_anchor)
      lname, fname = name.split(', ')
      player = Player.find_or_create_by(id: id)
      player.update(city: city, gender: gender, fname: fname, lname: lname )
      TeamMembership.find_or_create_by(player: player, team: self)
      Rating.create_from_string(id, rating)
    end

    update(last_complete_save: Time.now)

  end


  #not sure if this works
  def new_from_team_page(url)
    page = load_url(url)
    header_rows = page.css('tr[bgcolor="#EFEFEF"]')
    raise "there is more than header row" unless header_rows.count == 1
    header_row = header_rows.last

    attrs = get_captains_from_header_row(header_row)
    attrs.merge!(get_organizations_from_header_row(header_row))
    attrs[:area] = get_area_from_header_row(header_row)
    self.update(attrs)
    self.save!
    #next, get other info and make sure the captains persist

    self
  end


  def url
    "https://www.ustanorcal.com/teaminfo.asp?id=#{id}"
  end

  private

  def get_captains_from_header_row(header_row)
    captain, co_captain = header_row.css('a[href^=playermatches]')
    captains = {captain: Player.create_minimal_from_anchor(captain)}
    if co_captain
      captains[:co_captain] = Player.create_minimal_from_anchor(co_captain)
    end

    captains
  end

  def get_area_from_header_row(header_row)
    (header_row.css('td')[1])
    array_of_text.first.split(': ').last
  end

  def get_organizations_from_header_row(header_row)
    organization, home_facility = header_row.css('a[href^="organization.asp?id="]')
    organizations = {}

    if home_facility
      organizations[:organization] = Organization.create_minimal_from_anchor(organization)
    else
      home_facility = organization
    end
    organizations[:home_facility] = Organization.create_minimal_from_anchor(home_facility)

    organizations
  end

  def self.team_rows_from_divisions_page(page)
    page.css('tr[bgcolor="#FFFFFF"], tr[bgcolor="#CCCCCC"]')
  end

end
