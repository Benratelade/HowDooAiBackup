function displayConnectorContents(data) {
	$.ajax({
		type: 'get', 
		url: 'http://' + location.host + '/connectors/list', 
		data: {
			id: data.connectorId
		}, 
		success: function(result){
			responseHtml = '<ul>'; 
			$.each(result, function(index, item) {
				responseHtml += '<li data-item-type="' + item['item_type'] + '" data="' + item['item_name'] + '"><input type="radio" name="gender" value="' + item['item_name'] + '">' + item['item_name'] + '</li>' ; 
			})
			responseHtml += '</ul>'
			if (data.parentElement.attr('class') == "connector") {
				$("#connector-contents ul").html(responseHtml);
			} else {
				data.parentElement.html(responseHtml);
			}
			makeFoldersClickable(); 
		}
	})
}


function makeFoldersClickable() {
	$('li[data-item-type="directory"]').dblclick(function(){
		$(this).css("background-color", "red"); 
		connector = $(this).closest(".connector"); 
		connectorId = connector.find("select").first().val(); 
		var data = { connector: connector, 
					 connectorId: connectorId, 
					 parentElement: $(this).parent()
				}; 
		displayConnectorContents(data);
	});
}

$(document).ready(function(){
		$("#source-connector select").change(function() {
			connectorId = $(this).val(); 
			connector = $(this).closest(".connector").attr('id'); 
			var data = { connector: connector, 
						 connectorId: connectorId, 
						 parentElement: $(this).parent()
					}; 
			displayConnectorContents(data);
		}); 
		
		makeFoldersClickable(); 
})