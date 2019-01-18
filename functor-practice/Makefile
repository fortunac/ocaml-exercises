build:
	ocamlbuild -use-ocamlfind -pkgs 'core,oUnit' -tag 'warn(A),thread' Tree.byte TestTree.byte

debug:
	ocamlbuild -use-ocamlfind -pkgs 'core,oUnit' -tag 'warn(A),thread,debug' Tree.byte TestTree.byte

run:
	ocamlrun TestTree.byte

clean:
	ocamlbuild -clean
