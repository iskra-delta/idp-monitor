            ;; sio.s
            ;; 
            ;; driving parter's Z80 SIO/1 chip.
            ;; 
            ;; 2023-09-18   tstih
            .module sio
        
            .area   _CODE
sio_init::
            ret

            ;; read byte from serial port to register a
            ;; if byte is not available Z flag is set
sio_read_a::
            ret

            ;; write byte in reg. a to seriap port
sio_write_a::
            ret