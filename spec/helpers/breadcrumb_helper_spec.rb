require 'rails_helper'

RSpec.describe BreadcrumbHelper, type: :helper do
  describe '#add_breadcrumb' do
    it 'adds breadcrumbs to the array' do
      helper.add_breadcrumb "Home", root_path
      helper.add_breadcrumb "Characters", characters_path

      expect(helper.breadcrumbs.length).to eq(2)
      expect(helper.breadcrumbs.first[:title]).to eq("Home")
      expect(helper.breadcrumbs.first[:path]).to eq(root_path)
      expect(helper.breadcrumbs.last[:title]).to eq("Characters")
      expect(helper.breadcrumbs.last[:path]).to eq(characters_path)
    end

    it 'marks breadcrumb as active when specified' do
      helper.add_breadcrumb "Current Page", nil, active: true

      expect(helper.breadcrumbs.first[:active]).to be true
    end
  end

  describe '#render_breadcrumbs' do
    it 'returns empty string when no breadcrumbs' do
      expect(helper.render_breadcrumbs).to be_nil
    end

    it 'renders breadcrumbs with proper HTML structure' do
      helper.add_breadcrumb "Home", root_path
      helper.add_breadcrumb "Characters", characters_path
      helper.add_breadcrumb "Current", nil, active: true

      result = helper.render_breadcrumbs

      expect(result).to include('nav')
      expect(result).to include('Home')
      expect(result).to include('Characters')
      expect(result).to include('Current')
      expect(result).to include('href')
    end
  end
end
