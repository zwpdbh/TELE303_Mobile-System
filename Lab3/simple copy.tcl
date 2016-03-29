# ======================================================================
# Define options
# ======================================================================
 set val(chan)         Channel/WirelessChannel  ;# channel type
 set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
 set val(ant)          Antenna/OmniAntenna      ;# Antenna type
 set val(ll)           LL                       ;# Link layer type
 set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
 set val(ifqlen)       50                       ;# max packet in ifq
 set val(netif)        Phy/WirelessPhy          ;# network interface type
 set val(mac)          Mac/802_11               ;# MAC type
 set val(nn)           2                        ;# number of mobilenodes
 set val(rp)	       AODV 			;# routing protocol
 set val(x)            600
 set val(y)            600

set ns [new Simulator]
ns-random 7

set f [open 1_out.tr w]
$ns trace-all $f
set namtrace [open 1_out.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)
set f0 [open proj_out0.tr w]
set f1 [open proj_out1.tr w]

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

set chan_1 [new $val(chan)]

# CONFIGURE AND CREATE NODES

$ns node-config  -adhocRouting $val(rp) \
 		 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 -topoInstance $topo \
                 -agentTrace OFF \
                 -routerTrace ON \
                 -macTrace ON \
                 -movementTrace OFF \
                 -channel $chan_1   
                
proc finish {} {
	global ns f f0 f1 namtrace
	$ns flush-trace
        close $namtrace   
	close $f0
        close $f1
        exec nam -r 5m 1_out.nam &
	exit 0
}

# define color index
$ns color 0 blue
$ns color 1 red
$ns color 2 chocolate
$ns color 3 red
$ns color 4 brown
$ns color 5 tan
$ns color 6 gold
$ns color 7 black
                        
set n(0) [$ns node]
#$ns at 0.0 "$n(0) color red"
$n(0) color "0"
$n(0) shape "circle"
set n(1) [$ns node]
$n(1) color "blue"
$n(1) shape "circle"

# set node size
for {set i 0} {$i < $val(nn)} {incr i} {
	$ns initial_node_pos $n($i) 30
}

# set initial positions
$n(0) set X_ 0.0
$n(0) set Y_ 0.0
$n(0) set Z_ 0.0

$n(1) set X_ 0.0
$n(1) set Y_ 0.0
$n(1) set Z_ 0.0

# set motions
$ns at 0.0 "$n(0) setdest 200.0 200.0 3000.0"
$ns at 0.0 "$n(1) setdest 300.0 300.0 3000.0"
$ns at 1.0 "$n(0) setdest 200.0 200.0 500.0"
$ns at 1.0 "$n(1) setdest 400.0 400.0 500.0"
$ns at 1.5 "$n(0) setdest 200.0 200.0 500.0"
$ns at 1.5 "$n(1) setdest 300.0 300.0 500.0"


# CONFIGURE AND SET UP A FLOW

set sink0 [new Agent/LossMonitor]
set sink1 [new Agent/LossMonitor]
$ns attach-agent $n(0) $sink0
$ns attach-agent $n(1) $sink1


proc attach-CBR-traffic { node sink size interval } {
   #Get an instance of the simulator
   set ns [Simulator instance]
   #Create a CBR  agent and attach it to the node
   set cbr [new Agent/CBR]
   $ns attach-agent $node $cbr
   $cbr set packetSize_ $size
   $cbr set interval_ $interval

   #Attach CBR source to sink;
   $ns connect $cbr $sink
   return $cbr
  }

set cbr0 [attach-CBR-traffic $n(0) $sink1 1000 .015]
set cbr1 [attach-CBR-traffic $n(1) $sink0 1000 .015]
 
$ns at 0.3 "$cbr0 start"
$ns at 0.3 "$cbr1 start"
$ns at 10.0 "finish"

puts "Start of simulation.."
$ns run

