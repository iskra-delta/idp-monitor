        ;; head.s
        ;; 
        ;; page 0 for idp monitor (address 0x0000)
        ;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2023 tomaz stih
        ;;
        ;; 2023-09-09   tstih
        .module head

        .include "config.inc"

        .area   _HEADER (ABS)
        .org    0x0000
        di                              ; disable interrupts (just in case)
        ld      sp,#MONITOR_STACK       ; initialize stack.
        
        ;; now copy the monitor to destination
        ld      hl,#monitor           
        ld      de,#MONITOR_ADDRESS
        ld      bc,#MONITOR_SIZE        
        ldir                        
        
        ;; and jump to it
        jp      MONITOR_ADDRESS
        ;; start of monitor code.
        ;; the monitor is compiled separately to the target
        ;; address and glued to the end of this file by the 
        ;; make process
monitor: