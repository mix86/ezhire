describe Goo do

  before(:each) do
    @google = Goo.new :someid, max_pages: 5
    allow(@google).to receive(:connect)
    allow(@google).to receive(:fetch_page).and_return(google_result)
  end

  it do
    result = @google.search 'ololo'
    expect(result.size).to eq 10
    expect(result.first).to eq({ title: 'title', link: 'link'})
  end

  private

  def google_result
    item = double(title: 'title', link: 'link')

    data = double(items: [item, item],
                  queries: double(nextPage: [double(startIndex: 11)]))

    double(data: data)
  end
end
