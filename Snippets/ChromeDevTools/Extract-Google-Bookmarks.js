/// 
/// Little snippet which finds all the links on a https://www.google.com/bookmarks on a page
/// as a set of markdown ready for pasting.
/// 

var search = document.getElementById("search");
var hits = [];

// Find all hyperlinks to start with
var links = search.querySelectorAll("a");

// Loop over all links and identify which links are actually bookmark links!
for (var link of links) {
	var id = link.getAttribute("id");
	var href = link.getAttribute("href");

	if (id && id.indexOf("bkmk_href_") === 0 && href && href.length > 0) {
		var hit = {
			text: link.text,
			href: link.href,
			link: link
		};

		// google bookmarks adds a redirect ... we don't want that!
		hit.href = hit.href.replace("https://www.google.com/url?q=", "");

		// google also adds a suffix which means we get 404 all over the place!, so get rid of that!
		var pos = hit.href.indexOf("&usd");
		if (pos > 0) {
			hit.href = hit.href.substring(0, pos);
		}

		hits.push(hit);
	} // if bookmark link

	var markdown = "";
	for (var hit of hits) {
// copy all links into markdown format
		markdown += `* [${hit.text}](${hit.href})\n`;
	}
} // foreach (link)

// output results
console.clear()
copy(markdown);
console.info(markdown);
console.warn(`${hits.length} markdown links have been copied to the clipboard.`);
console.info("Once you're done, remember to scroll to the bottom");
console.info("'Manage Labels' to delete the '11' label so we're ready for next time!");
