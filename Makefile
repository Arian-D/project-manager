bin = pm
garbage = ./build

build:
	ghc -o $(bin) Main.hs -outputdir $(garbage)

run: build
	./$(bin)

clean:
	$(RM) -r $(garbage)
