ca65 hekl_unrom.asm -o hekl_unrom.o

ld65 -C hekl_unrom.cfg hekl_unrom.o -o ""
copy /b hekl_unrom.hdr+_prg\bank00.prg+_prg\bank01.prg+_prg\bank02.prg+_prg\bank03.prg+_prg\bank04.prg+_prg\bank05.prg+_prg\bank06.prg+_prg\bankFixed.prg "The Mad Wizard - A Candelabra Chronicle.nes"
pause
