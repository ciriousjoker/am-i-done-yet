# Am I Done Yet

This is a basic Todo app where you can swipe the todos to change the progress.
Completed todos are sent to the bottom and the list is ordered by progress (descending)

## Getting Started

I know, that the code style isn't that good, but with only 5000 characters available, every modularized components costs 300 bytes just for the repeated import statements.

If I had this code base and an infinite amount of bytes available, I would do these things:

    - write (or restore, rather) an intermediate class for App <-> Firestore communication.
    - Replace all var keyword and add redundant typings where I removed them
    - Extract the ListView and everything below it into a new file
    - Name the variables better
	- Add some comments where needed
    - Use spaces instead of tabs (this conversion saved around 700 bytes alone)
    - Restore all the new keywords (though I can probably get used to that)
    - Add commata to the end of statements (improves formatting, but means that more indentations are needed. Currently, indentation is minimized almost to the max.)
