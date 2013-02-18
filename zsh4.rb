require 'formula'

class Zsh4 < Formula
  homepage 'http://www.zsh.org/'
  url 'http://downloads.sourceforge.net/project/zsh/zsh-dev/4.3.10/zsh-4.3.10.tar.bz2'
  sha1 '132f9ce411bf318abccbae9cdc2f8cc14f8be85b'

  depends_on 'gdbm'
  depends_on 'pcre'

  option 'disable-etcdir', 'Disable the reading of Zsh rc files in /etc'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{share}/zsh/functions
      --enable-scriptdir=#{share}/zsh/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
      --program-suffix=4
    ]

    args << '--disable-etcdir' if build.include? 'disable-etcdir'

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install"
  end

  def test
    system "#{bin}/zsh", "--version"
  end

  def caveats; <<-EOS.undent
    To use this build of Zsh as your login shell, add it to /etc/shells.

    If you have administrator privileges, you must fix an Apple miss
    configuration in Mac OS X 10.7 Lion by renaming /etc/zshenv to
    /etc/zprofile, or Zsh will have the wrong PATH when executed
    non-interactively by scripts.

    Alternatively, install Zsh with /etc disabled:

      brew install --disable-etcdir zsh
    EOS
  end
end
