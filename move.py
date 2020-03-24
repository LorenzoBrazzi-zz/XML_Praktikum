import shutil
import os

sourceXSL = '/Users/lorenzobrazzi/Desktop/XSL/'
destXSL = '/Users/lorenzobrazzi/Downloads/basex/webapp'

filesXSL = os.listdir(sourceXSL)

for f in filesXSL:
    shutil.move(sourceXSL+f, destXSL)


sourcexQuery = ''
destxQuery = ''

filesxQuery = os.listdir(sourcexQuery)

for f in filesxQuery:
    shutil.move(sourcexQuery+f, destxQuery)


sourceStatic = ''
destStatic = ''

filesStatic = os.listdir(filesStatic)

for f in filesStatic:
    shutil.move(sourceStatic+f, destStatic)