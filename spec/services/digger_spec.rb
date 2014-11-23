describe Digger do
  before(:each) do
    @moikrug_search = double()
    @moikrug_search_class = double(new: @moikrug_search)

    allow(@moikrug_search).to receive(:call).and_yield({ name: "Foo",
                                                         link: "http://foo.moikrug.ru/" })
    allow_any_instance_of(Digger).to receive(:moikrug_search).and_return(@moikrug_search_class)
    allow_any_instance_of(Digger).to receive(:moikrug_query).and_return('kuuuu')
  end

  it "returns correct result" do
    digger = Digger.new nil, foo: :bar

    digger.call do |result|
      expect(result.class).to eq Digger::Loot
      expect(result.name).to eq "Foo"
      expect(result.moikrug_link).to eq "http://foo.moikrug.ru/"
      expect(result.facebook_link).to be_nil
    end
  end

  it "passes options to Moikrug::Search" do
    digger = Digger.new nil, max_pages: 1, start: 1
    expect(@moikrug_search_class).to receive(:new).with("kuuuu", max_pages: 1, start: 1)
    digger.call {}
  end
end
