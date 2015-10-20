CC = /usr/lib64/mpich2/bin/mpicxx 
CC = mpicxx 
# Your Auryn install path
AURYNDIR = /home/zenke/auryn/
# Where you have compiled the static Auryn library libauryn.a
BUILDDIR = $(AURYNDIR)/build/arch/src

CFLAGS= -ansi -Wall -pipe -O3 -ffast-math -funsafe-math-optimizations \
		-march=native -mtune=native -pedantic \
		-I$(AURYNDIR)/src -I$(AURYNDIR)/dev/src

LDFLAGS=-L$(BUILDDIR) -L. -lauryn \
		-lboost_program_options -lboost_serialization -lboost_mpi  

all: sim.timestamp

sim.timestamp: sim_lgnet ratemod.dat
	./sim_lgnet
	> $<

ratemod.dat: ratemod.dat.gz
	gunzip -c $< > $@

sim_%: sim_%.o $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) $< $(LDFLAGS) -o $(subst .o,,$<)

%.o : %.cpp
	$(CC) $(CFLAGS) -c $<

clean: 
	rm -f sim_lgnet ratemod.dat data/lgnet.*
