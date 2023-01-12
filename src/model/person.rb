require 'open-uri'
require 'nokogiri'
require 'uri'
require_relative './card.rb'

class Person
  attr_reader :person_url, :html, :card_links

  def initialize(person_url)
    @person_url = person_url
    @html       = fetch_html(person_url)
    @card_links = find_card_links
  end

  def fetch_cards
    card_links.map {|card_link| fetch_card(card_link) }
  end

  def save_cards
    fetch_cards.each(&:save_body)
  end

  def crawl
    fetch_cards.each(&:crawl)
  end

  private

  def fetch_html(url)
    sleep 1
    URI.open(url) do |f|
      charset = f.charset
      f.read
    end
  end

  def find_card_links
    doc = Nokogiri::HTML.parse(html, nil, nil)
    link_elements = doc.css("h2:has(a[name='sakuhin_list_1']) + ol li a")
    link_elements.map{ |ele| URI.join(person_url, ele.attr(:href)).to_s }
  end

  def fetch_card(card_link)
    Card.new(card_link)
  end

end

if __FILE__ == $PROGRAM_NAME
  person_url = ARGV[0] || 'https://www.aozora.gr.jp/index_pages/person1383.html'
  person = Person.new(person_url)
  person.crawl
end
