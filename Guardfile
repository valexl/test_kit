# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'active_support'
require 'active_support/core_ext'

guard 'rails' do
  watch('Gemfile.lock')
  watch(%r{^config/.*})
end

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim|jbuilder)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|sass|html))).*}) { |m| "/assets/#{m[3]}" }
end

guard 'spork', :wait => 120, :cucumber => false, test_unit: false do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/routes.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }

  # watch(%r{^app/models/(.+)\.rb$})
  # watch(%r{^app/controllers/(.+)\.rb$})
  # watch(%r{^lib/(.+)\.rb$})
end

# guard :rspec do

guard :rspec, cmd: 'bundle exec rspec --drb', :all_on_start => false, :all_after_pass => false, failed_mode: :keep do

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  
  watch('spec/spec_helper.rb')   { "spec" }
  watch('spec/rails_helper.rb')  { "spec" }
  watch('spec/rcntec_auth_helper.rb')  { "spec" }

  
  # watch(%r{^db/migrate/(\d+).+\.rb})                  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.slim)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch(%r{^spec/factories/(.+)\.rb$})                { |m| "spec/models/#{m[1].singularize}_spec.rb" }
  watch(%r{^app/models/(.+)\.rb$})                    { |m| "spec/lib/rcntec/ams/filters/#{m[1].singularize}_spec.rb" }
  watch(%r{^app/models/(.+)\.rb$})                    { |m| "spec/lib/rcntec/ams/searcher/#{m[1].singularize}_spec.rb" }
  watch(%r{^app/models/(.+)\.rb$})                    { |m| "spec/lib/rcntec/ams/form_objects/#{m[1].singularize}_spec.rb" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  # watch(%r{^app/views/(.+)/.*\.(erb|slim)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
end


guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end


