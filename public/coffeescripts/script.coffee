show_error = (error_message) -> $('#flash_error').html(error_message).show('slow') unless $.page_unloaded
hide_error = -> $('#flash_error').text('').hide 'slow'
show_notice = (notice, time=false) ->
  $('#flash_notice').text(notice).show 'slow'
  setTimeout hide_notice, time * 1000 unless time == false
hide_notice = -> $('#flash_notice').text('').hide 'slow'
set_timeout = (seconds, callback) -> setTimeout callback, seconds * 1000

String.prototype.capitalize = -> this.charAt(0).toUpperCase() + this.slice(1)

$(document).ready ->
  listen = (last_modified, etag) ->
    $.ajax
      'beforeSend': (xhr) ->
        xhr.setRequestHeader "If-None-Match", etag
        xhr.setRequestHeader "If-Modified-Since", last_modified
      url: '/ajax/updates',
      dataType: 'json',
      type: 'get',
      cache: 'false',
      success: (packet, textStatus, xhr) ->
        hide_error()
        etag = xhr.getResponseHeader('Etag')
        last_modified = xhr.getResponseHeader('Last-Modified')
        packet = new Array(packet) unless $.isArray(packet)
        for data in packet
          console.log "received data: type=#{data.type} id=#{data.id} updated_at=#{data.updated_at} status='#{data.status if data.status?}'"

          switch data.type
            when 'status'
              switch data.status
                when 'online'
                  hide_error()
                when 'offline'
                  show_error "The server has lost connectivity to #{data.target}."

        listen last_modified, etag
      error: (xhr, textStatus, errorThrown) ->
        console.log textStatus + ': ' + errorThrown
        show_error "Connection to server has been lost. Either you have an issue with your internet connectivity or the server is offline."
        set_timeout 10, -> listen last_modified, etag

  #set_timeout 0.5, -> listen 'Thu, 1 Jan 1970 00:00:00 GMT', '0'

  window.onbeforeunload = ->
    show_notice "Page has been unloaded. Refresh page to reload application."
    $.page_unloaded = true
    null