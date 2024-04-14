            ;; sio.s
            ;; 
            ;; driving parter's Z80 SIO/1 chip.
            ;; 
            ;; 2023-09-18   tstih
            .module sio

            .equ RS232_CTL, 0xef
            .equ RS232_DTA, 0xf7
		    .equ CTS_ON, 0xff
            .equ CTS_OFF, 0xef
            .equ RESULT_SUCCESS, 0x00

            .area   _CODE
sio_init::
            ret

            ;; read byte from serial port to register a
            ;; if byte is not available Z flag is set
sio_read_a::
            ret

            ;; write byte in reg. a to seriap port
sio_write_a::
            ;; fuse emulator hack, fuse waiting for down signal
            ld      d,a                 ; store a
            ld      a,#0xfe             ; signal tx to low 
            out     (RS232_DTA),a

            ;; send the start bit
            ld      bc,#0x01ff          ; b=0x01, c=0xff  
            ld      a,c
            out     (RS232_DTA),a       ; start bit

            ;; start sending out bits
            srl     d                   ; LSB to carry... 
            rla                         ; ...and to LSB of a 
            xor     b                   ; negate bit 0 
            out     (RS232_DTA),a       ; out bit

            srl     d			
            rla				
            xor     b						
            out     (RS232_DTA),a

            srl     d
            rla
            xor     b
            out     (RS232_DTA),a

            srl     d
            rla
            xor     b
            out     (RS232_DTA),a

            srl     d
            rla
            xor     b
            out     (RS232_DTA),a

            srl     d
            rla
            xor     b
            out     (RS232_DTA),a

            srl     d
            rla
            xor     b
            out     (RS232_DTA),a

            srl     d
            rla
            xor     b
            out     (RS232_DTA),a

            ;; emit stop bit!
            ld      a,#0xfe         ; load a with stop bit 
            
            ;; fuse hack: retransmit stop bit three times for fuse		
            out     (RS232_DTA),a   ; emit stop bit
            out     (RS232_DTA),a
            out     (RS232_DTA),a

            ret