describe Moikrug::QueryBuilder do
  let(:options) do
    { city: "москва",
      specializations: ["ловить бабочек"],
      period: 2,
      contender: true }
  end

  it do
    builder = Moikrug::QueryBuilder.new(options)
    example = 'москва "ищу работу" ("ноября 2014" OR "октября 2014") "о себе" (ловить бабочек)'

    expect(builder.call).to eq(example)
  end

  it do
    builder = Moikrug::QueryBuilder.new(options.merge specializations: ["ловить", "бабочек"])
    example = 'москва "ищу работу" ("ноября 2014" OR "октября 2014") "о себе" (ловить OR бабочек)'

    expect(builder.call).to eq(example)
  end

  it do
    builder = Moikrug::QueryBuilder.new(options.merge period: 1)
    example = 'москва "ищу работу" ("ноября 2014") "о себе" (ловить бабочек)'

    expect(builder.call).to eq(example)
  end

  it do
    builder = Moikrug::QueryBuilder.new(options.merge contender: false)
    example = 'москва "о себе" (ловить бабочек)'

    expect(builder.call).to eq(example)
  end
end
