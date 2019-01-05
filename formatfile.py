# -*- coding: utf-8 -*-
"""
Created on Wed Jan 31 22:06:09 2018
format the data
@author: fatmi
"""
import re

fo = open("MFE-C-1-6.txt","r+")
tarFile = open("foramt-MFE-C.txt","w")
seqnumber = 1

while(True):
    #create the sequence for folding
    seqRead = fo.readline()
    if len(seqRead) == 0:
        break
    seqChop = seqRead.strip()
    if seqChop[0:3] != "GCA":
        result = re.search('-\d{0,2}\.\d{0,2}',seqChop)
        textout = str(result.group(0))    
        tarFile.write(textout)
        tarFile.write("\n")

#close file handle
fo.close()
tarFile.close()
