program hello_atlas_f
  use atlas_module
  implicit none

  call atlas_initialize()
  call atlas_log%info("Hello from atlas")
  call atlas_finalize()
end program
