            ;; monitor.s
            ;; 
            ;; the monitor. 
            ;; NOTES:
            ;;  - monitor is located in shared memory at the top of memory
            ;;  - it initializes bank 0 and bank 1 zero page (the RST vectors) 
            ;;  - it uses no interrupts: serial comms are implemented by polling.
            ;;  - interrupts are disabled when in monitor mode!
            ;;  - implemented gdb serial protocol is described here:
            ;;    https://www.embecosm.com/appnotes/ean4/embecosm-howto-rsp-server-ean4-issue-2.html
            ;;
            ;; MIT License (see: LICENSE)
            ;; copyright (c) 2023 tomaz stih
            ;;
            ;; 2023-09-09   tstih
            .module monitor

            .globl  sio_init
            .globl  sio_write_a

            .area   _CODE
page0_tbl:  ;; page 0 table only has two entries
            ;; RST 0x00 is debugger start
            ;; RST 0x08 is debugger breakpoint
            jp      rst0
            jp      rst8

init_page0:
            ;; init page 0
            ld      hl,#page0_tbl       ; from "our" page 0
            ld      de,#0x0             ; RST 0 vector
            ld      bc,#3               ; jp opcode + address
            ldir
            ld      de,#0x8             ; and rst 8
            ld      bc,#3               
            ldir                        ; rst 8 handler to page 0
            ret


            ;; monitor code assumes that interrupts are disabled!
rst0:       ld      sp,#stack           ; reset stack
            ;; switch ROM off
            out     (0x80),a
            ;; init page 0 of bank 0
            call    init_page0
            ;; switch bank
            out     (0x90),a
            ;; init page 0 of bank 1
            call    init_page0
            ;; and pass control to the debugger 
rst8:       ;; the debugger (breakpoint!)
            call    sio_init
            ld      hl,#hello
hello_loop$:
            ld      a,(hl)
            or      a
            jr      z,hello_end$
            call    sio_write_a
            inc     hl
            jr      hello_loop$
hello_end$:
            reti
hello:      .asciz  "Hello World!"

            ;; help linker find _DATA segment
            .area   _DATA
            .area   _STACK
            .ds     128
stack::
            .area   _MEMTOP