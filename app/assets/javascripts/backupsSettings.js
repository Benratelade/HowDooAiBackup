function displayConnectorContents(connector_id) {
	$.ajax({
		type: 'get', 
		url: 'http://' + location.host + '/connectors/list', 
		data: {
			id: connector_id
		}, 
		success: function(result){
			responseHtml = "<table>"; 
			$.each(result, function(index, item) {
				responseHtml += "<tr><td>" + item + "</td><td><a>Backup now</a></td></tr>" ; 
			})
			responseHtml += "</table>"; 
			$("#connector-contents").html(responseHtml); 
		}
	})
}