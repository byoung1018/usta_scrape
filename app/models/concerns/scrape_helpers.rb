module ScrapeHelpers

  def load_url(url)
    return url if url.is_a?(Nokogiri)
    content = open(url)

    Nokogiri::HTML(content)
  end

  def id_from_column(column)
    id_from_anchor(column.css('a').last)
  end

  def parse_column_text(column)
    raw_text = column.text
    raw_text.split("\n").map(&:strip).reject(&:empty?)
  end

  def id_from_anchor(anchor)
    id_from_url(anchor.values.last)
  end

  def id_from_url(url)
    url.split('=').last.to_i
  end

  def row_values(row)
    row.map {|attr| attr.split(': ').last}
  end

  def create_minimal_from_anchor(anchor)
    attrs = {}
    id = id_from_anchor(anchor)
    name = anchor.text.strip
    if (self.is_a?(Player) ||
        (self.is_a?(Class) && self.name == 'Player')
       ) && name.include?(',')
      lname, fname = name.split(',')
      attrs[:fname] = fname.strip
      attrs[:lname] = lname.strip
    else
      attrs[:name] = name
    end
    begin
      obj = find_or_create_by(id: id)
      obj.update(attrs)
    rescue Exception => e
      binding.pry
      puts 'stop'
    end

    obj
  end

  def create_minimal_from_column(column)
    create_minimal_from_anchor(column.css('a').last)
  end

  def columns_to_strings(columns)
    columns.map{|column| column.text.strip}
  end

  def remove_extra_spaces(string)
    string.split(' ').reject(&:empty?).join(' ')
  end

end