Ultraschall State Inspector v2.3.1 - 1.05.2021


#Introduction

    Developing features in Reaper is fun. 
    But debugging in Reaper is not. Mostly due the fact, that you can't
    conveniently see, what is happening in the background.
    Are states working as expected? Are Reaper's features do what they're told?
    For such situations, we made the Ultraschall-Inspector.

    
#What is it?

    The Ultraschall Inspector helps you monitoring states in Reaper, like
    toggle-command-states, external states, external project states, 
    key-value-stores from .ini-files, as well as a lot of Reaper's own states, 
    like projectlength, transport and mouse-states.
    That way you can see, whether states behave as expected due to your script.

    In addition, you can change states(where applicable) within the Inspector,
    can add actions/scripts that can be run from within the Inspector as well.
    You also have helper stuff like color-value-conversion or for conversion of 
    the char-values, as returned by the function gfx.getchar() to the accompanying
    character/keyboard-key.

    
#How to install it?

    It's easy. Extract the contents of the folder someplace, preferably the Scripts-folder
    of Reaper's Ressources-folder.
    Next, you add the script "ultraschall_StateInspector.lua":
        1) Menu: Actions -> Show Actions List
        2) Button Load
        3) select "ultraschall_StateInspector.lua"
        4) start the script from within Reaper
    
    
#How to use it?

    The Inspector is useable with mouse. At the top, you have the menu with several options
    you can choose(more on that later on).
    You can add a state by, e.g. Menu: Add-States->Add Toggle Command. Type in the Action-CommandID
    of the command, whose toggle state you want to monitor, hit OK and the state appears.

    In the middle of the Inspector-Window, you have the list of the states you've added.
    First, the entrynumber within the list, then the state-name(colored by type) and then
    it's value.
    You can browse through the list using the arrow-keys, as well as PgUp/PgDn/Home and End.
    You can also make the window smaller or bigger, the list will fit accordingly.
    If a state is too long to fit the screen, then you can use left and right-arrow-keys to
    move the list into these directions.

    If you have several states and want to highlight some of them for better visibility, just
    left click on them.

    If you want to change a state, rightclick on them, a dialog, in which you can enter the new 
    value will appear.
    Exception: Toggle-States and Actions open a context-menu, in which you can choose to toggle
    the toggle-state, as well as running the action/script.

    If you have a list, you want to save, you can do it in two ways.
        1) Quick-Load-Slots: In the Inspector, you can have 9 saveslots. Hit S and type in 
                             the slotnumber and a name for the list. L displays a list of
                             all existing slots.
                             Now you can easily switch between these slots by using the keys
                             1-9
        2) SaveFiles : You can save and load the list into a file as well, using ctrl+s/cmd+l. 
                       To load a list from a file, hit ctrl+l/cmd+l.

    All these options are also available through the menu at the top of the window, so feel free
    to browse through it.

    
#The Menu

    File - clear/load/save-collection or close the Inspector
    Add States - here you can find a lot of states, you can add, eg:
                        - Actions/Scripts
                        - Toggle Command States
                        - external states(persistant and non persistant ones)
                        - ultraschall-external states (only relevant, if you've installed ultraschall.fm)
                        - any external state, key values-stores from ini-files, like reaper.ini
                        - project external states - states, that are part of the project itself
                        - Reaper States - a collection of states from Reaper itself, ordered by
                                          category
    Edit List - here you change/modify the list
                the entry "Toggle Keyboard Control" turns off keyboard-shortcuts within the Inspector
                which might be helpful, if you chose e.g.
                    Add States -> Add Reaper State -> Miscellaneous -> Get Current Character
    
    View - switches between several views. Currently only the state-list as well as the project-notes, 
           if they're existing.
    
    Developer Tools - some helpful tools, that might help your everyday coding work. I'm open for more
                      ideas, that you'd love to have in that menu
    
    Help - what it says ;)
    
    
#About Ultraschall

    The Ultraschall-project is focused on modifying Reaper into a production-platform, with a focus on
    podcasting as well as producing shows for radios.
    
    In January 2018, the Ultraschall version 3.1 has been released.
    More info at ultraschall.fm or at https://twitter.com/ultraschall_fm
    
    For questions regarding the Ultraschall-Inspector, contact Meo directly:
    mespotine@mespotine.de and https://twitter.com/MespotineShows
    
    
#License

    ################################################################################
    # 
    # Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
    # 
    # Permission is hereby granted, free of charge, to any person obtaining a copy
    # of this software and associated documentation files (the "Software"), to deal
    # in the Software without restriction, including without limitation the rights
    # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    # copies of the Software, and to permit persons to whom the Software is
    # furnished to do so, subject to the following conditions:
    # 
    # The above copyright notice and this permission notice shall be included in
    # all copies or substantial portions of the Software.
    # 
    # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    # THE SOFTWARE.
    # 
    ################################################################################