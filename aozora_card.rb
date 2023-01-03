require 'open-uri'
require 'nokogiri'
require 'uri'

class CardCrawler
  attr_reader :card_url

  def initialize(card_url)
    @card_url = card_url
  end

  def card_crawl
    card_html = fetch_html(card_url)
    body_xhtml_link = find_body_xhtml_link(card_html)
    fetch_html(body_xhtml_link)
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

  def find_body_xhtml_link(card_html)
    doc = Nokogiri::HTML.parse(card_html, nil, nil)
    link = doc.at_css('table.download td:contains("XHTML") ~ td a').attr('href')
    URI.join(card_url, link)
  end
end

if __FILE__ == $PROGRAM_NAME
  card_url = ARGV[0] || 'https://www.aozora.gr.jp/cards/001383/card56875.html'
  crawler = CardCrawler.new(card_url)
  crawler.card_crawl
end
