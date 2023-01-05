require_relative './base_card_saver.rb'

class HTMLCardSaver < BaseCardSaver
  SAVE_LOCATION = File.expand_path("../../result_htmls", __dir__)
  def post_initialize(args)
    @file_name = args[:file_name]
  end

  def save
    File.open(file_path,"w") do |f|
      f.write(card_html)
    end
  end

  private

  def file_path
    "#{SAVE_LOCATION}/#{@file_name}"
  end

end

if __FILE__ == $PROGRAM_NAME
  file_name = ARGV[0] || 'test1.html'
  card_html = <<~EOF
  <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
      </head>
      <body>
        Hello World！
      </body>
    </html>
  EOF

  args = {file_name: file_name, card_html: card_html}
  saver = HTMLCardSaver.new(args)
  saver.save
end
