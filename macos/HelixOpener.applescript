on open theFiles
	set args to ""
	repeat with f in theFiles
		set args to args & " " & quoted form of (POSIX path of f)
	end repeat
	set firstPath to POSIX path of (item 1 of theFiles)
	set dir to do shell script "dirname " & quoted form of firstPath
	launchHelix(args, dir)
end open

on run
	launchHelix("", POSIX path of (path to home folder))
end run

on launchHelix(args, dir)
	tell application "Ghostty"
		activate
		set cfg to new surface configuration
		set command of cfg to "/opt/homebrew/bin/hx" & args
		set initial working directory of cfg to dir
		new window with configuration cfg
	end tell
end launchHelix
