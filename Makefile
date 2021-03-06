OUTDIR := stl

all: build

build: $(OUTDIR) parts/*.stl

$(OUTDIR):
	mkdir -p $(OUTDIR)

parts/%.stl : parts/%.scad
	for scad in $?; do \
	  out=`basename "$$scad" .scad`; \
	  openscad \
	    --export-format binstl \
	    -o $(OUTDIR)/"$$out".stl \
	    -D "$$out"=true \
	    -D "all=false" \
	    main.scad; \
	done;
