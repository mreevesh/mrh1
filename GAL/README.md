
The Address and IO Decoders allow the 65C02 to simulate the address decoding of the Z80 based RC2014 and SBC Computers

The Address decoder decodes the uper 8 bits of the Address bus [A8-A15] which allows it to create the following memory map:
    ROM 16K - C0xx-FFxx (/ROMCS)
    UPPER RAM 16K - 80xx-BFxx (/RAMCS1)
    LOWER RAM 16K - 00xx-7Fxx (excluding the IO space) (/RAMCS0)
    IO Space 256B - 03x (/IOREQ)

The 65C02 has a single RWB signal to indicate Reading (High), Writing (Low). This signal is split out within the Decoder to create a /RD (Reading - Active Low) and /WR (Writing - Active Low)
For timing purposes both these signals are linked to the Clock input (PHI2) and will only go active during a positive clock cycle, this ensurse the Data and Address Buses are stable before asserting the RW/WR signals.

During a Memory Request the /MEMREQ line is Active Low

During an IO Request the /IOREQ line is Active Low

Address Decoder Pin Map

         --------
PHI2 IN |1     24| Vcc
A15  IN |2     23| OUT /WR
A14  IN |3     22| OUT /RD
A13  IN |4     21| OUT /MEMREQ (Memory Request)
A12  IN |5     20| OUT /IOREQ  (IO Request)
A11  IN |6     19| OUT /RAMCS1 (Upper memory)
A10  IN |7     18| OUT /RAMCS0 (Lower memory)
A9   IN |8     17| OUT /ROMCS  (ROM)
A8   IN |9     16| NC
NC   IN |10    15| NC
NC   IN |11    14| NC
Gnd     |12    13| IN RWB 
         --------


The IO decoder decodes the lower 8 bits of the Address bus [A0-A7] and creates active low Select signals based for each decoded device address, providing the IOREQ line from the Address Decoder is Active (Low)

The IO Decoding is setup as follows:
    ACIA0 - 00-01
    ACIA1 - 02-03
    PIA0  - 04-07
    PIA1  - 08-0B
    IOP0  - 0C-0D
    IOP1  - 0E-0F
    VIA   - 10-1f

When the IOREQ line is low and the address is in range for one of these devices, the associated Select Pin is made Active (Low)

IO Decoder Pin Map 
          --------
A7    IN |1     24| Vcc
A6    IN |2     23| NC
A5    IN |3     22| NC
A4    IN |4     21| NC
A3    IN |5     20| OUT /IOP1
A2    IN |6     19| OUT /IOP0
A1    IN |7     18| OUT /VIA
A0    IN |8     17| OUT /PIA1
IOREQ IN |9     16| OUT /PIA0
NC    IN |10    15| OUT /ACIA1
NC    IN |11    14| OUT /ACIA0
Gnd      |12    13| IN  NC 
          --------

Under Linux or MacOS the following command can be used to write the JED Files to the GALs

Write address_decoder file to GAL22V10D
    minipro -p GAL22V10D -w ADDRESS_DECODER.jed

Write IO_decoder file to GAL22V10D
    minipro -p GAL22V10D -w IO_DECODER.jed