
all: buildit

buildit:
	cd build && make all

run:
	cd build && make run

clean:
	cd build && make clean
