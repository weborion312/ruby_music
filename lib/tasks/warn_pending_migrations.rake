namespace :db do
  desc 'Warns if there are pending migrations'
  task :warn_if_pending_migrations => :environment do
    pending_migrations = ActiveRecord::Migrator.new(:up, 'db/migrate').pending_migrations

    if pending_migrations.any?
      puts ''
      puts ' * * * * * * * * * * * * * * * * * * * * * * * * * * * *'
      puts ' *                                                     *'
      puts " * You have #{pending_migrations.size} pending migrations:"
      pending_migrations.each do |pending_migration|
        puts ' * %4d %s' % [pending_migration.version, pending_migration.name]
      end
      puts ' *'
      puts ' * Run cap deploy:migrate!'
      puts ' *                                                     *'
      puts ' * * * * * * * * * * * * * * * * * * * * * * * * * * * *'
      puts ''
    end
  end
end
