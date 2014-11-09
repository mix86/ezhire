describe Template::Renderer do
  let(:template) { Template.new body: body }
  let(:person) { double(name: 'ololo') }
  let(:project) { double(name: 'cool project', note: 'very long description')}

  let(:subject) { Template::Renderer.new template, person: person, project: project }

  context '#call' do
    it 'has call method' do
      expect(subject.respond_to? :call).to eq true
    end

    it 'returns rendered body' do
      expect(subject.call.class).to eq String
    end

    it 'substitutes vars' do
      rendered = subject.call
      expect(rendered).to include 'ololo'
      expect(rendered).to include 'cool project'
      expect(rendered).to include 'very long description'
    end
  end

  private

  def body
    <<-BODY
    Hallo %person_name%!
    %vacancy_name%
    %vacancy_note%
    BODY
  end
end
