class FluidityDev < Formula

  url "https://github.com/jrper/mac_modulefiles.git"

  depends_on "libspud"
  depends_on "petsc-fluidity"
  depends_on "jrper/fluidity/zoltan"
  depends_on "modules"
  depends_on "gmsh"
  depends_on "numpy"
  depends_on "scipy"
  depends_on "matplotlib"
  depends_on "gnu-sed"
  depends_on "udunits"
  depends_on "netcdf" => "with-fortran"

  def install
    mkdir "#{prefix}/fluidity-dev"
    FileUtils.install "modulefiles/fluidity-dev/homebrew", "#{prefix}/fluidity-dev/homebrew"
  end

  def caveats

    s = ""
    s += <<-EOS.undent
        To use the fluidity-dev environment module add
           export MODULEPATH=$MODULEPATH:#{prefix}/fluidity-dev/homebrew
        to your .profile file after the point you source the Modules shell 
        init file.
    EOS
  end
end
