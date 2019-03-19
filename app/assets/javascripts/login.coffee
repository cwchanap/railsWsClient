# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ -> 
    $('#login').on('ajax:success', (event) -> 
        [data, status, xhr] = event.detail
        if data.error == true
            $('#loginMsg').html(data.message).addClass('alert alert-danger')
    ).on('ajax:error', (event) ->
        console.log("Error in request")
        [data, status, xhr] = event.detail
        $('#loginMsg').html(data).addClass('alert alert-danger')
    )
