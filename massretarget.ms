dirName = getSavepath();
dirFiles = getFiles(dirName+"\\*.fbx")

filePath = getOpenFileName caption:"Open Options File" types:"HKO File (*.hko)|*.hko"
file = openFile filePath mode:"r+"
str = ""
while not eof file do (
    str += readline file
)
close file
fbxPresetPath = getOpenFileName caption:"Open FBX Preset" types:"FBX Preset (*.fbximportpreset)|*.fbximportpreset"

for f in dirFiles do
(
    file = openFile filePath mode:"wt"
    if matchpattern str pattern:"*" do (
        fileName = getFileNameFile(f)
        fixedStr = substituteString str "*" fileName
        format fixedStr to:file
    )
    close file
    FBXImporterSetParam "LoadImportPresetFile" fbxPresetPath
    importfile f #noPrompt using:FBXIMP
    select (for o in objects where not o.isHiddenInVpt collect o)
    hkSceneExportUtility.useOptionsFile = true
    hkSceneExportUtility.optionsFile = filePath
    hkSceneExportUtility.exportScene true
)