module_name = Pm
bin = pm
garbage = ./build

build: $(module_name).hs
	ghc -main-is $(module_name) $(module_name).hs -o $(bin) -outputdir $(garbage)

run: build
	./$(bin)

clean:
	$(RM) -r $(garbage)
