require "template_utils"

install_unless_present("redis-client") {
  run "sudo npm install http://github.com/technoweenie/redis-node-client/tarball/npm"
}

install_unless_present("redis") {
  get_and_install_tarball "http://redis.googlecode.com/files/redis-2.0.1.tar.gz"
}
