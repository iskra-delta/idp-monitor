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

            .include "config.inc"

            .area   _HEADER (ABS)
            .org    MONITOR_ADDRESS
page0:      ;; page 0 table only has two entries
            ;; RST 0x00 is debugger start
            ;; RST 0x08 is debugger breakpoint
            jp      rst0
            jp      rst8
init_page0:
            ld      hl,#page0           ; from "our" page 0
            ld      de,#0x0             ; RST 0 vector
            ld      bc,#3               ; jp opcode + address
            ldir
            ld      de,#0x8             ; and rst 8
            ld      bc,#3               
            ret

            ;; monitor code assumes that interrupts are disabled!
rst0:       
            ;; switch ROM off
            out     (0x80),a
            ;; init page 0 of bank 0
            call    init_page0
            ;; switch bank
            out     (0x90),a
            ;; init page 0 of bank 1
            call    init_page0
            ;; and pass control to the debugger 
            jp  rst8

rst8:       ;; the debugger (breakpoint!)
            reti

            
            ;; ----- remote serial protocol -----------------------------------
rsp_init:   ret

            ;; ----------------------------------------------------------------
            ;; rsp_send_packet
            ;; input:
            ;;  de = data
            ;;  b = len
rsp_send_packet:
            ld      a,#'$'
            call    serial_write_a
            ;; send package
            push    bc                  ; store len
rsp_sp_send_byte:
            ld      a,(de)              ; get byte for sending
            ;; TODO escape
            call    serial_write_a      ; write to serial port
            inc     de                  ; next char
            djnz    rsp_sp_send_byte
            ;; all data sent
            pop     bc                  ; restore len
            ;; finish the package with #...
            ld      a,#'#'
            call    serial_write_a
            ;; ...and the checksum.

rsp_ack:    ld      a,#'+'
            call    serial_write_a
            ret

rsp_nak:    ld      a,#'-'
            call    serial_write_a
            ret

rsp_checksum:

            ;; ----- serial comms ---------------------------------------------
serial_init:
            ret

            ;; read byte from serial port to register a
            ;; if byte is not available Z flag is set
serial_read_a:
            ret

            ;; write byte in reg. a to seriap port
serial_write_a:
            ret

            ;; ----- debugger logic -------------------------------------------
dbg_read_byte:
            ret

dbg_write_byte:
            ret

dbg_read_regs:
            ret