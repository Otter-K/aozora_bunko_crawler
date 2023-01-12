require 'open-uri'
require 'nokogiri'
require 'uri'

class Card
  attr_reader :card_url, :html, :title, :body_link
  SAVE_LOCATION = File.expand_path("../../result_htmls", __dir__)

  def initialize(url)
    @card_url  = url
    @html      = fetch_html(card_url)
    @title     = find_title
    @body_link = find_body_link
  end

  def save_body(file_name = nil)
    file_name ||= "#{title}.html"
    result = crawl
    File.open(file_path(file_name),"w") do |f|
      f.write(result[:body])
    end
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
    title = doc.at_css('head > meta[property="og:title"]').attr('content')
    sub_title = doc.at_css("table[summary='タイトルデータ'] > tr:contains('副題') td:not(.header)")&.text.to_s
    title + sub_title
  end

  def fetch_body
    fetch_html(body_link)
  end

  def file_path(file_name)
    "#{SAVE_LOCATION}/#{file_name}"
  end

  def logging(str)
    puts str
  end
end

if __FILE__ == $PROGRAM_NAME
  card_url = ARGV[0] || 'https://www.aozora.gr.jp/cards/001383/card56875.html'
  card = Card.new(card_url)
  puts card.save_body
end
