# CPU meter, minimal CPU usage meter widget for Übersicht, styled as an old school V.U. meter
# Takes into account cores and tries to make a very low resource intensive call to ps instead
# of top as I've seen in other similar widgets.
# To do: the number of cores and the colors used could be a variable.
#
# Reven Sanchez -- May 2020
command: """
# Rev 1 May 2020
# Changed script to avoid long call to top and take cores into account

# numProc=`nproc` # but doesn't work. Do we need an eval?
numProc=8 # will have to be hardcoded
myCPU=`ps -A -o %cpu | awk '{s+=$1} END {print s}' | sed s/'\\,'/'.'/ | awk '{print int($1+0.5)}'`
myCPU=`echo "$myCPU / $numProc" | bc | awk '{print int($1+0.5)}'`
typeset -i a=5
while [ $a -lt $myCPU ]
do
	echo "<span>|</span>"
	a=`expr $a + 5`
done
echo "<span class='red'>|</span>"
while [ $a -lt 100 ]
do
	echo "<span class='dark'>|</span>"
	a=`expr $a + 5`
done
unset myCPU
unset a
unset numProc
"""

# the refresh frequency in milliseconds
refreshFrequency: 1000

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
render: (output) -> """
  <p>
    CPU #{output}
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
  top: 95%
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
