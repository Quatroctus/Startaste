; Interpreter routines for Protected Mode

; ============================================ ;
; Run Interpreter Routine
; Arguments: bl: Row
; Outputs: bl: New Row, dl: Column (0)
; ============================================ ;
interpreter_run:
  push ecx

  .get:
  mov dl, 0
  call string_get_row
  mov cl, 0x20
  call string_strip
  call string_lowercase

  .parse:
    .debug_command:
      mov di, interrupter_COMMANDS_debug_command
      call string_compare
      cmp ax, 1
      jne .help_command
      mov si, interrupter_MSGS_debug
      mov eax, 2
      jmp 08h:kernel_end
      jmp .display
    .help_command:
      mov di, interrupter_COMMANDS_help_command
      call string_compare
      cmp ax, 1
      jne .quit_command
      mov si, interrupter_MSGS_help
      mov eax, 1
      jmp .display
    .quit_command:
      mov di, interrupter_COMMANDS_quit_command
      call string_compare
      cmp ax, 1
      jne .no_display
      mov eax, 0
      jmp kernel_quit

  .display:
  inc bl
  call graphics_print_string
  .no_display:
  inc bl
  mov si, COMMAND_MSG
  call graphics_print_string
  mov dl, 1

  .done:
    pop ecx
    ret

interrupter_COMMANDS_help_command db 'help', 0
interrupter_COMMANDS_quit_command db 'quit', 0
interrupter_COMMANDS_debug_command db 'debug', 0
interrupter_MSGS_help db 'HELP: shows this help message. QUIT: hangs kernel.', 0
interrupter_MSGS_debug db 'DEBUG', 0