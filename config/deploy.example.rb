set :ubistrano, {
  :application => :sum_beta,
  :platform    => :sinatra,  # :php, :rails, :sinatra
  :repository  => 'git@github.com:winton/sum.git',
  
  :ec2 => {
    :access_key => '',
    :secret_key => ''
  },
  
  :mysql => {
    :root_password => '',
    :app_password  => ''
  },
  
  :production => {
    :domains => [ 'beta.sumapp.com' ],
    :host    => '174.129.231.24'
  },
  
  :staging => {
    :domains => [ 'staging.beta.sumapp.com' ],
    :host    => '174.129.231.24'
  }
}

require 'ubistrano'

after "deploy:update_code", "deploy:update_crontab"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :web do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end