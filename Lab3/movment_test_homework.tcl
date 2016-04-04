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
 set val(rp)           AODV             ;# routing protocol
 set val(x)            500
 set val(y)            500

set ns [new Simulator]
ns-random 7

# Then setup trace support by opening file movement_out.tr and call the procedure trace-all {} as follows:
set f [open movement_out.tr w]
$ns trace-all $f
set namtrace [open movement_out.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)
set f0 [open proj_out0.tr w]
set f1 [open proj_out1.tr w]

# Create Topology
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create GOD(General Operations Directior Object)
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
        exec nam -r 5m movement_out.nam &
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

                   
#$ns at 0.0 "$n(0) color red"                        
set n(0) [$ns node]
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
$n(0) set X_ 100.0
$n(0) set Y_ 100.0
$n(0) set Z_ 0.0



$n(1) set X_ 150.0
$n(1) set Y_ 100.0
$n(1) set Z_ 0.0

# set motions
$ns at 0.0 "$n(0) setdest 100.0 100.0 2000.0"
$ns at 0.0 "$n(1) setdest 150.0 100.0 2000.0"

# node1 movement
$ns at 2.0 "$n(1) setdest 350.0 100.0 200.0"
$ns at 4.0 "$n(1) setdest 150.0 100.0 200.0"

# movement vertically
$ns at 6.0 "$n(1) setdest 150.0 300.0 200.0"
$ns at 8.0 "$n(1) setdest 150.0 100.0 200.0"

$ns at 10.0 "$n(1) setdest 350.0 100.0 200.0"




#setup TCP agents:
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
#Attach the agents to NODES
$ns attach-agent $n(0) $tcp
$ns attach-agent $n(1) $sink
#Set out connection between agents
$ns connect $tcp $sink

#Create and attach an application
set ftp [new Application/FTP]
$ftp attach-agent $tcp
#Start the application traffic 
$ns at 1.0 "$ftp start"

$ns at 13.0 "finish"

puts "Start of simulation.."
$ns run

