
all: buildit

buildit:
	cd build && make all

run: buildit
	cd build && make run

clean:
	cd build && make clean
