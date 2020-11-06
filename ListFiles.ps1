#PROMPT FOR FILEPATH

Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$null = $browser.ShowDialog()
$selectedpath = $browser.SelectedPath

#File for CSV export
$csvFilePath = $selectedpath+"\index_files.csv"

#Folder to be parsed
$parsingPath = $selectedpath+"\*"

#ask if parse recursively
$a = new-object -comobject wscript.shell 
$intAnswer = $a.popup("Include Subfolders?", ` 
0,"Miau :3",4) 
If ($intAnswer -eq 6) { 
    $files = Get-ChildItem -path $parsingPath -File -Recurse
} else { 
    $files = Get-ChildItem -path $parsingPath -File
} 

$i = 0

#count amount of files for iterating through them
$amount = $files.count

#iterate through files getting all the data
$hashes = foreach ($file in $Files){
    Write-Output (New-Object -TypeName PSCustomObject -Property @{
        		FilePath 		= $file.FullName		# full path of the file
		FileDirectory 	= $file.DirectoryName	# only the path of the file
		FileName 		= $file.Name		# only filename with extension
		FileCleanName	= $file.BaseName		# only filename without extension
              
		})
		
		$i++
        #Write to console how many files are left to be parsed
        Write-Host "Datei / von:     " $i " / " $amount
		
}

#generate csv file from parsed data
$hashes | Select-Object "FileCleanName", "FileName", "FileDirectory", "FilePath" | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $csvFilePath
