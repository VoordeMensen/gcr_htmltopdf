<?
// Fast PDF generation - VoordeMensen - 2020
//
// input: HTTP POST with html
// pagination by splitting </page> tag
// output: wrapper to wkhtmltopdf returns inline PDF with random name

require __DIR__ . '../../vendor/autoload.php';
use mikehaertl\wkhtmlto\Pdf;
use voku\helper\HtmlDomParser;

$html = HtmlDomParser::str_get_html($_POST['html']);

// split input by page tags
$pdfdata=$html;
$pdfdata = explode("</page>",$pdfdata);
array_pop($pdfdata);

// if no pagetags handle as a single page
if(!$pdfdata) {
    $pdfdata[0]=$html;
}

// create PDF
$pdf = new Pdf(array(
    'use-xserver',
    'commandOptions' => array(
       'enableXvfb' => true,
    ),    
    'no-outline',         // Make Chrome not complain
    'margin-top'    => 0,
    'margin-right'  => 3,
    'margin-bottom' => 3,
    'margin-left'   => 3,

    // Default page options
    'disable-smart-shrinking',
));

// addPages 
foreach ($pdfdata as &$page) {
	$page = "<html>".utf8_decode($page)."</html>";
	$pdf->addPage($page);
}

// output 
$rand = substr(md5(microtime()),rand(0,26),5);
if (!$pdf->send('gcr_htmltopdf_'.$rand.'.pdf',true)) {
    echo $pdf->getError();
}
?>
