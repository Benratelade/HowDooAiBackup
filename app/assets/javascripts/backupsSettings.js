function displayConnectorContents(data) {
	$.ajax({
		type: 'get', 
		url: 'http://' + location.host + '/connectors/list', 
		data: {
			id: data.connectorId, 
			path: data.path
		}, 
		success: function(result){
			responseHtml = '<ul>'; 
			$.each(result, function(index, item) {
				responseHtml += '<li data-item-type="' + item['item_type'] + '" data="' + item['item_name'] + '" data-path-to-item="' + item['path_to_item'] + '"><input type="radio" name="gender" value="' + item['item_name'] + '">' + item['item_name'] + '</li>' ; 
			});
			responseHtml += '</ul>'
			var objectifiedHtmlString = $(responseHtml); 
			if (data.elementToUpdate.attr('class') == "connector") {
				$("#connector-contents ul").append(objectifiedHtmlString);
			} else {
				console.log("this is inside the else"); 
				console.log(data.elementToUpdate); 
				data.elementToUpdate.append(objectifiedHtmlString);
			}
			console.log("pong");
			console.log(objectifiedHtmlString);
			makeFoldersClickable(objectifiedHtmlString);
		}
	})
}

function makeFoldersClickable(groupOfElements) {
	groupOfElements.find('li[data-item-type="directory"]').dblclick(function(){
		event.stopPropagation();
		var connector = $(this).closest(".connector"); 
		var connectorId = connector.find("select").first().val(); 
		var data = { connector: connector, 
					 connectorId: connectorId, 
					 elementToUpdate: $(this), 
					 path: $(this).attr("data-path-to-item")
				};
		displayConnectorContents(data);
	});
}

$(document).ready(function(){
		$("#source-connector select").change(function() {
			var connectorId = $(this).val(); 
			var connector = $(this).closest(".connector").attr('id'); 
			var data = { connector: connector, 
						 connectorId: connectorId, 
						 elementToUpdate: $(this).parent(), 
						 path: "/"
					}; 
			displayConnectorContents(data);
		}); 
		
})