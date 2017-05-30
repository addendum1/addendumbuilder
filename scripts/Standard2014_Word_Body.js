function getLongString(f) {
  return f.toString().
    replace(/^[^\/]+\/\*!?/, '').
    replace(/\*\/[^\/]+$/, '');
}





function addSpaces(numOfSpaces) {
  var txt = '';
  for(var j=0; j<numOfSpaces; j++) {
    txt += '<w:r w:rsidRPr="00AB07D0">';
    txt += '  <w:rPr>';
    txt += '      <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
    txt += '      <w:b/>';
    txt += '      <w:sz w:val="16"/>';
    txt += '      <w:szCs w:val="16"/>';
    txt += '    </w:rPr>';
    txt += '    <w:t xml:space="preserve"> </w:t>';  // add a space
    txt += '</w:r>';
  }
  return txt;
}





function buildClause_Bold(theVal) {
  var txt = '<w:r w:rsidRPr="002123A2">';
  txt += '  <w:rPr>';
  txt += '    <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
  txt += '    <w:b/>';
  txt += '    <w:bCs/>';
  txt += '    <w:sz w:val="16"/>';
  txt += '    <w:szCs w:val="16"/>';
  txt += '  </w:rPr>';
  txt += '  <w:t xml:space="preserve">' + theVal + '</w:t>';
  txt += '</w:r>';
  return txt;
}





function buildClause_BoldUnderlined(theVal) {
  var txt = '<w:r w:rsidRPr="00AB07D0">';
  txt += '  <w:rPr>';
  txt += '      <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
  txt += '      <w:b/>';
  txt += '      <w:sz w:val="16"/>';
  txt += '      <w:szCs w:val="16"/>';
  txt += '     <w:u w:val="single"/>';
  txt += '    </w:rPr>';
  txt += '    <w:t xml:space="preserve">' + theVal + '</w:t>';
  txt += '</w:r>';
  return txt;
}




function buildClause_Amount(theVal,amountInWords) {
  // Format the value as a dollar amount
  var nVal = parseInt(theVal,10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
  // Build the rest
  var txt = '<w:r w:rsidRPr="00AB07D0">';
  txt += '    <w:rPr>';
  txt += '      <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
  txt += '      <w:b/>';
  txt += '      <w:bCs/>';
  txt += '      <w:sz w:val="16"/>';
  txt += '      <w:szCs w:val="16"/>';
  txt += '    </w:rPr>';
  txt += '    <w:t xml:space="preserve">' + amountInWords + '($' + nVal + ')</w:t>';
  txt += '</w:r>';
  return txt;
}




function buildClause_Normal(theVal) {
  var txt = '<w:r w:rsidRPr="00AB07D0">';
  txt += '     <w:rPr>';
  txt += '       <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
  txt += '       <w:sz w:val="16"/>';
  txt += '       <w:szCs w:val="16"/>';
  txt += '     </w:rPr>';
  txt += '     <w:t xml:space="preserve">' + theVal + '</w:t>';
  txt += '   </w:r>';
  return txt;
}





function buildClause_ClauseNumber(theVal) {
  var txt = '<w:r w:rsidRPr="009D2AD4">';
  txt += '    <w:rPr>';
  txt += '     <w:rFonts w:ascii="Arial Narrow" w:hAnsi="Arial Narrow" w:cs="Tahoma"/>';
  txt += '     <w:b/>';
  txt += '     <w:bCs/>';
  txt += '     <w:sz w:val="16"/>';
  txt += '     <w:szCs w:val="16"/>';
  txt += '   </w:rPr>';
  txt += '   <w:t>' + theVal + '</w:t>';
  txt += '</w:r>';
  txt += '<w:r w:rsidR="00D04784" w:rsidRPr="009D2AD4">';
  txt += '   <w:rPr>';
  txt += '    <w:rFonts w:ascii="Arial Narrow" w:hAnsi="Arial Narrow" w:cs="Tahoma"/>';
  txt += '    <w:b/>';
  txt += '    <w:bCs/>';
  txt += '    <w:sz w:val="16"/>';
  txt += '    <w:szCs w:val="16"/>';
  txt += '   </w:rPr>';
  txt += '<w:t>.</w:t>';
  txt += '<w:tab/>';
  txt += '</w:r>';
  return txt;
}





function clauseFormatBeforeClause() {
   var txt = '    <w:pPr>';
   txt += '          <w:pStyle w:val="ListParagraph"/>';
   txt += '          <w:numPr>';
   txt += '             <w:ilvl w:val="0"/>';
   txt += '            <w:numId w:val="3"/>';
   txt += '          </w:numPr>';
   txt += '          <w:ind w:left="426" w:right="-450" w:hanging="426"/>';
   txt += '           <w:jc w:val="both"/>';
   txt += '          <w:rPr>';
   txt += '            <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
   txt += '             <w:sz w:val="16"/>';
   txt += '            <w:szCs w:val="16"/>';
   txt += '          </w:rPr>';
   txt += '       </w:pPr>';
   return txt;
}




function clauseFormatBeforeBullet() {
   var txt = ' <w:pPr>';
   txt += '     <w:pStyle w:val="ListParagraph"/>';
   txt += '     <w:numPr>';
   txt += '       <w:ilvl w:val="0"/>';
   txt += '       <w:numId w:val="4"/>';
   txt += '     </w:numPr>';
   txt += '     <w:ind w:left="709" w:right="-450" w:hanging="283"/>';
   txt += '     <w:jc w:val="both"/>';
   txt += '     <w:rPr>';
   txt += '       <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
   txt += '       <w:sz w:val="16"/>';
   txt += '       <w:szCs w:val="16"/>';
   txt += '     </w:rPr>';
   txt += '   </w:pPr>';
   return txt;
}





function clauseFormatAfterClause() {
 var txt = '<w:p w:rsidR="00B3718E" w:rsidRPr="00B3718E" w:rsidRDefault="00B3718E" w:rsidP="00A276C3">';
 txt += '<w:pPr>';
 txt += '    <w:ind w:left="426" w:right="-450" w:hanging="426"/>';
 txt += '    <w:jc w:val="both"/>';
 txt += '     <w:rPr>';
 txt += '       <w:rFonts w:ascii="Gisha" w:hAnsi="Gisha" w:cs="Gisha"/>';
 txt += '       <w:sz w:val="16"/>';
 txt += '       <w:szCs w:val="16"/>';
 txt += '      </w:rPr>';
 txt += '   </w:pPr>';
 txt += '</w:p>';
 return txt;
}


