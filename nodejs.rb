require "template_utils"

install_unless_present("node") {
  get_and_install_tarball("http://nodejs.org/dist/node-v0.2.2.tar.gz",
                          "node-v0.2.2", "node")
}

install_unless_present("npm") {
  run "curl http://npmjs.org/install.sh | sudo sh"
}

install_npm_unless_present("socket.io")
install_npm_unless_present("node-static",
                      "http://github.com/cloudhead/node-static/tarball/master")
