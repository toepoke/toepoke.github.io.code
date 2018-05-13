/// 
/// Little snippet which finds all the links on a https://www.google.com/bookmarks on a page
/// as a set of markdown ready for pasting.
/// 

var search = document.getElementById("search");
var hits = [];

// Find all hyperlinks to start with
var links = search.querySelectorAll("a");

function tidyTargetLink(href) {
	if (!href) {
		return "";
	}
	// google bookmarks adds a redirect ... we don't want that!
	href = href.replace("https://www.google.com/url?q=", "");

	// google also adds a suffix which means we get 404 all over the place!, so get rid of that!
	var pos = href.indexOf("&usd");
	if (pos > 0) {
		href = href.substring(0, pos);
	}

	return href;
}

function extractBookmarkComment(infoEle) {
	var info = "";
	if (!infoEle) {
		return info;
	}
	// GB adds a summary of the tags before out comment, so skip that part out
	info = infoEle.textContent;
	// GB also adds some preamble, so we'll remove that too
	var preamblePos = info.indexOf(" - ");
	if (preamblePos > 0) {
		info = info.substring(preamblePos + " - ".length);
	} else {
		// GB will just include the tags, which we aren't interested in
		info = "";
	}

	return info;
}

// Loop over all links and identify which links are actually bookmark links!
for (var link of links) {
	var id = link.getAttribute("id");
	var href = link.getAttribute("href");
	var info = "";

	if (id && id.indexOf("bkmk_href_") === 0 && href && href.length > 0) {
		var hit = {
			text: link.text,
			href: link.href,
			info: "",
			link: link
		};

		hit.href = tidyTargetLink(hit.href);

		// we may have addition notes to the link we want including
		// link.parentElement.parentElement.parentElement.querySelectorAll("td span#bkmk_info_0")[0].innerText
		var infoId = id.replace("_href_", "_info_");
		var infoEles = link.parentElement.parentElement.parentElement.querySelectorAll("td span#" + infoId);
		if (infoEles && infoEles.length > 0) {
			hit.info = extractBookmarkComment(infoEles[0]);
		}

		// and finally, if the info has a | in it, markdown will see this as a table cell declaration
		// ... so escape that out
		hit.text = hit.text.replace("|", "&#124;");

		hits.push(hit);
	} // if bookmark link

	var markdown = "";
	for (var hit of hits) {
// copy all links into markdown format
		markdown += `* [${hit.text}](${hit.href})`;
// add notes if there are any
		if (hit.info && hit.info !== "") {
			markdown += `* - ${hit.info}*`;
		}
		markdown += "\n";
	}
} // foreach (link)

// output results
console.clear()
copy(markdown);
console.info(markdown);
console.warn(hits, `\n${hits.length} markdown links have been copied to the clipboard.`);
console.info("Once you're done, remember to scroll to the bottom");
console.info("'Manage Labels' to delete the '11' label so we're ready for next time!");
