function fish_command_not_found
    print_message
    __fish_default_command_not_found_handler $argv
end

function print_message
    set -l messages "Boooo!" "Don't you know anything?"
    set -a messages "RTFM!"
    set -a messages "Haha, n00b!"
    set -a messages "Wow! That was impressively wrong!"
    set -a messages Pathetic
    set -a messages "The worst one today!"
    set -a messages "n00b alert!"
    set -a messages "Your application for reduced salary has been sent!"
    set -a messages lol
    set -a messages "u suk"
    set -a messages "lol... plz"
    set -a messages "plz uninstall"
    set -a messages "And the Darwin Award goes to.... $USER"
    set -a messages ERROR_INCOMPETENT_USER
    set -a messages "Incompetence is also a form of competence"
    set -a messages "Bad."
    set -a messages "Fake it till you make it!"
    set -a messages "What is this...? Amateur hour!?"
    set -a messages "Come on! You can do it!"
    set -a messages "Nice try."
    set -a messages "What if... you type an actual command the next time!"
    set -a messages "What if I told you... it is possible to type valid commands."
    set -a messages "Y u no speak computer???"
    set -a messages "This is not Windows"
    set -a messages "Perhaps you should leave the command line alone..."
    set -a messages "Please step away from the keyboard!"
    set -a messages "error code: 1D10T"
    set -a messages "ACHTUNG! ALLES TURISTEN UND NONTEKNISCHEN LOOKENPEEPERS! DAS KOMPUTERMASCHINE IST NICHT FÜR DER GEFINGERPOKEN UND MITTENGRABEN! ODERWISE IST EASY TO SCHNAPPEN DER SPRINGENWERK, BLOWENFUSEN UND POPPENCORKEN MIT SPITZENSPARKEN. IST NICHT FÜR GEWERKEN BEI DUMMKOPFEN. DER RUBBERNECKEN SIGHTSEEREN KEEPEN DAS COTTONPICKEN HÄNDER IN DAS POCKETS MUSS. ZO RELAXEN UND WATSCHEN DER BLINKENLICHTEN."
    set -a messages "Pro tip: type a valid command!"
    set -a messages "Go outside."
    set -a messages "This is not a search engine."
    set -a messages "(╯°□°）╯︵ ┻━┻"
    set -a messages "¯\\_(ツ)_/¯"
    set -a messages "So, I'm just going to go ahead and run rm -rf / for you."
    set -a messages "Why are you so stupid?!"
    set -a messages "Perhaps computers are not for you..."
    set -a messages "Why are you doing this to me?!"
    set -a messages "Don't you have anything better to do?!"
    set -a messages "I am _seriously_ considering 'rm -rf /'-ing myself..."
    set -a messages "This is why you get to see your children only once a month."
    set -a messages "This is why nobody likes you."
    set -a messages "Are you even trying?!"
    set -a messages "Try using your brain the next time!"
    set -a messages "My keyboard is not a touch screen!"
    set -a messages "Commands, random gibberish, who cares!"
    set -a messages "Typing incorrect commands, eh?"
    set -a messages "Are you always this stupid or are you making a special effort today?!"
    set -a messages "Dropped on your head as a baby, eh?"
    set -a messages "Brains aren't everything. In your case they're nothing."
    set -a messages "I don't know what makes you so stupid, but it really works."
    set -a messages "You are not as bad as people say, you are much, much worse."
    set -a messages "Two wrongs don't make a right, take your parents as an example."
    set -a messages "You must have been born on a highway because that's where most accidents happen."
    set -a messages "If what you don't know can't hurt you, you're invulnerable."
    set -a messages "If ignorance is bliss, you must be the happiest person on earth."
    set -a messages "You're proof that god has a sense of humor."
    set -a messages "Keep trying, someday you'll do something intelligent!"
    set -a messages "If shit was music, you'd be an orchestra."
    set -a messages "How many times do I have to flush before you go away?"

    set RANDOM (random 1 (count $messages))
    set message $messages[$RANDOM]
    printf "\\n %s\\n\\n" (tput bold)(tput setaf 1)$message(tput sgr0) >&2
end
