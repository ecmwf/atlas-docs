program hello_atlas_f
  use atlas_module
  implicit none

  call atlas_library%initialise()
  call atlas_log%info("Hello from atlas")
  call atlas_library%finalise()
end program
