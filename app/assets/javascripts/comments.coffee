# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  PrivatePub.subscribe $('form#comment-question-form').attr('action'), (data, channel) ->
    comment = $.parseJSON(data['comment']);
    $('.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id).append('<p>' + comment.body + '<p>')
    $('#comment_body').val('')
    if comment.commentable_type == 'Question'
      $('.comment-question-link').show()
      $('form#comment-question-form').hide()
    else
      $('.comment-answer-link').show()
      $('form#comment-answer-form').hide()

$(document).ready(ready)