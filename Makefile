root=$(PWD)

project_tcl=$(root)/src/project.tcl
ipx_tcl=$(root)/src/ipx.tcl
build_tcl=$(root)/src/build.tcl

.PHONY: all project ipx build clean

all: 
	cd $(root)/build && vivado -mode batch -source $(project_tcl) $(ipx_tcl) $(build_tcl)

project:
	cd $(root)/build && vivado -mode batch -source $(project_tcl)

ipx:
	cd $(root)/build && vivado -mode batch -source $(ipx_tcl)

build:
	cd $(root)/build && vivado -mode batch -source $(build_tcl)

clean:
	rm -rf build/*
