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
        xor     a