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
	<div id="gauge3" style="width: 320px";></div>
<button onclick="reloadGM3()">reload to see animation</button>
 
<script>
    gm3_settings = 
    {
        ElementId	: "gauge3",
        MinValue	: -100,
        MaxValue	: 100,
        Value           : 38,
        MinLabel	: "-100 c",
        MaxLabel	: "+100 c",
        Text            : "Temp. Celsius",
        GaugeColors     : ['#FF0000','#00FF00'],
        GaugeSegments   : { BorderColor: '#383838', BorderWidth: 2 },
        Panel           : { BorderWidth:1, BorderColor: '#000000',
                            BackgroundColor: '#FFFFFF',Margin: 3 },
        OuterBorder     : { BorderWidth:1, BorderColor: '#0F0F0F',
                            BackgroundColor: '#AEAEAE' },
        NeedlePivot     : { BorderWidth:1, BorderColor: '#0F0F0F',
                            BackgroundColor: '#AEAEAE' }
    }
    GaugeMeter(gm3_settings);
 
    function reloadGM3()
    {
        GaugeMeter(gm3_settings);
    }
</script>
 

  </body>
</html>
