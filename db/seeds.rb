if TermsAndConditions.count == 0
  Rake::Task['opjam:terms_and_conditions'].invoke
end

user = User.find_or_create_by_email(
  :email                         => 'user@example.com',
  :password                      => 'password',
  :password_confirmation         => 'password',
  :username                      => 'user'
)
user.terms_and_conditions_accepted = true
user.age_accepted = true

admin = AdminUser.find_or_create_by_email(
  :email                         => 'admin@example.com',
  :password                      => 'password',
  :password_confirmation         => 'password',
)

%w[Superuser Refinery].each { |role|
  Role.find_or_create_by_title(:title => role).save
  admin.roles << Role.find_by_title(role)
}
admin.save!

Rake::Task['opjam:generate_tracks'].invoke if Track.count == 0

# Added by Refinery CMS Pages extension
Refinery::Pages::Engine.load_seed

# Added by Refinery CMS News engine
Refinery::News::Engine.load_seed

# Added by Refinery CMS Inquiries engine
Refinery::Inquiries::Engine.load_seed
