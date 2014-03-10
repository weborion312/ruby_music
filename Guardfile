group 'front' do
  guard :livereload do
    watch(%r{app/helpers/.+\.rb})

    # Non-defaults start here
    watch(%r{app/views/.+\.(erb|haml)})
    watch(%r{(public/).+\.(css|js|html)})
    #watch(%r{app/assets/stylesheets/(.+\.css)$}) { |m| "assets/#{m[1]}" }
    #
    watch(%r{app/assets/stylesheets/(.+\.sass).*$})  { |m| "/assets/application.css" }#
    #
    #{ |m| "assets/#{m[1]}" }
    watch(%r{app/assets/javascripts/(.+\.js)$}) { |m| "assets/#{m[1]}" }
    watch(%r{app/assets/javascripts/(.+\.js)\.(coffee|erb)}) { |m| "assets/#{m[1]}" }
    # Non-defaults end here

    watch(%r{config/locales/.+\.yml})
  end
end

group 'specs' do
  guard 'spin' do
    # uses the .rspec file
    # --colour --fail-fast --format documentation --tag ~slow
    watch(%r{^spec/.+_spec\.rb})
    watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.haml})                         { |m| "spec/#{m[1]}.haml_spec.rb" }
    watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
  end
end

guard 'jasmine' do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$})         { "spec/javascripts" }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)$})  { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
end
