GENERATEPMPACKAGE = generate-pm-package

all:

dist:always
	mkdir -p dist
	$(GENERATEPMPACKAGE) config/dist/xml-simplegenerator.pi dist/

test:
	prove t/*.t

always: