all: checkmakefiles
	@cd src && $(MAKE)

clean: checkmakefiles
	@cd src && $(MAKE) clean

cleanall: checkmakefiles
	@cd src && $(MAKE) MODE=release clean
	@cd src && $(MAKE) MODE=debug clean
	@rm -f src/Makefile

INET_PATH ?= ../../inet

OPP_MAKEMAKE_ARGS = -o flora -O out -f --deep -KINET_PROJ=$(INET_PATH) -DINET_IMPORT -I. -I$$\(INET_PROJ\)/src -L$$\(INET_PROJ\)/src -lINET$$\(D\)

CMDENV ?= 0
VERBOSE ?= 0

ifneq (0, $(CMDENV))
  OMNETPP_EXTRA_ARGS += -u Cmdenv
  ifneq (0, $(VERBOSE))
    OMNETPP_EXTRA_ARGS += --cmdenv-express-mode=false
  endif
endif

NETWORK ?= 1

run:
	cd simulations && ../src/flora $(OMNETPP_EXTRA_ARGS) -n ../src:../simulations:../../inet/examples:../../inet/src:../../inet/tutorials -l ../../inet/src/INET -f flora_skeleton.ini -f test_networks/network$(NETWORK).ini

makefiles:
	@cd src && opp_makemake $(OPP_MAKEMAKE_ARGS)
checkmakefiles:
	@if [ ! -f src/Makefile ]; then \
	echo; \
	echo '======================================================================='; \
	echo 'src/Makefile does not exist. Please use "make makefiles" to generate it!'; \
	echo '======================================================================='; \
	echo; \
	exit 1; \
	fi

makefiles-lib:
	@cd src && opp_makemake $(OPP_MAKEMAKE_ARGS) -s

makefiles-static-lib:
	@cd src && opp_makemake $(OPP_MAKEMAKE_ARGS) -a
