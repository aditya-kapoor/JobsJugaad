sha1=`cd /var/www/apps/JobsJugaad/current/ &&  git rev-parse HEAD`
sha2=`cd /var/www/apps/JobsJugaad/current/ && git rev-parse HEAD^`
asset_change_count=`cd /var/www/apps/JobsJugaad/current/ &&  ((git diff --name-status $sha1 $sha2) | grep -Ec '(app|vendor|public)/assets/')`

if [ $asset_change_count -gt 0 ]
then
  `cd /var/www/apps/JobsJugaad/current/ && RAILS_ENV=production bundle exec rake assets:precompile`
else
  echo "skipping precompilation"
fi