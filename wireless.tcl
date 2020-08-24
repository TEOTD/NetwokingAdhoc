#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 5                        ;# max packet in ifq
set val(nn)     10                         ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      1986                      ;# X dimension of topography
set val(y)      905                      ;# Y dimension of topography
set val(stop)   55.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#colouring the simulator
$ns color 1 blue 
$ns color 2 yellow 
$ns color 3 red

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 10 nodes
set n0 [$ns node]
$n0 set X_ 804
$n0 set Y_ 692
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 602
$n1 set Y_ 548
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 1001
$n2 set Y_ 548
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 601
$n3 set Y_ 301
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 1002
$n4 set Y_ 302
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set n5 [$ns node]
$n5 set X_ 299
$n5 set Y_ 405
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
set n6 [$ns node]
$n6 set X_ 1302
$n6 set Y_ 405
$n6 set Z_ 0.0
$ns initial_node_pos $n6 20
set n7 [$ns node]
$n7 set X_ 499
$n7 set Y_ 805
$n7 set Z_ 0.0
$ns initial_node_pos $n7 20
set n8 [$ns node]
$n8 set X_ 1196
$n8 set Y_ 802
$n8 set Z_ 0.0
$ns initial_node_pos $n8 20
set n9 [$ns node]
$n9 set X_ 796
$n9 set Y_ 102
$n9 set Z_ 0.0
$ns initial_node_pos $n9 20

#===================================
#        Generate movement          
#===================================
$ns at 0 " $n5 setdest 1298 401 200 " 
$ns at 0 " $n6 setdest 298 408 200 " 
$ns at 3 " $n7 setdest 800 426 200 " 
$ns at 5 " $n7 setdest 1192 800 200 " 
$ns at 3 " $n8 setdest 800 426 200 " 
$ns at 5 " $n8 setdest 507 805 200 " 
$ns at 8 " $n9 setdest 794 433 200 " 

#===================================
#        Agents Definition        
#===================================

$ns duplex-link $n0 $n1 100Mb 1ms DropTail
$ns duplex-link $n0 $n2 100Mb 1ms DropTail
$ns duplex-link $n1 $n3 100Mb 1ms DropTail
$ns duplex-link $n2 $n4 100Mb 1ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n3 $tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

set tcp3 [new Agent/TCP]
$ns attach-agent $n4 $tcp3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3

set sink0 [new Agent/TCPSink]
$ns attach-agent $n0 $sink0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n0 $sink2
set sink3 [new Agent/TCPSink]
$ns attach-agent $n0 $sink3

#virtually connect source and sink
$ns connect $tcp0 $sink0
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$ns connect $tcp3 $sink3
#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection

set p1 [new Agent/Ping]
$ns attach-agent $n1 $p1
set p2 [new Agent/Ping]
$ns attach-agent $n2 $p2
set p3 [new Agent/Ping]
$ns attach-agent $n3 $p3
set p4 [new Agent/Ping]
$ns attach-agent $n4 $p4
set p5 [new Agent/Ping]
$ns attach-agent $n5 $p5
set p6 [new Agent/Ping]
$ns attach-agent $n6 $p6
set p7 [new Agent/Ping]
$ns attach-agent $n7 $p7
set p8 [new Agent/Ping]
$ns attach-agent $n8 $p8
set p9 [new Agent/Ping]
$ns attach-agent $n9 $p9
#virtually connect
$ns connect $p1 $p5
$ns connect $p2 $p6
$ns connect $p3 $p7
$ns connect $p4 $p8
$ns connect $p4 $p9
$p1 set packetSize_ 300
$p1 set interval_ 0.00001
$p2 set packetSize_ 300
$p2 set interval_ 0.00001
$p3 set packetSize_ 300
$p3 set interval_ 0.00001
$p4 set packetSize_ 300
$p4 set interval_ 0.00001
$p5 set packetSize_ 300
$p5 set interval_ 0.00001
$p6 set packetSize_ 300
$p6 set interval_ 0.00001
$p7 set packetSize_ 300
$p7 set interval_ 0.00001
$p8 set packetSize_ 300
$p8 set interval_ 0.00001
$p9 set packetSize_ 300
$p9 set interval_ 0.00001
#set queue limit

#writing receive procedure
Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id]received reply from $from with round-trip time $rtt msec"
}

for {set ab 0.0} {$ab < 10.0} {set ab [expr $ab + 0.1000000000000000000]} {
$ns at $ab "$p1 send"
$ns at $ab "$ftp0 start"
}
for {set ab 0.0} {$ab < 5.0} {set ab [expr $ab + 0.1000000000000000000]} {
$ns at $ab "$p2 send"
$ns at $ab "$ftp0 stop"
$ns at 3.0 "$ftp1 start"
}
for {set ab 0.0} {$ab < 30.0} {set ab [expr $ab + 0.1000000000000000000]} {
$ns at $ab "$p3 send"
$ns at $ab "$ftp1 stop"
$ns at $ab "$ftp2 start"
}
for {set ab 0.0} {$ab < 20.0} {set ab [expr $ab + 0.1000000000000000000]} {
$ns at $ab "$p4 send"
$ns at $ab "$ftp2 stop"
$ns at $ab "$ftp3 start"
}
for {set ab 0.0} {$ab < 30.0} {set ab [expr $ab + 0.1000000000000000000]} {
$ns at $ab "$p5 send"
$ns at $ab "$ftp3 stop"

}


#$ns at 0.0 "$ftp0 start"
#$ns at 2.0 "$ftp0 stop"
#$ns at 3.0 "$ftp1 start"
#$ns at 4.0 "$ftp1 stop"
#$ns at 4.0 "$ftp2 start"
#$ns at 5.0 "$ftp2 stop"
#$ns at 6.0 "$ftp3 start"
#$ns at 7.0 "$ftp3 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
