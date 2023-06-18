# 141L

### Program 1:

Program 1 requires us to read 2 bytes at a time: LSW and MSW. We used 4 registers to keep track of the two bytes throughout the program, using 2 registers to save the location and 2 to save the data(r0 to r3). They were kept consistent through one iteration of the program before moving on to the next two bytes to encode. 
To calculate the parity bits, we shifted the data bits to calculate p8 and p4 while we used masks to calculate p2 and p1 so that we can isolate the necessary bits and xor all the bits together for each parity bit.\


As for creating the output byte, since MSW output only requires one parity bit, p8, we immediately created the MSW output after calculating p8 parity bit. As for LSW, we first saved the parity bits p1, p2, and p4 in their individual registers. Then we combined the parity bits first, in the order they appear in the output byte. Then we shifted bits of the input data to place the data bits in the correct position and combine them all together. At the end of the iteration, we store the results into their respective memory locations by adding 30 to the byte location.
</br>
This program only uses 1 jump to handle the looping of the program until we reach the memory location 30, which then we are past the input memory location.
### Program 2:
Program 2 is kind of an extension to program 1. Same as program 1, we use 4 registers to keep track of two bytes throughout the program iteration. Then we start off by calculating all the parity bits. For this program, however, we included the parity bit itself in calculating the parity bit so that we can tell which data bit(or the parity bit itself) is causing the error. We started with p0 by taking the reduction xor of all data bits. Then like program 1, we made masks for calculating p1 and p2, shifting data bits for p4, and simple reduction xor of MSW for p8. We combine all the parity bits to be in a byte form of 0000_p8p4p2p1 to help with error detection and correction(I will refer to this as parity-byte in writing).
</br>
In terms of error detection, we first look at p0 to figure out if we are looking at 0/2 error or 1 error. p0 will be 1 if there is 1 error and p0 will be 0 if there are 0 or 2 errors. We differentiate 0 or 2 errors by looking at the parity-byte: if parity-byte is 0 then there are no errors, but if it is any number greater than 0 then we have 2 errors.
</br>
For error correction, we look at the parity-bit which reveals the bit position of the error bit(ex. 0000_1111 means we have an error in bit 15). If the bit position is less than 8 then we look to fix it in LSW, otherwise in MSW. For the actual correction, we have a bit manipulator, which starts at 1 (0000_0001), and we shift the bit to the correct position to xor with original data and correct the bit.
</br>
Similar to program 1, we save the data by taking the current location and adjusting by 30 but with subtraction.
</br>
There are many jumps in this program. We have the main loop which loops the error detection and correction until all bytes are decoded, p0err which contains instructions when p0 is 1, fixLSW and fixMSW to correct corresponding byte, and out for creating the correct MSW and LSW output and putting it into the correct memory address.
### Program 3:
For program 3, we needed access to one memory location so we used 2 registers, one to save the location and the other to save the data. We also have dedicated registers to save counts for part A, B, and C(r5 to r7), pattern(rC), and the max number of iteration(rD).
</br>
We first start off by capturing the pattern data in location 32 by shifting into position xxxx_x000 where x denotes the pattern bits.
</br>
Going into part A, there are 4 possible sets in which the pattern can occur: bits 7 to 3, 6 to 2, 5 to 1, and 4 to 0. In all of these cases, we shift the data bits to get rid of unwanted bits and put them in the position of xxxx_x000. Then we compare it to the pattern and increase the counter by 1 when they match.
</br>
For part B, we save the previous part A count then compare it to the current part A count at the end of part A iteration. If there is a change in number for the counter, we know that there has been a pattern found within the byte. We then increase the part B counter by 1.
</br>
For part C, there are also 4 possible cases: last 4 bits of current byte + 1st bit of next byte, last 3 + first 2, last 2 + first 3, last 1 + first 4. We start off by getting the next byte data. Then similar to part A, we move the data bits in position xxxx_x000 through the means of shifting and or’ing. If there are cases that match, we increase the counter by 1. Also the ‘break’ of the program is determined in part C, since when we get to byte 31(the last byte of the message) there is no message in the next byte. Thus, the very first thing in part C is checking the location of the current byte, and jumping to the end if we are on the last byte.\
We store the counter information at the end, out of the loop. We store part A and B counter as it is. For part C, we add A and C counters together before storing the count, since we only calculated the boundary-crossing patterns for part C but part C asks for the total number of pattern occurrences.\
Program 3 has the most branches between the 3 programs. We have the main loop that will loop through all the message bytes, 3 branches for part A for ‘if’ statements for matching patterns, 1 branch for part B for ‘if’ statement for matching pattern, 4 branches for part C for ‘if’ statements for matching patterns, count for checking/moving to the next byte, and end for storing the calculated results.
