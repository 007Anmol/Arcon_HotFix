@echo off
echo Switching to E drive and running AssemblyHasher1.exe...

:: Switch to E drive
E:

:: Navigate to the correct folder
cd "E:\HashBuilder"

:: Run the executable with arguments
AssemblyHasher1.exe "E:\DUMMY_Diff.24\new" "E:\DUMMY_Diff.24\old" "E:\DUMMY_Diff.24\final" "E:\DUMMY_Diff.24\rollback"

:: Optional: Pause to see output
pause
