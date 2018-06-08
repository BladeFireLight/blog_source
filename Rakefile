require 'time'
require 'rake'
require 'yaml'
##############
# Jekyll tasks
##############

# Usage: rake serve, rake serve:prod
task :serve => ["serve:dev"]
namespace :serve do

  desc "Serve Jekyll site locally"
  task :dev do
    puts "Starting up Jekyll site server..."
    system "bundle exec jekyll serve "
  end
  desc "Serve Jekyll site locally and do not watch for changes"
  task :nowatch do
    puts "Starting up Jekyll site server..."
    system "bundle exec jekyll serve --no-watch "
  end
  desc "Regenerate files and drafts for development"
  task :drafts do
    puts "* Regenerating files and drafts for development..."
    system "bundle exec jekyll serve --profile --drafts "
  end
end

# Usage: rake build, rake build:dev, rake build:drafts
task :build => ["build:prod"]
namespace :build do

  desc "Regenerate files for production"
  task :prod do
    puts "* Regenerating files..."
    system "JEKYLL_ENV=production; bundle exec jekyll build"
  end

#  desc "Regenerate files for production (Windows systems)"
#  task :win do
#    puts "* Regenerating files..."
#    system "bundle exec jekyll build"
#  end

  desc "Regenerate files and drafts"
  task :drafts do
    puts "* Regenerating files and drafts..."
    system "bundle exec jekyll build --profile --drafts"
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
      XMLRPC::Client.new('rpc.pingomatic.com', '/').call('weblogUpdates.extendedPing', 'www.bladefirelight.com' , 'https://www.bladefirelight.com', 'https://www.bladefirelight.com/atom.xml')
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
      Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + URI.escape('https://www.bladefirelight.com/sitemap.xml'))
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
      Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?siteMap=' + URI.escape('https://www.bladefirelight.com/sitemap.xml'))
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
  system "git -C _site add -A"
  puts "* Commit : Committing the contents of ./_site "
  system 'git -C _site commit -a -m "Automated Commit : Content Update"'
  puts "* Commit : Pushing commit of ./_site to the GitHub"
  system "git -C _site push"
  puts "* Commit : Adding changes in ./ to repo"
  system "git -C . add -A"
  puts "* Commit : Committing the contents of ./ "
  system 'git -C . commit -a -m "Automated Commit : Content Update"'
  puts "* Commit : Pushing commit of ./ to the GitHub"
  system "git -C . push origin"
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

####################
# New Post
###################
desc 'create a new draft post'
task :post, :title do |task, args|
  
  title = args[:title]
  #puts "#{title}"
  system "bundle exec jekyll post #{title} --layout single"
end
