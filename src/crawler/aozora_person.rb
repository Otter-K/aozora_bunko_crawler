require 'open-uri'
require 'nokogiri'
require 'uri'

class PersonCrawler
  attr_reader :person_url

  def initialize(person_url)
    @person_url = person_url
  end

  def person_crawl
    person_html = fetch_html(person_url)
    find_card_links(person_html)
  end

  private

  def fetch_html(url)
    sleep 1
    charset = nil
    URI.open(url) do |f|
      charset = f.charset
      f.read
    end
  end

  def find_card_links(person_html)
    doc = Nokogiri::HTML.parse(person_html, nil, nil)
    link_elements = doc.css("h2:has(a[name='sakuhin_list_1']) + ol li a")
    link_elements.map{ |ele| URI.join(person_url, ele.attr(:href)).to_s }
  end

end

if __FILE__ == $PROGRAM_NAME
  person_url = ARGV[0] || 'https://www.aozora.gr.jp/index_pages/person1383.html'
  crawler = PersonCrawler.new(person_url)
  puts crawler.person_crawl
end
