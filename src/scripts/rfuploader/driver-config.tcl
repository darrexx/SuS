# Set COM port where RF access point is mounted
set com "/dev/ttyACM0"

# udev rule to assign a fixed name under /dev to the USB dongle
# TI RF USB Dongle
#KERNEL=="ttyACM*", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="16a6", SYMLINK += "ti-rfdongle"
