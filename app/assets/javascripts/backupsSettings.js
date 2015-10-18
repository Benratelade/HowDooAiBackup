function displayConnectorContents(connectorId) {
	$.ajax({
		type: 'get', 
		url: 'http://' + location.host + '/connectors/list', 
		data: {
			id: connectorId
		}, 
		success: function(result){
			responseHtml = ''; 
			$.each(result, function(index, item) {
				responseHtml += '<tr data="' + item + '"><td>' + item + "</td></tr>" ; 
			}) 
			$("#connector-contents tbody").html(responseHtml); 
		}
	})
}

$(document).ready(function(){
		$("#source-connector select").change(function() {
		connectorId = $(this).val(); 
		displayConnectorContents(connectorId);
	}); 
})