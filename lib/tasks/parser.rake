namespace :parser do

  desc "Run parser"
  task :run => :environment do
    IKit::TestIkit::Parser::Main.new.analyze!
  end
end
