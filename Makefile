.SUFFIXES: .c .u
CC= gcc
# CFLAGS_MAC = -g -Wall -O3 -DHAVE_INLINE -DGSL_RANGE_CHECK_OFF -Winline -funroll-loops -fstrict-aliasing -fsched-interblock -falign-loops=16 -falign-jumps=16 -falign-functions=16 -falign-jumps-max-skip=15 -falign-loops-max-skip=15 -malign-natural -ffast-math -mdynamic-no-pic -mpowerpc-gpopt -force_cpusubtype_ALL -fstrict-aliasing -mcpu=7450 -faltivec
CFLAGS_MAC = -g -Wall -O3 -DHAVE_INLINE -DGSL_RANGE_CHECK_OFF -Winline -fast -I/opt/local/include/gsl
CFLAGS_PTON = -g -Wall -O3 -DHAVE_INLINE=1 -DGSL_RANGE_CHECK_OFF=1
CFLAGS_DEBUG = -g -Wall
CFLAGS = -g -Wall -I/opt/local/include/gsl/ -I/usr/include/sys/ -I/usr/include/

# MAC_LDFLAGS = -lgsl -latlas -lcblas -L/sw/li
LDFLAGS = -lm -lgsl -latlas -lgslcblas
MAC_LDFLAGS = -lgsl -lgslcblas -L/opt/local/lib
C2_LDFLAGS = -lgsl -lcblas -latlas
CYCLES_LDFLAGS = -lgsl -lgslcblas
LSOURCE = utils.c topic.c doc.c hyperparameter.c main.c gibbs.c
LOBJECTS = utils.o topic.o doc.o hyperparameter.o main.o gibbs.o

model=model
data=../jacm/jacm

main:	$(LOBJECTS)
	$(CC) $(CFLAGS) $(LOBJECTS) -o main $(LDFLAGS)

c2:	$(LOBJECTS)
	$(CC) $(CFLAGS_PTON) $(LOBJECTS) -o main $(C2_LDFLAGS)

cycles:	$(LOBJECTS)
	$(CC) $(CFLAGS_PTON) $(LOBJECTS) -o main $(CYCLES_LDFLAGS)

debug:	$(LOBJECTS)
	$(CC) $(CFLAGS_DEBUG) $(LOBJECTS) -o main $(LDFLAGS)

clean:
	-rm -f *.o

train: $(model)

$(model): $(data).dat settings-d4.txt
	./main gibbs $^ $@

tree: tree.txt

tree.txt:
	python tree.py txt $(model)/run000/iter=001000 $(data).voc.txt $(data).txt tree.txt
