describe Goo do

  before(:each) do
    @google = Goo.new :someid
    allow(@google).to receive(:call_google).and_return(google_result)
  end

  it do
    result = @google.search 'ololo'
    expect(result.size).to eq 2
    expect(result.first).to eq({ title: 'title', link: 'link'})
  end

  private

  def google_result
    item = double(title: 'title', link: 'link')
    data = double(items: [item, item])
    double(data: data)
  end
end
