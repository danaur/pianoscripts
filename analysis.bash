echo "Number of Keypresses"
cat pianodata/*_raw | grep "Note on" | wc -l

echo "Number of times sustain pedal pressed"
cat pianodata/*_raw | grep "Control change" | grep "value 127" | wc -l
