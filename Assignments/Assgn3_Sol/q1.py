import sys
base = input("Enter the base b:")
num_b = raw_input("Enter Number in base b:")
num_b = num_b.strip()

MAX = 999999999

if base > 36:
	print "Invalid Input"
	sys.exit()
if base < 2:
	print "Invalid Input"
	sys.exit()

val = []

for i in num_b:
	if i=='.' :
		val.append(i)
	else :
		if i>='A' and i<='Z' :
			temp = ord(i) - ord('A')
			temp += 10
			if temp >= base :
				print "Invalid Input"
				sys.exit()
			val.append(temp)
		elif i>='0' and i<='9':
			temp = ord(i) - ord('0')
			if temp >= base :
				print "Invalid Input"
				sys.exit()
			val.append(temp)
		else :
			if i == '-' :
				if not val:
					val.append('-')
					continue
			print "Invalid Input"
			sys.exit()
flag=0
minus=0

print val[0]

if val[0] == '-' :
	minus = 1
	if val[1] > 0 :
		flag = 1
else :
	if val[0] > 0 :
		flag = 1

for i in val:
	if flag == 1 :
		break
	else :
		if minus == 1 :
			del val[1]
		else :
			del val[0]
	if minus == 1 and val[1] > 0 :
		break
	if minus == 0 and val[0] > 0 :
		break

res= 0.0

left_ints = 0
for x in val:
	if x == '-':
		continue
	if x == '.':
		break
	left_ints += 1

right=0
right_nums=-1
for x in val:
	if x == '-':
		continue
	if x == '.':
		right = 1
		continue
	if right == 0:	
		res += x*(base**(left_ints-1))
		left_ints -= 1
		if res > MAX:
			print "Invalid Input"
			sys.exit()
	else:
		res += x*(base**(right_nums))
		right_nums -= 1
		if res > MAX:
			print "Invalid Input"
			sys.exit()
	

if minus == 1:
	res = -1*res
if (res%1) == 0:
	print "%d"%(res)
else:
	#print "%f"%(res) 
	ans = str('%.6f'%res)
	ans = ans.rstrip("0")
	ans = ans.rstrip(".")
	print ans
