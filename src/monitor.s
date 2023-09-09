            ;; monitor.s
            ;; 
            ;; the monitor
            ;;
            ;; MIT License (see: LICENSE)
            ;; copyright (c) 2023 tomaz stih
            ;;
            ;; 2023-09-09   tstih
            .module monitor

            .include "config.inc"

            .area   _HEADER (ABS)
            .org    MONITOR_ADDRESS
page0:
            jp      rst0
            jp      rst8
            jp      rst10
            jp      rst18
            jp      rst20
            jp      rst28
            jp      rst30
            jp      rst38
            jp      nmi

            ;; the code
rst0:       
            di
            ;; switch ROM off
            out     (0x80),a
            ;; init page 0 of bank 0
            call    rst0_init_page0
            ;; switch bank
            out     (0x90),a
            ;; init page 0 of bank 1
            call    rst0_init_page0
            ;; now initialize required interrupt vectors
            ;; ...todo...
            ;; enable interrupts
            im  2
            ei
            ;; and pass control to the debugger 
            jp  rst8

rst0_init_page0:
            ld      hl,#0x0000          ; initialize page 0
            ld      de,#0               ; initial value
            call    fill_page           ; fill page 0 with zeroes
            ld      hl,#0x0000          ; RST vectors
            ld      de,#page0           ; to page 0
            ld      a,#8                ; 8 vectors
rst0_loop:  ld      bc,#3               ; 3 bytes
            ldir    
            ;; skip over 5 bytes to next rst
            inc     hl
            inc     de
            inc     hl
            inc     de
            inc     hl
            inc     de
            inc     hl
            inc     de
            inc     hl
            inc     de
            dec     a
            jr      nz,rst0_loop        ; next vector
            ;; and copy nmi, hl already points to the correct address
            ld      de,#0x0066
            ld      bc,#3
            ldir
            ret

rst8:       
            reti

rst10:       
            reti

rst18:       
            reti

rst20:       
            reti

rst28:       
            reti

rst30:       
            reti

rst38:       
            reti

nmi:       
            reti


            ;; fill page in hl with value in de
fill_page:  ld      a,#128              ; 128 x 2 bytes = 256 bytes
fill_page_loop:
            ;; copy 2 bytes from de to (hl)
            ld      (hl),e
            inc     hl
            ld      (hl),d
            inc     hl
            dec     a
            jr      nz,fill_page_loop
            ret