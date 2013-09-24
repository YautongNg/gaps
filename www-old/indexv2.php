<title>GAPS v5.0 - GPS Analysis and Positioning Software</title>
<head>
<style type="text/css">
<!--
.style1 {
	font-size: 20px;
	font-family: "Times New Roman", Times, serif;
        font-weight: bold;
}
.style2 {
	color: #000066;
	font-weight: bold;
}
.style4 {font-size: 24px}
.style5 {font-size: 20px ;font-weight: bold;color: #FF0000}
.style6 {font-size: 16px ;font-weight: bold;color: #FF0000}
-->
</style>
</head>
<PRE class="style1 style5" align="left">   </PRE>
<PRE class="style1 style5" align="left">   </PRE>


<img src="Graphics/gaps.jpg" /></br>
</br>
<strong>GAPS v5.0 - GPS Analysis and Positioning Software </strong></br>




<p>Filename must follow RINEX naming conventions: <strong>ssssdddh.yyt </strong>where
<li>ssss is the four character site identifier
<li>ddd is the day of year Click <a href="http://csrc.ucsd.edu/scripts/convertDate.cgi">here </a> for date converter.
<li>h is session identifier, 0-9
<li>yy is the two digit year
<li>t is the file type, 'o' for observations, 'd' for Hatanaka compressed.<br>
Click <a href="https://currents.cfc.umt.edu:8443/display/BeWhere/Rinex+Naming+Convention">here</a> for more details.<br>
Examples: abcd001.08o.gz, abcd131.08o, jdu1013.05d.Z etc.
<br><br>
Files may be uncompressed or compressed using <a href="http://www.willus.com/archive/unixcmds.zip">UNIX compression</a> (*.Z) or <a href="http://www.gzip.org/">gzip </a> *.gz)
<br></br>GAPS utilizies both IGS rapid and final clock and orbit products. Therefore a latency of 17 - 41 hours may be required.

</p>

</PRE>

<PRE class="style1 style5" align="left">  </PRE>



<form enctype="multipart/form-data" action="<?php echo $_SERVER["PHP_SELF"]; ?>" method="post">
  <p>
    <input type="hidden" name="MAX_FILE_SIZE" value="10048000">
    File:
  <input name="userfile" type="file" />
  <br>
  <br></p>
   <strong><br>
  </strong>
  <p align="left"><strong><span class="style6">Options</span><br>
  </strong></p>
  <hr>
  <p class="style2">	A-priori coordinates </p>
  <table width="99%" border="0" cellspacing="0" cellpadding="00">
    <tr>
      <td width="34%">X (m) / Latitude (sdd.mmssssss) </td>
      <td width="66%"><input name="X" type="text" id="X" value="0"></td>
    </tr>
    <tr>
      <td>Y (m) / Longitude (sdd.mmssssss)&nbsp;</td>
      <td><input name="Y" type="text" id="Y" value="0"></td>
    </tr>
    <tr>
      <td>Z (m) / Height (m)</td>
      <td><input name="Z" type="text" id="Z" value="0"></td>
    </tr>
  </table>
  <span class="style5">(*) if zero,  RINEX approximate coordinates will be used as apriori</span><br>
  <br>
  <table width="99%" border="0" cellpadding="00" cellspacing="0">
    <tr>
      <td width="34%">A-priori coordinates constraint (m) </td>
      <td width="66%"><input name="cc" type="text" id="cc" value="0"></td>
    </tr>
  </table>
  <span class="style5">(*) if zero, coordinates will be unconstrained</span><br>
  <br>
  <hr>
  <p class="style2">Data processing </p>
  <table width="99%" border="0" cellspacing="0" cellpadding="00">

    <tr>
      <td width="34%">Initial time (hhmmss) </td>
      <td width="66%"><input name="it" type="text" id="it" value="000000"></td>
    </tr>
    <tr>
      <td>Final time (hhmmss) </td>
      <td><input name="ft" type="text" id="ft" value="235959"></td>
    </tr>
  </table>
  <br>
  <table width="99%" border="0" cellpadding="00" cellspacing="0">
    <tr>
      <td width="34%">Positioning type </td>
      <td width="66%">
	  <input name="pos" type="radio" value="sta" checked>
      Static
        <input name="pos" type="radio" value="kin">
      Kinematic</td>
    </tr>
  </table>
  <strong><br>
  </strong>
  <table width="99%" border="0" cellspacing="0" cellpadding="00">
    <tr>
      <td width="34%">Cutoff elevation angle (degrees) </td>
      <td width="66%"><input name="el" type="text" id="el" value="10"></td>
    </tr>
  </table>
   <strong><br>
  </strong>
  <hr>
  <p class="style2">Neutral Atmosphere Delay  </p>
  <table width="99%" border="0" cellspacing="0" cellpadding="00">
    <tr>
      <td width="34%">A-priori NAD prediction model:</td>
      <td width="66%">VMF1 Gridded/UNB3m backup</td>
    </tr>
    <tr>
      <td>Apriori NAD standard deviation (m) </td>
      <td><input name="nsd" type="text" id="nsd" value="0.10"></td>
    </tr>
    <tr>
      <td>NAD process noise (mm/h) </td>
      <td><input name="nrw" type="text" id="nrw" value="5"></td>
    </tr>
    <tr>
      <td>Apriori gradient standard deviation (m) </td>
      <td><input name="gsd" type="text" id="gsd" value="0.001"> Set to -1 to not estimate.</td>
    </tr>
    <tr>
      <td>Gradient process noise (mm/h) </td>
      <td><input name="grw" type="text" id="grw" value="0.3"> Set to -1 to not estimate.</td>
    </tr>
</table>
<strong><br>
  </strong>
  <hr>
  <p class="style2">Site Displacement Effects </p>
  <table width="99%" border="0" cellspacing="0" cellpadding="00">     <tr>
	<td width ="15%">Apply Solid Earth Tides? </td>
	<td width="35%"> </td>
      <td width="20%">
	<input name="etd" type="radio" value="1" checked>
      Yes
        <input name="etd" type="radio" value="0" >
      No</td>
    </tr>
    <tr>
	<td width ="15%">Apply Ocean Tidal Loading? </td><td id='fileupload' width="35%">

        If your station is in our <a href ="IGStations.txt">list</a> you do not need to upload a file. If not, you can submit your own in BLQ format. Ocean tide loading data available <a href ="http://froste.oso.chalmers.se/loading/">here.</a>
      <input name="userfile2"  type="file" />
	<td width="35%"> </td>
      <td width="20%">
	<input name="otl" type="radio" value="1" checked>
      Yes
        <input name="otl" type="radio" value="0" >
      No</td>
    </tr>
  </table>
   <strong><br>
  </strong>
  <hr>
  <p class="style2">Pictures format  </p>
  <table width="99%" border="0" cellpadding="00" cellspacing="0">
    <tr>
      <td width="66%">
	<input name="pic" type="radio" value="1">
      emf
        <input name="pic" type="radio" value="2" checked>
      jpg</td>
    </tr>
  </table>
 <hr>
  <p class="style2">E-mail  </p>
  <table width="99%" border="0" cellspacing="0" cellpadding="00">
   <tr>
      <td width="34%">E-mail address to receive results: </td>
      <td width="66%"><input name="ema" type="text" id="ema" value=""></td>
    </tr>
  </table>
   <strong><br>
  </strong>
  <hr>
  <br>
  <br>
  <input name="submit" type="submit" value="Process" />
  <br>
  <p>&nbsp;</p>
</form>


<?php
import_request_variables('p');
if (@is_uploaded_file($_FILES["userfile"]["tmp_name"])) {
copy($_FILES["userfile"]["tmp_name"], "c:/phpdev/www/ppp/files/" . $_FILES["userfile"]["name"]);
$NOME=str_replace('.','_',$_FILES["userfile"]["name"]);
$NOME2=$_FILES["userfile"]["name"];

//if (@is_uploaded_file($_FILES["userfile2"]["tmp_name"])) {
//copy($_FILES["userfile2"]["tmp_name"], "c:/phpdev/www/ppp/files/" . $_FILES["userfile2"]["name"]);

//echo("cd C:/PPP/ && autoDP2 $NOME2 $X $Y $Z $cc $it $ft $pos $el $nsd $nrw");

//$output = shell_exec("cd C:\PPP\ && autoDP3 $NOME2 $pic $X $Y $Z $cc $it $ft $pos $el $nsd $nrw");

//echo ("cd C:\PPP\ && autoDP3 $NOME2 $pic $X $Y $Z $cc $it $ft $pos $el $nsd $nrw");

echo ('<PRE align="left" class="style2">Your file has been received. Results will be sent by e-mail (This can take a few minutes).');
echo ('<PRE align="left" class="style2"> ');
echo ('<PRE align="left" class="style5">You can close this window now.');
flush();

$output = shell_exec("cd C:\PPP\ && autoDP6 $NOME2 $pic $X $Y $Z $cc $it $ft $pos $el $nsd $nrw $ema $gsd $grw $otl $etd");


//echo( "cd C:\PPP\ && autoDP6 $NOME2 $pic $X $Y $Z $cc $it $ft $pos $el $nsd $nrw $ema" );

//$output = shell_exec("C:/autoDP2 {$NOME2} {$_POST['X']} {$_POST['Y']} {$_POST['Z']} {$_POST['cc']} {$_POST['it']} {$_POST['ft']} {$_POST['pos']} {$_POST['el']} {$_POST['nsd']} {$_POST['nrw']}");

//$output = shell_exec("C:/autoDP2 $NOME2 $_POST['X'] $_POST['Y'] $_POST['Z'] $_POST['cc'] $_POST['it'] $_POST['ft'] $_POST['pos'] $_POST['el'] $_POST['nsd'] $_POST['nrw']");


//$output = shell_exec('C:/PPP/autoDP');
//$output = shell_exec('C:/PPP/autoDP');
//echo(' Finished - Use the links bellow to acces your results.</PRE>');
//echo("<PRE align=\"left\"><a target=\"_blank\" href=\"http://gaps.gge.unb.ca/ppp_results/{$NOME}/{$NOME}.html\">Results Summary</a></PRE>");
//echo("<PRE align=\"left\"><a target=\"_blank\" href=\"http://gaps.gge.unb.ca/ppp_results/{$NOME}/{$NOME}.zip\">All Results (zip file)</a></PRE>");
//echo('<PRE class="style5" align="left"> If you get an error message when trying to access the links above it means your file was NOT successfuly //processed.</PRE>');
//flush();
}
?>

