from math import log, floor

bst = raw_input().split()
bst = list(bst)
bst = map(int,bst)

bst.sort()

print bst

indent = "         "
two = 2
sz = len(bst)
done = 1234567843424424232

level = int(log(sz,2))

for i in range(level):
    curr = int(sz/two)
    xx = 1
    for i in range(sz):
        if i is curr:
            print bst[i],
            bst[i] = done
            xx = xx + 2
            curr = (xx*sz)/two
        else:
            print "  ",
    two = two*2
    print

# to print left over
for i in range(sz):
    if bst[i] is done:
        print "  ",
    else:
        print bst[i],
