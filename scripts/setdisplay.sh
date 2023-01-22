#!/bin/bash


# 0x11 = HDMI 1
# 0x0F = Displayport-1
# Manjaro
# Display 1 = Right
# 	HDMI 1 = Manjaro
# 	Displayport 1 = Work
# Display 2 = Left
# 	HDMI 1 = Work
# 	Displayport 1 = Manjaro
# Display 3 = Middle
# 	HDMI 1 = Work
# 	Displayport 1 = Manjaro

# Get current input of middle display
current=$(ddcutil -d 3 getvcp 60 | sed -n "s/.*(sl=\(.*\))/\1/p")

# Get the other input
case $current in

    # HDMI (Work -> Manjaro)
    0x11)
        output_right=0x11
        output_left=0x0f
        output_middle=0x0f
        ;;

    # Display port (Manjaro -> Work)
    0x0f)
        output_right=0x0f
        output_left=0x11
        output_middle=0x11
        ;;

    *)
        echo "Unknown input"
        exit 1
        ;;
esac

# Set new input
ddcutil -d 1 setvcp 60 $output_right
sleep 1
ddcutil -d 2 setvcp 60 $output_left
sleep 1
ddcutil -d 3 setvcp 60 $output_middle

