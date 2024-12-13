<HTML><HEAD><TITLE>Photo Album</TITLE>
<LINK REL="stylesheet" HREF="/inc/gallery.css">
<SCRIPT SRC="/inc/gallery.js"></SCRIPT>
</HEAD>
<BODY onLoad="definer()">
<H2>Photos</H2>
You might want to drag this window off to the right side of your screen. 
<P>
This is kind of an arbitrary pile of pictures. They drop off after a time (currently 1 month), but some day I will add an option for viewing archives of older bunches. 
<P>
<HR SIZE=1>
<TABLE CELLPADDING=4 CELLSPACING=4><TR>
<?php
$now = time();
if ($dir = @opendir("/home/httpd/html/pyoing/pix")) {
 $cnt = 0;
 while(false !== ($file = readdir($dir))) {
  if(preg_match("/\.jpg$|\.mov$|\.mpg$/i", "$file")) {
	$fmtime = date(U, filemtime($file));
	if ($fmtime < ($now - 15552000)) { /* six months */
//	if ($fmtime < ($now - 10368000)) {
//	if ($fmtime < ($now - 5184000)) {
//	if ($fmtime < ($now - 2592000)) {
		continue;
	}
    $blob[$file] = $fmtime;
  }
 }
}
closedir($dir);
//$boob = sort($blob);
//arsort($blob);
//$boob = msort($blob);
foreach($blob as $fname => $key) {
    $name = ereg_replace("\.jpg", "", $fname);
    echo "<TD><A HREF=\"/pix/$fname\" TARGET=\"mom\">$name</A></TD>\n";
    $cnt++;
    if (is_int($cnt/3)) {
     echo "</TR>\n<TR>";
    } 
}
function msort($array, $id="id") {
	$temp_array = array();
	while(count($array)>0) {
		$lowest_id = 0;
		$index=1;
		foreach ($array as $item) {
			if (isset($item[$id]) && $array[$lowest_id][$id]) {
				if ($item[$id]<$array[$lowest_id][$id]) {
					$lowest_id = $index;
				}
			}
			$index++;
		}
		$temp_array[] = $array[$lowest_id];
		$array = array_merge(array_slice($array, 0,$lowest_id), array_slice($array, $lowest_id+1));
	}
	return $temp_array;
}
?>
</TR></TABLE>
<HR SIZE=1>
<DIV CLASS="button"><FORM><input TYPE="button" VALUE="Close" onClick="window.close()"></FORM></div>
</BODY>
</HTML>
