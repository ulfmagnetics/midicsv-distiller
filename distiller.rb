require 'bundler'
require 'csv'

class Distiller
  def self.usage
    puts "Usage: #{$0} <midi csv> <output csv>"
  end

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

if ARGV.size != 2
  Distiller.usage
  exit
end

midi_csv = File.read(ARGV[0])
CSV.open(ARGV[1], "wb") do |csv|
  options = {}
  options.merge!(root_note: ENV['ROOT_NOTE'].to_i) if ENV['ROOT_NOTE']
  options.merge!(ticks_per_unit: ENV['TICKS_PER_UNIT'].to_i) if ENV['TICKS_PER_UNIT']
  Distiller.new(midi_csv).rows(options).map do |row| 
    csv << row
  end
end