require 'open-uri'
require 'pdf-reader'
require 'byebug'
require 'csv'

module CsvService
  def self.convert_to_csv(file)
    io = open(file)
    reader = PDF::Reader.new(io)

    first_page = reader.pages.first

    text = first_page.text.upcase
    raw_content = first_page.raw_content
    n_text = text.split

    init_index = 0
    end_index = 0
    n_text.each_with_index do |word, index|
      if word == 'EMITIDA'
        phrase = n_text[index..(index + 3)].join(' ')
        init_index = index + 3
        break
      end
    end

    n_text.each_with_index do |word, index|
      if word == 'CONT'
        phrase = n_text[index..(index + 3)].join(' ')
        if phrase == 'CONT ILUMIN PUBLICA MUNICIPIO'
          end_index = index - 1
          break
        end
      end
    end

    table = n_text[init_index..end_index]
    header = table.shift(14)

    regex = /( KWH )|( KW )/

    ref = 0
    data = []
    table.each_with_index do |word, index|
      if word == 'KWH' || word == 'KW'
        product_description = table[ref..(index - 1)].join(' ')
        un = word
        billed_quantities = table[index + 1]
        unity_value = table[index + 2]
        total_value = table[index + 3]
        base_calculus = table[index + 4]
        icms = table[index + 5]
        ref = index + 6

        object = {
          product_description: product_description,
          un: un,
          billed_quantities: billed_quantities,
          unity_value: unity_value,
          total_value: total_value,
          base_calculus: base_calculus,
          icms: icms
        }
        data.push(object)
      end
    end

    CSV.generate do |csv|
      csv << ['DESCRIÇÃO DO PRODUTO', 'UNIDADE', 'GRANDEZAS FATURADAS', 'VALOR UNITÁRIO', 'VALOR TOTAL', 'BASE DE CÁLCULO', 'ALIQUOTA ICSM']
      data.each do |item|
        csv <<  [
          item[:product_description],
          item[:un],
          item[:billed_quantities],
          item[:unity_value],
          item[:total_value],
          item[:base_calculus],
          item[:icms]
        ]
      end
    end
  end
end
