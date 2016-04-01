class Zoltan < Formula
  homepage "http://www.cs.sandia.gov/Zoltan"
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.81.tar.gz"
  sha256 "9d6f2f9e2b37456cab7fe6714d51cd6d613374e915e6cc9f7fddcd72e3f38780"

  bottle do
    sha256 "133207543f781aa413062f7ecbe80b89e76b96577b62fe150727fa9f499a6d3c" => :yosemite
    sha256 "970454cab90e1c4ed9cccd2042c704d4122a4cfe59d5044d8b193bfcefe8fbe2" => :mavericks
    sha256 "d60f28375337061ea183d9e1112018498ad6dc33acbeaf5764a461b30ad797d5" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on "scotch"
  depends_on "petsc-fluidity"
  depends_on :fortran
  depends_on "gcc"

  mpilang = [:cc, :cxx, :f90]
  depends_on :mpi => mpilang

  fails_with :llvm 
  fails_with :clang
  fails_with :gcc_4_0

  ENV["OMPI_FC"] = ENV["FC"]

  def oprefix(f)
    Formula[f].opt_prefix
  end

  def install
    ENV.deparallelize

    ENV["CC"] = "#{HOMEBREW_PREFIX}/bin/mpicc-5"
    ENV["CXX"] = "#{HOMEBREW_PREFIX}/bin/mpicxx-5"

    args = [
      "--prefix=#{prefix}",
      "CC=#{#{ENV["MPICC"]}}",
      "CXX=#{ENV["MPICXX"]}",
    ]
    args << "--with-parmetis" 
    args << "--enable-zoltan-cppdriver"
    args << "--enable-mpi"
    args << "--with-mpi-compilers=yes"
    args << "--with-gnumake"
    args << "--enable-zoltan-cppdriver"
    args << "--disable-examples"
    args << "--with-parmetis-libdir=#{oprefix("petsc-fluidity")}/lib/"
    args << "--with-parmetis-incdir=#{oprefix("petsc-fluidity")}/include"
    args << "--enable-f90interface"
    args << "FC=#{ENV["MPIFC"]}" 

    mkdir "zoltan-build" do
      system "../configure", *args
      system "make", "everything"
      system "make", "check" if build.with? "check"
      system "make", "install"
    end
  end
end
