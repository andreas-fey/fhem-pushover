##############################################
package main;

use strict;
use warnings;
use HttpUtils;
use Encode;

sub pushover_Initialize($) {
    my ($hash) = @_;

    $hash->{SetFn}    = "pushover_Set";
    $hash->{DefFn}    = "pushover_Define";
    $hash->{AttrList} = undef;
}

###################################
sub pushover_Set($@) {
    my ( $hash, @a ) = @_;
    my $result;

    return "no set value specified" if ( int(@a) < 2 );
    return "msg" if ( $a[1] eq "?" );

    shift @a;
    my $name = shift @a;
    my $v = join( " ", @a );

    if ( $name eq "msg" ) {
        Log3 $name, 2, "pushover set $name msg $v";
        $result = sendMsg( $hash, $v );
    }
    else {
        return "unknown argument $name, choose msg";
    }

    $hash->{CHANGED}[0] = $v;
    $hash->{STATE} = $v;

    readingsBeginUpdate($hash);
    readingsBulkUpdate( $hash, "lastMsg", $v );
    readingsBulkUpdate( $hash, "state",   $result );
    readingsEndUpdate( $hash, 1 );

    return undef;
}

sub pushover_Define($$) {
    my ( $hash, $def ) = @_;
    my @a = split( "[ \t][ \t]*", $def );

    my $u = "wrong syntax: define <name> <token> <user>";
    return $u if ( int(@a) < 3 );

    $hash->{token} = $a[2];
    $hash->{user}  = $a[3];

    return undef;
}

sub sendMsg {
    my ( $hash, $msg ) = @_;
    my $name     = $hash->{NAME};
    my $token    = $hash->{token};
    my $user     = $hash->{user};
    my $response = "";
    my $URL      = "https://api.pushover.net/1/messages.json";

    my $POST =
      "token=" . $token . "&user=" . $user . "&message=" . urlEncode($msg);

    Log3 $name, 4, "pushover $name: POST $URL (" . urlDecode($POST) . ")";
    $response = CustomGetFileFromURL( 0, $URL, 3, $POST, 0, 5 );

    if ( $response =~ m/"status":(.*),/ ) {
        return "ok" if $1 eq "1";
        return "error";
    }

    return "undefined";
}

1;

=pod
=begin html

<a name="pushover"></a>
<h3>Pushover</h3>
<ul>
  <a name="pushover_define"></a>
  <h4>Define</h4>
  <ul>
    <code>define &lt;name&gt; pushover &lt;yourToken&gt; &lt;yourUser&gt;
          &lt;yourMessage&gt;</code>
    <br><br>

    Defines a module for sending Push Messages using <a href="http://www.pushover.com">Pushover</a>.<br><br>

    Example:
    <ul>
      <code><define Push pushover aRGcjYZvpBwYQWAreoWr5pdaz7Q3ke uevdarUBH6hqj532pd3kGr5rzUY54oq/code><br>
    </ul>
  </ul>

  <a name="pushover_Set"></a>
  <h4>Set </h4>
  <ul>
    <code>set &lt;name&gt; &lt;value&gt;</code>
    <br><br>
    where <code>value</code> is one of:<br>
    <pre>
    msg                # the message to send via push
    </pre>

    Examples:
    <ul>
      <code>set msg "My push message"</code><br>
    </ul>
  </ul>

  <a name="push_Attr"></a>
  <h4>Attributes</h4> 
  <ul>
    <li><a name="token"><code>attr &lt;name&gt; token &lt;string&gt;</code></a>
                <br />App token from Pushover</li>
    <li><a name="user"><code>attr &lt;name&gt; user &lt;string&gt;</code></a>
                <br />User token from Pushover</li>
  </ul>
</ul>

=end html
=cut
