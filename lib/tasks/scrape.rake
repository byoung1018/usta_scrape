namespace :scrape do
  task test: :environment do
    # Team.create_from_division_page('https://www.ustanorcal.com/listteams.asp?leagueid=1872')
    # TeamMembership.create_memberships_from_team_page('/Users/byoung/Documents/play/usta_scrape/team_page_original.html')

  end


  task get_all_current: :environment do
    Division.create_from_current_division_list
    Division.all.each {|division| Team.create_from_division_page(division.url)}
    Team.where(last_complete_save: nil).each(&:create_players_from_team_page)
  end
end
