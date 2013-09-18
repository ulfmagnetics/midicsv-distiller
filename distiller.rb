require 'bundler'
require 'csv'

class Distiller
  def initialize(csv)
    @raw_rows = CSV.parse(csv)
  end

  def rows(options = {})
    root_note = options[:root_note] || 0
    ticks_per_unit = options[:ticks_per_unit] || 1

    @raw_rows.select { |row| row[2] =~ /note_on/i }.map do |row|
      [
        ticks_to_units(row[1].to_i, ticks_per_unit), 
        note_number_with_offset(row[4].to_i, root_note)
      ]
    end
  end

  private

  def ticks_to_units(ticks, scaling_factor)
    (ticks / scaling_factor).to_i
  end

  def note_number_with_offset(num, offset)
    num - offset
  end
end