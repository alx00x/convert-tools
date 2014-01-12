import shutil
import os

folderSrc = "\\\\192.168.0.200\\c\\tools\\convert\\"
folderDest = "C:\\convert\\"
if not os.path.isdir(folderDest):
    os.makedirs(folderDest)
shutil.rmtree(folderDest)
shutil.copytree(folderSrc, folderDest)

print os.listdir(folderDest)