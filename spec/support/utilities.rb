include ApplicationHelper

# Specファイル中で呼び出された場合に行われる
# example -- before { valied_signin(user)}
def valid_signin user
  fill_in "Email",  with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def insert_user
  fill_in "Name", with: "Example User"
  fill_in "Email",  with: "user@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation",  with: "foobar"
end

def sign_in user,options={}
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token,User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",  with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert,alert-error',text:message)
  end
end
