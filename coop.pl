#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);


my $minimum = 1;
my $maximum = 100;

my $minimumSpd = 1;
my $maximumSpd = 100;



get '/' => 'index';

websocket '/echo' => sub {
  my $ws = shift;
  $ws->app->log->debug('WebSocket opened');

  $ws->inactivity_timeout(300);

  my $id = Mojo::IOLoop->recurring(1 => sub {

my $outdoorTemp = $minimum + int(rand($maximum - $minimum));
my $indoorTemp  = $minimum + int(rand($maximum - $minimum));
my $cpuTemp = cpuTempF();


my $bytes = encode_json {outdoorTemp => $outdoorTemp, indoorTemp => $indoorTemp, cpuTemp => $cpuTemp};
$ws->send($bytes);
 
 });

   $ws->on(finish => sub {
    my ($ws, $code, $reason) = @_;
    $ws->on(finish => sub { Mojo::IOLoop->remove($id) });

    $ws->app->log->debug("WebSocket closed with status $code");

  });
};
app->start;



sub cpuTempF 
        {
                
                my $cpuTemp = `/opt/vc/bin/vcgencmd measure_temp`;
                my @cpuTempBefore = split(/=/,$cpuTemp);
                my $cpuTempBefore;
                my @cpuTempAfter = split(/\'/,$cpuTempBefore[1]);
                my $cpuTempAfter;
                my $F = $cpuTempAfter[0] * 9/5 + 32;
		return $F;
        }










__DATA__

@@ index.html.ep


%= javascript 'excanvas.js';
%= javascript 'gauge-meterTest.js';



<!DOCTYPE html>
<html>
  <head><title>Web Socket Mojolicious</title>
</head>
  <body>


   <div id="outdoorTempGauge" style="width: 320px";></div>
	<div id="indoorTempGauge" style="width: 320px";></div>
	 <div id="cpuTempGauge" style="width: 320px";></div>





    <script>
  
 	var ws = new WebSocket('<%= url_for('echo')->to_abs %>');
 	ws.onmessage = function(event) {
		var res = JSON.parse(event.data);
	//	document.getElementById("outdoorTemp").innerHTML = res.outdoorTemp;
//		document.getElementById("indoorTemp").innerHTML = res.indoorTemp;
//		document.getElementById("cpuTemp").innerHTML = res.cpuTemp;
		var outdoorTemp = res.outdoorTemp;
		var indoorTemp = res.indoorTemp;
		var cpuTemp = res.cpuTemp;
      
// Outdoor 

    outdoorTemp_settings = 
    {
        ElementId     : "outdoorTempGauge",
        Value         : outdoorTemp,
        Animate       : false,
        MinLabel      : "0 F",
        MaxLabel      : "50F",
	StartEazingAt   : 0.5,
        Text          : "Outdoor temp",
        GaugeColors   :
        [
                '#006600', '#006600',
                '#33CC33', '#33CC33',
                '#33CC33', '#33CC33',
                '#33CC33', '#FFCC00',
                '#FF6600', '#FF0000'

        ],
        GaugeSegments : { BorderColor : '#0000FF', BorderWidth : 1},
        NeedlePivot   : { BorderColor : '#0000FF', BackgroundColor : '#D0D0FF' },
        Font          : '24px Helvetica'


    }


    GaugeMeter(outdoorTemp_settings);
 

// Indoor 

  indoorTemp_settings = 
    {
        ElementId     : "indoorTempGauge",
        Value         : indoorTemp,
        Animate       : false,
        MinLabel      : "0 F",
        MaxLabel      : "50F",
        StartEazingAt   : 0.5,
        Text          : "Indoor temp",
        GaugeColors   :
        [
                '#006600', '#006600',
                '#33CC33', '#33CC33',
                '#33CC33', '#33CC33',
                '#33CC33', '#FFCC00',
                '#FF6600', '#FF0000'

        ],
        GaugeSegments : { BorderColor : '#0000FF', BorderWidth : 1},
        NeedlePivot   : { BorderColor : '#0000FF', BackgroundColor : '#D0D0FF' },
        Font          : '24px Helvetica'


    }

    GaugeMeter(indoorTemp_settings);

// cpuTemp

  cpuTemp_settings = 
    {
        ElementId     : "cpuTempGauge",
        Value         : cpuTemp,
        Animate       : false,
	MaxValue      : 150,
        MinLabel      : "0 F",
        MaxLabel      : "150 F",
        StartEazingAt   : 0.5,
        Text          : "CPU  temp",
        GaugeColors   :
        [
                '#006600', '#006600',
                '#33CC33', '#33CC33',
                '#33CC33', '#33CC33',
                '#33CC33', '#FFCC00',
                '#FF6600', '#FF0000'

        ],
        GaugeSegments : { BorderColor : '#0000FF', BorderWidth : 1},
        NeedlePivot   : { BorderColor : '#0000FF', BackgroundColor : '#D0D0FF' },
        Font          : '24px Helvetica'


    }

    GaugeMeter(cpuTemp_settings);





};


</script>
</body>
</html>

