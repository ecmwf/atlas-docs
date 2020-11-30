#include "atlas/library.h"
#include "atlas/runtime/Log.h"

int main(int argc, char* argv[]) {
  atlas::initialize(argc, argv);
  atlas::Log::info() << "Hello from atlas" << std::endl;
  atlas::finalize();
}
