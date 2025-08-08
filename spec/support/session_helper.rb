module SessionHelper
  def session_sign_in
    user = FactoryBot.create(:user)
    session = FactoryBot.create(:session, user: user)
    allow(Current).to receive(:session).and_return(session)
    session
  end
end

RSpec.configure do |config|
  config.include SessionHelper
end
