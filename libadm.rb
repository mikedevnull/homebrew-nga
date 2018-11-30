class Libadm < Formula
  desc "Audio Definition Model (ITU-R BS.2076) library"
  homepage "https://libadm.readthedocs.io/en/latest/"

  url "https://github.com/IRT-Open-Source/libadm/archive/0.9.0.tar.gz"
  sha256 "6e86f6e9ba82753f1ecf2d2b632a284044cd383718e82062b6a850bea05e0f3f"

  head "https://github.com/IRT-Open-Source/libadm.git"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=OFF" # TODO: change to ON once fix is released
    system "cmake", ".", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <adm/adm.hpp>

      int main(int argc, char const* argv[]) {
        auto admProgramme = adm::AudioProgramme::create(
          adm::AudioProgrammeName("Alice and Bob talking in the forrest"));

        auto admDocument = adm::Document::create();
        admDocument->add(admProgramme);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-fvisibility=hidden", "-L#{lib}", "-llibadm", "test.cpp", "-o", "test"
    system "./test"
  end
end
