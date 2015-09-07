#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);


my $minimum = 1;
my $maximum = 100;

my $minimumSpd = 0;
my $maximumSpd = 15;



get '/' => 'index';

websocket '/echo' => sub {
  my $ws = shift;
  $ws->app->log->debug('WebSocket opened');

  $ws->inactivity_timeout(300);

  my $id = Mojo::IOLoop->recurring(0.5 => sub {

my $outdoorTemp = $minimum + int(rand($maximum - $minimum));
my $indoorTemp  = $minimum + int(rand($maximum - $minimum));
my $cpuTemp = $minimumSpd + int(rand($maximumSpd - $minimumSpd));

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
      


    gm3_settings = 
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
    GaugeMeter(gm3_settings);
 
    function reloadGM3()
    {
        GaugeMeter(gm3_settings);
    }




};



  </script>



  </body>
</html>

