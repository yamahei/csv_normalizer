require "spec_helper"

RSpec.describe CsvNormalizer do

  CSV_PATH = File.expand_path('../test.csv', __FILE__)
  CSV_OPTION = {
    :excludes => ['no'],
    :encoding => "UTF-8",
  }

  it "has a version number" do
    expect(CsvNormalizer::VERSION).not_to be nil
  end

  it "load from module method." do
    t = CsvNormalizer.load_to_table CSV_PATH
    expect(t.class).to eq(CsvNormalizer::Table)
  end

  it "load from class method." do
    t = CsvNormalizer::Table.new CSV_OPTION
    t.load CSV_PATH
    expect(t.class).to eq(CsvNormalizer::Table)
  end
  
end
