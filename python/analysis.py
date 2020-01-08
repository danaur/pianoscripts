import matplotlib.pyplot as plt; plt.rcdefaults()
import numpy as np
import matplotlib.pyplot as plt
import fileinput

# Note 32 is A0
note_literals = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

literal_mapping = {}
tmp_inx = 9
pitch = 0
for nonliteral in range(21, 109):
    tmp_inx %= len(note_literals)
    if tmp_inx == 0:
        pitch += 1
    literal_mapping[nonliteral] = str(note_literals[tmp_inx]) + "" + str(pitch)
    tmp_inx += 1
print literal_mapping

literal_mapping_no_pitch = {}
for nonliteral in range(21, 109):
    tmp_inx %= len(note_literals)
    if tmp_inx == 0:
        pitch += 1
    literal_mapping_no_pitch[nonliteral] = str(note_literals[tmp_inx])
    tmp_inx += 1
print literal_mapping_no_pitch


notes = {}
#for a in range(32, 109):
    #notes[a] = 0
for line in fileinput.input():
    note = int(line.rstrip())
    val = notes.get(note, 0) + 1
    notes[note] = val
print(notes)

for note in notes.keys():
    if notes[note] < 0:
        del notes[note]

#objects = notes
#objects = [literal_mapping[note] for note in notes]
#performance = [notes[note] for note in notes]

objects = note_literals

perf = {}
for note in notes:
    literal = literal_mapping_no_pitch[note]
    perf[literal] = perf.get(literal, 0) + notes[note]

performance = [perf[literal] for literal in note_literals]

y_pos = np.arange(len(objects))

plt.bar(y_pos, performance, align='center', alpha=0.5)
plt.xticks(y_pos, objects)
plt.ylabel('Times note played')
plt.xlabel('Note played')
plt.title('Frequency of Notes')

plt.show()
