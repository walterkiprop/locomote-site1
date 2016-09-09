require 'spec_helper'

describe Locomotive::Steam::Liquid::Tags::Editable::File do

  let(:page)        { instance_double('Page', fullpath: 'hello-world', updated_at: DateTime.parse('2007-06-29 21:00:00')) }
  let!(:listener)   { Liquid::SimpleEventsListener.new }
  let(:options)     { { page: page } }

  let(:source) { "{% editable_file banner, hint: 'some text' %}http://www.placehold.it/500x500{% endeditable_file %}" }

  describe 'parsing' do

    subject { parse_template(source, options) }

    context 'valid syntax' do

      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

    end

    context 'without a slug' do

      let(:source) { "{% editable_file %}{% endeditable_file %}" }

      it 'requires a slug' do
        expect { subject }.to raise_error(::Liquid::SyntaxError, "Liquid syntax error: Valid syntax: editable_file <slug>(, <options>)")
      end

    end

    context 'with a tag or block inside' do

      let(:source) { "{% editable_file banner %}{{ test }}{% endeditable_file %}" }

      it 'does not allow it' do
        expect { subject }.to raise_error(::Liquid::SyntaxError, "Liquid syntax error: No liquid tags are allowed inside the editable_file \"banner\" (block: default)")
      end

    end

    describe 'events' do

      before  { parse_template(source, options) }

      subject { listener.events.first.first }

      it 'records the name of the event' do
        is_expected.to eq 'steam.parse.editable.editable_file'
      end

      describe 'attributes' do

        subject { listener.events.first.last[:attributes] }

        it { is_expected.to include(block: nil) }
        it { is_expected.to include(type: :editable_file) }
        it { is_expected.to include(slug: 'banner') }
        it { is_expected.to include(hint: 'some text') }
        it { is_expected.to include(default_source_url: 'http://www.placehold.it/500x500') }

      end

    end

  end

  describe 'rendering' do

    let(:live_editing) { false }

    let(:page)        { instance_double('Page', fullpath: 'hello-world', updated_at: DateTime.parse('2007-06-29 21:00:00')) }
    let(:element)     { instance_double('EditableFile', id: 42, default_source_url: nil, source?: false, source: nil, content: nil, base_url: '') }
    let(:services)    { Locomotive::Steam::Services.build_instance }
    let(:context)     { ::Liquid::Context.new({}, {}, { page: page, services: services, live_editing: live_editing }) }

    before { allow(services).to receive(:current_site).and_return(nil) }

    before { allow(services.editable_element).to receive(:find).and_return(element) }

    subject { render_template(source, context, options) }

    it { is_expected.to eq 'http://www.placehold.it/500x500' }

    context 'live editing' do

      let(:live_editing) { true }

      it { is_expected.to eq 'http://www.placehold.it/500x500?editable-path=banner' }

      context 'inside a block' do

        let(:source) { "{% block head %}{% editable_file banner, hint: 'some text' %}http://www.placehold.it/500x500?123456{% endeditable_file %}{% endblock %}" }

        it { is_expected.to include('http://www.placehold.it/500x500?123456&editable-path=head--banner') }

      end

    end

    context 'no element found, render the default content' do

      let(:element) { nil }
      it { is_expected.to eq 'http://www.placehold.it/500x500' }

    end

    context 'using the default value' do

      let(:element) { instance_double('EditableFile', id: 42, default_source_url: 'http://www.placehold.it/500x500', source?: false, source: nil, content: nil) }
      it { is_expected.to eq 'http://www.placehold.it/500x500?1183150800' }

    end

    context 'modified value' do

      let(:file)    { 'http://www.placehold.it/250x250' }
      let(:element) { instance_double('EditableFile', source: file, default_source_url: false, base_url: '') }
      it { is_expected.to eq 'http://www.placehold.it/250x250?1183150800' }

    end

    context 'inside blocks' do

      let(:source) { '{% block wrapper %}{% block sidebar %}{% editable_file banner %}http://www.placehold.it/250x250{% endeditable_file %}{% endblock %}{% endblock %}' }

      before { expect(services.editable_element).to receive(:find).with(page, 'wrapper/sidebar', 'banner').and_return(element) }
      it { is_expected.to eq 'http://www.placehold.it/250x250' }

    end

    context 'resize image' do

      let(:source) { "{% block header %}{% editable_file banner, hint: 'some text', resize: '500x100#' %}http://www.placehold.it/500x500{% endeditable_file %}{% endblock %}" }
      it { is_expected.to eq '/steam/dynamic/W1siZnUiLCJodHRwOi8vd3d3LnBsYWNlaG9sZC5pdC81MDB4NTAwIl0sWyJwIiwidGh1bWIiLCI1MDB4MTAwIyJdXQ/1c79f4581f33aae4/500x500' }

      context 'live editing on' do

        let(:live_editing) { true }

        it { is_expected.to eq '<span class="locomotive-block-anchor" data-element-id="header" style="visibility: hidden"></span>/steam/dynamic/W1siZnUiLCJodHRwOi8vd3d3LnBsYWNlaG9sZC5pdC81MDB4NTAwIl0sWyJwIiwidGh1bWIiLCI1MDB4MTAwIyJdXQ/1c79f4581f33aae4/500x500?editable-path=header--banner' }

      end

    end

    context 'no default file and inside a capture block' do
      let(:source)  { "{% capture url %}{% editable_file banner, hint: 'some text' %}{% endeditable_file %}{% endcapture %}->{{ url }}" }
      let(:element) { instance_double('EditableFile', id: 42, default_source_url: nil, source?: true, source: '/foo/bar', content: nil, base_url: '') }
      it { is_expected.to eq '->/foo/bar?1183150800' }
    end

  end

end
