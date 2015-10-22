class IKit::TestIkit::Parser::Main
  def initialize
    @alphabet = ('a'..'z').to_a
  end

  def analyze!
    @alphabet.each do |char|
      Resque.enqueue(Workers::PageParser, char)
    end
  end

end
