# == Schema Information
#
# Table name: team_memberships
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  player_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TeamMembership < ApplicationRecord
  belongs_to :player
  belongs_to :team
  extend ScrapeHelpers

  def self.create_memberships_from_team_page(url)
    page = load_url(url)
    team_id = id_from_url(url)
    player_table = page.css('table [bgcolor="#000066"]')[1]
    rows = player_table.css('tr')[3..-1]
    raise 'the players table moved' unless rows.to_html.include?('playermatches.asp?id=')
    rows.each do |row|
      player, city, gender, rating, np_sw, expiration = row.css('td')
      player_id = id_from_column(player)
      player_name, city, gender, rating_text, expiration = columns_to_strings(
          [player, city, gender, rating, expiration])
      lname, fname = player_name.split(', ')

      rating = Rating.create_from_string(player_id, rating_text)

      player = Player.find_or_create_by(id: player_id,
                                        fname: fname,
                                        lname: lname,
                                        city: city,
                                        gender: gender,
                                        expiration_date: expiration
      )

      find_or_create_by(player: player, team_id: team_id)
    end
    byebug
    puts 'stop'
  end

end
