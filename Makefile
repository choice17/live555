.PHONY: cleanObj
cleanObj:
	rm ./*/*.lib
	rm ./*/*.obj

.PHONY: cleanExe
cleanExe:
	rm ./*/*.exe

.PHONY: cleanMak
cleanMak:
	rm ./*/*.mak
	
.PHONY: clean
clean:
	$(cleanObj) 
	$(cleanMak)
	$(cleanExe)
	
