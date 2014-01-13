import os
import sys
import shutil
import win32com.client

shell = win32com.client.Dispatch("WScript.Shell")
sysHome = os.path.expanduser('~')

folderSrc = "\\\\192.168.0.200\\c\\tools\\convertScripts\\convert\\"
folderDest = "C:\\convert\\"
if not os.path.isdir(folderDest):
    os.makedirs(folderDest)
shutil.rmtree(folderDest)
shutil.copytree(folderSrc, folderDest)

shortcut1 = shell.CreateShortCut(sysHome + "\\Desktop\\convert_install.lnk")
shortcut1.Targetpath = "\\\\192.168.0.200\\c\\tools\\convertScripts\\convert_install.exe"
shortcut1.WorkingDirectory = "\\\\192.168.0.200\\c\\tools\\convertScripts"
shortcut1.save()

shortcut2 = shell.CreateShortCut(sysHome + "\\Desktop\\convert.lnk")
shortcut2.Targetpath = "c:\\convert"
shortcut2.save()