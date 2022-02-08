with import <nixpkgs> { };

mkShell { buildInputs = [ gnumake autoconf automake libtool gmp ]; }
