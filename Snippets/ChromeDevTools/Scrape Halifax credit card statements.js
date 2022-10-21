/**
  As with all finance websites it's too hard to download statements.  The Haliax one you have to clear on each month.  Bit of a pain if you're downloading
  years worth.  This little snippet makes it a little easier:
  
  1. Log into your account as normal
  2. Nav to the statements page that shows all your downloadable statements
  3. Select the year of interest
  4. Copy+paste this snippet into the snippet tab in Chrome DevTools
  5. Run it
  
The script will go over each download link and click it.  You just have to click the "Save" button.

BEWARE:
It only downloads the first 10 ... no idea why, haven't really looked.  
Just be aware you have to download the other 2 ... will remind you why it's such a pain!
**/

Number.prototype.padZero= function(len){
 var s= String(this), c= '0';
 len= len || 2;
 while(s.length < len) s= c + s;
 return s;
}

function downloadURI(uri, name) {
  var link = document.createElement("a");
  link.download = name;
  link.href = uri;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  delete link;
}

function downloadAllStatements() {
    var rows = $("table.statements tbody tr");

    for (var i=0; i < rows.length; i++) {
        var row = rows[i];
        var dateStr = row.children[0].textContent.trim();
        var links = row.querySelectorAll("a");
        var downloadLink = links[1].href;
        var date = new Date(dateStr);
        var filename = date.getFullYear() + date.getMonth().padZero() + " - " + dateStr + ".pdf";

        console.log(filename, dateStr, downloadLink);

        // giving the filename doesn't work 
        
        downloadURI(downloadLink, filename);
        
    }

}

downloadAllStatements();
