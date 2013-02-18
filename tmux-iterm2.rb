require 'formula'

class TmuxIterm2 < Formula
  homepage 'https://github.com/gnachman/tmux2'

  head 'git://github.com/gnachman/tmux2.git', :branch => 'mountainlion'

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"

    (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux'

    # Install addtional meta file
    prefix.install 'NOTES'
  end

  def caveats; <<-EOS.undent
    Installed tmux for iTerm2
    Additional information can be found in:
      #{prefix}/NOTES
    EOS
  end

  def test
    system "#{bin}/tmux", "-V"
  end
end

