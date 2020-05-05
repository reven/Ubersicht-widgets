# Mem meter, minimal memory usage meter widget for Übersicht, styled as an old school V.U. meter
# Tries to make a very low resource intensive call to vm_stat instead of top as I've seen in other similar widgets.
#
# Reven Sanchez -- May 2020
command: """
# Rev 1-May-20
# Took out hard coded value and used more reliable and quicker commands

totalRAM=`sysctl -n hw.memsize` # size in bytes
ticks=20
tickchar='|'
onetick=`expr 100 / $ticks`
# We'll consider inactive and free as available memmory. Then convert to bytes and substract
# from total to get used. This approximation is the quickest.
# just one call to vm_stat. There is probably a better way to cache this.
response=$(vm_stat)
freeRAM=$(echo \"$response\" | awk '/Pages free/ {print $3}' | sed s/'\\.'/''/) # size in pages
inacRAM=$(echo \"$response\" | awk '/Pages inactive/ {print $3}' | sed s/'\\.'/''/) # size in pages
usedRAM=`expr $totalRAM - $freeRAM \\* 4096  - $inacRAM \\* 4096`
myPercentRAM=`expr $usedRAM \\* 100 / $totalRAM`

declare -i a=$onetick
while [ $a -lt $myPercentRAM ]
do
    echo \"<span>$tickchar</span>\"
    a=`expr $a + $onetick`
done

#border color is initially set as 31
echo \"<span class='red'>$tickchar</span>\"

while [ $a -lt 100 ]
do
#unused tile color is initially set as 30
    echo \"<span class='dark'>$tickchar</span>\"
    a=`expr $a + $onetick`
done

echo \"\n\"

unset response
unset inacRAM
unset freeRAM
unset usedRAM
unset totalRAM
unset myPercentRAM
unset a
unset ticks
unset onetick
unset tickchar
"""

# the refresh frequency in milliseconds
refreshFrequency: 5000

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
render: (output) -> """
  <p>
    MEM #{output}
  </p>
"""

# the CSS style for this widget, written using Stylus
# (http://learnboost.github.io/stylus/)
style: """
  background: rgba(#000, 0.95) transparent
  border: none
  box-sizing: border-box
  color: #115bfc
  font-family: Monaco
  font-weight: 0
  font-size: 0.85em
  left: 3.5%
  top: 93%
  width: 340px
  text-align: justify

  span
    display: inline
    margin-right: -0.66em

  .red
    color: #f00

  .dark
    color: #333
"""
