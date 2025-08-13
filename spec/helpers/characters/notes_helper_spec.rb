require 'rails_helper'

RSpec.describe Characters::NotesHelper, type: :helper do
  describe 'helper' do
    it 'is included in the helper' do
      expect(helper.class.included_modules).to include(Characters::NotesHelper)
    end
  end
end
