"""
what is the approximate size of the smallest number never contemplated by humans?

what is the smallest number no-one has seen?
simple version with uniform weights first
assume people have seen N numbers, from 1..2**d
we want the smallest number in the interval not in the set of N samples.
each number is uniformly likely to be in/out of set.
for OUT, prob is (1 - 1/2**d)**N
question is what is expected min value of out set?
ans


"""

from mpmath import *

mp.dps = 200

d = mpf(12)
N = mpf(10000000000) * mpf(1000000)

# universe
T = 10**d

# prob of 1 number with 1 draw being selected
s = 1 / T

# prob of 1 number never being selected in N draws
ns = (1 - s) ** N

# now we want expected value of iterating with ns prob of ending each time
# P(end at k) = (1 - ns) ** (k - 1) * ns
# what is expected length? 1/ns
print(1 / ns)
