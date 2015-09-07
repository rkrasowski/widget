#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);


my $minimum = 0;
my $maximum = 100;

my $minimumSpd = 0;
my $maximumSpd = 15;



get '/' => 'index';

websocket '/echo' => sub {
  my $ws = shift;
  $ws->app->log->debug('WebSocket opened');

  $ws->inactivity_timeout(300);

  my $id = Mojo::IOLoop->recurring(0.5 => sub {

my $lat = $minimum + int(rand($maximum - $minimum));
my $lon = $minimum + int(rand($maximum - $minimum));
my $speed = $minimumSpd + int(rand($maximumSpd - $minimumSpd));

my $bytes = encode_json {lat => $lat, lon => $lon, speed => $speed};
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
%= javascript 'gauge-meter.js';



<!DOCTYPE html>
<html>
  <head><title>Web Socket Mojolicious</title>
</head>
  <body>


   <div id="gauge3" style="width: 320px";></div>






    <script>
  
 	var ws = new WebSocket('<%= url_for('echo')->to_abs %>');
 	ws.onmessage = function(event) {
		var res = JSON.parse(event.data);
	//	document.getElementById("Lat").innerHTML = res.lat;
//		document.getElementById("Lon").innerHTML = res.lon;
//		document.getElementById("Spd").innerHTML = res.speed;
		var gaugeVal = res.lat;
      


    gm3_settings = 
    {
        ElementId     : "gauge3",
       Value         : gaugeVal,
        Animate       : false,
        MinLabel      : "0 %",
        MaxLabel      : "100 %",
        Text          : "Power",
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

