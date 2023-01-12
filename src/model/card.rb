require 'open-uri'
require 'nokogiri'
require 'uri'

class Card
  attr_reader :card_url, :html, :title, :body_link

  def initialize(url)
    @card_url  = url
    @html      = fetch_html(card_url)
    @title     = find_title
    @body_link = find_body_link
  end

  def crawl
    logging "crawling #{title}"
    {title: title, body: fetch_body}
  end

  private

  def fetch_html(url)
    sleep 1
    URI.open(url) do |f|
      charset = f.charset
      f.read
    end
  end

  def find_body_link
    doc = Nokogiri::HTML.parse(html, nil, nil)
    link = doc.at_css('table.download td:contains("XHTML") ~ td a').attr('href')
    URI.join(card_url, link)
  end

  def find_title
    doc = Nokogiri::HTML.parse(html, nil, nil)
    link = doc.at_css('head > meta[property="og:title"]').attr('content')
  end

  def fetch_body
    fetch_html(body_link)
  end

  def logging(str)
    puts str
  end
end

if __FILE__ == $PROGRAM_NAME
  card_url = ARGV[0] || 'https://www.aozora.gr.jp/cards/001383/card56875.html'
  card = Card.new(card_url)
  puts card.crawl
end
