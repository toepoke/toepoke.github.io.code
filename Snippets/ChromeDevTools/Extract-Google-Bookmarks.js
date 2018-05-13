/// 
/// Little snippet which finds all the links on a https://www.google.com/bookmarks on a page
/// as a set of markdown ready for pasting.
/// 


// 
// GB adds additional data to the URL, like redirects and analytics.  
// We don't want these present, so strip them off
// 
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
} // tidyTargetLink


// 
// The comment field on the page includes tag information (e.g. "[tag1,tag2,tag3]") which is of no
// use to our readers.
// 
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

		// GB also adds a trailing "]"
		if (info.substring(info.length - 1) == "]") {
			info = info.substring(0, info.length - 1);
		}
	} else {
		// GB will just include the tags, which we aren't interested in
		info = "";
	}

	return info;
} // extractBookmarkComment


// 
// If the given text has a "|" in it, markdown will see this as a table cell declaration
// ... so escape that out
// 
function escapeMarkdownString(md) {
	if (!md || md === "") {
		return "";
	}

	return md.replace("|", "&#124;");

} // escapeMarkdownString



// 
// We publish the elevenses articles in markdown format.  To make our lives easier we build up
// all the links into markdown format so we just paste that into our article ready for breaking into 
// appropriate sections.
// 
function markdownify(hits) {
	var markdown = "";

	for (var hit of hits) {
		var text = escapeMarkdownString(hit.text);
		var href = escapeMarkdownString(hit.href);
		var info = escapeMarkdownString(hit.info);

		// copy all links into markdown format
		markdown += `* [${text}](${href})`;
		// add notes if there are any
		if (info && info !== "") {
			markdown += `* - ${info}*`;
		}
		markdown += "\n";
	}

	return markdown;

} // markdownify



// 
// Main routine to grab the links and rearrange them so they're usable for our articles.
// 
function main() {
	var search = document.getElementById("search");
	var hits = [];

	// Find all hyperlinks to start with
	var links = search.querySelectorAll("a");

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

			// remove addition stuff GB adds (e.g. they use a redirect)
			hit.href = tidyTargetLink(hit.href);

			// we may have addition notes to the link we want including
			var infoId = id.replace("_href_", "_info_");
			var infoEles = link.parentElement.parentElement.parentElement.querySelectorAll("td span#" + infoId);
			if (infoEles && infoEles.length > 0) {
				hit.info = extractBookmarkComment(infoEles[0]);
			}

			hits.push(hit);
		} // if bookmark link

	} // foreach (link)

	return hits;
} // main



var hits = main();
var markdown = markdownify(hits);

// output results
console.clear()
copy(markdown);
console.info(markdown);
console.warn(hits, `\n${hits.length} markdown links have been copied to the clipboard.`);
console.info("Once you're done, remember to scroll to the bottom");
console.info("'Manage Labels' to delete the '11' label so we're ready for next time!");
