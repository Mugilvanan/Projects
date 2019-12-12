# ----------------------------------------------------------------------------------
# -- Engineer Name : Mugilvanan Vinayagam
# -- Description   : Python implementaton of conversion of floating point 32-bits
# --                 representation to 8 bit representation.  
# ----------------------------------------------------------------------------------

import struct

def float_to_hex(f):
	return hex(struct.unpack('<I', struct.pack('<f', f))[0])

def fp32_to_fp16(a):
	if a == 0:
		return 0
	sign = (a >> 31) & 1
	# print(sign)
	expo = (a >> 23) & int('ff', 16)
	expo = expo - 127 + 15

	mant = (a & int('7fffff', 16))
	mant = mant >> 13

	if expo < 0:
		expo = 0
		mant = 0;
	# print(expo)

	# print(mant)

	fp16 = (sign << 15) | ((expo << 10) & int('7c00', 16)) | mant

	return fp16

print(hex(int(float_to_hex(0.00001), 16)))
