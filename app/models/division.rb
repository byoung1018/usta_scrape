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

class Division < ApplicationRecord
  extend ScrapeHelpers
  has_many :division_memberships
  has_many :teams

  before_validation :sanitize_attributes
  # validates_presence_of :division_type, :age_group, :level, :gender, :year, :label
  DIVISION_TYPES = ['Mixed', 'MX Tri-Level', 'Tri-Level', 'Adult', 'Combo', 'Super Senior', 'Senior']
  AGE_GROUPS = ['18', '40', '50', '55', '60', '65', '70', 'Fifty']
  LEVELS = ['2.0', '2.5', '3.0', '3.5', '4.0', '4.5', '5.0', '5.5',
            '6.0', '7.0', '8.0', '9.0', '10.0',
            '6.5', '7.5', '8.5', '9.5', '10.5', 'Open'  ]
  GENDERS = ['Mens', 'Womens', 'Mixed']


  def self.create_from_division_page(url)
    division_page = load_url(url)
    id = id_from_url(url)
    title = division_page.css('strong')
    raise "there is more than one strong tag on #{url}" if division_page.count > 1
    label = title.to_html.gsub('<br>', ' ')
    create_from_label(id, label)

  end

  def self.create_from_current_division_list
    errors = []
    division_links.each do |link|
      id = id_from_anchor(link)
      next if self.find_by(id: id)

      erros << create_from_label(id, link.text)
    end
  end

  def self.create_from_label(id, label)
    found = self.find_by(id: id)
    return found if found
    attributes = parse_division_label(label)
    division = self.new(attributes)
    division.id = id
    division.label = label
    if division.save
      "created #{label}"
    else
      #error (need to create handling for automation)
      # byebug
      puts "could not create #{label}/n attributes: #{attributes}"
      "could not create #{label}/n attributes: #{attributes}"
    end
  end

  def self.division_links
    html = load_url('https://www.ustanorcal.com/listdivisions.asp')
    all_links = html.css('a')

    all_links.select{|link| link.values.first.include?('listteams.asp?leagueid=')}
  end

  # eg. label == '2017 Mixed 18 & Over 10.0'
  def self.parse_division_label(label)
    division = {}
    division[:year] = label[/[0-9]{4}/]
    label = label[5..-1]
    # for each of those, if something in those lists is found, assign that
    # to the corrisponding attribute and gsub it from the label
    ['DIVISION_TYPES', 'AGE_GROUPS', 'LEVELS', 'GENDERS'].map do |attribute_options|
      eval(attribute_options).each do |attribute_option|
        if label.include?(attribute_option)
          attribute_name = attribute_options.downcase.singularize.to_sym
          division[attribute_name] = attribute_option
          label.gsub!(attribute_option, '')
        end
      end
    end

    division
  end

  def sanitize_attributes
    self.division_type = 'Adult' if ['Super Senior', 'Senior'].include?(self.division_type)
    self.gender = 'mixed' if ['Mixed', 'MX Tri-Level'].include?(division_type)
    self.age_group ||= '18'
  end

end
