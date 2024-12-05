# frozen_string_literal: true

require 'csv'
require 'bigdecimal'
require 'bigdecimal/util'

# SampleProcessor — это класс, предназначенный для обработки CSV-файла с данными об образцах.
# Он читает данные, выполняет вычисления для оксидирования и нитрования, и записывает результаты в новый CSV-файл.
class SampleProcessor
  DEFAULT_HEADERS_WITH_COLUMN_INDEX = {
    'Sample Number' => 1,
    'Oxidation' => 3,
    'Nitration' => 4
  }.freeze

  def initialize(input_file)
    @input_file = input_file
    @output_file = File.join(File.dirname(input_file), "result_#{File.basename(input_file)}")
  end

  def call
    puts "Parsing #{@input_file} into #{@output_file} started"
    CSV.open(@output_file, 'w') do |csv|
      csv << DEFAULT_HEADERS_WITH_COLUMN_INDEX.keys
      write_rows(csv)
    end

    puts "Parsing #{@input_file} into #{@output_file} complete."
  end

  private

  def parsed_row(row)
    sample_number = row[DEFAULT_HEADERS_WITH_COLUMN_INDEX['Sample Number']]
    oxidation = (row[DEFAULT_HEADERS_WITH_COLUMN_INDEX['Oxidation']].to_d * 100).round
    nitration = (row[DEFAULT_HEADERS_WITH_COLUMN_INDEX['Nitration']].to_d * 100).round
    [sample_number, oxidation, nitration]
  end

  def write_rows(csv)
    header_found = false
    CSV.foreach(@input_file, headers: false, col_sep: ',') do |row|
      if header_found
        next if row[DEFAULT_HEADERS_WITH_COLUMN_INDEX['Sample Number']].nil?

        csv << parsed_row(row)
      elsif row.include?('Samples')
        header_found = true
      end
    end
  end
end
