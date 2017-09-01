#! /usr/bin/env python

import xlrd
import csv
import os


currentDir = os.getcwd()

filePathXLS= str().join([currentDir, "/recipes.xls"])
pathCSV= str().join([currentDir, "/csv/"])


book = xlrd.open_workbook(filePathXLS)

#count = 1

for sheet in book.sheets():
    
    print sheet.name
    
    filePathCSV = str().join([pathCSV, sheet.name, ".csv"])
#    filePathCSV = str().join([pathCSV, "Rezept ", str(count), ".csv"])
    
    csvWriter = csv.writer(open(filePathCSV, 'w'), delimiter='|', quotechar="", quoting=csv.QUOTE_NONE, lineterminator='\n')
    
    for i in range(sheet.nrows):
        
        test = sheet.row_values(i)
        
#        print test
        
        for index, object in enumerate(test):
            
            item = test[index]
            
            if type(item) == type(unicode()):
                test[index] = item.encode('utf-8')
                test[index] = test[index].replace("\n","")
                test[index] = test[index].replace("\r","")
        
            elif type(item) == type(str()):
                test[index] = item
                test[index] = test[index].replace("\n","")
                test[index] = test[index].replace("\r","")

            if sheet.cell(i, index).ctype in (2,3) and int(test[index]) == test[index]:
                test[index] = int(test[index])

        csvWriter.writerow(test)

#    count = count + 1