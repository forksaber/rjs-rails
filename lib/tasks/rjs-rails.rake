namespace :rjs do
 
  rjs = RjsRails::Build::Api.new


  task "copy_sources" => "assets:environment" do
    rjs.copy_sources
  end

  desc "requirejs assets precompile"
  task "precompile" => "assets:environment" do
    if rjs.config.precompile_required?
      rjs.precompile
    else
      puts "=> skipping rjs precompile (not required)"
    end
  end

end
task "assets:precompile" => ["rjs:precompile"]
