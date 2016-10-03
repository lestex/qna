ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question-form').show()

vote_for_question = ->
  $('.voting-question').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    if(vote.rating != '+0')
        $('.vote-rating-question').html('<p>' + vote.rating + '<p>')
    else
        $('.vote-rating-question').html('')
    $('.voting-choice-question').hide()
    $('.voting-reject-question').show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-question').html(value)

votes_cancel_for_question = ->
  $('.voting-reject-question').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    if(vote.rating != '+0')
        $('.vote-rating-question').html('<p>' + vote.rating + '<p>')
    else
        $('.vote-rating-question').html('')
    $('.voting-choice-question').css('display', 'inline-block')
    $('.voting-reject-question').hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-question').html(value)


$(document).ready(ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', vote_for_question)
$(document).on('turbolinks:load', votes_cancel_for_question)

PrivatePub.subscribe "/questions", (data, channel) ->
  question = $.parseJSON(data['question']);  
  $('.questions').append('<p><a href="/questions/' + question.id + '">' + question.title + '</a></p>');