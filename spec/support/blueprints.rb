# require 'machinist/active_record'

# User.blueprint do
#   username                      { "name#{sn}" }
#   email                         { "test#{sn}@test.com" }
#   password                      { "password" }
#   password_confirmation         { "password" }
#   terms_and_conditions_accepted { '1' } # 1 means true, accepted validator only accepts it
#   terms_and_conditions          { TermsAndConditions.current }
#   age_accepted                  { true } 
# end

# AdminUser.blueprint do
#   email { "admin#{sn}@example.com" }
#   password { 'opensesame' }
# end

# Authentication.blueprint do
#   uid { sn }
#   user { nil } # Always set the user manually
# end

# Setting.blueprint do
# end

# Track.blueprint do
#   user { User.make! }
#   name { "blah" }
#   media { File.open("spec/support/empty.mp3") }
#   private { false }
#   pulled { false }
# end

# TermsAndConditions.blueprint do
#   notes   { "These are notes #{sn}" }
#   content { "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus." }
#   active  { false }
# end

# EventLog.blueprint do
#   ip          {"10.1.0.#{sn}"}
# end
