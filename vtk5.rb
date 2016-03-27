class Vtk5 < Formula
  homepage "http://www.vtk.org"
  url "http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz" # update libdir below, too!
  sha256 "f1a240c1f5f0d84e27b57e962f8e4a78b166b25bf4003ae16def9874947ebdbb"
  head "git://vtk.org/VTK.git", :branch => "release-5.10"
  revision 2

  deprecated_option "examples" => "with-examples"
  deprecated_option "qt-extern" => "with-qt-extern"
  deprecated_option "qt" => "with-qt"
  deprecated_option "python" => "with-python"
  deprecated_option "tcl" => "with-tcl"
  deprecated_option "remove-legacy" => "without-legacy"

  

  depends_on "cmake" => :build
  depends_on :x11 => :optional
  depends_on :python 
  depends_on "libtiff"
  depends_on :mpi => [:cc, :cxx]

  keg_only "Different versions of the same library"

  # Fix bug in Wrapping/Python/setup_install_paths.py: http://vtk.org/Bug/view.php?id=13699
  # and compilation on mavericks backported from head.
  patch :DATA

  def install
    libdir = if build.head? then lib; else "#{lib}/vtk-5.10"; end

    args = %W[
      -Wno-dev
      -DCMAKE_C_COMPILER=#{ENV["CC"]} 
      -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
      -DVTK_USE_MPI=ON
      -DMPI_C_COMPILER=#{ENV["MPICC"]}
      -DMPI_CXX_COMPILER=#{ENV["MPICXX"]}
      -DVTK_REQUIRED_OBJCXX_FLAGS=""
      -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG
      -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
      -DVTK_USE_CARBON=OFF
      -DVTK_USE_HYBRID:BOOL=ON
      -DVTK_USE_COCOA:BOOL=ON
      -DVTK_USE_TK=OFF
      -DCMAKE_BUILD_TYPE=Release
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_INSTALL_RPATH:STRING=#{libdir}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{libdir}
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
      -DVTK_USE_SYSTEM_TIFF=ON
      -DVTK_USE_PARALLEL:BOOL=ON
      -DVTK_WRAP_TCL=OFF
      -DVTK_WRAP_PYTHON=ON
    ]
    args << "-DPYTHON_LIBRARY='#{`python-config --prefix`.chomp}/lib/libpython2.7.dylib'"
args << "-DVTK_PYTHON_SETUP_ARGS:STRING='--prefix=#{prefix} --single-version-externally-managed --record=installed.txt'"
    mkdir "build" do
      args << ".."
      system "cmake", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    s = ""
    s += <<-EOS.undent
        Even without the --with-qt option, you can display native VTK render windows
        from python. Alternatively, you can integrate the RenderWindowInteractor
        in PyQt, PySide, Tk or Wx at runtime. Read more:
            import vtk.qt4; help(vtk.qt4) or import vtk.wx; help(vtk.wx)

        VTK5 is keg only in favor of VTK6. Add
            #{opt_prefix}/lib/python2.7/site-packages
        to your PYTHONPATH before using the python bindings.
    EOS

    if build.with? "examples"
      s += <<-EOS.undent

        The scripting examples are stored in #{HOMEBREW_PREFIX}/share/vtk

      EOS
    end
    s.empty? ? nil : s
  end
end

__END__
diff --git a/Wrapping/Python/setup_install_paths.py b/Wrapping/Python/setup_install_paths.py
index 00f48c8..014b906 100755
--- a/Wrapping/Python/setup_install_paths.py
+++ b/Wrapping/Python/setup_install_paths.py
@@ -35,7 +35,7 @@ def get_install_path(command, *args):
                 option, value = string.split(arg,"=")
                 options[option] = value
             except ValueError:
-                options[option] = 1
+                options[arg] = 1

     # check for the prefix and exec_prefix
     try:

