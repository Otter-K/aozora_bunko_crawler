require 'open-uri'
require 'nokogiri'
require 'uri'

class CardCrawler
  attr_reader :card_url, :card_html, :title

  def initialize(card_url)
    @card_url = card_url
    @card_html = fetch_html(card_url)
    @title = title
  end

  def card_crawl
    body_xhtml = fetch_body_xhtml
    puts "crawling #{title}"
    {title:title, body: body_xhtml}
  end

  private

  def fetch_body_xhtml
    body_xhtml_link = find_body_xhtml_link
    fetch_html(body_xhtml_link)
  end

  def find_body_xhtml_link
    doc = Nokogiri::HTML.parse(card_html, nil, nil)
    link = doc.at_css('table.download td:contains("XHTML") ~ td a').attr('href')
    URI.join(card_url, link)
  end

  def fetch_html(url)
    sleep 1
    charset = nil
    URI.open(url) do |f|
      charset = f.charset
      f.read
    end
  end

  def title
    doc = Nokogiri::HTML.parse(card_html, nil, nil)
    link = doc.at_css('head > meta[property="og:title"]').attr('content')
  end
end

if __FILE__ == $PROGRAM_NAME
  card_url = ARGV[0] || 'https://www.aozora.gr.jp/cards/001383/card56875.html'
  crawler = CardCrawler.new(card_url)
  puts crawler.card_crawl
end
