require_relative 'crawler/aozora_card.rb'
require_relative 'crawler/aozora_person.rb'
require_relative 'saver/base_card_saver.rb'
require_relative 'saver/html_file_saver.rb'

class AozoraBunkoScraper
  attr_reader :person_crawler, :card_crawler, :saver
  def initialize(url)
    @person_crawler = PersonCrawler.new(url)
  end

  def scrape_person
    persons_card_links = person_crawler.person_crawl
    persons_card_links.each do |card_link|
      prepare_card_crawler(card_link)
      result = card_crawler.card_crawl
      prepare_saver(result)
      saver.save
    end
  end

  def prepare_card_crawler(url)
    @card_crawler = CardCrawler.new(url)
  end

  def prepare_saver(result)
    args = {file_name: "#{result[:title]}.html", card_html: result[:body]}
    @saver = HTMLCardSaver.new(args)
  end
end

if __FILE__ == $PROGRAM_NAME
  url = ARGV[0] || 'https://www.aozora.gr.jp/index_pages/person1383.html'
  scraper = AozoraBunkoScraper.new(url)
  scraper.scrape_person
end
