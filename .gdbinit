# ____________breakpoint aliases_____________
define bpl
	info breakpoints
end
document bpl
	Show breakpoints.
end

define bpc
	clear $arg0
end
document bpc
	Clear breakpoint number arg0.
end

define bpe
	enable $arg0
end
document bpe
	Enable breakpoint number arg0.
end

define bpd
	disable $arg0
end
document bpd
	Disable breakpoint number arg0.
end


# ___________process information____________
define stack
	info stack
	info frame
	info args
	info locals
end
document stack
	Show stack info.
end

define reg
	printf "  r0:%08X  r1:%08X  r2:%08X", $r0, $r1, $r2
	printf "  r3:%08X  r4:%08X  r5:%08X\n", $r3, $r4, $r5
	printf "  r6:%08X  r7:%08X  r8:%08X", $r6, $r7, $r8
	printf "  r9:%08X r10:%08X r11:%08X\n", $r9, $r10, $r11
	printf " r12:%08X r13:%08X r14:%08X", $r12, $r13, $r14
	printf " r15:%08X r16:%08X r17:%08X\n", $r15, $r16, $r17
	printf "  pc:%08X  ps:%08X  cr:%08X", $pc, $ps, $cr
	printf "  lr:%08X ctr:%08X  mq:%08X\n", $lr, $ctr, $mq
end
document reg
	Print out key register values.
	r0-r31 are general purpose registers.
	f0-f31 are floating-point registers.
	xer is a fixed-point exception register
	fpscr is a floating-point status and control register
	cr is a condition register
	lr is a link register
	ctr is the count register
	v0-v31 are vector registers
	mq is the multiply/quotient divide dividend register
	ps is the machine state register
	pc is a program counter
	parameters to functions are passed in r3-r10 and f1-f13
	r13-r31 and f14-f31 are used for local vars
	r1 is the stack pointer
	r3 or f3 is used for funtion return values (unless returning a
		struct in which case look to r4)
end

define xx
	if $arg0 > 100
		x $arg0
	else
		printf "0x%08X:\tnull\n",$arg0
	end
end

define xs
	if $arg0 > 100
		x/s $arg0
	else
		printf "0x%08X:\tnull\n",$arg0
	end
end

define reinit
	source ~/.gdbinit
end

define regall
	printf "r1: "
	xx $r1
	printf "r2: "
	xx $r2
	printf "r3: "
	xx $r3
	printf "r4: "
	xx $r4
	printf "r5: "
	xx $r5
	printf "r6: "
	xx $r6
	printf "r7: "
	xx $r7
	printf "r8: "
	xx $r8
	printf "r9: "
	xx $r9
	printf "r10: "
	xx $r10
	printf "r11: "
	xx $r11
	printf "r12: "
	xx $r12
	printf "r13: "
	xx $r13
	printf "r14: "
	xx $r14
	printf "r15: "
	xx $r15
	printf "r16: "
	xx $r16
	printf "r17: "
	xx $r17
end

define func
	info functions
end

define var
	info variables
end

define lib
	info sharedlibrary
end

define sig
	info signals
end

define thread
	info threads
end

define dis
	disassemble $arg0
end
document dis
	Disassemble line arg0.
end


# _____________hex/ascii dump an address_____________
define hexdump
printf "%08X : ", $arg0
printf "%02X %02X %02X %02X  %02X %02X %02X %02X", \
	*(unsigned char*)($arg0), *(unsigned char*)($arg0 + 1), \
	*(unsigned char*)($arg0 + 2), *(unsigned char*)($arg0 + 3), \
	*(unsigned char*)($arg0 + 4), *(unsigned char*)($arg0 + 5), \
	*(unsigned char*)($arg0 + 6), *(unsigned char*)($arg0 + 7)
printf " - "
printf "%02X %02X %02X %02X  %02X %02X %02X %02X ", \
	*(unsigned char*)($arg0 + 8), *(unsigned char*)($arg0 + 9), \
	*(unsigned char*)($arg0 + 10), *(unsigned char*)($arg0 + 11), \
	*(unsigned char*)($arg0 + 12), *(unsigned char*)($arg0 + 13), \
	*(unsigned char*)($arg0 + 14), *(unsigned char*)($arg0 + 15)
printf "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", \
	*(unsigned char*)($arg0), *(unsigned char*)($arg0 + 1), \
	*(unsigned char*)($arg0 + 2), *(unsigned char*)($arg0 + 3), \
	*(unsigned char*)($arg0 + 4), *(unsigned char*)($arg0 + 5), \
	*(unsigned char*)($arg0 + 6), *(unsigned char*)($arg0 + 7), \
	*(unsigned char*)($arg0 + 8), *(unsigned char*)($arg0 + 9), \
	*(unsigned char*)($arg0 + 10), *(unsigned char*)($arg0 + 11), \
	*(unsigned char*)($arg0 + 12), *(unsigned char*)($arg0 + 13), \
	*(unsigned char*)($arg0 + 14), *(unsigned char*)($arg0 + 15)
end
document hexdump
	Print a dump of memory at address arg0
end

# __________________process context_______________
define context
printf "________________________________________"
printf "_____________________________[registers]\n"
reg
printf "[%08X]--------------------------------", $r1
printf "------------------------------[stack]\n"
hexdump $r1-86
hexdump $r1-70
hexdump $r1-56
hexdump $r1-40
hexdump $r1-24
#hexdump $r1
printf "[%08X:%08X]----------------------------", $lr, $pc
printf "---------------------------[code]\n"
x /6i $pc
printf "----------------------------------------"
printf "----------------------------------------\n"
end
document context
	Display important memory and code around current line.
end

# _____________process control______________
define n
	ni
	context
end
document n
	Step over instruction
end

define s
	si
	context
end
document s
	Step into instruction
end

define c
	continue
	context
end

define go
	stepi $arg0
	context
end
document go
	Step arg0 instructions
end

define goto
	tbreak $arg0
	continue
	context
end
document goto
	Run until arg0
end

define pret
	#finish
	# Don't trust finish command when no symbol info available
	goto *$lr
	#context
end
document pret
	Return from the current function
end

define start
	tbreak _start
	r
	context
end
document start
	Break start and run.
end

define main
	tbreak main
	r
	context
end
document main
	Start program and break on main
end


# _____________gdb options______________
set confirm 0
set verbose off
set output-radix 0x10
set input-radix 0x10

