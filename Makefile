
all: buildit

buildit:
	cd build && make all

run: buildit
	cd build && make run

altrun: buildit
	cd build && make alt && make altrun

clean:
	cd build && make clean
