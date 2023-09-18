            ;; rsp.s
            ;; 
            ;; remote serial protocol (gdb!)
            ;; 
            ;; 2023-09-18   tstih
            .module rsp

            .globl  sio_write_a
            .globl  sio_read_a
     
            .area   _CODE
rsp_init::
            ret

            ;; ----------------------------------------------------------------
            ;; rsp_send_packet
            ;; input:
            ;;  de = data
            ;;  b = len
rsp_send_packet:
            ld      a,#'$'
            call    sio_write_a
            ;; send package
            push    bc                  ; store len
rsp_sp_send_byte:
            ld      a,(de)              ; get byte for sending
            ;; TODO escape
            call    sio_write_a         ; write to serial port
            inc     de                  ; next char
            djnz    rsp_sp_send_byte
            ;; all data sent
            pop     bc                  ; restore len
            ;; finish the package with #...
            ld      a,#'#'
            call    sio_write_a
            ;; ...and the checksum.

rsp_ack:    ld      a,#'+'
            call    sio_write_a
            ret

rsp_nak:    ld      a,#'-'
            call    sio_write_a
            ret

rsp_checksum:
