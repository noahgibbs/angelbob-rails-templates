def gsub_in_file(regexp, replacement, filename)
  env = IO.read filename
  env.gsub!(regexp, replacement) unless env.include?(replacement)
  File.open(filename, "w") do |env_out|
    env_out.write(env)
  end
end

def install_unless_present(filename)
  if `which #{filename}`.empty?
    yield
  end
end

def get_and_install_tarball(uri, dirname, filename)
  Dir.chdir "/tmp"
  run "wget #{uri}"
  run "tar zxvf #{File.basename(uri)}"
  Dir.chdir(dirname)
  run "./configure && make"
  raise "Couldn't build #{filename}(#{dirname})!" unless File.exist?(filename)
  run "sudo make install"
end

def install_npm_unless_present(package, uri = nil)
  if `npm ls installed | grep #{package}`.empty?
    run "npm install #{uri | package}"
  end
end
