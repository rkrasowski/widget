#!/usr/bin/env perl
use Mojolicious::Lite;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Gauge-meter';

@@ layouts/default.html.ep

%= javascript 'excanvas.js';
%= javascript 'gauge-meter.js';





<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
 

 <body>
        <div id="gauge3" style="width: 320px";></div>

  </body>




<script>

var Value = 98;

    gm3_settings = 
    {
 	ElementId     : "gauge3",
       Value         : Value,
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
</script>
</html>
