$(document).ready(function(){
	$("#source-connector select").change(function() {
		var connectorId = $(this).val(); 
		var connector = $(this).closest(".connector").attr('id'); 
		var data = { connector: connector, 
					 connectorId: connectorId, 
					 elementToUpdate: $(this).parent(), 
					 path: "/"
				}; 
		displayConnectorContents(data, displayRoot);
	}); 

	rootfolder = $('[role="root-folder"]'); 
		
})

function displayConnectorContents(data, passedFunction) {
	$.ajax({
		type: 'get', 
		url: 'http://' + location.host + '/connectors/list', 
		data: {
			id: data.connectorId, 
			path: data.path
		}, 
		success: function(result) {
			passedFunction(data, result)
		}
	})
}

function makeFoldersClickable(groupOfElements) {
	groupOfElements.find('[data-item-type="directory"]').dblclick(function(){
		event.stopPropagation();
		var connector = $(this).closest(".connector"); 
		var connectorId = connector.find("select").first().val(); 
		var data = { connector: connector, 
					 connectorId: connectorId, 
					 elementToUpdate: $(this).parents('li').first(), 
					 path: $(this).attr("data-path-to-item")
				};
		displayConnectorContents(data, displayFolderContents);
	});
}

function displayRoot(data, result) {
	var listHtmlObject = buildListHtml(data, result); 
	$('[role="root-folder"]').children('span#root-contents').html(listHtmlObject);
	data.elementToUpdate.addClass("expanded"); 
	data.elementToUpdate.removeClass("collapsed"); 
	makeFoldersClickable(listHtmlObject);
}

function displayFolderContents(data, result) {
	var listHtmlObject = buildListHtml(data, result); 
	data.elementToUpdate.append(listHtmlObject);
	data.elementToUpdate.addClass("expanded"); 
	data.elementToUpdate.removeClass("collapsed"); 
	makeFoldersClickable(listHtmlObject);
}

function buildListHtml(data, result) {
	var responseContainer = $('<ul></ul>'); 
	$.each(result, function(index, item) {
		if (item['item_name'] != '.' && item['item_name'] != '..') { 
			listElement = $("<li></li>", {
				'class': 'collapsed'
			}).appendTo(responseContainer); 
			clickableAnchor = $("<a></a>", {
				href: '#', 
				'class': 'selectable', 
				name: 'item-name',
				data: item['item_name'], 
				'data-path-to-item': item['path_to_item'], 
				value: item['item_name'],
				text: item['item_name'], 
				"data-item-type": item['item_type']
			}).appendTo(listElement); 
		}
	});
	return responseContainer; 
}