#!/usr/bin/tclsh

#To define a variable
set WelcomeString "TCL Story"
#----------------------------------------------------

#To print message in stdout
puts "start $WelcomeString process ..."
#----------------------------------------------------

set main_dir [pwd]

set TargetFile dummy

#To open or create a file in write mode
set DummyFile [ open ${TargetFile}.txt w+ ]
#----------------------------------------------------

#To define global variable
set ::GateStartTime [clock seconds]
#----------------------------------------------------

#To print in a file
puts  -nonewline $DummyFile "Hello, "
puts $DummyFile "this is dummy File to read and write"
puts $DummyFile "last access date is: [clock format $GateStartTime -format %d.%m.%Y__%H:%M:%S]"
#----------------------------------------------------

#To close a file
close $DummyFile
#----------------------------------------------------

#To create directory
file mkdir Deleteme
#----------------------------------------------------

#To Copy All txt files
file copy -force -- {*}[glob *.txt] Deleteme/

#or you can use the following
#set TXT_Files [glob *.txt]
#foreach txt_fname $TXT_Files {
#    file copy -- $txt_fname Deleteme/
#}
#----------------------------------------------------


#To define array
set ::instance_input(dummy) dummy.txt
set ::instance_output(dummy) {print start time}
set ::instance_action(dummy) "puts {going to read from dummy.txt}"
#Another form
#array set instance_names {
#1 Bitstream
#2 FSBL
#3 PMU
#}
#----------------------------------------------------


proc main_Action { FileToRead } {

    #To copy array
    #array set proc_out_arr [array get ::instance_output]
	#----------------------------------------------------
	
	#To get a corresponding value in the array
    foreach {InstName InstInput} [array get ::instance_input $FileToRead] {}
	#----------------------------------------------------
	
	#To open a file
	set FileID [ open $InstInput r+ ]
	#----------------------------------------------------

    #To read line by line
	#gets $FileID First_File_Line
    #puts $First_File_Line
	#gets $FileID Second_File_Line
    #puts $Second_File_Line
	#----------------------------------------------------
	
	#To read all content not read so far
	set All_File_Content [read $FileID]
	#----------------------------------------------------
	
	#To split lines individually
	set All_File_Line [ split $All_File_Content "\n" ]
	#----------------------------------------------------
	
	#To get some information about these lines
	# Note: "join" is used to avoid added braces in the output
	#puts "you have provided: \n [join $All_File_Line]"
    #puts "which has [llength $All_File_Line] lines"
    #puts "second line is: [lindex $All_File_Line 1]"
    #puts "before last line is: [lindex $All_File_Line end-1]"
	#----------------------------------------------------
    
	#To run external system command
	set App_RetVal [exec awk {/date/{a=$NF} END{print a}} $InstInput]
	#puts "Date is $App_RetVal"
	#----------------------------------------------------
	
	#To parse each line
	foreach x $All_File_Line {
	    if {$x != ""} {
		    #puts "found line:  $x"
			
			#To get first character of the line
			set firstChar [string index $x 0]
			#----------------------------------------------------
			
			#To search for a line that contain certain pattern
			set LineFound [string match -nocase {*date*} "$x"]
			if { $LineFound } {
			    set line_split [split $x " "]
				set ReplacingValue [clock format $::GateStartTime -format %d.%m.%Y]
				
				#To Replace a string with another
				#format is [string replace string first_ch_pos last_ch_pos newString]
				lset line_split end [string replace $App_RetVal 0 end $ReplacingValue]
				#----------------------------------------------------
				puts "Make sure that last line is: \n $line_split"
			}
			#----------------------------------------------------
		}
	}
	puts $FileID $line_split
	
	#To add element to end of list
	lappend All_File_Line "DONE ! "
	#----------------------------------------------------
	
	close $FileID


}

#To call a procedure
main_Action $TargetFile
#----------------------------------------------------

puts "Done successfully"

