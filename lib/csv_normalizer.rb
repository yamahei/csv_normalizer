require "csv_normalizer/version"
require "csv_normalizer/table"

module CsvNormalizer

  def self.load_to_table filepath, option={}
    _t = CsvNormalizer::Table.new(option)
    _t.load(filepath)
    return _t
  end

end
