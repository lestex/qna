require_relative '../features_helper'

feature 'Subscribe to question' do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  scenario 'Authenticated user subscribes to the question', js: true do
    log_in_user(user)
    visit question_path(question)
    click_on 'Subscribe'

    expect(page).to have_content 'You subscribed to this question!'
  end

  scenario 'Non-authenticated user cannot subscribe to the question', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
  end

  scenario 'Authenticated user unsubscribes from the question', js: true do
    log_in_user(user)
    visit question_path(question)
    click_on 'Subscribe'
    expect(page).to_not have_link 'Subscribe'

    click_on 'Unsubscribe'
    expect(page).to have_content 'You removed your subscription from this question!'
  end

  context 'author condition' do
    let(:subscription) { create(:subscription, question: question, user_id: question.user_id) }
    scenario 'Author of the question unsubscribes from the question', js: true do
      question.subscriptions << subscription
      log_in_user(question.user)
      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_content 'You removed your subscription from this question!'
    end
  end

  scenario 'Authenticated user receives an email when a new answer is created', js: true do
    log_in_user(user)
    visit question_path(question)
    click_on 'Subscribe'
    fill_in 'answer_body', with: 'Answer Body'
    click_on 'Answer a question'
    expect(page).to have_content 'Your answer created successfully.'

    open_email(user.email)
    expect(current_email.subject).to eq 'You have a new answer'
  end
end