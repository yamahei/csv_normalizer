require 'csv'
module CsvNormalizer
class Table

    def initialize option={}
        #option
        @hashead = option[:hashead] || true
        @excludes = option[:excludes] || []
        _encoding = option[:encoding] || Encoding.default_external
        #init
        Encoding.default_external = _encoding
        @table = nil
    end

    def method_missing(method, *args)
        @table.send(method, *args)
    end

    def load filename, allow_header_diff=true #appendable
        option = { headers:@hashead }
        if @table.nil? then
            @table = CSV.table(filename, option)
        else
            _table = CSV.table(filename, option)
            if !allow_header_diff && @table.headers.sort != _table.headers.sort then
                p @table.headers
                p _table.headers                
                raise StandardError.new("header not match.")
            else
                _table.by_row.each{|row|
                    _row, diff = [], (_table.headers - @table.headers)
                    @table.headers.each{|header| _row << row[header] }
                    diff.each{|header| _row << row[header] }
                    @table << row
                }
            end
        end
    end

    def save filepath, write_head=true
        File.open(filepath, 'w') do |file|
            file.write(_generate(write_head))
        end
    end
    def new_col colname
        @table.by_col[colname] = @table.by_row.map{|row| yield row }
    end
    def delete_row#remove if yield=true
        @table = @table.by_row.delete_if{|row| yield(row) }
    end
    def each_row
        @table = @table.by_row.each{|row| yield(row) }
    end

    private

    def _generate write_head=true
        _table = @table.by_col
        _head = _table.headers - @excludes
        return CSV.generate {|csv|
            csv << _head if write_head
            _table.by_row.each{|row|
                _row = row.fields(*_head)
                csv << _row
            }
        }
    end

end#class
end#module