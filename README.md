Тестовое задание:
 
С прибора поступил текстовый файл (в приложении), из него надо взять :
номер образца, это столбец «Samples»
оксидирование: «Oxidation»
нитрование: «Nitration»
 
оксидирование и нитрование надо умножить на 100 и округлить до целого
 
вывести результат в отдельный csv файл вида:
 
sample number, Oxidation, Nitration
sample number, Oxidation, Nitration
sample number, Oxidation, Nitration

rspec тест:
1. bundle install
2. rspec

запуск из irb:
1. require './sample_processor'
2. input_file = File.join(File.dirname(__FILE__), '13-57-08 11-40-17 2s140519.csv')
3. processor = SampleProcessor.new(input_file)
4. processor.call
