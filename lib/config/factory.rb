module Config
  module Factory
    Dir.glob(File.expand_path('../factory/*.rb', __FILE__)).sort.each(&method(:require))
  end
end
