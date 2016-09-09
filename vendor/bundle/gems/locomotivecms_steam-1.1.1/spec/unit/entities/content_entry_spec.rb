require 'spec_helper'

describe Locomotive::Steam::ContentEntry do

  let(:fields)      { nil }
  let(:repository)  { instance_double('FieldRepository', all: fields) }
  let(:type)        { instance_double('ContentType', slug: 'articles', label_field_name: :title, fields: repository) }
  let(:attributes)  { { title: 'Hello world', _slug: 'hello-world' } }
  let(:content_entry) { described_class.new(attributes) }

  before { content_entry.content_type = type }

  describe '#valid?' do

    let(:fields) { [instance_double('Field', name: :title, type: :string, required: true)] }

    before do
      allow(repository).to receive(:required).and_return(fields)
      allow(type).to receive(:fields_by_name).and_return({ title: fields.first })
    end

    subject { content_entry.valid? }
    it { is_expected.to eq true }

    context 'missing attribute' do

      let(:attributes) { {} }
      it { is_expected.to eq false }
      it { subject; expect(content_entry.errors[:title]).to eq(["can't be blank"]) }
      it { subject; expect(content_entry.errors.empty?).to eq false }

    end

    describe 'adding a custom error message' do

      before { content_entry.errors.add(:title, 'is mandatory') }

      it { expect(content_entry.errors[:title]).to eq(['is mandatory']) }

    end

  end

  describe '#_label' do

    subject { content_entry._label }
    it { is_expected.to eq 'Hello world' }

  end

  describe '#content_type_slug' do

    subject { content_entry.content_type_slug }
    it { is_expected.to eq 'articles' }

  end

  describe '#to_hash' do

    let(:fields)      { [instance_double('TitleField', name: :title, type: :string), instance_double('PictureField', name: :picture, type: :file, localized: true)] }
    let(:attributes)  { { id: 42, title: 'Hello world', _slug: 'hello-world', picture: Locomotive::Steam::Models::I18nField.new(:picture, fr: 'foo.png', en: 'bar.png'), custom_fields_recipe: ['hello', 'world'], _type: 'Entry' } }

    subject { content_entry.to_hash }

    before do
      allow(type).to receive(:fields_by_name).and_return({ title: fields.first, picture: fields.last })
      allow(type).to receive(:persisted_field_names).and_return([:title, :picture])
      allow(content_entry).to receive(:base_url).and_return('/assets')
    end

    it { expect(Set.new(subject.keys)).to eq(Set.new(['_id', '_position', '_visible', '_label', '_slug', 'content_type_slug', 'title', 'picture', 'created_at', 'updated_at'])) }

    context 'when decorated' do

      let(:decorated) { Locomotive::Steam::Decorators::I18nDecorator.new(content_entry, :fr, :en) }

      before { allow(content_entry).to receive(:localized_attributes).and_return({ picture: true }) }

      subject { decorated.to_hash }

      it { expect(subject['picture'].url).to eq '/assets/foo.png' }

    end

  end

  describe 'dynamic attributes' do

    let(:field_type)  { :string }
    let(:attributes)  { { my_field: value } }
    let(:field)       { instance_double('Field', name: :my_field, type: field_type) }

    before { allow(type).to receive(:fields_by_name).and_return(my_field: field) }

    subject { content_entry.my_field }

    describe 'unable to cast it' do

      let(:field_type)  { :float }
      let(:value)       { [] }
      it { is_expected.to eq nil }

    end

    context 'no provided value, should return nil' do

      let(:attributes)  { {} }
      it { is_expected.to eq nil }

    end

    context 'a string' do
      let(:value) { 'Hello world' }
      it { is_expected.to eq 'Hello world' }
      context 'localized' do
        let(:value) { build_i18n_field(en: 'Hello world', fr: 'Bonjour monde') }
        it { expect(subject.translations).to eq('en' => 'Hello world', 'fr' => 'Bonjour monde') }
      end
    end

    context 'an integer' do
      let(:field_type)  { :integer }
      let(:value)       { '42' }
      it { is_expected.to eq 42 }
      context 'localized' do
        let(:value) { build_i18n_field(en: 42, fr: '42') }
        it { expect(subject.translations).to eq('en' => 42, 'fr' => 42) }
      end
    end

    context 'a float' do
      let(:field_type)  { :float }
      let(:value)       { '42.0' }
      it { is_expected.to eq 42.0 }
      context 'localized' do
        let(:value) { build_i18n_field(en: 42.0, fr: '42.0') }
        it { expect(subject.translations).to eq('en' => 42.0, 'fr' => 42.0) }
      end
    end

    context 'a date' do
      let(:field_type)  { :date }
      let(:value)       { '2007/06/29' }
      let(:date)        { Date.parse('2007/06/29') }
      it { is_expected.to eq date }
      context 'localized' do
        let(:value) { build_i18n_field(en: '2007/06/29', fr: date) }
        it { expect(subject.translations).to eq('en' => date, 'fr' => date) }
        context 'with a single value for all the translations' do
          let(:value) { build_i18n_field('2007/06/29') }
          it { expect(subject[:fr]).to eq(date) }
          it { expect(subject[:en]).to eq(date) }
        end
      end
    end

    context 'a date time' do
      before { Time.zone = 'UTC' }
      let(:field_type)  { :date_time }
      let(:value)       { '2007/06/29 10:00:00' }
      let(:datetime)    { DateTime.parse('2007/06/29 10:00:00') }
      it { is_expected.to eq datetime }
      context 'localized' do
        let(:value) { build_i18n_field(en: '2007/06/29 10:00:00', fr: datetime) }
        it { expect(subject.translations).to eq('en' => datetime, 'fr' => datetime) }
      end
    end

    context 'a file' do
      let(:field_type)  { :file }
      let(:value)       { '/foo.png' }
      let(:attributes)  { { my_field: value, my_field_size: { 'default' => 42 } } }
      it { expect(subject.url).to eq('/foo.png') }
      it { expect(subject.size).to eq(42) }
      context 'localized' do
        let(:value) { build_i18n_field(en: '/foo-en.png', fr: '/foo-fr.png') }
        let(:attributes)  { { my_field: value, my_field_size: { 'en' => 42, 'fr' => 7 } } }
        it { expect(subject.translations[:en].url).to eq('/foo-en.png') }
        it { expect(subject.translations[:en].size).to eq(42) }
        it { expect(subject.translations[:fr].url).to eq('/foo-fr.png') }
        it { expect(subject.translations[:fr].size).to eq(7) }
      end
      context 'no file size provided' do
        let(:attributes)  { { my_field: value } }
        it { expect(subject.size).to eq(nil) }
      end
    end

    context 'a select' do
      let(:option)      { instance_double('SelectOption', name: { en: 'Category #1', fr: 'Categorie #1' }) }
      let(:field)       { instance_double('Field', name: :my_field, type: :select, select_options: instance_double('SelectOptions')) }
      let(:attributes)  { { my_field_id: 42 } }
      before { expect(field.select_options).to receive(:find).with(42).and_return(option) }
      it { is_expected.to eq({ en: 'Category #1', fr: 'Categorie #1' }) }
    end

  end

  def build_i18n_field(translations = {})
    Locomotive::Steam::Models::I18nField.new(:my_field, translations)
  end

end
