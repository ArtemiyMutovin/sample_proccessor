# frozen_string_literal: true

require 'rspec'
require 'csv'
require_relative '../sample_processor'

RSpec.describe SampleProcessor do
  let(:input_file) { 'spec/fixtures/input.csv' }
  let(:output_file) { 'spec/fixtures/result_input.csv' }
  let(:processor) { SampleProcessor.new(input_file) }

  before do
    # Создаем временный входной файл для тестов
    CSV.open(input_file, 'w') do |csv|
      csv << ['Warnings', 'Samples', 'Soot (A/.1mm)', 'Oxidation (A/.1mm)', 'Nitration (A/.1mm)']
      csv << %w[Info 12345 0.1 0.05 0.03]
      csv << %w[Info 67890 0.2 0.07 0.06]
    end
  end

  after do
    File.delete(output_file) if File.exist?(output_file)
  end

  describe '#call' do
    it 'creates a result file with expected content' do
      processor.call

      expect(File).to exist(output_file)

      result_data = CSV.read(output_file, headers: true)
      expect(result_data.headers).to eq(['Sample Number', 'Oxidation', 'Nitration'])
      expect(result_data[0].to_h).to eq({ 'Sample Number' => '12345', 'Oxidation' => '5', 'Nitration' => '3' })
      expect(result_data[1].to_h).to eq({ 'Sample Number' => '67890', 'Oxidation' => '7', 'Nitration' => '6' })
    end
  end
end
