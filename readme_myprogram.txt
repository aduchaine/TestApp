7/6/16


******_v.1.00
Initial release date: **/**/**

	Directions to use:
	
	These instructions apply to machines on a recent Windows platform.
	

	Contents: (Search the heading to quickly navigate - ctrl + F)
	
		I) Installation
			A) Default
		
		II) Initial_Startup
		
		III) Using_the_Program
			A) Default_Settings
				1) Keys_or_equivalents
					a) Virtual_keyboard
				2) Mouse_clicks_or_equivalents
			
			
	Installation:

		The only installation option currently available is "default". The program will not work if directories are changed.
		
		Default:
	
			Download the zip file.
			
			If the download path (directory) has ANY spaces in it, move the zip file to a location which doesn't have spaces. Underscores are okay.
			
			Unpack/unzip the zip file. Do not create a folder for the unpacked files. A directory with files is created when unzipped. Unzip "here" or "at this location" are common prompts.		
			
			Navigate into the folder, "..\******\", created by unzipping the previous file.
			
			Click/start the item which says "Click Me".
			
			This will unpack all files, including the main program, create a base directory for the program and place all files into these directories. This includes the original download and anything else which was unzipped with it.		
			
			You can find everything in the base directory:	"C:\*****"
			
			The program is ready to use.	
	
	
	Initial_Startup:
	
		In "C:\****" you will find a folder with the program and all necessary files along with a shortcut you can place anywhere.
		
		You can use the shortcut to start the program or click it directly in "C:\*****\*****".
		
		When the program starts for the first time, it will begin by creating "C:\*****\Documents" and "C:\*****\Logs" folders.
		
		The final result of the program, which occurs when a user completes the content, will go into the "C:\*****\Documents\" folder.
		
		User and error logs will go into the "C:\*****\Logs\" folder.

		
	Using_the_Program:
	
		The program will start like any other program.
		
		To terminate the session before completion, click the "Quit" button or close/"X" the window. The program's internal memory is destroy when terminated regardless of how this is done.
		
		The only way to receive output is to complete all the steps.
	
	
		Default_Settings:
			
			The program is set up to identify user input and do something with it. Certain user input will not output text directly to the user. The standard function keys like, ENTER/RETURN, TAB, ESC, etc. behave in a specific manner. It's intentional to try to adhere to the most common conventions of use for this type of input.
			
			Accepting a selection will save the input to the program's internal memory. If the program is exited before finishing, all memory is destroyed.
			
			In most circumstances, navigating back with unfinished input fields on the current page, will save any input before performing the navigation command. This is to save time on re-entering the input if reviewing previous pages is desired.
			
			Navigating forward is only possible if the input fields contain valid input.
			
			The virtual keyboard will be the primary text input device if the option is accepted at the beginning of the program.
			
			Keys_or_equivalents:
			
				If a description states "standard", it is assumed to perform the most conventional operation.
				
				Function keys not listed below will have no effect.
				
				"ENTER/RETURN" - accepts a selection; this also hides the virtual keyboard if used
				
				"TAB" - inter-page navigation; pressing TAB will go to the next input field if possible; single question pages require an explicit selection and TAB is not enabled
				
				Arrows:				
					"LEFT/RIGHT" - results vary
				
						Page: accepts any user input; navigation to the next or previous page; if the page has insufficient user input, navigation forward will not be possible
					
						Text fields: standard cursor navigation to the next/previous cursor position
						
					"UP/DOWN" - only menus; moves the selector; pressing ENTER accepts the selection					
					
				Virtual_keyboard:				
					
					Some of the commands are described above. The few below are specific to the virtual keyboard. The default layout is the lowercase alphabet, some standard functions and a few special characters. Starting the keyboard or switching from the numeric view will revert to the default layout regardless of the previous state.
					
					"&123/ABC" - toggles between numbers-special characters and default layout
					
					"ESC" - hides the keyboard; this will also accept any user input similar to pressing ENTER and only while using the virtual keyboard
					
					"BACKSPACE/SHIFT" - standard
					
					"FCT2/FCT3" - undefined
					
			Mouse_clicks_or_equivalents:
			
				Right Click: does nothing
				
				Mouse Wheel: scrolls menus; does not move the selector with it, you must click your selection
				
				Left Click: accepts a selection
					
		
	
	
EDIT THIS:		
	Feedback - 
		The client program (which accompanies this file) has hundreds of debugging messages in it which I have *mostly* commented out, meaning, you shouldn't see them. Due to the number of messages, there is a good chance I didn't remove them all.
		
		I purposely left some important messages in. You would generally see these messages if there is a network, database or server error. These messages should be apparent as they will say ERROR in the message or give some technical jargon.
		
		If any suspect messages appear when using the program, please let me know. In most cases, if I am on top of administering the server, I will find these same or similar messages in the log files, but not always.
		
		Since I am new to all of this, I couldn't have possibly covered all possibilities and your feeback will be welcome.
		
		Notes on feedback:
			- I highly value "bug" reports. If something happens that is obviously wrong, this is likely a bug.		
			- content irregularities which can cause user confusion are extremely helpful - see the statement before these bullets
			- content output (the stuff that happens after you give the program input) may have spelling/grammatical/nonsensical errors which can be fixed easily
				- not as important as the other two but easy to fix in most cases
			- some things may just not work right
				- one of the main purposes for this is to get outside, "real world", usage from the program - it's one of the better ways to eliminate most of the things I mentioned above
	
		To give feedback:
			- aside from using the telephone, you can currently give me feedback from inside the program by simply going into chat and typing your feedback - type my name and/or "feedback" somewhere in your message
			- I can easily search thousands of files very quickly using a program and various search parameters so, I will find any message if I know what to look for
			
	Upcoming - 
		I'll be adding a simple mail system (like email) fairly soon. This is the next larger project for this program. This will make feedback within the program (and while in mind) easier than starting up a separate, resource hogging mail app like gmail. Ofc, it'll be mail so, feedback isn't the only purpose for it ;)
		
		After that, I'll figure out how to assign a graphical icon to the program (which should be easy) and maybe a different name than "client.v.1.238xxxx".
		
		If there aren't any major issues with the program up through the items above, I'll begin to learn about adding a GUI so a mouse can be used to select the various options.
	
		In between all of this and possibly more important, I am willing to take suggestions for making a program for some specific or not-so-specific real-world use. Something that could be sold or something you could use. I'm open.
		
	
Thanks