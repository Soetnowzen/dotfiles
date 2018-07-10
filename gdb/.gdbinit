set prompt \001\033[0;32m\002(gdb)\001\033[0m\002\040

set python print-stack full
set confirm off
set print pretty

define exit
  quit
end

# Breakpoint aliases
define bpl
  info breakpoints
end
document bpl
  list breakpoints
end

# Processs aliases
define stack
  info stack
end
document stack
  print call stack
end

define frame
  info frame
  info args
  info locals
end
document frame
  print stack frame
end
define flags
  if (($eflags >> 0xb) & 1 )
    printf "o "
  else
    printf "o "
  end
  if (($eflags >> 0xa) & 1 )
    printf "d "
  else
    printf "d "
  end
  if (($eflags >> 9) & 1 )
    printf "i "
  else
    printf "i "
  end
  if (($eflags >> 8) & 1 )
    printf "t "
  else
    printf "t "
  end
  if (($eflags >> 7) & 1 )
    printf "s "
  else
    printf "s "
  end
  if (($eflags >> 6) & 1 )
    printf "z "
  else
    printf "z "
  end
  if (($eflags >> 4) & 1 )
    printf "a "
  else
    printf "a "
  end
  if (($eflags >> 2) & 1 )
    printf "p "
  else
    printf "p "
  end
  if ($eflags & 1)
    printf "c "
  else
    printf "c "
  end
  printf "\n"
end
document flags
  print flags register
end

define eflags
  printf " of <%d> df <%d> if <%d> tf <%d>",\
          (($eflags >> 0xb) & 1 ), (($eflags >> 0xa) & 1 ), \
          (($eflags >> 9) & 1 ), (($eflags >> 8) & 1 )
  printf " sf <%d> zf <%d> af <%d> pf <%d> cf <%d>\n",\
          (($eflags >> 7) & 1 ), (($eflags >> 6) & 1 ),\
          (($eflags >> 4) & 1 ), (($eflags >> 2) & 1 ), ($eflags & 1)
  printf " id <%d> vip <%d> vif <%d> ac <%d>",\
          (($eflags >> 0x15) & 1 ), (($eflags >> 0x14) & 1 ), \
          (($eflags >> 0x13) & 1 ), (($eflags >> 0x12) & 1 )
  printf " vm <%d> rf <%d> nt <%d> iopl <%d>\n",\
          (($eflags >> 0x11) & 1 ), (($eflags >> 0x10) & 1 ),\
          (($eflags >> 0xe) & 1 ), (($eflags >> 0xc) & 3 )
end
document eflags
  print entire eflags register
end
define reg
  printf " eax:%08x ebx:%08x ecx:%08x ", $eax, $ebx, $ecx
  printf " edx:%08x eflags:%08x\n", $edx, $eflags
  printf " esi:%08x edi:%08x esp:%08x ", $esi, $edi, $esp
  printf " ebp:%08x eip:%08x\n", $ebp, $eip
  printf " cs:%04x ds:%04x es:%04x", $cs, $ds, $es
  printf " fs:%04x gs:%04x ss:%04x ", $fs, $gs, $ss
  echo \033[31m
  flags
  echo \033[0m
end
document reg
  print cpu registers
end

define thread
  info threads
end
document thread
  print threads in target
end

# data window
define ddump
  echo \033[36m
  printf "[%04x:%08x]------------------------", $ds, $data_addr
  printf "---------------------------------[ data]\n"
  echo \033[34m
  set $_count=0
  while ( $_count < $arg0 )
    set $_i=($_count*0x10)
    hexdump ($data_addr+$_i)
    set $_count++
  end
end
document ddump
  display $arg0 lines of hexdump for address $data_addr
end

define dd
  if ( ($arg0 & 0x40000000) || ($arg0 & 0x08000000) || ($arg0 & 0xbf000000) )
    set $data_addr=$arg0
    ddump 0x10
  else
    printf "invalid address: %08x\n", $arg0
  end
end
document dd
  display 16 lines of a hex dump for $arg0
end

define datawin
  if ( ($esi & 0x40000000) || ($esi & 0x08000000) || ($esi & 0xbf000000) )
    set $data_addr=$esi
  else
    if ( ($edi & 0x40000000) || ($edi & 0x08000000) || ($edi & 0xbf000000) )
      set $data_addr=$edi
    else
      if ( ($eax & 0x40000000) || ($eax & 0x08000000) || ($eax & 0xbf000000) )
        set $data_addr=$eax
      else
        set $data_addr=$esp
      end
    end
  end
  ddump 2
end
document datawin
  display esi, edi, eax, or esp in data window
end
