from tempfile import NamedTemporaryFile
import shutil
import csv

def countSetBits(n):
 
    count = 0
    while (n):
        n &= (n-1)
        count+= 1
     
    return count
 
 

filename = 'test15 - Kopie.csv'
tempfile = NamedTemporaryFile('w+t', newline='', delete=False)

with open(filename, 'r', newline='') as csvFile, tempfile:
    reader = csv.reader(csvFile, delimiter=',', quotechar='"')
    writer = csv.writer(tempfile, delimiter=',', quotechar='"')
    writer.writerow(next(reader))
    for row in reader:
        for i in range(1,17):
            row[i] = int(row[i])*2.5
        writer.writerow(row)

shutil.move(tempfile.name, filename)


### Function to get no of set bits in binary
### representation of passed binary no. */
##def countSetBits(n):
## 
##    count = 0
##    while (n):
##        n &= (n-1)
##        count+= 1
##     
##    return count
## 
## 
### Program to test function countSetBits
##i = 264917626060800
##print(countSetBits(i))
##  
### This code is contributed by
### Smitha Dinesh Semwal
