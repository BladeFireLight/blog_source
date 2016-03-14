##############
# Jekyll tasks
##############

# Usage: rake serve, rake serve:prod
task :serve => ["serve:dev"]
namespace :serve do

  desc "Serve development Jekyll site locally"
  task :dev do
    puts "Starting up development Jekyll site server..."
    system "bundle exec jekyll serve --no-watch --config _config.yml,_config.dev.yml"
  end
  desc "Serve development Jekyll site locally and watch for changes"
  task :watch do
    puts "Starting up development Jekyll site server..."
    system "bundle exec jekyll serve --config _config.yml,_config.dev.yml"
  end
  desc "Serve production Jekyll site locally"
  task :prod do
    puts "Starting up production Jekyll site server..."
    system "bundle exec jekyll serve --no-watch"
  end
  desc "Regenerate files and drafts for development"
  task :drafts do
    puts "* Regenerating files and drafts for development..."
    system "bundle exec jekyll serve --no-watch --config _config.yml,_config.dev.yml --profile --drafts"
  end
end

# Usage: rake build, rake build:dev, rake build:drafts
task :build => ["build:prod"]
namespace :build do

  desc "Regenerate files for production"
  task :prod do
    puts "* Regenerating files for production..."
    system "JEKYLL_ENV=production; bundle exec jekyll build"
  end

  desc "Regenerate files for production (Windows systems)"
  task :win do
    puts "* Regenerating files for production..."
    system "bundle exec jekyll build"
  end

  desc "Regenerate files for development"
  task :dev do
    puts "* Regenerating files for development..."
    system "bundle exec jekyll build --config _config.yml,_config.dev.yml --profile"
  end

  desc "Regenerate files and drafts for development"
  task :drafts do
    puts "* Regenerating files and drafts for development..."
    system "bundle exec jekyll build --config _config.yml,_config.dev.yml --profile --drafts"
  end
end

####################
# Notification tasks
####################

# Usage: rake notify
task :notify => ["notify:pingomatic", "notify:google", "notify:bing"]
desc "Notify various services that the site has been updated"
namespace :notify do

  desc "Notify Ping-O-Matic"
  task :pingomatic do
    begin
      require 'xmlrpc/client'
      puts "* Notifying Ping-O-Matic that the site has updated"
      XMLRPC::Client.new('rpc.pingomatic.com', '/').call('weblogUpdates.extendedPing', 'blog.bladefirelight.com' , 'https://blog.bladefirelight.com', 'https://blog.bladefirelight.com/atom.xml')
    rescue LoadError
      puts "! Could not ping ping-o-matic, because XMLRPC::Client could not be found."
    end
  end

  desc "Notify Google of updated sitemap"
  task :google do
    begin
      require 'net/http'
      require 'uri'
      puts "* Notifying Google that the site has updated"
      Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + URI.escape('https://blog.bladefirelight.com/sitemap.xml'))
    rescue LoadError
      puts "! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found."
    end
  end

  desc "Notify Bing of updated sitemap"
  task :bing do
    begin
      require 'net/http'
      require 'uri'
      puts '* Notifying Bing that the site has updated'
      Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?siteMap=' + URI.escape('https://blog.bladefirelight.com/sitemap.xml'))
    rescue LoadError
      puts "! Could not ping Bing about our sitemap, because Net::HTTP or URI could not be found."
    end
  end
end

##################
# Deployment tasks
##################

# Usage: rake commit
desc "Commit the contents of ./_site to GitHub"
task :commit do
  puts "* Commit : Adding changes in ./_site to repo"
  system "git -C _site add ."
  puts "* Commit : Committing the contents of ./_site "
  system 'git -C _site commit -a -m "Automated Commit : Content Update"'
  puts "* Commit : Pushing commit of ./_site to the GitHub"
  system "git -C _site push"
end

# Usage: rake deploy, rake deploy:win
task :deploy => ["deploy:prod"]
namespace :deploy do
  desc "Regenerate and commit production files and notify services of the update"
  task :prod => ["build", "commit", "notify"] do
  end

  # Usage: rake deploy:win
  desc "Regenerate and commit production files and notify services of the update (Windows systems)"
  #task :win => ["build:win", "commit", "notify"] do
  task :win => ["build:win", "commit" ] do
  end
end
