ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
  $('.comment-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#comment-answer-form').show()

vote_for_answer = ->
  $('.vote-answer').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    if(vote.rating != '+0')
        $('.vote-rating-answer-' + vote.id).html('<p>' + vote.rating + '<p>')
    else
        $('.vote-rating-answer-' + vote.id).html('')
    $('.voting-choice-answer-' + vote.id).hide()
    $('.voting-reject-answer-' + vote.id).show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-answer-' + vote.id).html(value)

vote_cancel_for_answer = ->
  $('.vote-cancel-answer').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    if(vote.rating != '+0')
        $('.vote-rating-answer-' + vote.id).html('<p>' + vote.rating + '<p>')
    else
        $('.vote-rating-answer-' + vote.id).html('')
    $('.voting-choice-answer-' + vote.id).css('display', 'inline-block')
    $('.voting-reject-answer-' + vote.id).hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-answer-' + vote.id).html(value)

comment_answer = ->
  $('form#comment-answer-form').bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    $.each errors.body, (index, value) ->
      $('.comment-message').html('Body ' + value)

$(document).ready(ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', vote_for_answer)
$(document).on('turbolinks:load', vote_cancel_for_answer)