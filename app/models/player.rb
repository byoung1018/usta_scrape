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
  include ScrapeHelpers


  #haven't tested yet
  def self.scrape_all_players
    i = 1
    last_player_id = Rating.order(:player_id).pluck(:player_id).last
    existing = []
    loop do
      batch_start = i
      while existing.empty?
        return if last_player_id >= i
        batch_start = i
        puts "looking between #{batch_start} and #{batch_start + 1000}"
        existing = Rating.where('player_id between ? and ?', batch_start, batch_start + 1000)
                       .order(:player_id).pluck(:player_id).uniq
        batch_start += 1000
      end

      next_existing = existing.pop
      while i < next_existing
        puts "creating #{i}"
        Self.create_from_scratch(i)

      end
      i += 1
    end
  end

  def update_from_players_page
    # page = load_url('/Users/byoung/Documents/play/usta_scrape/player_page_original.html')
    page = load_url(url)
    raise "trying to create bad id: #{url}" if page.text.include?('Oops!')
    name = remove_extra_spaces(page.css('font').last.text)
    info = page.css('.PlayerInfo')
    columns = info.css('td')
    usta_number, expiration_date, = row_values(parse_column_text(columns[0]))
    rating, _description, city, gender = parse_column_text(columns[1])

    city, gender = row_values([city, gender])

    Rating.create_from_string(id, rating)
    update(city: city, gender: gender, name: name, usta_number: usta_number,
           expiration_date: expiration_date, last_complete_save: Time.now)
  end

  def url
    "https://www.ustanorcal.com/playermatches.asp?id=#{id}"
  end

  def self.create_from_scratch(id)
    new(id: id).update_from_players_page
  end

  def expiration_date=(date)
    if date.is_a?(String) && date.include?('/')
      month, day, year = date.split('/').map(&:to_i)
      date = Time.new(year, month, day)
    end
    super(date)
  end
end
