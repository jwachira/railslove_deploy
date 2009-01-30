# run a rake task
def rake(task)
  rails_env = fetch(:rails_env, "production")
  rake = fetch(:rake, "rake")
  run "sh -c 'cd #{directory}; #{rake} #{task} RAILS_ENV=#{rails_env} #{rake_env}'"
end


# THANKS: http://dev.animoto.com/articles/capistrano-gem-management
# =========== 
# CAP GEMS
# Author: Stevie Clifton
def gem_list
  fetch(:dependencies, {})[:remote][:gem] rescue {}
end

# Passes the Deploy::Dependency after running a check, the gem, 
# and version to a block.  Deploy::Dependency does not have any
# internal awareness of which gem it is, which make doing this
# a PITA.  Probably would be wiser to extend Deploy::Dependency
# to save the gem name and args so that we could query them directly
#
def with_gem_dependencies &block
  Deploy::Dependencies.new(strategy.configuration) do |d|
    gem_list.each do |gem, version|
      dep = d.remote.gem(gem, version, {})
      yield dep, gem, version
    end
  end
end