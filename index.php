<HTML><HEAD> <TITLE>KXRY Broadcast Archive</TITLE>
<LINK REL="stylesheet" HREF="/archive/kxry.css">
</HEAD>
<BODY>
<a href="xray.fm" alt="Public Home Page"  border=0><img src="https://xray.fm/theme/107/img/logo1_white-on-black_399.png" width=110></a>
<H2>Broadcast Archive</H2>
<table><tr>
<?php
$base = "/home/linda/radio";
$blob = scandir($base, SCANDIR_SORT_ASCENDING);
echo "<td valign=top>";

$cnt=0;
$day=0;
foreach($blob as $fname){
	if(preg_match("/\.mp3$/", "$fname")){
		$cnt++;
		$dname = preg_replace("/\.mp3/", "", $fname);
		echo "<A HREF=\"/archive/files/$fname\">$dname</A><BR>\n";
		if(is_int($cnt/24)){
			$day++;
			echo "</TD>\n";
			echo "<TD valign=top>";
		}
	}
}
?>
</td></TR></TABLE>
</BODY>
</HTML>
