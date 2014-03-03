module RjsRails
  class Sources

    attr_accessor :env

    def initialize(env = nil)
      @env = env
    end

    def paths
      @paths ||= load_paths
    end

    private

    def sources_path
      @sources_path ||= Pathname.new(sources_file)
    end

    def readable?
      sources_path.readable?
    end

    def load_paths
      return [] if not readable?
      File.open sources_path do |f|
        paths = YAML.load f.read
        paths.is_a? Array ? paths : []
      end
    end

    def sources_file
      env.sources_yml
    end

    def env
      @env ||= ::RjsRails::Env.new
    end


  end
end
