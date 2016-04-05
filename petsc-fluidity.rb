# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula

class PetscFluidity < Formula
  desc ""
  homepage ""
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.6.3.tar.gz"
  version "3.6.3-fluidity"
  sha256 "2458956c876496f3c8160591324459be7c11f2e1ce09ad98347394c67a46d858"

  depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "hypre"
  depends_on "gcc"
  depends_on "netcdf" => "with-fortran"
  depends_on "hdf5" => "with-mpi"
  depends_on "valgrind"
  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran

  keg_only "Don't conflict with default homebrew petsc installation."

  fails_with :llvm 
  fails_with :clang
  fails_with :gcc_4_0

  def oprefix(f)
    Formula[f].opt_prefix
  end



  def install
    ENV.deparallelize

    ENV["OMPI_FC"] = ENV["FC"]
    ENV["OMPI_F77"] = ENV["FC"]

    ENV["PETSC_DIR"] = Dir.getwd

    ENV["MPICC"] = "#{HOMEBREW_PREFIX}/bin/mpicc-5"
    ENV["MPICXX"] = "#{HOMEBREW_PREFIX}/bin/mpicxx-5"

    system "./configure", "--with-shared-libraries=0",
                          "--with-pic=fPIC",
                          "--with-cc=#{ENV["MPICC"]}",
                          "--with-cxx=#{ENV["MPICXX"]}",
                          "--with-fc=#{ENV["MPIFC"]}",
                          "--with-debugging=0",
                          "--useThreads 0",
                          "--with-clanguage=c++",
                          "--with-c-support",
                          "--with-fortran-interfaces=1",
                          "--download-blacs",
                          "--with-hypre-dir=#{oprefix("hypre")}",
                          "--download-ml",
                          "--download-ctetgen",
                          "--download-chaco",
                          "--download-metis",
                          "--download-parmetis",
                          "--download-exodusii",
                          "--with-netcdf=1",
                          "--with-netcdf-dir=#{oprefix("netcdf")}",
                          "--with-hdf5",
                          "--with-hdf5-dir=#{oprefix("hdf5")}",
                          "--download-ptscotch",
                          "--download-mumps",
                          "--download-suitesparse",
                          "--download-scalapack",
                          "--with-scalar-type=real",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"

  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test petsc-lite`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
