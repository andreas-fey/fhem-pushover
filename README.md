fhem-pushover
=============

This in a <a href="http://www.pushover.com">Pushover</a> module for FHEM. Pushover is a service to send Push messages to iOS and Android devices via a simple API.
This module defines an actor which uses Pushover to send a message. 

<h2>Usage</h2>

First, define a device:

<code>define &lt;name&gt; pushover &lt;app token&gt; &lt;user token&gt;</code>

where "name" is your devices name; app and user token can be found in the Pushover dashboard. 

<br/>
You can use this actor e.g. with the THRESHOLD module and get a notofication if e.g. temperature falls beyond a defined minimum:

<code>define TempWatcherBathroom THRESHOLD Temp_Bath Push | set @ msg "Temp in bathroom too low!" | set @ msg "Temp in bathroom OK."</code>


<br/>
You can find more information on <a href="http://www.andreas-fey.com">my website</a>
