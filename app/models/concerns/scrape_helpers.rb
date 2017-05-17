module ScrapeHelpers

  def load_url(url)
    return url if url.is_a?(Nokogiri)
    content = open(url)

    Nokogiri::HTML(content)
  end

  def id_from_column(column)
    id_from_anchor(column.css('a').last)
  end

  def id_from_anchor(anchor)
    id_from_url(anchor.values.last)
  end

  def id_from_url(url)
    url.split('=').last.to_i
  end

  def create_minimal_from_column(column)
    name = column.text.strip
    id = id_from_column(column)
    find_or_create_by(name: name, id: id)
  end
end