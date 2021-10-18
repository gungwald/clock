PGM=clock
BASE_DSK=base-clock.dsk
# It is necessary to use this older version of AppleCommander to support
# the PowerBook G4 and iBook G3. This version only requires Java 1.3.
AC=java -jar AppleCommander-1.3.5-ac.jar
SRC=$(PGM).baz
VOL=$(PGM)
DSK=$(PGM).dsk
APPLEWIN_VER=1.29.10.0
TO_REMOVE=$(PGM).bas $(PGM).tok $(DSK) *~
BASTOKEN=python bastoken/bastoken.py
VBC=python2 virtual_basic/virtualbasic.py

ifeq ($(OS),Windows_NT)
	COPY=copy
	remove=for %%f in $(1) do if exist %%f del %%f
	EMU=$(USERPROFILE)\Dropbox\opt\applewin-$(APPLEWIN_VER)\applewin.exe -no-printscreen-dlg -s7 empty -s6d1
else
	COPY=cp
	remove=for f in $(1); do if [ -f $$f ]; then rm $$f; fi; done
	EMU=wine $(HOME)/Dropbox/opt/applewin-$(APPLEWIN_VER)/applewin -no-printscreen-dlg -s7 empty -s6d1
endif

# There is some kind of problem with turning this into a boot disk
# after it is created by AppleCommander. So, copy an existing boot
# disk instead.
#$(AC) -pro140 $(DSK) $(VOL)

$(DSK): $(PGM).tok
	$(COPY) $(BASE_DSK) $(DSK)
	$(AC) -p $(DSK) $(PGM) BAS 0x801 < $(PGM).tok

$(PGM).tok: $(PGM).bas
	$(BASTOKEN) $(PGM).bas $(PGM).tok

$(PGM).bas: $(SRC)
	$(VBC) $(SRC)

clean:
	$(call remove,$(TO_REMOVE))
