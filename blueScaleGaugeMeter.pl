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
<h1>Gauge meter test!</h1>
To learn more, you can browse through the documentation
<%= link_to 'here' => '/perldoc' %>.

@@ layouts/default.html.ep

%= javascript 'excanvas.js';
%= javascript 'gauge-meter.js';







<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><
	<div id="gauge2" style="width: 320px";      ></div>
 
<script>
    //note that you don't need to assign the Gauge Meter to a var 
    //if your not planning on setting a different value later on
    GaugeMeter(
    {
        ElementId     : "gauge2",
        Value         : 33,
        Animate       : false,
        MinLabel      : "0 %",
        MaxLabel      : "100 %",
        Text          : "Power",
        GaugeColors   :
        [
            '#D0D0FF', '#C0C0FF',
            '#B0B0FF', '#A0A0FF',
            '#9090FF', '#8080FF',
            '#7070FF', '#6060FF',
            '#5050FF', '#4040FF'
        ],
        GaugeSegments : { BorderColor : '#0000FF', BorderWidth : 1},
        NeedlePivot   : { BorderColor : '#0000FF', BackgroundColor : '#D0D0FF' },
        Font          : '14px Helvetica'
 
    });
</script>

  </body>
</html>
