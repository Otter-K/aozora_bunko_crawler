class BaseCardSaver
  attr_reader :card_html
  def initialize(args)
    @card_html = args[:card_html]

    post_initialize(args)
  end

  def post_initialize(args)
    nil
  end
end
