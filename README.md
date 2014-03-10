# OpJam

## Installation

### Extra tools required to be installed:

* FFMPEG
* ImageMagick
* Qt

### Mac
These can be installed with brew or macports (seriously use brew).

### Ubuntu
* apt-get install ffmpeg libavcodec-extra-52
* apt-get install imagemagick

## Deployment

The workflow we are using is that developers should constantly be deploying to
UAT, so that changes can get some initial QA etc.

At the point in time that we feel a version of the site is ready to be rolled
out to production, then first the site should be rolled out to staging as per
instructions below.

This allows us to perform final QA with a copy of production data.

Finally after any fixes the site is deployed to production.

### Environments
* UAT
* staging
* production

Each environemtn has it's own local database that it talks to.

### Custom

`assets:precompile` task happens locally.

### UAT
Relies on the *github/webjam* `develop` branch. (that's what it will `checkout`)

`bundle exec cap uat deploy`

### staging
Chris needs to give approval before this happens.

``` bash
git checkout master
git merge develop
git push origin master
bundle exec cap staging deploy:migrate_db
bundle exec cap staging deploy:migrate_assets
bundle exec cap staging deploy
bundle exec cap staging deploy:migrate # If the above step tells you migrations are pending
bundle exec cap staging unicorn:restart
```

TODO: Write a cap task that pulls in production database and assets into staging
database.


### production
Once in master:

``` bash
tag master
bundle exec cap production deploy
bundle exec cap production deploy:migrate # If the above step tells you migrations are pending
bundle exec cap production unicorn:restart
# Archive all the kanbanery tasks in Done
```


## Versioning

We follow the [Semantic Versioning 2.0.0-rc.1](http://semver.org/).

Also, before tagging a release the `CHANGELOG.md` file should be
updated with a brief summary of what's being included or removed.

## Kanbanery

See the [Kanbanery](http://wiki.opjam.com/display/RND/Kanbanery) page on the
wiki.

## WebJam Lib

### `home_plates.rb`
Handles plates/wall-rings logic.

### `mp3_metadata.rb`
Scrapes mp3 files tags metadata.

### `ffmpeg.rb`
Converts `.mp3` files to `.oga`.

Usage:
```ruby
require 'webjam'
file = File.open('spec/support/full.mp3')
WebJam::Transcode.new(file).to_oga(:type)

```

## Resque

Audio files transcoding is processed in background jobs and
administered by a *[Resque](https://github.com/defunkt/resque)* queue.

The `Transcode` worker is in `app/workers`.

### Runnig Resque
```sh
redis-server /path/to/redis.conf
rake resque:work QUEUE='*'
```
