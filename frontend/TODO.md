
[ ] have a useless error message easter egg with the stupid "pacman with teeth" emoji
[ ] turn this project into a webapp. if I want to be able to show different windows minimized/maximized, etc based on the link, I need to do it
[ ] make the project use fonts and colors only from the "Palette.elm" module
[x] make the 'make.sh' script copy all the album art in the './built' dir automatically
[x] make sure to add a good wallpaper, not the windows xp one
[x] check out css font rendering options and see if you can make the font look like it's bitmap
[ ] the current "make.sh", "run.sh" and the backend all use relative paths 
    currently...
    This is obviously not best practice. 
    Should you call "run.sh" in the wrong directory, be ready for unexpected
    results. I'll have to change these to use a well defined, pre-determined 
    directory.
[ ] make it so you can't drag a window's titlebar below the tasklist
[x] check if i can access the browser zoom amount. it seems to screw up 
    dragging windows
[ ] optimize the album covers that the file explorer and other programs display
[x] use the right icons for all programs & menu items and everything and 
    configure the make.sh script to copy all the right icons in the right place
[x] instead of using "top" and "left" to move windows, use "translate". It seems
    it doesn't stop moving windows when the mouse goes outside the browser window.
[ ] when just selected, the taskbar items have a dotted border on their inside.
    the ones I wrote don't... Fix it.
[ ] display the proper time
[ ] while dragging a window, if the user takes the mouse outside the screen, 
    the dragging ceases. in webamp this doesn't happen, so there surely is a
    way to fix this
[ ] get a bunch of gifs from skynet.net (when you press the "im feeling lucky"
    button) and use them on the site
[ ] check whether it would be a good idea to gzip the main elm.js file before sending
[ ] I can probably share the code for buttons and put it in the Windoze.elm module
[ ] make reordering of navbar items possible by drag and drop
[ ] make resizing windows work
[ ] when clicking on the desktop, unFocus all windows
[ ] when resizing the desktop viewport, re-position windows to always be inside
[ ] instead of tracking mouse movement at all times, use "onMouseDown" and 
    "onMouseUp" to handle clicking & dragging titlebars
