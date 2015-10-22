class Workers::PageParser
  @queue = :page_parser

  def self.perform(char)
    IKit::TestIkit::Parser::Runner.new(char).save_resources!
  end
end
