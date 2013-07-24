namespace :rjs do
 
  rjs = RjsRails::Env.new
  config = rjs.config
  source_dir = config.source_dir
  build_dir = config.build_dir

  def clean_dir(dir)
    print "Cleaning #{dir} ..."
    FileUtils.remove_entry_secure(dir, true)
    FileUtils.mkpath dir
    puts " done"
  end

  class NoCompression
    def compress(string)
      string
    end
  end

   def disable_gc
      GC.disable
      begin
        yield
      ensure
       # GC.enable
       # GC.start
      end
   end

  task "clean_dirs" do
    clean_dir(source_dir)
    clean_dir(build_dir)
  end

  task "build_init" => ["assets:cache:clean", "rjs:clean_dirs"]

  desc "Copy project's all javascript files to #{source_dir}"
  task "copy_js_sources" => [ "assets:environment", "rjs:clean_dirs" ] do
    print "Copying js sources"
    Rails.application.config.assets.js_compressor = NoCompression.new
    assets = Rails.application.assets
    js_assets = assets.each_logical_path(["*.js"])
    num_assets = js_assets.count
    count = 0
    js_assets.each do |logical_path|
      if asset = assets.find_asset(logical_path)
        filename = "#{source_dir}/#{logical_path}"
        asset.write_to(filename)
      end  
      count += 1
      percent = count*100/num_assets
      print "\rCopying js sources .. #{percent}% complete"
    end 
    puts
  end

  desc "Generate build.js for r.js"
  task "prepare_build_js" do
    puts "Generating build.js"
    template = config.template
    output_file = config.build_js
    binding = rjs.get_binding()
    File.open(template) { |f|
      erb = ERB.new(f.read)
      File.open(output_file , 'w') { |of|
        of.write(erb.result(binding))
      }
    }
  end

  desc "Rjs asset build rake task"
  task "optimization" do 
    command = "node #{config.build_js}"
    IO.popen(command) { |f|
      f.each { |line|
        puts line
      }
    }
  end

  task "build_end" => [ 
    "refresh_sprockets_env",
    "additional_assets_for_precompile",
    "reenable_assets_cache_clean"
  ]

  desc "Add #{build_dir} to sprockets index "
  task "refresh_sprockets_env" do
    assets_env = Rails.application.assets.instance_variable_get("@environment")
    assets_env.prepend_path(build_dir)
    assets_env.js_compressor = Uglifier.new
    Rails.application.assets = assets_env.index
  end  
 
  task "additional_assets_for_precompile" do
    assets_array = rjs.assets_for_precompile
    Rails.application.config.assets.precompile.concat(assets_array)
  end  

  task "reenable_assets_cache_clean" do
    Rake::Task["assets:cache:clean"].reenable
  end  


  desc "Build r.js optimized js files to #{build_dir}"
  task "build" => [
    "rjs:build_init",
    "rjs:copy_js_sources",
    "rjs:prepare_build_js",
    "rjs:optimization",
    "rjs:build_end"
  ]

  desc "rjs assets precompile"
  task "precompile" do
    if rjs.precompile_required?
      Rake::Task["rjs:build"].invoke
    end
  end

end
task "assets:precompile" => ["rjs:precompile"]
