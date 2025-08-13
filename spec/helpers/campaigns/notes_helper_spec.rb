require 'rails_helper'

RSpec.describe Campaigns::NotesHelper, type: :helper do
  describe 'helper' do
    it 'is included in the helper' do
      expect(helper.class.included_modules).to include(Campaigns::NotesHelper)
    end
  end
end
