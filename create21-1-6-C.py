#!/usr/bin/python

#open a file for reading
fo = open("sequence.txt","r+")
tarFile = open("result-C.fa","w")
seqnumber = 1

while(True):
    #create the sequence for folding
    seqRead = fo.readline()
    if len(seqRead) == 0:
        break
    seqChop = seqRead.strip()
    header = "GCAUGCACGAAAGUACGUGCU"
    linker = "AUG"
    body = "AA"
    seq = header + linker + body + seqChop
    
    seqp = "".join([str(seqnumber),">","\n"])
    tarFile.write(seq)
    tarFile.write("\n")
    
    seqnumber = seqnumber + 1

#close file handle
fo.close()
tarFile.close()


