# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libspud < Formula
  desc ""
  homepage ""
  url "lp:spud", :using => :bzr
  sha256 ""
  version "1.1"

  # depends_on "cmake" => :build
  depends_on "libxml2"
  depends_on "python"
  depends_on "trang"
  depends_on "gcc"
  depends_on "pygtk" => "with-libglade"
  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran

  fails_with :llvm 
  fails_with :clang

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    FileUtils.cp Dir["#{HOMEBREW_PREFIX}/Library/Taps/jrper/homebrew-fluidity/wrappers/*"], Dir.getwd

    bin.install "mpicc-5"
    bin.install "mpicxx-5"

    ENV["CC"] = "#{bin}/mpicc-5"
    ENV["CXX"] = "#{bin}/mpicxx-5"

    # Remove unrecognized options if warned by configure
    system "./configure", "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps

    inreplace "#{bin}/diamond", "/usr/share/diamond/gui/diamond.svg", "#{prefix}/share/diamond/gui/diamond.svg"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libspud`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
