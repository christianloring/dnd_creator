require 'rails_helper'

RSpec.describe CharactersHelper, type: :helper do
  describe 'helper' do
    it 'is included in the helper' do
      expect(helper.class.included_modules).to include(CharactersHelper)
    end
  end
end
