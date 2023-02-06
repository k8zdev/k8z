package main

// #include <stdlib.h>
// #include "stdint.h"
import "C"

func cstr2String(pointer *C.char, size C.int) string {
	if size == 0 || pointer == nil {
		return ""
	}
	return C.GoStringN(pointer, size)
}
