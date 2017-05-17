namespace :scrape do
  task test: :environment do
    Team.create_from_division_page('https://www.ustanorcal.com/listteams.asp?leagueid=1872')
  end


end
