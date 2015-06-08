#!/bin/sh

CARD=/dev/snd/hwC0D0
HEADPHONE_PIN=0xf
SPEAKER_PIN=0xb

HEADPHONE_ENABLE=0xc0
SPEAKER_ENABLE=0x40
DISABLE=0x0

OLD_VALUE=meh

while true; do
	PIN_VALUE=`hda-verb $CARD $HEADPHONE_PIN get_pin_sen 0 2>&1 | grep value | sed 's/value = 0x//'`
	if test $PIN_VALUE != $OLD_VALUE; then
		if test $PIN_VALUE = 0; then
			echo "Headphones unplugged"
			hda-verb $CARD $HEADPHONE_PIN set_pin_wid $DISABLE
			hda-verb $CARD $SPEAKER_PIN set_pin_wid $SPEAKER_ENABLE
		else
			echo "Headphones plugged"
			hda-verb $CARD $SPEAKER_PIN set_pin_wid $DISABLE
			hda-verb $CARD $HEADPHONE_PIN set_pin_wid $HEADPHONE_ENABLE
		fi
		OLD_VALUE=$PIN_VALUE
	fi
	sleep 1
done
