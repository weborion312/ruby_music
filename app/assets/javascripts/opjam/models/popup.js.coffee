class Opjam.Models.Popup extends Backbone.Model

  fetch: (url)=>
    $.ajax(
      url: url
      dataType: "html"
      success: (response)=>
        @setResponse(response)
    )

  submitForm: (form)=>

    if form.enctype == "multipart/form-data"
      # just submit the damn form
      form.submit()
    else
      $.ajax(
        url: form.action
        type: "POST"
        data: $(form).serialize()
        complete: (jqxhr, status) ->
          if _.include(@.dataTypes, "json")
            window.location = "/"
          else
            Opjam.popup.setResponse(jqxhr.responseText)
          location = jqxhr.getResponseHeader("X-Location")
          if location != null && location != undefined
            Opjam.router.navigate("!/" + location.substr(1), false)
      )

  setResponse: (response) =>
    @html = response
    @trigger "change"
