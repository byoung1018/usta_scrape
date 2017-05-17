
class Scraper




  attr_accessor :pages_loaded_count, :players_processed_count, :mod_count, :processed_some

  def initialize
    @processed_some = false
    @pages_loaded_count = 0
    @players_processed_count = 0
    @mod_count = 0
  end

  def print_nodes(nodes)
    nodes.each {|node| puts node}
  end

  def pause
    # p hit any key to continue
    # gets
  end

  def href(node)
    "http://www.ustanorcal.com/#{node.attributes["href"].value}"
  end

  def write_doc(doc)
    File.open("output.html", 'w') { |file| file.write(doc.to_html) }
  end

  def load(url)
    url = href(url) if url.class.name != "String"
    html = Nokogiri::HTML(open(url))
    puts "loading #{url}"
    @pages_loaded_count += 1

    html
  end

  def process_link_at_url(url)
    html = load(url)
    links = html.css('td > a')
    byebug if links.length < 1
    links.drop(1).each {|link| yield(link)}
  end

  def write_error(error)
    open("log.txt", 'a') {|file| file.write("#{error}\r\n")}
  end

  def process_team_page(url)

    processed_any = false
    html = load(url)
    tables = html.css('tr tr')
    tables.each do |row|
      if row.to_html.include?("=\"play") && !row.to_html.include?("Captain")
        processed_any = true
        process_player(row)
      end
    end
    write_error("no links for #{url}") unless processed_any
  end

  def process_player(player)
    url = player.css("a")[0].attributes["href"].value
    name = player.css("td:nth-of-type(1)")[0].text.strip
    gender = player.css("td:nth-of-type(3)")[0].text
    rating = player.css("td:nth-of-type(4)")[0].text
    rating_type = rating[-1]
    rating = rating[0..2]
    @players_processed_count += 1
    puts "#{@players_processed_count} processed #{name}"
    # save(name, url, rating, gender)
    @db.execute("INSERT INTO Users ( Name, Rating, Gender, URL, Rating_Type ) VALUES ( ?, ?, ?, ?, ? )", [name, rating, gender, url, rating_type])
  end

  def save(name, url, rating, gender)
    folder_path = ""
    i = 0
    4.times do
      i += 1 if name[i] == " "
      folder_path += "#{name[i]}/".downcase
      Dir.mkdir(folder_path) unless Dir.exists?(folder_path)
      i += 1
    end


    new_entry = "\"#{name}\",\"#{rating}\",\"#{gender}\",\"#{url}\""
    file = name[i] == nil ? "names_too_short" : "#{folder_path}/#{name[i].downcase}.txt"

    return if file_contains?(file, new_entry)
    open(file, 'a') {|file| file.write("#{new_entry}\r\n")}
  end

  def file_contains?(file, new_entry)
    return false unless File.exists?(file)
    File.open(file, "r") do |f|
      f.each_line do |line|
        return true if line.strip == new_entry
      end
    end

    false
  end

  def process_all_current


    all_levels_link = "http://www.ustanorcal.com/listdivisions.asp"
    process_link_at_url(all_levels_link) do |level| #load all levels
      process_link_at_url(level) do |team| #

        process_team_page(team) if @mod_count % 3 == 0
        @mod_count += 1
      end
    end
    @db.close
  end
end
# a = Scraper.new
# a.process_all_current
